; =============================================================================
; DeductionRule
; 
; AndLink
;   LinkType
;       A
;       B
;   LinkType
;       B
;       C
; |-
; LinkType
;   A
;   C
;
; Due to pattern matching issues, currently the file has been divided into 3 
; parts, each pertaining to different links. The rules are :-
;       deduction-inheritance-rule
;       deduction-implication-rule
;       deduction-subset-rule
;
; -----------------------------------------------------------------------------
(load "formulas.scm")

(define deduction-inheritance-rule
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C")
            (InheritanceLink
                (VariableNode "$A")
                (VariableNode "$B"))
            (InheritanceLink
                (VariableNode "$B")
                (VariableNode "$C")))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: deduction-formula")
            (ListLink
                (VariableNode "$A")
                (VariableNode "$B")
                (VariableNode "$C")
                (InheritanceLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (InheritanceLink
                    (VariableNode "$B")
                    (VariableNode "$C"))
                (InheritanceLink
                    (VariableNode "$A")
                    (VariableNode "$C"))))))

(define deduction-implication-rule
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C")
            (ImplicationLink
                (VariableNode "$A")
                (VariableNode "$B"))
            (ImplicationLink
                (VariableNode "$B")
                (VariableNode "$C"))
            ; To avoid matching (Inheritance A B) and (Inheritance B A)
            (NotLink
                (EqualLink
                    (VariableNode "$A")
                    (VariableNode "$C"))))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: deduction-formula")
            (ListLink
                (VariableNode "$A")
                (VariableNode "$B")
                (VariableNode "$C")
                (ImplicationLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (ImplicationLink
                    (VariableNode "$B")
                    (VariableNode "$C"))
                (ImplicationLink
                    (VariableNode "$A")
                    (VariableNode "$C"))))))

;; Todo: There are 2 copies of this now--one in deduction.scm and one in
;;       deduction-rule.scm
(define pln-rule-deduction-intensional-implication
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C")
            (IntensionalImplicationLink
                (VariableNode "$A")
                (VariableNode "$B"))
            (IntensionalImplicationLink
                (VariableNode "$B")
                (VariableNode "$C")))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: deduction-formula")
            (ListLink
                (VariableNode "$A")
                (VariableNode "$B")
                (VariableNode "$C")
                (IntensionalImplicationLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (IntensionalImplicationLink
                    (VariableNode "$B")
                    (VariableNode "$C"))
                (IntensionalImplicationLink
                    (VariableNode "$A")
                    (VariableNode "$C"))))))


; Name the rule
(define pln-rule-deduction-intensional-implication-name
    (Node "pln-rule-deduction-intensional-implication"))
(DefineLink pln-rule-deduction-intensional-implication-name
    pln-rule-deduction-intensional-implication)


(define deduction-subset-rule
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C")
            (SubsetLink
                (VariableNode "$A")
                (VariableNode "$B"))
            (SubsetLink
                (VariableNode "$B")
                (VariableNode "$C")))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: deduction-formula")
            (ListLink
                (VariableNode "$A")
                (VariableNode "$B")
                (VariableNode "$C")
                (SubsetLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (SubsetLink
                    (VariableNode "$B")
                    (VariableNode "$C"))
                (SubsetLink
                    (VariableNode "$A")
                    (VariableNode "$C"))))))

(define (deduction-formula A B C AB BC AC)
    (let
        ((sA (cog-stv-strength A))
         (cA (cog-stv-confidence A))
         (sB (cog-stv-strength B))
         (cB (cog-stv-confidence B))
         (sC (cog-stv-strength C))
         (cC (cog-stv-confidence C))
         (sAB (cog-stv-strength AB))
         (cAB (cog-stv-confidence AB))
         (sBC (cog-stv-strength BC))
         (cBC (cog-stv-confidence BC)))
       (display "\ndeduction-formula:\n")
       (display "A = ") (display A) (newline)
       (display "B = ") (display B) (newline)
       (display "C = ") (display C) (newline)
       (display "sA = ") (display sA) (newline)
       (display "sB = ") (display sB) (newline)
       (display "sC = ") (display sC) (newline)
       (display "sAB = ") (display sAB) (newline)
       (display "sBC = ") (display sBC) (newline)
       (display "cAB = ") (display cAB) (newline)
       (display "cBC = ") (display cBC) (newline)
       (display "strength = ") (display (simple-deduction-strength-formula sA sB sC sAB sBC))(newline)
       ;(display ", confidence = ") (display confidence)

        (cog-set-tv!
            AC
            (stv
                (simple-deduction-strength-formula sA sB sC sAB sBC) 
                (min cAB cBC)))))
