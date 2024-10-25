# This script is meant to process the geoTIFF files from GEE output
import GriddingMachineDatasets as GMD
import NetcdfIO as NC


# global variables
INPUT_FOLDER = "/home/wyujie/GriddingMachine/original/GEE/MCD43A4_061";
OUTPUT_FOLDER = "/home/wyujie/GriddingMachine/original/GEE/MCD43A4_061";


# functions to get the dimensions
lon_dim(nx::Int) = 360nx;
lat_dim(nx::Int) = 180nx;
ind_dim(mt::String) = (
    return if mt == "1M"
        12
    elseif mt == "8D"
        46
    else
        error("Temporal resolution $(mt) not supported!")
    end;
);


# 1. function to process the bands, months, and years
function combine_bands(y::Int, nx::Int, mt::String, b::Int)
    # path to file
    filepath = "$(INPUT_FOLDER)/$(y)_$(nx)X_$(mt).tif";
    bands = (collect(1:ind_dim(mt)) .- 1) .* 7 .+ b;

    # first index is 2 when y == 2000 and mt == 1M (because MODIS started collecting data since 2000-Feb)
    first_ind = if y == 2000 && mt == "1M"
        2
    elseif y == 2000 && mt == "8D"
        7
    else
        1
    end;

    # loop through the time index
    data = ones(Float32, lon_dim(nx), lat_dim(nx), ind_dim(mt)) .* NaN32;
    for i in first_ind:ind_dim(mt)
        band_data = GMD.read_geotiff(filepath, bands[i-first_ind+1]);
        data[:,:,i] .= band_data;
    end;

    return data
end;


# 2. save the data to netCDF file per band
for y in 2000:2024
    for nx in [1]
        for mt in ["8D", "1M"]
            in_file = "$(INPUT_FOLDER)/$(y)_$(nx)X_$(mt).tif";
            for b in 1:7
                out_file = "$(OUTPUT_FOLDER)/B$(b)_$(nx)X_$(mt)_$(y)_V1.nc";
                # if input file exists and output file does not
                if isfile(in_file) && !isfile(out_file)
                    NC.create_nc!(out_file, ["lon", "lat", "ind"], [lon_dim(nx), lat_dim(nx), ind_dim(mt)]);
                    data = combine_bands(y, nx, mt, b);
                    NC.append_nc!(out_file, "REFL_B$(b)", data, Dict{String,String}("about" => "Reflectance of Band $(b)"), ["lon", "lat", "ind"]);
                    @info "Finished processing file $(out_file)";
                end;
            end;
        end;
    end;
end;
