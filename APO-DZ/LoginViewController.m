//
//  LoginViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/21/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "LoginViewController.h"
#import "RSMWebRequestManager.h"
#import "URLs.h"

#define RgbUIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface LoginViewController ()

// Properties
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;

// Instance Methods
- (IBAction)displayAbout:(id)sender;
- (IBAction)promptForPassword:(id)sender;
- (void)continueToApp;
- (void)raiseNoInternetAlert;

@end

@implementation LoginViewController

static NSString *FIRST_NAME_KEY = @"first_name";
static NSString *LAST_NAME_KEY  = @"last_name";
static NSString *PASSWORD_CORRECT = @"password_correct";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (![RSMWebRequestManager doesHaveInternetConnection]) {
        // Display alert
        [self raiseNoInternetAlert];
    } else if ([[self class] loginComplete]) {
        [self continueToApp];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *firstName;
    if ((firstName = [prefs objectForKey:FIRST_NAME_KEY])) {
        // If we're already logged in, update the name label.
        NSString *lastName  = [prefs objectForKey:LAST_NAME_KEY];
        
        [_nameLabel setText:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
        [_statusLabel setText:@"Welcome, Brother."];
        
        [_logoutButton setUserInteractionEnabled:YES];
    } else {
        [_nameLabel setText:@""];
        [_statusLabel setText:@"Please log in to continue."];
        
        [prefs removeObjectForKey:PASSWORD_CORRECT];
        [prefs synchronize];
        _logoutButton.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)continueToApp
{
    [self performSegueWithIdentifier:@"LoginCompleteSegue" sender:self];
}

- (IBAction)displayAbout:(id)sender
{
    UIAlertView *aboutAlert =
    [[UIAlertView alloc] initWithTitle:@"About Me"
                               message:@"This app is made for use by brothers of Alpha Phi Omega at the University of Pennsylvania. \n Please contact developer@upennapo.org with any questions or problems."
                              delegate:self
                     cancelButtonTitle:@"Great!"
                     otherButtonTitles:nil, nil];
    [aboutAlert show];
}

- (IBAction)promptForPassword:(id)sender
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"password_correct"]) {
        UIAlertView *passwordPrompt =
        [[UIAlertView alloc] initWithTitle:@"Enter Password"
                                   message:@"Please enter the chapter app password:"
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"Submit", nil];
        [passwordPrompt setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [passwordPrompt show];
    } else if (![[NSUserDefaults standardUserDefaults] objectForKey:FIRST_NAME_KEY]) {
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    } else {
        [self continueToApp];
    }
}

+ (BOOL)loginComplete
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:FIRST_NAME_KEY] && [prefs objectForKey:@"last_name"]
    && [prefs boolForKey:@"password_correct"];
}

- (void)raiseNoInternetAlert
{
    UIAlertView *noInternetAlert =
    [[UIAlertView alloc] initWithTitle:@"Unable to Load"
                               message:@"The APO app requires a network connection. Please try again when you are connected to the internet."
                              delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil, nil];
    [noInternetAlert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView title] isEqualToString:@"Enter Password"] && buttonIndex == 1) {
        // Try to validate the password.
        if ([[[alertView textFieldAtIndex:0] text] isEqualToString:APP_PASSWORD]) {
            // Remember that the password was correct so we don't have to enter it again.
            [[NSUserDefaults standardUserDefaults] setBool:YES
                                                    forKey:PASSWORD_CORRECT];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self performSegueWithIdentifier:@"SignInSegue" sender:self];
        } else {
            UIAlertView *incorrectPasswordAlert =
            [[UIAlertView alloc] initWithTitle:@"Incorrect Password"
                                       message:@"That password was incorrect. Please try again."
                                      delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"Ok", nil];
            [incorrectPasswordAlert show];
        }
    } else if ([[alertView title] isEqualToString:@"Incorrect Password"] && buttonIndex == 1) {
        [self promptForPassword:nil];
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Via http://stackoverflow.com/questions/18795117/change-tab-bar-tint-color-ios-7
    if ([[segue identifier] isEqualToString:@"LoginCompleteSegue"]) {
        UITabBarController *tabBarController = [segue destinationViewController];
        tabBarController.tabBar.tintColor = RgbUIColor(0, 87, 155);
    }
}

@end
