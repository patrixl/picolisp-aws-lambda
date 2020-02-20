(de main (Event_data Headers)
   (println (json-decode "{\"Hello\":\"World\"}"))
   (prinl (json-encode '(("Hello" . "World"))))
   (let (*Aws_region "us-east-1" # temp override the region
         *Aws_query  "Action=DescribeRegions&Version=2013-10-15" )
      (prinl (awscurl-start)) )
   (prin "Headers: ") (println Headers)
   (prinl "Event_data: " Event_data) )
