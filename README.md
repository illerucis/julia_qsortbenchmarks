motivation
=====================

This is a cursory report regarding [issue #939](https://github.com/JuliaLang/julia/issues/939?source=cc). For primitive datatypes, Julia invokes Quicksort, so the general purpose here is to increase the performance of the standard library implementation of Quicksort. While looking at Julia's current implementation of Quicksort, several issues became apparent:

- Each pivot element is not guaranteed to be placed in its proper position in the array after each pass
 - the algorithm may have to look at more elements than are necessary
- The algorithm fails to complete without the insertion sort optimization, on an array out-of-bounds exception
 - this isn't necessarily a big issue since insertion sort is invoked for small arrays in the standard library implementation

As a quick example, let's look at Julia's pure Quicksort on array ```[4, 10, 11, 24, 9]```, without the insertion sort optimization ```hi-lo <= SMALL_THRESHOLD && return isort(v, lo, hi)```, and without the ```@inbounds``` macro.

The pivot on the first pass is ```11```, determined by ```p = (lo+hi)>>>1```. However after the first pass, the array becomes ```[4, 10, 9, 24, 11]```. If we let the algorithm try to run to completion, the following error is raised ```ERROR: BoundsError()``` on the ```j``` index crawl ```while isless(pivot, v[j]); j -= 1; end```.

potential improvements (?)
=====================

Improvements are proposed with four permutations of Quicksort, outlined in qsortbenchmarks.jl. 

- The canonical Quicksort algorithm that places the pivot in its natural position after each pass. The pivot is chosen as the first element in each subarray
- Canonical, and performs a random shuffle (Fisher-Yates) of the array before the initial sort 
- Canonical, but uses a median of three sampled values (indexes lo, (hi+lo)>>>1, hi) as the pivot
- Canonical with both a median of three pivot, and the random shuffle

Some low-hanging fruit optimizations were made to the canonical example, specifically the ```@inbounds``` macro which speeds up array access (~2x boost in performance), and the lack of bounds checking on the ```j``` index scan. 

Naive benchmarking shows an improvement across the board over Julia's current Quicksort. For each sample, we create an array of random integers, copy the array for each implementation, and time each implementation. The results are then normalized to the standard libary's sort time. This method on 10^4 samples of 10^5-element random integer arrays produces
<h4 style="color:red;">...not up to date...</h4>
<table>
    <thead>
        <tr>
	    <th></th>
	    <th>Mean Ratio</th>
	    <th>Median Ratio</th>
	</tr>
    </thead>
    <tbody>
        <tr>
	   <td>Canonical</td>
	   <td>0.9472264</td>
	   <td>0.9567886</td>
	</tr>
        <tr>
	   <td>Median-of-3 Pivot</td>
	   <td>0.9462880</td>
	   <td>0.9468467</td>
	</tr>
        <tr>
	   <td>Random Shuffle</td>
	   <td>0.9372264</td>
	   <td>0.9467886</td>
	</tr>
        <tr>
	   <td>Combo</td>
	   <td>0.9422264</td>
	   <td>0.9417886</td>
	</tr>
    </tbody>
</table>