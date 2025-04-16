#lang racket

(require web-server/servlet
         web-server/servlet-env)

;; Helper to safely check if 'name exists and extract it
(define (extract-name req)
  (define bindings (request-bindings req))
  (define name-value
    (with-handlers ([exn:fail? (lambda (_) #f)])
      (extract-binding/single 'name bindings)))
  (if name-value
      `(p "Hello, " ,name-value "!")
      `(p "Who are you? Please tell us your name.")))

(define (start req)
  (response/xexpr
   `(html
     (head
       (title "Test Web App")
       (link ((rel "stylesheet") (href "/static/style.css"))))
     (body
       (h1 "Welcome to the Test Web App!")
       (p "Ask: Who am I?")
       (form ((action "/") (method "get"))
         (input ((type "text") (name "name") (placeholder "Enter your name")))
         (button ((type "submit")) "Submit"))
       ,(extract-name req)))))

(serve/servlet start
               #:servlet-path "/"
               #:launch-browser? #f
               #:port 8000
               #:servlet-regexp #rx""
               #:extra-files-paths (list (build-path "." "static")))
