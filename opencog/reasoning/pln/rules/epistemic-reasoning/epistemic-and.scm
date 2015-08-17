
(define pln-rule-epistemic-and
  (BindLink
   (VariableList
    (VariableNode "$A")
    (VariableNode "$B"))
   (EAndLink
    (VariableNode "$A")
    (VariableNode "$B"))
   (ExecutionOutputLink
    (GroundedSchemaNode "scm: pln-formula-epistemicand")
    (ListLink
     (VariableNode "$A")
     (VariableNode "$B")))))

(define (pln-formula-epistemic-and A B)
  (cog-set-tv!
   (EAndLink A B)
   (pln-formula-epistemic-and-side-effect-free A B))
)

(define (pln-formula-epistemic-and-side-effect-free A B)
  (let 
      ((sA (cog-stv-strength A))
       (sB (cog-stv-strength B))
       (cA (cog-stv-confidence A))
       (cB (cog-stv-confidence B)))
    (stv ( max (sA+sB-1 0)) (min cA cB))))
