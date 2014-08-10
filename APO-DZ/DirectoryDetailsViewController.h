//
//  DirectoryDetailsViewController.h
//  APO-DZ
//
//  Created by Ronald Martin on 12/23/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DirectoryDetailsViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *brotherDetails;

@end
