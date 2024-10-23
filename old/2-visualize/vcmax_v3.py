#
# This script is meant to visualize the initial data to determine its projection and coverage
#
import matplotlib.pyplot as PLT
import netCDF4 as NC


# 1. Read the data
infile = "/home/wyujie/DATASERVER/database/GriddingMachine/original/VCMAX_CESM_1M.nc"
dset = NC.Dataset(infile, "r")
vcmax_v3 = dset.variables["VCMAX25T_MEAN"][:]
vcmax_v4 = dset.variables["VCMAX25Z_MEAN"][:]
std_v3 = dset.variables["VCMAX25T_STD"][:]
std_v4 = dset.variables["VCMAX25Z_STD"][:]
dset.close()


# 2. Visualize the data using imshow
fig = PLT.figure("test-v3", figsize=(12,12), dpi=300)
ax1 = fig.add_subplot(211)
ax2 = fig.add_subplot(212)
cm1 = ax1.imshow(vcmax_v3[6], origin="lower")
cm2 = ax2.imshow(std_v3[6], origin="lower")
fig.colorbar(cm1, ax=ax1)
fig.colorbar(cm2, ax=ax2)
fig.set_tight_layout(True)
fig.savefig("figure/vcmax_v3.png")

fig = PLT.figure("test-v4", figsize=(12,12), dpi=300)
ax1 = fig.add_subplot(211)
ax2 = fig.add_subplot(212)
cm1 = ax1.imshow(vcmax_v4[6], origin="lower")
cm2 = ax2.imshow(std_v4[6], origin="lower")
fig.colorbar(cm1, ax=ax1)
fig.colorbar(cm2, ax=ax2)
fig.set_tight_layout(True)
fig.savefig("figure/vcmax_v4.png")
