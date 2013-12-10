const SMALL_THRESHOLD = 20

# insertion sort
function isort(v, lo=1, hi=length(v))
    @inbounds for i = lo+1:hi
        j = i
        x = v[i]
        while j > lo
            if isless(x, v[j-1])
                v[j] = v[j-1]
                j -= 1
                continue
            end
            break
        end
        v[j] = x
    end
    return v;
end

# median of 3 pivot
function qsort_c_mp!(v, lo=1, hi=length(v))
    @inbounds while lo < hi
        hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)
        mi = (lo+hi)>>>1
        if v[lo] > v[mi]
            v[lo], v[mi] = v[mi], v[lo];
        end
        if v[lo] > v[hi]
            v[lo], v[hi] = v[hi], v[lo];
        end
        if v[mi] > v[lo]
            v[mi], v[lo] = v[lo], v[mi];
        end
        v[mi], v[lo] = v[lo], v[mi]
        highval = v[hi]
        v[hi] = v[lo]
        i, j = lo, hi;
        pivot = v[lo]
        while true;
            i += 1;
            while isless(v[i], pivot);
                i += 1;
            end
            j -= 1;
            while isless(pivot, v[j]);
                j -= 1;
            end
            i >= j && break;
            v[i], v[j] = v[j], v[i];
        end
        v[j], v[lo] = v[lo], v[j];
        v[hi] = highval
        qsort_c_mp!(v, lo, j-1);
        lo = j+1
    end
    return v;
end

# median of 3 pivot
function qsort_s_mp!(v, lo=1, hi=length(v))
    @inbounds while lo < hi
        hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)
        mi = (lo+hi)>>>1
        if v[lo] > v[mi]
            if v[lo] < v[hi]
                pivot = v[lo]
            elseif v[mi] > v[hi]
                pivot = v[mi]
            else
                pivot = v[hi]
            end
        else
            if v[lo] > v[hi]
                pivot = v[lo]
            elseif v[mi] < v[hi]
                pivot = v[mi]
            else
                pivot = v[hi]
            end
        end
        i, j = lo, hi
        while true;
            while isless(v[i], pivot); i += 1; end
            while isless(pivot, v[j]); j -= 1; end
            i <= j || break;
            v[i], v[j] = v[j], v[i]
            i += 1; j -= 1;
        end
        lo < j && qsort_s_mp!(v, lo, j)
        lo = i
    end
    return v;
end
