;==============================================================================
; Abduction Rule
;
; AND(Inheritance A C, Inheritance B C) entails Inheritance A B
;------------------------------------------------------------------------------
(load "formulas.scm")
(define pln-rule-abduction
	(BindLink
		(VariableList
			(VariableNode "$A")
			(VariableNode "$B")
			(VariableNode "$C"))
		(AndLink
			(InheritanceLink
				(VariableNode "$A")
				(VariableNode "$C"))
			(InheritanceLink
				(VariableNode "$B")
				(VariableNode "$C"))
			; To avoid matching (Inheritance A C) and (Inheritance A C)
			(NotLink
				(EqualLink
					(VariableNode "$A")
					(VariableNode "$B"))))
		(ExecutionOutputLink
			(GroundedSchemaNode "scm: pln-formula-abduction")
			(ListLink
				(InheritanceLink
					(VariableNode "$A")
					(VariableNode "$B"))
				(InheritanceLink
					(VariableNode "$A")
					(VariableNode "$C"))
				(InheritanceLink
					(VariableNode "$B")
					(VariableNode "$C"))))))

; -----------------------------------------------------------------------------
; Abduction Formula
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Side-effect: TruthValue of AB may be updated
; -----------------------------------------------------------------------------

(define (pln-formula-abduction AB AC BC)
	(cog-set-tv!
		AB
		(pln-formula-abduction-side-effect-free
			AB
			AC
			BC
			(gar AB)
			(gar BC)
			(gdr AC))))
; -----------------------------------------------------------------------------
; This version has no side effects and simply returns a TruthValue
; -----------------------------------------------------------------------------

(define (pln-formula-abduction-side-effect-free AB AC BC A B C)
	(let
		(
			(sCB (inversion-formula 
				(cog-stv-strength BC)
				(cog-stv-strength B) 
				(cog-stv-strength C)))
			(sAC (cog-stv-strength AC))
			(sC (cog-stv-strength C))
			(sB (cog-stv-strength B))
			(sA (cog-stv-strength A)))
		(stv 
			(simple-deduction-formula sA sC sB sAC sCB) ;Strength
                	(min
                    		(cog-stv-confidence AB)
                    		(cog-stv-confidence BC))))) ; Confidence

; =============================================================================

; Name that rule
(define pln-rule-abduction-name (Node "pln-rule-abduction"))
(DefineLink pln-rule-abduction-name pln-rule-abduction)
