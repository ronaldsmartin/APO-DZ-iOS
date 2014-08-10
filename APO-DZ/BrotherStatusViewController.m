//
//  BrotherStatusViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/21/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "BrotherStatusViewController.h"

#import <FacebookSDK/FBRequestConnection.h>
#import "RSMWebRequestManager.h"
#import "Brother.h"

#define RgbUIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface BrotherStatusViewController ()

// Properties
@property (nonatomic, retain) __block Brother *broData;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

// Methods

@end

@implementation BrotherStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Retrieve name.
    NSString *firstName = [[NSUserDefaults standardUserDefaults]objectForKey:@"first_name"],
    *lastName  = [[NSUserDefaults standardUserDefaults]objectForKey:@"last_name"];
    
    // Acquire requirement data from the Spreadsheet.
    _broData = [[Brother alloc] initWithFirstName:firstName
                                         lastName:lastName];
    
    // Activate label on successful login.
    if ([_broData brotherStatus]) {
        [_nameLabel setText:[NSString stringWithFormat:@"%@ %@ - %@", firstName, lastName, [_broData brotherStatus]]];
    } else {
        [_nameLabel setText:@"Unable to login. Please change your user credentials."];
        [_nameLabel setBackgroundColor:RgbUIColor(204, 51, 51)];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    /* 
     0: Summary
     1: Service
     2: Fellowship
     3: Membership
     */
    return 4;
}

/*------------------------> TABLE SECTION HEADERS <------------------------*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setBackgroundColor:[UIColor blackColor]];
    [headerLabel setTextColor:RgbUIColor(221, 174, 51)];
    [headerLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:17.0]];
    
    static NSString *headerTitle;
    switch (section) {
        case 0:
            headerTitle = @"Summary";
            break;
        case 1:
            headerTitle = @"Service";
            break;
        case 2:
            headerTitle = @"Fellowship";
            break;
        case 3:
            headerTitle = @"Membership";
            break;
    }
    [headerLabel setText:headerTitle];
    
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

/*------------------------> TABLE ROW CONTENTS <------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger numRows;
    switch (section) {
        case 0:
            // Total Completion; Service Completion; Fellowship Completion; Membership Completion
            numRows = 4;
        case 1:
            // Hours; Mandatory; Publicity; Hosting
            numRows = 4;
            break;
        case 2:
            // Points; Hosting
            numRows = 2;
            break;
        case 3:
            // Points; Pledge Comp.; Bro Comp.
            numRows = 3;
            break;
    }
    
    // Add one for section header cell.
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RequirementCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    // Configure the cell...
    
    // Set cell labels.
    UILabel *reqNameLabel  = (id)[cell viewWithTag:1],
            *reqValueLabel = (id)[cell viewWithTag:2];
    
    static NSString *reqName;
    NSString *reqValue;
    BOOL complete;
    
    switch ([indexPath indexAtPosition:0]) {
        case 0:
            // Get the right text.
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    reqName = @"Everything:";
                    complete = [_broData doneWithRequirements];
                    break;
                case 1:
                    reqName = @"Service:";
                    complete = [_broData doneWithService];
                    break;
                case 2:
                    reqName = @"Fellowship:";
                    complete = [_broData doneWithFellowship];
                    break;
                case 3:
                    reqName = @"Membership";
                    complete = [_broData doneWithMembership];
                    break;
            }
            reqValue = complete ? @"Complete!" : @"Incomplete";
            break;
        case 1:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    reqName = @"Service Hours:";
                    reqValue = [_broData serviceHours] && [_broData reqServiceHours] ?
                                [NSString stringWithFormat:@"%@ / %@",
                                 [_broData serviceHours], [_broData reqServiceHours]] :
                                @"Loading...";
                    complete = ![reqValue isEqualToString:@"Loading..."] &&
                                [_broData serviceHours] >= [_broData reqServiceHours];
                    break;
                case 1:
                    reqName  = @"Mandatory:";
                    complete = [_broData mandatoryServiceDone];
                    reqValue = complete ? @"Complete!" : @"Incomplete";
                    break;
                case 2:
                    reqName  = @"Publicity:";
                    complete = [_broData publicityDone];
                    reqValue = complete ? @"Complete!" : @"Incomplete";
                    break;
                case 3:
                    reqName  = @"Service Hosting:";
                    complete = [_broData serviceHostingDone];
                    reqValue = complete ? @"Complete!" : @"Incomplete";
                    break;
            }
            break;
        case 2:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    reqName  = @"Fellowship Points:";
                    reqValue = [_broData fellowshipPoints] && [_broData reqFellowshipPoints] ?
                                [NSString stringWithFormat:@"%@ / %@",
                                 [_broData fellowshipPoints], [_broData reqFellowshipPoints]] :
                                @"Loading";
                    complete = ![reqValue isEqualToString:@"Loading..."] &&
                                [_broData fellowshipPoints] >= [_broData reqFellowshipPoints];
                    break;
                case 1:
                    reqName  = @"Fellowship Hosting:";
                    complete = [_broData fellowshipHostingDone];
                    reqValue = complete ? @"Complete!" : @"Incomplete";
            }
            break;
        case 3:
            switch ([indexPath indexAtPosition:1]) {
                case 0:
                    reqName  = @"Membership Points:";
                    reqValue = [_broData membershipPoints] && [_broData reqMembershipPoints] ?
                                [NSString stringWithFormat:@"%@ / %@",
                                 [_broData membershipPoints], [_broData reqMembershipPoints]] :
                               @"Loading...";
                    complete = ![reqValue isEqualToString:@"Loading..."] &&
                                [_broData membershipPoints] >= [_broData reqMembershipPoints];
                    break;
                case 1:
                    reqName = @"Pledge Component:";
                    complete = [_broData pledgeComponentDone];
                    reqValue = complete ? @"Complete!" : @"Incomplete";
                    break;
                case 2:
                    reqName = @"Brother Component:";
                    complete = [_broData brotherComponentDone];
                    reqValue = complete ? @"Complete!" : @"Incomplete";
                    break;
            }
            break;
    }
    
    [reqNameLabel  setText:reqName];
    [reqValueLabel setText:reqValue];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    #pragma mark - potentially incomplete function
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
