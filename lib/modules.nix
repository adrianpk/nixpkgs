with import ./.. {};
with lib;

rec {

  /* Evaluate a set of modules.  The result is a set of two
     attributes: ‘options’: the nested set of all option declarations,
     and ‘config’: the nested set of all option values. */
  evalModules = { modules, prefix ? [], args ? {}, check ? true }:
    let
      args' = args // result;
      closed = closeModules modules args';
      # Note: the list of modules is reversed to maintain backward
      # compatibility with the old module system.  Not sure if this is
      # the most sensible policy.
      options = mergeModules check prefix (reverseList closed);
      config = yieldConfig options;
      yieldConfig = mapAttrs (n: v: if isOption v then v.value else yieldConfig v);
      result = { inherit options config; };
    in result;

  /* Close a set of modules under the ‘imports’ relation. */
  closeModules = modules: args:
    let
      toClosureList = file: parentKey: imap (n: x:
        if isAttrs x || builtins.isFunction x then
          unifyModuleSyntax file "${parentKey}:anon-${toString n}" (applyIfFunction x args)
        else
          unifyModuleSyntax (toString x) (toString x) (applyIfFunction (import x) args));
    in
      builtins.genericClosure {
        startSet = toClosureList unknownModule "" modules;
        operator = m: toClosureList m.file m.key m.imports;
      };

  /* Massage a module into canonical form, that is, a set consisting
     of ‘options’, ‘config’ and ‘imports’ attributes. */
  unifyModuleSyntax = file: key: m:
    if m ? config || m ? options || m ? imports then
      let badAttrs = removeAttrs m ["imports" "options" "config" "key"]; in
      if badAttrs != {} then
        throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. ${builtins.toXML m} "
      else
        { inherit file;
          key = m.key or key;
          imports = m.imports or [];
          options = m.options or {};
          config = m.config or {};
        }
    else
      { inherit file;
        key = m.key or key;
        imports = m.require or [];
        options = {};
        config = removeAttrs m ["key" "require"];
      };

  applyIfFunction = f: arg: if builtins.isFunction f then f arg else f;

  /* Merge a list of modules.  This will recurse over the option
     declarations in all modules, combining them into a single set.
     At the same time, for each option declaration, it will merge the
     corresponding option definitions in all machines, returning them
     in the ‘value’ attribute of each option. */
  mergeModules = check: prefix: modules:
    mergeModules' check prefix modules
      (concatMap (m: map (config: { inherit (m) file; inherit config; }) (pushDownProperties m.config)) modules);

  mergeModules' = check: prefix: options: configs:
    let
      declaredNames = concatMap (m: attrNames m.options) options;
      declaredNames' = listToAttrs (map (n: { name = n; value = 1; }) declaredNames);
      checkDefinedNames = res: fold (m: res: fold (n: res:
          if hasAttr n declaredNames' then res else
            throw "The option `${showOption (prefix ++ [n])}' defined in `${m.file}' does not exist."
        ) res (attrNames m.config)) res configs;
    in (if check then checkDefinedNames else id) (listToAttrs (map (name: {
      # We're descending into attribute ‘name’.
      inherit name;
      value =
        let
          loc = prefix ++ [name];
          # Get all submodules that declare ‘name’.
          decls = concatLists (map (m:
            if hasAttr name m.options
              then [ { inherit (m) file; options = getAttr name m.options; } ]
              else []
            ) options);
          # Get all submodules that define ‘name’.
          defns = concatLists (map (m:
            if hasAttr name m.config
              then map (config: { inherit (m) file; inherit config; })
                (pushDownProperties (getAttr name m.config))
              else []
            ) configs);
          nrOptions = count (m: isOption m.options) decls;
          # Process mkMerge and mkIf properties.
          defns' = concatMap (m:
            if hasAttr name m.config
              then map (m': { inherit (m) file; value = m'; }) (dischargeProperties (getAttr name m.config))
              else []
            ) configs;
        in
          if nrOptions == length decls then
            let opt = fixupOptionType loc (mergeOptionDecls loc decls);
            in evalOptionValue loc opt defns'
          else if nrOptions != 0 then
            let
              firstOption = findFirst (m: isOption m.options) "" decls;
              firstNonOption = findFirst (m: !isOption m.options) "" decls;
            in
              throw "The option `${showOption loc}' in `${firstOption.file}' is a prefix of options in `${firstNonOption.file}'."
          else
            mergeModules' check loc decls defns;
    }) declaredNames));

  /* Merge multiple option declarations into a single declaration.  In
     general, there should be only one declaration of each option.
     The exception is the ‘options’ attribute, which specifies
     sub-options.  These can be specified multiple times to allow one
     module to add sub-options to an option declared somewhere else
     (e.g. multiple modules define sub-options for ‘fileSystems’). */
  mergeOptionDecls = loc: opts:
    fold (opt: res:
      if opt.options ? default && res ? default ||
         opt.options ? example && res ? example ||
         opt.options ? description && res ? description ||
         opt.options ? merge && res ? merge || # FIXME: remove merge
         opt.options ? apply && res ? apply ||
         opt.options ? type && res ? type
      then
        throw "The option `${showOption loc}' in `${opt.file}' is already declared in ${concatStringsSep " and " (map (d: "`${d}'") res.declarations)}."
      else
        opt.options // res //
          { declarations = [opt.file] ++ res.declarations;
            options = if opt.options ? options then [(toList opt.options.options ++ res.options)] else [];
          }
    ) { inherit loc; declarations = []; options = []; } opts;

  /* Merge all the definitions of an option to produce the final
     config value. */
  evalOptionValue = loc: opt: defs:
    let
      # Process mkOverride properties, adding in the default
      # value specified in the option declaration (if any).
      defsFinal = filterOverrides'
        ((if opt ? default then [{ file = head opt.declarations; value = mkOptionDefault opt.default; }] else []) ++ defs);
      # Type-check the remaining definitions, and merge them if
      # possible.
      merged =
        if defsFinal == [] then
          throw "The option `${showOption loc}' is used but not defined."
        else
          fold (def: res:
            if opt.type.check def.value then res
            else throw "The option value `${showOption loc}' in `${def.file}' is not a ${opt.type.name}.")
            (opt.type.merge' { prefix = loc; } (map (m: m.value) defsFinal)) defsFinal;
      # Finally, apply the ‘apply’ function to the merged
      # value.  This allows options to yield a value computed
      # from the definitions.
      value = (opt.apply or id) merged;
    in opt //
      { value = addErrorContext "while evaluating the option `${showOption loc}':" value;
        definitions = map (def: def.value) defsFinal;
        isDefined = defsFinal != [];
      };

  /* Given a config set, expand mkMerge properties, and push down the
     mkIf properties into the children.  The result is a list of
     config sets that do not have properties at top-level.  For
     example,

       mkMerge [ { boot = set1; } (mkIf cond { boot = set2; services = set3; }) ]

     is transformed into

       [ { boot = set1; } { boot = mkIf cond set2; services mkIf cond set3; } ].

     This transform is the critical step that allows mkIf conditions
     to refer to the full configuration without creating an infinite
     recursion.
  */
  pushDownProperties = cfg:
    if cfg._type or "" == "merge" then
      concatMap pushDownProperties cfg.contents
    else if cfg._type or "" == "if" then
      map (mapAttrs (n: v: mkIf cfg.condition v)) (pushDownProperties cfg.content)
    else
      # FIXME: handle mkOverride?
      [ cfg ];

  /* Given a config value, expand mkMerge properties, and discharge
     any mkIf conditions.  That is, this is the place where mkIf
     conditions are actually evaluated.  The result is a list of
     config values.  For example, ‘mkIf false x’ yields ‘[]’,
     ‘mkIf true x’ yields ‘[x]’, and

       mkMerge [ 1 (mkIf true 2) (mkIf true (mkIf false 3)) ]

     yields ‘[ 1 2 ]’.
  */
  dischargeProperties = def:
    if def._type or "" == "merge" then
      concatMap dischargeProperties def.contents
    else if def._type or "" == "if" then
      if def.condition then
        dischargeProperties def.content
      else
        [ ]
    else
      [ def ];

  /* Given a list of config values, process the mkOverride properties,
     that is, return the values that have the highest (that is,
     numerically lowest) priority, and strip the mkOverride
     properties.  For example,

       [ { file = "/1"; value = mkOverride 10 "a"; }
         { file = "/2"; value = mkOverride 20 "b"; }
         { file = "/3"; value = "z"; }
         { file = "/4"; value = mkOverride 10 "d"; }
       ]

     yields

       [ { file = "/1"; value = "a"; }
         { file = "/4"; value = "d"; }
       ]

     Note that "z" has the default priority 100.
  */
  filterOverrides' = defs:
    let
      defaultPrio = 100;
      getPrio = def: if def.value._type or "" == "override" then def.value.priority else defaultPrio;
      min = x: y: if x < y then x else y;
      highestPrio = fold (def: prio: min (getPrio def) prio) 9999 defs;
      strip = def: if def.value._type or "" == "override" then def // { value = def.value.content; } else def;
    in concatMap (def: if getPrio def == highestPrio then [(strip def)] else []) defs;

  /* For use in options like environment.variables. */
  filterOverrides = defs: map (def: def.value) (filterOverrides' (map (def: { value = def; }) defs));

  /* Hack for backward compatibility: convert options of type
     optionSet to configOf.  FIXME: remove eventually. */
  fixupOptionType = loc: opt:
    let
      options' = opt.options or
        (throw "Option `${showOption loc'}' has type optionSet but has no option attribute.");
      coerce = x:
        if builtins.isFunction x then x
        else { config, ... }: { options = x; };
      options = map coerce (flatten options');
      f = tp:
        if tp.name == "option set" then types.submodule options
        else if tp.name == "attribute set of option sets" then types.attrsOf (types.submodule options)
        else if tp.name == "list or attribute set of option sets" then types.loaOf (types.submodule options)
        else if tp.name == "list of option sets" then types.listOf (types.submodule options)
        else if tp.name == "null or option set" then types.nullOr (types.submodule options)
        else tp;
    in opt // { type = f (opt.type or types.unspecified); };


  /* Properties. */

  mkIf = condition: content:
    { _type = "if";
      inherit condition content;
    };

  mkAssert = assertion: message: content:
    mkIf
      (if assertion then true else throw "\nFailed assertion: ${message}")
      content;

  mkMerge = contents:
    { _type = "merge";
      inherit contents;
    };

  mkOverride = priority: content:
    { _type = "override";
      inherit priority content;
    };

  mkOptionDefault = mkOverride 1001;
  mkDefault = mkOverride 1000;
  mkForce = mkOverride 50;

  mkFixStrictness = id; # obsolete, no-op

  # FIXME: Add mkOrder back in. It's not currently used anywhere in
  # NixOS, but it should be useful.

}
