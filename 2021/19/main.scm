; This was really painful, Scheme is so simple it almost feels like I am programming in lambda calculus directly
(use-modules (ice-9 rdelim) (srfi srfi-1))

(define (parseline l)
  (map string->number (string-split l #\,)))

(define (data)
  (call-with-input-file "input.txt"
    (lambda (p)
      (let loop ((line (read-line p))
                 (result '()))
        (if (eof-object? line)
            (reverse result)
            (loop (read-line p)
				  (if (string-contains line "scanner")
					(cons '() result)
					(if (string-contains line ",")
					  (cons (reverse (cons (parseline line) (reverse (car result)))) (cdr result))
					  result))))))))

(define (manhattan a b)
  (apply + (map abs (subt a b))))

(define (zip a b)
  (map cons a b))

(define (addt a b)
  (map (lambda (x) (+ (car x) (cdr x))) (zip a b)))

(define (subt a b)
  (map (lambda (x) (- (car x) (cdr x))) (zip a b)))

(define (distancesb b bs)
  (map (lambda (x) (subt x b)) bs))

(define (distancesbm bs)
  (map (lambda (b) (distancesb b (filter (lambda (x) (not (eq? x b))) bs))) bs))

(define (numeq a b)
  (fold (lambda (x y) (if (member x b) (+ y 1) y)) 0 a))

(define (uniq xs)
  (fold (lambda (x y) (if (member x y) y (cons x y))) '() xs))

(define (maximum a)
  (fold (lambda (x y) (if (> x y) x y)) 0 a))

(define (perm n used)
  (flatten (map (lambda (x) (let ((r (map (lambda (y) (cons x y)) (perm n (cons x used))))) (if (null? r) (list (cons x '())) r))) (filter (lambda (x) (not (member x used))) n))))

(define (signs n)
  (if (= n 0) (list '()) (flatten (map (lambda (x) (list (cons 1 x) (cons -1 x))) (signs (- n 1))))))

(define (flatten xs)
  (fold (lambda (a b) (append a b)) '() xs))

(define (rot p r s)
  (map (lambda (x) (* (list-ref s x) (list-ref p x))) r))

(define (rotate ps r s)
  (map (lambda (x) (rot x r s)) ps))

(define (zero p)
  (map (lambda (x) 0) p))

(define (scannersimilar as cached)
  (maximum (map (lambda (a) (maximum (map (lambda (b) (numeq a b)) cached))) (distancesbm as))))

(define (searchrot bs r s truthdelta)
  (if (< 10 (scannersimilar (rotate bs r s) truthdelta))
	(cons #t (cons r (cons s '())))
	'(#f)))

(define (searchr bs r dirs truthdelta)
  (if (null? dirs) '() (cons (searchrot bs r (car dirs) truthdelta) (searchr bs r (cdr dirs) truthdelta))))

(define (searchd bs rots dirs truthdelta)
  (if (null? rots) '() (append (searchr bs (car rots) dirs truthdelta) (searchd bs (cdr rots) dirs truthdelta))))

(define (search unmatched truthdelta rots dirs)
  (let ((f (filter car (searchd (car unmatched) rots dirs truthdelta))))
	(if (null? f)
	  (search (cdr unmatched) truthdelta rots dirs)
	  (cons (car unmatched) (cdr (car f))))))

(define (range rs)
  (if (null? rs) '() (cons (- (length rs) 1) (range (cdr rs)))))

(define (offset xs r t)
  (map (lambda (x) (addt t (subt x r))) xs))

(define (filter-guess truth xs)
  (filter (lambda (x) (< 10 (numeq x truth))) xs))

(define (guess truth rotated)
  (car (filter-guess truth (flatten (map (lambda (t) (map (lambda (r) (offset rotated r t)) rotated)) truth)))))

(define (rotate-found found truth)
  (let ((rotated (rotate (car found) (list-ref found 1) (list-ref found 2))))
	(let ((res (guess truth rotated)))
	(cons res (cons (subt (car res) (car rotated)) '())))))

(define (max-dist xs)
  (maximum (flatten (map (lambda (a) (map (lambda (b) (manhattan a b)) xs)) xs))))

(define (println x)
  (display x)(display "\n"))

(let ((unmatched (data)))
  (let ((truth (car unmatched)))
	(set! unmatched (cdr unmatched))
	(let ((scanners (list (zero (car truth))))
		  (rots (perm (range (car truth)) '()))
		  (dirs (signs (length (car truth)))))
	  (while (not (null? unmatched))
	    (let ((truthdelta (distancesbm truth)))
		  (let ((found (search unmatched truthdelta rots dirs)))
			(set! unmatched (delete (car found) unmatched))
			(let ((shifted (rotate-found found truth)))
			  (set! truth (uniq (append truth (car shifted))))
			  (set! scanners (cons (car (cdr shifted)) scanners))
			  )
			(println (cons "Added scanner:" (car scanners))))))
	  ; part 1
	  (println (length truth))
	  ; part 2
	  (println (max-dist scanners)))))
