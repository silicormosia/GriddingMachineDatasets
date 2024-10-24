module GriddingMachineDatasets

using Revise

using ArchGDAL: getband, read
using YAML: load_file, write_file

using NetcdfIO: read_nc, save_nc!


include("0-prepare-input/read-geotiff.jl");

include("1-process-input/yaml.jl");
include("1-process-input/read.jl");
include("1-process-input/verify.jl");
include("1-process-input/save.jl");


end # module
