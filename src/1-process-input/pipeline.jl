#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add pipeline function to process the entire dataset (read, verify, save)
#
#######################################################################################################################################################################################################
"""

    process_dataset!(yaml_file::String)

Process the entire dataset (read, verify, save), given
- `yaml_file` the path to the YAML file

"""
function process_dataset! end;

process_dataset!(yaml_file::String) = process_dataset!(read_yaml(yaml_file));

process_dataset!(config::Dict) = (
    # if the task is not a duplicate, process each year; otherwise, process the data
    if !config["DUPLICATED_TASK"]
        process_dataset!(config, nothing);
    end;

    # if the task is a duplicated task, loop through the years
    years = config["YEARS"];
    for year in years
        process_dataset!(config, year);
    end;

    return nothing
);

process_dataset!(config::Dict, year::Union{Int,Nothing}) = (
    # read the data
    data = isnothing(year) ? read_input(config; data_or_std = "data") : read_input(config, year; data_or_std = "data");
    if verify_data(data, config["DATA"])
        isnothing(year) ? save_input!(config, data) : save_input!(config, data, year);
    else
        return error("Data verification failed, please check the data and configuration!");
    end;

    # read the std
    std = isnothing(year) ? read_input(config; data_or_std = "std") : read_input(config, year; data_or_std = "std");
    if !isnothing(std)
        if verify_data(std, config["STD"])
            isnothing(year) ? save_input!(config, std; data_or_std = "std") : save_input!(config, std, year; data_or_std = "std");
        else
            return error("STD verification failed, please check the data and configuration!");
        end;
    end;

    return nothing
);
