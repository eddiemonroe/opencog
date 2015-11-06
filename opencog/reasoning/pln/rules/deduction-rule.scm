;; =============================================================================
;; DeductionRule
;;
;; <LinkType>
;;   A
;;   B
;; <LinkType>
;;   B
;;   C
;; |-
;; <LinkType>
;;   A
;;   C
;;
;; Due to type system limitations, the rule has been divided into 3:
;;       deduction-inheritance-rule
;;       deduction-implication-rule
;;       deduction-subset-rule
;;
;; -----------------------------------------------------------------------------
(load "formulas.scm")

;; Generate the corresponding deduction rule given its link-type.
(define (gen-deduction-rule link-type)
    (BindLink
        (VariableList
            (VariableNode "$A")
            (VariableNode "$B")
            (VariableNode "$C"))
        (AndLink
            (link-type
                (VariableNode "$A")
                (VariableNode "$B"))
            (link-type
                (VariableNode "$B")
                (VariableNode "$C"))
            (NotLink
                (EqualLink
                    (VariableNode "$A")
                    (VariableNode "$C")
                )))
        (ExecutionOutputLink
            (GroundedSchemaNode "scm: deduction-formula")
            (ListLink
                (link-type
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (link-type
                    (VariableNode "$B")
                    (VariableNode "$C"))
                (link-type
                    (VariableNode "$A")
                    (VariableNode "$C"))))))


(define deduction-inheritance-rule
    (gen-deduction-rule InheritanceLink))

(define deduction-implication-rule
    (gen-deduction-rule ImplicationLink))

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
    (gen-deduction-rule SubsetLink))

(define (deduction-formula AB BC AC)
    (let
        ((sA (cog-stv-strength (gar AB)))
         (cA (cog-stv-confidence (gar AB)))
         (sB (cog-stv-strength (gar BC)))
         (cB (cog-stv-confidence (gar BC)))
         (sC (cog-stv-strength (gdr BC)))
         (cC (cog-stv-confidence (gdr BC)))
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

;; Name the rules
(define deduction-inheritance-rule-name
  (Node "deduction-inheritance-rule"))
(DefineLink deduction-inheritance-rule-name
  deduction-inheritance-rule)

(define deduction-implication-rule-name
  (Node "deduction-implication-rule"))
(DefineLink deduction-implication-rule-name
  deduction-implication-rule)

(define deduction-subset-rule-name
  (Node "deduction-subset-rule"))
(DefineLink deduction-subset-rule-name
  deduction-subset-rule)
