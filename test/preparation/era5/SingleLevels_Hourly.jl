# This script is meant to process the ERA5 Single Levels data
using Dates: isleapyear
import NetcdfIO as NC


# Global variables
INPUT_FOLDER = "/home/wyujie/DATASERVER/reanalysis/ERA5/SingleLevels/Hourly/original";
OUTPUT_FOLDER = "/home/wyujie/GriddingMachine/original/ERA5/SingleLevels";
mkpath(OUTPUT_FOLDER);


# ERA5 variables

ERA5_SL_HOURLY_SELECTION =[
            "10m_u_component_of_wind",
            "10m_v_component_of_wind",
            "2m_dewpoint_temperature",
            "2m_temperature",
            "mean_surface_direct_short_wave_radiation_flux",
            "mean_surface_direct_short_wave_radiation_flux_clear_sky",
            "mean_surface_downward_long_wave_radiation_flux",
            "mean_surface_downward_long_wave_radiation_flux_clear_sky",
            "mean_surface_downward_short_wave_radiation_flux",
            "mean_surface_downward_short_wave_radiation_flux_clear_sky",
            "mean_surface_downward_uv_radiation_flux",
            "skin_temperature",
            "soil_temperature_level_1",
            "soil_temperature_level_2",
            "soil_temperature_level_3",
            "soil_temperature_level_4",
            "surface_pressure",
            "total_cloud_cover",
            "total_precipitation",
            "volumetric_soil_water_layer_1",
            "volumetric_soil_water_layer_2",
            "volumetric_soil_water_layer_3",
            "volumetric_soil_water_layer_4"];
ERA5_SL_HOURLY_LAYERS = [
            "u10", "v10", "d2m", "t2m",
            "msdrswrf", "msdrswrfcs", "msdwlwrf", "msdwlwrfcs", "msdwswrf", "msdwswrfcs", "msdwuvrf",
            "skt", "stl1", "stl2", "stl3", "stl4", "sp", "tcc", "tp", "swvl1", "swvl2", "swvl3", "swvl4"];
GRIDDINGMACHINE_TAGS = [
            "WIND_U_10M",
            "WIND_V_10M",
            "T_DW_2M",
            "T_AIR_2M",
            "SW_DIR",
            "SW_DIR_CS",
            "LW_RAD",
            "LW_RAD_CS",
            "SW_RAD",
            "SW_RAD_CS",
            "UV_RAD",
            "T_SKIN",
            "T_SOIL_1",
            "T_SOIL_2",
            "T_SOIL_3",
            "T_SOIL_4",
            "P_ATM",
            "CLOUD_COVER",
            "PRECIPITATION",
            "SWC_1",
            "SWC_2",
            "SWC_3",
            "SWC_4"];


# functions to get the dimensions
include("../dim.jl");


# 1. function to process the bands, months, and years
function read_data(y::Int, var_label::String, var_name::String)
    # path to file
    filepath = joinpath(INPUT_FOLDER, "$(var_label)_SL_$(y).nc");
    filevars = NC.varname_nc(filepath);

    # only when file exists and the variable is in the file
    nz = isleapyear(y) ? 366*24 : 365*24;
    if isfile(filepath) && var_name in filevars
        data = ones(Float32, 360*4, 180*4, nz) .* NaN32;
        for iz in 1:nz
            layer = NC.read_nc(filepath, var_name, iz);

        end;

        return data
    end;

    # otherwise, skip
    return nothing
end;

read_data(2000, ERA5_SL_HOURLY_SELECTION[1], ERA5_SL_HOURLY_LAYERS[1]);
