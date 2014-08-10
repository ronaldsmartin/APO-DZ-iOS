//
//  Brother.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/21/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "Brother.h"
#import "RSMWebRequestManager.h"
#import "URLs.h"

#define SCRIPT_URL @"https://script.google.com/macros/s/AKfycbyH2NyHcbjhBa6mNFPj5rQ9BgvNZ4hKdZmkXWTdCrQFpbwvEKo/exec?id=0AkIjNxyzqN0_dFFWa2VCdnVOaDFvNmNoTEVaWDhoNHc&sheet=Summary"


@implementation Brother



- (id)initWithFirstName:(NSString *)fName lastName:(NSString *)lName
{
    self = [super init];
    
    if (self && [RSMWebRequestManager doesHaveInternetConnection]) {
        // Pull brotherhood data
        NSData *jsonData = [RSMWebRequestManager dataFromUrlString:BROTHER_DATA_JSON];
        NSError *jsonError;
        NSDictionary *sheetJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
        
        NSArray *records = [sheetJson objectForKey:@"records"];
        
        // Assign name
        _firstName = fName;
        _lastName  = lName;
        
        // Find brother data
        NSDictionary *broData;
        for (NSDictionary *personDict in records) {
            if ([[personDict objectForKey:@"Last_Name"]  isEqualToString:lName] &&
                [[personDict objectForKey:@"First_Name"] isEqualToString:fName]) {
                
                broData = personDict;
                NSLog(@"Brother Data: %@", broData);
                break;
            }
        }
        
        // Assign values based on name
        _brotherStatus         = [broData objectForKey:@"Status"];
        _doneWithRequirements  = [[broData valueForKey:@"Complete"] boolValue];
        
        _doneWithService       = [[broData objectForKey:@"Service"] boolValue];
        _serviceHours          = [broData objectForKey:@"Service_Hours"];
        _reqServiceHours       = [broData objectForKey:@"Required_Service_Hours"];
        _mandatoryServiceDone  = [[broData objectForKey:@"Large_Group_Project"] boolValue];
        _publicityDone         = [[broData objectForKey:@"Publicity"] boolValue];
        _serviceHostingDone    = [[broData objectForKey:@"Service_Hosting"] boolValue];

        _doneWithFellowship    = [[broData objectForKey:@"Fellowship"] boolValue];
        _fellowshipPoints      = [broData objectForKey:@"Fellowship_Points"];
        _reqFellowshipPoints   = [broData objectForKey:@"Required_Fellowship"];
        _fellowshipHostingDone = [[broData objectForKey:@"Fellowship_Hosting"] boolValue];
        
        _doneWithMembership    = [[broData objectForKey:@"Membership"] boolValue];
        _membershipPoints      = [broData objectForKey:@"Membership_Points"];
        _reqMembershipPoints   = [broData objectForKey:@"Required_Membership_Points"];
        _pledgeComponentDone   = [[broData objectForKey:@"Pledge_Comp"] boolValue];
        _brotherComponentDone  = [[broData objectForKey:@"Brother_Comp"] boolValue];
    }
    
    return self;
}

@end
