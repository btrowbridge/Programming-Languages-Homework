:- use_module(library(clpfd)).

% [3,_,4,_,_,1,_,3,2,3,_,_,1,_,_,2]

sudoku(Puzzle, Solution) :-
  Solution = Puzzle,
  
  Puzzle = [N11, N12, N13, N14,
            N21, N22, N23, N24,
            N31, N32, N33, N34,
            N41, N42, N43, N44],

  clpfd:append(Solution, Rng), Rng ins 1..4,
  
  
  Row1 = [N11, N12, N13, N14], 
  Row2 = [N21, N22, N23, N24],
  Row3 = [N31, N32, N33, N34],
  Row4 = [N41, N42, N43, N44],      
  
  Col1 = [N11, N21, N31, N41],
  Col2 = [N12, N22, N32, N42],
  Col3 = [N13, N23, N33, N43],
  Col4 = [N14, N24, N34, N44],      
  
  Square1 = [N11, N12, N21, N22],
  Square2 = [N13, N14, N23, N24],
  Square3 = [N31, N32, N41, N42],
  Square4 = [N33, N34, N43, N44],      
  
  valid([Row1, Row2, Row3, Row4,
         Col1, Col2, Col3, Col4,
         Square1, Square2, Square3, Square4]).
 
valid([]).
valid([Head | Tail]) :- maplist(clpfd:all_different, Head), valid(Tail).