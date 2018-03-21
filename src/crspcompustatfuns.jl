
function portfolioassignments!(df::AbstractDataFrame,groupbyvar::Union{Integer,Symbol,Vector{<:Union{Integer,Symbol}}},var::Union{Integer,Symbol},portname::Symbol;nysebrkpts=false)
   df[portname] = allowmissing(fill(99,size(df,1)))
   for subdf in groupby(df,groupbyvar)
      if nysebrkpts
         dsub = subdf[:EXCHCD .== 1, var]
      else
         dsub = subdf[var]
      end
      filter!(!ismissing,dsub)
      if length(dsub) >= 1
         breaks = quantile(convert(Vector{Float64},dsub),0.0:0.1:1.0)
         subdf[portname] = map(x->searchsortedlast(breaks[1:end-1],x),subdf[var])
         subdf[ismissing.(subdf[var]),portname] = missing
      end
   end
end


# assumes :PERMNO and :DATE exist on both DataFrames
function compustat2crspjoin(crsp::AbstractDataFrame,compustat::AbstractDataFrame,joincols::Union{Integer,Symbol,Vector{<:Union{Integer,Symbol}}})
   df = copy(crsp)
   dfjoin = compustat[vcat(:PERMNO,:DATE,joincols)]

   for j  in joincols
      df[j] = Vector{Union{Float64,Missing}}(fill(missing,(nrow(df),)))
   end
   df[:DDATE] = Vector{Union{Date,Missing}}(fill(missing,(nrow(df),)))
   for subdf in groupby(df,:PERMNO)
      pno = subdf[:PERMNO][1]
      joiners=filter(r->r[:PERMNO] == pno,dfjoin)
      nrj = nrow(joiners)
      if nrj >= 1
         @inbounds for i=1:nrj
            dt = joiners[i,:DATE]
            daterows = dt + Dates.Month(6) .<= subdf[:DATE] .< dt + Dates.Month(18)
            for j in joincols
               subdf[daterows,j] = joiners[i,j]
            end
            subdf[daterows,:DDATE] = dt
         end
      end
   end
   return df
end


