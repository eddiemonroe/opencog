; =============================================================================
; IntensionalSimilarityEvaluationRule
;
; AndLink
;   AttractionLink
;       C
;       A
;   AttractionLink
;       C
;       B
; |-
; IntensionalSimilarityLink
;   A
;   B
;
; -----------------------------------------------------------------------------

(define pln-rule-intensional-similarity-evaluation
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (AttractionLink
                (VariableNode "$C")
                (VariableNode "$A"))
            (AttractionLink
                (VariableNode "$C")
                (VariableNode "$B")))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: pln-formula-intensional-similarity-evaluation")
            (ListLink
                (IntensionalSimilarityLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (AttractionLink
                    (VariableNode "$C")
                    (VariableNode "$A"))
                (AttractionLink
                    (VariableNode "$C")
                    (VariableNode "$B"))))))

(define (pln-formula-intensional-similarity-evaluation AB CA CB)
    (cog-set-tv!
        AB (pln-formula-intensional-similarity-evaluation-side-effect-free AB CA CB)))

(define (pln-formula-intensional-similarity-evaluation-side-effect-free AB CA CB)
    (let 
        ((sCA (cog-stv-strength CA))
         (cCA (cog-stv-confidence CA))
         (sCB (cog-stv-strength CB))
         (cCB (cog-stv-confidence CB)))
        (if 
            (and (< sCA 0.5) (< sCB 0.5))
            (stv 0 0)
            (if
                (and (>= sCA 0.5) (>= sCB 0.5))
                (stv 1 1)
                (stv 0 1)))))

; Name the rule
(define pln-rule-intensional-similarity-evaluation-name
  (Node "pln-rule-intensional-similarity-evaluation"))
(DefineLink
  pln-rule-intensional-similarity-evaluation-name
  pln-rule-intensional-similarity-evaluation)
