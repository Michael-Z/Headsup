//
//  Poker3GView.h
//  Headsup
//
//  Created by Haolan Qin on 6/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppController.h"

// GameKit Session ID for app
#define kHeadsupPoker3GSessionID @"hu-3g-003"

#ifdef HU_3G

@interface Poker3GView : UIView <GKPeerPickerControllerDelegate, GKSessionDelegate> {
	IBOutlet UILabel *settingsLabel;
	
	GKSession		*gameSession;
	NSString		*gamePeerId;
	
	enum ViewType viewType;
	BOOL isViewPresented;
	BOOL isHeroApplicationDataSent;
	uint8_t *heroHoldemApplicationData;
	uint8_t *villainHoldemApplicationData;
	uint8_t *heroOmahaApplicationData;
	uint8_t *villainOmahaApplicationData;
	NSString *myVillainDeviceId;	
	
	UIViewController *viewController;
	MyViewController *holdemToolModeViewController;
	MyViewController *holdemGameModeViewController;
	MyViewController *omahaToolModeViewController;
	MyViewController *omahaGameModeViewController;
	BOOL dealer;
}

@property (nonatomic, retain) IBOutlet UILabel *settingsLabel;
@property(nonatomic, retain) GKSession	 *gameSession;
@property(nonatomic, copy)	 NSString	 *gamePeerId;


- (void)invalidateSession:(GKSession *)session;

- (IBAction) bluetoothButtonPressed:(id)sender;
- (IBAction) singlePhoneModeButtonPressed:(id)sender;
- (IBAction) singlePlayerModeButtonPressed:(id)sender;
- (IBAction) settingsButtonPressed:(id)sender;
- (IBAction) helpButtonPressed:(id)sender;

- (void) send:(uint8_t)message;
- (void) sendArray:(uint8_t[])message size:(uint8_t)size;
- (void) endSession;
- (void) willDisplay;

@end

#endif
