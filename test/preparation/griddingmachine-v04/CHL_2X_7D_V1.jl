using GriddingMachine.Blender: regrid, nanmean
using GriddingMachine.Collector: download_artifact!
using NetcdfIO: append_nc!, create_nc!, read_nc



lon = read_nc(download_artifact!("CHL_2X_7D_V1"), "lon");
lat = read_nc(download_artifact!("CHL_2X_7D_V1"), "lat");
ind = read_nc(download_artifact!("CHL_2X_7D_V1"), "ind");
data = read_nc(download_artifact!("CHL_2X_7D_V1"), "data");
stdv = read_nc(download_artifact!("CHL_2X_7D_V1"), "std");
data_filled = deepcopy(data);

# fill the missing values with mean value
# use land mask to identify missing values
land_mask = read_nc(download_artifact!("LM_4X_1Y_V1"), "data");
land_mask_2X = regrid(land_mask, 2);
filtered_land = land_mask_2X .> 0;

for i in axes(data, 3)
    slice = data[:, :, i];
    mean_value = nanmean(slice);
    site_to_refill = isnan.(slice) .& filtered_land;
    data_filled[site_to_refill,i] .= mean_value;
end;



# copy a nanmean


# save the data
new_data_folder = joinpath(homedir(), "GriddingMachine/refactored");
new_data_file = joinpath(new_data_folder, "CHL_2X_7D_V1_R1.nc");
create_nc!(new_data_file, ["lon", "lat", "ind"], [size(data)...]);
append_nc!(new_data_file, "data", data_filled, Dict{String,Any}("about" => "Leaf chlorophyll content"), ["lon", "lat", "ind"]);
append_nc!(new_data_file, "std", stdv, Dict{String,Any}("about" => "Standard deviation of leaf chlorophyll content"), ["lon", "lat", "ind"]);
