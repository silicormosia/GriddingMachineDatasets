#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add pipeline function to process the entire dataset (read, verify, save)
#     2024-Oct-24: Make sure the path exists before saving the reprocessed data
#     2024-Oct-24: Skip the process if the reprocessed file exists
#     2024-Oct-24: Use loop file method to loop through all the different configurations
#
#######################################################################################################################################################################################################
"""

    process_dataset!(yaml_file::String)

Process the entire dataset (read, verify, save), given
- `yaml_file` the path to the YAML file

"""
function process_dataset! end;

process_dataset!(yaml_file::String) = process_dataset!(read_yaml(yaml_file));

process_dataset!(config::OrderedDict) = (
    # make sure the path exists
    mkpath(reprocessed_folder_path(config));

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
            process_dataset!(config, prefix, nx, mt, vv, nothing);
        else
            for year in yyyy
                process_dataset!(config, prefix, nx, mt, vv, year);
            end;
        end;
    end;

    return nothing
);

process_dataset!(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}) = (
    # make sure the output file does not exist. If exists, skip the process
    output_file = reprocessed_file_path(config, prefix, nx, mt, vv, yyyy);

    if isfile(output_file)
        return nothing
    end;

    # show the progress
    @info "Processing file $(output_file)";

    # read the data
    data = read_input(config, prefix, nx, mt, vv, yyyy; data_or_std = "data");
    if !isnothing(data)
        if verify_data(data, config["DATA"])
            save_input!(config, data, output_file; data_or_std = "data");
        else
            return error("Data verification failed, please check the data and configuration!");
        end;
    end;

    # read the std
    std = read_input(config, prefix, nx, mt, vv, yyyy; data_or_std = "std");
    if !isnothing(std)
        if verify_data(std, config["STD"])
            save_input!(config, data, output_file; data_or_std = "std");
        else
            return error("STD verification failed, please check the data and configuration!");
        end;
    end;

    return nothing
);
