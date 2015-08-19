; =============================================================================
; OrEvaluationRule
;
; AndLink
;   MemberLink
;       C
;       A
;   MemberLink
;       C
;       B
; |-
; OrLink
;   A
;   B
;
; -----------------------------------------------------------------------------

(define pln-rule-or-evaluation
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (MemberLink
                (VariableNode "$C")
                (VariableNode "$A"))
            (MemberLink
                (VariableNode "$C")
                (VariableNode "$B")))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: pln-formula-or-evaluation")
            (ListLink
                (OrLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (MemberLink
                    (VariableNode "$C")
                    (VariableNode "$A"))
                (MemberLink
                    (VariableNode "$C")
                    (VariableNode "$B"))))))

(define (pln-formula-or-evaluation AB CA CB)
    (cog-set-tv!
        AB (pln-formula-or-evaluation-side-effect-free AB CA CB)))

(define (pln-formula-or-evaluation-side-effect-free AB CA CB)
    (let 
        ((sCA (cog-stv-strength CA))
         (cCA (cog-stv-confidence CA))
         (sCB (cog-stv-strength CB))
         (cCB (cog-stv-confidence CB)))
        (if 
            (and (< sCA 0.5) (< sCB 0.5))
            (stv 0 1)
            (stv 1 1))))

; Name the rule
(define pln-rule-or-evaluation-name (Node "pln-rule-or-evaluation"))
(DefineLink pln-rule-or-evaluation-name pln-rule-or-evaluation)
