"""

    GriddingMachineDatasets

Module to prepare artifacts for GriddingMachine.

"""
module GriddingMachineDatasets

using Revise

using ArchGDAL: getband, read
using YAML: load_file, write_file

using NetcdfIO: append_nc!, read_nc, save_nc!


include("prepare-input/read-geotiff.jl");

include("process-input/yaml.jl");
include("process-input/read.jl");
include("process-input/verify.jl");
include("process-input/save.jl");
include("process-input/pipeline.jl");


end # module
