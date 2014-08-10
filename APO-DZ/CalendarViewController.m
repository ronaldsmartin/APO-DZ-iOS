//
//  CalendarViewController.m
//  APO-DZ
//
//  Created by Ronald Martin on 12/22/13.
//  Copyright (c) 2013 Alpha Phi Omega, Delta Zeta Chapter. All rights reserved.
//

#import "CalendarViewController.h"
#import "RSMWebRequestManager.h"
#import "URLs.h"

@interface CalendarViewController ()

// Properties
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UIWebView *calendarWebView;

// Instance Methods
- (void)loadCalendar;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self.view bringSubviewToFront:_loadingIndicator];
    [_loadingIndicator setColor:[UIColor blackColor]];
    [_loadingIndicator startAnimating];
    
    if (![RSMWebRequestManager doesHaveInternetConnection]) {
        [RSMWebRequestManager raiseNoInternetAlert];
        [_loadingLabel setText:@"Unable to Load."];
    } else {
        [self loadCalendar];
        [_loadingLabel setText:@""];
    }
    
    [_loadingIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCalendar
{
    [_calendarWebView setDelegate:self];
    [[_calendarWebView scrollView] setScrollEnabled:NO];
    
    // Get the URL for the calendar with the appropriate window size.
    CGSize windowSize = _calendarWebView.frame.size;
    NSString *calendarHtml = [URLs calendarUrlWithHeightFloat:windowSize.height - 10
                                                   widthFloat:windowSize.width - 15];
    
    // Load the request into the Web View
    [_calendarWebView loadHTMLString:calendarHtml baseURL:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *webViewErrorAlert =
    [[UIAlertView alloc] initWithTitle:@"Something went wrong."
                               message:@"Sorry, an error occurred and we're unable to load the calendar. Please try again later."
                              delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil, nil];
    [webViewErrorAlert show];
}

@end
