# GriddingMachineDatasets

Codebase for reprocessing data for GriddingMachine.jl. The steps of the process are:

0. Format the data from original source to NetCDF format
1. Determine how the data should be processed, e.g.,
   - Whether there is a std term
   - Whether the data is global scale
   - ... ...



- Collect the data from the original source
- Combine the data into a single file (when necessary)
- Regrid the data (when necessary)
- Create a metadata file for the data (JSON or YAML format)
- Use the pipeline to process the data
- Make the data available for download using the GriddingMachine.jl package
