#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add function to generate the GriddingMachine tag
#
#######################################################################################################################################################################################################
"""

    griddingmachine_tag(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int)
    griddingmachine_tag(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Nothing)

Generate the GriddingMachine tag, given
- `config` the configuration dictionary
- `year` the year to save (only for duplicated tasks)

"""
function griddingmachine_tag end;

griddingmachine_tag(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int) = (
    tag = config["GRIDDINGMACHINE"]["TAG"];

    if tag == ""
        return "$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv)"
    else
        return "$(tag)_$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv)"
    end;
);

griddingmachine_tag(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Nothing) = (
    tag = config["GRIDDINGMACHINE"]["TAG"];

    if tag == ""
        return "$(prefix)_$(nx)X_$(mt)_$(vv)"
    else
        return "$(tag)_$(prefix)_$(nx)X_$(mt)_$(vv)"
    end;
);


# short cut functions
original_folder_path(config::OrderedDict) = joinpath(GRIDDING_MACHINE_HOME, "original", config["FOLDER"]["ORIGINAL"]);
reprocessed_folder_path(config::OrderedDict) = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER"]["REPROCESSED"]);
tarball_folder_path(config::OrderedDict) = joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER"]["TARBALL"]);

original_file_path(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int) = joinpath(original_folder_path(config), "$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv).nc");
original_file_path(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Nothing) = joinpath(original_folder_path(config), "$(prefix)_$(nx)X_$(mt)_$(vv).nc");

reprocessed_file_path(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}) =
    joinpath(reprocessed_folder_path(config), "$(griddingmachine_tag(config, prefix, nx, mt, vv, yyyy)).nc");

tarball_file_path(config::OrderedDict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}) =
    joinpath(tarball_folder_path(config), "$(griddingmachine_tag(config, prefix, nx, mt, vv, yyyy)).tar.gz");
