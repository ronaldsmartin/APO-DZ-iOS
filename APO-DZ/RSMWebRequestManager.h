//
//  RSMWebRequestManager.h
//  APO-DZ
//
//  Created by Ronald Martin on 10/15/13.
//  Copyright (c) 2013 Ronald Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSMWebRequestManager : NSObject

+ (BOOL)doesHaveInternetConnection;
+ (NSData *)dataFromUrl:(NSURL *)url;
+ (NSData *)dataFromUrlString:(NSString *)urlString;
+ (void)raiseNoInternetAlert;

@end
