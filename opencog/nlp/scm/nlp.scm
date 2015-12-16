
(define-module (opencog nlp))

(use-modules (opencog) (opencog atom-types))

; User-modifiable config paramters.
(define relex-server-host "127.0.0.1")
(define relex-server-port 4444)

; Load various parts....
(load "nlp/nlp-utils.scm")
(load "nlp/disjunct-list.scm")
(load "nlp/processing-utils.scm")
