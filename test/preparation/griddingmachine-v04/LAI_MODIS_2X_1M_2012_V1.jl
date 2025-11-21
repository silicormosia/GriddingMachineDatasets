using GriddingMachine.Blender: regrid, nanmean
using GriddingMachine.Collector: download_artifact!
using NetcdfIO: append_nc!, create_nc!, read_nc


lon = read_nc(download_artifact!("LAI_MODIS_2X_1M_2012_V1"), "lon");
lat = read_nc(download_artifact!("LAI_MODIS_2X_1M_2012_V1"), "lat");
ind = read_nc(download_artifact!("LAI_MODIS_2X_1M_2012_V1"), "ind");
data = read_nc(download_artifact!("LAI_MODIS_2X_1M_2012_V1"), "data");
stdv = read_nc(download_artifact!("LAI_MODIS_2X_1M_2012_V1"), "std");
data_filled = deepcopy(data);

# fill the missing values with mean value
# use land mask to identify missing values
land_mask = read_nc(download_artifact!("LM_4X_1Y_V1"), "data");
land_mask_2X = regrid(land_mask, 2);
filtered_land = land_mask_2X .> 0;

for i in axes(data, 3)
    slice = data[:, :, i];
    site_to_refill = isnan.(slice) .& filtered_land;
    data_filled[site_to_refill,i] .= 0;
end;

data[:,:,end]
data_filled[:,:,end]
