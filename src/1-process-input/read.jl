
# if the DUPLICATED_TASK is true, loop through the years; otherwise, just read the input file from the FILE_NAME
function read_input end;

# read the data from a specific year
read_input(config::Dict, year::Int; data_or_std::String = "data") = (
    @assert data_or_std in ["data", "std"] "data_or_std must be either 'data' or 'std'";

    # read the data
    if data_or_std == "data"
        return read_input(config["FOLDER_ORIGINAL"], config["FILE_NAME"], config["DATA"], year);
    end;

    # read the std (if key exists)
    if haskey(config, "STD_LABEL")
        return read_input(config["FOLDER_ORIGINAL"], config["FILE_NAME"], config["STD"], year);
    end;

    return nothing
);

# read the data from the FILE_NAME
read_input(config::Dict; data_or_std::String = "data") = (
    @assert data_or_std in ["data", "std"] "data_or_std must be either 'data' or 'std'";

    # read the data
    if data_or_std == "data"
        return read_input(config["FOLDER_ORIGINAL"], config["FILE_NAME"], config["DATA"]);
    end;

    # read the std (if key exists)
    if haskey(config, "STD_LABEL")
        return read_input(config["FOLDER_ORIGINAL"], config["FILE_NAME"], config["STD"]);
    end;

    return nothing
);

read_input(folder::String, filename::String, dict::Dict, year::Int) = read_input(folder, replace(filename, "YYYY" => lpad(year, 4, "0")), dict);

read_input(folder::String, filename::String, dict::Dict) = read_input(joinpath(folder, filename), dict);

read_input(filepath::String, dict::Dict) = (
    data = read_nc(filepath, dict["LABEL"]);

    # if key REV_LAT exists, reverse the latitude
    data_a = if haskey(dict, "REV_LAT") && dict["REV_LAT"]
        push!(dict["CHANGE_LOGS"], "Latitude has been remapped from -90 to 90.");
        data[:,end:-1:1,:]
    else
        data
    end;

    # if key REV_LON exists, reverse the longitude
    data_b = if haskey(dict, "REV_LON") && dict["REV_LON"]
        push!(dict["CHANGE_LOGS"], "Longitude has been remapped from west to east.");
        data_a[end:-1:1,:,:]
    else
        data_a
    end;

    # if key SCALING exists, scale the data
    data_c = if haskey(dict, "SCALING") && lowercase(dict["SCALING"]) == "linear"
        push!(dict["CHANGE_LOGS"], "Data has been scaled linearly.");
        FT = eltype(data_b);
        data_b .* FT(dict["SCALING_FACTOR"][1]) .+ FT(dict["SCALING_FACTOR"][2])
    else
        data_b
    end;

    # if key LIMITS exists, limit the data
    if haskey(dict, "LIMITS")
        push!(dict["CHANGE_LOGS"], "Data has been limited within $(dict["LIMITS"][1]) and $(dict["LIMITS"][2]).");
        mask = data_c .< dict["LIMITS"][1] .|| data_c .> dict["LIMITS"][2];
        data_c[mask] .= NaN;
    end;

    return data_c
);
