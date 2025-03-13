# This script is meant to process the geoTIFF files from GEE output
import GriddingMachine as GM
import GriddingMachineDatasets as GMD
import NetcdfIO as NC


# global variables
INPUT_FOLDER = "/home/wyujie/GriddingMachine/original/CHL/MERIS-ML/GLOBMAP_MERIS_LCC-0.05degree";
OUTPUT_FOLDER = "/home/wyujie/GriddingMachine/original/CHL/MERIS-ML";


# functions to get the dimensions
include("../dim.jl");
include("../time.jl");


# 1. function to process the bands (assume non-leap year)
function combine_bands()
    # to loop through the years
    data = ones(Float32, lon_dim(20), lat_dim(20), 52) .* NaN32;
    for i in 1:52
        @info "Reading $(i)th out of 52 files...";
        doy = 7 * (i-1) + 1;
        filepath = "$(INPUT_FOLDER)/MERIS-LCC-LACC-300m-$(mm_dd(doy))-global-0.05degree.tif";
        band_data = GMD.read_geotiff(filepath, 1);
        data[:,:,i] .= band_data;
    end;

    return data
end;


# 2. save the data to netCDF file per band
out_file = "$(OUTPUT_FOLDER)/CHL_20X_7D_V2.nc";
if !isfile(out_file)
    NC.create_nc!(out_file, ["lon", "lat", "ind"], [lon_dim(20), lat_dim(20), 52]);
    data = combine_bands();
    NC.append_nc!(out_file, "CHL", data, Dict{String,String}("about" => "Leaf chlorophyll content"), ["lon", "lat", "ind"]);
    @info "Finished processing file $(out_file)";
end;


# 3. regrid the data to coarser resolution
for nx in [2, 4]
    reg_file = "$(OUTPUT_FOLDER)/CHL_$(nx)X_7D_V2.nc";
    if !isfile(reg_file)
        NC.create_nc!(reg_file, ["lon", "lat", "ind"], [lon_dim(nx), lat_dim(nx), 52]);
        d20x = NC.read_nc(out_file, "CHL");
        data = GM.Blender.regrid(d20x, nx);
        NC.append_nc!(reg_file, "CHL", data, Dict{String,String}("about" => "Leaf chlorophophyll content"), ["lon", "lat", "ind"]);
        @info "Finished processing file $(reg_file)";
    end;
end;
