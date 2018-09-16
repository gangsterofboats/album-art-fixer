#lang racket
(require file/glob)

;; Parse arguments
(define input-path null)
(define output-path null)

(command-line
 #:once-each
 [("-i" "--input") input "Input path" (set! input-path input)]
 [("-o" "--output") output "Output path" (set! output-path output)])

;; Ensure directory paths end in slashes
(unless (string-suffix? input-path "/")
  (set! input-path (string-append input-path "/")))
(unless (string-suffix? output-path "/")
  (set! output-path (string-append output-path "/")))

;; Main part of script
(define aarts (glob (string-append input-path "**AlbumArt.jpg")))
(define not-big-enough (list))
(define not-square (list))
(for ([f aarts])
  (define result (with-output-to-string (lambda () (system (format "magick identify \"~a\"" f)))))
  (define aadims (first (regexp-match #px"\\d+x\\d+" result)))
  (set! aadims (string-split aadims "x"))
  (cond
    [(not (equal? (first aadims) (second aadims))) (set! not-square (append not-square (list f)))])
  (cond
    [(or (< (string->number (first aadims)) 1000) (< (string->number (second aadims)) 1000))
     (set! not-big-enough (append not-big-enough (list f)))]))

;; # Write results of search to files
(display-lines-to-file not-big-enough (string-append output-path "notbig.txt") #:exists 'replace)
(display-lines-to-file not-square (string-append output-path "notsquare.txt") #:exists 'replace)
