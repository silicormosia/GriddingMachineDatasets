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
    return load_file(yaml_file);
end;
