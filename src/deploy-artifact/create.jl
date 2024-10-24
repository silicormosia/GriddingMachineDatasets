#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add function to create an artifact for GriddingMachine
#
#######################################################################################################################################################################################################
"""

    create_artifact!(config::Dict, year::Union{Int,Nothing})

Create an artifact for GriddingMachine, given
- `config` the configuration dictionary
- `year` the year to create the artifact (only for duplicated tasks)

"""
function create_artifact! end;

create_artifact!(config::Dict, year::Union{Int,Nothing}) = (
    gm_tag = isnothing(year) ? griddingmachine_tag(config) : griddingmachine_tag(config, year);
    src_gm_file = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", "GRIDDINGMACHINE");
    src_nc_file = joinpath(GRIDDING_MACHINE_HOME, "reprocessed", config["FOLDER_REPROCESSED"], "$gm_tag.nc");
    tmp_dir = mktempdir(joinpath(GRIDDING_MACHINE_HOME, "cache"));
    mkpath(tmp_dir);

    # copy the empty file GRIDDINGMACHINE and netCDF file to the tmp_dir folder
    dst_gm_file = joinpath(tmp_dir, "GRIDDINGMACHINE");
    dst_nc_file = joinpath(tmp_dir, "$gm_tag.nc");
    cp(src_gm_file, dst_gm_file; force = true);
    cp(src_nc_file, dst_nc_file; force = true);

    # compute the hash of the tmp_dir folder and rename it
    artifact_hash = Base.SHA1(tree_hash(tmp_dir));
    artifact_dir = joinpath(GRIDDING_MACHINE_HOME, "public", bytes2hex(artifact_hash.bytes));
    mv(tmp_dir, artifact_dir; force = true);

    # package the artifact
    tarball = joinpath(GRIDDING_MACHINE_HOME, "tarballs", config["FOLDER_TARBALL"], "$gm_tag.tar.gz");
    package(artifact_dir, tarball);

    return nothing
);
