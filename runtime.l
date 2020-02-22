(de init-runtime ()
   (setq *Handler (sys "_HANDLER")
      *Aws_region  (sys "AWS_REGION")
      *Aws_execution_env  (sys "AWS_EXECUTION_ENV")
      *Aws_function_name  (sys "AWS_LAMBDA_FUNCTION_NAME")
      *Aws_lambda_function_memory_size  (sys "AWS_LAMBDA_FUNCTION_MEMORY_SIZE")
      *Aws_lambda_function_version  (sys "AWS_LAMBDA_FUNCTION_VERSION")
      *Aws_loggroup_name  (sys "AWS_LAMBDA_LOG_GROUP_NAME")
      *Aws_logstream_name  (sys "AWS_LAMBDA_LOG_STREAM_NAME")
      *Aws_access_key  (sys "AWS_ACCESS_KEY_ID")
      *Aws_secret_key  (sys "AWS_SECRET_ACCESS_KEY")
      *Aws_session_token  (sys "AWS_SESSION_TOKEN")
      *Lambda_task_root  (sys "LAMBDA_TASK_ROOT")
      *Lambda_runtime_dir  (sys "LAMBDA_RUNTIME_DIR")
      *Aws_lambda_runtime_api  (sys "AWS_LAMBDA_RUNTIME_API")
      *Tz  (sys "TZ")

      *Lang (sys "LANG")
      *Path (sys "PATH")
      *Ld_library_path (sys "LD_LIBRARY_PATH")

      *Request_id NIL ) )

(de *Err
   (prinl "Error at: " (str ^))
      (let (Curl (make
                    (link 'curl "--silent" "--show-error" "--location" "-X" "POST"
                       (pack "http://" *Aws_lambda_runtime_api "/2018-06-01/runtime/invocation/" *Request_id "/error")
                       "-d" (json-encode (list (cons "errorMessage" (pack "Error at: " (str ^)))
                                            (cons "errorType" "Runtime") ) )
                       "--header" "Lambda-Runtime-Function-Error-Type: Runtime" ) ) )
         (in Curl (till NIL T)) ) )

(de make-temp ()
   (in '(mktemp) (till "^J" T)) )

(de get-event-data (Url Temp)
   (json-decode
      (in (make (link 'curl "--silent" "--show-error" "--location" "--dump-header" Temp "-X" "GET" Url ) )
         (till NIL T) ) ) )

(de parse-headers (Raw)
   (mapcar '((L) (mapcar '((E) (pack (clip E))) (split L ":") ) )
      (split (chop Raw) "^J") ) )

(de get-script-name (Root Handler)
   (pack Root "/" (car (mapcar pack (split (chop Handler) "."))) ".l") )

(de get-function-name (Handler)
   (cadr (mapcar pack (split (chop Handler) "."))))

(de eval-function (Function Event_data Headers)
   (eval (append (str (pack Function)) (quote Event_data) (quote Headers))) )

(de send-response (Url Response)
   (in (make (link 'curl "--silent" "--show-error" "--location" "-X" "POST" "-d" Response Url))
      (till NIL T) ) )

(de get-request-id (Headers)
   (cadr (assoc "Lambda-Runtime-Aws-Request-Id" Headers)) )
