//
//  URLs.h
//  APO-DZ
//
//  Created by Ronald Martin on 25/3/14.
//  Copyright (c) 2014 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLs : NSObject

extern NSString *APP_PASSWORD;

extern NSString *DIRECTORY_BROTHERS_JSON;
extern NSString *DIRECTORY_PLEDGE_JSON;
extern NSString *BROTHER_DATA_JSON;
extern NSString *CALENDAR_DEFAULT;
+ (NSString *)calendarUrlWithHeightString:(NSString *)height WidthString:(NSString *)width;
+ (NSString *)calendarUrlWithHeightFloat:(CGFloat)height widthFloat:(CGFloat)width;


/*-----------------------------> LINKS <-----------------------------*/
// Sheets
extern NSString *BROTHR_SHT_URL;
extern NSString *PLEDGE_SHT_URL;
extern NSString *BIGLIT_SHT_URL;
extern NSString *FD_GRP_SHT_URL;

// Forms
extern NSString *SERVICE_RPRT_FORM_URL;
extern NSString *SERVICE_REFL_FORM_URL;
extern NSString *FELLOWS_HOST_FORM_URL;
extern NSString *FELLOWS_RPRT_FORM_URL;
extern NSString *STDYGRP_RPRT_FORM_URL;
extern NSString *FOODGRP_RPRT_FORM_URL;
extern NSString *BIGLITL_RPRT_FORM_URL;
extern NSString *MERIT_DEMERIT_RPRT_FORM_URL;
extern NSString *REIMBURSE_RPRT_FORM_URL;

// Sites
extern NSString *NATIONAL_SITE_URL;
extern NSString *CHAPTER_SITE_URL;
extern NSString *BOARD_FEEDBACK_URL;
extern NSString *SERVICE_FORUM_URL;

// Social Media
extern NSString *YOUTUBE_CHANNEL_URL;
extern NSString *INSTAGRAM_URL;
extern NSString *TUMBLR_URL;
extern NSString *APOUTOFCONTEXT_URL;

/*-----------------------------> END LINKS <-----------------------------*/

@end
