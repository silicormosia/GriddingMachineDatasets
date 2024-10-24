using Revise

import GriddingMachineDatasets as GMD


# 0. load the yaml file
# 1.
config = GMD.read_yaml("/home/wyujie/Github/Julia/GriddingMachineDatasets/test.yaml");
data = GMD.read_input(config, 2019; data_or_std="data");
verification = GMD.verify_data(data, config["DATA"]);
GMD.save_input!(config, data, 2019)
