#######################################################################################################################################################################################################
#
# Changes to the function
# General
#     2024-Oct-24: Add function to create an artifact for GriddingMachine
#     2024-Oct-24: Skip the process if the reprocessed file does not exist or the tarball file exists
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
    src_nc_file = reprocessed_file_path(config, year);
    tarball_file = tarball_file_path(config, year);

    # make sure the file exists; otherwise, return nothing
    if !isfile(src_nc_file)
        @info "Reprocessed file $src_nc_file not found, skipping the process...";

        return nothing
    end;

    # make sure the tarball file does not exist. If exists, skip the process
    if isfile(tarball_file)
        return nothing
    end;

    # create a temporary folder
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
    package(artifact_dir, tarball_file);

    return nothing
);
