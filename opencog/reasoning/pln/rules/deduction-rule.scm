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

(use-modules (opencog logger))

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

(define deduction-intensional-implication-rule
    (gen-deduction-rule IntensionalImplicationLink))

#!
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
                (IntensionalImplicationLink
                    (VariableNode "$A")
                    (VariableNode "$B"))
                (IntensionalImplicationLink
                    (VariableNode "$B")
                    (VariableNode "$C"))
                (IntensionalImplicationLink
                    (VariableNode "$A")
                    (VariableNode "$C"))))))
!#

; Name the rule
(define deduction-intensional-implication-rule-name
    (Node "deduction-intensional-implication-rule"))
(DefineLink deduction-intensional-implication-rule-name
    deduction-intensional-implication-rule)


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

       ;(display "\ndeduction-formula:  \n")
       ;(display "A = ") (gar AB) (newline)
       ;(display "B = ") (gar BC) (newline)
       ;(display "C = ") (gdr BC) (newline)
       ;(display "sA = ") (display sA) (newline)
       ;(display "sB = ") (display sB) (newline)
       ;(display "sC = ") (display sC) (newline)
       ;(display "sAB = ") (display sAB) (newline)
       ;(display "sBC = ") (display sBC) (newline)
       ;(display "cAB = ") (display cAB) (newline)
       ;(display "cBC = ") (display cBC) (newline)
       ;(display "strength = ") (display (simple-deduction-strength-formula sA sB sC sAB sBC))(newline)
       ;(display ", confidence = ") (display confidence)

        (cog-merge-hi-conf-tv!
            AC
            (stv
                (if (< 0.99 (* sAB sBC cAB cBC))
                    ;; Hack to make it up for the lack of
                    ;; distributional TV. This cover the case where
                    ;; little is known about A and B (i.e. their
                    ;; strength is meaningless), yet we can
                    ;; confidently calculate sAC because sAB and sBC
                    ;; are so high anyway.
                    (* sAB sBC)
                    ;; Otherwise fall back on the naive formula
                    (simple-deduction-strength-formula sA sB sC sAB sBC))
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
