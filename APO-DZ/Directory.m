//
//  Directory.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/23/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "Directory.h"
#import "RSMWebRequestManager.h"
#import "URLs.h"


@implementation Directory

static NSString *BROTHER_SHEET_NAME = @"Brothers";
static NSString *PLEDGE_SHEET_NAME  = @"Pledges";
static NSString *ALUMNI_SHEET_NAME  = @"Alumni";

static NSString *BROTHER_STORAGE_KEY_OLD = @"directory_brothers";
static NSString *PLEDGE_STORAGE_KEY_OLD  = @"directory_pledges";
static NSString *ALUMNI_STORAGE_KEY_OLD  = @"directory_alumni";

- (Directory *)init
{
    self = [super init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (![prefs boolForKey:@"CLEARED_OLD"]) {
        [prefs removeObjectForKey:BROTHER_STORAGE_KEY_OLD];
        [prefs removeObjectForKey:PLEDGE_STORAGE_KEY_OLD];
        [prefs setBool:YES forKey:@"CLEARED_OLD"];
        [self refreshDirectories];
    }
    return self;
}

- (NSArray *)brotherDirectory
{
    // Lazily instantiate directory.
    if (_brotherDirectory) return _brotherDirectory;
    
    _brotherDirectory = [[self class] directoryForSheet:BROTHER_SHEET_NAME forceRefresh:NO];
    
    return _brotherDirectory;
}

- (NSArray *)pledgeDirectory
{
    // Lazily instantiate directory.
    if (_pledgeDirectory) return _pledgeDirectory;
    
    _pledgeDirectory = [[self class] directoryForSheet:PLEDGE_SHEET_NAME forceRefresh:NO];
    
    return _pledgeDirectory;
}

- (NSArray *)alumniDirectory
{
    // Lazily instantiate directory.
    if (_alumniDirectory) return _alumniDirectory;
    
    _alumniDirectory = [[self class] directoryForSheet:ALUMNI_SHEET_NAME forceRefresh:NO];
    
    return _alumniDirectory;
}

- (void)refreshDirectories
{
    _brotherDirectory = [[self class] directoryForSheet:BROTHER_SHEET_NAME forceRefresh:YES];
    _pledgeDirectory  = [[self class] directoryForSheet:PLEDGE_SHEET_NAME forceRefresh:YES];
    _alumniDirectory  = [[self class] directoryForSheet:ALUMNI_SHEET_NAME forceRefresh:YES];
}

+ (NSArray *)directoryForSheet:(NSString *)sheetName forceRefresh:(BOOL)forceRefresh
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *directory;
    
    if (forceRefresh) {
        // Redownload the directory.
        NSString *url = [DIRECTORY_SCRIPT stringByAppendingString:sheetName];
        NSLog(@"URL: %@", url);
        NSArray *directory = [[self class] directoryWithUrlString:url sheetKey:sheetName];
        
        // Cache the directory.
        [prefs setObject:directory forKey:sheetName];
        [prefs synchronize];
        
        NSLog(@"%@ Directory count: %lu\n\n", sheetName, (unsigned long) [[prefs objectForKey:sheetName] count]);
        
        return directory;
    } else if ((directory = [prefs objectForKey:sheetName])) {
        // Try to retrieve and return the directory
        return directory;
    } else {
        // The directory isn't cached, so force a download.
        return [[self class] directoryForSheet:sheetName forceRefresh:YES];
    }
}

+ (NSArray *)directoryWithUrlString:(NSString *)url sheetKey:(NSString *)sheetKey
{
    NSDictionary *jsonDictionary;
    
    if ([RSMWebRequestManager doesHaveInternetConnection]) {
        // Acquire data from the internet if possible for most updated version.
        NSError *jsonError;
        NSData *directoryData = [RSMWebRequestManager dataFromUrlString:url];
        if (directoryData == nil)
            return @[];
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:directoryData
                                                            options:0
                                                              error:&jsonError];
    }
    
    return [jsonDictionary objectForKey:sheetKey];
}


@end
