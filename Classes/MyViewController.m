//
//  MyViewController.m
//  Headsup
//
//  Created by Haolan Qin on 4/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyViewController.h"

#import "GADBannerView.h"

#import "PrefsView.h"
#import "AppController.h"

@implementation MyViewController {
    GADBannerView *bannerView_;
    
    BOOL isFetchForNow;
}

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
		
        /*adView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
        adView.tag = AD_VIEW_TAG;
		[self.view addSubview:adView];*/
		
		/*
		self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)] autorelease];
		self.adView.delegate = self;
		[self.view addSubview:self.adView];*/
        
        GSFullscreenAd *gsFullscreenAd = [[GSFullscreenAd alloc] initWithDelegate:self];
        self.myFullscreenAd = gsFullscreenAd;
        [gsFullscreenAd release];
        
        [self displayFullscreenAd];
        
        // Create a view of the standard size at the top of the screen.
        // Available AdSize constants are explained in GADAdSize.h.
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        bannerView_.adUnitID = GOOGLE_ADMOB_IPHONE_BANNER_MEDIATION_ID;
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        bannerView_.rootViewController = self;
        [self.view addSubview:bannerView_];
        
        // Initiate a generic request to load it with an ad.
        [bannerView_ loadRequest:[GADRequest request]];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	/*
	[super viewDidAppear:animated];
	[self.adView resumeAdAutoRefresh]; */
	
	[super viewDidAppear:animated];
	
	if ([AppController isFreeVersion]) {
		//[adView doNotIgnoreAutoRefreshTimer];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	/*
	[super viewWillDisappear:animated];
	[self.adView pauseAdAutoRefresh]; */
	
	[super viewWillDisappear:animated];
	
	if ([AppController isFreeVersion]) {
		//[adView ignoreAutoRefreshTimer];
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
    
    self.myFullscreenAd = nil;
    
    bannerView_.delegate = nil;
    [bannerView_ release];
    bannerView_ = nil;
	
	[super dealloc];
}

- (void) fetchFullscreenAdToShowNow:(BOOL)isToShowNow {
    isFetchForNow = isToShowNow;
    [self.myFullscreenAd fetch];
}

- (void) displayFullscreenAd {
    if ([self.myFullscreenAd isAdReady]) {
        [self.myFullscreenAd displayFromViewController:self];
        
        // fetch for next time
        [self fetchFullscreenAdToShowNow:NO];
    } else {
        // fetch to display now
        [self fetchFullscreenAdToShowNow:YES];
    }
}

- (void) hideBannerAd {
    bannerView_.delegate = nil;
    [bannerView_ removeFromSuperview];
    [bannerView_ release];
    bannerView_ = nil;
    
}

#pragma mark - Protocol methods

- (NSString *)greystripeGUID {
    NSLog(@"Accessing Greystripe iPhone interstitial GUID");
    
    // The Greystripe GUID is defined in Constants.h and preloaded in GSSDKDemo-Prefix.pch in this example
    // Alternate example: You can also set the Greystripe GUID in the AppDelegate.m as well
    return GS_IPHONE_INTERSTITAL_GUID;
}

//- (void)textViewDidChangeSelection:(UITextView *)textView {
//    [textView resignFirstResponder];
//}

- (void)greystripeAdFetchSucceeded:(id<GSAd>)a_ad {
    if (a_ad == self.myFullscreenAd) {
        NSLog(@"Greystripe fullscreen ad fetched!");
        // only display the full screen ad if it's meant to be displayed now.
        // otherwise, save it for later.
        if (isFetchForNow) {
            [self.myFullscreenAd displayFromViewController:self];
            
            [NSTimer scheduledTimerWithTimeInterval:IPHONE_INTERSTITIAL_REQUEST_INTERVAL target:self selector:@selector(gsFetchTimerFired:) userInfo:nil repeats:NO];
        }
    }
}

- (void)greystripeAdFetchFailed:(id<GSAd>)a_ad withError:(GSAdError)a_error {
    if (a_ad == self.myFullscreenAd) {
        [NSTimer scheduledTimerWithTimeInterval:IPHONE_INTERSTITIAL_REQUEST_INTERVAL target:self selector:@selector(gsFetchTimerFired:) userInfo:nil repeats:NO];
    }
}

- (void) gsFetchTimerFired:(id)userInfo {
    [self fetchFullscreenAdToShowNow:NO];
}

- (void)greystripeAdClickedThrough:(id<GSAd>)a_ad {
}

- (void)greystripeWillPresentModalViewController {
}

- (void)greystripeDidDismissModalViewController {
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
