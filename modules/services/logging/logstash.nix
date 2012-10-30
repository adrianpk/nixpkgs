{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.logstash;

  listToConfig = list: "[ " + (concatStringsSep ", " (map exprToConfig list)) + " ]";

  hashToConfig = attrs:
    let
      attrNameToConfigList = name:
        [ (exprToConfig name)  (exprToConfig (getAttr name attrs)) ];
    in
      "[ " +
      (concatStringsSep ", " (map attrNameToConfigList (attrNames attrs))) +
      " ]";

  valueToConfig = nvpair: let name = nvpair.name; value = nvpair.value; in
    if (isAttrs value) && ((!(value ? __type)) || value.__type == "repeated")
      then ''
        ${name} {
          ${exprToConfig value}
        }
      ''
      else "${name} => ${exprToConfig value}";

  repeatedAttrsToConfig = values:
      concatStringsSep "\n" (map valueToConfig values);

  attrsToConfig = attrs:
    let
      attrToConfig = name: valueToConfig {
        inherit name;
        value = (getAttr name attrs);
      };
    in
      concatStringsSep "\n" (map attrToConfig (attrNames attrs));

  exprToConfig = expr:
    let
      isCustomType = expr: (isAttrs expr) && (expr ? __type);

      isFloat = expr: (isCustomType expr) && (expr.__type == "float");

      isHash = expr: (isCustomType expr) && (expr.__type == "hash");

      isRepeatedAttrs = expr: (isCustomType expr) && (expr.__type == "repeated");
    in
      if builtins.isBool expr then (if expr then "true" else "false") else
      if builtins.isString expr then ''"${expr}"'' else
      if builtins.isInt expr then toString expr else
      if isFloat expr then expr.value else
      if isList expr then listToConfig expr else
      if isHash expr then hashToConfig expr.value else
      if isRepeatedAttrs expr then repeatedAttrsToConfig expr.values
      else attrsToConfig expr;

  mergeConfigs = configs:
    let
      op = attrs: newAttrs:
        let
          isRepeated = newAttrs ? __type && newAttrs.__type == "repeated";
        in {
            values = attrs.values ++ (if isRepeated then newAttrs.values else
              map (name: { inherit name; value = getAttr name newAttrs; })
              (attrNames newAttrs));
          };
    in (foldl op { values = []; } configs) // { __type = "repeated"; };

in

{
  ###### interface

  options = {
    services.logstash = {
      enable = mkOption {
        default = false;
        description = ''
          Enable logstash.
        '';
      };

      inputConfig = mkOption {
        default = {};
        description = ''
          An attribute set (or an expression generated by mkNameValuePairs)
          representing a logstash configuration's input section.
          Logstash configs are name-value pairs, where values can be bools,
          strings, numbers, arrays, hashes, or other name-value pairs,
          and names are strings that can be repeated. Name-value pairs with no
          repeats are represented by attr sets. Bools, strings, ints, and
          arrays are mapped directly. Name-value pairs with repeats can be
          generated by the config.lib.logstash.mkNameValuePairs function, which
          takes a list of attrsets and combines them while preserving attribute
          name duplicates if they occur. Similarly, there are the mkFloat and
          mkHash functions, which take a string representation of a float and an
          attrset, respectively.
        '';
        merge = mergeConfigs;
      };

      filterConfig = mkOption {
        default = {};
        description = ''
          An attribute set (or an expression generated by mkNameValuePairs)
          representing a logstash configuration's filter section.
          See inputConfig description for details.
        '';
        merge = mergeConfigs;
      };

      outputConfig = mkOption {
        default = {};
        description = ''
          An attribute set (or an expression generated by mkNameValuePairs)
          representing a logstash configuration's output section.
          See inputConfig description for details.
        '';
        merge = mergeConfigs;
      };
    };
  };


  ###### implementation

  config = mkMerge [ {
    lib.logstash = {
      mkFloat = stringRep: { __type = "float"; value = stringRep; };

      mkHash = attrs: { __type = "hash"; value = attrs; };

      mkNameValuePairs = mergeConfigs;
    };
  } ( mkIf cfg.enable {
    jobs.logstash = with pkgs; {
      description = "Logstash daemon";
      startOn = "started networking and filesystem";

      path = [ jre ];

      script = "cd /tmp && exec java -jar ${logstash} agent -f ${writeText "logstash.conf" ''
        input {
          ${exprToConfig cfg.inputConfig}
        }

        filter {
          ${exprToConfig cfg.filterConfig}
        }

        output {
          ${exprToConfig cfg.outputConfig}
        }
      ''}";
    };
  })];
}
