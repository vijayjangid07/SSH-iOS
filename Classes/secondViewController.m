//
//  secondViewController.m
//  libssh2-for-iOS
//
//  Created by Vijay Jangid on 23/05/13.
//
//

#import "secondViewController.h"
static const int kControlCharacter = 0x2022;

@interface secondViewController ()

@end

@implementation secondViewController
@synthesize txtCommandPrompt,controlKeyMode;

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
    appDelegate = (libssh2_for_iOSAppDelegate *)[[UIApplication sharedApplication] delegate];
    controlKeyMode = YES;
    strCommand = [[NSMutableString alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    txtCommandPrompt.text = appDelegate.commands;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(text.length > 0)
    {
        unichar c = [text characterAtIndex:0];
        
          
            // Convert the character to a control key with the same ascii name (or
            // just use the original character if not in the acsii range)
            if (c < 0x60 && c > 0x40) {
                // Uppercase (and a few characters nearby, such as escape)
                c -= 0x40;
                [strCommand appendFormat:@"%@",text];
            } else if (c < 0x7B && c > 0x60) {
                // Lowercase
                c -= 0x60;
                [strCommand appendFormat:@"%@",text];
            }
            else if (c == 0x0a) {
                // Convert newline to a carraige return
                c = 0x0d;
                [self executeCommand];
            }
            else
            {
                [strCommand appendFormat:@"%@",text];
            }
        
       
    }
    
    NSLog(@"%@",text);
    return YES;
}

- (void)executeCommand
{
    NSLog(@"%@",strCommand);
    [appDelegate.commands appendFormat:@"\n %@ \n",strCommand];
    [appDelegate.commands appendFormat:@"%@ \n",[sshOperator execCommand:strCommand sshServer:appDelegate.myssh]];
    strCommand = [[NSMutableString alloc] init];
    txtCommandPrompt.text = appDelegate.commands;
}
@end
