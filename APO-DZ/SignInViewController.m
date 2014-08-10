//
//  SignInViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 14/3/14.
//  Copyright (c) 2014 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (nonatomic, strong) IBOutlet UILabel     *statusLabel;
@property (nonatomic, strong) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *lastNameTextField;
@property (nonatomic, strong) IBOutlet UIButton    *logoutButton;
@property (nonatomic, strong) IBOutlet UIButton    *loginButton;

- (IBAction)dismissModal:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)saveAndContinue:(id)sender;
- (void)resetUser;

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Refresh the status bar to hide it for this view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Setting delegates for the text fields allows us to use the Return keyboard
    // key to toggle the fields and hide the keyboard.
    [_firstNameTextField setDelegate:self];
    [_lastNameTextField  setDelegate:self];
    
    // Update view for logged in User.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"]) {
        NSString *firstName = [[NSUserDefaults standardUserDefaults]objectForKey:@"first_name"],
                 *lastName  = [[NSUserDefaults standardUserDefaults]objectForKey:@"last_name"],
                 *user      = [NSString stringWithFormat:@"Currently logged in as\n %@ %@", firstName, lastName];
        
        // Change instructions box to login status.
        [_statusLabel setText:user];
        
        // Fill text fields with existing credentials.
        [_firstNameTextField setPlaceholder:firstName];
        [_lastNameTextField  setPlaceholder:lastName];
        
        // Enable logout button.
        _logoutButton.enabled = YES;
        _logoutButton.alpha   = 1;
    } else {
        [self resetUser];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)dismissModal:(id)sender
{
    UIActionSheet *confirmCancelActionSheet =
        [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to cancel login?"
                                    delegate:self
                           cancelButtonTitle:@"Resume Login"
                      destructiveButtonTitle:@"Cancel Login"
                           otherButtonTitles:nil, nil];
    [confirmCancelActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([actionSheet.title isEqualToString:@"Are you sure you want to cancel login?"] &&
            buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if ([actionSheet.title isEqualToString:@"Are you sure you want to log out?"] &&
            buttonIndex == 0) {
        [self resetUser];
    }
}

- (void)resetUser
{
    // Sign out of Facebook.
    if (FBSession.activeSession.isOpen) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    
    // Remove user data from system prefs.
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"directory_brothers"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"directory_pledges"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    // Replace instructions.
    _statusLabel.text = @"Enter your name exactly as it appears on the Spreadsheet.";
    
    // Replace placeholder text.
    _firstNameTextField.placeholder = @"Greatest";
    _lastNameTextField.placeholder  = @"Ever";
    
    // Replace text field text.
    _firstNameTextField.text = @"";
    _lastNameTextField.text  = @"";
    
    // Disable the logout button.
    _logoutButton.userInteractionEnabled = NO;
    _logoutButton.alpha = 0.5;
}

- (IBAction)logout:(id)sender
{
    // Confirm logout via ActionSheet.
    UIActionSheet *confirmLogoutActionSheet =
    [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to log out?"
                                delegate:self
                       cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:@"Logout"
                       otherButtonTitles:nil, nil];
    [confirmLogoutActionSheet showInView:self.view];
}

- (IBAction)saveAndContinue:(id)sender
{
    // If both fields are nonempty, store the entered name in user prefs and
    // dismiss the modal view.
    if (![_firstNameTextField hasText]) {
        UIAlertView *emptyFirstNameAlert =
        [[UIAlertView alloc] initWithTitle:@"First Name Field is Empty"
                                   message:@"Please enter your first name as it appears on the spreadsheet to continue."
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil];
        [emptyFirstNameAlert show];
    } else if (![_lastNameTextField hasText]) {
        UIAlertView *emptyLastNameAlert =
        [[UIAlertView alloc] initWithTitle:@"Last Name Field is Empty"
                                   message:@"Please enter your last name as it appears on the spreadsheet to continue."
                                  delegate:self
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil];
        [emptyLastNameAlert show];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:_firstNameTextField.text
                                                  forKey:@"first_name"];
        [[NSUserDefaults standardUserDefaults] setObject:_lastNameTextField.text
                                                  forKey:@"last_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _firstNameTextField) {
        [_lastNameTextField becomeFirstResponder];
    } else if (textField == _lastNameTextField) {
        [_lastNameTextField  resignFirstResponder];
        
        // Animate the Continue button if both fields are filled.
        if (_firstNameTextField.text && _lastNameTextField.text &&
                ![_firstNameTextField.text isEqualToString:@""] &&
                ![_lastNameTextField.text isEqualToString:@""]) {
            [self flashOn:_loginButton];
        }
    }
    return YES;
}

/*----------------------> FLASHING BUTTON <----------------------*/

// Flashing button courtesy of:
// http://stackoverflow.com/questions/15368397/uibutton-flashing-animation
- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        //don't animate alpha to 0, otherwise you won't be able to interact with it
        v.alpha = .01;
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}

/*---------------------------> FACEBOOK <--------------------------*/

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if (!_firstNameTextField.text ||
            [_firstNameTextField.text isEqualToString:@""]) {
        _firstNameTextField.text = user.first_name;
        _lastNameTextField.text  = user.last_name;
        [self flashOn:_loginButton];
    }
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
