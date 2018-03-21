__precompile__()
module WRDSFuns

using SASLib
using DataFrames
using Missings
using ShiftedArrays
using Compat.Dates

export compustat2crspjoin, portfolioassignments!
export dropcols,alltomissing!,tomissing!,disallowmissing!

include("crspcompustatfuns.jl")
include("utilities.jl")

end
