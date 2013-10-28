# Nixpkgs/NixOS option handling.

let lib = import ./default.nix; in

with import ./trivial.nix;
with import ./lists.nix;
with import ./misc.nix;
with import ./attrsets.nix;
with import ./strings.nix;

rec {

  isOption = lib.isType "option";
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

  mkEnableOption = name: mkOption {
    default = false;
    example = true;
    description = "Whether to enable ${name}.";
    type = lib.types.bool;
  };

  mergeDefaultOption = args: list:
    if length list == 1 then head list
    else if all builtins.isFunction list then x: mergeDefaultOption args (map (f: f x) list)
    else if all isList list then concatLists list
    else if all isAttrs list then fold lib.mergeAttrs {} list
    else if all builtins.isBool list then fold lib.or false list
    else if all builtins.isString list then lib.concatStrings list
    else if all builtins.isInt list && all (x: x == head list) list then head list
    else throw "Cannot merge definitions of `${showOption args.prefix}' given in ${showFiles args.files}.";

  /* Obsolete, will remove soon.  Specify an option type or apply
     function instead.  */
  mergeTypedOption = typeName: predicate: merge: args: list:
    if all predicate list then merge list
    else throw "Expect a ${typeName}.";

  mergeEnableOption = mergeTypedOption "boolean"
    (x: true == x || false == x) (fold lib.or false);

  mergeListOption = mergeTypedOption "list" isList concatLists;

  mergeStringOption = mergeTypedOption "string"
    (x: if builtins ? isString then builtins.isString x else x + "")
    lib.concatStrings;

  mergeOneOption = args: list:
    if list == [] then abort "This case should never happen."
    else if length list != 1 then
      throw "The unique option `${showOption args.prefix}' is defined multiple times, in ${showFiles args.files}."
    else head list;


  # Generate documentation template from the list of option declaration like
  # the set generated with filterOptionSets.
  optionAttrSetToDocList = optionAttrSetToDocList' [];

  optionAttrSetToDocList' = prefix: options:
    fold (opt: rest:
      let
        docOption = rec {
          name = showOption opt.loc;
          description = opt.description or (throw "Option `${name}' has no description.");
          declarations = filter (x: x != unknownModule) opt.declarations;
          internal = opt.internal or false;
          visible = opt.visible or true;
        }
        // optionalAttrs (opt ? example) { example = scrubOptionValue opt.example; }
        // optionalAttrs (opt ? default) { default = scrubOptionValue opt.default; }
        // optionalAttrs (opt ? defaultText) { default = opt.defaultText; };

        subOptions =
          let ss = opt.type.getSubOptions opt.loc;
          in if ss != {} then optionAttrSetToDocList' opt.loc ss else [];
      in
        # FIXME: expensive, O(n^2)
        [ docOption ] ++ subOptions ++ rest) [] (collect isOption options);


  /* This function recursively removes all derivation attributes from
     `x' except for the `name' attribute.  This is to make the
     generation of `options.xml' much more efficient: the XML
     representation of derivations is very large (on the order of
     megabytes) and is not actually used by the manual generator. */
  scrubOptionValue = x:
    if isDerivation x then { type = "derivation"; drvPath = x.name; outPath = x.name; name = x.name; }
    else if isList x then map scrubOptionValue x
    else if isAttrs x then mapAttrs (n: v: scrubOptionValue v) (removeAttrs x ["_args"])
    else x;


  /* For use in the ‘example’ option attribute.  It causes the given
     text to be included verbatim in documentation.  This is necessary
     for example values that are not simple values, e.g.,
     functions. */
  literalExample = text: { _type = "literalExample"; inherit text; };


  /* Helper functions. */
  showOption = concatStringsSep ".";
  showFiles = files: concatStringsSep " and " (map (f: "`${f}'") files);
  unknownModule = "<unknown-file>";

}
