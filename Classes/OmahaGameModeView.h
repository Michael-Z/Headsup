//
//  GameModeView.h
//  Headsup
//
//  Created by Haolan Qin on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import "Constants.h"

#import "AppController.h"

@class CardView;
@class Deck;
@class Hand;
@class PotLimitOmahaHiVillain;

@interface OmahaGameModeView : UIView {
	UINavigationController *navController;
	AppController *appController;

	IBOutlet CardView *heroCard0View, *heroCard1View, *heroCard2View, *heroCard3View;
	IBOutlet CardView *villainCard0View, *villainCard1View, *villainCard2View, *villainCard3View;
	IBOutlet CardView *communityCard0View, *communityCard1View, *communityCard2View, 
	*communityCard3View, *communityCard4View;
	
	IBOutlet UIButton *heroDealerButton, *villainDealerButton;
	IBOutlet UILabel *heroStackLabel, *heroActionLabel, *heroAmountLabel, *heroNameLabel;
	IBOutlet UILabel *villainStackLabel, *villainActionLabel, *villainAmountLabel, *villainNameLabel;
	IBOutlet UILabel *potLabel;
	IBOutlet UILabel *whoWonLabel;
	
	IBOutlet UITextField *amountTextField;
	
	IBOutlet UIButton *betRaiseButton, *checkCallButton, *foldButton;
	IBOutlet UIButton *revealMyHandToMyselfButton;
	IBOutlet UILabel *peekCounterLabel;
	
	IBOutlet UILabel *howMuchMoreToCallLabel;
	IBOutlet UILabel *howMuchMoreToBetRaiseLabel;
	IBOutlet UILabel *howMuchMoreToBetRaiseForKeyboardLabel;
	
	
	IBOutlet UIButton *halfPotButton, *potButton;
	IBOutlet UIButton *lessAmountButton, *moreAmountButton;
	IBOutlet UIButton *betRaiseButtonForKeyboard;

	IBOutlet UIButton *endButton;
	IBOutlet UIButton *lobbyButton;
	
	IBOutlet UIActivityIndicatorView *waitingIndicator;
	
	IBOutlet UILabel *gameNameLabel;
	IBOutlet UILabel *handCountLabel;
	
	IBOutlet UILabel *statusLabel;
	IBOutlet UILabel *gameModeLabel;
			
	BOOL dealer;
	
	BOOL heroWantsToEndMatch, villainWantsToEndMatch;
	
	enum GameMode gameMode;
	
	PotLimitOmahaHiVillain *villain;	
	
	Hand *hand;
	Deck *deck;
	
	NSTimer *allInDealingTimer;
	NSTimer *showdownTimer;
	NSTimer *holeCardsDealingTimer;
	
	//NSTimer *timer;
	
	// most of the time this flag is NO. it's only YES between a non-dealer deal and
	// the very first move of the hand.
	BOOL isHandStarted;	
	
	// only YES after the first card is dealt and before the fourth card is dealt.
	BOOL isDealingGoingOn;
	
	NSInteger handCount;
	
	// it's possible that villain's first move will be received by hero (non-dealer) 
	// before his dealing animation is over. handling of the first move must be postponed
	// until the dealing animation is over.
	BOOL isMovePostponed;
	enum MoveType postponedVillainsFirstMove;
	NSInteger postponedVillainsFirstMoveAmount;
	
	// YES from all-in starts to next hand starts. Note that all-in is a generic term that includes showdown.
	BOOL isAllIn;
	
	// game state. the data will be saved when user exits the application so that the game can be
	// restored when user relaunches it.
	uint8_t *applicationData;
	
	// uid of villain device that corresponds to the application data.
	NSString *myVillainDeviceId;
	
