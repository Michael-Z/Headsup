//
//  GameModeView.h
//  Headsup
//
//  Created by Haolan Qin on 10/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

#import "AppController.h"
#import "Constants.h"



@class CardView;
@class Deck;


@interface BlackjackGameModeView : UIView {
	UINavigationController *navController;
	AppController *appController;
	
	IBOutlet CardView *dealerCard0View, *dealerCard1View, *dealerCard2View, 
						*dealerCard3View, *dealerCard4View;
	
	IBOutlet CardView *heroCard0View, *heroCard1View, *heroCard2View, *heroCard3View, 
						*heroCard4View, *heroFirstCardView, *heroLastCardView;
		
	IBOutlet UITextField *amountTextField;
	
	IBOutlet UIButton *hintButton, *surrenderButton;
	IBOutlet UILabel *hintLabel;
	IBOutlet UIButton *splitButton, *doubleButton, *hitButton, *dealStandButton;
	IBOutlet UIButton *dealButtonForKeyboard;
	IBOutlet UIButton *noBetButton, *minBetButton, *midBetButton, *bigBetButton, *maxBetButton;
		
	IBOutlet UIButton *endButton, *lobbyButton;
		
	IBOutlet UILabel *gameNameLabel;	
	IBOutlet UILabel *handCountLabel;
		
	IBOutlet UILabel *dealerHandLabel;
	IBOutlet UILabel *heroHandLabel, *heroFirstHandLabel;
	IBOutlet UILabel *heroStackLabel, *heroStackLabelForKeyboard;
	IBOutlet UILabel *resultLabel;
	
	IBOutlet UILabel *dealerCardsNumLabel, *dealerCardsLabel;
	IBOutlet UILabel *heroCardsNumLabel, *heroCardsLabel;	
	
	IBOutlet UILabel *statusLabel;
	IBOutlet UIActivityIndicatorView *waitingIndicator;
	
	// heroOtherCardsNum is the number of cards in the hero hand
	// that's not currently in play. I.e. hero has two hands. It's either the 
	// second hand if the first hand is being played, or the first hand if the
	// second hand is being played.
	// heroHand refers to the hand in the middle
	// heroFirstHand refers to the single hand or the first hand in a split hand
	// hero SecondHand refers to the second hand in a split hand
	NSInteger dealerCardsNum, heroCardsNum, heroOtherCardsNum;
	NSMutableArray *dealerCardViews, *heroCardViews;
	NSInteger currentBet;
	BOOL isFirstHandDoubleDown, isSecondHandDoubleDown;
	
	Deck *deck;
	
	NSTimer *dealerCardsDealingTimer;
	NSTimer *holeCardsDealingTimer;
	
	NSInteger handCount;
	
	NSArray *strategyCard;
	
	CardView *animationFromCardView, *animationToCardView;
	CGPoint animationOldCenter;
	NSInteger animationHeroCardViewIndex;
	
	BOOL isDealerHandSoft, isHeroHandSoft, isHeroFirstHandSoft, isHeroSecondHandSoft;
	// hard values
	NSInteger dealerHandValue, heroHandValue, heroFirstHandValue, heroSecondHandValue;
		
	// game state. the data will be saved when user exits the application so that the game can be
	// restored when user relaunches it.
	uint8_t *applicationData;
		
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

	CFURLRef		slidingSoundFileURLRef;
	SystemSoundID	slidingSoundFileObject;
}

@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) AppController *appController;

@property (nonatomic, retain) IBOutlet CardView *dealerCard0View;
@property (nonatomic, retain) IBOutlet CardView *dealerCard1View;
@property (nonatomic, retain) IBOutlet CardView *dealerCard2View;
@property (nonatomic, retain) IBOutlet CardView *dealerCard3View;
@property (nonatomic, retain) IBOutlet CardView *dealerCard4View;

