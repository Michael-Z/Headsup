//
//  HoldemHistoryModeView.h
//  Headsup
//
//  Created by Haolan Qin on 1/26/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import "Constants.h"

#import "AppController.h"

@class CardView;
@class HoldemHand;
@class GameModeView;

@interface HoldemHistoryModeView : UIView {
	UINavigationController *navController;
	AppController *appController;
	GameModeView *gameModeView;
	
	// indexes of the current hand/action
	NSInteger handIndex, actionIndex;
	
	// the list of hands to be reviewed in this history view
	NSMutableArray *listHands;
	
	NSMutableArray *arrHeroStacks, *arrHeroActions, *arrHeroAmounts;
	NSMutableArray *arrVillainStacks, *arrVillainActions, *arrVillainAmounts;
	NSMutableArray *arrPots;
	
	HoldemHand *hand;

	IBOutlet CardView *heroCard0View, *heroCard1View;
	IBOutlet CardView *villainCard0View, *villainCard1View;
	IBOutlet CardView *communityCard0View, *communityCard1View, *communityCard2View, 
	*communityCard3View, *communityCard4View;
	
	IBOutlet UIButton *heroDealerButton, *villainDealerButton;
	IBOutlet UILabel *heroStackLabel, *heroActionLabel, *heroAmountLabel, *heroNameLabel;
	IBOutlet UILabel *villainStackLabel, *villainActionLabel, *villainAmountLabel, *villainNameLabel;
	IBOutlet UILabel *potLabel;
	IBOutlet UILabel *whoWonLabel;
		
	IBOutlet UIButton *prevActionButton, *nextActionButton;
	IBOutlet UIButton *firstActionButton, *lastActionButton;	
		
	IBOutlet UIButton *endButton;
	IBOutlet UIButton *lobbyButton;
		
	IBOutlet UILabel *gameNameLabel;
	
	// index in the game session
	IBOutlet UILabel *handCountLabel;
	
	// index in the saved hands array
	IBOutlet UILabel *handIndexLabel;
	// total of saved hands
	IBOutlet UILabel *handTotalLabel;
	// index of the action in the current saved hand
	IBOutlet UILabel *actionIndexLabel;
	// total of actions in the current saved hand
	IBOutlet UILabel *actionTotalLabel;
	
	IBOutlet UILabel *smallBlindLabel, *bigBlindLabel;
													
	CFURLRef		soundFileURLRef;
	SystemSoundID	soundFileObject;

	CFURLRef		foldSoundFileURLRef;
	SystemSoundID	foldSoundFileObject;

	CFURLRef		checkSoundFileURLRef;
	SystemSoundID	checkSoundFileObject;
	
	CFURLRef		callSoundFileURLRef;
	SystemSoundID	callSoundFileObject;

	CFURLRef		betSoundFileURLRef;
	SystemSoundID	betSoundFileObject;

	CFURLRef		raiseSoundFileURLRef;
	SystemSoundID	raiseSoundFileObject;


	CFURLRef		dealingCardsSoundFileURLRef;
	SystemSoundID	dealingCardsSoundFileObject;

	CFURLRef		allInSoundFileURLRef;
	SystemSoundID	allInSoundFileObject;

	CFURLRef		wonPotSoundFileURLRef;
	SystemSoundID	wonPotSoundFileObject;

	CFURLRef		showCardsSoundFileURLRef;
	SystemSoundID	showCardsSoundFileObject;

}

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) AppController *appController;
@property (nonatomic, retain) GameModeView *gameModeView;

@property (nonatomic, retain) IBOutlet CardView *heroCard0View;
@property (nonatomic, retain) IBOutlet CardView *heroCard1View;
@property (nonatomic, retain) IBOutlet CardView *villainCard0View;
@property (nonatomic, retain) IBOutlet CardView *villainCard1View;
@property (nonatomic, retain) IBOutlet CardView *communityCard0View;
@property (nonatomic, retain) IBOutlet CardView *communityCard1View;
@property (nonatomic, retain) IBOutlet CardView *communityCard2View;
@property (nonatomic, retain) IBOutlet CardView *communityCard3View;
@property (nonatomic, retain) IBOutlet CardView *communityCard4View;

@property (nonatomic, retain) IBOutlet UIButton *heroDealerButton;
@property (nonatomic, retain) IBOutlet UILabel *heroStackLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroActionLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroNameLabel;

@property (nonatomic, retain) IBOutlet UIButton *villainDealerButton;
@property (nonatomic, retain) IBOutlet UILabel *villainStackLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainActionLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainNameLabel;

@property (nonatomic, retain) IBOutlet UILabel *potLabel;
@property (nonatomic, retain) IBOutlet UILabel *whoWonLabel;

@property (nonatomic, retain) IBOutlet UIButton *prevActionButton;
@property (nonatomic, retain) IBOutlet UIButton *nextActionButton;

@property (nonatomic, retain) IBOutlet UIButton *endButton;
@property (nonatomic, retain) IBOutlet UIButton *lobbyButton;

@property (nonatomic, retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *handCountLabel;

@property (nonatomic, retain) IBOutlet UILabel *smallBlindLabel;
@property (nonatomic, retain) IBOutlet UILabel *bigBlindLabel;


@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

@property (readwrite)	CFURLRef		foldSoundFileURLRef;
@property (readonly)	SystemSoundID	foldSoundFileObject;

@property (readwrite)	CFURLRef		checkSoundFileURLRef;
@property (readonly)	SystemSoundID	checkSoundFileObject;

@property (readwrite)	CFURLRef		callSoundFileURLRef;
@property (readonly)	SystemSoundID	callSoundFileObject;

@property (readwrite)	CFURLRef		betSoundFileURLRef;
@property (readonly)	SystemSoundID	betSoundFileObject;

@property (readwrite)	CFURLRef		raiseSoundFileURLRef;
@property (readonly)	SystemSoundID	raiseSoundFileObject;

@property (readwrite)	CFURLRef		dealingCardsSoundFileURLRef;
@property (readonly)	SystemSoundID	dealingCardsSoundFileObject;

@property (readwrite)	CFURLRef		allInSoundFileURLRef;
@property (readonly)	SystemSoundID	allInSoundFileObject;

@property (readwrite)	CFURLRef		wonPotSoundFileURLRef;
@property (readonly)	SystemSoundID	wonPotSoundFileObject;

@property (readwrite)	CFURLRef		showCardsSoundFileURLRef;
@property (readonly)	SystemSoundID	showCardsSoundFileObject;


- (IBAction) endButtonPressed:(id)sender;
- (IBAction) lobbyButtonPressed:(id)sender;

- (IBAction) prevActionButtonPressed:(id)sender;
- (IBAction) nextActionButtonPressed:(id)sender;
- (IBAction) firstActionButtonPressed;
- (IBAction) lastActionButtonPressed;

- (void) setupInitialScreen;

- (void) willDisplay;

@end
