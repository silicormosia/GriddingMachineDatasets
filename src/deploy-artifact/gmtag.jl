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