	NSInteger SB, BB;

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

@property (nonatomic, retain) IBOutlet CardView *heroCard0View;
@property (nonatomic, retain) IBOutlet CardView *heroCard1View;
@property (nonatomic, retain) IBOutlet CardView *heroCard2View;
@property (nonatomic, retain) IBOutlet CardView *heroCard3View;

@property (nonatomic, retain) IBOutlet CardView *villainCard0View;
@property (nonatomic, retain) IBOutlet CardView *villainCard1View;
@property (nonatomic, retain) IBOutlet CardView *villainCard2View;
@property (nonatomic, retain) IBOutlet CardView *villainCard3View;

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
@property (nonatomic, retain) IBOutlet UITextField *amountTextField;



@property (nonatomic, retain) IBOutlet UIButton *betRaiseButton;
@property (nonatomic, retain) IBOutlet UIButton *checkCallButton;
@property (nonatomic, retain) IBOutlet UIButton *foldButton;

@property (nonatomic, retain) IBOutlet UILabel *howMuchMoreToCallLabel;
@property (nonatomic, retain) IBOutlet UILabel *howMuchMoreToBetRaiseLabel;
@property (nonatomic, retain) IBOutlet UILabel *howMuchMoreToBetRaiseForKeyboardLabel;



@property (nonatomic, retain) IBOutlet UIButton *revealMyHandToMyselfButton;
@property (nonatomic, retain) IBOutlet UILabel *peekCounterLabel;


@property (nonatomic, retain) IBOutlet UIButton *halfPotButton;
@property (nonatomic, retain) IBOutlet UIButton *potButton;
@property (nonatomic, retain) IBOutlet UIButton *lessAmountButton;
@property (nonatomic, retain) IBOutlet UIButton *moreAmountButton;
@property (nonatomic, retain) IBOutlet UIButton *betRaiseButtonForKeyboard;

@property (nonatomic, retain) IBOutlet UIButton *endButton;
@property (nonatomic, retain) IBOutlet UIButton *lobbyButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *waitingIndicator;

@property (nonatomic, retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *handCountLabel;


@property (nonatomic) BOOL dealer;
@property (nonatomic, retain) Deck* deck;
@property (nonatomic, retain) Hand* hand;

@property (nonatomic) enum GameMode gameMode;

@property (nonatomic) NSInteger SB;
@property (nonatomic) NSInteger BB;

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


- (void)setUpStuff;

- (IBAction) endButtonPressed:(id)sender;
- (IBAction) lobbyButtonPressed:(id)sender;

- (IBAction) fold:(id)sender;
- (IBAction) checkCall:(id)sender;
- (IBAction) betRaise:(id)sender;

- (IBAction) revealMyHandToMyself:(id)sender;
- (IBAction) concealMyHand:(id)sender;

- (IBAction) betRaiseButtonForKeyboardPressed:(id)sender;
- (IBAction) halfPotButtonPressed:(id)sender;
- (IBAction) potButtonPressed:(id)sender;
- (IBAction) lessAmountButtonPressed:(id)sender;
- (IBAction) moreAmountButtonPressed:(id)sender;

- (IBAction) amountValueChanged:(id)sender;

- (void) villainMadeAMove: (enum MoveType)move amount:(NSInteger)amount;
- (void) villainRequestedToEndMatch;

- (void)afterDisplayingWhoWonTimerFireMethod;
- (void)beforeDealingNextStreetTimerFireMethod;

- (void)dealSecondCardNonDealerTimerMethod;
- (void)dealThirdCardNonDealerTimerMethod;
- (void)dealFourthCardNonDealerTimerMethod;
- (void)dealFifthCardNonDealerTimerMethod;
- (void)dealSixthCardNonDealerTimerMethod;
- (void)dealSeventhCardNonDealerTimerMethod;
- (void)dealEighthCardNonDealerTimerMethod;


- (void)dealSecondCardDealerTimerMethod;
- (void)dealThirdCardDealerTimerMethod;
- (void)dealFourthCardDealerTimerMethod;
- (void)dealFifthCardDealerTimerMethod;
- (void)dealSixthCardDealerTimerMethod;
- (void)dealSeventhCardDealerTimerMethod;
- (void)dealEighthCardDealerTimerMethod;


- (void) dealNewHandAsDealer;
- (void) dealNewHandAsNonDealer;

- (void) setupInitialScreen;

- (void) keyboardDismissed;
- (void) keyboardDisplayed;

- (NSData*) getApplicationData;
- (void) saveToApplicationDataAtIndex:(NSInteger)index card:(uint8_t)data;
- (void) saveToApplicationData;

// the only TWO  entry points to this view is the following two methods.

- (void) willRestoreFromHeroApplicationData:(uint8_t*)heroApplicationData 
					 villainApplicationData:(uint8_t*)villainApplicationData
							villainDeviceId:(NSString*)villainDeviceId
								   gameMode:(enum GameMode)mode;

- (void) willDisplayAtHand:(NSInteger)count 
				 heroStack:(NSInteger)heroStack 
			  villainStack:(NSInteger)villainStack
				smallBlind:(NSInteger)smallBlind
				  bigBlind:(NSInteger)bigBlind
		   villainDeviceId:(NSString*)villainDeviceId
				  gameMode:(enum GameMode)mode;


- (void) killAllActiveTimers;
- (void) resetStuff;
- (NSString *) getVillainDeviceId;

- (BOOL) didHeroMakeNoMove;
- (BOOL) didHeroPostBB;
- (BOOL) didHeroCheck;
- (BOOL) didHeroCall;
- (BOOL) didHeroBet;
- (BOOL) didHeroRaise;
- (BOOL) didVillainRaise;


- (NSInteger) heroStackSize;
- (NSInteger) villainStackSize;
- (NSInteger) potSize;
- (NSInteger) effectivePotSizeVillainsTurn;
- (NSInteger) heroBetOrRaiseAmount;

- (NSInteger) maxAmountAllowedForVillain;
- (NSInteger) callAmountForVillain;
- (NSInteger) minRaiseAmountForVillain;
- (NSInteger) potSizedRaiseForVillain;
- (NSInteger) nearPotSizedRaiseForVillain;
- (NSInteger) halfPotSizedRaiseForVillain;
- (NSInteger) potSizedBetForVillain;
- (NSInteger) nearPotSizedBetForVillain;
- (NSInteger) halfPotSizedBetForVillain;

@end
