; Tihs rule is for sentential complements following propositional attitude verbs, such as 
; "I know that you lied to me." or "I imagine you will make a fine garbage man someday, son."
; It hooks up know to that, and imagine to will in the sentences above.
; this relation exists so that someday OpenCog will understand that the situations described
; in the sentences following propositional attitude verbs must be interpreted as 'representations'
; rather than 'reality' which means that you can't infer anything about reality from them. 
; look up Jackendoff's writing on this subject if  you wish to understand more . . . 
; (AN June 2015)


(define rep
    (BindLink
        (VariableList
            (TypedVariableLink
                (VariableNode "$a-parse")
                (TypeNode "ParseNode")
            )
            (TypedVariableLink
                (VariableNode "$pred")
                (TypeNode "WordInstanceNode")
            )
            (TypedVariableLink
                (VariableNode "$comp")
                (TypeNode "WordInstanceNode")
            )
        )
        (AndLink
            (WordInstanceLink
                (VariableNode "$pred")
                (VariableNode "$a-parse")
            )
            (WordInstanceLink
                (VariableNode "$comp")
                (VariableNode "$a-parse")
            )
            (EvaluationLink
                (DefinedLinguisticRelationshipNode "_rep")
                (ListLink
                    (VariableNode "$pred")
                    (VariableNode "$comp")     
                )
            )
        )
        (ExecutionOutputLink
       	   (GroundedSchemaNode "scm: pre-rep-rule")
       	      (ListLink
       	        (VariableNode "$comp")  
		(VariableNode "$pred")         	         
            )
        )
    )
)

(InheritanceLink (stv 1 .99) (ConceptNode "rep-Rule") (ConceptNode "Rule"))

(ReferenceLink (stv 1 .99) (ConceptNode "rep-Rule") comp)

; This is function is not needed. It is added so as not to break the existing
; r2l pipeline.
(define (pre-rep-rule comp pred)
    	(rep-rule
		(word-inst-get-word-str comp) (cog-name comp)
		(word-inst-get-word-str pred) (cog-name pred)		              
	)
)


