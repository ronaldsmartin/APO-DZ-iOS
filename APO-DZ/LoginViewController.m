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

@interface LoginViewController ()

// Properties
@property (strong, nonatomic) IBOutlet __block FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;

// Instance Methods
- (IBAction)displayAbout:(id)sender;
- (IBAction)promptForPassword:(id)sender;
- (void)centerNameLabel;
- (void)continueToApp;
- (void)raiseNoInternetAlert;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (![RSMWebRequestManager doesHaveInternetConnection]) {
        
        // Center label when there's no profile picture.
        [self centerNameLabel];
        
        // Display alert
        [self raiseNoInternetAlert];
    }
}

- (void)centerNameLabel
{
    _nameLabel.frame = CGRectOffset(_nameLabel.frame, (self.view.center.x - (_nameLabel.frame.size.width / 2)), 5);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // Set the profile picture view if we're logged into Facebook.
    if (FBSession.activeSession.state != FBSessionStateClosedLoginFailed) {
        
        // Open a new session if the last auth token expired.
        if (!FBSession.activeSession.isOpen) {
            [FBSession openActiveSessionWithAllowLoginUI:NO];
        }
        
        // Request user's profile id and set the ProfilePictureView
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // Success! Include your code to handle the results here
                [_profilePictureView setProfileID:[result id]];
            } else {
                // An error occurred, we need to handle the error
                // See: https://developers.facebook.com/docs/ios/errors
                NSLog(@"LoginViewController: %@", error);
                
                // Center label when there's no profile picture.
                [self centerNameLabel];
                [_profilePictureView setProfileID:nil];
            }
        }];
    } else {
        [_profilePictureView setProfileID:nil];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"]) {
        NSString *firstName = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"],
                 *lastName  = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"];
        
        [_nameLabel setText:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
        [_statusLabel setText:@"Welcome, Brother."];
        
        [_logoutButton setUserInteractionEnabled:YES];
    } else {
        [_nameLabel setText:@""];
        [_statusLabel setText:@"Please log in to continue."];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password_correct"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"]) {
        [self performSegueWithIdentifier:@"SignInSegue" sender:self];
    } else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"password_correct"]) {
        UIAlertView *passwordPrompt =
        [[UIAlertView alloc] initWithTitle:@"Enter Password"
                                   message:@"Please enter the chapter app password:"
                                  delegate:self
                         cancelButtonTitle:@"Cancel"
                         otherButtonTitles:@"Submit", nil];
        [passwordPrompt setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [passwordPrompt show];
    } else {
        [self continueToApp];
    }
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
            [[NSUserDefaults standardUserDefaults] setValue:@"password_correct"
                                                     forKey:@"password_correct"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self continueToApp];
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

@end
