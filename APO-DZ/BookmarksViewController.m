//
//  BookmarksViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/26/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "BookmarksViewController.h"
#import "URLs.h"

// RGB Color Utility
#define RgbUIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define HEADER_HEIGHT 30


@interface BookmarksViewController ()

// Links
+ (void)openGoogleDocWithUrlString:(NSString *)docAddressUrlString;
+ (void)openFbPage;
+ (void)openFbGroup;

@end

@implementation BookmarksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
    Sheets {
        Brotherhood
        Pledges
        Big-Little
        Food Groups
    }
    Reporting {
        Report a project
        Reflect on service
        Create a fellowship
        Report your fellowship
        Give a (de-)merit
        Report big-little hangout
        Report your food group
        Send a shoutout
        Request a reimbursement
        Tell Board
    }
    General {
        National Website
        Chapter Website
        Board Feedback
        Ye Olde Service Forum
    }
    Social Media {
        DZ Facebook Page
        DZ Active Brothers Group
        YouTube
        Instagram
        Tumblr
        APOutOfContext
    }
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // 0 = Sheets; 1 = Reporting; 2 = General; 3 = Social Media
    return 4;
}

#pragma mark Table view headers

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    static NSString *headerTitle;
    switch (section) {
        case 0:
            headerTitle = @"Reporting Forms";
            break;
        case 1:
            headerTitle = @"Sheets";
            break;
        case 2:
            headerTitle = @"General";
            break;
        case 3:
            headerTitle = @"Social Media";
            break;
    }
    return headerTitle;
}

