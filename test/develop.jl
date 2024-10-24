using Revise

import GriddingMachineDatasets as GMD


# GMD.process_dataset!("/home/wyujie/Github/Julia/GriddingMachineDatasets/test.yaml");
config = GMD.read_yaml("/home/wyujie/Github/Julia/GriddingMachineDatasets/test.yaml");
GMD.create_artifact!(config, 2020);
