(import :gerbil/expander :std/swank/api :std/swank/message)
(export #t)

(def (swank-context (:mod (current-slime-package)))
  (def cxt
    (identity ;; make-top-context
     (cond
      ((string? :mod)
       (if (string=? "TOP" :mod)
	 (gx#current-expander-context)
	 (swank-context
	  (string->symbol (string-append ":" :mod)))))
      ((not :mod) (gx#current-expander-context))
      ((symbol? :mod) (gx#import-module :mod #f #t))
      (else (error "Unknown Module" :mod)))))
  (parameterize ((gx#current-expander-context cxt))
    ;; TODO: This should be a shadow context or something.
    (gx#eval-syntax '(extern namespace: #f
		       swank:lookup-presented-object
		       swank:lookup-presented-object-or-lose
		       swank:get-presented-object
		       repl-result-history-ref))) 
  cxt)

(def (swank-eval-in-context form (cxt-name (current-slime-package)))
  (parameterize ((gx#current-expander-context (swank-context cxt-name)))
    (eval form)))

(def (list-all-context-names)
  (##list-sort
   string<?
   ["TOP"
    (map
      (lambda (cxt)
	(symbol->string (gx#expander-context-id cxt)))
      (filter gx#module-context?
	      (map cdr
		   (hash->list
		    (gx#current-expander-module-registry)))))
    ...]))

(def-swank (swank:list-all-package-names . _)
  (list-all-context-names))

(def-swank (swank:set-package name)
  [name (if (equal? name "TOP") "TOP"
	    (string-append ":" name))])

