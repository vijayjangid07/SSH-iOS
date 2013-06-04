//
//  sshConnector.m
//  sshtest
//
//  Created by Daniel Finneran on 23/10/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import "sshConnector.h"
#include "libssh2_config.h"
#include "libssh2.h"

#ifdef HAVE_WINSOCK2_H
# include <winsock2.h>
#endif
#ifdef HAVE_SYS_SOCKET_H
# include <sys/socket.h>
#endif
#ifdef HAVE_NETINET_IN_H
# include <netinet/in.h>
#endif
#ifdef HAVE_SYS_SELECT_H
# include <sys/select.h>
#endif
# ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif
#ifdef HAVE_ARPA_INET_H
# include <arpa/inet.h>
#endif

#include <sys/time.h>
#include <sys/types.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <stdio.h>
#include <ctype.h>

unsigned int hostaddr;

struct sockaddr_in soin;
const char *fingerprint;

const char *keyfile1="~/.ssh/id_rsa.pub";
const char *keyfile2="~/.ssh/id_rsa";
const char *username="";
const char *password="";

int rc;
int type;

size_t len;

//Someone on the libssh team has spelling issues (known begins with a 'K')
LIBSSH2_KNOWNHOSTS *nh;

@implementation sshConnector

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


static void kbd_callback(const char *name, int name_len,
                         const char *instruction, int instruction_len,
                         int num_prompts,
                         const LIBSSH2_USERAUTH_KBDINT_PROMPT *prompts,
                         LIBSSH2_USERAUTH_KBDINT_RESPONSE *responses,
                         void **abstract)
{
    (void)name;
    (void)name_len;
    (void)instruction;
    (void)instruction_len;
    if (num_prompts == 1) {
        responses[0].text = strdup(password);
        responses[0].length = strlen(password);
    }
    (void)prompts;
    (void)abstract;
} /* kbd_callback */

