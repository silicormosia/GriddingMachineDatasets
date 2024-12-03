# functions to get the dimensions
lon_dim(nx::Int) = 360nx;
lat_dim(nx::Int) = 180nx;
ind_dim(mt::String) = (
    return if mt == "1M"
        12
    elseif mt == "8D"
        46
    else
        error("Temporal resolution $(mt) not supported!")
    end;
);
