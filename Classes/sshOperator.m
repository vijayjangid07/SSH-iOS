//
//  sshOperator.m
//  sshtest
//
//  Created by Daniel Finneran on 23/10/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "sshOperator.h"
#import "libssh2.h"


LIBSSH2_CHANNEL *channel;
int rc;
int bytecount = 0; /*wrap up in a function*/
int exitcode;

@implementation sshOperator

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

static int waitsocket(int socket_fd, LIBSSH2_SESSION *session)
{    
    // Variable Declarations
    struct timeval timeout;
    
    fd_set fd;    
    fd_set *writefd = NULL;
    fd_set *readfd = NULL;
    
    int rc;
    int dir;
	
    timeout.tv_sec = 2;
    timeout.tv_usec = 0;
    
    FD_ZERO(&fd);
    FD_SET(socket_fd, &fd);
	
 
    /* now make sure we wait in the correct direction */
    dir = libssh2_session_block_directions(session);
    if(dir & LIBSSH2_SESSION_BLOCK_INBOUND)
        readfd = &fd;
    if(dir & LIBSSH2_SESSION_BLOCK_OUTBOUND)
        writefd = &fd;
    rc = select(socket_fd + 1, readfd, writefd, NULL, &timeout);
    
    return rc;
}

// from libssh2 example - ssh2_exec.c
+(NSString*) execCommand:(NSString *)commandline sshServer:(sshServer*)server {
    
    if (![server connectionStatus]) 
    {
        return @"No Connection";    
    }

	NSString *result;
	const char * cmd = [commandline UTF8String];
	
    /*Exec non-blocking on the remote host */
    while( (channel = libssh2_channel_open_session([server session])) == NULL &&
		  libssh2_session_last_error([server session],NULL,NULL,0) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket([server sock], [server session]);
    }
    if( channel == NULL )
    {
        NSLog(@"Error\n");
        exit( 1 );
    }
    while( (rc = libssh2_channel_exec(channel, cmd)) ==
		  LIBSSH2_ERROR_EAGAIN )
    {
        waitsocket([server sock], [server session]);
    }
    if( rc != 0 )
    {
        NSLog(@"Error\n");
        exit( 1 );
    }
    NSMutableString *response = [[NSMutableString alloc] init];
    for( ;; )
    {
        int rc1;
        do
        {
            char buffer[0x4000];
            
            rc1 = libssh2_channel_read( channel, buffer, sizeof(buffer) );
            if( rc1 > 0 )
            {
				result = [NSString stringWithCString:buffer encoding: 4];
                
                int i;
                bytecount += rc1;
                //fprintf(stderr, "We read:\n");
                for( i=0; i < rc1; ++i )
                {
                    //fputc( buffer[i], stderr);
                    [response appendFormat:@"%c",buffer[i]];
                }
                //fprintf(stderr, "\n");
                result = response;
            }
            else {
                NSLog(@"libssh2_channel_read returned %d", rc1);
            }
        }
        while( rc1 > 0 );
		
        /* this is due to blocking that would occur otherwise so we loop on
		 this condition */
        if( rc1 == LIBSSH2_ERROR_EAGAIN )
        {
            waitsocket([server sock], [server session]);
        }
        else
            break;
    }
    exitcode = 127;
    /*while( (rc = libssh2_channel_close(channel)) == LIBSSH2_ERROR_EAGAIN )
        waitsocket([server sock], [server session]);
	
    if( rc == 0 )
    {
        exitcode = libssh2_channel_get_exit_status( channel );
    }
    NSLog(@"\nEXIT: %d bytecount: %d", exitcode, bytecount);
	
    libssh2_channel_free(channel);
    channel = NULL;*/
	
    return result;
    
}

@end