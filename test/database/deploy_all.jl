import GriddingMachineDatasets as GMD


# loop through the YAML files in the folder yaml
yaml_folder = joinpath(@__DIR__, "../..", "yaml");
yaml_files = readdir(yaml_folder);

for yaml_file in yaml_files
    GMD.process_dataset!(joinpath(yaml_folder, yaml_file));
    GMD.deploy_datasets!(joinpath(yaml_folder, yaml_file));
end;
