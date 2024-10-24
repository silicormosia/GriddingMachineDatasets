using Revise

import GriddingMachineDatasets as GMD


config = GMD.read_yaml("/home/wyujie/Github/Julia/GriddingMachineDatasets/test.yaml");
GMD.process_dataset!("/home/wyujie/Github/Julia/GriddingMachineDatasets/test.yaml");
GMD.deploy_datasets!("/home/wyujie/Github/Julia/GriddingMachineDatasets/test.yaml");
