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
    rev_tag = haskey(config["GRIDDINGMACHINE"], "REVISION") ? config["GRIDDINGMACHINE"]["REVISION"] : "";
    rev_naming = rev_tag == "" ? "" : "_$(rev_tag)";

    gmtag = if tag == ""
        uppercase("$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv)$(rev_naming)")
    elseif occursin(prefix, tag)
        uppercase("$(tag)_$(nx)X_$(mt)_$(yyyy)_$(vv)$(rev_naming)")
    else
        uppercase("$(tag)_$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv)$(rev_naming)")
    end;

    return gmtag
);

griddingmachine_tag(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, ::Nothing) = (
    tag = config["GRIDDINGMACHINE"]["TAG"];
    rev_tag = haskey(config["GRIDDINGMACHINE"], "REVISION") ? config["GRIDDINGMACHINE"]["REVISION"] : "";
    rev_naming = rev_tag == "" ? "" : "_$(rev_tag)";

    gmtag = if tag == ""
        uppercase("$(prefix)_$(nx)X_$(mt)_$(vv)$(rev_naming)")
    elseif occursin(prefix, tag)
        uppercase("$(tag)_$(nx)X_$(mt)_$(vv)$(rev_naming)")
    else
        uppercase("$(tag)_$(prefix)_$(nx)X_$(mt)_$(vv)$(rev_naming)")
    end;

    return gmtag
);


# short cut functions
original_folder(config::Union{Dict, OrderedDict}) = joinpath(GRIDDING_MACHINE_HOME, "original", config["FOLDER"]["ORIGINAL"]);
original_file(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Int) = joinpath(original_folder(config), "$(prefix)_$(nx)X_$(mt)_$(yyyy)_$(vv).nc");
original_file(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, ::Nothing) = joinpath(original_folder(config), "$(prefix)_$(nx)X_$(mt)_$(vv).nc");

reprocessed_folder(config::Union{Dict, OrderedDict}) = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER"]["REPROCESSED"]);
reprocessed_file(config::Union{Dict, OrderedDict}, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}) = (
    gmtag = griddingmachine_tag(config, prefix, nx, mt, vv, yyyy);

    # make sure the tag does not exist in current Artifacts.YANL file
    current_library = read_library("$(@__DIR__)/../../Artifacts.yaml");
    current_tags = keys(current_library);
    @assert !(gmtag in current_tags) "GriddingMachine tag $gmtag already exists!";

    return joinpath(reprocessed_folder(config), "$(gmtag).nc")
);
