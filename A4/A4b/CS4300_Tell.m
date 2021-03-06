function KB_out = CS4300_Tell(KB,sentence)
% CS4300_Tell - Tell function for logic KB
% On input:
%   KB (KB struct): Knowledge base (CNF)
%       (k).clauses (1xp vector): disjunction clause
%   sentence (KB struct): query theorem (CNF)
%       (k).clauses (1xq vector): disjunction
% On output:
%   KB_out (KB struct): revised KB
% Call:
%   KB = CS4300_Tell([],[1]);
% Author:
%   Monish Gupta and Eric Waugh
%   U1008121 and U0947296
%   Fall 2017

if isempty(KB)
    if ~isstruct(sentence)
        KB_out(1).clauses = sentence;
    else
        KB_out = sentence;
    end
    return;
end

if ~isstruct(sentence)
    temp = sentence;
    sentence = [];
    sentence(1).clauses = temp;
end

%check to see if opposite literal already exists to prevent inconsistent KB
for i = 1:length(KB)
    if KB(i).clauses == -1 * sentence(1).clauses
        KB(i) = [];
        break;
    end
end


KB_out = CS4300_clause_union(KB,sentence);

end
