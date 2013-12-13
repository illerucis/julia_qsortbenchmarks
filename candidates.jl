const SMALL_THRESHOLD = 20

# insertion sort
function isort(v, lo, hi)
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

# updated qsort
function qsort_c_mp!(v, lo=1, hi=length(v))
    @inbounds while lo < hi
        hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)
        mi = (lo+hi)>>>1
        if isless(v[mi], v[lo])
            v[lo], v[mi] = v[mi], v[lo];
        end
        if isless(v[hi], v[mi])
            v[mi], v[hi] = v[hi], v[mi];
        end
        if isless(v[mi], v[lo])
            v[mi], v[lo] = v[lo], v[mi];
        end
        v[mi], v[lo] = v[lo], v[mi]
        i, j = lo, hi;
        pivot = v[lo]
        while true;
            i += 1;
            while isless(v[i], pivot);
                i += 1;
            end;
            j -= 1;
            while isless(pivot, v[j]);
                j -= 1;
            end;
            i >= j && break;
            v[i], v[j] = v[j], v[i];
        end
        v[j], v[lo] = v[lo], v[j];
        lo < (j - 1) && qsort_c_mp!(v, lo, j-1);
        lo = j+1
    end
    return v;
end

# julia's current implementation as of v0.2
function qsort_stdlib!(v, lo=1, hi=length(v))
    @inbounds while lo < hi
        hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)
        pivot = v[(lo+hi)>>>1]
        i, j = lo, hi
        while true;
            while isless(v[i], pivot); i += 1; end
            while isless(pivot, v[j]); j -= 1; end
            i <= j || break;
            v[i], v[j] = v[j], v[i]
            i += 1; j -= 1;
        end
        lo < j && qsort_stdlib!(v, lo, j)
        lo = i
    end
    return v;
end
