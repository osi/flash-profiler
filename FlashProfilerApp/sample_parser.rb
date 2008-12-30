class SampleParser
  @@shell = /^\[(\w+)(.+)\]$/m
  
  def self.parse(text)
    m = @@shell.match(text)

    # The 'time' field is crap. the relative values are okay though, so the times can be adjusted to be
    # relative to the first item
    
    # TODO take in the crap time to use as the first, in order to determine an offset
    # TODO set an actual time based on when we started sampling

    case m[1]
    when "NewObjectSample"
      NewObjectSample.parse m[2]
    when "Sample"
      CpuSample.parse m[2]
    when "DeleteObjectSample"
      DeleteObjectSample.parse m[2]
    else
      raise "Unknown sample type #{m[1]} -- #{text}"
    end
  end
end

=begin
require "new_object_sample"
require "delete_object_sample"
require "cpu_sample"
require "stack_frame"

samples = <<-EOF
[NewObjectSample
   time: 716228101642
     id: 1
   type: flash.events::ProgressEvent
]
[NewObjectSample
   time: 716228101732
     id: 2
   type: String
  stack: 
    flash.utils::ByteArray/readUTFBytes()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228101738
     id: 3
   type: flash.events::DataEvent
  stack: 
    flash.net::XMLSocket/scanAndSendEvent()
]
[Sample
   time: 716228103778
  stack: 
    flash.events::DataEvent/get data()
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228103785
     id: 4
   type: Date
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228103807
     id: 5
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228103808
     id: 6
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228103809
     id: 7
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228103814
     id: 8
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716228103815
     id: 9
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[DeleteObjectSample
   time: 716228103862
     id: 1
   size: 40
]
[NewObjectSample
   time: 716229101641
     id: 10
   type: flash.events::ProgressEvent
]
[NewObjectSample
   time: 716229101700
     id: 11
   type: String
  stack: 
    flash.utils::ByteArray/readUTFBytes()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229101713
     id: 12
   type: flash.events::DataEvent
  stack: 
    flash.net::XMLSocket/scanAndSendEvent()
]
[Sample
   time: 716229101742
  stack: 
    global/trace()
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[Sample
   time: 716229104110
  stack: 
    flash.events::DataEvent/get data()
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229104119
     id: 13
   type: Date
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229104142
     id: 14
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229104143
     id: 15
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229104145
     id: 16
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229104148
     id: 17
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716229104149
     id: 18
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[DeleteObjectSample
   time: 716229104196
     id: 10
   size: 40
]
[NewObjectSample
   time: 716230101728
     id: 19
   type: flash.events::ProgressEvent
]
[NewObjectSample
   time: 716230101784
     id: 20
   type: String
  stack: 
    flash.utils::ByteArray/readUTFBytes()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230101794
     id: 21
   type: flash.events::DataEvent
  stack: 
    flash.net::XMLSocket/scanAndSendEvent()
]
[Sample
   time: 716230103541
  stack: 
    flash.events::DataEvent/get data()
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230103548
     id: 22
   type: Date
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230103568
     id: 23
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230103569
     id: 24
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230103571
     id: 25
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230103573
     id: 26
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716230103574
     id: 27
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[DeleteObjectSample
   time: 716230103617
     id: 19
   size: 40
]
[NewObjectSample
   time: 716231101892
     id: 28
   type: flash.events::ProgressEvent
]
[NewObjectSample
   time: 716231101948
     id: 29
   type: String
  stack: 
    flash.utils::ByteArray/readUTFBytes()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231101953
     id: 30
   type: flash.events::DataEvent
  stack: 
    flash.net::XMLSocket/scanAndSendEvent()
]
[Sample
   time: 716231104116
  stack: 
    flash.events::DataEvent/get data()
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231104125
     id: 31
   type: Date
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231104153
     id: 32
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231104155
     id: 33
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231104156
     id: 34
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231104159
     id: 35
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716231104160
     id: 36
   type: String
  stack: 
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[DeleteObjectSample
   time: 716231104210
     id: 28
   size: 40
]
[NewObjectSample
   time: 716232164304
     id: 37
   type: flash.events::ProgressEvent
]
[NewObjectSample
   time: 716232164343
     id: 38
   type: String
  stack: 
    flash.utils::ByteArray/readUTFBytes()
    flash.net::XMLSocket/scanAndSendEvent()
]
[NewObjectSample
   time: 716232164347
     id: 39
   type: flash.events::DataEvent
  stack: 
    flash.net::XMLSocket/scanAndSendEvent()
]
[Sample
   time: 716232166061
  stack: 
    flash.events::DataEvent/get data()
    Agent/dataReceived()
    flash.events::EventDispatcher/dispatchEventFunction()
    flash.events::EventDispatcher/dispatchEvent()
    flash.net::XMLSocket/scanAndSendEvent()
]
[DeleteObjectSample
   time: 716232166224
     id: 37
   size: 40
]
EOF

samples.split("]\n[").each do |s| 
  s = "[" + s if s[0,1] != "["
  s = s + "]" if s[-1,1] != "]"
  puts SampleParser.parse(s).inspect
end
=end
