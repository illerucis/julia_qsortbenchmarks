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

# median of 3 pivot that reflects the current pull request
function qsort_c_mp!(v, lo=1, hi=length(v))
    @inbounds while lo < hi
        hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)
        mi = (lo+hi)>>>1
        # med = median([v[lo], v[mi], v[hi]])
        if isless(v[mi], v[lo])
            v[lo], v[mi] = v[mi], v[lo];
        end
        if isless(v[hi], v[mi])
            v[mi], v[hi] = v[hi], v[mi];
        end
        if isless(v[mi], v[lo])
            v[mi], v[lo] = v[lo], v[mi];
        end
        # @assert v[mi] == med
        v[mi], v[lo] = v[lo], v[mi]
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
        qsort_c_mp!(v, lo, j-1);
        lo = j+1
    end
    return v;
end

# median of 3 pivot with the suggested change to median mechanics
# at most 4 assignments and 3 comparisons
function qsort_s_mp!(v, lo=1, hi=length(v))
    @inbounds while lo < hi
        hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)
        mi = (lo+hi)>>>1
        if isless(v[hi], v[mi])
            if isless(v[lo], v[hi])
                mival = v[mi]
                v[mi] = v[hi]
                v[hi] = mival
            else
                loval = v[lo]
                if isless(v[mi], v[lo])
                    v[lo] = v[hi]
                    v[hi] = loval
                else
                    v[lo] = v[hi]
                    v[hi] = v[mi]
                    v[mi] = loval
                end
            end
        elseif isless(v[mi], v[lo])
            loval = v[lo]
            if isless(v[lo], v[hi])
                v[lo] = v[mi]
                v[mi] = loval
            else
                v[lo] = v[mi]
                v[mi] = v[hi]
                v[hi] = loval
            end
        end
        v[mi], v[lo] = v[lo], v[mi]
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
        qsort_c_mp!(v, lo, j-1);
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
