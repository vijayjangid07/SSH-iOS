//
//  secondViewController.h
//  libssh2-for-iOS
//
//  Created by Vijay Jangid on 23/05/13.
//
//

#import <UIKit/UIKit.h>
#import "libssh2_for_iOSAppDelegate.h"
@class libssh2_for_iOSAppDelegate;

@interface secondViewController : UIViewController<UITextViewDelegate>
{
    libssh2_for_iOSAppDelegate *appDelegate;
    BOOL controlKeyMode;
    NSMutableString *strCommand;
}
@property(nonatomic,assign) BOOL controlKeyMode;
@property(nonatomic,retain) IBOutlet UITextView *txtCommandPrompt;
- (void)executeCommand;

@end
