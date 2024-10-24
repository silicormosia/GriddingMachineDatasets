#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add pipeline function to deploy the datasets
#     2024-Oct-24: Use loop file method to loop through all the different configurations
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
    mkpath(joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER"]["TARBALL"]));

    # read the FILE configurations
    dict_file = config["FILE"];
    prefixs = dict_file["PREFIX"];
    nxs = dict_file["NX"];
    mts = dict_file["MT"];
    vvs = dict_file["VV"];
    yyyy = haskey(dict_file, "YYYY") ? dict_file["YYYY"] : nothing;

    # loop through the files and process each file
    for prefix in prefixs, nx in nxs, mt in mts, vv in vvs
        if isnothing(yyyy)
            create_artifact!(config, prefix, nx, mt, vv, nothing);
        else
            for year in yyyy
                create_artifact!(config, prefix, nx, mt, vv, year);
            end;
        end;
    end;

    return nothing
);