-(int) connect:(sshServer *) server
{
    unsigned long hostaddr;
    int rc, i, auth_pw = 0;
    struct sockaddr_in sin;
    const char *fingerprint;
    char *userauthlist;

    LIBSSH2_CHANNEL *channel;
#ifdef WIN32
    WSADATA wsadata;
    
    WSAStartup(MAKEWORD(2,0), &wsadata);
#endif
    
    
    
        hostaddr = inet_addr([server hostname]);
    
        username = [server username];
        password = [server password];
    
    rc = libssh2_init (0);
    
    if (rc != 0) {
        fprintf (stderr, "libssh2 initialization failed (%d)\n", rc);
        return 1;
    }
    
    /* Ultra basic "connect to port 22 on localhost".  Your code is
     * responsible for creating the socket establishing the connection
     */
    [server setSock: socket(AF_INET, SOCK_STREAM, 0)];
    
    sin.sin_family = AF_INET;
    sin.sin_port = htons(22);
    sin.sin_addr.s_addr = hostaddr;
    if (connect([server sock], (struct sockaddr*)(&sin),
                sizeof(struct sockaddr_in)) != 0) {
        fprintf(stderr, "failed to connect!\n");
        return -1;
    }
    
    /* Create a session instance and start it up. This will trade welcome
     * banners, exchange keys, and setup crypto, compression, and MAC layers
     */
    [server setSession: libssh2_session_init()];
    
    if (libssh2_session_handshake([server session], [server sock])) {
        
        fprintf(stderr, "Failure establishing SSH session\n");
        return -1;
    }
    
    /* At this point we havn't authenticated. The first thing to do is check
     * the hostkey's fingerprint against our known hosts Your app may have it
     * hard coded, may go to a file, may present it to the user, that's your
     * call
     */
    fingerprint = libssh2_hostkey_hash([server session], LIBSSH2_HOSTKEY_HASH_SHA1);
    
    fprintf(stderr, "Fingerprint: ");
    for(i = 0; i < 20; i++) {
        fprintf(stderr, "%02X ", (unsigned char)fingerprint[i]);
    }
    fprintf(stderr, "\n");
    
    /* check what authentication methods are available */
    userauthlist = libssh2_userauth_list([server session], username, strlen(username));
    
    fprintf(stderr, "Authentication methods: %s\n", userauthlist);
    if (strstr(userauthlist, "password") != NULL) {
        auth_pw |= 1;
    }
    if (strstr(userauthlist, "keyboard-interactive") != NULL) {
        auth_pw |= 2;
    }
    if (strstr(userauthlist, "publickey") != NULL) {
        auth_pw |= 4;
    }
    
    /* if we got an 4. argument we set this option if supported */
    /*if(argc > 4) {
        if ((auth_pw & 1) && !strcasecmp(argv[4], "-p")) {
            auth_pw = 1;
        }
        if ((auth_pw & 2) && !strcasecmp(argv[4], "-i")) {
            auth_pw = 2;
        }
        if ((auth_pw & 4) && !strcasecmp(argv[4], "-k")) {
            auth_pw = 4;
        }
    }*/
    auth_pw = 2;
    if (auth_pw & 1) {
        /* We could authenticate via password */
        if (libssh2_userauth_password([server session], username, password)) {
            
            fprintf(stderr, "\tAuthentication by password failed!\n");
            goto shutdown;
        } else {
            fprintf(stderr, "\tAuthentication by password succeeded.\n");
        }
    } else if (auth_pw & 2) {
        /* Or via keyboard-interactive */
        if (libssh2_userauth_keyboard_interactive([server session], username,
                                                  
                                                  &kbd_callback) ) {
            fprintf(stderr,
                    "\tAuthentication by keyboard-interactive failed!\n");
            goto shutdown;
        } else {
            fprintf(stderr,
                    "\tAuthentication by keyboard-interactive succeeded.\n");
            [server setConnected:TRUE]  ;
            return  0;
        }
    } else if (auth_pw & 4) {
        /* Or by public key */
        if (libssh2_userauth_publickey_fromfile([server session], username, keyfile1,
                                                
                                                keyfile2, password)) {
            fprintf(stderr, "\tAuthentication by public key failed!\n");
            goto shutdown;
        } else {
            fprintf(stderr, "\tAuthentication by public key succeeded.\n");
            [server setConnected:TRUE]  ;
            return  0;
        }
    } else {
        fprintf(stderr, "No supported authentication methods found!\n");
        goto shutdown;
    }
    
    /* Request a shell */
    if (!(channel = libssh2_channel_open_session([server session]))) {
        
        fprintf(stderr, "Unable to open a session\n");
        goto shutdown;
    }
    
    /* Some environment variables may be set,
     * It's up to the server which ones it'll allow though
     */
    libssh2_channel_setenv(channel, "FOO", "bar");
    
    
    /* Request a terminal with 'vanilla' terminal emulation
     * See /etc/termcap for more options
     */
    if (libssh2_channel_request_pty(channel, "vanilla")) {
        
        fprintf(stderr, "Failed requesting pty\n");
        goto skip_shell;
    }
    
    /* Open a SHELL on that pty */
    if (libssh2_channel_shell(channel)) {
        
        fprintf(stderr, "Unable to request shell on allocated pty\n");
        goto shutdown;
    }
    
    /* At this point the shell can be interacted with using
     * libssh2_channel_read()
     * libssh2_channel_read_stderr()
     * libssh2_channel_write()
     * libssh2_channel_write_stderr()
     *
     * Blocking mode may be (en|dis)abled with: libssh2_channel_set_blocking()
     * If the server send EOF, libssh2_channel_eof() will return non-0
     * To send EOF to the server use: libssh2_channel_send_eof()
     * A channel can be closed with: libssh2_channel_close()
     * A channel can be freed with: libssh2_channel_free()
     */
    
skip_shell:
    if (channel) {
        libssh2_channel_free(channel);
        
        channel = NULL;
    }
    
    /* Other channel types are supported via:
     * libssh2_scp_send()
     * libssh2_scp_recv()
     * libssh2_channel_direct_tcpip()
     */
    
shutdown:
    
    libssh2_session_disconnect([server session],
                               
                               "Normal Shutdown, Thank you for playing");
    libssh2_session_free([server session]);
    
    
#ifdef WIN32
    closesocket([server sock]);
#else
    close([server sock]);
#endif
    fprintf(stderr, "all done!\n");
    
    libssh2_exit();
    
    
    return -1;
    
}

-(BOOL) closeSSH:(sshServer*)server {	
    
    if (![server connectionStatus]) 
    {
        return FALSE;    
    }
    
    libssh2_session_disconnect([server session],"Disconnected");
    libssh2_session_free([server session]);
	
    close([server sock]);
    NSLog(@"all done\n");
	[server setConnected:FALSE];
	return TRUE;
}


@end
