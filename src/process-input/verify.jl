#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-23: Add function to verify the data (need to read the figure externally)
#     2024-Oct-24: Add a new key "VERIFIED" to the dict to store the verification status for duplicated tasks
#
#######################################################################################################################################################################################################
"""

    verify_data(data::Array,
                dict::Dict;
                data_path::String = "/home/wyujie/GriddingMachine/cache/test.nc",
                python::String = "/net/fluo/data2/software/Anaconda/anaconda3/bin/python",
                script::String = "/home/wyujie/Github/Julia/GriddingMachineDatasets/src/python/verify-data.py")

Verify the data by plotting it and asking the user to verify it, given
- `data` the data to verify (will be saved to a temporary file)
- `dict` the dictionary containing the configuration
- `data_path` the path to save the data
- `python` the path to the python executable
- `script` the path to the python script to plot the data

"""
function verify_data(
            data::Array,
            dict::Dict;
            data_path::String = "/home/wyujie/GriddingMachine/cache/test.nc",
            python::String = "/net/fluo/data2/software/Anaconda/anaconda3/bin/python",
            script::String = "/home/wyujie/Github/Julia/GriddingMachineDatasets/src/python/verify-data.py")
    # if VERIFY_ONCE is true and the data has been verified, return true
    if haskey(dict, "VERIFY_ONCE") && dict["VERIFY_ONCE"] && haskey(dict, "VERIFIED") && dict["VERIFIED"]
        return true
    end;

    # save data to a local file path
    save_nc!(data_path, "test", data, Dict{String,String}("about" => "test data"));

    # call python script externally to plot the data
    if haskey(dict, "LIMITS")
        vmin = dict["LIMITS"][1];
        vmax = dict["LIMITS"][2];
        run(`$python $script $data_path test $vmin $vmax`);
    else
        run(`$python $script $data_path`);
    end;

    # ask user to verify the data
    print("Please verify the data in the plot. Type 'Y/y' to continue, otherweise to stop > ");
    response = readline();

    # add a new key "VERIFIED" to the dict
    dict["VERIFIED"] = lowercase(response) == "y";

    return Bool(dict["VERIFIED"])
end;
