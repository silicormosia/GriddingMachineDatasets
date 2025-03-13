const MDAYS = [0,31,59,90,120,151,181,212,243,273,304,334,365];
const NDAYS = [31,28,31,30,31,30,31,31,30,31,30,31];

function month_ind(doy::Number)
    # if not leap year
    @assert 1 <= doy <= 365;
    i_month = 1;
    for i in 1:12
        if MDAYS[i] < doy <= MDAYS[i+1]
            i_month = i;
            break;
        end;
    end;

    return i_month
end;

function day_ind(doy::Number)
    i_month = month_ind(doy);

    return doy - MDAYS[i_month]
end;

function mm_dd(doy::Number)
    i_month = month_ind(doy);
    i_day = doy - MDAYS[i_month];

    return lpad(i_month, 2, "0") * lpad(i_day, 2, "0")
end;
