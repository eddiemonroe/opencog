; =============================================================================
; EquivalenceTransformationRule
; 
; EquivalenceLink
;   A
;   B
; |-
; AndLink
;   ImplicationLink
;       A
;       B
;   ImplicationLink
;       B
;       A
;
; Due to pattern matching issues, currently the file has been divided into 3
; parts, each pertaining to different links. The rules are :-
;       pln-rule-equivalence-transformation
;       pln-rule-intensional-equivalence-transformation
;       pln-rule-extensional-equivalence-transformation
;
;
; -----------------------------------------------------------------------------

(define pln-rule-equivalence-transformation
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B"))
        (EquivalenceLink
            (VariableNode "$A")
            (VariableNode "$B"))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm:pln-formula-equivalence-transformation")
            (ListLink
                (AndLink
                    (ImplicationLink
                        (VariableNode "$A")
                        (VariableNode "$B"))
                    (ImplicationLink
                        (VariableNode "$B")
                        (VariableNode "$A")))
                (EquivalenceLink
                    (VariableNode "$A")
                    (VariableNode "$B"))))))

(define (pln-formula-equivalence-transformation AII EV)
    (cog-set-tv!
        (list-ref (cog-outgoing-set AII) 0) (cog-tv EV))
    (cog-set-tv!
        (list-ref (cog-outgoing-set AII) 1) (cog-tv EV))
    AII)

; Name the rule
(define pln-rule-equivalence-transformation-name
  (Node "pln-rule-equivalence-transformation"))
(DefineLink
  pln-rule-equivalence-transformation-name
  pln-rule-equivalence-transformation)



; IntensionalEquivalanceTransformationRule
;
(define pln-rule-intensional-equivalence-transformation
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B"))
        (IntensionalEquivalenceLink
            (VariableNode "$A")
            (VariableNode "$B"))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm:pln-formula-equivalence-transformation")
            (ListLink
                (AndLink
                    (IntensionalImplicationLink
                        (VariableNode "$A")
                        (VariableNode "$B"))
                    (IntensionalImplicationLink
                        (VariableNode "$B")
                        (VariableNode "$A")))
                (IntensionalEquivalenceLink
                    (VariableNode "$A")
                    (VariableNode "$B"))))))

; Name the rule
(define pln-rule-intensional-equivalence-transformation-name
  (Node "pln-rule-intensional-equivalence-transformation"))
(DefineLink
  pln-rule-intensional-equivalence-transformation-name
  pln-rule-intensional-equivalence-transformation)
