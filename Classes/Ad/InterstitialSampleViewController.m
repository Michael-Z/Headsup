//
//  InterstitialSampleViewController.m
//  InterstitialSample
//
//  Copyright AdMob 2009. All rights reserved.
//

#import "InterstitialSampleViewController.h"
#import "AppController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <math.h>


@implementation InterstitialSampleViewController

@synthesize appController;
@synthesize interstitialAd;


- (void)loadView
{
  [super loadView];
  
  // Show Default.png (the splash screen) until the interstitial request completes.
  splashView = [[UIImageView alloc] initWithFrame:self.view.frame];
  splashView.image = [UIImage imageNamed:@"Default.png"];
  [self.view addSubview:splashView];
  
  // Since our application starts in landscape we need to rotate Default.png to landscape too.
  //splashView.transform = CGAffineTransformMakeRotation(-M_PI/2);
  //splashView.center = CGPointMake(CGRectGetMidY(self.view.frame), CGRectGetMidX(self.view.frame));
}

- (void)dealloc 
{
  [splashView release];
  [super dealloc];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	// support all orientations. because the default is portrait, this will cause the video
	// to be displayed in portrait only.
	//return YES;
	// Return YES for supported orientations
	//return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)welcomeUser
{
	// change orientation
	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
	
	// Remove the splash screen image if it was showing.
	if(splashView)
	{
		[splashView removeFromSuperview];
		[splashView release];
		splashView = nil;
	}
  	
	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
	NSLog(@"welcome user");
	//[appController setup];
}

#pragma mark AdMobInterstitialDelegate methods

// Sent when an interstitial ad request succefully returned an ad.  At the next transition
// point in your application call [ad show] to display the interstitial.
- (void)didReceiveInterstitial:(AdMobInterstitialAd *)ad
{
  NSLog(@"Interstitial ad retrieved.");
	
	if(ad == interstitialAd)
	{
		[ad show];
	}
	

	/*
  switch(ad.applicationEvent)
  {
    case AdMobInterstitialEventAppOpen:
      // Show the interstitial.  This is just after the splash screen but before -welcomeUser.
      [ad show];
      
      // Request another interstitial to show later before playing MOVIE_URL.
      [AdMobInterstitialAd requestInterstitialAt:AdMobInterstitialEventPreRoll 
                                        delegate:self 
                            interstitialDelegate:self];
      break;
    case AdMobInterstitialEventPreRoll:
      // Hold onto the interstitial until the movie is played.
      //prerollInterstitial = [ad retain];
      break;
  }*/
}

- (void) destroyInterstitialAd {
	[interstitialAd release];
	interstitialAd = nil;
}
	
// Sent when an interstitial ad request completed without an interstitial to show.  This is
// common since interstitials are shown sparingly to users.
- (void)didFailToReceiveInterstitial:(AdMobInterstitialAd *)ad
{
  NSLog(@"No interstitial ad retrieved.  This is ok.");
	
	[self destroyInterstitialAd];


	/*
  // check the ad type to know what we do next.
  switch(ad.applicationEvent)
  {
    case AdMobInterstitialEventAppOpen:
      // No interstitial so immediately replace the splash screen (Default.png) with this view.
      [self welcomeUser];
      break;
    case AdMobInterstitialEventPreRoll:
      // There was no pre-roll interstitial so we have nothing to do.
      break;
  }  */
}

- (void)interstitialWillDisappear:(AdMobInterstitialAd *)ad
{
  if(ad.applicationEvent == AdMobInterstitialEventAppOpen)
  {
    // The app-oven interstitial is about to disapper revealing self.view.
    [self welcomeUser];
  }
}

- (void)interstitialDidDisappear:(AdMobInterstitialAd *)ad
{
	[self destroyInterstitialAd];
}

#pragma mark AdMobDelegate methods

// Use this to provide a publisher id for an ad request. Get a publisher id
// from http://www.admob.com
- (NSString *)publisherIdForAd:(AdMobView *)adView {
	return @"a14b074167649d6";
}

- (UIViewController *)currentViewControllerForAd:(AdMobView *)adView {
	return appController.viewController;
}

#pragma mark AdMobDelegate test ad methods

// These force the interstitial video test ad to be returned.
/*
- (BOOL)useTestAd
{
  return YES;
}

- (NSString *)testAdAction 
{
  return @"video_int";
}



- (NSArray *)testDevices
{
	return [NSArray arrayWithObjects: 
			@"b1ab061564728370c4b4bf146787c148800ff7c1", 
			@"35340eeff9214ebb88d7698d23701d185fef5f32",
			nil];
}

- (NSString *)testAdActionForAd:(AdMobView *)adMobView
{
	return @"video_int"; // see AdMobDelegateProtocol.h for a listing of valid values here
}
*/
@end