//
//  HelpHoldemView.h
//  Headsup
//
//  Created by Haolan Qin on 08/29/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "AppController.h"


@interface GameCenterView : UIView 
	<GKMatchmakerViewControllerDelegate, 
	GKLeaderboardViewControllerDelegate,
	GKAchievementViewControllerDelegate> {
	
	UINavigationController *navController;
	
	IBOutlet UIActivityIndicatorView *activityIndicatorView;
	
	IBOutlet UIButton *lobbyButton;
	IBOutlet UIButton *signInButton;
	IBOutlet UIButton *holdemButton, *omahaButton;
	IBOutlet UIButton *leaderboardButton, *achievementButton;
	
	IBOutlet UILabel *holdemActivityLabel, *omahaActivityLabel;
	
	enum GameName gameName;
}

@property (nonatomic, retain) UINavigationController *navController;

- (IBAction) lobbyButtonPressed;
- (IBAction) signInButtonPressed;

- (IBAction) holdemButtonPressed;
- (IBAction) omahaButtonPressed;

- (IBAction) leaderboardButtonPressed;
- (IBAction) achievementButtonPressed;

- (void)setupAudioSession;

- (void) willDisplay;

@end
