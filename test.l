(load (pack (car (file)) ".modules/picolisp-unit/HEAD/unit.l"))

(load "runtime.l")

# Some useful values
(setq Port (or (sys "_PICOLISP_AWS_LAMBDA_PORT") "8080"))
(sys "_HANDLER" "example.main")
(sys "LAMBDA_TASK_ROOT" (car (file)))
(sys "LAMBDA_RUNTIME_DIR" (car (file)))
(sys "AWS_LAMBDA_RUNTIME_API" (sys (pack "localhost:" Port)))

(init)

# Start the mock server

# Define the tests
(de test-event-data ()
   (finally (call 'rm Temp)
      (let Temp (make-temp)
         (assert-equal
            '(("Key1" . "Value1") ("Key2" . "Value2") ("Key3" . "Value3"))
            (get-event-data (pack "http://" *Aws_lambda_runtime_api "/event")) ) ) ) )

(de test-send-response ())

(de test-send-error ())

(de test-header-parsing ())

(de test-request-id-parsing ())

(de test-load-handler ())

(de test-eval-function ())

(execute
   '(test-event-data)
   '(test-send-response)
   '(test-send-error)
   '(test-header-parsing)
   '(test-request-id-parsing)
   '(test-load-handler)
   '(test-event-data) )
