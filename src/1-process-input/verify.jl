
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
