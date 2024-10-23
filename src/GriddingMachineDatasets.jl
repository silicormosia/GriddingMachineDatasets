module GriddingMachineDatasets

using Revise
using YAML: load_file, write_file

using NetcdfIO: read_nc


include("1-process-input/yaml.jl");
include("1-process-input/read-input.jl");


end # module
