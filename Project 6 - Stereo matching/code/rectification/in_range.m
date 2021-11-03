function bool = in_range(v, minv, maxv)

%IN_RANGE checks if a given value is within a specified range.
%
%   bool = in_range(v, minv, maxv) sets bool to 1 if minv <= v <= maxv,
%   0 otherwise.
%
%Created September 2003.
%
%Copyright Du Huynh
%The University of Western Australia
%School of Computer Science and Software Engineering

if v >= minv & v <= maxv
   bool = 1;
else
   bool = 0;
end

return
