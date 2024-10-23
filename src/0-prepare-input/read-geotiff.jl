
function read_geotiff end;

read_geotiff(filepath::String, band::Int) = (
    dset = read(filepath);
    data = getband(dset, band);

    return data[:,:]
);
