#
# This file is meant to reprocess the data to meet GriddingMachine requirements
#
using GriddingMachine.Blender: regrid
using NetcdfIO: append_nc!, create_nc!, read_nc


# 1. Define the location of the original data files and the reprocessed files
COMBINED_FILE = "/home/wyujie/DATASERVER/database/GriddingMachine/original/VCMAX_CESM_1M.nc";
REPROCESSED_FILE = "/home/wyujie/DATASERVER/database/GriddingMachine/reprocessed/VCMAX_CESM_1X_1M.nc";


# 2. Reprocess the data for resolution and projection
if !isfile(REPROCESSED_FILE)
    data_t_raw = read_nc(COMBINED_FILE, "VCMAX25T_MEAN");
    data_z_raw = read_nc(COMBINED_FILE, "VCMAX25Z_MEAN");
    std_t_raw = read_nc(COMBINED_FILE, "VCMAX25T_STD");
    std_z_raw = read_nc(COMBINED_FILE, "VCMAX25Z_STD");

    # reproject the data so that lon start from -180 to 180
    data_t_new = similar(data_t_raw);
    data_z_new = similar(data_z_raw);
    std_t_new = similar(std_t_raw);
    std_z_new = similar(std_z_raw);
    data_t_new[1:72,:,:] = data_t_raw[73:144,:,:];
    data_t_new[73:144,:,:] = data_t_raw[1:72,:,:];
    data_z_new[1:72,:,:] = data_z_raw[73:144,:,:];
    data_z_new[73:144,:,:] = data_z_raw[1:72,:,:];
    std_t_new[1:72,:,:] = std_t_raw[73:144,:,:];
    std_t_new[73:144,:,:] = std_t_raw[1:72,:,:];
    std_z_new[1:72,:,:] = std_z_raw[73:144,:,:];
    std_z_new[73:144,:,:] = std_z_raw[1:72,:,:];

    # regrid the data to 1x1 degree resolution
    data_t_regrid = regrid(data_t_new, (360,180); expansion=15);
    data_z_regrid = regrid(data_z_new, (360,180); expansion=15);
    std_t_regrid = regrid(std_t_new, (360,180); expansion=15);
    std_z_regrid = regrid(std_z_new, (360,180); expansion=15);

    # save the reprocessed data
    create_nc!(REPROCESSED_FILE, ["lon", "lat", "month"], [360, 180, 12]);
    append_nc!(REPROCESSED_FILE, "lon", collect(-179.5:1:180), Dict{String,String}("about" => "longitude"), ["lon"]);
    append_nc!(REPROCESSED_FILE, "lat", collect(-89.5:1:90), Dict{String,String}("about" => "latitude"), ["lat"]);
    append_nc!(REPROCESSED_FILE, "month", collect(1:12), Dict{String,String}("about" => "month"), ["month"]);
    append_nc!(REPROCESSED_FILE, "VCMAX25T_MEAN", data_t_regrid, Dict{String,String}("about" => "mean of canopy profile of vcmax25"), ["lon", "lat", "month"]);
    append_nc!(REPROCESSED_FILE, "VCMAX25Z_MEAN", data_z_regrid, Dict{String,String}("about" => "mean of canopy profile of vcmax25 predicted by LUNA model"), ["lon", "lat", "month"]);
    append_nc!(REPROCESSED_FILE, "VCMAX25T_STD", std_t_regrid, Dict{String,String}("about" => "std of canopy profile of vcmax25"), ["lon", "lat", "month"]);
    append_nc!(REPROCESSED_FILE, "VCMAX25Z_STD", std_z_regrid, Dict{String,String}("about" => "std of canopy profile of vcmax25 predicted by LUNA model"), ["lon", "lat", "month"]);
end;
