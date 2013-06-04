//
//  libssh2_for_iOSAppDelegate.h
//  libssh2-for-iOS
//
//  Created by Felix Schulze on 01.02.11.
//  Copyright 2010 Felix Schulze. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <UIKit/UIKit.h>
#import "sshServer.h"
#import "sshConnector.h"
#import "secondViewController.h"
#import "sshOperator.h"
#import "FirstViewController.h"

@interface libssh2_for_iOSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	
    sshServer *myssh;
    sshConnector *connection;
    NSMutableString *commands;
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) sshServer *myssh;
@property (nonatomic, retain) sshConnector *connection;
@property (nonatomic, retain) NSMutableString *commands;
@property (nonatomic, retain) UINavigationController *navController;

- (IBAction)showInfo;

@end

