//
//  FirstViewController.m
//  libssh2-for-iOS
//
//  Created by Vijay Jangid on 23/05/13.
//
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize textField, textView, ipField, userField, passwordField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication] delegate];
    textField.text = @"";
    ipField.text = @"";
    userField.text = @"";
    passwordField.text = @"";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)executeCommand:(id)sender
{
    if(!appDelegate.connection)
    {
        appDelegate.connection = [[sshConnector alloc] init];
        appDelegate.myssh = [[sshServer alloc] init];
        [appDelegate.myssh setSSHHost:ipField.text port:22 user:userField.text key:@"" keypub:@"" password:passwordField.text];
        
        int x = [appDelegate.connection connect:appDelegate.myssh];
        if(x == 0)
        {
            [appDelegate.commands appendFormat:@"%@ \n",[sshOperator execCommand:@"rmdir newfolder" sshServer:appDelegate.myssh]];
            secondViewController *secondView = [[secondViewController alloc] initWithNibName:@"secondViewController" bundle:nil];
            
            [self.navigationController pushViewController:secondView animated:YES];
        }
        else
        {
            [appDelegate.connection closeSSH:appDelegate.myssh];
            appDelegate.connection = nil;
        }
    }
}
@end
