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
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *emailLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel;
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
                *yearKey  = @"Expected_Graduation_Year",
                *classKey = @"Pledge_Class",
                *majorKey = @"Major";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Get strings for labels.
    NSString *fNameKey  = [[_brotherDetails objectForKey:pNameKey] isEqualToString:@""] ?  @"First_Name" : pNameKey,
             *firstName = [_brotherDetails objectForKey:fNameKey],
             *lastName  = [_brotherDetails objectForKey:lNameKey],
             *brotherName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    NSString *phoneNumberString =
        [[_brotherDetails objectForKey:phoneKey] respondsToSelector:@selector(stringValue)] ? [[_brotherDetails objectForKey:phoneKey] stringValue] : [_brotherDetails objectForKey:phoneKey];
    
    // Fill in labels.
    [_nameLabel  setText:brotherName];
    [_emailLabel setText:[_brotherDetails  objectForKey:emailKey]];
    [_phoneLabel setText:phoneNumberString];
    [_yearLabel  setText:[[_brotherDetails objectForKey:yearKey]  stringValue]];
    [_classLabel setText:[_brotherDetails  objectForKey:classKey]];
    [_majorLabel setText:[_brotherDetails  objectForKey:majorKey]];
    
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
    
    // Disable buttons if functionality is not present.
    if (![MFMailComposeViewController canSendMail]) {
        [_emailButton setEnabled:NO];
        [_emailButton setHidden:YES];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sms:816-373-8667"]]) {
        [_textButton setEnabled:NO];
        [_textButton setHidden:YES];
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"telprompt://816-373-8667"]]) {
        [_phoneButton setEnabled:NO];
        [_phoneButton setHidden:YES];
    }
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
    [mc setToRecipients:[NSArray arrayWithObject:[_brotherDetails objectForKey:emailKey]]];
    
    // Activate the view.
    [self presentViewController:mc animated:YES completion:nil];
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
