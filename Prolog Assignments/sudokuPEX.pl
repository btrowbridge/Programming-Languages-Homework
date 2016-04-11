% Bradley Trowbridge
% Programming Languages
% Dean Bushey
% Sudoku PEX

% Standard query format: sudoku(Rows) where Rows is a 2D array and blank elements are replaced with an underscore (_)
% To use the sample test cases: problem(num, Rows), sudoku(Rows). 
% 								Rows remains a variable and num is the number of the desired test case, (see below)

:- use_module(library(clpfd)). % for use of domain spacifications i.e. "all_distinct"
 
sudoku(Rows) :-  
% Rows must be a list composing of the domain 1..4
  append(Rows, Rng), Rng ins 1..4,  
%Each row must have distinct items
  maplist(all_distinct, Rows),
% Transposing allows us to compare columns which must also be distinct
  transpose(Rows, Columns),
  maplist(all_distinct, Columns),    
% Extract the elements from row and apply our pre-defined Square predicate
  Rows = [A,B,C,D],     
  square(A, B), square(C,D),     
  maplist(label, Rows),      % Label limits us to one solution
  maplist(writeln, Rows).	 % Print lines

% Our defined square predicate
square([], []).     			   % Base case empty list  
square([A1,A2|An], [B1,B2|Bn]) :-  % Splits rows into the first two element and the remaining
  all_distinct([A,B,C,D]),         % Ensure that this squares' elements are distinct
  square(An, Bn). 				   % Recursive call on the remaining

%Sample test cases
problem(1,[ [3,_,4,_],
			[_,1,_,3],
		 	[2,3,_,_],
			[1,_,_,2]]).
problem(2,[ [3,4,1,_],
			[_,2,_,_],
		 	[_,_,2,_],
			[_,1,4,3]]).
%FailCases: Expected False
%Square
problem(3,[ [3,3,4,_],
			[_,1,_,3],
		 	[2,3,_,_],
			[1,_,_,2]]).
%Rows
problem(3,[ [3,_,4,_],
			[_,1,_,3],
		 	[2,3,_,_],
			[1,_,_,1]]).
%Column
problem(3,[ [3,_,4,2],
			[_,1,_,3],
		 	[2,3,_,_],
			[1,_,_,2]]).