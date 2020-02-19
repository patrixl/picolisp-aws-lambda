# Load aw's json and awscurl libraries
(load "@json/json.l" "@awscurl/libawscurl.l")

(de main (EventData . Headers)
   (println (json-decode "{\"Hello\":\"World\"}"))
   (prinl (json-encode '(("Hello" . "World"))))
   (setq *Aws_query "Action=DescribeRegions&Version=2013-10-15")
   (prinl (awscurl-start))
   (prin "Headers: ") (println Headers)
   (prinl "EventData: " EventData) )
