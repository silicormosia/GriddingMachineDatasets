#
# This script is meant to visualize the initial data to determine its projection and coverage
#
import cartopy.crs as CCRS
import matplotlib.pyplot as PLT
import netCDF4 as NC


# 1. Read the data
infile = "/home/wyujie/DATASERVER/database/GriddingMachine/regridded/VCMAX_CESM_1X_1M.nc"
dset = NC.Dataset(infile, "r")
lats = dset.variables["lat"][:]
lons = dset.variables["lon"][:]
vcmax_v3 = dset.variables["VCMAX25T_MEAN"][:]
vcmax_v4 = dset.variables["VCMAX25Z_MEAN"][:]
std_v3 = dset.variables["VCMAX25T_STD"][:]
std_v4 = dset.variables["VCMAX25Z_STD"][:]
dset.close()


# 2. Visualize the data using imshow
fig = PLT.figure("test-v3", figsize=(12,12), dpi=300)
ax1 = fig.add_subplot(2,1,1, projection=CCRS.Robinson())
ax2 = fig.add_subplot(2,1,2, projection=CCRS.Robinson())
ax1.set_global()
ax1.coastlines()
ax2.set_global()
ax2.coastlines()
cm1 = ax1.pcolormesh(lons, lats, vcmax_v3[6], transform=CCRS.PlateCarree())
cm2 = ax2.pcolormesh(lons, lats, std_v3[6], transform=CCRS.PlateCarree())
fig.colorbar(cm1, ax=ax1)
fig.colorbar(cm2, ax=ax2)
fig.set_tight_layout(True)
fig.savefig("figure/vcmax_v3.png")

fig = PLT.figure("test-v4", figsize=(12,12), dpi=300)
ax1 = fig.add_subplot(2,1,1, projection=CCRS.Robinson())
ax2 = fig.add_subplot(2,1,2, projection=CCRS.Robinson())
ax1.set_global()
ax1.coastlines()
ax2.set_global()
ax2.coastlines()
cm1 = ax1.pcolormesh(lons, lats, vcmax_v4[6], transform=CCRS.PlateCarree())
cm2 = ax2.pcolormesh(lons, lats, std_v4[6], transform=CCRS.PlateCarree())
fig.colorbar(cm1, ax=ax1)
fig.colorbar(cm2, ax=ax2)
fig.set_tight_layout(True)
fig.savefig("figure/vcmax_v4.png")
