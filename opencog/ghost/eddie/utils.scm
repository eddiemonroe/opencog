; Ghost startup stuff

(use-modules (opencog)
             (opencog nlp)
             (opencog nlp relex2logic)
             (opencog openpsi)
             (opencog attention)
             (opencog eva-behavior)
             (opencog ghost)
             (opencog ghost procedures))

; (add-to-load-path "/home/eddie/hansonrobotics/opencog/loving-ai-ghost")


; load ghost file manually for access to local variables
; (load-from-path

(ecan-based-ghost-rules #t)
(set-relex-server-host)
(ghost-run)


; opencog shortcusts
(define incoming cog-incoming-set)
(define outgoing cog-outgoing-set)




; ghost shortcuts

(define gpf ghost-parse-file)
(define gp ghost-parse)
(define g ghost)




(define default-goal (ConceptNode "GHOST Default Goal"))
(define goal  (ConceptNode "goal"))

(define say test-ghost)


(define-public (scm-test)
    (display "yay!!!! very nice")
    "hello there"
)

; Auto Load Ghost Files for Testing
; (gpf "eddie/meditation.gst")
(gpf "/home/eddie/hansonrobotics/opencog/loving-ai-ghost/variables.ghost")
; (gpf "/home/eddie/hansonrobotics/opencog/loving-ai-ghost/introduction.ghost")
(gpf "/home/eddie/hansonrobotics/opencog/loving-ai-ghost/awareness_practice_1.ghost")



