//
//  libssh2_for_iOSAppDelegate.m
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

#import "libssh2_for_iOSAppDelegate.h"
#import "VersionHelper.h"

@implementation libssh2_for_iOSAppDelegate

@synthesize window;

@synthesize myssh;
@synthesize commands,connection;
@synthesize navController;
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    

    commands = [[NSMutableString alloc] init];
    FirstViewController *firstController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:firstController];
    if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [self.window addSubview: self.navController.view];
    }
    else
    {
        // use this mehod on ios6
        [self.window setRootViewController:self.navController];
    }

    [self.window makeKeyAndVisible];
    return YES;
}




- (IBAction)showInfo {
    NSString *message = [NSString stringWithFormat:@"libssh2-Version: %@\nlibgcrypt-Version: %@\nlibgpg-error-Version: %@\nopenssl-Version: %@\n\nLicense: See include/*/LICENSE\n\nCopyright 2011-2013 by Felix Schulze\n http://www.felixschulze.de", [VersionHelper libssh2Version], [VersionHelper libgcryptVersion], [VersionHelper libgpgerrorVersion], [VersionHelper opensslVersion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"libssh2-for-iOS" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
