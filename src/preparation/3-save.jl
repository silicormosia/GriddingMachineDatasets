"""

    save_input!(config::Union{Dict, OrderedDict}, data::Array, filepath::String; data_or_std::String = "data")

Save the input data to a netCDF file, given
- `config` the configuration dictionary
- `data` the data to save
- `filepath` the path to the netCDF file
- `data_or_std` the type of data to save (either "data" or "std")

"""
function save_input!(config::Union{Dict, OrderedDict}, data::Array, filepath::String; data_or_std::String = "data")
    @assert data_or_std in ["data", "std"] "data_or_std must be either 'data' or 'std";

    # save the data to a netcdf file
    data_attributes = Dict{String,Any}(
                "about" => config[uppercase(data_or_std)]["ABOUT"],
                "unit"  => config[uppercase(data_or_std)]["UNIT"],
    );
    n_changes = length(config[uppercase(data_or_std)]["CHANGE_LOGS_TO_WRITE"]);
    for i in 1:n_changes
        data_attributes["change_$(i)"] = config[uppercase(data_or_std)]["CHANGE_LOGS_TO_WRITE"][i];
    end;

    # save a new file if data_or_std is "data"; otherwise, append to the existing file
    if data_or_std == "data"
        save_nc!(filepath, data_or_std, data, data_attributes);
    else
        dim_names = length(size(data)) == 3 ? ["lon", "lat", "ind"] : ["lon", "lat"];
        append_nc!(filepath, data_or_std, data, data_attributes, dim_names);
    end;

    return nothing
end;
