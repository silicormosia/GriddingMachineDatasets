"""

    griddingmachine_tag(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int)
    griddingmachine_tag(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Nothing)

Generate the GriddingMachine tag, given
- `config` the configuration dictionary
- `year` the year to save (only for duplicated tasks)

"""
function griddingmachine_tag end;

griddingmachine_tag(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int) = (
    tag = config["GRIDDINGMACHINE"]["TAG"];

    if tag == ""
        return uppercase("$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv)")
    elseif occursin(prefix, tag)
        return uppercase("$(tag)_$(nx)X_$(mt)_$(yyyy)_$(vv)")
    else
        return uppercase("$(tag)_$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv)")
    end;
);

griddingmachine_tag(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, ::Nothing) = (
    tag = config["GRIDDINGMACHINE"]["TAG"];

    if tag == ""
        return uppercase("$(prefix)_$(nx)X_$(mt)_$(vv)")
    elseif occursin(prefix, tag)
        return uppercase("$(tag)_$(nx)X_$(mt)_$(vv)")
    else
        return uppercase("$(tag)_$(prefix)_$(nx)X_$(mt)_$(vv)")
    end;
);


# short cut functions
original_folder(config::Union{Dict, OrderedDict}) = joinpath(GRIDDING_MACHINE_HOME, "original", config["FOLDER"]["ORIGINAL"]);
original_file(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int) = joinpath(original_folder(config), "$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv).nc");
original_file(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, ::Nothing) = joinpath(original_folder(config), "$(prefix)_$(nx)X_$(mt)_$(vv).nc");

reprocessed_folder(config::Union{Dict, OrderedDict}) = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER"]["REPROCESSED"]);
reprocessed_file(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}) =
    joinpath(reprocessed_folder(config), "$(griddingmachine_tag(config, prefix, nx, mt, vv, yyyy)).nc");
