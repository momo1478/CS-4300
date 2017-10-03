function Sip = CS4300_RTP(sentences,thm,vars)
% CS4300_RTP - resolution theorem prover
% On input:
%   sentences (CNF data structure): array of conjuctive clauses
%       (i).clauses
%           each clause is a list of integers (- for negated literal)
%       thm (CNF datastructure): a disjunctive clause to be tested
%       vars (1xn vector): list of variables (positive integers)
% On output:
%   Sip (CNF data structure): results of resolution
%       []: proved sentence |- thm
%       not []: thm does not follow from sentences
% Call: (example from Russell & Norvig, p. 252)
%   DP(1).clauses = [-1,2,3,4];
%   DP(2).clauses = [-2];
%   DP(3).clauses = [-3];
%   DP(4).clauses = [1];
%   thm(1).clauses = [4];
%   vars = [1,2,3,4];
%   Sr = CS4300_RTP(DP,thm,vars);
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017


for lit = 1 : length(thm(1).clauses)
    a = -1 * thm(1).clauses(lit);
    for sent = 1 : length(sentences)
        b = sentences(sent).clauses;
        is_unique = 1;
        if a == b % set a == set b 
            is_unique = 0;
        end
   end
   if is_unique 
       sentences(length(sentences) + 1).clauses = a;
   end
end

new = [];
Sip = [];

while 1 == 1
    
    for i = 1:length(sentences)   
        for j = i:length(sentences)
            if i ~= j
                resolvents = CS4300_PL_Resolve(sentences(i).clauses, sentences(j).clauses);
                if ~isempty(resolvents)
                    if isempty(resolvents(1).clauses)
                        Sip = [];
                        return
                    end
                    
                    %new = new \union resolvents
                    is_unique = 1;
                    for k = 1 : length(new)
                        a = new(k).clauses; b = resolvents(1).clauses;
                        if all([ismember(b,a),ismember(a,b)])
                            is_unique = 0;
                        end
                    end

                    if is_unique
                       new(length(new) + 1).clauses = resolvents(1).clauses; 
                    end
                end
            end
        end 
    end
    
    elements_to_add = [];
    is_subset = 1;
    for i = 1 : length(new)
        a = new(i).clauses; is_unique = 1;
        for j = 1 : length(sentences)
           b = sentences(j).clauses;
           if all([ismember(b,a),ismember(a,b)])
                is_unique = 0;
           end
        end
        if is_unique
            is_subset = 0;
            elements_to_add(length(elements_to_add) + 1).clauses = new(i).clauses;
        end
    end
    
    if is_subset
        Sip = sentences;
        return
    end
    
    for i = 1 : length(elements_to_add) 
        sentences(length(sentences) + 1).clauses = elements_to_add(i).clauses;
    end
end

end