@property (nonatomic, retain) IBOutlet CardView *heroCard0View;
@property (nonatomic, retain) IBOutlet CardView *heroCard1View;
@property (nonatomic, retain) IBOutlet CardView *heroCard2View;
@property (nonatomic, retain) IBOutlet CardView *heroCard3View;
@property (nonatomic, retain) IBOutlet CardView *heroCard4View;
@property (nonatomic, retain) IBOutlet CardView *heroFirstCardView;
@property (nonatomic, retain) IBOutlet CardView *heroLastCardView;


@property (nonatomic, retain) IBOutlet UITextField *amountTextField;

@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet UIButton *surrenderButton;
@property (nonatomic, retain) IBOutlet UILabel *hintLabel;

@property (nonatomic, retain) IBOutlet UIButton *splitButton;
@property (nonatomic, retain) IBOutlet UIButton *doubleButton;
@property (nonatomic, retain) IBOutlet UIButton *hitButton;
@property (nonatomic, retain) IBOutlet UIButton *dealStandButton;

@property (nonatomic, retain) IBOutlet UIButton *dealButtonForKeyboard;

@property (nonatomic, retain) IBOutlet UIButton *noBetButton;
@property (nonatomic, retain) IBOutlet UIButton *minBetButton;
@property (nonatomic, retain) IBOutlet UIButton *midBetButton;
@property (nonatomic, retain) IBOutlet UIButton *bigBetButton;
@property (nonatomic, retain) IBOutlet UIButton *maxBetButton;

@property (nonatomic, retain) IBOutlet UIButton *endButton;
@property (nonatomic, retain) IBOutlet UIButton *lobbyButton;

@property (nonatomic, retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *handCountLabel;

@property (nonatomic, retain) IBOutlet UILabel *dealerHandLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroHandLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroFirstHandLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroStackLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroStackLabelForKeyboard;
@property (nonatomic, retain) IBOutlet UILabel *resultLabel;

@property (nonatomic, retain) IBOutlet UILabel *dealerCardsNumLabel;
@property (nonatomic, retain) IBOutlet UILabel *dealerCardsLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroCardsNumLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroCardsLabel;

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

@property (readwrite)	CFURLRef		slidingSoundFileURLRef;
@property (readonly)	SystemSoundID	slidingSoundFileObject;

- (void)setUpStuff;

- (IBAction) endButtonPressed:(id)sender;
- (IBAction) lobbyButtonPressed:(id)sender;

- (IBAction) noBetButtonPressed:(id)sender;
- (IBAction) minBetButtonPressed:(id)sender;
- (IBAction) midBetButtonPressed:(id)sender;
- (IBAction) bigBetButtonPressed:(id)sender;
- (IBAction) maxBetButtonPressed:(id)sender;

- (IBAction) showHint:(id)sender;
- (IBAction) hideHint:(id)sender;
- (IBAction) surrenderButtonPressed:(id)sender;

- (IBAction) splitButtonPressed:(id)sender;
- (IBAction) doubleButtonPressed:(id)sender;
- (IBAction) hitButtonPressed:(id)sender;
- (IBAction) dealStandButtonPressed:(id)sender;

- (IBAction) dealButtonForKeyboardPressed:(id)sender;

- (IBAction) amountValueChanged:(id)sender;

- (void) setupInitialScreen;

- (void) keyboardDismissed;
- (void) keyboardDisplayed;

- (NSData*) getApplicationData;
//- (void) saveToApplicationDataAtIndex:(NSInteger)index card:(uint8_t)data;
- (void) saveToApplicationData;

// the only TWO  entry points to this view is the following two methods.

- (void) willRestoreFromApplicationData:(uint8_t*)heroApplicationData;

- (void) willDisplayAtHand:(NSInteger)count 
				 heroStack:(NSInteger)heroStack;

- (void) killAllActiveTimers;
- (void) resetStuff;

- (void) postSplitAnimation;
- (void) postMiddleToLeftOneCardAnimation;
- (void) postMiddleToLeftAnimation;
- (void) postRightToMiddleAnimation;
- (void) postMiddleToLeftOneCardAceAnimation;
- (void) postMiddleToLeftAceAnimation;
- (void) postRightToMiddleAceAnimation;

- (NSInteger) heroTotalChips;

@end
