//
//  MyViewController.h
//  Headsup
//
//  Created by Haolan Qin on 4/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ARRollerView.h"
//#import "ARRollerProtocol.h"
#import "AdWhirlDelegateProtocol.h"
#import "AdWhirlView.h"

//#import "MobclixAds.h"

@interface MyViewController : UIViewController <AdWhirlDelegate> {//<ARRollerDelegate> { //, MobclixAdViewDelegate> {
@private
	//MobclixAdView* adView;
	AdWhirlView* adView;
}

//@property(nonatomic,retain) MobclixAdView* adView;
@end
