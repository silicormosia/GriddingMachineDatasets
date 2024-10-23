
# if the DUPLICATED_TASK is true, loop through the years; otherwise, just read the input file from the FILE_NAME
function read_input end;

# read the data from a specific year
read_input(config::Dict, year::Int; data_or_std::String = "data") = (
    @assert data_or_std in ["data", "std"] "data_or_std must be either 'data' or 'std'";

    # read the data
    if data_or_std == "data"
        return read_input(config["FOLDER"], config["FILE_NAME"], config["DATA_LABEL"], year);
    end;

    # read the std (if key exists)
    if haskey(config, "STD_LABEL")
        return read_input(config["FOLDER"], config["FILE_NAME"], config["STD_LABEL"], year);
    end;

    return nothing
);

# read the data from the FILE_NAME
read_input(config::Dict; data_or_std::String = "data") = (
    @assert data_or_std in ["data", "std"] "data_or_std must be either 'data' or 'std'";

    # read the data
    if data_or_std == "data"
        return read_input(config["FOLDER"], config["FILE_NAME"], config["DATA_LABEL"]);
    end;

    # read the std (if key exists)
    if haskey(config, "STD_LABEL")
        return read_input(config["FOLDER"], config["FILE_NAME"], config["STD_LABEL"]);
    end;

    return nothing
);

read_input(folder::String, filename::String, label::String, year::Int) = read_input(folder, replace(filename, "YYYY" => lpad(year, 4, "0")), label);

read_input(folder::String, filename::String, label::String) = read_input(joinpath(folder, filename), label);

read_input(filepath::String, label::String) = (
    data = read_nc(filepath, label);

    return data
);
