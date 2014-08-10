//
//  RSMWebRequestManager.m
//  APO-DZ
//
//  Created by Ronald Martin on 10/15/13.
//  Copyright (c) 2013 Ronald Martin. All rights reserved.
//

#import "Reachability.h"
#import "RSMWebRequestManager.h"

@implementation RSMWebRequestManager

+ (BOOL)doesHaveInternetConnection
{
    // Use Apple Reachabilitiy to assess network connection.
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    return [networkReachability currentReachabilityStatus] != NotReachable;
}

+ (NSData *)dataFromUrl:(NSURL *)url
{
    // Create outlets for the URL response and error (for debugging)
    NSURLResponse *urlResponse;
    NSError       *urlError;
    
    if ([self doesHaveInternetConnection]) {
        // Get data from a URL.
        return [NSURLConnection
                sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                returningResponse:&urlResponse
                error:&urlError];
    } else {
        NSLog(@"WebRequestManager: Unable to retrieve data from %@.", url);
        return nil;
    }
}

+ (NSData *)dataFromUrlString:(NSString *)urlString
{
    return [self dataFromUrl:[NSURL URLWithString:urlString]];
}

+ (void)raiseNoInternetAlert
{
    UIAlertView *noInternetAlert =
    [[UIAlertView alloc] initWithTitle:@"Unable to Load"
                               message:@"This app requires a network connection. Please try again when you are connected to the internet."
                              delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil, nil];
    [noInternetAlert show];
}

@end
