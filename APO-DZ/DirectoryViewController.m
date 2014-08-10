//
//  DirectoryViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/23/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "DirectoryViewController.h"
#import "Directory.h"
#import "DirectoryDetailsViewController.h"

#define HEADER_HEIGHT 49
#define RgbUIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface DirectoryViewController ()

// Property
@property (nonatomic, retain) NSArray *brotherInfo;
@property (nonatomic, retain) NSArray *pledgesInfo;
@property (nonatomic, strong) NSDictionary *detailsForPressed;

- (void)retrieveDirectories;

@end

@implementation DirectoryViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveDirectories];
}

- (void)retrieveDirectories
{
    // Attempt to access the cached directory data
    _brotherInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"directory_brothers"];
    _pledgesInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"directory_pledges"];
    
    // Retrieve directories from back-end if we don't have them locally.
    if (!_brotherInfo || !_pledgesInfo) {
        
        // Use the JSON directory retrieval script to set the directory if we don't have a cached dictionary.
        Directory *directory = [[Directory alloc] init];
        _brotherInfo = [directory brotherDirectory];
        _pledgesInfo = [directory pledgeDirectory];
        
        // Cache the data for later use.
        [[NSUserDefaults standardUserDefaults] setObject:_brotherInfo
                                                  forKey:@"directory_brothers"];
        [[NSUserDefaults standardUserDefaults] setObject:_pledgesInfo
                                                  forKey:@"directory_pledges"];
        [[NSUserDefaults standardUserDefaults] synchronize];
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
    return 2;
}


/*------------------------> TABLE SECTION HEADERS <------------------------*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // Make sure height matches the height of the header in
    // heightForHeaderInSection!
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEADER_HEIGHT)];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setBackgroundColor:RgbUIColor(45, 72, 133)];
    [headerLabel setTextColor:RgbUIColor(221, 174, 51)];
    [headerLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:23.0]];
    
    // Set the title for the section.
    switch (section) {
        case 0:
            [headerLabel setText:@"BROTHERHOOD DIRECTORY"];
            break;
        case 1:
            [headerLabel setText:@"PLEDGE DIRECTORY"];
            break;
        default:
            break;
    }
    
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Make sure this matches the height of the header in viewForHeaderInSection!
    return HEADER_HEIGHT;
}


/*---------------------------> TABLE ROW DATA <---------------------------*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    switch (section) {
        case 0:
            if (!_brotherInfo) return 0;
            else return [_brotherInfo count];
        case 1:
            if (!_pledgesInfo) return 0;
            else return [_pledgesInfo count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrotherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *nameLabel = (id) [cell viewWithTag:1],
            *detailsLabel = (id) [cell viewWithTag:2];

    NSArray *memberData = [indexPath indexAtPosition:0] == 0 ? _brotherInfo : _pledgesInfo;
    NSDictionary *brotherData = [memberData objectAtIndex:[indexPath indexAtPosition:1]];
    NSString *lastName    = [brotherData objectForKey:@"Last_Name"],
             *firstName   = [[brotherData objectForKey:@"Preferred_Name"] isEqualToString:@""] ?
                              [brotherData objectForKey:@"First_Name"] :
                              [brotherData objectForKey:@"Preferred_Name"],
             *pledgeclass = [brotherData objectForKey:@"Pledge_Class"];
    
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
    [detailsLabel setText:[NSString stringWithFormat:@"%@", pledgeclass]];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *memberData = [indexPath indexAtPosition:0] == 0 ? _brotherInfo : _pledgesInfo;
    _detailsForPressed = [memberData objectAtIndex:[indexPath indexAtPosition:1]];
    [self performSegueWithIdentifier:@"DirectoryDetailsSegue" sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"DirectoryDetailsSegue"]) {
        DirectoryDetailsViewController *directoryDetails = [segue destinationViewController];
        [directoryDetails setBrotherDetails:_detailsForPressed];
    }
}


@end
