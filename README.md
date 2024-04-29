# GriddingMachineDatasets

Codebase for reprocessing data for GriddingMachine.jl. The steps of the process are:
- Collect the data from the original source
- Combine the data into a single file (when necessary)
- Regrid the data (when necessary)
- Create a metadata file for the data (JSON or YAML format)
- Use the pipeline to process the data
- Make the data available for download using the GriddingMachine.jl package
