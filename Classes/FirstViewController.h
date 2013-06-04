//
//  FirstViewController.h
//  libssh2-for-iOS
//
//  Created by Vijay Jangid on 23/05/13.
//
//

#import <UIKit/UIKit.h>
#import "libssh2_for_iOSAppDelegate.h"
@class libssh2_for_iOSAppDelegate;
@interface FirstViewController : UIViewController
{
    libssh2_for_iOSAppDelegate *appDelegate;
    IBOutlet UITextField *textField;
    IBOutlet UITextField *ipField;
    IBOutlet UITextField *userField;
    IBOutlet UITextField *passwordField;
    IBOutlet UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *ipField;
@property (nonatomic, retain) IBOutlet UITextField *userField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
