; Certainty psi-demand definition
(InheritanceLink
    ; The strength of the stv is the demand-value, & confidence is always 1.
    (ConceptNode "OpenPsi: Certainty" (stv .6 1))
    (ConceptNode "OpenPsi: Demand")
)

(EvaluationLink
    (PredicateNode "must_have_value_within")
    (ListLink
        (ConceptNode "OpenPsi: Certainty")
        (NumberNode .8)
        (NumberNode 1.)
    )
)

; actions that can act on the psi-demand Competence.
(EvaluationLink
    (PredicateNode "Psi: acts-on")
    (ListLink
        ; This is the default function that each psi-demand must have.
        (GroundedSchemaNode "scm: psi-demand-updater")
        (ConceptNode "OpenPsi: Certainty")
    )
)
