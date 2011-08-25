//
//  HeadsupView.h
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

#import "AppController.h"

@class CardView;
@class Deck;
@class Hand;
@class HandFSM;
@class MadeHand;

@interface OmahaToolModeView : UIView <UIAlertViewDelegate> {
	UINavigationController *navController;
	AppController *appController;

	IBOutlet CardView *heroCard0View, *heroCard1View, *heroCard2View, *heroCard3View;
	IBOutlet CardView *villainCard0View, *villainCard1View, *villainCard2View, *villainCard3View;
	IBOutlet CardView *communityCard0View, *communityCard1View, *communityCard2View, 
	*communityCard3View, *communityCard4View;
	
	IBOutlet UILabel *status0Label, *status1Label, *status2Label;
	
	IBOutlet UIButton *heroDealerButton, *villainDealerButton;
	IBOutlet UIButton *heroBlindButton, *villainBlindButton;
	IBOutlet UILabel *heroActLabel, *villainActLabel;
	
	IBOutlet UIButton *newHandButton, *nextStreetButton, *allInButton;
	IBOutlet UIButton *revealMyHandToMyselfButton;
	
	IBOutlet UIActivityIndicatorView *waitingIndicator;
	
	IBOutlet UIActivityIndicatorView *villainsWaitingIndicator;
	IBOutlet UILabel *villainsWaitingLabel;
	
	IBOutlet UILabel *handCountLabel;
	
	
	// internal use
	BOOL newHandButtonEnabled;
	BOOL nextStreetButtonEnabled;
	BOOL allInButtonEnabled;
	BOOL revealMyHandToMyselfButtonEnabled;
	
	BOOL dealer;
	
	Hand *hand;
	Deck *deck;
	
	HandFSM *handFSM;
	
	NSTimer *timer;
	
	NSInteger handCount;
	
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

@property (nonatomic, retain) IBOutlet UILabel *status0Label;
@property (nonatomic, retain) IBOutlet UILabel *status1Label;
@property (nonatomic, retain) IBOutlet UILabel *status2Label;

@property (nonatomic, retain) IBOutlet UIButton *heroDealerButton;
@property (nonatomic, retain) IBOutlet UIButton *villainDealerButton;
@property (nonatomic, retain) IBOutlet UIButton *heroBlindButton;
@property (nonatomic, retain) IBOutlet UIButton *villainBlindButton;
@property (nonatomic, retain) IBOutlet UILabel *heroActLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainActLabel;


@property (nonatomic, retain) IBOutlet UIButton *newHandButton;
@property (nonatomic, retain) IBOutlet UIButton *nextStreetButton;
@property (nonatomic, retain) IBOutlet UIButton *allInButton;
@property (nonatomic, retain) IBOutlet UIButton *revealMyHandToMyselfButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *waitingIndicator;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *villainsWaitingIndicator;
@property (nonatomic, retain) IBOutlet UILabel *villainsWaitingLabel;

@property (nonatomic, retain) IBOutlet UILabel *handCountLabel;

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
- (IBAction) nextStreetButtonPressed:(id)sender;
- (IBAction) allInButtonPressed:(id)sender;
- (IBAction) revealMyHandToMyself:(id)sender;
- (IBAction) concealMyHand:(id)sender;

- (void) stateChanged;
- (void)timerFireMethod;//: (NSTimer*)theTimer;

- (void) startVillainsWaiting;
- (void) stopVillainsWaiting;


+(void) logMadeHand:(MadeHand*)hand;

- (void) willDisplayAtHand:(NSInteger)count;

- (void) dealSecondCardTimerMethod;
- (void) dealThirdCardTimerMethod;
- (void) dealFourthCardTimerMethod;
- (void) dealFifthCardTimerMethod;
- (void) dealSixthCardTimerMethod;
- (void) dealSeventhCardTimerMethod;
- (void) dealEighthCardTimerMethod;

- (void) makeNewHandReadyToBeDealt;

@end
