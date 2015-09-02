; This loads all the rules into the cogserver shell. This assumes that the
; cogserver is started from in-source build directory.
(define (load-r2l-rulebase)
    (load-scm-from-file "../opencog/nlp/relex2logic/loader/load-rules.scm")
    (load-scm-from-file
        "../opencog/nlp/relex2logic/loader/gen-r2l-en-rulebase.scm")
)

(define (nlp-fc sent)
  (define mylist '())
; run forward chaining on sentence
  (let* ((temp (run-fc sent)); temp contains list of cog-fc results and parse node
        (result1 (car temp));result1 contains Listlink nested 3 times
        (parse-node (cadr temp))
        (result2 (cog-outgoing-set result1));result2 contains ListLink nested 2 times
        (parse-name (cog-name parse-node))
        )

     (for-each (lambda (x)
                 (let* ((t1 (cog-outgoing-set x));t1 contains ListLink List of results
                       )
                       (for-each (lambda (b)
                                   (let* ((t2 (cog-outgoing-set b)));t2 contains atoms contained in ListLink
                                    (for-each (lambda(c)
                                             ;  (display c)
                                                (set! mylist (append mylist (list c)))
                                              )
                                     t2)
                                   )
                                 )
                       t1
                       )
                 )
               )
      result2)

  (ReferenceLink
    (InterpretationNode (string-append parse-name "_interpretation_$X"))
    ; The function in the SetLink returns a list of outputs that
    ; are the results of the evaluation of the relex-to-logic functions,
    ; on the relex-opencog-outputs.
  (SetLink (delete-duplicates mylist))
  )

  (InterpretationLink
    (InterpretationNode (string-append parse-name "_interpretation_$X"))
    parse-node
  )

  (AtTimeLink
      ; FIXME: maybe opencog's internal time octime should be used. Will do for
      ; now assuming a single instance deals with a single conversation.
      (TimeNode (number->string (current-time)))
      (InterpretationNode (string-append parse-name "_interpretation_$X"))
      (TimeDomainNode "Dialogue-System")
  )
 )
#t
)

(define (run-fc sent)
  (define parse-node (car (sentence-get-parses (nlp-parse sent))))
  (list (cog-fc
    (SetLink (parse-get-relations parse-node))
    r2l-rules
   )
  parse-node
  )
)
(define (run-fc-dbg sent)
  (define parse-node (car (sentence-get-parses (nlp-parse sent))))
  (display (cog-fc
    (SetLink (parse-get-relations parse-node))
    r2l-rules
   )
  )
)
