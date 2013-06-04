//
//  sshServer.h
//  sshtest
//
//  Created by Daniel Finneran on 23/10/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libssh2.h"



@interface sshServer : NSObject {
    // Average SSH Details Required
    const char *hostname;
	int port;
    const char *username;
    const char *password;
    // SSH Key Details
	const char *key;
	const char *keypub;
    // Session Status/Details
    bool connected;
    int sock;
    LIBSSH2_SESSION *session;
    LIBSSH2_CHANNEL *channel;
    
    
}
//Getter methods
- (const char *)hostname;
- (int)port;
- (const char *)username;
- (const char *)password;
- (const char *)key;
- (const char *)keypub;
- (int) sock;
- (LIBSSH2_SESSION *)session;
- (LIBSSH2_CHANNEL *)channel;


//sshServer Methods
-(void) setSSHHost:(NSString*)sshHost port:(int)sshPort user:(NSString*)sshUser key:(NSString*)sshKey keypub:(NSString*)sshKeypub password:(NSString*)sshpassWord;    /* Set SSH Server Details */
-(void) setSession:(LIBSSH2_SESSION *)sshSession; /* Set the persistant Session */
-(void) setSock:(int)sshSock; /* Set a persistant socket */
-(void) setConnected:(bool)sshconnected; /* Set state to connected */
-(bool) connectionStatus; /* Return connected status */

@end
