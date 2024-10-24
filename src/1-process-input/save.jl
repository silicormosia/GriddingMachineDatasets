#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-23: Add function to save the data to a netCDF file
#     2024-Oct-24: Add change logs when saving the data based on the configuration
#
#######################################################################################################################################################################################################
"""

    save_input!(config::Dict, data::Array, year::Int)

Save the input data to a netCDF file, given
- `config` the configuration dictionary
- `data` the data to save
- `year` the year to save (only for duplicated tasks)

"""
function save_input end;

save_input!(config::Dict, data::Array, year::Int) = (
    # determine the file to save (TAG of GriddingMachine)
    tag = config["TAG"];
    reso_s = config["RESOLUTION_SPATIAL"];
    reso_t = config["RESOLUTION_TEMPORAL"];
    version = config["VERSION"];
    gm_tag = "$(tag)_$(reso_s)X_$(reso_t)_$(year)_V$(version)";

    # save the data to a netcdf file
    filepath = joinpath(config["FOLDER_REPROCESSED"], "$gm_tag.nc");
    data_attributes = Dict{String,String}(
                "about" => config["DATA"]["ABOUT"],
                "unit"  => config["DATA"]["UNIT"],
    );
    n_changes = length(config["DATA"]["CHANGE_LOGS"]);
    for i in 1:n_changes
        data_attributes["change_$(i)"] = config["DATA"]["CHANGE_LOGS"][i];
    end;
    save_nc!(filepath, "data", data, data_attributes);

    return gm_tag
);
