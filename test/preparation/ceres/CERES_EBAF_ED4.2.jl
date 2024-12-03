# This script is meant to process the CERES data copied from CliMA
import NetcdfIO as NC


# Global variables
INPUT_FOLDER = "/home/wyujie/DATASERVER/satellite/CERES";
OUTPUT_FOLDER = "/home/wyujie/GriddingMachine/original/CERES/EBAF_ED4.2";
mkpath(OUTPUT_FOLDER);


# functions to get the dimensions
include("../dim.jl");


# 1. function to process the bands, months, and years
function read_data(y::Int, varname::String)
    # path to file
    filepath = "$(INPUT_FOLDER)/CERES_EBAF_Edition4.2_200003-202407.nc";

    # first index is 3 when y == 2000 and mt == 1M
    first_ind = y == 2000 ? 3 : 1;

    # loop through the time index
    data = ones(Float32, lon_dim(1), lat_dim(1), ind_dim("1M")) .* NaN32;
    for i in first_ind:ind_dim("1M")
        data[:,:,i] .= NC.read_nc(filepath, varname, (y-2000) * ind_dim("1M") + i - 3 + 1);
    end;

    return data
end;


# 2. save the data to netCDF file per band
ncvars = ["cldarea_total_daynight_mon"];
fnvars = ["CLOUD_FRACTION"];
for y in 2000:2023
    for ivar in eachindex(ncvars)
        vn = ncvars[ivar];
        fn = fnvars[ivar];
        out_file = "$(OUTPUT_FOLDER)/$(fn)_CERES_EBAF_ED4.2_1X_1M_$(y)_V1.nc";
        if !isfile(out_file)
            NC.create_nc!(out_file, ["lon", "lat", "ind"], [lon_dim(1), lat_dim(1), ind_dim("1M")]);
            data = read_data(y, vn);
            NC.append_nc!(out_file, fn, data, Dict{String,String}("about" => "CERES $(vn)"), ["lon", "lat", "ind"]);
            @info "Finished processing file $(out_file)";
        end;
    end;
end;
