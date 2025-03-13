# This script is meant to process the SLA collections from DOI: 10.1111/geb.13680
import GriddingMachine as GM
import NetcdfIO as NC


# global variables
INPUT_FOLDER = "/home/wyujie/GriddingMachine/original/LMA";
OUTPUT_FOLDER = "/home/wyujie/GriddingMachine/original/LMA";


# functions to get the dimensions
include("../dim.jl");


# 1. save the data to netCDF file per z
in_file = "$(INPUT_FOLDER)/Global_Maps_SLA.nc";
in_data = NC.read_nc(in_file, "variable");
zs_old = [2,5];
zs = [1,3,4,6,7];
for i_old in 1:2
    vn = i_old;
    out_file = "$(OUTPUT_FOLDER)/LMA_2X_1Y_V$(vn).nc";
    if !isfile(out_file)
        NC.create_nc!(out_file, ["lon", "lat"], [lon_dim(2), lat_dim(2)]);
        data = 1 ./ in_data[:,:,zs_old[i_old]];
        NC.append_nc!(out_file, "LMA", data, Dict{String,String}("about" => "Leaf mass per area (kg m⁻²)"), ["lon", "lat"]);
        @info "Finished processing file $(out_file)";
    end;
end;
for i in 1:5
    vn = i + 2;
    out_file = "$(OUTPUT_FOLDER)/LMA_2X_1Y_V$(vn).nc";
    if !isfile(out_file)
        NC.create_nc!(out_file, ["lon", "lat"], [lon_dim(2), lat_dim(2)]);
        data = 1 ./ in_data[:,:,zs[i]];
        NC.append_nc!(out_file, "LMA", data, Dict{String,String}("about" => "Leaf mass per area (kg m⁻²)"), ["lon", "lat"]);
        @info "Finished processing file $(out_file)";
    end;
end;