#pragma mark Table view content


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowsInSection;
    switch (section) {
        // Sheets
        case 0:
            rowsInSection = 11;
            break;
        // Reporting
        case 1:
            rowsInSection = 4;
            break;
        // General
        case 2:
            rowsInSection = 4;
            break;
        // Social Media
        case 3:
            rowsInSection = 6;
            break;
        // ERRORS
        default:
            rowsInSection = -1;
            break;
    }
    
    return rowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier  = @"LinkCell",
             *cellLabelString = @"";
    
    // Configure the cell...
    switch (indexPath.section) {
        // Reporting
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellLabelString = @"Report a project";
                    break;
                case 1:
                    cellLabelString = @"Reflect on service";
                    break;
                case 2:
                    cellLabelString = @"Withdraw from a project";
                    break;
                case 3:
                    cellLabelString = @"Create a fellowship";
                    break;
                case 4:
                    cellLabelString = @"Report your fellowship";
                    break;
                case 5:
                    cellLabelString = @"Give a (de-)merit";
                    break;
                case 6:
                    cellLabelString = @"Report big-little hangout";
                    break;
                case 7:
                    cellLabelString = @"Report your food group";
                    break;
                case 8:
                    cellLabelString = @"Send a shoutout";
                    break;
                case 9:
                    cellLabelString = @"Request a reimbursement";
                    break;
                case 10:
                    cellLabelString = @"Tell Board";
                    break;
                default:
                    break;
            }
            break;
        // Sheets
        case 1:
            switch (indexPath.row) {
                case 0:
                    cellLabelString = @"Brotherhood";
                    break;
                case 1:
                    cellLabelString = @"Pledges";
                    break;
                case 2:
                    cellLabelString = @"Big-Little";
                    break;
                case 3:
                    cellLabelString = @"Food-Groups";
                    break;
                default:
                    break;
            }
            break;
        // General
        case 2:
            switch (indexPath.row) {
                case 0:
                    cellLabelString = @"National Website";
                    break;
                case 1:
                    cellLabelString = @"Chapter Website";
                    break;
                case 2:
                    cellLabelString = @"Board Feedback";
                    break;
                case 3:
                    cellLabelString = @"Ye Olde Service Forum";
                    break;
                default:
                    break;
            }
            break;
        // Social Media
        case 3:
            switch (indexPath.row) {
                case 0:
                    cellLabelString = @"Facebook Page";
                    break;
                case 1:
                    cellLabelString = @"Active Bros FB Group";
                    break;
                case 2:
                    cellLabelString = @"YouTube Channel";
                    break;
                case 3:
                    cellLabelString = @"Instagram";
                    break;
                case 4:
                    cellLabelString = @"tumblr";
                    break;
                case 5:
                    cellLabelString = @"APOutOfContext";
                    break;
                default:
                    break;
            }
            break;
        // ERRORS
        default:
            break;
    }
    
    // Get the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    // Set the label.
    UILabel *cellLabel = (id)[cell viewWithTag:1];
    [cellLabel setText:cellLabelString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *urlToOpen;
    switch (indexPath.section) {
        // Reporting
        case 0:
            switch (indexPath.row) {
                case 0:
                    urlToOpen = SERVICE_RPRT_FORM_URL;
                    break;
                case 1:
                    urlToOpen = SERVICE_REFL_FORM_URL;
                    break;
                case 2:
                    urlToOpen = SERVICE_WITHDRAW_FORM_URL;
                    break;
                case 3:
                    urlToOpen = FELLOWS_HOST_FORM_URL;
                    break;
                case 4:
                    urlToOpen = FELLOWS_RPRT_FORM_URL;
                    break;
                case 5:
                    urlToOpen = MERIT_DEMERIT_RPRT_FORM_URL;
                    break;
                case 6:
                    urlToOpen = BIGLITL_RPRT_FORM_URL;
                    break;
                case 7:
                    urlToOpen = FOODGRP_RPRT_FORM_URL;
                    break;
                case 8:
                    urlToOpen = SHOUTOUT_FORM_URL;
                    break;
                case 9:
                    urlToOpen = REIMBURSE_RPRT_FORM_URL;
                    break;
                case 10:
                    urlToOpen = BOARD_FEEDBACK_URL;
                    break;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
            break;
        // Sheets
        case 1:
            switch (indexPath.row) {
                case 0:
                    urlToOpen = BROTHR_SHT_URL;
                    break;
                case 1:
                    urlToOpen = PLEDGE_SHT_URL;
                    break;
                case 2:
                    urlToOpen = BIGLIT_SHT_URL;
                    break;
                case 3:
                    urlToOpen = FD_GRP_SHT_URL;
                    break;
                default:
                    break;
            }
            [self.class openGoogleDocWithUrlString:urlToOpen];
            break;
        // General
        case 2:
            switch (indexPath.row) {
                case 0:
                    urlToOpen = NATIONAL_SITE_URL;
                    break;
                case 1:
                    urlToOpen = CHAPTER_SITE_URL;
                    break;
                case 2:
                    urlToOpen = SERVICE_FORUM_URL;
                    break;
                default:
                    break;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
            break;
        // Social Media
        case 3:
            switch (indexPath.row) {
                case 0:
                    [BookmarksViewController openFbPage];
                    break;
                case 1:
                    [BookmarksViewController openFbGroup];
                    break;
                case 2:
                    urlToOpen = YOUTUBE_CHANNEL_URL;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
                    break;
                case 3:
                    urlToOpen = INSTAGRAM_URL;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
                    break;
                case 4:
                    urlToOpen = TUMBLR_URL;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
                    break;
                case 5:
                    urlToOpen = APOUTOFCONTEXT_URL;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlToOpen]];
                    break;
                default:
                    break;
            }
            break;
        // ERRORS
        default:
            NSLog(@"BookmarksController: uncaught case in didSelectRowAtIndexPath");
            break;
    }
}

+ (void)openGoogleDocWithUrlString:(NSString *)docAddressUrlString
{
    NSURL *driveURL =
        [NSURL URLWithString:[@"googledrive://" stringByAppendingString:docAddressUrlString]];
    if ([[UIApplication sharedApplication] canOpenURL:driveURL]) {
        [[UIApplication sharedApplication] openURL:driveURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:docAddressUrlString]];
    }
}

+ (void)openFbPage
{
    NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/324921860906338"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/upennapo"]];
    }
}

+ (void)openFbGroup
{
    NSURL *facebookGroupURL = [NSURL URLWithString:@"fb://group/164243926970825"];
    if ([[UIApplication sharedApplication] canOpenURL:facebookGroupURL]) {
        [[UIApplication sharedApplication] openURL:facebookGroupURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/apodz1/"]];
    }
}

+ (void)openTumblr
{
    NSString *urlString = [@"tumblr://x-callback-url/link?url=" stringByAppendingString:TUMBLR_URL];
    NSURL *tumblrUrl = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:tumblrUrl]) {
        [[UIApplication sharedApplication] openURL:tumblrUrl];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TUMBLR_URL]];
    }
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
