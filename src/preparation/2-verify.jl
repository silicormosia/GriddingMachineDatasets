"""

    verify_data(data::Array,
                dict::Union{Dict, OrderedDict};
                cache_data_path::String = joinpath(GRIDDING_MACHINE_HOME, "cache/test.nc"),
                python::String = "python3",
                script::String = "$(@__DIR__)/../python/verify-data.py")

Verify the data by plotting it and asking the user to verify it, given
- `data` the data to verify (will be saved to a temporary file)
- `dict` the dictionary containing the configuration
- `data_path` the path to save the data
- `python` the path to the python executable
- `script` the path to the python script to plot the data

"""
function verify_data!(
            data::Array,
            dict::Union{Dict, OrderedDict};
            cache_data_path::String = joinpath(GRIDDING_MACHINE_HOME, "cache/test.nc"),
            python::String = "python3",
            script::String = "$(@__DIR__)/../python/verify-data.py")
    # if VERIFY_ONCE is true and the data has been verified, return true
    if haskey(dict, "VERIFY_ONCE") && dict["VERIFY_ONCE"] && haskey(dict, "VERIFIED") && dict["VERIFIED"]
        return true
    end;

    # save data to a local file path
    save_nc!(cache_data_path, "test", data, Dict{String,String}("about" => "test data"));

    # call python script externally to plot the data
    if haskey(dict, "LIMITS")
        vmin = dict["LIMITS"][1];
        vmax = dict["LIMITS"][2];
        run(`$python $script $(cache_data_path) test $vmin $vmax`);
    else
        run(`$python $script $(cache_data_path) test`);
    end;

    # ask user to verify the data
    print("Please verify the data in the plot. Type 'Y/y' to continue, otherweise to stop > ");
    response = readline();

    # add a new key "VERIFIED" to the dict
    dict["VERIFIED"] = lowercase(response) == "y";

    return Bool(dict["VERIFIED"])
end;
