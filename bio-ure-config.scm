;
; Configuration file for bio reasoning experiments
;

(load "opencog/reasoning/pln/rules/deduction.scm")
;(load "opencog/reasoning/pln/rules/modus-ponens.scm")
(load "opencog/reasoning/pln/rules/member-to-inheritance-rule.scm")
(load "opencog/reasoning/pln/rules/inheritance-to-member-rule.scm")
;(load "opencog/reasoning/pln/rules/abduction.scm")

; Define a new rule base (aka rule-based system)
(InheritanceLink
   (ConceptNode "bio-rule-base")
   (ConceptNode "URE")
)

; Associate the rules to the rule base (with weights, their semantics
; is currently undefined, we might settled with probabilities but it's
; not sure)
(MemberLink (stv 0.5 1)
   pln-rule-deduction
   (ConceptNode "bio-rule-base")
)
;(MemberLink (stv 0.5 1)
;   pln-rule-modus-ponens
;   (ConceptNode "bio-rule-base")
;)

(MemberLink (stv 0.5 1)
   pln-rule-member-to-inheritance
   (ConceptNode "bio-rule-base")
)

(MemberLink (stv 0.5 1)
   pln-rule-inheritance-to-member
   (ConceptNode "bio-rule-base")
)

;(MemberLink (stv 0.5 1)
;   pln-rule-abduction
;   (ConceptNode "bio-rule-base")
;)

; Termination criteria parameters
(ExecutionLink
   (SchemaNode "URE:maximum-iterations")
   (ConceptNode "bio-rule-base")
   (NumberNode "10")
)

; Attention allocation (set the TV strength to 0 to disable it, 1 to
; enable it)
(EvaluationLink (stv 0 1)
   (PredicateNode "URE:attention-allocation")
   (ConceptNode "bio-rule-base")
)


(define biorules (ConceptNode "bio-rule-base"))

