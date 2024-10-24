#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add pipeline function to deploy the datasets
#
#######################################################################################################################################################################################################
"""

    deploy_datasets!(yaml_file::String)

Deploy the datasets for GriddingMachine, given
- `yaml_file` the path to the YAML file

"""
function deploy_datasets! end;

deploy_datasets!(yaml_file::String) = deploy_datasets!(read_yaml(yaml_file));

deploy_datasets!(config::Dict) = (
    # make the path exists
    mkpath(joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER_TARBALL"]));

    # if the task is not a duplicate, process each year; otherwise, process the data
    if !config["DUPLICATED_TASK"]
        create_artifact!(config, nothing);
    end;

    # if the task is a duplicated task, loop through the years
    years = config["YEARS"];
    for year in years
        create_artifact!(config, year);
    end;

    return nothing
);
