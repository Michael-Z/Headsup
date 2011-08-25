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



@class CardView;
@class Deck;
@class Hand;


@interface DrawGameModeView : UIView {
	IBOutlet CardView *heroCard0View, *heroCard1View, *heroCard2View, *heroCard3View, *heroCard4View;
	IBOutlet CardView *villainCard0View, *villainCard1View, *villainCard2View, *villainCard3View, *villainCard4View;
	
	IBOutlet UIButton *heroDealerButton, *villainDealerButton;
	IBOutlet UILabel *heroStackLabel, *heroActionLabel, *heroAmountLabel, *heroDrawActionLabel;
	IBOutlet UILabel *villainStackLabel, *villainActionLabel, *villainAmountLabel, *villainDrawActionLabel;
	IBOutlet UILabel *potLabel;
	IBOutlet UILabel *whoWonLabel;
		
	IBOutlet UIButton *betRaiseButton, *checkCallButton, *foldButton;
	IBOutlet UIButton *revealMyHandToMyselfButton;
	IBOutlet UIButton *patDiscardButton;
	
	IBOutlet UILabel *howMuchMoreToCallLabel;
	IBOutlet UILabel *howMuchMoreToBetRaiseLabel;
	
	IBOutlet UILabel *gameNameLabel;
	IBOutlet UILabel *handCountLabel;
			
	BOOL dealer;
	
	BOOL herosTurnToDraw;
	
	Hand *hand;
	Deck *deck;
	
	NSTimer *timer;
	
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


@property (nonatomic, retain) IBOutlet CardView *heroCard0View;
@property (nonatomic, retain) IBOutlet CardView *heroCard1View;
@property (nonatomic, retain) IBOutlet CardView *heroCard2View;
@property (nonatomic, retain) IBOutlet CardView *heroCard3View;
@property (nonatomic, retain) IBOutlet CardView *heroCard4View;

@property (nonatomic, retain) IBOutlet CardView *villainCard0View;
@property (nonatomic, retain) IBOutlet CardView *villainCard1View;
@property (nonatomic, retain) IBOutlet CardView *villainCard2View;
@property (nonatomic, retain) IBOutlet CardView *villainCard3View;
@property (nonatomic, retain) IBOutlet CardView *villainCard4View;

@property (nonatomic, retain) IBOutlet UIButton *heroDealerButton;
@property (nonatomic, retain) IBOutlet UILabel *heroStackLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroActionLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroDrawActionLabel;

@property (nonatomic, retain) IBOutlet UIButton *villainDealerButton;
@property (nonatomic, retain) IBOutlet UILabel *villainStackLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainActionLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainDrawActionLabel;


@property (nonatomic, retain) IBOutlet UILabel *potLabel;
@property (nonatomic, retain) IBOutlet UILabel *whoWonLabel;

@property (nonatomic, retain) IBOutlet UIButton *betRaiseButton;
@property (nonatomic, retain) IBOutlet UIButton *checkCallButton;
@property (nonatomic, retain) IBOutlet UIButton *foldButton;
@property (nonatomic, retain) IBOutlet UIButton *revealMyHandToMyselfButton;
@property (nonatomic, retain) IBOutlet UIButton *patDiscardButton;

@property (nonatomic, retain) IBOutlet UILabel *howMuchMoreToCallLabel;
@property (nonatomic, retain) IBOutlet UILabel *howMuchMoreToBetRaiseLabel;


@property (nonatomic, retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *handCountLabel;


@property (nonatomic) BOOL dealer;
@property (nonatomic, retain) Deck* deck;

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

- (IBAction) fold:(id)sender;
- (IBAction) checkCall:(id)sender;
- (IBAction) betRaise:(id)sender;

- (IBAction) revealMyHandToMyself:(id)sender;
- (IBAction) concealMyHand:(id)sender;

- (IBAction) patOrDiscard:(id)sender;

- (void) willDisplay;
- (void) villainMadeAMove: (enum MoveType)move amount:(NSInteger)amount;

- (void)afterDisplayingWhoWonTimerFireMethod;
- (void)beforeDealingNextStreetTimerFireMethod;

- (void)dealSecondCardNonDealerTimerMethod;
- (void)dealThirdCardNonDealerTimerMethod;
- (void)dealFourthCardNonDealerTimerMethod;
- (void)dealFifthCardNonDealerTimerMethod;


- (void)dealSecondCardDealerTimerMethod;
- (void)dealThirdCardDealerTimerMethod;
- (void)dealFourthCardDealerTimerMethod;
- (void)dealFifthCardDealerTimerMethod;


- (void) dealNewHandAsDealer;
- (void) dealNewHandAsNonDealer;

- (void) setupInitialScreen;

@end
