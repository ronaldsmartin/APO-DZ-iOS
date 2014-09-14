//
//  DirectoryDetailsViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/23/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "DirectoryDetailsViewController.h"
#import <FacebookSDK/FBGraphUser.h>
#import <FacebookSDK/FBProfilePictureView.h>
#import <FacebookSDK/FBRequest.h>

@interface DirectoryDetailsViewController ()

// Display Outlets
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet UILabel *classLabel;
@property (nonatomic, strong) IBOutlet UILabel *majorLabel;
@property (nonatomic, strong) IBOutlet FBProfilePictureView *profilePictureView;
// Buttons
@property (nonatomic, strong) IBOutlet UIButton *emailButton;
@property (nonatomic, strong) IBOutlet UIButton *phoneButton;
@property (nonatomic, strong) IBOutlet UIButton *textButton;
// Instance Variables
@property (nonatomic, strong) NSString *brotherFbId;
@property (nonatomic, assign) ABAddressBookRef addressBook;
@property (nonatomic, strong) NSMutableArray *menuArray;

// Instance Methods
+ (NSString *)formatToPhoneNumber:(NSNumber *)number;
- (IBAction)facebookBrother:(id)sender;
- (IBAction)callBrother:(id)sender;
- (IBAction)textBrother:(id)sender;
- (IBAction)emailBrother:(id)sender;
- (IBAction)addToOrUpdateContacts:(id)sender;

@end

@implementation DirectoryDetailsViewController

static NSString *lNameKey = @"Last_Name",
                *pNameKey = @"Preferred_Name",
                *emailKey = @"Email_Address",
                *phoneKey = @"Phone_Number",
                *yearKey  = @"Graduation_Year",
                *classKey = @"Pledge_Class",
                *majorKey = @"Major";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Get strings for labels.
    NSString *fNameKey  =
        [_brotherDetails[pNameKey] isEqualToString:@""] ? @"First_Name" : pNameKey;
    
    NSString *firstName = _brotherDetails[fNameKey],
             *lastName  = _brotherDetails[lNameKey],
             *brotherName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    [self.navigationItem setTitle:brotherName];
    
    NSString *yearString =
        [NSString stringWithFormat:@"    %@", [_brotherDetails[yearKey] stringValue]];
    NSString *pledgeClassString =
        [NSString stringWithFormat:@"    %@", _brotherDetails[classKey]];
    NSString *phoneNumberString =
        [_brotherDetails[phoneKey] respondsToSelector:@selector(stringValue)] ?
        [_brotherDetails[phoneKey] stringValue] : _brotherDetails[phoneKey];
    
    // Fill in labels.
    [_emailButton setTitle:_brotherDetails[emailKey] forState:UIControlStateNormal];
    [_phoneButton setTitle:phoneNumberString forState:UIControlStateNormal];
    [_yearLabel  setText:yearString];
    [_classLabel setText:pledgeClassString];
    [_majorLabel setText:_brotherDetails[majorKey]];
    
    [self initProfilePicWithLastName:lastName firstName:firstName];
    [self initButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (NSString *)formatToPhoneNumber:(NSNumber *)number
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setPositiveFormat:@"###.###.####"];
    [formatter setLenient:YES];
    return [formatter stringFromNumber:number];
}

- (IBAction)callBrother:(id)sender
{
    NSString *phoneUrlString =
        [NSString stringWithFormat:@"telprompt://%@", [_brotherDetails objectForKey:phoneKey]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneUrlString]];
}

- (IBAction)facebookBrother:(id)sender
{
    NSString *urlString = [@"fb://profile/" stringByAppendingString:_brotherFbId];
    NSURL *facebookURL = [NSURL URLWithString:urlString];
    
    if (![[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        urlString = [@"https://www.facebook.com/" stringByAppendingString:_brotherFbId];
    }
    
    [[UIApplication sharedApplication] openURL:facebookURL];
}

- (IBAction)textBrother:(id)sender
{
    NSString *textUrlString =
        [NSString stringWithFormat:@"sms:%@", [_brotherDetails objectForKey:phoneKey]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:textUrlString]];
}

- (IBAction)emailBrother:(id)sender
{
    // Set up the message view and controller.
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc setMailComposeDelegate:self];
    [mc setToRecipients:@[_brotherDetails[emailKey]]];
    
    // Activate the view.
    [self presentViewController:mc animated:YES completion:nil];
}

- (void)initProfilePicWithLastName:(NSString *)lastName firstName:(NSString *)firstName
{
    // Try to acquire and display the FB profile picture.
    FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        for (NSDictionary *friend in [result objectForKey:@"data"]) {
            if ([[friend objectForKey:@"last_name"] isEqualToString:lastName]
                && [[friend objectForKey:@"first_name"] isEqualToString:firstName]) {
                [_profilePictureView setProfileID:[friend objectForKey:@"id"]];
                break;
            }
        }
    }];
}

- (void)initButtons
{
    // Disable buttons if functionality is not present.
    if (![MFMailComposeViewController canSendMail]) {
        [_emailButton setEnabled:NO];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms:816-373-8667"]]) {
        [_textButton setEnabled:NO];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt://816-373-8667"]]) {
        [_phoneButton setEnabled:NO];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"We were unable to send your email. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)addToOrUpdateContacts:(id)sender
{
    ABUnknownPersonViewController *addContactView = [[ABUnknownPersonViewController alloc] init];
    // [addContactView setUnknownPersonViewDelegate:self];
    [addContactView setAllowsAddingToAddressBook:YES];

#pragma warning - incomplete method implementation
    // view.displayedPerson = person; // Assume person is already defined.
    
    [self.navigationController pushViewController:addContactView animated:YES];
}

@end
