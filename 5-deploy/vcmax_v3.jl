#
# This script is meant to deploy the data for GriddingMachine.jl
#
using PkgUtility: deploy_artifact!


# 1. reprocess the data to meet GriddingMachine requirements
GRIDDING_MACHINE_HOME = "/home/wyujie/GriddingMachine";
ARTIFACT_TOML         = "$(@__DIR__)/../Artifacts.toml";
DATASET_FOLDER        = "$(GRIDDING_MACHINE_HOME)/reprocessed";
ARTIFACT_FOLDER       = "$(GRIDDING_MACHINE_HOME)/artifacts"
FTP_URLS              = ["ftp://fluo.gps.caltech.edu/XYZT_GRIDDING_MACHINE/artifacts"];

deploy_artifact!(ARTIFACT_TOML, "VCMAX_CESM_1X_1M_V3", DATASET_FOLDER, ["GRIDDINGMACHINE", "VCMAX_CESM_1X_1M_V3.nc"], ARTIFACT_FOLDER, FTP_URLS);
deploy_artifact!(ARTIFACT_TOML, "VCMAX_CESM_LUNA_1X_1M_V3", DATASET_FOLDER, ["GRIDDINGMACHINE", "VCMAX_CESM_LUNA_1X_1M_V3.nc"], ARTIFACT_FOLDER, FTP_URLS);
