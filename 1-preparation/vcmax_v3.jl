#
# This script is meant to prepare the data for Vcmax25 V3 for GriddingMachine.jl
#
using NetcdfIO: append_nc!, create_nc!, read_nc
using ProgressMeter: @showprogress
using Statistics: mean, std


# 1. Define the location of the original data files and the reprocessed files
CESM_DIR = "/home/wyujie/DATASERVER/model/CESM/CliMA_Land_Leaf_Optics/IHistClm50BgcCrop_leafspectra_v2/lnd/hist";
COMBINED_FILE = "/home/wyujie/DATASERVER/database/GriddingMachine/original/VCMAX_CESM_1M.nc";


# 2. Combine the files into a single file only if the combined file does not exist
if !isfile(COMBINED_FILE)
    data_3d_t = ones(144,96,12*35);
    data_3d_z = ones(144,96,12*35);
    for year in 1985:2019
        for month in 1:12
            infile = "IHistClm50BgcCrop_leafspectra_v2.clm2.h0.$(year)-$(lpad(month,2,"0")).nc";
            if isfile(joinpath(CESM_DIR, infile))
                println("Reading $infile");
                data_t = read_nc(joinpath(CESM_DIR, infile), "VCMX25T");
                data_z = read_nc(joinpath(CESM_DIR, infile), "Vcmx25Z");
                data_3d_t[:,:,12*(year-1985)+month] = data_t;
                data_3d_z[:,:,12*(year-1985)+month] = data_z;
            else
                println("File does not exist for year $year and month $month");
            end;
        end;
    end;

    # save the data
    create_nc!(COMBINED_FILE, ["lon", "lat", "time", "month"], [144, 96, 12*35,12]);
    append_nc!(COMBINED_FILE, "VCMAX25T", data_3d_t, Dict{String,String}("about" => "canopy profile of vcmax25"), ["lon", "lat", "time"]);
    append_nc!(COMBINED_FILE, "VCMAX25Z", data_3d_z, Dict{String,String}("about" => "canopy profile of vcmax25 predicted by LUNA model"), ["lon", "lat", "time"]);

    # compute the monthly means of the data
    mean_2d_t = ones(144,96,12);
    mean_2d_z = ones(144,96,12);
    std_2d_t = ones(144,96,12);
    std_2d_z = ones(144,96,12);
    for i in 1:144
        for j in 1:96
            for month in 1:12
                mean_2d_t[i,j,month] = mean(data_3d_t[i,j,month:12:end]);
                mean_2d_z[i,j,month] = mean(data_3d_z[i,j,month:12:end]);
                std_2d_t[i,j,month] = std(data_3d_t[i,j,month:12:end]);
                std_2d_z[i,j,month] = std(data_3d_z[i,j,month:12:end]);
            end;
        end;
    end;

    # save the means and stds
    append_nc!(COMBINED_FILE, "VCMAX25T_MEAN", mean_2d_t, Dict{String,String}("about" => "mean of canopy profile of vcmax25"), ["lon", "lat", "month"]);
    append_nc!(COMBINED_FILE, "VCMAX25Z_MEAN", mean_2d_z, Dict{String,String}("about" => "mean of canopy profile of vcmax25 predicted by LUNA model"), ["lon", "lat", "month"]);
    append_nc!(COMBINED_FILE, "VCMAX25T_STD", std_2d_t, Dict{String,String}("about" => "std of canopy profile of vcmax25"), ["lon", "lat", "month"]);
    append_nc!(COMBINED_FILE, "VCMAX25Z_STD", std_2d_z, Dict{String,String}("about" => "std of canopy profile of vcmax25 predicted by LUNA model"), ["lon", "lat", "month"]);
else
    println("The combined file already exists");
end;
