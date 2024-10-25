# This script is meant to port all the old GriddingMachine artifacts to the new Artifacts.yaml database
# Later, the GriddingMachine will be refactored to use the new Artifacts.yaml database
# Thse datasets may need to be reprocessed, but at the momment, we neglect this
old_database = GMD.read_toml("Artifacts.toml");;
new_database = OrderedDict{String,Any}();
for (k,item) in old_database
    key = k;
    sha = item["git-tree-sha1"];
    new_item = OrderedDict{String,Any}("FOLDER" => "OLD_DATABASE", "SHA" => sha);
    new_database[key] = new_item;
end

yaml_database = GMD.read_yaml("../../Artifacts.yaml");
yaml_keys = [k for k in keys(yaml_database)];
for (k,item) in new_database
    if !(k in yaml_keys)
        yaml_database[k] = item;
    else
        @warn "Key $k already exists in the database";
    end;
end;
sort!(yaml_database);
GMD.save_yaml!("../../Artifacts2.yaml", yaml_database);
