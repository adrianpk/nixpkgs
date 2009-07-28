# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with { inherit (builtins) head tail; };
with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;
with import ./properties.nix;
with import ./modules.nix;

rec {

  inherit (lib) typeOf;
  

  isOption = attrs: (typeOf attrs) == "option";
  mkOption = attrs: attrs // {
    _type = "option";
    # name (this is the name of the attributem it is automatically generated by the traversal)
    # default (value used when no definition exists)
    # example (documentation)
    # description (documentation)
    # type (option type, provide a default merge function and ensure type correctness)
    # merge (function used to merge definitions into one definition: [ /type/ ] -> /type/)
    # apply (convert the option value to ease the manipulation of the option result)
    # options (set of sub-options declarations & definitions)
  };

  # Make the option declaration more user-friendly by adding default
  # settings and some verifications based on the declaration content (like
  # type correctness).
  addOptionMakeUp = {name, recurseInto}: decl:
    let
      init = {
        inherit name;
        merge = mergeDefaultOption;
        apply = lib.id;
      };

      mergeFromType = opt:
        if decl ? type && decl.type ? merge then
          opt // { merge = decl.type.merge; }
        else
          opt;

      addDeclaration = opt: opt // decl;

      ensureMergeInputType = opt:
        if decl ? type then
          opt // {
            merge = list:
              if all decl.type.check list then
                opt.merge list
              else
                throw "One of the definitions has a bad type.";
          }
        else opt;

      ensureDefaultType = opt:
        if decl ? type && decl ? default then
          opt // {
            default =
              if decl.type.check decl.default then
                decl.default
              else
                throw "The default value has a bad type.";
          }
        else opt;

      handleOptionSets = opt:
        if decl ? type && decl.type.hasOptions then
          let
            optionConfig = opts: config:
               map (f: applyIfFunction f config)
                 (decl.options ++ [opts]);
          in
            opt // {
              merge = list:
                decl.type.iter
                  (path: opts:
                     lib.fix (fixableMergeFun (recurseInto path) (optionConfig opts))
                  )
                  opt.name
                  (opt.merge list);
              options = recurseInto (decl.type.docPath opt.name) decl.options;
            }
        else
          opt;
    in
      foldl (opt: f: f opt) init [
        # default settings
        mergeFromType

        # user settings
        addDeclaration

        # override settings
        ensureMergeInputType
        ensureDefaultType
        handleOptionSets
      ];

  # Merge a list of options containning different field.  This is useful to
  # separate the merge & apply fields from the interface.
  mergeOptionDecls = opts:
    if opts == [] then {}
    else if tail opts == [] then
      let opt = head opts; in
      if opt ? options then
        opt // { options = toList opt.options; }
      else
        opt
    else
      fold (opt1: opt2:
        lib.addErrorContext "opt1 = ${lib.showVal opt1}\nopt2 = ${lib.showVal opt2}" (
        # You cannot merge if two options have the same field.
        assert opt1 ? default -> ! opt2 ? default;
        assert opt1 ? example -> ! opt2 ? example;
        assert opt1 ? description -> ! opt2 ? description;
        assert opt1 ? merge -> ! opt2 ? merge;
        assert opt1 ? apply -> ! opt2 ? apply;
        assert opt1 ? type -> ! opt2 ? type;
        if opt1 ? options || opt2 ? options then
          opt1 // opt2 // {
            options =
               (toList (attrByPath ["options"] [] opt1))
            ++ (toList (attrByPath ["options"] [] opt2));
          }
        else
          opt1 // opt2
      )) {} opts;

  
  # !!! This function will be removed because this can be done with the
  # multiple option declarations.
  addDefaultOptionValues = defs: opts: opts //
    builtins.listToAttrs (map (defName:
      { name = defName;
        value = 
          let
            defValue = builtins.getAttr defName defs;
            optValue = builtins.getAttr defName opts;
          in
          if typeOf defValue == "option"
          then
            # `defValue' is an option.
            if hasAttr defName opts
            then builtins.getAttr defName opts
            else defValue.default
          else
            # `defValue' is an attribute set containing options.
            # So recurse.
            if hasAttr defName opts && isAttrs optValue 
            then addDefaultOptionValues defValue optValue
            else addDefaultOptionValues defValue {};
      }
    ) (attrNames defs));

  mergeDefaultOption = list:
    if list != [] && tail list == [] then head list
    else if all builtins.isFunction list then x: mergeDefaultOption (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then fold lib.mergeAttrs {} list
    else if all (x: true == x || false == x) list then fold lib.or false list
    else if all (x: x == toString x) list then lib.concatStrings list
    else throw "Cannot merge values.";

  mergeTypedOption = typeName: predicate: merge: list:
    if all predicate list then merge list
    else throw "Expect a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold lib.or false);

  mergeListOption = mergeTypedOption "list" isList concatLists;

  mergeStringOption = mergeTypedOption "string"
    (x: if builtins ? isString then builtins.isString x else x + "")
    lib.concatStrings;

  mergeOneOption = list:
    if list == [] then abort "This case should never happen."
    else if tail list != [] then throw "Multiple definitions. Only one is allowed for this option."
    else head list;


  # Handle the traversal of option sets.  All sets inside 'opts' are zipped
  # and options declaration and definition are separated.  If no option are
  # declared at a specific depth, then the function recurse into the values.
  # Other cases are handled by the optionHandler which contains two
  # functions that are used to defined your goal.
  # - export is a function which takes two arguments which are the option
  # and the list of values.
  # - notHandle is a function which takes the list of values are not handle
  # by this function.
  handleOptionSets = optionHandler@{export, notHandle, ...}: path: opts:
    if all isAttrs opts then
      lib.zip (attr: opts:
        let
          recurseInto = name: attrs:
            handleOptionSets optionHandler name attrs;

          # Compute the path to reach the attribute.
          name = if path == "" then attr else path + "." + attr;

          # Divide the definitions of the attribute "attr" between
          # declaration (isOption) and definitions (!isOption).
          test = partition (x: isOption (rmProperties x)) opts;
          decls = map rmProperties test.right; defs = test.wrong;

          # Make the option declaration more user-friendly by adding default
          # settings and some verifications based on the declaration content
          # (like type correctness).
          opt = addOptionMakeUp
            { inherit name recurseInto; }
            (mergeOptionDecls decls);

          # Return the list of option sets.
          optAttrs = map delayProperties defs;

          # return the list of option values.
          # Remove undefined values that are coming from evalIf.
          optValues = evalProperties defs;
        in
          if decls == [] then recurseInto name optAttrs
          else lib.addErrorContext "while evaluating the option ${name}:" (
            export opt optValues
          )
      ) opts
   else lib.addErrorContext "while evaluating ${path}:" (notHandle opts);

  # Merge option sets and produce a set of values which is the merging of
  # all options declare and defined.  If no values are defined for an
  # option, then the default value is used otherwise it use the merge
  # function of each option to get the result.
  mergeOptionSets =
    handleOptionSets {
      export = opt: values:
        opt.apply (
          if values == [] then
            if opt ? default then opt.default
            else throw "Not defined."
          else opt.merge values
        );
      notHandle = opts: throw "Used without option declaration.";
    };

  # Keep all option declarations.
  filterOptionSets =
    handleOptionSets {
      export = opt: values: opt;
      notHandle = opts: {};
    };


  fixableMergeFun = merge: f: config:
    merge (
      # remove require because this is not an option.
      map (m: removeAttrs m ["require"]) (
        # Delay top-level properties like mkIf
        map delayProperties (
          # generate the list of option sets.
          f config
        )
      )
    );

  fixableMergeModules = merge: initModules: {...}@args: config:
    fixableMergeFun merge (config:
      # filter the list of option sets.
      selectDeclsAndDefs (
        # generate the list of modules from a closure of imports/require
        # attribtues.
        moduleClosure initModules (args // { inherit config; })
      )
    ) config;


  fixableDefinitionsOf = initModules: {...}@args:
    fixableMergeModules (mergeOptionSets "") initModules args;

  fixableDeclarationsOf = initModules: {...}@args:
    fixableMergeModules (filterOptionSets "") initModules args;

  definitionsOf = initModules: {...}@args:
    lib.fix (fixableDefinitionsOf initModules args);

  declarationsOf = initModules: {...}@args:
    lib.fix (fixableDeclarationsOf initModules args);


  fixMergeModules = merge: initModules: {...}@args:
    lib.fix (fixableMergeModules merge initModules args);


  # old interface.
  fixOptionSetsFun = merge: {...}@args: initModules: config:
    fixableMergeModules (merge "") initModules args config;

  fixOptionSets = merge: args: initModules:
    fixMergeModules (merge "") initModules args;


  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = ignore: newOptionAttrSetToDocList;
  newOptionAttrSetToDocList = attrs:
    let options = collect isOption attrs; in
      fold (opt: rest:
        let
          docOption = {
            inherit (opt) name;
            description = if opt ? description then opt.description else
              throw "Option ${opt.name}: No description.";
          }
          // (if opt ? example then {inherit(opt) example;} else {})
          // (if opt ? default then {inherit(opt) default;} else {});

          subOptions =
            if opt ? options then
              newOptionAttrSetToDocList opt.options
            else
              [];
        in
          [ docOption ] ++ subOptions ++ rest
      ) [] options;


}
