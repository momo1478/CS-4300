function resolvents = CS4300_PL_Resolve(Ci, Cj)
% CS4300_PL_Resolve - resolves if there is a tautology
% On input:
%   Ci : A single disjunctive clause (1xp vector integers)
%   Ci : A single disjunctive clause (1xp vector integers)
% On output:
%   new_clause : A single disjunctive clause containing two clauses resolved
%   (sorted)
% Call:
%   Ci = [3,6,8];
%   Cj = [4,2,5];
%   nc = CS4300_PL_Resolve(Ci, Cj);
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017
%

has_match = 0;
matches_indicies = [];
for i = 1:length(Ci)
    for j = 1:length(Cj)
        if Ci(i) == -1 * Cj(j)
            has_match = 1;
            matches_indicies = unique([matches_indicies, i, j + length(Ci)]);
        end
    end
end
matches_indicies = sort(matches_indicies);

if has_match
    resolvents.clauses = [Ci,Cj];
    for i = 1:length(matches_indicies)
        resolvents.clauses(matches_indicies(i) - i + 1) = [];
    end
    resolvents.clauses = unique(resolvents.clauses);
    return;
end

resolvents = []; %empty solution/none

end
