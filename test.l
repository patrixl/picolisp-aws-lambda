(load (pack (car (file)) ".modules/picolisp-unit/HEAD/unit.l"))
(load (pack (car (file)) ".modules/picolisp-json/HEAD/json.l"))
(load (pack (car (file)) ".modules/picolisp-awscurl/HEAD/libawscurl.l"))
(load "@lib/http.l")
(load "runtime.l")

# Some useful values
(de init-test-sys ()
   (setq *Port (format (or (sys "_PICOLISP_AWS_LAMBDA_PORT") "8080")))
   (sys "_HANDLER" "example.main")
   (sys "LAMBDA_TASK_ROOT" ".")
   (sys "LAMBDA_RUNTIME_DIR" ".")
   (sys "AWS_LAMBDA_RUNTIME_API" (pack "localhost:" (format *Port))) )

# Mock server
(de start-mock-server (Port File)
   (unless (fork)
      (server Port File) ) )

# Mock data
(de make-mock-headers ()
   '(("Lambda-Runtime-Aws-Request-Id" "1234567890abcdef")
     ("Key1" "Value1")
     ("Key2" "Value2")) )

(de make-mock-raw-headers ()
   "Lambda-Runtime-Aws-Request-Id: 1234567890abcdef^JKey1: Value1^JKey2: Value2" )

(de make-mock-event-data ()
   '(("Key1" . "Value1") ("Key2" . "Value2") ("Key3" . "Value3")) )

# Define the tests
(de test-event-data ()
   (let Temp (make-temp)
      (finally
         (prog
            (call 'rm Temp)
            (mapcar kill (kids)) )
         (start-mock-server *Port "test/event.json")
         (assert-equal
            (make-mock-event-data)
            (get-event-data (pack "http://" *Aws_lambda_runtime_api) Temp)
            "Event data is obtained and decoded" ) ) ) )

(de test-header-parsing ()
   (assert-equal (parse-headers (make-mock-raw-headers))
      (make-mock-headers)
      "Headers are correctly parsed from the Temporary file" ) )

(de test-request-id-parsing ()
   (assert-equal
      (get-request-id (make-mock-headers))
      "1234567890abcdef"
      "Request ID is properly parsed") )

(de test-get-script ()
   (assert-equal (get-script-name *Lambda_task_root *Handler)
      "./example.l"
      "Ensure script filename is properly parsed") )

(de test-get-function ()
   (assert-equal (get-function-name *Handler) "main"
      "Function name is properly parsed") )

(de test-eval-function ()
   (assert-equal
      (prog
         (load (get-script-name *Lambda_task_root *Handler))
         (eval-function (get-function-name *Handler) (make-mock-event-data)
            (make-mock-headers) ) )
      (make-mock-event-data)
      "Example function returns the event data as-is" ) )

(de test-runtime ()
   (init-test-sys)
   (init-runtime)
   (execute
      '(test-event-data)
      '(test-header-parsing)
      '(test-request-id-parsing)
      '(test-get-script)
      '(test-get-function)
      '(test-eval-function) )

   (prinl "^J PicoLisp Runtime for AWS Lambda ^J")
   (report) )
