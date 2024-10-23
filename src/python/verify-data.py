#
# This script is meant to verify the orientation of the dataset
#
import matplotlib.pyplot as PLT
import matplotlib.animation as ANI
import netCDF4 as NC
import os
import sys


# 1. if file name not provided, print error message and exit
if len(sys.argv) == 1:
    print("    PythonVisualization: Please provide the file name!")
    sys.exit(1)


# 2. if file name provided, make sure the file exists
fname = sys.argv[1]
print("    PythonVisualization: File name is: ", fname)
if not os.path.exists(fname):
    print("    PythonVisualization: File", fname, "does not exist!")
    sys.exit(1)


# 3. make sure the data name is provided
if len(sys.argv) == 2:
    print("    PythonVisualization: Please provide the data name!")
    sys.exit(1)
label = sys.argv[2]
print("    PythonVisualization: Data name is: ", label)


# 4. read the optional input for vmin and vmax
vmin = None
vmax = None
if len(sys.argv) == 5:
    vmin = float(sys.argv[3])
    vmax = float(sys.argv[4])
    print("    PythonVisualization: vmin is: ", vmin)
    print("    PythonVisualization: vmax is: ", vmax)


# 5. read the data using Netcdf4
dset = NC.Dataset(fname)
data = dset.variables[label][:]
dset.close()


# 6. print the shape of the data
print("    PythonVisualization: Data shape is: ", data.shape)
if len(data.shape) == 2:
    print("    PythonVisualization: 2D PNG will be plotted as is!")
    PLT.figure(1, figsize=(13,6), dpi=300)
    if vmin is not None and vmax is not None:
        cm = PLT.imshow(data, origin="lower", vmin=vmin, vmax=vmax)
    else:
        cm = PLT.imshow(data, origin="lower")
    PLT.colorbar(cm)
    PLT.savefig("orientation.png")
    print("    PythonVisualization: Orientation image saved as orientation.png")
elif len(data.shape) == 3:
    def animate(i):
        PLT.clf()
        if vmin is not None and vmax is not None:
            cm = PLT.imshow(data[i,:,:], origin="lower", vmin=vmin, vmax=vmax)
        else:
            cm = PLT.imshow(data[i,:,:], origin="lower")
        PLT.colorbar(cm)
        PLT.title("Frame: " + str(i))
        return cm
    print("    PythonVisualization: 3D GIF will be plotted!")
    fig = PLT.figure(1, figsize=(13,6), dpi=300)
    anim = ANI.FuncAnimation(fig, animate, frames=data.shape[0], interval=200)
    writer = ANI.PillowWriter(fps=1)
    anim.save("orientation.gif", writer=writer)
    print("    PythonVisualization: Orientation image saved as orientation.gif")
else:
    print("    PythonVisualization: Data shape is not supported!")
    sys.exit(1)
