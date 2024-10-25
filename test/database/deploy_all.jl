import GriddingMachineDatasets as GMD


# loop through the YAML files in the folder yaml
yaml_folder = joinpath(@__DIR__, "../..", "yaml");
yaml_files = readdir(yaml_folder);

for yaml_file in yaml_files
    GMD.process_dataset!(joinpath(yaml_folder, yaml_file));
    GMD.deploy_datasets!(joinpath(yaml_folder, yaml_file));
end;

#=

old_yaml = GMD.read_yaml("Artifacts.yaml");
new_yaml = OrderedDict{String,Any}();
for (k,item) in old_yaml
    @show k item
    new_item = OrderedDict{String,String}("FOLDER" => "GEE/MCD43A4", "SHA" => item);
    @show new_item
    new_yaml[k] = new_item;
end;
GMD.save_yaml!("Artifacts.yaml", new_yaml);

=#
