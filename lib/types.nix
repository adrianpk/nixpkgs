# Definitions related to run-time type checking.  Used in particular
# to type-check NixOS configurations.

with import ./lists.nix;
with import ./attrsets.nix;
with import ./options.nix;
with import ./trivial.nix;
with import ./strings.nix;

let
  inherit (import ./modules.nix) mergeDefinitions evalModules;

  innerMerge = loc: type: defs: let
    inherit (mergeDefinitions loc type defs) mergedValue defsFinal;
  in if defsFinal == [] then {} else { value = mergedValue; };
in rec {

  isType = type: x: (x._type or "") == type;

  setType = typeName: value: value // {
    _type = typeName;
  };


  isOptionType = isType "option-type";
  mkOptionType =
    { # Human-readable representation of the type.
      name
    , # Function applied to each definition that should return true if
      # its type-correct, false otherwise.
      check ? (x: true)
    , # Merge a list of definitions together into a single value.
      # This function is called with two arguments: the location of
      # the option in the configuration as a list of strings
      # (e.g. ["boot" "loader "grub" "enable"]), and a list of
      # definition values and locations (e.g. [ { file = "/foo.nix";
      # value = 1; } { file = "/bar.nix"; value = 2 } ]).
      merge ? mergeDefaultOption
    , # Return a flat list of sub-options.  Used to generate
      # documentation.
      getSubOptions ? prefix: {}
    , # A mappable type can handle mkMap defs when merging
      mappable ? false
    }:
    { _type = "option-type";
      inherit name check merge getSubOptions mappable;
    };


  types = rec {

    unspecified = mkOptionType {
      name = "unspecified";
    };

    bool = mkOptionType {
      name = "boolean";
      check = isBool;
      merge = loc: fold (x: y: x.value || y) false;
    };

    int = mkOptionType {
      name = "integer";
      check = isInt;
      merge = mergeOneOption;
    };

    str = mkOptionType {
      name = "string";
      check = isString;
      merge = mergeOneOption;
    };

    # Merge multiple definitions by concatenating them (with the given
    # separator between the values).
    separatedString = sep: mkOptionType {
      name = "string";
      check = isString;
      merge = loc: defs: concatStringsSep sep (getValues defs);
    };

    lines = separatedString "\n";
    commas = separatedString ",";
    envVar = separatedString ":";

    # Deprecated; should not be used because it quietly concatenates
    # strings, which is usually not what you want.
    string = separatedString "";

    attrs = mkOptionType {
      name = "attribute set";
      check = isAttrs;
      merge = loc: fold (def: mergeAttrs def.value) {};
    };

    # derivation is a reserved keyword.
    package = mkOptionType {
      name = "derivation";
      check = isDerivation;
      merge = mergeOneOption;
    };

    path = mkOptionType {
      name = "path";
      # Hacky: there is no ‘isPath’ primop.
      check = x: builtins.unsafeDiscardStringContext (builtins.substring 0 1 (toString x)) == "/";
      merge = mergeOneOption;
    };

    # drop this in the future:
    list = builtins.trace "`types.list' is deprecated; use `types.listOf' instead" types.listOf;

    listOf = elemType: mkOptionType {
      name = "list of ${elemType.name}s";
      check = isList;
      merge = loc: defs:
        let
          nonMaps = filter (d: d.value._type or "" != "map") defs;
          maps = filter (d: d.value._type or "" == "map") defs;
          mapResults = fold (m: imap (x: l: imap (y: l: l ++ [ {
            inherit (m) file;
            value = m.value.f x y;
          } ]) l))
            (map (d: map (x: []) d.value) nonMaps) maps;
        in map (getAttr "value") (filter (hasAttr "value") (
          concatLists (imap (n: def: imap (m: def':
            innerMerge (loc ++ ["[${toString n}-${toString m}]"]) elemType
              ([{ inherit (def) file; value = def'; }] ++ elemAt (elemAt mapResults (n - 1)) (m - 1))
          ) def.value) nonMaps)
        ));
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["*"]);
      mappable = true;
    };

    attrsOf = elemType: mkOptionType {
      name = "attribute set of ${elemType.name}s";
      check = isAttrs;
      merge = loc: defs:
        let
          nonMaps = filter (d: d.value._type or "" != "map") defs;
          maps = filter (d: d.value._type or "" == "map") defs;
          names = concatMap (d: attrNames d.value) nonMaps;
          mapResults = listToAttrs (map (name: {
            inherit name;
            value = map (m: { inherit (m) file; value = m.value.f name; }) maps;
          }) names);
        in mapAttrs (n: getAttr "value") (filterAttrs (n: hasAttr "value") (
          zipAttrsWith (name: defs:
            innerMerge (loc ++ [name]) elemType (defs ++ getAttr name mapResults)
          )
            # Push down position info.
            (map (def: listToAttrs (mapAttrsToList (n: def':
              { name = n; value = { inherit (def) file; value = def'; }; }) def.value)) nonMaps)
        ));
      getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name>"]);
      mappable = true;
    };

    # List or attribute set of ...
    loaOf = elemType:
      let
        convertIfList = defIdx: def:
          if isList def.value then
            { inherit (def) file;
              value = listToAttrs (
                imap (elemIdx: elem:
                  { name = elem.name or "unnamed-${toString defIdx}.${toString elemIdx}";
                    value = elem;
                  }) def.value);
            }
          else
            def;
        listOnly = listOf elemType;
        attrOnly = attrsOf elemType;
      in mkOptionType {
        name = "list or attribute set of ${elemType.name}s";
        check = x: isList x || isAttrs x;
        merge = loc: defs: attrOnly.merge loc (imap convertIfList defs);
        getSubOptions = prefix: elemType.getSubOptions (prefix ++ ["<name?>"]);
        # maps over the post-convertifList defs
        mappable = true;
      };

    uniq = elemType: mkOptionType {
      inherit (elemType) name check;
      merge = mergeOneOption;
      getSubOptions = elemType.getSubOptions;
    };

    nullOr = elemType: mkOptionType {
      name = "null or ${elemType.name}";
      check = x: builtins.isNull x || elemType.check x;
      merge = loc: defs:
        let nrNulls = count (def: isNull def.value) defs; in
        if nrNulls == length defs then null
        else if nrNulls != 0 then
          throw "The option `${showOption loc}' is defined both null and not null, in ${showFiles (getFiles defs)}."
        else elemType.merge loc defs;
      getSubOptions = elemType.getSubOptions;
    };

    functionTo = elemType: mkOptionType {
      name = "function that evaluates to a(n) ${elemType.name}";
      check = isFunction;
      merge = loc: defs: fnArgs:
        (innerMerge loc elemType (map (fn:
          { inherit (fn) file; value = fn.value fnArgs; }
        ) defs)).value or (throw
          "The option `${showOption loc}' is defined as a function that doesn't return any value (using mkIf or mkMerge), in ${showFiles (getFiles defs)}");
      getSubOptions = elemType.getSubOptions;
    };

    submodule = opts:
      let
        opts' = toList opts;
      in
      mkOptionType rec {
        name = "submodule";
        check = x: isAttrs x || isFunction x;
        merge = loc: defs:
          let
            coerce = def: if isFunction def then def else { config = def; };
            modules = opts' ++ map (def: { _file = def.file; imports = [(coerce def.value)]; }) defs;
          in (evalModules { inherit modules; args.name = last loc; prefix = loc; }).config;
        getSubOptions = prefix: (evalModules
          { modules = opts'; inherit prefix;
            # FIXME: hack to get shit to evaluate.
            args = { name = ""; }; }).options;
      };

    # Obsolete alternative to configOf.  It takes its option
    # declarations from the ‘options’ attribute of containing option
    # declaration.
    optionSet = mkOptionType {
      name = /* builtins.trace "types.optionSet is deprecated; use types.submodule instead" */ "option set";
    };

    # Augment the given type with an additional type check function.
    addCheck = elemType: check: elemType // { check = x: elemType.check x && check x; };

  };

}
