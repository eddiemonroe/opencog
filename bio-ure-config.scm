;
; URE Configuration file for PLN
;
; Before running any PLN inference you must load that file in the
; AtomSpace
;
; In order to add new rules you need to hack this file in 2 places
;
; 1. In the Load rules section, to add the file name where the rule is
; defined (see define rule-files).
;
; 2. In the Associate rules to PLN section, to add the name of the
; rule and its weight (see define rules).

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load required modules and utils ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-modules (opencog))
(use-modules (opencog rule-engine))

(load-from-path "utilities.scm")
(load-from-path "av-tv.scm")
(load-from-path "rule-engine-utils.scm")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define PLN rule-based system ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define bio-rbs (ConceptNode "bio-rbs"))
(InheritanceLink
   bio-rbs
   (ConceptNode "URE")
)

; Define pln-fc and pln-bc for convenience 
(define (bio-fc source) (cog-fc source bio-rbs))
(define (bio-bc target) (cog-bc target bio-rbs))

;;;;;;;;;;;;;;;;
;; Load rules ;;
;;;;;;;;;;;;;;;;
(add-to-load-path "/home/eddie/opencog/opencog/opencog/reasoning/pln/")
; Load the rules (use load for relative path w.r.t. to that file)
(define rule-files (list "rules/deduction.scm"
                         ; "rules/modus-ponens.scm"
                         "rules/member-to-inheritance-rule.scm"))
;(define rule-files (list "../opencog/reasoning/pln/rules/deduction.scm"
;                         "../opencog/reasoning/pln/rules/modus-ponens.scm"))
(for-each load-from-path rule-files)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Associate rules to PLN ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; List the rules and their weights.
(define rules (list (list pln-rule-deduction-name 1)
                    ; (list pln-rule-modus-ponens-name 1)
                    (list pln-rule-member-to-inheritance-name 1))
)

; Associate rules to PLN
(ure-add-rules bio-rbs rules)

;;;;;;;;;;;;;;;;;;;;;
;; Other paramters ;;
;;;;;;;;;;;;;;;;;;;;;

; Termination criteria parameters
(ure-set-num-parameter bio-rbs "URE:maximum-iterations" 20)

; Attention allocation (0 to disable it, 1 to enable it)
(ure-set-fuzzy-bool-parameter bio-rbs "URE:attention-allocation" 0)
