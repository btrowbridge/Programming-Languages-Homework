;Scheme Assignment
;Programming Languages: Dean Bushey
;Bradley Trowbridge

;Programming Exercises 

;1.)	Write a Scheme function that computes the volume of a sphere, given its radius.
(define sphereVolume 
	(lambda ( r )
		( * ( / 4 3) ( * pi r r r)))) 	


;4.) Write a Scheme function that takes two numeric parameters, A and B, and returns A raised to the B power.


(define (power A B)
	(cond
		((equal? B 0) 1)
		( else ( * A (power A ( - B 1 ))))
	))
