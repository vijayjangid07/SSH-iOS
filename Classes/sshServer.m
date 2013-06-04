//
//  sshServer.m
//  sshtest
//
//  Created by Daniel Finneran on 23/10/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "sshServer.h"



@implementation sshServer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) setSSHHost:(NSString*)sshHost 
               port:(int)sshPort 
               user:(NSString*)sshUser 
               key:(NSString*)sshKey 
               keypub:(NSString*)sshKeypub 
               password:(NSString*)sshpassWord {
    
    //allocate Host details to object
    hostname = [sshHost UTF8String];
    port = sshPort;
    username = [sshUser UTF8String];
    key = [sshKey UTF8String];
    keypub = [sshKeypub UTF8String];
    password = [sshpassWord UTF8String];
}

-(void) setSession:(LIBSSH2_SESSION *)sshSession {
    session = sshSession;
}

-(void) setSock:(int)sshSock{
    sock = sshSock;
}
-(void) setConnected:(bool)sshconnected{
    connected = sshconnected;
}

-(bool) connectionStatus {
    return connected;
}


// Getter Methods

- (const char *)hostname { return hostname;}
- (int)port { return port;}
- (const char *)username {return username;}
- (const char *)password {return password;}
- (const char *)key {return key;}
- (const char *)keypub {return keypub;}
- (int) sock {return sock;}
- (LIBSSH2_SESSION *)session {return session;}
- (LIBSSH2_CHANNEL *)channel {return channel;}

@end
