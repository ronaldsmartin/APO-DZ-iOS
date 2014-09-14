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

#define HEADER_HEIGHT 30
#define RgbUIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

@interface DirectoryViewController ()

// Property
@property (nonatomic, retain) Directory *directory;
@property (nonatomic, retain) NSArray *brotherDirectory;
@property (nonatomic, retain) NSArray *pledgeDirectory;
@property (nonatomic, retain) NSArray *alumniDirectory;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, strong) NSDictionary *detailsForPressed;

- (void)retrieveDirectories;
- (void)refreshDirectoriesWithControl:(UIRefreshControl *)refreshControl;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end

@implementation DirectoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _directory = [[Directory alloc] init];
    [self retrieveDirectories];
    
    // Set up pull-to-refresh
    [self.refreshControl addTarget:self
                            action:@selector(refreshDirectoriesWithControl:)
                  forControlEvents:UIControlEventValueChanged];
    
    // Setting translucent to NO in the Storyboard doesn't work, so override here:
    // (Solution via http://stackoverflow.com/questions/19927542/ios7-backgroundimage-for-uisearchbar )
    [self.searchDisplayController.searchBar setBackgroundImage:[self.class imageWithColor:RgbUIColor(2, 136, 209)]
                                                forBarPosition:0
                                                    barMetrics:UIBarMetricsDefault];
}

- (void)retrieveDirectories
{
    _brotherDirectory = [_directory brotherDirectory];
    _pledgeDirectory  = [_directory pledgeDirectory];
    _alumniDirectory  = [_directory alumniDirectory];
}

- (void)refreshDirectoriesWithControl:(UIRefreshControl *)refreshControl
{
    [_directory refreshDirectories];
    [self retrieveDirectories];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
            [formatter stringFromDate:[NSDate date]]];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    else return 3;
}


#pragma mark - Table section headers

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    // Make sure height matches the height of the header in
    // heightForHeaderInSection!
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, HEADER_HEIGHT)];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerLabel setBackgroundColor:RgbUIColor(2, 136, 209)];
    [headerLabel setTextColor:RgbUIColor(221, 174, 51)];
    [headerLabel setFont:[UIFont fontWithName:@"Futura-CondensedExtraBold" size:18.0]];
    
    // Set the title for the section.
    switch (section) {
        case 0:
            [headerLabel setText:@"BROTHERS"];
            break;
        case 1:
            [headerLabel setText:@"PLEDGES"];
            break;
        case 2:
            [headerLabel setText:@"ALUMNI"];
            break;
        default:
            break;
    }
    
    return headerLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // Make sure this matches the height of the header in viewForHeaderInSection!
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    else return HEADER_HEIGHT;
}


#pragma mark - Table data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_searchResults count];
    }

    // When not searching, use three sections.
    switch (section) {
        case 0:
            if (!_brotherDirectory) return 0;
            else return [_brotherDirectory count];
        case 1:
            if (!_pledgeDirectory) return 0;
            else return [_pledgeDirectory count];
        case 2:
            if (!_alumniDirectory) return 0;
            else return [_alumniDirectory count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BrotherCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UILabel *nameLabel = (id) [cell viewWithTag:1],
            *detailsLabel = (id) [cell viewWithTag:2];

    NSArray *memberData;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        memberData = _searchResults;
    } else switch (indexPath.section) {
        case 0:
            memberData = _brotherDirectory;
            break;
        case 1:
            memberData = _pledgeDirectory;
            break;
        case 2:
            memberData = _alumniDirectory;
            break;
        default:
            memberData = @[];
            break;
    }
    
    NSDictionary *brotherData = memberData[indexPath.row];
    NSString *lastName    = brotherData[@"Last_Name"],
             *firstName   = [brotherData[@"Preferred_Name"] isEqualToString:@""] ?
                brotherData[@"First_Name"] : brotherData[@"Preferred_Name"],
             *pledgeclass = brotherData[@"Pledge_Class"];
    
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
    [detailsLabel setText:[NSString stringWithFormat:@"%@", pledgeclass]];
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSArray *memberData;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        memberData = _searchResults;
    } else switch (indexPath.section) {
        case 0:
            memberData = _brotherDirectory;
            break;
        case 1:
            memberData = _pledgeDirectory;
            break;
        case 2:
            memberData = _alumniDirectory;
            break;
        default:
            memberData = @[];
            break;
    }
    
    _detailsForPressed = memberData[indexPath.row];
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

#pragma mark - Search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    // Combine all directories
    _searchResults = [NSMutableArray arrayWithArray:_brotherDirectory];
    [_searchResults addObjectsFromArray:_pledgeDirectory];
    [_searchResults addObjectsFromArray:_alumniDirectory];
    
    // Create predicates and filter
    NSPredicate *firstNamePredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"First_Name", searchText],
                *preferredNamePredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"Preferred_Name", searchText],
                *lastNamePredicate  = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"Last_Name", searchText],
                *pledgeClassPredicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", @"Pledge_Class", searchText];
    
    NSPredicate *resultPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[firstNamePredicate, preferredNamePredicate, lastNamePredicate, pledgeClassPredicate]];
    
    [_searchResults filterUsingPredicate:resultPredicate];
    
    // Sort results
    [_searchResults sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = a[@"First_Name"];
        NSDate *second = b[@"First_Name"];
        return [first compare:second];
    }];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchResults removeAllObjects];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchDisplayController.searchResultsTableView reloadData];
}

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
