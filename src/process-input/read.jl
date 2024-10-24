#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-23: Add function to read the input files (netCDF format)
#     2024-Oct-24: Add change logs when formatting the data based on the configuration
#     2024-Oct-24: Copy CHANGE_LOGS to CHANGE_LOGS_TO_WRITE to avoid repeatly adding the same logs
#     2024-Oct-24: Skip the process if the original file does not exist
#     2024-Oct-24: Use loop file method to loop through all the different configurations
#
#######################################################################################################################################################################################################
"""

    read_input(config::Dict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}; data_or_std::String = "data")

Read the input data and format it based on the configuration, given
- `config` the configuration dictionary
- `prefix` the prefix of the file
- `nx` the spatial resolution (number of grid points in one degree)
- `mt` the time resolution
- `vv` the version of the dataset
- `yyyy` the year of the data (only for duplicated tasks)
- `data_or_std` the type of data to read (either "data" or "std")

"""
function read_input end;

read_input(config::Dict, prefix::String, nx::Int, mt::String, vv::String, yyyy::Union{Int,Nothing}; data_or_std::String = "data") = (
    @assert data_or_std in ["data", "std"] "data_or_std must be either 'data' or 'std'";

    # the index of prefix in the configuration
    if haskey(config, uppercase(data_or_std))
        dict_data = config[uppercase(data_or_std)];
        idx = findfirst(x -> x == prefix, config["FILE"]["PREFIX"]);
        return read_input(original_file_path(config, prefix, nx, mt, vv, yyyy), dict_data, dict_data["LABEL"][idx])
    end;

    return nothing
);

read_input(filepath::String, dict::Dict, label::String) = (
    # make sure file exists; otherwise, return nothing
    if !isfile(filepath)
        @info "original file $filepath not found, skipping the process...";

        return nothing
    end;

    # read the data from the netCDF file
    data = read_nc(filepath, label);

    # clear the change logs
    dict["CHANGE_LOGS_TO_WRITE"] = deepcopy(dict["CHANGE_LOGS"]);

    # if key REV_LAT exists, reverse the latitude
    data_a = if haskey(dict, "REV_LAT") && dict["REV_LAT"]
        push!(dict["CHANGE_LOGS_TO_WRITE"], "Latitude has been remapped from -90 to 90.");
        data[:,end:-1:1,:]
    else
        data
    end;

    # if key REV_LON exists, reverse the longitude
    data_b = if haskey(dict, "REV_LON") && dict["REV_LON"]
        push!(dict["CHANGE_LOGS_TO_WRITE"], "Longitude has been remapped from west to east.");
        data_a[end:-1:1,:,:]
    else
        data_a
    end;

    # if key SCALING exists, scale the data
    data_c = if haskey(dict, "SCALING") && lowercase(dict["SCALING"]) == "linear"
        push!(dict["CHANGE_LOGS_TO_WRITE"], "Data has been scaled linearly.");
        FT = eltype(data_b);
        data_b .* FT(dict["SCALING_FACTOR"][1]) .+ FT(dict["SCALING_FACTOR"][2])
    else
        data_b
    end;

    # if key LIMITS exists, limit the data
    if haskey(dict, "LIMITS")
        push!(dict["CHANGE_LOGS_TO_WRITE"], "Data has been limited within $(dict["LIMITS"][1]) and $(dict["LIMITS"][2]).");
        mask = data_c .< dict["LIMITS"][1] .|| data_c .> dict["LIMITS"][2];
        data_c[mask] .= NaN;
    end;

    return data_c
);
