function [KB,KBi,vars] = CS4300_BR_gen_KB
% BR_gen_KB - generate Wumpus World logic in KB
% On input:
%   N/A
% On output:
%   KB (CNF KB): KB with Wumpus logic (atom symbols)
%    (k).clauses (string): string form of disjunction
%   KBi (CNF KB): KB with Wumpus logic (integers)
%    (k).clauses (1xp vector): integer form of disjunction
%   vars(struct: vector of strings): list of atom strings
%    (k).var (string): name of atom
% Call:
%   [KB,KBi,vars] = CS4300_BR_gen_KB;
% Author:
%   Eric Waugh and Monish Gupta
%   u0947296 and u1008121
%   Fall 2017
%

KB = [];
KBi = [];

vars = [];
conGraph = zeros(16,16);
letters = ['B','G','P','S','W'];
for l = 1:5
    for i = 1:4
        for j = 1:4
            vars(length(vars) + 1).var = strcat(letters(l), int2str(i), int2str(j));
        end
    end
end

for i = 1:16
    if rem(i,4) ~= 1 %left
        conGraph(i, i - 1) = 1; 
    end
    if rem(i,4) ~= 0 %right
        conGraph(i, i + 1) = 1;
    end
    if i < 13 %up
        conGraph(i, i + 4) = 1;
    end
    if i > 4 %down
        conGraph(i, i - 4) = 1;
    end  
end

breeze_offset = 0;
glitter_offset = 16;
pit_offset = 32;
stench_offset = 48;
wumpus_offset = 64;
BLANK = ' ';

for i = 1:16 %sets up rule for breezes where one neighbor must be a pit
    new_rule = -(i + breeze_offset);
    new_string_rule = ['-', vars(i + breeze_offset).var];
    for j = 1:16
        if conGraph(i,j) == 1
            KBi(length(KBi) + 1).clauses = [-(j + pit_offset), i + breeze_offset];
            KB(length(KB) + 1).clauses = ['-', vars(j + pit_offset).var, BLANK, vars(i + breeze_offset).var];
            
            new_rule = [new_rule, j + pit_offset];
            new_string_rule = [new_string_rule, BLANK, vars(j + pit_offset).var];
        end
    end
    KBi(length(KBi) + 1).clauses = new_rule;
    KB(length(KB) + 1).clauses = new_string_rule;
end

for i = 1:16 %sets up rule for stenches where one neighbor must be a wumpus
    new_rule = -(i + stench_offset);
    new_string_rule = strcat('-', vars(i + stench_offset).var);
    for j = 1:16
        if conGraph(i,j) == 1
            KBi(length(KBi) + 1).clauses = [-(j + wumpus_offset), i + stench_offset];
            KB(length(KB) + 1).clauses = ['-', vars(j + wumpus_offset).var, BLANK, vars(i + stench_offset).var];
            
            new_rule = [new_rule, j + wumpus_offset];
            new_string_rule = strcat(new_string_rule, {' '}, vars(j + wumpus_offset).var);
        end
    end
    KBi(length(KBi) + 1).clauses = new_rule;
    KB(length(KB) + 1).clauses = new_string_rule;
end

gold_rule = [];
gold_string_rule = [];
for i = 1:16 %only 1 gold on the board rule set
    gold_rule = [gold_rule, i + glitter_offset]
    gold_string_rule = [gold_string_rule, BLANK, vars(i + glitter_offset).var];
    for j = i:16
        if i ~= j
            new_rule = [-(i + glitter_offset), -(j + glitter_offset)];
            new_string_rule = ['-', vars(i + glitter_offset).var, BLANK, '-', vars(j + glitter_offset).var];
            KBi(length(KBi) + 1).clauses = new_rule;
            KB(length(KB) + 1).clauses = new_string_rule;
        end
    end
end
KBi(length(KBi) + 1).clauses = gold_rule;
KB(length(KB) + 1).clauses = gold_string_rule;

wumpus_rule = [];
wumpus_string_rule = [];
for i = 1:16 %only 1 wumpus on the board rule set
    wumpus_rule = [wumpus_rule, i + wumpus_offset]
    wumpus_string_rule = [wumpus_string_rule, BLANK, vars(i + wumpus_offset).var];
    for j = i:16
        if i ~= j
            new_rule = [-(i + wumpus_offset),-(j + wumpus_offset)];
            new_string_rule = ['-', vars(i + wumpus_offset).var, BLANK, '-', vars(j + wumpus_offset).var];
            KBi(length(KBi) + 1).clauses = new_rule;
            KB(length(KB) + 1).clauses = new_string_rule;
        end
    end
end
KBi(length(KBi) + 1).clauses = wumpus_rule;
KB(length(KB) + 1).clauses = wumpus_string_rule;

for i = 1:16 %no gold on a pit
    new_rule = [-(i + glitter_offset), -(i + pit_offset)];
    new_string_rule = ['-', vars(i + glitter_offset).var, BLANK, '-', vars(i + pit_offset).var];
    KBi(length(KBi) + 1).clauses = new_rule;
    KB(length(KB) + 1).clauses = new_string_rule;
end

for i = 1:16 %no wumpus on a pit
    new_rule = [-(i + wumpus_offset), -(i + pit_offset)];
    new_string_rule = ['-', vars(i + wumpus_offset).var, BLANK, '-', vars(i + pit_offset).var];
    KBi(length(KBi) + 1).clauses = new_rule;
    KB(length(KB) + 1).clauses = new_string_rule;
end
