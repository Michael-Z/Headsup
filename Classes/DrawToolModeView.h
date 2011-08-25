//
//  HeadsupView.h
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>


@class CardView;
@class Deck;
@class Hand;
@class HandFSM;
@class MadeHand;

@interface DrawToolModeView : UIView <UIAlertViewDelegate> {
	IBOutlet CardView *heroCard0View, *heroCard1View, *heroCard2View, *heroCard3View, *heroCard4View;
	IBOutlet CardView *villainCard0View, *villainCard1View, *villainCard2View, *villainCard3View, *villainCard4View;
	
	IBOutlet UIButton *heroDealerButton, *villainDealerButton;
	IBOutlet UIButton *heroBlindButton, *villainBlindButton;
	IBOutlet UILabel *heroActLabel, *villainActLabel;
	IBOutlet UILabel *whoWonLabel;
	IBOutlet UILabel *heroHandLabel, *villainHandLabel;
	
	IBOutlet UILabel *heroDrawActionLabel, *villainDrawActionLabel;
	
	IBOutlet UIButton *newHandButton, *allInButton;
	IBOutlet UIButton *patDiscardButton;
	IBOutlet UIButton *revealMyHandToMyselfButton;
	
	IBOutlet UIActivityIndicatorView *waitingIndicator;
	
	IBOutlet UIActivityIndicatorView *villainsWaitingIndicator;
	IBOutlet UILabel *villainsWaitingLabel;
	
	
	// internal use
	BOOL newHandButtonEnabled;
	BOOL allInButtonEnabled;
	BOOL revealMyHandToMyselfButtonEnabled;
	
	BOOL dealer;
	
	BOOL herosTurnToDraw;
	
	Hand *hand;
	Deck *deck;
	
	HandFSM *handFSM;
	
	NSTimer *timer;
	
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
@property (nonatomic, retain) IBOutlet UIButton *villainDealerButton;
@property (nonatomic, retain) IBOutlet UIButton *heroBlindButton;
@property (nonatomic, retain) IBOutlet UIButton *villainBlindButton;
@property (nonatomic, retain) IBOutlet UILabel *heroActLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainActLabel;

@property (nonatomic, retain) IBOutlet UILabel *whoWonLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroHandLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainHandLabel;

@property (nonatomic, retain) IBOutlet UILabel *heroDrawActionLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainDrawActionLabel;


@property (nonatomic, retain) IBOutlet UIButton *newHandButton;
@property (nonatomic, retain) IBOutlet UIButton *allInButton;
@property (nonatomic, retain) IBOutlet UIButton *patDiscardButton;
@property (nonatomic, retain) IBOutlet UIButton *revealMyHandToMyselfButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *waitingIndicator;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *villainsWaitingIndicator;
@property (nonatomic, retain) IBOutlet UILabel *villainsWaitingLabel;


@property (nonatomic) BOOL dealer;
@property (nonatomic, retain) Deck* deck;

@property (nonatomic, retain) HandFSM* handFSM;

@property (readwrite)	CFURLRef		dealingCardsSoundFileURLRef;
@property (readonly)	SystemSoundID	dealingCardsSoundFileObject;

@property (readwrite)	CFURLRef		allInSoundFileURLRef;
@property (readonly)	SystemSoundID	allInSoundFileObject;

@property (readwrite)	CFURLRef		wonPotSoundFileURLRef;
@property (readonly)	SystemSoundID	wonPotSoundFileObject;

@property (readwrite)	CFURLRef		showCardsSoundFileURLRef;
@property (readonly)	SystemSoundID	showCardsSoundFileObject;


- (IBAction) newHandButtonPressed:(id)sender;
- (IBAction) patDiscardButtonPressed:(id)sender;
- (IBAction) allInButtonPressed:(id)sender;
- (IBAction) revealMyHandToMyself:(id)sender;
- (IBAction) concealMyHand:(id)sender;

- (void) villainStoodPat;
- (void) villainDiscardedCards:(NSInteger)numDiscardedCards;
	

- (void) stateChanged;

- (void) startVillainsWaiting;
- (void) stopVillainsWaiting;


+(void) logMadeHand:(MadeHand*)hand;

- (void) willDisplay;

- (void) dealSecondCardTimerMethod;
- (void) dealThirdCardTimerMethod;
- (void) dealFourthCardTimerMethod;
- (void) dealFifthCardTimerMethod;
- (void) dealSixthCardTimerMethod;


@end
