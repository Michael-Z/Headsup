//
//  OmahaTrainingModeView.h
//  Headsup
//
//  Created by Haolan Qin on 8/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>
#import "Constants.h"

#import "AppController.h"



@class CardView;
@class Deck;
@class Hand;


@interface OmahaTrainingModeView : UIView {
	UINavigationController *navController;
	AppController *appController;

	IBOutlet CardView *heroCard0View, *heroCard1View, *heroCard2View, *heroCard3View;
	IBOutlet CardView *villainCard0View, *villainCard1View, *villainCard2View, *villainCard3View;
	IBOutlet CardView *communityCard0View, *communityCard1View, *communityCard2View, 
	*communityCard3View, *communityCard4View;
	
	IBOutlet UILabel *heroStatusLabel, *heroPercentageLabel, *heroHandLabel, *heroOutsLabel, *heroWinsLabel;
	IBOutlet UILabel *villainStatusLabel, *villainPercentageLabel, *villainHandLabel, *villainOutsLabel, *villainWinsLabel;
		
	IBOutlet UIButton *endButton;
	IBOutlet UIButton *lobbyButton;
	
	IBOutlet UIActivityIndicatorView *waitingIndicator;
	
	IBOutlet UILabel *gameNameLabel;	
	IBOutlet UILabel *handCountLabel;
	
	IBOutlet UIButton *playPauseButton, *skipButton, *prevButton, *nextButton;
	IBOutlet UIButton *handButton;
	IBOutlet UIButton *sameDifferentButton;
	
	IBOutlet UILabel *statusLabel;

	Hand *hand;
	Deck *deck;
	
	// game state. the data will be saved when user exits the application so that the game can be
	// restored when user relaunches it.
	uint8_t *applicationData;	
	
	NSTimer *allInDealingTimer;
	NSTimer *showdownTimer;
	NSTimer *holeCardsDealingTimer;	
	NSTimer *infoTimer;
	NSTimer *dealToTheRiverTimer;

	NSInteger handCount;
	
	// YES: show hero hand; NO: show villain hand.
	BOOL heroOrVillainHand;
		
	// cached hero/villain preflop/flop percentages. if the value is INVALID_PERCENTAGE, then it
	// hasn't been cached yet.
	NSInteger preflopHeroPercentage, preflopVillainPercentage;
	NSInteger flopHeroPercentage, flopVillainPercentage;	
	
	// indexes of cards dealt in B mode (run it N times mode)
	// e.g. if switching street is preflop, every time we would deal five cards. indexes of those
	// five cards would be stored in this array.
	NSMutableArray *cardsDealt;	
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

@property (nonatomic, retain) IBOutlet UILabel *heroStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroPercentageLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroHandLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroOutsLabel;
@property (nonatomic, retain) IBOutlet UILabel *heroWinsLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainPercentageLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainHandLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainOutsLabel;
@property (nonatomic, retain) IBOutlet UILabel *villainWinsLabel;

@property (nonatomic, retain) IBOutlet UIButton *endButton;
@property (nonatomic, retain) IBOutlet UIButton *lobbyButton;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *waitingIndicator;

@property (nonatomic, retain) IBOutlet UILabel *gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *handCountLabel;

@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;
@property (nonatomic, retain) IBOutlet UIButton *skipButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *handButton;
@property (nonatomic, retain) IBOutlet UIButton *sameDifferentButton;

@property (nonatomic, retain) Deck* deck;
@property (nonatomic, retain) Hand* hand;



- (void)setUpStuff;

- (void)resetStuff;
- (void)killAllActiveTimers;

- (IBAction) endButtonPressed:(id)sender;
- (IBAction) lobbyButtonPressed:(id)sender;

- (IBAction) playPauseButtonPressed:(id)sender;
- (IBAction) skipButtonPressed:(id)sender;
- (IBAction) prevButtonPressed:(id)sender;
- (IBAction) nextButtonPressed:(id)sender;

- (IBAction) handButtonPressed:(id)sender;
- (IBAction) handButtonReleased:(id)sender;

- (IBAction) sameDifferentButtonPressed:(id)sender;

- (void)afterDisplayingWhoWonTimerFireMethod;
- (void)beforeDealingNextStreetTimerFireMethod;

- (void)dealSecondCardDealerTimerMethod;
- (void)dealThirdCardDealerTimerMethod;
- (void)dealFourthCardDealerTimerMethod;

- (void)dealNewHandAsDealer;

- (NSData*) getApplicationData;

// the only TWO  entry points to this view are the following two methods.
- (void) willRestoreFromApplicationData:(uint8_t*)appData;

- (void) willDisplay;


@end
