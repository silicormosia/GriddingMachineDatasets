"""

    GriddingMachineDatasets

Module to prepare artifacts for GriddingMachine.

"""
module GriddingMachineDatasets

using Revise

using ArchGDAL: getband, read
using OrderedCollections: OrderedDict
using Pkg.GitTools: tree_hash
using Pkg.PlatformEngines: package
using YAML: load_file, write_file

using NetcdfIO: append_nc!, read_nc, save_nc!


# GLOABL VARIABLES
GRIDDING_MACHINE_HOME = joinpath(homedir(), "GriddingMachine");


include("yaml/yaml.jl");

include("prepare-input/read-geotiff.jl");

include("process-input/read.jl");
include("process-input/verify.jl");
include("process-input/save.jl");
include("process-input/process.jl");

include("deploy-artifact/gmtag.jl");
include("deploy-artifact/create.jl");
include("deploy-artifact/deploy.jl");


end # module
