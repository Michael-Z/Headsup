/*

File: Picker.h
Abstract: 
 A view that displays both the currently advertised game name and a list of
other games
 available on the local network (discovered & displayed by
BrowserViewController).
 

Version: 1.5
*/

#import <UIKit/UIKit.h>

//#import "AdMobDelegateProtocol.h";
#import "BrowserViewController.h"

@interface Picker : UIView 
	<GKMatchmakerViewControllerDelegate, 
	GKLeaderboardViewControllerDelegate,
	GKAchievementViewControllerDelegate> { //<AdMobDelegate>  {
		
	IBOutlet UIActivityIndicatorView *activityIndicatorView;

@private
	UILabel* _gameNameLabel;
	BrowserViewController* _bvc;
			
	//AdMobView *rollerView;
	//AdWhirlView *adView;
}

@property (nonatomic, assign) id<BrowserViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* gameName;

- (id)initWithFrame:(CGRect)frame type:(NSString *)type;

- (void) helpButtonPressed;

//- (void) addRollerView;

@end
