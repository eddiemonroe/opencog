;
; utilities.scm
;
; Assorted utilties for checking R2L outputs.
;

; -----------------------------------------------------------------------
; r2l-get-root -- Return all hypergraph R2L roots containing 'atom'
;
; Similar to cog-get-root, except that it will stop at the SetLink in case
; RelEx2Logic is called with the r2l(...) function.
;
(define (r2l-get-root atom)
	(define iset (cog-incoming-set atom))
	
	; if reached the SetLink that wrap around R2L outputs (happens when using r2l(...))
	(if (and (= (length iset) 1) (equal? 'SetLink (cog-type (car iset))))
		(list atom)
		; if no incoming set (happens when using relex-parse(...))
		(if (null? iset)
			(list atom)
			(append-map r2l-get-root iset)
		)
	)
)

; -----------------------------------------------------------------------
; r2l-get-word-inst -- Retrieve WordInstanceNode given R2L style node
;
; Given a R2L style node, find the corresponding WordInstanceNode.
;
(define (r2l-get-word-inst node)
	(cond ((null? node) '())
	      ((has-word-inst? node) (car (cog-chase-link 'ReferenceLink 'WordInstanceNode node)))
	      (else '())
	)
)

; -----------------------------------------------------------------------
; r2l-get-word -- Retrieve WordNode given R2L style node
;
; Given a R2L style node, find the corresponding WordNode.  Skipping
; WordInstanceNode since maybe it is not an instanced word.
; TODO: update this when non-instanced R2L node are linked to WordNode
;
(define (r2l-get-word node)
	(cond ((null? node) '())
	      ((has-word? node) (cog-node 'WordNode (cog-name node)))
	      (else '())
	)
)

; -----------------------------------------------------------------------
; r2l-get-interp -- Retrieve the InterpretationNode given SetLink.
;
; Returns the InterpretationNode associated with the SetLink.
;
(define (r2l-get-interp a-set-link)
	(car (cog-chase-link 'ReferenceLink 'InterpretationNode a-set-link))
)

; -----------------------------------------------------------------------
; has-word-inst? -- Check if a node has the corresponding WordInstanceNode
;
; Return #t or #f depends on whether the node has a WordInstanceNode.
;
(define (has-word-inst? node)
	(not (null? (cog-chase-link 'ReferenceLink 'WordInstanceNode node)))
)

; -----------------------------------------------------------------------
; has-word? -- Check if a node has the corresponding WordNode
;
; Return #t or #f depends on whether the node has a WordNode.
; TODO: update this when non-instanced R2L node are linked to WordNode
;
(define (has-word? node)
	(not (null? (cog-node 'WordNode (cog-name node))))
)

; -----------------------------------------------------------------------
; is-r2l-inst? -- Check if a node is a R2L instanced node.
;
; Return #t or #f depends on whether the node is instanced.  VariableNode
; is also instanced node.
;
(define (is-r2l-inst? node)
	(or (equal? 'VariableNode (cog-type node)) (has-word-inst? node))
)

; -----------------------------------------------------------------------
; is-r2l-abstract? -- Check if a node is a R2L abstract node.
;
; Return #t or #f depends on whether the node is the abstract version.
;
(define (is-r2l-abstract? node)
	(has-word? node)
)

