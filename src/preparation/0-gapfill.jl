""" Different gapfill methods """
abstract type AbsrtactFillMethod end;

""" Fill missing values with the mean value (nanmean) """
struct FillMethodMean <: AbsrtactFillMethod end;

""" Fill missing values with a constant value """
struct FillMethodConstant <: AbsrtactFillMethod
    constant::Real
end;


"""

    fill_missing_values!(data_in::AbstractArray, land_mask::AbstractArray, mthd::AbsrtactFillMethod)

Gapfill the data based on the specified method, given
- `data_filled` the data array to be filled (2D or 3D)
- `land_mask` the land mask data (2D)

"""
function fill_missing_values! end;

fill_missing_values!(data_in::AbstractArray, land_mask::AbstractArray, mthd::FillMethodConstant) = (
    filtered_land = land_mask .> 0;

    sum_gapfill = 0;
    for i in axes(data_in, 3)
        slice = data_in[:, :, i];
        site_to_refill = isnan.(slice) .& filtered_land;
        data_in[site_to_refill, i] .= mthd.constant;
        sum_gapfill += sum(site_to_refill);
    end;

    return sum_gapfill
);

fill_missing_values!(data_in::AbstractArray, land_mask::AbstractArray, mthd::FillMethodMean) = (
    filtered_land = land_mask .> 0;

    sum_gapfill = 0;
    for i in axes(data_in, 3)
        slice = data_in[:, :, i];
        mean_value = nanmean(slice);
        site_to_refill = isnan.(slice) .& filtered_land;
        data_in[site_to_refill, i] .= mean_value;
        sum_gapfill += sum(site_to_refill);
    end;

    return sum_gapfill
);
