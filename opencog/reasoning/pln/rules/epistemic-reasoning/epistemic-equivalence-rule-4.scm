
; Equivalence rule for simple truth values (see Section 2.2, rule 4) 
;
; Given Implication A B , calculate strength of Equivalence belief A belief B
;  Equivalence (A) (B) <s> <c>
;  |-
;  Equivalence (believe i A <t>) (believe i B <t>) <s ∗ (1 − \epsilon )> <c>
;
; -----------------------------------------------------------------------------

(define pln-rule-epistemic-equivalence
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B"))
        (EquivalenceLink
            (AndLink
                (VariableNode "$A")
                (VariableNode "$B"))
            (VariableNode "$A"))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: pln-formula-simple-epistemic-implication")
            (ListLink
                (VariableNode "$B")
                (EquivalenceLink
                    (VariableNode "$A")
                    (VariableNode "$B"))))))

; -----------------------------------------------------------------------------
; Epistemic Equivalence Formula
; This version has no side effects and simply returns a TruthValue
; -----------------------------------------------------------------------------


(define (pln-formula-simple-epistemic-equivalence-side-effect-free EquivalenceLink(A B))
    (let 
        (epsilon=0.05)
        ((sAB (cog-stv-strength (EquivalenceLink (A B)))
        )
         (cAB (cog-stv-confidence (EquivalenceLink (A B) ))))
            (stv (sAB*(1-epsilon))) (cAB))) 
