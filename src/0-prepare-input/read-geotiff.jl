#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-23: Add function to read geotiff files
#
#######################################################################################################################################################################################################
"""

    read_geotiff(filepath::String, band::Int)

Reads a geotiff file and returns the data of the specified band, given
- `filepath` the path to the geotiff file
- `band` the band to read

"""
function read_geotiff end;

read_geotiff(filepath::String, band::Int) = (
    dset = read(filepath);
    data = getband(dset, band);

    return data[:,:]
);
