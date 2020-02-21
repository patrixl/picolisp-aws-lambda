(de send-error-response
   (prinl "Error at: " (str ^))
      (let (Curl (make
                    (link 'curl "--silent" "--show-error" "--location" "-X" "POST"
                       (pack "http://" *Aws_lambda_runtime_api "/2018-06-01/runtime/invocation/" *Request_id "/error")
                       "-d" (json-encode (list (cons "errorMessage" (pack "Error at: " (str ^)))
                                            (cons "errorType" "Runtime") ) )
                       "--header" "Lambda-Runtime-Function-Error-Type: Runtime" ) ) )
         (in Curl (till NIL T)) ) )

(de get-event-data (Url Temp)
   (json-decode
      (in (make (link 'curl "--silent" "--show-error" "--location" "--dump-header" Temp "-X" "GET" Url ) )
         (till NIL T) ) ) )

(de parse-headers (Temp)
   (mapcar '((L) (mapcar '((A) (pack (clip A))) (split L ":"))) (split (chop (in Temp (till NIL T))) "^J")) )

(de eval-function (Function Event_data Headers)
   (eval (append (str (pack Function)) (quote Event_data) (quote Headers))) )

(de send-response (Url Response)
   (in (make (link 'curl "--silent" "--show-error" "--location" "-X" "POST" "-d" Response Url))
      (till NIL T) ) )

(de get-request-id (Headers)
   (cadr (assoc "Lambda-Runtime-Aws-Request-Id" Headers)) )
