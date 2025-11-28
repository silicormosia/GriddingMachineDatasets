module GriddingMachineDatasets

using Revise

using ArchGDAL: getband, read
using NetcdfIO: append_nc!, read_nc, save_nc!
using OrderedCollections: OrderedDict
using PkgUtility.ArtifactTools: read_library


# GLOABL VARIABLES
GRIDDING_MACHINE_HOME = joinpath(homedir(), "GriddingMachine");


# pipelines
#     0. pre-processing, used to convert other formats to netCDF
#     1. reading the netCDF file and do some basic processing
include("preparation/0-geotiff.jl");
include("preparation/1-read.jl");
include("preparation/2-verify.jl");
include("preparation/3-save.jl");
include("preparation/4-tag.jl");
include("preparation/pipeline.jl");


#     using NetcdfIO: append_nc!, save_nc!
#
#
#
#     include("process-input/process.jl");
#
#     include("deploy-artifact/gmtag.jl");
#     include("deploy-artifact/create.jl");
#     include("deploy-artifact/deploy.jl");
#
end # module
