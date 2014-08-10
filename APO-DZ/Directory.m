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


- (NSArray *)brotherDirectory
{
    // Lazily instantiate directory.
    if (_brotherDirectory) return _brotherDirectory;
    
    _brotherDirectory = [[self class] directoryWithUrlString:DIRECTORY_BROTHERS_JSON
                                                   sheetKey:@"ActiveBrotherDirectory"];
    
    return _brotherDirectory;
}

- (NSArray *)pledgeDirectory
{
    // Lazily instantiate directory.
    if (_pledgeDirectory) return _pledgeDirectory;
    
    _pledgeDirectory = [[self class] directoryWithUrlString:DIRECTORY_PLEDGE_JSON
                                                   sheetKey:@"PledgeDirectory"];
    
    return _pledgeDirectory;
}

+ (NSArray *)directoryWithUrlString:(NSString *)url sheetKey:(NSString *)sheetKey
{
    NSDictionary *jsonDictionary;
    
    if ([RSMWebRequestManager doesHaveInternetConnection]) {
        // Acquire data from the internet if possible for most updated version.
        NSError *jsonError;
        NSData *directoryData = [RSMWebRequestManager dataFromUrlString:url];
        jsonDictionary = [NSJSONSerialization JSONObjectWithData:directoryData
                                                            options:0
                                                              error:&jsonError];
    }
    
    return [jsonDictionary objectForKey:sheetKey];
}


@end
