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

deploy_datasets!(config::OrderedDict) = (
    # load the Artifacts.yaml file
    database_file = joinpath(@__DIR__, "../../Artifacts.yaml");
    database = read_yaml(database_file);
    if isnothing(database)
        database = OrderedDict{String,Any}();
    end;
    existing_artifacts = [k for k in keys(database)];

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
    database_changed = false;
    for prefix in prefixs, nx in nxs, mt in mts, vv in vvs
        if isnothing(yyyy)
            art = create_artifact!(config, prefix, nx, mt, vv, nothing);
            if !isnothing(art)
                database_changed = true;
                push!(database, art[1] => art[2]);
                push!(existing_artifacts, art[1]);
            end;
        else
            for year in yyyy
                art = create_artifact!(config, prefix, nx, mt, vv, year);
                if !isnothing(art)
                    database_changed = true;
                    push!(database, art[1] => art[2]);
                    push!(existing_artifacts, art[1]);
                end;
            end;
        end;
    end;

    # write the database back to the Artifacts.yaml file
    #database_changed ? save_yaml!(database_file, database) : nothing;
    if database_changed
        sort!(database);
        save_yaml!(database_file, database);
    end;

    return nothing
);
