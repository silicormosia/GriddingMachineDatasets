#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-23: Add function to read the configuration file (YAML format)
#
#######################################################################################################################################################################################################
"""

    read_yaml(yaml_file::String)

Read the configuration file in YAML format, given
- `yaml_file` the path to the YAML file

"""
function read_yaml(yaml_file::String)
    return load_file(yaml_file; dicttype = OrderedDict{String,Any})
end;


#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add function to save the data base
#
#######################################################################################################################################################################################################
"""

    save_yaml!(yaml_file::String, dict::OrderedDict)
    save_yaml!(dict::OrderedDict, yaml_file::String)

Save the dictionary to a YAML file, given
- `yaml_file` the path to the YAML file
- `dict` the dictionary to save

"""
function save_yaml! end;

save_yaml!(yaml_file::String, dict::Union{Dict,OrderedDict}) = (
    write_file(yaml_file, dict);

    return nothing;
);

save_yaml!(dict::Union{Dict,OrderedDict}, yaml_file::String) = save_yaml!(yaml_file, dict);
