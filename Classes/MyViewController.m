//
//  MyViewController.m
//  Headsup
//
//  Created by Haolan Qin on 4/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"

#import "PrefsView.h"
#import "AppController.h"


@implementation MyViewController

//@synthesize adView;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
	if (![self.view isKindOfClass:[PrefsView class]]) {
		for (UIView* view in self.view.subviews) {
			if ([view isKindOfClass:[UITextField class]])
				[view resignFirstResponder];
		}
	}
}

/*- (NSString*)adView:(MobclixAdView*)adView publisherKeyForSuballocationRequest:(MCAdsSuballocationType)suballocationType {
	// AdMob Headsup 3G
	return @"a14a3db8c6bb49f";
}*/

- (void) viewDidLoad {
	NSLog(@"viewDidLoad %@", self);
	
	[super viewDidLoad];
	
	if ([AppController isFreeVersion]) {
		//ARRollerView* rollerView = [ARRollerView requestRollerViewWithDelegate:self];
		//[self.view addSubview:rollerView];
		adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        adView.tag = AD_VIEW_TAG;
		[self.view addSubview:adView];
		
		/*
		self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];
		self.adView.delegate = self;
		[self.view addSubview:self.adView];*/
	}
}

- (void)viewDidAppear:(BOOL)animated {
	/*
	[super viewDidAppear:animated];
	[self.adView resumeAdAutoRefresh]; */
	
	[super viewDidAppear:animated];
	
	if ([AppController isFreeVersion]) {
		[adView doNotIgnoreAutoRefreshTimer];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	/*
	[super viewWillDisappear:animated];
	[self.adView pauseAdAutoRefresh]; */
	
	[super viewWillDisappear:animated];
	
	if ([AppController isFreeVersion]) {
		[adView ignoreAutoRefreshTimer];
	}
}

- (void)viewDidUnload {
	/*
	[self.adView cancelAd]; 
	self.adView.delegate = nil; 
	self.adView = nil;*/
}

- (void)dealloc {
	/*
	[self.adView cancelAd]; 
	self.adView.delegate = nil; 
	self.adView = nil;
	[super dealloc];*/
	
	[super dealloc];
}

#pragma mark ARRollerDelegate required delegate method implementation
- (NSString*)adWhirlApplicationKey
{
	NSLog(@"adwhirl key %@", self);
#ifdef HU_3G
	return @"7593e476af6d102cb741df581a7911e8";
#else	
	return @"d5141bb89578102caf90c29cca1d33aa";
#endif
}

- (UIViewController *)viewControllerForPresentingModalView {
	NSLog(@"viewcontrollerforpresentingmodalview");
	return ((AppController *)[[UIApplication sharedApplication] delegate]).viewController;
}

- (UIDeviceOrientation) adWhirlCurrentOrientation {
	return UIDeviceOrientationPortrait;
}

- (NSString *)googleAdSenseCompanyName {
	NSLog(@"google adsense company name");
	return @"Heads Up Gaming";
}

- (NSString *)googleAdSenseAppName {
	return @"Headsup Poker Free (Holdem Blackjack Omaha)";
}

- (NSString *)googleAdSenseApplicationAppleID {
	return @"312224231";
}

/*
- (NSString *)googleAdSenseKeywords {
	return @"texas+hold'em,omaha,blackjack,casino,gamble,chip,card,21";
}*/

@end
