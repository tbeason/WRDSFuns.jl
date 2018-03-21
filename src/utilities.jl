# a collection of helper functions

dropcols(df::AbstractDataFrame, cols) = df[setdiff(names(df), cols)]

function tomissing!(d::AbstractDataFrame,x::Union{Integer,Symbol})
	allowmissing!(d,x)
	d[findall(isnan,d[x]),x] = missing
end

function alltomissing!(d::AbstractDataFrame)
	for nm in names(d)
		if eltype(d[nm]) <: Float64
			if any(isnan,d[nm])
				tomissing!(d,nm)
			end
		end
	end
end



function disallowmissing!(d::AbstractDataFrame,x::Union{Integer,Symbol}) 
	d[x] = convert(Vector{eltype(d[x])},d[x])
	return d
end

function disallowmissing!(d,x...)
	for y in x
		disallowmissing!(d,y)
	end
	return d
end