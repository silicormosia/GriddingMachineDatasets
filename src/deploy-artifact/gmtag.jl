#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add function to generate the GriddingMachine tag
#
#######################################################################################################################################################################################################
"""

    griddingmachine_tag(config::Dict, year::Int)
    griddingmachine_tag(config::Dict)

Generate the GriddingMachine tag, given
- `config` the configuration dictionary
- `year` the year to save (only for duplicated tasks)

"""
function griddingmachine_tag end;

griddingmachine_tag(config::Dict, year::Int) = (
    tag = config["TAG"];
    reso_s = config["RESOLUTION_SPATIAL"];
    reso_t = config["RESOLUTION_TEMPORAL"];
    version = config["VERSION"];

    return "$(tag)_$(reso_s)X_$(reso_t)_$(year)_V$(version)"
);

griddingmachine_tag(config::Dict) = (
    tag = config["TAG"];
    reso_s = config["RESOLUTION_SPATIAL"];
    reso_t = config["RESOLUTION_TEMPORAL"];
    version = config["VERSION"];

    return "$(tag)_$(reso_s)X_$(reso_t)_V$(version)"
);


# short cut functions
original_folder_path(config::Dict) = joinpath(GRIDDING_MACHINE_HOME, "original", config["FOLDER_ORIGINAL"]);

reprocessed_file_path(config::Dict, year::Int) = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER_REPROCESSED"], "$(griddingmachine_tag(config, year)).nc");
reprocessed_file_path(config::Dict, year::Nothing) = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER_REPROCESSED"], "$(griddingmachine_tag(config)).nc");
reprocessed_folder_path(config::Dict) = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER_REPROCESSED"]);

tarball_file_path(config::Dict, year::Int) = joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER_TARBALL"], "$(griddingmachine_tag(config, year)).tar.gz");
tarball_file_path(config::Dict, year::Nothing) = joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER_TARBALL"], "$(griddingmachine_tag(config)).tar.gz");
tarball_folder_path(config::Dict) = joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER_TARBALL"]);
