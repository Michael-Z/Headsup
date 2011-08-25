//
//  InterstitialSampleViewController.h
//  InterstitialSample
//
//  Copyright AdMob 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdMobDelegateProtocol.h"
#import "AdMobInterstitialDelegateProtocol.h"
#import "AdMobInterstitialAd.h"

@class AppController;

@interface InterstitialSampleViewController : UIViewController
	<AdMobDelegate, AdMobInterstitialDelegate> {  
	
	UIImageView *splashView;
	
	AppController *appController;
		
	AdMobInterstitialAd *interstitialAd;
}

- (void)welcomeUser;

@property (nonatomic, retain) AppController *appController;
@property (nonatomic, retain) AdMobInterstitialAd *interstitialAd;

@end

