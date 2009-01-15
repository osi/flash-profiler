//
//  FPAgent.m
//  FlashProfilerApp
//
//  Created by peter royal on 1/8/09.
//  Copyright 2009 Electrotank, Inc.. All rights reserved.
//

#import "FPAgent.h"

short read_short(const unsigned char *bytes, unsigned int offset) {
    return (bytes[offset] << 8) + bytes[offset+1];
}

unsigned int read_unsigned_int(const unsigned char *bytes, unsigned int offset) {
    return (bytes[offset] << 24) + (bytes[offset+1] << 16) + (bytes[offset+2] << 8) + bytes[offset+3];
}

@implementation FPAgent

- (id)init {
    [self dealloc];
    
    @throw [NSException exceptionWithName:@"FPBadInitCall" 
                                   reason:@"Initialize with initWithSocket" 
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithSocket:(AsyncSocket *)socket {
    [super init];
    
    _socket = socket; 
    
    [_socket setDelegate:self];
    
    return self;
}

- (BOOL)isConnected {
    return [_socket isConnected];
}

- (void)setDelegate:(id)delegate {
    _delegate = delegate;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"Accepted conection on %@:%i", host, port);
    
    [_socket readDataToLength:12 withTimeout:5 tag:1UL];
    
/*
    NSLog "Accepted connection from #{host}:#{port}"

    hello_msg = read_message
    
    if "AGENT READY" != hello_msg
      @socket.disconnect
    else
      @sampling_state = :stopped

      @tracker.add self

      NSLog "Agent ready"
    end
 
 */
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData*)data withTag:(long)tag {
    switch (tag) {
        case 1L: 
            {
                const unsigned char *bytes = [data bytes];
                
                short msg_type = read_short(bytes, 0);
                
                if( msg_type != 0x4201 ) {
                    NSLog(@"Received invalid message type %i", msg_type);
                    [_socket disconnect];
                    return;
                }
                
                unsigned int seconds = read_unsigned_int(bytes,2);
                short ms = read_short(bytes, 6);
                unsigned int counter = read_unsigned_int(bytes,8);
                
                NSTimeInterval secondsSince1970 = seconds + (ms / 1000.0);
                NSDate *start = [NSDate dateWithTimeIntervalSince1970: secondsSince1970];
                
                NSLog(@"Remote time is %@", start);
            }
            break;
        default:
            NSLog(@"Unknown tag value: %i", tag);
            break;
    }
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"Socket closed");
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    NSLog(@"Will be closing due to %@", err);
}

// TODO all the action methods need to be lazy and return stuff
// via the delgate

/*
class Agent
  
  def memory_usage
    m = send_and_expect "GET MEMORY", /MEMORY: (\d+) (\d+)/
    
    MemoryUsage.new m[1].to_i, m[2].to_i
  end
  
  def samples
    count = send_and_expect("GET SAMPLES", /SENDING SAMPLES: (\d+)/)[1].to_i
    sample_set = SampleSet.new
    previous = nil
    
    count.times do
      previous = (sample_set << read_sample(previous))
    end
    
    send_and_expect "CLEAR SAMPLES", "OK CLEARED"
    
    sample_set
  end
  
  def start_sampling
    at = send_and_expect("START SAMPLING", /OK START (\d+)/)[1].to_i
    @started_at = Time.at(at / 1000, at % 1000 * 1000)
    @sampling_state = :started
  end
  
  def pause_sampling
    send_and_expect "PAUSE SAMPLING", "OK PAUSE"
    
    @sampling_state = :paused
  end
  
  def stop_sampling
    send_and_expect "STOP SAMPLING", "OK STOP"
    
    @sampling_state = :stopped
  end
  
  def sampling?
    :started == @sampling_state
  end
  
  def to_s
    "#{@socket.peeraddr[2]}:#{@socket.peeraddr[1]}"
  end
  
  # AsyncSocket delegates
  
  def onSocket(socket, didConnectToHost:host, port:port)
    NSLog "Accepted connection from #{host}:#{port}"

    hello_msg = read_message
    
    if "AGENT READY" != hello_msg
      @socket.disconnect
    else
      @sampling_state = :stopped

      @tracker.add self

      NSLog "Agent ready"
    end
  end
  
  def onSocket(socket, didReadData:data, withTag:tag)
    @callbacks.delete(tag).call NSString.initWithData(data, encoding: NSUTF8StringEncoding)
  end
  
  def onSocket(socket, willDisconnectWithError:err)
    NSLog "#{self} closing due to #{err}"
  end
  
  def onSocketDidDisconnect(socket)
    # TODO ensure that we're removed from the tracker
  end
  
  private
  
  def read_sample(previous)
    SampleParser.parse read_message, @started_at, previous.nil? ? nil : previous.raw_time
  end
  
  def send_and_expect(msg, expected)
    send_message msg
    
    response = read_message
   
    case expected
    when Regexp
      m = expected.match(response)
      return m if not m.nil?
    when response
      return response
    end
    
    raise "Invalid response: #{response}"
  end
  
  def send_message(msg) 
    sdata = msg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    
    @socket.writeData sdata, withTimeout: -1, tag: 0
    @socket.writeData AsyncSocket.ZeroData, withTimeout: -1, tag: 0
  end
  
  def read_message(&block)
    id = @callback_counter++
    
    @callbacks[id] = block
    @socket.readDataToData AsyncSocket.ZeroData, withTimeout: -1, tag: id
  end  
end 

*/

@end
