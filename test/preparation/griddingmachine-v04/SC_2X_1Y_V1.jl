using GriddingMachine.Blender: regrid, nanmean
using GriddingMachine.Collector: download_artifact!
using NetcdfIO: append_nc!, create_nc!, read_nc


lon = read_nc(download_artifact!("SC_2X_1Y_V1"), "lon");
lat = read_nc(download_artifact!("SC_2X_1Y_V1"), "lat");
data = read_nc(download_artifact!("SC_2X_1Y_V1"), "data");
stdv = read_nc(download_artifact!("SC_2X_1Y_V1"), "std");
data_filled = deepcopy(data);


data_int = round.(Int, data)
