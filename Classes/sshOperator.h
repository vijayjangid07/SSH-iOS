//
//  sshOperator.h
//  sshtest
//
//  Created by Daniel Finneran on 23/10/2011.
//  Copyright 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sshServer.h"

@interface sshOperator : NSObject

+(NSString*) execCommand:(NSString *)commandline sshServer:(sshServer*)server;

@end
