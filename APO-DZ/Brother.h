//
//  Brother.h
//  APO-DZ
//
//  Created by Ronald Martin on 12/21/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brother : NSObject



// Name and Status
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *brotherStatus;

// High-Level Completion
@property (nonatomic) BOOL doneWithRequirements;

// Service Details
@property (nonatomic) BOOL doneWithService;
@property (nonatomic, strong) NSNumber *serviceHours;
@property (nonatomic, strong) NSNumber *reqServiceHours;
@property (nonatomic) BOOL mandatoryServiceDone;
@property (nonatomic) BOOL publicityDone;
@property (nonatomic) BOOL serviceHostingDone;

// Fellowship Details
@property (nonatomic) BOOL doneWithFellowship;
@property (nonatomic, strong) NSNumber *fellowshipPoints;
@property (nonatomic, strong) NSNumber *reqFellowshipPoints;
@property (nonatomic) BOOL fellowshipHostingDone;

// Membership Details
@property (nonatomic) BOOL doneWithMembership;
@property (nonatomic, strong) NSNumber *membershipPoints;
@property (nonatomic, strong) NSNumber *reqMembershipPoints;
@property (nonatomic) BOOL pledgeComponentDone;
@property (nonatomic) BOOL brotherComponentDone;

// Public Methods
- (id)initWithFirstName:(NSString *)fName lastName:(NSString *)lName;

@end
