//
//  BlackjackHeadsupModeView.m
//  Headsup
//
//  Created by Haolan Qin on 11/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "BlackjackHeadsupModeView.h"
#import "Constants.h"
#import "Deck.h"
#import "Card.h"
#import "CardView.h"
#import "BlackjackVillain.h"

#define DEAL_BUTTON_TITLE	@"Deal"
#define STAND_BUTTON_TITLE	@"Stand"
#define DEAL_BUTTON_IMAGE @"dealbet.png"
#define STAND_BUTTON_IMAGE @"stand.png"

#define BLACKJACK @"Blackjack"
#define BUSTED @"Busted"

#define PUSH @"Push"
#define DEALER_BLACKJACK @"Dealer Got Blackjack"
#define DEALER_BUSTED @"Dealer Busted"
#define DEALER_WON @"Dealer Won"
#define HERO_BLACKJACK @"You Got Blackjack"
#define HERO_BUSTED @"You Busted"
#define HERO_WON @"You Won"

#define ACTION_STAND @"St"
#define ACTION_HIT @"H"
#define ACTION_DOUBLE @"D"
#define ACTION_SPLIT @"Sp"
#define ACTION_SURRENDER @"Sr"

#define RESULT_BLACKJACK @"BJ"
#define RESULT_WIN @"W"
#define RESULT_LOSS @"L"
#define RESULT_PUSH @"P"

#define ANIMATION_HERO_SPLIT @"ANIMATION_HERO_SPLIT"
#define ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD @"ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD"
#define ANIMATION_HERO_MIDDLE_TO_LEFT @"ANIMATION_HERO_MIDDLE_TO_LEFT"
#define ANIMATION_HERO_RIGHT_TO_MIDDLE @"ANIMATION_HERO_RIGHT_TO_MIDDLE"
#define ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD_ACE @"ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD_ACE"
#define ANIMATION_HERO_MIDDLE_TO_LEFT_ACE @"ANIMATION_HERO_MIDDLE_TO_LEFT_ACE"
#define ANIMATION_HERO_RIGHT_TO_MIDDLE_ACE @"ANIMATION_HERO_RIGHT_TO_MIDDLE_ACE"

#define ANIMATION_VILLAIN_SPLIT @"ANIMATION_VILLAIN_SPLIT"
#define ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD @"ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD"
#define ANIMATION_VILLAIN_MIDDLE_TO_LEFT @"ANIMATION_VILLAIN_MIDDLE_TO_LEFT"
#define ANIMATION_VILLAIN_RIGHT_TO_MIDDLE @"ANIMATION_VILLAIN_RIGHT_TO_MIDDLE"
#define ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD_ACE @"ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD_ACE"
#define ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ACE @"ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ACE"
#define ANIMATION_VILLAIN_RIGHT_TO_MIDDLE_ACE @"ANIMATION_VILLAIN_RIGHT_TO_MIDDLE_ACE"

#define HERO_STACK 1000
#define MIN_BET 10
#define MID_BET 30
#define BIG_BET 100

#define DEALING_DELAY 0.5
#define DEALER_DEALING_DELAY 1.0
#define SHOWDOWN_DELAY 5.0

#define CARD_SLIDING_LONG_DURATION 0.8
#define CARD_SLIDING_SHORT_DURATION 0.2

#define MAX_CARD_NUM 5

#define MAX_HAND_COUNT 15

#define STATUS_DEALING	@"Dealing..."
#define STATUS_THINKING	@"Thinking..."
#define STATUS_SHOWDOWN @"Showdown..."

@implementation BlackjackHeadsupModeView

@synthesize navController;
@synthesize appController;

@synthesize dealerCard0View;
@synthesize dealerCard1View;
@synthesize dealerCard2View;
@synthesize dealerCard3View;
@synthesize dealerCard4View;

@synthesize heroCard0View;
@synthesize heroCard1View;
@synthesize heroCard2View;
@synthesize heroCard3View;
@synthesize heroCard4View;
@synthesize heroFirstCardView;
@synthesize heroLastCardView;

@synthesize villainCard0View;
@synthesize villainCard1View;
@synthesize villainCard2View;
@synthesize villainCard3View;
@synthesize villainCard4View;
@synthesize villainFirstCardView;
@synthesize villainLastCardView;

@synthesize amountTextField;

@synthesize hintButton;
@synthesize surrenderButton;
@synthesize hintLabel;

@synthesize splitButton;
@synthesize doubleButton;
@synthesize hitButton;
@synthesize dealStandButton;
@synthesize dealButtonForKeyboard;

@synthesize noBetButton;
@synthesize minBetButton;
@synthesize midBetButton;
@synthesize bigBetButton;
@synthesize maxBetButton;

@synthesize endButton;
@synthesize lobbyButton;

@synthesize gameNameLabel;
@synthesize handCountLabel;

@synthesize dealerHandLabel;
@synthesize heroHandLabel;
@synthesize heroFirstHandLabel;
@synthesize heroStackLabel;
@synthesize heroStackLabelForKeyboard;
@synthesize resultLabel;

@synthesize villainHandLabel;
@synthesize villainFirstHandLabel;
@synthesize villainStackLabel;

@synthesize heroBetLabel;
@synthesize heroFirstBetLabel;
@synthesize villainBetLabel;
@synthesize villainFirstBetLabel;

@synthesize heroActionLabel;
@synthesize villainActionLabel;

@synthesize heroResultLabel;
@synthesize villainResultLabel;

@synthesize heroFirstBase;
@synthesize villainFirstBase;

@synthesize dealerCardsNumLabel;
@synthesize dealerCardsLabel;
@synthesize heroCardsNumLabel;
@synthesize heroCardsLabel;

@synthesize villainWaitIndicator;

@synthesize deck;

@synthesize soundFileURLRef;
@synthesize soundFileObject;

@synthesize foldSoundFileURLRef;
@synthesize foldSoundFileObject;

@synthesize checkSoundFileURLRef;
@synthesize checkSoundFileObject;

@synthesize callSoundFileURLRef;
@synthesize callSoundFileObject;

@synthesize betSoundFileURLRef;
@synthesize betSoundFileObject;

@synthesize raiseSoundFileURLRef;
@synthesize raiseSoundFileObject;


@synthesize dealingCardsSoundFileURLRef;
@synthesize dealingCardsSoundFileObject;

@synthesize allInSoundFileURLRef;
@synthesize allInSoundFileObject;

@synthesize wonPotSoundFileURLRef;
@synthesize wonPotSoundFileObject;

@synthesize showCardsSoundFileURLRef;
@synthesize showCardsSoundFileObject;

@synthesize slidingSoundFileURLRef;
@synthesize slidingSoundFileObject;

- (void) resetStuff {
	[deck release];
	deck = [[Deck alloc] init];	
	
	[dealerCardViews release];
	dealerCardViews = [[NSMutableArray alloc] init];
	
	[heroCardViews release];
	heroCardViews = [[NSMutableArray alloc] init];
	
	[villainCardViews release];
	villainCardViews = [[NSMutableArray alloc] init]; 
		
	free(applicationData);
	applicationData = malloc(HEADSUP_BLACKJACK_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	applicationData[0] = (uint8_t)0;
		
	endButton.hidden = YES;
	[endButton setNeedsDisplay];
	
	handCount = 0;	
	
	strategyCard = [[NSArray arrayWithObjects:
					HIT, HIT, HIT, HIT, HIT, HIT, HIT, HIT, HIT, HIT,
					HIT, HIT, HIT, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
					DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
					DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT,
					DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE,
					HIT, HIT, STAND, STAND, STAND, HIT, HIT, HIT, HIT, HIT,
					STAND, STAND, STAND, STAND, STAND, HIT, HIT, HIT, HIT, HIT,
					STAND, STAND, STAND, STAND, STAND, HIT, HIT, HIT, HIT, HIT,
					STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND,
					STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND,
					STAND, STAND, STAND, STAND, DOUBLE, STAND, STAND, STAND, STAND, STAND,
					STAND, DOUBLE, DOUBLE, DOUBLE, DOUBLE, STAND, STAND, HIT, HIT, STAND,
					DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
					HIT, HIT, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
					HIT, HIT, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
					SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, 
					STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND,
					SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, STAND, SPLIT, SPLIT, SPLIT, SPLIT, 
					SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, 
					SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, STAND, HIT, 
					SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, HIT, HIT, HIT, 
					DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT,
					HIT, HIT, HIT, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
					HIT, HIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, HIT, HIT, 
					HIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, HIT, HIT,
					nil
					] retain];
}

- (void)setUpStuff {
	
	[self resetStuff];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardDismissed) 
												 name:UIKeyboardWillHideNotification object:nil]; 	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardDisplayed) 
												 name:UIKeyboardWillShowNotification object:nil]; 	
	
	// Get the main bundle for the app
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();
	
	// Get the URL to the sound file to play
	soundFileURLRef  =	CFBundleCopyResourceURL (
												 mainBundle,
												 CFSTR ("YourTurn"),
												 CFSTR ("wav"),
												 NULL
												 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  soundFileURLRef,
									  &soundFileObject
									  );
	
	// Get the URL to the sound file to play
	foldSoundFileURLRef  =	CFBundleCopyResourceURL (
												 mainBundle,
												 CFSTR ("FoldingCards"),
												 CFSTR ("wav"),
												 NULL
												 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  foldSoundFileURLRef,
									  &foldSoundFileObject
									  );
	
	// Get the URL to the sound file to play
	checkSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("CHECK"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  checkSoundFileURLRef,
									  &checkSoundFileObject
									  );
	
	// Get the URL to the sound file to play
	callSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("Bet-2"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  callSoundFileURLRef,
									  &callSoundFileObject
									  );

	
	// Get the URL to the sound file to play
	betSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("Bet-1"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  betSoundFileURLRef,
									  &betSoundFileObject
									  );

	
	// Get the URL to the sound file to play
	raiseSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("Raise-1"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  raiseSoundFileURLRef,
									  &raiseSoundFileObject
									  );
	
	
	
	// Get the URL to the sound file to play
	dealingCardsSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("DealingCards"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  dealingCardsSoundFileURLRef,
									  &dealingCardsSoundFileObject
									  );
	
	// Get the URL to the sound file to play
	allInSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("AllIn"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  allInSoundFileURLRef,
									  &allInSoundFileObject
									  );
	
	// Get the URL to the sound file to play
	wonPotSoundFileURLRef  =	CFBundleCopyResourceURL (
													 mainBundle,
													 CFSTR ("ChipsToPlayer"),
													 CFSTR ("wav"),
													 NULL
													 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  wonPotSoundFileURLRef,
									  &wonPotSoundFileObject
									  );	
	
	
	// Get the URL to the sound file to play
	showCardsSoundFileURLRef  =	CFBundleCopyResourceURL (
															 mainBundle,
															 CFSTR ("ShowCards"),
															 CFSTR ("wav"),
															 NULL
															 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  showCardsSoundFileURLRef,
									  &showCardsSoundFileObject
									  );
	
	// Get the URL to the sound file to play
	slidingSoundFileURLRef  =	CFBundleCopyResourceURL (
														 mainBundle,
														 CFSTR ("slidding"),
														 CFSTR ("wav"),
														 NULL
														 );
	
	// Create a system sound object representing the sound file
	AudioServicesCreateSystemSoundID (
									  slidingSoundFileURLRef,
									  &slidingSoundFileObject
									  );
}

- (id)initWithCoder:(NSCoder *)coder {	
	if (self = [super initWithCoder:coder]) {
		[self setUpStuff];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self setUpStuff];
    }
    return self;
}

- (void)dealloc {
	[deck release];
	
	[dealerCardViews release];
	[heroCardViews release];
	[villainCardViews release];
	
	free(applicationData);
	
	AudioServicesDisposeSystemSoundID (self.soundFileObject);
	CFRelease (soundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.foldSoundFileObject);
	CFRelease (foldSoundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.checkSoundFileObject);
	CFRelease (checkSoundFileURLRef);
	
	AudioServicesDisposeSystemSoundID (self.callSoundFileObject);
	CFRelease (callSoundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.betSoundFileObject);
	CFRelease (betSoundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.raiseSoundFileObject);
	CFRelease (raiseSoundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.dealingCardsSoundFileObject);
	CFRelease (dealingCardsSoundFileURLRef);
	
	AudioServicesDisposeSystemSoundID (self.allInSoundFileObject);
	CFRelease (allInSoundFileURLRef);
	
	AudioServicesDisposeSystemSoundID (self.wonPotSoundFileObject);
	CFRelease (wonPotSoundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.showCardsSoundFileObject);
	CFRelease (showCardsSoundFileURLRef);

	AudioServicesDisposeSystemSoundID (self.slidingSoundFileObject);
	CFRelease (slidingSoundFileURLRef);

    [super dealloc];
}

- (NSData*) getApplicationData {
	return [[[NSData alloc] initWithBytes:applicationData length:HEADSUP_BLACKJACK_APPLICATION_DATA_LENGTH] autorelease];
}

- (void) playYourTurnSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.soundFileObject);
}	

- (void) playFoldSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.foldSoundFileObject);	
}

- (void) playCheckSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.checkSoundFileObject);	
}

- (void) playCallSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.callSoundFileObject);	
}

- (void) playBetSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.betSoundFileObject);	
}

- (void) playRaiseSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.raiseSoundFileObject);	
}

- (void) playDealingCardsSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.dealingCardsSoundFileObject);	
}

- (void) playAllInSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.allInSoundFileObject);	
}

- (void) playHeroWonPotSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.wonPotSoundFileObject);	
}

- (void) playShowCardsSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.showCardsSoundFileObject);	
}

- (void) playSlidingSound {
	if ([[NSUserDefaults standardUserDefaults] boolForKey:KEY_SOUND])
		AudioServicesPlaySystemSound (self.slidingSoundFileObject);	
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void) startWaitIndicator:(NSString*) status {
	[statusLabel setText:status];
	[statusLabel setHidden:NO];
	
	waitingIndicator.hidden = NO;
	[waitingIndicator startAnimating];
}

- (void) stopWaitIndicator {
	[statusLabel setHidden:YES];
	
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
}

- (void) villainStartWaiting {
	/*[villainWaitIndicator setHidden:NO];
	 [villainWaitIndicator startAnimating];*/
	
	[self startWaitIndicator:STATUS_THINKING];
}

- (void) villainStopWaiting {
	/*[villainWaitIndicator setHidden:YES];
	 [villainWaitIndicator stopAnimating];*/
	
	[self stopWaitIndicator];
}

/*- (void) updateNumberLabel:(UILabel*)label addAmount:(float)amount {
	float currentValue = [[label text] floatValue];
	[label setText:[NSString stringWithFormat:@"%.2f", currentValue + amount]];
	[label setNeedsDisplay];
}*/

- (uint8_t) action2byte:(NSString*)action {
	uint8_t retval = 0;
	
	if ([action isEqualToString:ACTION_SPLIT]) {
		retval = 1;
	} else 	if ([action isEqualToString:ACTION_DOUBLE]) {
		retval = 2;
	} else if ([action isEqualToString:ACTION_HIT]) {
		retval = 3;
	} else 	if ([action isEqualToString:ACTION_STAND]) {
		retval = 4;
	}
	
	return retval;
}

- (NSString*) byte2action:(uint8_t)actionCode {
	NSString* retval = @"";
	
	if (actionCode == 1) {
		retval = ACTION_SPLIT;
	} else if (actionCode == 2) {
		retval = ACTION_DOUBLE;
	} else if (actionCode == 3) {
		retval = ACTION_HIT;
	} else if (actionCode == 4) {
		retval = ACTION_STAND;
	}
	
	return retval;
}

- (void) updateNumberLabel:(UILabel*)label addAmount:(NSInteger)amount {
 NSInteger currentValue = [[label text] intValue];
 [label setText:[NSString stringWithFormat:@"%d", currentValue + amount]];
}

- (NSInteger) userAmount {
	return [[amountTextField text] integerValue];
}

- (NSInteger) heroSingleBet {
	NSInteger bet = currentHeroBet;
	NSInteger retval;
	
	if (heroFirstCardView.card == nil && isHeroFirstHandDoubleDown)
		retval = bet / 2;
	else if (heroFirstCardView.card != nil && isHeroSecondHandDoubleDown)
		retval = bet / 2;
	else
		retval = bet;
	
	return retval;
}

- (NSInteger) villainSingleBet {
	NSInteger bet = currentVillainBet;
	NSInteger retval;
	
	if (villainFirstCardView.card == nil && isVillainFirstHandDoubleDown)
		retval = bet / 2;
	else if (villainFirstCardView.card != nil && isVillainSecondHandDoubleDown)
		retval = bet / 2;
	else
		retval = bet;
	
	return retval;
}

- (NSInteger) heroStack {
	return [heroStackLabel.text intValue];
}

- (NSInteger) villainStack {
	return [villainStackLabel.text intValue];
}

- (NSInteger) maxAmountAllowed {
	NSInteger heroTotalChips = [self heroStack] + [self userAmount];
	NSInteger maxBet = heroTotalChips / MIN_BET * MIN_BET;
	
	return maxBet;
}

- (BOOL) isHeroFirstBase {
	return ![heroFirstBase isHidden];
}

- (void) clearApplicationData {
	applicationData[0] = (uint8_t)0;
	[appController writeBlackjackHeadsupModeApplicationData:[self getApplicationData]];
}

- (void) setCurrentHeroBet:(NSInteger)bet {
	currentHeroBet = bet;
	
	[heroBetLabel setText:
		(currentHeroBet == 0 ?
		 @"" :
		[NSString stringWithFormat:@"%d", currentHeroBet])];
	[amountTextField setText:[NSString stringWithFormat:@"%d", currentHeroBet]];
}

- (void) setCurrentVillainBet:(NSInteger)bet {
	currentVillainBet = bet;
	
	[villainBetLabel setText:
		(currentVillainBet == 0 ?
		 @"" :
		 [NSString stringWithFormat:@"%d", currentVillainBet])];
}

- (void) startNewTournament {
	[self setupInitialScreen];
	
	[self setCurrentHeroBet:0];
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", HERO_STACK]];
	[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", HERO_STACK]];
	
	[self setCurrentVillainBet:0];
	[villainStackLabel setText:[NSString stringWithFormat:@"%d", HERO_STACK]];
	
	[dealButtonForKeyboard setHidden:YES];
	[heroStackLabelForKeyboard setHidden:YES];
	
	// determine who's gonna be FB (First Base)
	// reseed RNG
	srandomdev();
	
	if (random() % 2 == 0) {
		// hero is FB
		[heroFirstBase setHidden:NO];
		[villainFirstBase setHidden:YES];				
	} else {
		// villain is FB
		[heroFirstBase setHidden:YES];
		[villainFirstBase setHidden:NO];		
	}	

	applicationData[0] = (uint8_t)1;
	gameState = kHUBJStateFirstBasesTurnToBet;
	[self saveToApplicationData];
	
	if ([self isHeroFirstBase]) {
		[self herosTurnToBet];
	} else {
		[villain firstToBet];
	}
}	

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if (buttonIndex == 0) {
        if ([AppController isFreeVersion]) {
            [GSAdEngine displayFullScreenAdForSlotNamed:@"fullscreenSlot"];
        }
        
		[self startNewTournament];
	} else {
		// do nothing
	}	
}

- (void) killAllActiveTimers {
	[dealerCardsDealingTimer invalidate];
	dealerCardsDealingTimer = nil;
		
	[holeCardsDealingTimer invalidate];
	holeCardsDealingTimer = nil;
	
	[showdownTimer invalidate];
	showdownTimer = nil;
}

- (NSInteger) validateAmount {
	NSInteger amount = [self userAmount];
	
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	
	if (amount >= maxAmountAllowed) {
		amount = maxAmountAllowed;
	} else {
		amount = amount / MIN_BET * MIN_BET;
		
		if (amount < MIN_BET)
			amount = MIN_BET;
	}
	
	return amount;
}

// called when keyboard is dismissed.
// we need to correct bet/raise when this method is called.
- (void)keyboardDismissed {
	// hide the deal button
	[dealButtonForKeyboard setHidden:YES];
	[heroStackLabelForKeyboard setHidden:YES];
	
	// validate user input
	NSInteger amount = [self validateAmount];
	
	float diff = currentHeroBet - amount;
	[self updateNumberLabel:heroStackLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:diff];
	
	[self setCurrentHeroBet:amount];
}

- (void) keyboardDisplayed {
	[dealButtonForKeyboard setHidden:NO];
	[heroStackLabelForKeyboard setHidden:NO];
}

- (BOOL) isSoft:(enum Party)party {
	NSMutableArray *cardViews;
	NSInteger cardsNum;
	
	if (party == kPartyDealer) {
		cardViews = dealerCardViews;
		cardsNum = dealerCardsNum;
	} else if (party == kPartyHero) {
		cardViews = heroCardViews;
		cardsNum = heroCardsNum;
	} else { // if (party == kPartyVillain
		cardViews = villainCardViews;
		cardsNum = villainCardsNum;
	}
	
	BOOL retval = NO;
	
	for (int i=0; i < cardsNum; i++) {
		Card *card = ((CardView*)[cardViews objectAtIndex:i]).card;
		if (card.rank == kRankAce) {
			retval = YES;
			break;
		}
	}
	
	return retval;
}

- (BOOL) isBlackjack:(enum Party)party {
	NSMutableArray *cardViews;
	NSInteger cardsNum;
	
	if (party == kPartyDealer) {
		cardViews = dealerCardViews;
		cardsNum = dealerCardsNum;
	} else if (party == kPartyHero) {
		cardViews = heroCardViews;
		cardsNum = heroCardsNum;
	} else { // if (party == kPartyVillain
		cardViews = villainCardViews;
		cardsNum = villainCardsNum;
	}
	
	BOOL retval = NO;
	
	// To count as Blackjack, a hand must have only two cards with a total of
	// 21 and it cannot be in a splitting hand.
	if (cardsNum == 2 && 
		(party == kPartyDealer || 
		 (party == kPartyHero && heroOtherCardsNum == 0) ||
		 (party == kPartyVillain && villainOtherCardsNum == 0))) {
			
		Card *card0 = ((CardView*)[cardViews objectAtIndex:0]).card;
		Card *card1 = ((CardView*)[cardViews objectAtIndex:1]).card;
		
		retval = ((card0.rank == kRankAce || 
				   card1.rank == kRankAce) &&
				  [card0 getBlackjackValue] + [card1 getBlackjackValue] == 11);
	}
	
	return retval;
}

- (NSInteger) getVillainCardsNum {
	return villainCardsNum;
}

- (NSInteger) getVillainHandValue {
	return villainHandValue;
}

- (NSInteger) getCurrentHeroBet {
	return currentHeroBet;
}

- (NSInteger) getCurrentVillainBet {
	return currentVillainBet;
}

// hard value
- (NSInteger) calcTotalValue:(enum Party) party {
	NSMutableArray *cardViews;
	NSInteger cardsNum;
	
	if (party == kPartyDealer) {
		cardViews = dealerCardViews;
		cardsNum = dealerCardsNum;
	} else if (party == kPartyHero) {
		cardViews = heroCardViews;
		cardsNum = heroCardsNum;
	} else { // if (party == kPartyVillain
		cardViews = villainCardViews;
		cardsNum = villainCardsNum;
	}
	
	NSInteger retval = 0;
	
	for (int i=0; i < cardsNum; i++) {
		Card *card = ((CardView*)[cardViews objectAtIndex:i]).card;
		retval += [card getBlackjackValue];		
	}
		
	return retval;
}

- (NSInteger) calcDealerHandSoftValue {
	return isDealerHandSoft && dealerHandValue <= 11 ? dealerHandValue + 10 : dealerHandValue;
}

- (NSInteger) calcHeroHandSoftValue {
	return isHeroHandSoft && heroHandValue <= 11 ? 
	heroHandValue + 10 : 
	heroHandValue;
}

- (NSInteger) calcHeroFirstHandSoftValue {
	return isHeroFirstHandSoft && heroFirstHandValue <= 11 ? 
	heroFirstHandValue + 10 : 
	heroFirstHandValue;
}

- (NSInteger) calcHeroSecondHandSoftValue {
	return isHeroSecondHandSoft && heroSecondHandValue <= 11 ? 
	heroSecondHandValue + 10 : 
	heroSecondHandValue;
}

- (NSInteger) calcVillainHandSoftValue {
	return isVillainHandSoft && villainHandValue <= 11 ? 
	villainHandValue + 10 : 
	villainHandValue;
}

- (NSInteger) calcVillainFirstHandSoftValue {
	return isVillainFirstHandSoft && villainFirstHandValue <= 11 ? 
	villainFirstHandValue + 10 : 
	villainFirstHandValue;
}

- (NSInteger) calcVillainSecondHandSoftValue {
	return isVillainSecondHandSoft && villainSecondHandValue <= 11 ? 
	villainSecondHandValue + 10 : 
	villainSecondHandValue;
}

- (void) setEnabledBettingSystem:(BOOL)isEnabled {
	[noBetButton setHidden:!isEnabled];
	[minBetButton setHidden:!isEnabled];
	[midBetButton setHidden:!isEnabled];
	[bigBetButton setHidden:!isEnabled];
	[maxBetButton setHidden:!isEnabled];
	
	[amountTextField setHidden:!isEnabled];
}

- (void) resetButtons {
	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[AppController changeTitleOfButton:dealStandButton to:DEAL_BUTTON_TITLE];
	[AppController changeImageOfButton:dealStandButton to:DEAL_BUTTON_IMAGE];
	[dealStandButton setHidden:NO];	
	[hintButton setHidden:YES];
	
	[self setEnabledBettingSystem:YES];
}

- (void) resetForNewHand {
	[self stopWaitIndicator];
	
	longShowdownDelay = NO;
	
	[self setEnabledBettingSystem:NO];
	
	[handCountLabel setText:[NSString stringWithFormat:@"%d", ++handCount]];
	
	[self setCurrentHeroBet:0];
	[self setCurrentVillainBet:0];
	
	isHeroFirstHandDoubleDown = NO;
	isHeroSecondHandDoubleDown = NO;

	isVillainFirstHandDoubleDown = NO;
	isVillainSecondHandDoubleDown = NO;

	// reset cards
	dealerCard0View.faceUp = YES;
	dealerCard1View.faceUp = NO;
	dealerCard2View.faceUp = YES;
	dealerCard3View.faceUp = YES;
	dealerCard4View.faceUp = YES;
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	heroCard4View.faceUp = YES;
	heroFirstCardView.faceUp = YES;
	heroLastCardView.faceUp = YES;
	
	dealerCard0View.card = nil;
	dealerCard1View.card = nil;
	dealerCard2View.card = nil;
	dealerCard3View.card = nil;
	dealerCard4View.card = nil;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	heroFirstCardView.card = nil;
	heroLastCardView.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
	villainFirstCardView.card = nil;
	villainLastCardView.card = nil;	
	
	dealerCardsNum = 0;
	heroCardsNum = 0;
	heroOtherCardsNum = 0;
	villainCardsNum = 0;
	villainOtherCardsNum = 0;
	
	isDealerHandSoft = NO;
	isHeroHandSoft = NO;
	isHeroFirstHandSoft = NO;
	isHeroSecondHandSoft = NO;
	isVillainHandSoft = NO;
	isVillainFirstHandSoft = NO;
	isVillainSecondHandSoft = NO;
	
	dealerHandValue = 0;
	heroHandValue = 0;
	heroFirstHandValue = 0;
	heroSecondHandValue = 0;
	villainHandValue = 0;
	villainFirstHandValue = 0;
	villainSecondHandValue = 0;
	
	// reset buttons
	[hintButton setHidden:YES];
	[hintLabel setText:@""];
	[surrenderButton setHidden:YES];
		
	// reset labels
	[dealerHandLabel setText:@""];
	[heroActionLabel setText:@""];
	[heroResultLabel setText:@""];
	[heroHandLabel setText:@""];
	[heroFirstHandLabel setText:@""];
	[villainActionLabel setText:@""];
	[villainResultLabel setText:@""];
	[villainHandLabel setText:@""];
	[villainFirstHandLabel setText:@""];
	[resultLabel setText:@""];
	
	[dealerCardsNumLabel setHidden:YES];
	[dealerCardsLabel setHidden:YES];
	[heroCardsNumLabel setHidden:YES];
	[heroCardsLabel setHidden:YES];
	
	// auto-save point
	gameState = kHUBJStateFirstBasesTurnToBet;
	// flag bit
	applicationData[0] = (uint8_t)1;	
	// clear all boolean flags
	applicationData[1] = (uint8_t)0;
	applicationData[2] = (uint8_t)0;
	// save applicationData[4-44]
	[self saveToApplicationData];
	// cards applicationData[45-67] have already been set	
}

- (float) calcHeroBetsWon {
	float betsWon = 0;
	NSInteger dealerHandSoftValue = [self calcDealerHandSoftValue];
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	NSInteger heroFirstHandSoftValue = [self calcHeroFirstHandSoftValue];	
	
	if ([dealerHandLabel.text isEqualToString:BLACKJACK]) {
		if ([heroHandLabel.text isEqualToString:BLACKJACK])
			betsWon = 0;
		else
			betsWon = -1;
	} else if ([dealerHandLabel.text isEqualToString:BUSTED]) {
		if ([heroFirstHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (isHeroFirstHandDoubleDown)
				betsWon -= 1;
		} else if ([heroFirstHandLabel.text isEqualToString:@""]) {
			betsWon += 0;
		} else {
			betsWon += 1;				
			if (isHeroFirstHandDoubleDown)
				betsWon += 1;
		}
		
		if ([heroHandLabel.text isEqualToString:BLACKJACK]) {
			betsWon += 1.5;
		} else if ([heroHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (heroFirstCardView.card == nil && isHeroFirstHandDoubleDown)
				betsWon -= 1;
			else if (heroFirstCardView.card != nil && isHeroSecondHandDoubleDown)
				betsWon -= 1;
		} else {
			betsWon += 1;
			if (heroFirstCardView.card == nil && isHeroFirstHandDoubleDown)
				betsWon += 1;
			else if (heroFirstCardView.card != nil && isHeroSecondHandDoubleDown)
				betsWon += 1;
		}
	} else { // dealer has 17 to 21
		if ([heroFirstHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (isHeroFirstHandDoubleDown)
				betsWon -= 1;
		} else if ([heroFirstHandLabel.text isEqualToString:@""]) {
			betsWon += 0;
		} else {
			if (dealerHandSoftValue > heroFirstHandSoftValue) {
				betsWon -= 1;
				if (isHeroFirstHandDoubleDown)
					betsWon -= 1;
			} else if (dealerHandSoftValue < heroFirstHandSoftValue) {
				betsWon += 1;
				if (isHeroFirstHandDoubleDown)
					betsWon += 1;
			} else
				betsWon += 0;
		}
		
		if ([heroHandLabel.text isEqualToString:BLACKJACK]) {
			betsWon += 1.5;
		} else if ([heroHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (heroFirstCardView.card == nil && isHeroFirstHandDoubleDown)
				betsWon -= 1;
			else if (heroFirstCardView.card != nil && isHeroSecondHandDoubleDown)
				betsWon -= 1;
		} else {			
			if (dealerHandSoftValue > heroHandSoftValue) {
				betsWon -= 1;
				if (heroFirstCardView.card == nil && isHeroFirstHandDoubleDown)
					betsWon -= 1;
				else if (heroFirstCardView.card != nil && isHeroSecondHandDoubleDown)
					betsWon -= 1;				
			} else if (dealerHandSoftValue < heroHandSoftValue) {
				betsWon += 1;
				if (heroFirstCardView.card == nil && isHeroFirstHandDoubleDown)
					betsWon += 1;
				else if (heroFirstCardView.card != nil && isHeroSecondHandDoubleDown)
					betsWon += 1;
			} else
				betsWon += 0;
		}		
	}
	
	return betsWon;
}

- (void) processHeroResults {	
	float betsWon = [self calcHeroBetsWon];
	NSInteger singleBet = [self heroSingleBet];
	
	NSInteger betAmountWon = betsWon * singleBet;	
	if (betAmountWon == 1.5 * singleBet) {
		[heroResultLabel setText:RESULT_BLACKJACK];
	} else if (betAmountWon == 0) {
		[heroResultLabel setText:RESULT_PUSH];
	} else if (betAmountWon > 0) {
		[heroResultLabel setText:RESULT_WIN];
	} else if (betAmountWon < 0) {
		[heroResultLabel setText:RESULT_LOSS];
	}
	
	// calculate hero's total chips left.
	// number of single bets put in by hero in this hand
	NSInteger betsPutIn = 0;
	if (heroOtherCardsNum == 0) {
		// hero has one hand
		betsPutIn = isHeroFirstHandDoubleDown ? 2 : 1;
	} else {
		// hero has two hands
		betsPutIn = (isHeroFirstHandDoubleDown ? 2 : 1) + 
		(isHeroSecondHandDoubleDown ? 2 : 1);
	}
	NSInteger heroTotalChips = [self heroStack] + (betsPutIn + betsWon) * singleBet;
	//NSLog(@"%d %d %d %f %d", heroTotalChips, [self heroStack], betsPutIn, betsWon, singleBet);
	
	// can't set currentHeroBet to 0 yet as the value is needed in saveToApplicationData
	[heroBetLabel setText:@""];
	[heroFirstBetLabel setText:@""];
	//[self setCurrentHeroBet:0];
	
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroTotalChips]];
	[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", heroTotalChips]];		
}

- (float) calcVillainBetsWon {
	float betsWon = 0;
	NSInteger dealerHandSoftValue = [self calcDealerHandSoftValue];
	NSInteger villainHandSoftValue = [self calcVillainHandSoftValue];
	NSInteger villainFirstHandSoftValue = [self calcVillainFirstHandSoftValue];	
	
	if ([dealerHandLabel.text isEqualToString:BLACKJACK]) {
		if ([villainHandLabel.text isEqualToString:BLACKJACK])
			betsWon = 0;
		else
			betsWon = -1;
	} else if ([dealerHandLabel.text isEqualToString:BUSTED]) {
		if ([villainFirstHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (isVillainFirstHandDoubleDown)
				betsWon -= 1;
		} else if ([villainFirstHandLabel.text isEqualToString:@""]) {
			betsWon += 0;
		} else {
			betsWon += 1;				
			if (isVillainFirstHandDoubleDown)
				betsWon += 1;
		}
		
		if ([villainHandLabel.text isEqualToString:BLACKJACK]) {
			betsWon += 1.5;
		} else if ([villainHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (villainFirstCardView.card == nil && isVillainFirstHandDoubleDown)
				betsWon -= 1;
			else if (villainFirstCardView.card != nil && isVillainSecondHandDoubleDown)
				betsWon -= 1;
		} else {
			betsWon += 1;
			if (villainFirstCardView.card == nil && isVillainFirstHandDoubleDown)
				betsWon += 1;
			else if (villainFirstCardView.card != nil && isVillainSecondHandDoubleDown)
				betsWon += 1;
		}
	} else { // dealer has 17 to 21
		if ([villainFirstHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (isVillainFirstHandDoubleDown)
				betsWon -= 1;
		} else if ([villainFirstHandLabel.text isEqualToString:@""]) {
			betsWon += 0;
		} else {
			if (dealerHandSoftValue > villainFirstHandSoftValue) {
				betsWon -= 1;
				if (isVillainFirstHandDoubleDown)
					betsWon -= 1;
			} else if (dealerHandSoftValue < villainFirstHandSoftValue) {
				betsWon += 1;
				if (isVillainFirstHandDoubleDown)
					betsWon += 1;
			} else
				betsWon += 0;
		}
		
		if ([villainHandLabel.text isEqualToString:BLACKJACK]) {
			betsWon += 1.5;
		} else if ([villainHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (villainFirstCardView.card == nil && isVillainFirstHandDoubleDown)
				betsWon -= 1;
			else if (villainFirstCardView.card != nil && isVillainSecondHandDoubleDown)
				betsWon -= 1;
		} else {			
			if (dealerHandSoftValue > villainHandSoftValue) {
				betsWon -= 1;
				if (villainFirstCardView.card == nil && isVillainFirstHandDoubleDown)
					betsWon -= 1;
				else if (villainFirstCardView.card != nil && isVillainSecondHandDoubleDown)
					betsWon -= 1;				
			} else if (dealerHandSoftValue < villainHandSoftValue) {
				betsWon += 1;
				if (villainFirstCardView.card == nil && isVillainFirstHandDoubleDown)
					betsWon += 1;
				else if (villainFirstCardView.card != nil && isVillainSecondHandDoubleDown)
					betsWon += 1;
			} else
				betsWon += 0;
		}		
	}
	
	return betsWon;
}

- (void) processVillainResults {	
	float betsWon = [self calcVillainBetsWon];
	NSInteger singleBet = [self villainSingleBet];
	
	NSInteger betAmountWon = betsWon * singleBet;	
	if (betAmountWon == 1.5 * singleBet) {
		[villainResultLabel setText:RESULT_BLACKJACK];
	} else if (betAmountWon == 0) {
		[villainResultLabel setText:RESULT_PUSH];
	} else if (betAmountWon > 0) {
		[villainResultLabel setText:RESULT_WIN];
	} else if (betAmountWon < 0) {
		[villainResultLabel setText:RESULT_LOSS];
	}	
	
	// calculate villain's total chips left.
	// number of single bets put in by villain in this hand
	NSInteger betsPutIn = 0;
	if (villainOtherCardsNum == 0) {
		// villain has one hand
		betsPutIn = isVillainFirstHandDoubleDown ? 2 : 1;
	} else {
		// villain has two hands
		betsPutIn = (isVillainFirstHandDoubleDown ? 2 : 1) + 
		(isVillainSecondHandDoubleDown ? 2 : 1);
	}
	NSInteger villainTotalChips = [self villainStack] + (betsPutIn + betsWon) * singleBet;
	//NSLog(@"%d %d %d %f %d", villainTotalChips, [self villainStack], betsPutIn, betsWon, singleBet);
	
	// can't set currentVillainBet to 0 yet as the value is needed in saveToApplicationData
	[villainBetLabel setText:@""];
	[villainFirstBetLabel setText:@""];	
	//[self setCurrentVillainBet:0];
	
	[villainStackLabel setText:[NSString stringWithFormat:@"%d", villainTotalChips]];
}	

// the game is over. determine who is the winner.
- (BOOL) didHeroWin {
	BOOL retval = YES;
	
	// note that currentHeroBet and currentVillainBet can't be used here as 
	// they can be non-zero and they are already part of hero/villainStack
	// at this point.
	NSInteger heroTotalChips = [self heroStack];
	NSInteger villainTotalChips = [self villainStack];

	if (heroTotalChips > villainTotalChips) {
		retval = YES;
	} else if (heroTotalChips < villainTotalChips) {
		retval = NO;
	} else { // if (heroTotalChips == villainTotalChips)
		retval = [self isHeroFirstBase];
	}
	
	return retval;
}

- (void) postShowdownTimerMethod {
	showdownTimer = nil;
	
	[self resetForNewHand];
	[heroBetLabel setText:@""];
	[heroFirstBetLabel setText:@""];
	[villainBetLabel setText:@""];
	[villainFirstBetLabel setText:@""];
	
	// move first base button
	if ([self isHeroFirstBase]) {
		[heroFirstBase setHidden:YES];
		[villainFirstBase setHidden:NO];
	} else {
		[heroFirstBase setHidden:NO];
		[villainFirstBase setHidden:YES];
	}	
	
	[self saveToApplicationData];
	
	if ([self isHeroFirstBase]) {
		[self resetButtons];
	} else {
		[villain firstToBet];
	}
}	

- (void) nextHand {
	// check if the game is over
	if ([self heroStack] < MIN_BET ||
		[self villainStack] < MIN_BET ||
		handCount == MAX_HAND_COUNT) {
		
		AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
		
		// this heads up game is over. determine who is the winner
		BOOL heroWon = [self didHeroWin];
		
		if (heroWon) {
			[appController incrementHighScoreHeadsupBlackjackSinglePlayer];
		}
		
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:(heroWon ? @"You Won!" : @"You Lost")
															message:@"Tap OK to start over"
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];	
		[alertView show];
		[alertView release];			
	} else {
		// the game is not over yet. move on to the next hand.
		showdownTimer = 
		[NSTimer scheduledTimerWithTimeInterval:longShowdownDelay ? SHOWDOWN_DELAY * 2 : SHOWDOWN_DELAY 
										 target:self 
									   selector:@selector(postShowdownTimerMethod) 
									   userInfo:nil 
										repeats:NO];		
	}
}	

// update hero stack based on results indicated in dealer's hand label, hero's hand label,
// hero's first hand label, villain's hand label and villain's first hand label.
- (void) processResults {
	[self processHeroResults];
	[self processVillainResults];
			
	// this hand is over
	//SET_BOOLEAN_FLAG(applicationData[1], 1, YES);
	gameState = kHUBJStateResultsProcessed;
	[self saveToApplicationData];
	
	[self nextHand];			
}

- (void) dealFirstCard {
	[self playDealingCardsSound];
	heroCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardTimerMethod {
	[self playDealingCardsSound];
	villainCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardTimerMethod {
	[self playDealingCardsSound];
	dealerCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardTimerMethod {
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFifthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFifthCardTimerMethod {
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSixthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) showDealersSecondCard {
	[self startWaitIndicator:STATUS_SHOWDOWN];
	
	[self playDealingCardsSound];
	
	//SET_BOOLEAN_FLAG(applicationData[1], 0, YES);
	gameState = kHUBJStateDealersTurnToAct;
	[self saveToApplicationData];

	dealerCard1View.faceUp = YES;
	[dealerCard1View setNeedsDisplay];
}

- (void) showDealerHand {
	NSInteger dealerHandSoftValue = [self calcDealerHandSoftValue];
	
	if ([self isBlackjack:kPartyDealer]) {
		[dealerHandLabel setText:BLACKJACK];
	} else {		
		if (dealerHandSoftValue > 21)
			[dealerHandLabel setText:BUSTED];
		else
			[dealerHandLabel setText:[NSString stringWithFormat:@"%d", dealerHandSoftValue]];
	}
}

- (void) showHeroHand {
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	
	if ([self isBlackjack:kPartyHero]) {
		[heroHandLabel setText:BLACKJACK];
	} else {		
		if (heroHandSoftValue > 21)
			[heroHandLabel setText:BUSTED];
		else
			[heroHandLabel setText:[NSString stringWithFormat:@"%d", heroHandSoftValue]];
	}
}

- (void) showVillainHand {
	NSInteger villainHandSoftValue = [self calcVillainHandSoftValue];
	
	if ([self isBlackjack:kPartyVillain]) {
		[villainHandLabel setText:BLACKJACK];
	} else {		
		if (villainHandSoftValue > 21)
			[villainHandLabel setText:BUSTED];
		else
			[villainHandLabel setText:[NSString stringWithFormat:@"%d", villainHandSoftValue]];
	}
}

- (void) showFirstHand:(UILabel*)label value:(NSInteger)handValue {
	if (handValue > 21)
		[label setText:BUSTED];
	else
		[label setText:[NSString stringWithFormat:@"%d", handValue]];
}

- (void) showResult {
	if ([dealerHandLabel.text isEqualToString:BLACKJACK]) {
		// dealer has blackjack
		if ([heroHandLabel.text isEqualToString:BLACKJACK]) {
			[resultLabel setText:PUSH];
		} else {
			// hero doesn't have blackjack
			[resultLabel setText:DEALER_BLACKJACK];
		}
	} else {
		// dealer doesn't have blackjack
		if ([dealerHandLabel.text isEqualToString:BUSTED]) {
			// dealer busted
			[resultLabel setText:DEALER_BUSTED];
		} else if ([heroHandLabel.text isEqualToString:BUSTED]) {
			// hero busted
			[resultLabel setText:HERO_BUSTED];
		} else {
			// neither dealer nor hero busted
			NSInteger dealerHandSoftValue = [self calcDealerHandSoftValue];
			NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
			
			if (dealerHandSoftValue > heroHandSoftValue) {
				[resultLabel setText:DEALER_WON];
			} else if (dealerHandSoftValue < heroHandSoftValue) {
				[resultLabel setText:HERO_WON];
			} else { // dealerHandSoftValue == heroHandSoftValue
				[resultLabel setText:PUSH];
			}
		}
	}
}

- (void) herosTurnToBet {
	[self resetButtons];
	[self setEnabledBettingSystem:YES];
}

- (void) herosTurnToAct {
	if ([heroHandLabel.text isEqualToString:BLACKJACK]) {
		[self heroStands];
	} else {
		[AppController changeTitleOfButton:dealStandButton to:STAND_BUTTON_TITLE];
		[AppController changeImageOfButton:dealStandButton to:STAND_BUTTON_IMAGE];
		[dealStandButton setHidden:NO];
		[hitButton setHidden:NO];
		[doubleButton setHidden:[self heroStack] < currentHeroBet];
		
		if ([heroCard0View.card getBlackjackValue] ==
			[heroCard1View.card getBlackjackValue])
			[splitButton setHidden:[self heroStack] < currentHeroBet];
	}
}	

- (void) dealSixthCardTimerMethod {
	holeCardsDealingTimer = nil;
	
	[self playDealingCardsSound];
	dealerCard1View.card = [deck dealOneCard];
	
	[self stopWaitIndicator];
	
	// update points
	dealerCardsNum = 2;
	heroCardsNum = 2;
	villainCardsNum = 2;
	
	isDealerHandSoft = [self isSoft:kPartyDealer];
	isHeroHandSoft = [self isSoft:kPartyHero];
	isHeroFirstHandSoft = isHeroHandSoft;
	isVillainHandSoft = [self isSoft:kPartyVillain];
	isVillainFirstHandSoft = isVillainHandSoft;
	
	dealerHandValue = [self calcTotalValue:kPartyDealer];
	heroHandValue = [self calcTotalValue:kPartyHero];
	heroFirstHandValue = heroHandValue;
	villainHandValue = [self calcTotalValue:kPartyVillain];
	villainFirstHandValue = villainHandValue;
	
	// cards have been dealt
	//SET_BOOLEAN_FLAG(applicationData[2], 5, 1);
	gameState = kHUBJStateFirstBasesTurnToAct;
	[self saveToApplicationData];
	
	[self showHeroHand];
	[self showVillainHand];
	
	if ([self isBlackjack:kPartyHero]) {
		if ([self isBlackjack:kPartyDealer]) {
			// dealer got blackjack as well. this hand is over.
			[self showDealersSecondCard];
			
			[self showDealerHand];
						
			// hero gets his bet back
			[self processResults];
		} else {
			// dealer didn't get blackjack. check if villain has blackjack
			if ([self isBlackjack:kPartyVillain]) {
				// villain has blackjack. this hand is over.
				[self showDealersSecondCard];
				
				[self showDealerHand];
								
				// hero gets his bet back + 1.5 his bet
				[self processResults];
			} else {
				// villain doesn't have blackjack. villain and dealer will
				// play out this hand.
				// it's villain's turn
				[AppController changeTitleOfButton:dealStandButton to:STAND_BUTTON_TITLE];
				[AppController changeImageOfButton:dealStandButton to:STAND_BUTTON_IMAGE];
				
				[villain secondToAct];
			}
		}		
	} else 	if ([self isBlackjack:kPartyVillain]) {
		if ([self isBlackjack:kPartyDealer]) {
			// dealer got blackjack as well. this hand is over.
			[self showDealersSecondCard];
			
			[self showDealerHand];
			
			// hero gets his bet back
			[self processResults];
		} else {
			// dealer didn't get blackjack. hero didn't get blackjack. they
			// need to play out this hand. it's hero's turn to act.
			[self herosTurnToAct];
		}				
	} else {
		
		// hero/villain didn't get blackjack
		if ([self isBlackjack:kPartyDealer]) {
			// dealer got blackjack. dealer won.
			[self showDealersSecondCard];
			
			[self showDealerHand];
						
			// hero/villain stacks unchanged.
			[self processResults];
			
			// no need to change the buttons.
		} else {
			// dealer didn't get blackjack. it's FB's turn to play.
			
			if ([self isHeroFirstBase]) {
				// set buttons
				[self herosTurnToAct];
			} else {
				[villain firstToAct];
			}
		}
	}	
}

- (void) dealNewHand {
	[self startWaitIndicator:STATUS_DEALING];
	
	gameState = kHUBJStateCardsToBeDealt;
	[self saveToApplicationData];
	
	applicationData[0] = (uint8_t)1;
		
	[deck shuffleUpAndDeal:kHandBlackjack];
	// save cards just dealt in application data
	NSInteger cardsCount = [deck getNumOfCards];
	for (int i=0; i < cardsCount; i++) {
		Card *card = [deck getCardAtIndex:i];
		applicationData[45+i] = (uint8_t)((card.rank << 2) | card.suit);
	}	
	
	[self dealFirstCard];
}

- (IBAction) endButtonPressed:(id)sender {
	UIAlertView* alertView = 
	[[UIAlertView alloc] initWithTitle:@"Reset the game?" 
							   message:nil
							  delegate:self
					 cancelButtonTitle:@"Yes" 
					 otherButtonTitles:@"No", nil];	
	[alertView show];
	[alertView release];	
}

- (IBAction) lobbyButtonPressed:(id)sender {
	[self killAllActiveTimers];
	
	[self saveToApplicationData];
	[appController writeBlackjackHeadsupModeApplicationData:[self getApplicationData]];
	
	[navController popViewControllerAnimated:YES];
}

- (IBAction) noBetButtonPressed:(id)sender {
	[self updateNumberLabel:heroStackLabel addAmount:currentHeroBet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:currentHeroBet];
	
	[self setCurrentHeroBet:0];
		
	[self saveToApplicationData];
}

- (void) addBet:(NSInteger) additionalBet {	
	[self setCurrentHeroBet:(currentHeroBet + additionalBet)];
	
	[self updateNumberLabel:heroStackLabel addAmount:-additionalBet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:-additionalBet];	
}

- (IBAction) minBetButtonPressed:(id)sender {
	if ([self heroStack] >= MIN_BET)
		[self addBet:MIN_BET];
}

- (IBAction) midBetButtonPressed:(id)sender {
	if ([self heroStack] >= MID_BET)
		[self addBet:MID_BET];
}

- (IBAction) bigBetButtonPressed:(id)sender {
	if ([self heroStack] >= BIG_BET)
		[self addBet:BIG_BET];
}

- (IBAction) maxBetButtonPressed:(id)sender {
	
	[self addBet:[self maxAmountAllowed] - [self userAmount]];
}

- (IBAction) showHint:(id)sender {		
	// dealer index (column index) 0-9 on the strategy card
	NSInteger dealerIndex = 0;	
	if (dealerCard0View.card.rank == kRankAce)
		dealerIndex = 9;
	else
		dealerIndex = [dealerCard0View.card getBlackjackValue] - 2;
	
	// hero index (row index) 0-24 on the strategy card
	NSInteger heroIndex = 0;
	
	if (heroCardsNum == 2 && 
		[heroCard0View.card getBlackjackValue] == [heroCard1View.card getBlackjackValue]) {
		// splitting hands
		if (heroHandValue == 2) // AA
			heroIndex = 15;
		else
			heroIndex = 26 - heroHandValue / 2;
	} else if ([self calcHeroHandSoftValue] - heroHandValue == 10) {
		// soft hands
		if (heroHandValue == 10)
			heroIndex = 9;
		else if (heroHandValue == 9)
			heroIndex = 10;
		else if (heroHandValue == 8)
			heroIndex = 11;
		else if (heroHandValue == 7)
			heroIndex = 12;
		else if (heroHandValue == 6 || heroHandValue == 5)
			heroIndex = 13;
		else // 4 || 3
			heroIndex = 14;
	} else {
		// hard non-splitting hands
		if (heroHandValue <= 7)
			heroIndex = 0;
		else if (heroHandValue == 8)
			heroIndex = 1;
		else if (heroHandValue == 9)
			heroIndex = 2;
		else if (heroHandValue == 10)
			heroIndex = 3;
		else if (heroHandValue == 11)
			heroIndex = 4;
		else if (heroHandValue == 12)
			heroIndex = 5;
		else if (heroHandValue == 13 || heroHandValue == 14 || heroHandValue == 15)
			heroIndex = 6;
		else if (heroHandValue == 16)
			heroIndex = 7;
		else // >= 17
			heroIndex = 8;
	}
	
	// look up hint on the strategy card based on dealer index and hero index
	[hintLabel setText:(NSString*)[strategyCard objectAtIndex:heroIndex * 10 + dealerIndex]];
}

- (IBAction) hideHint:(id)sender {
	[hintLabel setText:@""];
}

- (IBAction) surrenderButtonPressed:(id)sender {
}

- (void)animationWillStart:(NSString *)animationID 
				   context:(void *)context {
}

- (void) restoreAnimatedCardView {
	animationToCardView.card = animationFromCardView.card;
	[animationFromCardView setHidden:YES];
	animationFromCardView.card = nil;
	[animationFromCardView setCenter:animationOldCenter];
	[animationFromCardView setHidden:NO];		
}	

- (void) slideCard:(CardView*)fromView 
				to:(CardView*)toView 
	   animationId:(NSString*)animationId
		  duration:(NSTimeInterval)duration
{	
	animationFromCardView = fromView;
	animationToCardView = toView;
	
	[UIView beginAnimations:animationId context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDuration:duration];
	
	animationOldCenter = fromView.center;
	[fromView setCenter:toView.center];
	[UIView commitAnimations];	
	
	if (duration == CARD_SLIDING_LONG_DURATION) {
		[self playSlidingSound];
	} else {
		[self playFoldSound];
	}
}

- (void) dealSecondHeroHand {
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];
	
	// check if hero has doubled down on the first hand
	if (isHeroFirstHandDoubleDown) {
		currentHeroBet /= 2;
	}
		
	[heroFirstBetLabel setText:heroBetLabel.text];
	[heroFirstHandLabel setText:heroHandLabel.text];
	[heroBetLabel setText:[NSString stringWithFormat:@"%d", currentHeroBet]];
	[heroHandLabel setText:@""];
	
	// slide the last hero card to second to last card
	NSInteger cardsViewNum = heroCardsNum >= MAX_CARD_NUM ? MAX_CARD_NUM : heroCardsNum;
	
	CardView* heroLastCardInFirstHand = 
	(CardView*)[heroCardViews objectAtIndex:cardsViewNum-1];
	
	CardView* heroSecondToLastCardInFirstHand = 
	(CardView*)[heroCardViews objectAtIndex:cardsViewNum-2];	
	
	animationHeroCardViewIndex = cardsViewNum - 2;
	
	[self slideCard:heroLastCardInFirstHand 
				 to:heroSecondToLastCardInFirstHand 
		animationId:ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (void) dealSecondVillainHand {
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];
	
	// check if villain has doubled down on the first hand
	if (isVillainFirstHandDoubleDown) {
		currentVillainBet /= 2;
	}
		
	[villainFirstBetLabel setText:villainBetLabel.text];
	[villainFirstHandLabel setText:villainHandLabel.text];
	[villainBetLabel setText:[NSString stringWithFormat:@"%d", currentVillainBet]];
	[villainHandLabel setText:@""];
	
	// slide the last villain card to second to last card
	NSInteger cardsViewNum = villainCardsNum >= MAX_CARD_NUM ? MAX_CARD_NUM : villainCardsNum;
	
	CardView* villainLastCardInFirstHand = 
	(CardView*)[villainCardViews objectAtIndex:cardsViewNum-1];
	
	CardView* villainSecondToLastCardInFirstHand = 
	(CardView*)[villainCardViews objectAtIndex:cardsViewNum-2];	
	
	animationVillainCardViewIndex = cardsViewNum - 2;
	
	[self slideCard:villainLastCardInFirstHand 
				 to:villainSecondToLastCardInFirstHand 
		animationId:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (BOOL) didHeroAndVillainBothBustOrGetDealtBlackjack {
	BOOL retval = YES;
	
	NSMutableArray* arrLabels = 
		[[NSArray arrayWithObjects:heroHandLabel, heroFirstHandLabel, 
		  villainHandLabel, villainFirstHandLabel,
		  nil] retain];
	
	for (UILabel* label in arrLabels) {
		NSString* text = label.text;
		
		if (![text isEqualToString:@""] &&
			![text isEqualToString:BUSTED] &&
			![text isEqualToString:BLACKJACK]) {
			retval = NO;
			break;
		}
	}
	
	[arrLabels release];

	return retval;
}
		  
// this method is called when hero's done acting on the current hand, 
// not necessarily when the "stand" button is pressed.
- (void) heroStands {
	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];
	
	if (heroLastCardView.card == nil) {
		if ([self isHeroFirstBase]) {
			gameState = kHUBJStateSecondBasesTurnToAct;
			[self saveToApplicationData];
			[villain secondToAct];
		} else {
			// display results
			[self showDealersSecondCard];
			
			// show dealer's hand
			[self showDealerHand];
			
			if (([self calcDealerHandSoftValue] >= 17) || 
				[self didHeroAndVillainBothBustOrGetDealtBlackjack]) {
				[self processResults];
			} else {
				dealerCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALER_DEALING_DELAY target:self selector:@selector(dealNextDealerCardTimerMethod) userInfo:nil repeats:NO];
			}
		}
	} else {
		// this is the first hand of two hands		
		[self dealSecondHeroHand];
	}
}	

- (void) setSecondBasesTurnToTrue {
	//SET_BOOLEAN_FLAG(applicationData[1], 7, YES);
	gameState = kHUBJStateSecondBasesTurnToAct;
	[self saveToApplicationData];
}

// called when villain's hand is over. so it's either hero's or dealer's
// turn to act.
- (void) villainStands {	
	if (villainLastCardView.card == nil) {
		if (![self isHeroFirstBase]) {
			gameState = kHUBJStateSecondBasesTurnToAct;
			[self saveToApplicationData];
			
			[self herosTurnToAct];
		} else {
			// display results
			[self showDealersSecondCard];
			
			// show dealer's hand
			[self showDealerHand];
			
			if (([self calcDealerHandSoftValue] >= 17) || 
				[self didHeroAndVillainBothBustOrGetDealtBlackjack]) {
				[self processResults];
			} else {
				dealerCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALER_DEALING_DELAY target:self selector:@selector(dealNextDealerCardTimerMethod) userInfo:nil repeats:NO];
			}
		}
	} else {
		// this is the first hand of two hands		
		[self dealSecondVillainHand];
	}
}	

- (void)animationDidStop:(NSString *)animationID 
				finished:(NSNumber *)finished
				 context:(void *)context {
	
	[self restoreAnimatedCardView];

	if ([animationID isEqualToString:ANIMATION_HERO_SPLIT]) {
		[self postHeroSplitAnimation];
	} else if ([animationID isEqualToString:ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD]) {
		[self postHeroMiddleToLeftOneCardAnimation];
	} else if ([animationID isEqualToString:ANIMATION_HERO_MIDDLE_TO_LEFT]) {
		[self postHeroMiddleToLeftAnimation];
	} else if ([animationID isEqualToString:ANIMATION_HERO_RIGHT_TO_MIDDLE]) {
		[self postHeroRightToMiddleAnimation];
	} else if ([animationID isEqualToString:ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD_ACE]) {
		[self postHeroMiddleToLeftOneCardAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_HERO_MIDDLE_TO_LEFT_ACE]) {
		[self postHeroMiddleToLeftAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_HERO_RIGHT_TO_MIDDLE_ACE]) {
		[self postHeroRightToMiddleAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_SPLIT]) {
		[self postVillainSplitAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD]) {
		[self postVillainMiddleToLeftOneCardAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_MIDDLE_TO_LEFT]) {
		[self postVillainMiddleToLeftAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_RIGHT_TO_MIDDLE]) {
		[self postVillainRightToMiddleAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD_ACE]) {
		[self postVillainMiddleToLeftOneCardAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ACE]) {
		[self postVillainMiddleToLeftAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_VILLAIN_RIGHT_TO_MIDDLE_ACE]) {
		[self postVillainRightToMiddleAceAnimation];
	}	
}

- (void) postHeroMiddleToLeftOneCardAnimation {
	[self saveToApplicationData];
	
	if (animationHeroCardViewIndex == 0) {
		// move first hand to the left
		[self slideCard:heroCard0View 
					 to:heroFirstCardView 
			animationId:ANIMATION_HERO_MIDDLE_TO_LEFT
			   duration:CARD_SLIDING_LONG_DURATION];
	} else {
		--animationHeroCardViewIndex;
		// keep shifting card to the next spot on the left side
		[self slideCard:(CardView*)[heroCardViews objectAtIndex:animationHeroCardViewIndex+1]
					 to:(CardView*)[heroCardViews objectAtIndex:animationHeroCardViewIndex]
			animationId:ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD
			   duration:CARD_SLIDING_SHORT_DURATION];		
	}
}

- (void) postHeroMiddleToLeftAnimation {
	[self saveToApplicationData];
	
	// move second hand to the middle
	[self slideCard:heroLastCardView 
				 to:heroCard0View 
		animationId:ANIMATION_HERO_RIGHT_TO_MIDDLE
		   duration:CARD_SLIDING_LONG_DURATION];		
}

- (void) postHeroRightToMiddleAnimation {	
	[heroActionLabel setText:@""];

	// reset heroCardsNum
	heroOtherCardsNum = heroCardsNum;
	heroCardsNum = 2;
	
	// deal one more card to hero's second hand
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	isHeroSecondHandSoft = [self isSoft:kPartyHero];
	heroSecondHandValue = [self calcTotalValue:kPartyHero];
	isHeroHandSoft = isHeroSecondHandSoft;
	heroHandValue = heroSecondHandValue;
	
	[self saveToApplicationData];
	
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	if (heroHandSoftValue == 21) {
		[heroHandLabel setText:@"21"];
				
		[self heroStands];
	} else {
		[heroHandLabel setText:[NSString stringWithFormat:@"%d", heroHandSoftValue]];
		
		[self saveToApplicationData];
		
		[doubleButton setHidden:([self heroStack] < currentHeroBet)];
		[hitButton setHidden:NO];
		[dealStandButton setHidden:NO];		
	}
}

- (void) postVillainMiddleToLeftOneCardAnimation {
	[self saveToApplicationData];
	
	if (animationVillainCardViewIndex == 0) {
		// move first hand to the left
		[self slideCard:villainCard0View 
					 to:villainFirstCardView 
			animationId:ANIMATION_VILLAIN_MIDDLE_TO_LEFT
			   duration:CARD_SLIDING_LONG_DURATION];
	} else {
		--animationVillainCardViewIndex;
		// keep shifting card to the next spot on the left side
		[self slideCard:(CardView*)[villainCardViews objectAtIndex:animationVillainCardViewIndex+1]
					 to:(CardView*)[villainCardViews objectAtIndex:animationVillainCardViewIndex]
			animationId:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD
			   duration:CARD_SLIDING_SHORT_DURATION];		
	}
}

- (void) postVillainMiddleToLeftAnimation {
	[self saveToApplicationData];
	
	// move second hand to the middle
	[self slideCard:villainLastCardView 
				 to:villainCard0View 
		animationId:ANIMATION_VILLAIN_RIGHT_TO_MIDDLE
		   duration:CARD_SLIDING_LONG_DURATION];		
}

- (void) postVillainRightToMiddleAnimation {	
	[villainActionLabel setText:@""];

	// reset villainCardsNum
	villainOtherCardsNum = villainCardsNum;
	villainCardsNum = 2;
	
	// deal one more card to villain's second hand
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];
	
	isVillainSecondHandSoft = [self isSoft:kPartyVillain];
	villainSecondHandValue = [self calcTotalValue:kPartyVillain];
	isVillainHandSoft = isVillainSecondHandSoft;
	villainHandValue = villainSecondHandValue;
	
	[self saveToApplicationData];
	
	NSInteger villainHandSoftValue = [self calcVillainHandSoftValue];
	if (villainHandSoftValue == 21) {
		[villainHandLabel setText:@"21"];
		
		[self villainStands];
	} else {
		[villainHandLabel setText:[NSString stringWithFormat:@"%d", villainHandSoftValue]];
		
		[self saveToApplicationData];
		
		//villain's turn
		if ([self isHeroFirstBase] ||
			[heroHandLabel.text isEqualToString:BLACKJACK]) {
			[villain secondToAct];
		} else {
			[villain firstToAct];
		}
	}
}

- (void) dealNextDealerCardTimerMethod {
	dealerCardsDealingTimer = nil;

	// deal one more card to dealer
	NSInteger dealerNextCardViewIndex = 
		dealerCardsNum >= MAX_CARD_NUM ? MAX_CARD_NUM - 1 : dealerCardsNum;
	CardView *dealerNextCardView = 
		(CardView*)[dealerCardViews objectAtIndex:dealerNextCardViewIndex];
	
	[self playDealingCardsSound];
	dealerNextCardView.card = [deck dealOneCard];
	
	isDealerHandSoft = isDealerHandSoft || (dealerNextCardView.card.rank == kRankAce);
	dealerHandValue += [dealerNextCardView.card getBlackjackValue];
	
	++dealerCardsNum;
		
	if (dealerCardsNum >= MAX_CARD_NUM) {
		[dealerCardsNumLabel setText:[NSString stringWithFormat:@"%d", dealerCardsNum]];
		[dealerCardsNumLabel setHidden:NO];
		[dealerCardsLabel setHidden:NO];
	}
	
	[self showDealerHand];
			
	if ([self calcDealerHandSoftValue] >= 17) {
		[self processResults];
	} else {
		// deal one more card to dealer
		dealerCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALER_DEALING_DELAY target:self selector:@selector(dealNextDealerCardTimerMethod) userInfo:nil repeats:NO];
	}	
}	

- (IBAction) splitButtonPressed:(id)sender {
	[heroActionLabel setText:ACTION_SPLIT];
	
	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];
	
	[heroHandLabel setText:@""];
		
	[self slideCard:heroCard1View 
				 to:heroLastCardView 
		animationId:ANIMATION_HERO_SPLIT
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (void) villainPressSplit {
	[villainActionLabel setText:ACTION_SPLIT];
	[villainHandLabel setText:@""];
	
	[self slideCard:villainCard1View 
				 to:villainLastCardView 
		animationId:ANIMATION_VILLAIN_SPLIT
		   duration:CARD_SLIDING_LONG_DURATION];	
}

- (void) postHeroMiddleToLeftOneCardAceAnimation {
	// move first hand to the left
	[self slideCard:heroCard0View 
				 to:heroFirstCardView 
		animationId:ANIMATION_HERO_MIDDLE_TO_LEFT_ACE
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (void) postHeroMiddleToLeftAceAnimation {	
	heroCard0View.card = nil;
	heroOtherCardsNum = 2;
	
	[self saveToApplicationData];
	
	// move second hand to the middle
	[self slideCard:heroLastCardView 
				 to:heroCard0View 
		animationId:ANIMATION_HERO_RIGHT_TO_MIDDLE_ACE
		   duration:CARD_SLIDING_LONG_DURATION];
}	

- (void) postHeroRightToMiddleAceAnimation {
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	heroCardsNum = 2;
	
	isHeroSecondHandSoft = YES;
	heroSecondHandValue = [self calcTotalValue:kPartyHero];
	isHeroHandSoft = YES;
	heroHandValue = heroSecondHandValue;	
	
	[self saveToApplicationData];
	
	// show second hand
	[self showHeroHand];
	
	[self heroStands];	
}

- (void) postHeroSplitAnimation {	
	[self updateNumberLabel:heroStackLabel addAmount:-currentHeroBet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:-currentHeroBet];

	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	// first hero hand
	isHeroHandSoft = [self isSoft:kPartyHero];
	heroHandValue = [self calcTotalValue:kPartyHero];
	isHeroFirstHandSoft = isHeroHandSoft;
	heroFirstHandValue = heroHandValue;	
	
	heroOtherCardsNum = 1;
	
	[self saveToApplicationData];
	
	if (heroCard0View.card.rank == kRankAce) {
		// splitting aces. no play.
		
		// show first hand
		[self showHeroHand];
		
		// 
		[heroFirstBetLabel setText:heroBetLabel.text];
		[heroFirstHandLabel setText:heroHandLabel.text];
		[heroHandLabel setText:@""];
		
		// move first hand to the left
		[self slideCard:heroCard1View 
					 to:heroCard0View 
			animationId:ANIMATION_HERO_MIDDLE_TO_LEFT_ONE_CARD_ACE
			   duration:CARD_SLIDING_LONG_DURATION];
	} else {
		// not splitting aces
		NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
		if (heroHandSoftValue == 21) {		
			[self dealSecondHeroHand];
		} else {
			[heroHandLabel setText:[NSString stringWithFormat:@"%d", heroHandSoftValue]];
			
			[self saveToApplicationData];
			
			[doubleButton setHidden:([self heroStack] < currentHeroBet)];
			[hitButton setHidden:NO];
			[dealStandButton setHidden:NO];			
		}
	}
}

- (void) postVillainMiddleToLeftOneCardAceAnimation {
	// move first hand to the left
	[self slideCard:villainCard0View 
				 to:villainFirstCardView 
		animationId:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ACE
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (void) postVillainMiddleToLeftAceAnimation {	
	villainCard0View.card = nil;
	villainOtherCardsNum = 2;
	
	[self saveToApplicationData];
	
	// move second hand to the middle
	[self slideCard:villainLastCardView 
				 to:villainCard0View 
		animationId:ANIMATION_VILLAIN_RIGHT_TO_MIDDLE_ACE
		   duration:CARD_SLIDING_LONG_DURATION];
}	

- (void) postVillainRightToMiddleAceAnimation {
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];
	villainCardsNum = 2;
	
	isVillainSecondHandSoft = YES;
	villainSecondHandValue = [self calcTotalValue:kPartyVillain];
	isVillainHandSoft = YES;
	villainHandValue = villainSecondHandValue;	
	
	[self saveToApplicationData];
	
	// show second hand
	[self showVillainHand];
	
	[self villainStands];	
}

- (void) postVillainSplitAnimation {	
	[self updateNumberLabel:villainStackLabel addAmount:-currentVillainBet];
	
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];
	
	// first villain hand
	isVillainHandSoft = [self isSoft:kPartyVillain];
	villainHandValue = [self calcTotalValue:kPartyVillain];
	isVillainFirstHandSoft = isVillainHandSoft;
	villainFirstHandValue = villainHandValue;	
	
	villainOtherCardsNum = 1;
	
	[self saveToApplicationData];
	
	if (villainCard0View.card.rank == kRankAce) {
		// splitting aces. no play.
		
		// show first hand
		[self showVillainHand];
		
		// 
		[villainFirstBetLabel setText:villainBetLabel.text];
		[villainFirstHandLabel setText:villainHandLabel.text];
		[villainHandLabel setText:@""];
		
		// move first hand to the left
		[self slideCard:villainCard1View 
					 to:villainCard0View 
			animationId:ANIMATION_VILLAIN_MIDDLE_TO_LEFT_ONE_CARD_ACE
			   duration:CARD_SLIDING_LONG_DURATION];
	} else {
		// not splitting aces
		NSInteger villainHandSoftValue = [self calcVillainHandSoftValue];
		if (villainHandSoftValue == 21) {		
			[self dealSecondVillainHand];
		} else {
			[self showVillainHand];
			
			[self saveToApplicationData];
			
			//villain's turn
			if ([self isHeroFirstBase] ||
				[heroHandLabel.text isEqualToString:BLACKJACK]) {
				[villain secondToAct];
			} else {
				[villain firstToAct];
			}
		}
	}
}

- (IBAction) doubleButtonPressed:(id)sender {
	[heroActionLabel setText:ACTION_DOUBLE];
	
	[self updateNumberLabel:heroStackLabel addAmount:-currentHeroBet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:-currentHeroBet];
	[self updateNumberLabel:heroBetLabel addAmount:currentHeroBet];
	[self setCurrentHeroBet:(currentHeroBet * 2)];
	
	if (heroFirstCardView.card == nil)
		isHeroFirstHandDoubleDown = YES;
	else 
		isHeroSecondHandDoubleDown = YES;
			
	[self playDealingCardsSound];
	heroCard2View.card = [deck dealOneCard];
	++heroCardsNum;
	
	isHeroHandSoft = [self isSoft:kPartyHero];
	heroHandValue = [self calcTotalValue:kPartyHero];
	
	if (heroSecondHandValue == 0) {
		// this is the first hand
		isHeroFirstHandSoft = isHeroHandSoft;
		heroFirstHandValue = heroHandValue;
	} else {
		// this is the second hand
		isHeroSecondHandSoft = isHeroHandSoft;
		heroSecondHandValue = heroHandValue;		
	}
				
	[self showHeroHand];
	
	[self saveToApplicationData];
	
	if (heroLastCardView.card == nil) {
		[self heroStands];
	} else {
		// this hand is the first hand of two hands
		[self dealSecondHeroHand];			
	}
}

- (void) villainPressDouble {
	[villainActionLabel setText:ACTION_DOUBLE];
	
	[self updateNumberLabel:villainStackLabel addAmount:-currentVillainBet];
	[self updateNumberLabel:villainBetLabel addAmount:currentVillainBet];
	currentVillainBet *= 2;
	
	if (villainFirstCardView.card == nil)
		isVillainFirstHandDoubleDown = YES;
	else 
		isVillainSecondHandDoubleDown = YES;
	
	[self playDealingCardsSound];
	villainCard2View.card = [deck dealOneCard];
	++villainCardsNum;
	
	isVillainHandSoft = [self isSoft:kPartyVillain];
	villainHandValue = [self calcTotalValue:kPartyVillain];
	
	if (villainSecondHandValue == 0) {
		// this is the first hand
		isVillainFirstHandSoft = isVillainHandSoft;
		villainFirstHandValue = villainHandValue;
	} else {
		// this is the second hand
		isVillainSecondHandSoft = isVillainHandSoft;
		villainSecondHandValue = villainHandValue;		
	}
	
	[self showVillainHand];
	
	[self saveToApplicationData];
	
	if (villainLastCardView.card == nil) {
		[self villainStands];
	} else {
		// this hand is the first hand of two hands
		[self dealSecondVillainHand];			
	}
}

- (IBAction) hitButtonPressed:(id)sender {
	[heroActionLabel setText:ACTION_HIT];
	
	// hide split button and double button
	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	
	NSInteger heroNextCardViewIndex = 
	heroCardsNum >= MAX_CARD_NUM ? MAX_CARD_NUM - 1 : heroCardsNum;
	CardView *heroNextCardView = 
	(CardView*)[heroCardViews objectAtIndex:heroNextCardViewIndex];
	
	[self playDealingCardsSound];
	heroNextCardView.card = [deck dealOneCard];
	
	isHeroHandSoft = isHeroHandSoft || (heroNextCardView.card.rank == kRankAce);
	heroHandValue += [heroNextCardView.card getBlackjackValue];
	
	if (heroSecondHandValue == 0) {
		isHeroFirstHandSoft = isHeroHandSoft;
		heroFirstHandValue = heroHandValue;
	} else {
		isHeroSecondHandSoft = isHeroHandSoft;
		heroSecondHandValue = heroHandValue;
	}
	
	++heroCardsNum;
	
	[self saveToApplicationData];
	
	if (heroCardsNum >= MAX_CARD_NUM) {
		[heroCardsNumLabel setText:[NSString stringWithFormat:@"%d", heroCardsNum]];
		[heroCardsNumLabel setHidden:NO];
		[heroCardsLabel setHidden:NO];
	}	
	
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	
	[self showHeroHand];
	
	[self saveToApplicationData];
	
	if (heroHandSoftValue > 21) {
		// hero busted		
		if (heroLastCardView.card == nil) {
			[self heroStands];
		} else {
			// this busted hand is the first hand of two hands
			[self dealSecondHeroHand];			
		}
	} else if (heroHandSoftValue == 21) {
		if (heroLastCardView.card == nil) {
			[self heroStands];
		} else {
			// this 21 hand is the first hand of two hands			
			[self dealSecondHeroHand];
		}
	} else {
		// hero's hand <= 20. it's still his turn to act on this hand.
		// nothing to do
	}	
}

- (void) villainPressHit {
	[villainActionLabel setText:ACTION_HIT];
	
	NSInteger villainNextCardViewIndex = 
	villainCardsNum >= MAX_CARD_NUM ? MAX_CARD_NUM - 1 : villainCardsNum;
	CardView *villainNextCardView = 
	(CardView*)[villainCardViews objectAtIndex:villainNextCardViewIndex];
	
	[self playDealingCardsSound];
	villainNextCardView.card = [deck dealOneCard];
	
	isVillainHandSoft = isVillainHandSoft || (villainNextCardView.card.rank == kRankAce);
	villainHandValue += [villainNextCardView.card getBlackjackValue];
	
	if (villainSecondHandValue == 0) {
		isVillainFirstHandSoft = isVillainHandSoft;
		villainFirstHandValue = villainHandValue;
	} else {
		isVillainSecondHandSoft = isVillainHandSoft;
		villainSecondHandValue = villainHandValue;
	}
	
	++villainCardsNum;
	
	[self saveToApplicationData];
	
	/*
	if (heroCardsNum >= MAX_CARD_NUM) {
		[heroCardsNumLabel setText:[NSString stringWithFormat:@"%d", heroCardsNum]];
		[heroCardsNumLabel setHidden:NO];
		[heroCardsLabel setHidden:NO];
	}*/	
	
	NSInteger villainHandSoftValue = [self calcVillainHandSoftValue];
	
	[self showVillainHand];
	
	[self saveToApplicationData];
	
	if (villainHandSoftValue > 21) {
		// villain busted		
		if (villainLastCardView.card == nil) {
			[self villainStands];
		} else {
			// this busted hand is the first hand of two hands
			[self dealSecondVillainHand];			
		}
	} else if (villainHandSoftValue == 21) {
		if (villainLastCardView.card == nil) {
			[self villainStands];
		} else {
			// this 21 hand is the first hand of two hands			
			[self dealSecondVillainHand];
		}
	} else {
		// villain's hand <= 20. it's still his turn to act on this hand.
		// nothing to do
		if ([self isHeroFirstBase] ||
			[heroHandLabel.text isEqualToString:BLACKJACK]) {
			[villain secondToAct];
		} else {
			[villain firstToAct];
		}
	}	
}

- (void) postHeroBet {
	[heroBetLabel setText:[NSString stringWithFormat:@"%d", [self userAmount]]];
		
	[dealStandButton setHidden:YES];
	[self setEnabledBettingSystem:NO];
	
	// villain's turn to bet if hero is FB;
	// otherwise, deal new hand
	if ([self isHeroFirstBase]) {
		// villain's turn to bet
		gameState = kHUBJStateSecondBasesTurnToBet;
		[self saveToApplicationData];
		
		[villain secondToBet];
	} else {		
		[self dealNewHand];
	}
}	

- (IBAction) dealStandButtonPressed:(id)sender {
	NSString *dealStandButtonTitle = [dealStandButton titleForState:UIControlStateNormal];
	
	if ([dealStandButtonTitle isEqualToString:DEAL_BUTTON_TITLE]) {
		if ([self userAmount] >= MIN_BET)
			[self postHeroBet];
	} else {
		// stand
		// dealer has soft 17 or up: stand; otherwise hit him until
		// he either gets soft 17 or up or busts.
		[heroActionLabel setText:ACTION_STAND];
		[self heroStands];		
	}
}

- (void) villainPressStand {
	[villainActionLabel setText:ACTION_STAND];
	
	[self villainStands];
}

- (NSInteger) getMinBet {
	return MIN_BET;
}

- (void) villainBet:(NSInteger)amount {	
	[self updateNumberLabel:villainStackLabel addAmount:-amount];
	
	[self setCurrentVillainBet:amount];
		
	if ([self isHeroFirstBase]) {
		[self dealNewHand];
	} else {
		gameState = kHUBJStateSecondBasesTurnToBet;
		[self saveToApplicationData];
		
		[self herosTurnToBet];
	}
}

- (IBAction) dealButtonForKeyboardPressed:(id)sender {
	// dismiss the keyboard
	[amountTextField resignFirstResponder];

	[self postHeroBet];
}

- (IBAction) amountValueChanged:(id)sender {
	NSInteger amount = [self userAmount];
		
	BOOL amountNeedsToChange = NO;
	if (amount > [self maxAmountAllowed]) {
		amount = [self maxAmountAllowed];
		amountNeedsToChange = YES;
	}
	
	NSInteger diff = currentHeroBet - amount;
	[self updateNumberLabel:heroStackLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:diff];	
	
	currentHeroBet = amount;
	[heroBetLabel setText:[NSString stringWithFormat:@"%d", currentHeroBet]];
	
	if (amountNeedsToChange)
		[amountTextField setText:[NSString stringWithFormat:@"%d", currentHeroBet]];
}

- (void) saveToApplicationData {
	// double down flags
	SET_BOOLEAN_FLAG(applicationData[1], 2, isHeroFirstHandDoubleDown);
	SET_BOOLEAN_FLAG(applicationData[1], 3, isHeroSecondHandDoubleDown);
	SET_BOOLEAN_FLAG(applicationData[1], 4, isDealerHandSoft);
	SET_BOOLEAN_FLAG(applicationData[1], 5, isHeroFirstHandSoft);
	SET_BOOLEAN_FLAG(applicationData[1], 6, isHeroSecondHandSoft);
	
	SET_BOOLEAN_FLAG(applicationData[2], 0, [self isHeroFirstBase]);	
	SET_BOOLEAN_FLAG(applicationData[2], 1, isVillainFirstHandDoubleDown);
	SET_BOOLEAN_FLAG(applicationData[2], 2, isVillainSecondHandDoubleDown);
	SET_BOOLEAN_FLAG(applicationData[2], 3, isVillainFirstHandSoft);
	SET_BOOLEAN_FLAG(applicationData[2], 4, isVillainSecondHandSoft);
	
	// the 4th byte is unused
	// hand count
	[AppController write2ByteInteger:handCount To:applicationData+4];
	
	// hero stack (balance - bet amount)
	[AppController write4ByteInteger:[self heroStack] To:applicationData+6];
	// hero bet amount
	[AppController write4ByteInteger:currentHeroBet To:applicationData+10];
	// villain stack (balance - bet amount)
	[AppController write4ByteInteger:[self villainStack] To:applicationData+14];
	// villain bet amount
	[AppController write4ByteInteger:currentVillainBet To:applicationData+18];
	
	// dealer's number of cards
	[AppController write2ByteInteger:dealerCardsNum To:applicationData+22];
	
	// hero's number of cards (hand in play)
	[AppController write2ByteInteger:heroCardsNum To:applicationData+24];		
	// hero's number of cards (hand not in play)
	[AppController write2ByteInteger:heroOtherCardsNum To:applicationData+26];
	// villain's number of cards (hand in play)
	[AppController write2ByteInteger:villainCardsNum To:applicationData+28];		
	// villain's number of cards (hand not in play)
	[AppController write2ByteInteger:villainOtherCardsNum To:applicationData+30];
	
	// dealer hand hard value
	[AppController write2ByteInteger:dealerHandValue To:applicationData+32];
	
	// hero first hand hard value
	[AppController write2ByteInteger:heroFirstHandValue To:applicationData+34];
	// hero second hand hard value
	[AppController write2ByteInteger:heroSecondHandValue To:applicationData+36];		
	// villain first hand hard value
	[AppController write2ByteInteger:villainFirstHandValue To:applicationData+38];
	// villain second hand hard value
	[AppController write2ByteInteger:villainSecondHandValue To:applicationData+40];	
	
	// state
	applicationData[42] = (uint8_t)gameState;
	applicationData[43] = [self action2byte:heroActionLabel.text];
	applicationData[44] = [self action2byte:villainActionLabel.text];
}	

- (void) setupInitialScreen {
	[dealerCardViews removeAllObjects];
	[dealerCardViews addObject:dealerCard0View];
	[dealerCardViews addObject:dealerCard1View];
	[dealerCardViews addObject:dealerCard2View];
	[dealerCardViews addObject:dealerCard3View];
	[dealerCardViews addObject:dealerCard4View];
	
	[heroCardViews removeAllObjects];
	[heroCardViews addObject:heroCard0View];
	[heroCardViews addObject:heroCard1View];
	[heroCardViews addObject:heroCard2View];
	[heroCardViews addObject:heroCard3View];
	[heroCardViews addObject:heroCard4View];
	
	[villainCardViews removeAllObjects];
	[villainCardViews addObject:villainCard0View];
	[villainCardViews addObject:villainCard1View];
	[villainCardViews addObject:villainCard2View];
	[villainCardViews addObject:villainCard3View];
	[villainCardViews addObject:villainCard4View];	
	
	handCount = 1;
	[handCountLabel setText:[NSString stringWithFormat:@"%d", handCount]];
	
	[heroActionLabel setText:@""];
	[villainActionLabel setText:@""];

	[heroResultLabel setText:@""];
	[villainResultLabel setText:@""];

	[heroBetLabel setText:@""];
	[heroFirstBetLabel setText:@""];
	[villainBetLabel setText:@""];
	[villainFirstBetLabel setText:@""];
	
	dealerCard0View.faceUp = YES;
	dealerCard1View.faceUp = NO;
	dealerCard2View.faceUp = YES;
	dealerCard3View.faceUp = YES;
	dealerCard4View.faceUp = YES;
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	heroCard4View.faceUp = YES;
	heroFirstCardView.faceUp = YES;
	heroLastCardView.faceUp = YES;
	
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	villainCard2View.faceUp = YES;
	villainCard3View.faceUp = YES;
	villainCard4View.faceUp = YES;
	villainFirstCardView.faceUp = YES;
	villainLastCardView.faceUp = YES;	
	
	dealerCard0View.card = nil;
	dealerCard1View.card = nil;
	dealerCard2View.card = nil;
	dealerCard3View.card = nil;
	dealerCard4View.card = nil;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	heroFirstCardView.card = nil;
	heroLastCardView.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
	villainFirstCardView.card = nil;
	villainLastCardView.card = nil;	
	
	// reset buttons
	[endButton setHidden:NO];
	[hintButton setHidden:YES];
	[hintLabel setText:@""];
	[surrenderButton setHidden:YES];
	
	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];	
	
	// reset labels
	[dealerHandLabel setText:@""];
	[heroHandLabel setText:@""];
	[heroFirstHandLabel setText:@""];
	[villainHandLabel setText:@""];
	[villainFirstHandLabel setText:@""];
	[resultLabel setText:@""];	
	
	[dealerCardsNumLabel setHidden:YES];
	[dealerCardsLabel setHidden:YES];
	[heroCardsNumLabel setHidden:YES];
	[heroCardsLabel setHidden:YES];	
	
	[dealButtonForKeyboard setHidden:YES];
	[heroStackLabelForKeyboard setHidden:YES];
    
    [self stopWaitIndicator];
    [villainWaitIndicator setHidden:YES];
}

// restore cards for either hero or villain
- (void) restoreCards:(NSMutableArray*)cardViews
			 cardsNum:(NSInteger)cardsNum
		otherCardsNum:(NSInteger)otherCardsNum
		firstCardView:(CardView*)firstCardView
		 lastCardView:(CardView*)lastCardView
{
	// three cases
	if (otherCardsNum == 0) {
		// has only one hand
		// hand
		for (int i=2; i < cardsNum; i++) {
			NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
			CardView *view = [cardViews objectAtIndex:cardViewIndex];
			view.card = [deck dealOneCard];
		}
	} else if (otherCardsNum == 1) {
		// the first hand is being played
		// split
		CardView *card1View = (CardView*)[cardViews objectAtIndex:1];
		lastCardView.card = card1View.card;
		card1View.card = nil;
		
		// deal the rest of the first hand
		for (int i=1; i < cardsNum; i++) {
			NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
			CardView *view = [cardViews objectAtIndex:cardViewIndex];
			view.card = [deck dealOneCard];
		}
	} else { // otherCardsNum >= 2
		// the second hand is being played
		
		// display the last card in the first hand
		firstCardView.card = heroCard0View.card;
		for (int i=1; i < otherCardsNum; i++)
			firstCardView.card = [deck dealOneCard];
		
		// the second hand
		CardView *card0View = (CardView*)[cardViews objectAtIndex:0];
		CardView *card1View = (CardView*)[cardViews objectAtIndex:1];
		card0View.card = card1View.card;
		card1View.card = nil;
		
		for (int i=1; i < cardsNum; i++) {
			NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
			CardView *view = [cardViews objectAtIndex:cardViewIndex];
			view.card = [deck dealOneCard];
		}
		
	}		
}

- (void) restoreDealerCards {
	if (dealerCardsNum > 2) {
		// turn up dealer's second card
		[self showDealersSecondCard];
		
		// deal the rest of dealer's hand
		for (int i=2; i < dealerCardsNum; i++) {
			NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
			CardView *view = [dealerCardViews objectAtIndex:cardViewIndex];
			view.card = [deck dealOneCard];
		}				
	}
}	

// if the only hand or first of two hands or second of two hands is over.
- (BOOL) isHandOver:(UILabel*)handLabel
	  otherCardsNum:(NSInteger)otherCardsNum 
		  card0View:(CardView*)card0View		
		actionLabel:(UILabel*)actionLabel {
	return ([actionLabel.text isEqualToString:ACTION_STAND] ||
			[actionLabel.text isEqualToString:ACTION_DOUBLE] ||
			[handLabel.text isEqualToString:BLACKJACK] ||
			[handLabel.text isEqualToString:BUSTED] ||
			[handLabel.text isEqualToString:@"21"] ||
			(otherCardsNum > 0 && card0View.card.rank == kRankAce));
}

// firstbase 1st hand -> first base 2nd hand -> 
// second base 1st hand -> second base 2nd hand -> dealer
// return YES if a transition occurrs otherwise NO.
// if YES is returned, gameState and other parameters may be changed 
// inside this method. if NO is returned, nothing will be changed inside
// this method.
- (BOOL) isChainReaction:(enum Party)party {
	BOOL retval = NO;
	
	if (party == kPartyHero) {
		if (heroOtherCardsNum == 1) {
			// two hands and the first hand is being played.
			if ([self isHandOver:heroHandLabel
				   otherCardsNum:heroOtherCardsNum
					   card0View:heroCard0View
					 actionLabel:heroActionLabel]) {
				retval = YES;
				// move the first hand to the left side and
				// deal the second hand. no gameState change.
				// move hero's first hand to the left
				[heroActionLabel setText:@""];
				NSInteger lastCardViewIndex = 
					heroCardsNum >= MAX_CARD_NUM ? 
					MAX_CARD_NUM - 1 :
					heroCardsNum - 1;
				CardView *heroLastView = [heroCardViews objectAtIndex:lastCardViewIndex];
				heroFirstCardView.card = heroLastView.card;
				
				heroFirstHandLabel.text = heroHandLabel.text;
				
				for (int i=0; i < heroCardsNum; i++) {
					NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
					CardView *view = [heroCardViews objectAtIndex:cardViewIndex];
					view.card = nil;
				}
				
				heroOtherCardsNum = heroCardsNum;
				
				// move hero's second hand to the middle
				heroCard0View.card = heroLastCardView.card;
				heroLastCardView.card = nil;
				
				// deal the second card for hero's hand
				heroCard1View.card = [deck dealOneCard];
				
				heroCardsNum = 2;
				
				isHeroSecondHandSoft = [self isSoft:kPartyHero];
				heroSecondHandValue = [self calcTotalValue:kPartyHero];
				isHeroHandSoft = isHeroSecondHandSoft;
				heroHandValue = heroSecondHandValue;				
				
				[self showHeroHand];
			}				
		} else { // if (heroOtherCardsNum == 0 || heroOtherCardsNum > 1)
			// only one hand, or
			// two hands and the second hand is being played.
			if ([self isHandOver:heroHandLabel
				   otherCardsNum:heroOtherCardsNum
					   card0View:heroCard0View
					 actionLabel:heroActionLabel]) {
				retval = YES;
				if (gameState == kHUBJStateFirstBasesTurnToAct) {
					gameState = kHUBJStateSecondBasesTurnToAct;
				} else if (gameState == kHUBJStateSecondBasesTurnToAct) {
					gameState = kHUBJStateDealersTurnToAct;
				}
			} else {
				retval = NO;
			}
		} 
	} else if (party == kPartyVillain) {
		if (villainOtherCardsNum == 1) {
			// two hands and the first hand is being played.
			if ([self isHandOver:villainHandLabel
				   otherCardsNum:villainOtherCardsNum
					   card0View:villainCard0View
					 actionLabel:villainActionLabel]) {
				retval = YES;
				// move the first hand to the left side and
				// deal the second hand. no gameState change.
				// move villain's first hand to the left
				[villainActionLabel setText:@""];
				NSInteger lastCardViewIndex = 
					villainCardsNum >= MAX_CARD_NUM ? 
					MAX_CARD_NUM - 1 :
					villainCardsNum - 1;
				CardView *villainLastView = [villainCardViews objectAtIndex:lastCardViewIndex];
				villainFirstCardView.card = villainLastView.card;
				
				villainFirstHandLabel.text = villainHandLabel.text;
				
				for (int i=0; i < villainCardsNum; i++) {
					NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
					CardView *view = [villainCardViews objectAtIndex:cardViewIndex];
					view.card = nil;
				}
				
				villainOtherCardsNum = villainCardsNum;
				
				// move villain's second hand to the middle
				villainCard0View.card = villainLastCardView.card;
				villainLastCardView.card = nil;
				
				// deal the second card for villain's hand
				villainCard1View.card = [deck dealOneCard];
				
				villainCardsNum = 2;
				
				isVillainSecondHandSoft = [self isSoft:kPartyVillain];
				villainSecondHandValue = [self calcTotalValue:kPartyVillain];
				isVillainHandSoft = isVillainSecondHandSoft;
				villainHandValue = villainSecondHandValue;								
				
				[self showVillainHand];
			}				
		} else { // if (villainOtherCardsNum == 0 || villainOtherCardsNum > 1)
			// only one hand, or
			// two hands and the second hand is being played.
			if ([self isHandOver:villainHandLabel
				   otherCardsNum:villainOtherCardsNum
					   card0View:villainCard0View
					 actionLabel:villainActionLabel]) {
				retval = YES;
				if (gameState == kHUBJStateFirstBasesTurnToAct) {
					gameState = kHUBJStateSecondBasesTurnToAct;
				} else if (gameState == kHUBJStateSecondBasesTurnToAct) {
					gameState = kHUBJStateDealersTurnToAct;
				}
			} else {
				retval = NO;
			}
		} 		
	}
	
	return retval;
}

- (void) whoseTurnIsIt {
	// chain reaction
	if (gameState == kHUBJStateFirstBasesTurnToAct) {
		if ([self isHeroFirstBase]) {
			if ([self isChainReaction:kPartyHero]) {
				[self whoseTurnIsIt];
			} else {
				[self herosTurnToAct];
			}
		} else {
			if ([self isChainReaction:kPartyVillain]) {
				[self whoseTurnIsIt];
			} else {				
				[villain firstToAct];
			}
		}
	} else if (gameState == kHUBJStateSecondBasesTurnToAct) {
		if ([self isHeroFirstBase]) {
			if ([self isChainReaction:kPartyVillain]) {
				[self whoseTurnIsIt];
			} else {				
				[villain secondToAct];
			}
		} else {
			if ([self isChainReaction:kPartyHero]) {
				[self whoseTurnIsIt];
			} else {				
				[self herosTurnToAct];
			}
		}
	} else if (gameState == kHUBJStateDealersTurnToAct) {
		longShowdownDelay = YES;
		
		[self showDealersSecondCard];
		[self showDealerHand];
		
		// deal the rest of dealer's hand
		if ([self calcDealerHandSoftValue] >= 17) {
			// update hero/villain chip stacks
			[self processResults];
		} else {
			// deal one more card to dealer
			dealerCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALER_DEALING_DELAY target:self selector:@selector(dealNextDealerCardTimerMethod) userInfo:nil repeats:NO];
		}		
	} else if (gameState == kHUBJStateResultsProcessed) {
		longShowdownDelay = YES;
		
		[self showDealersSecondCard];
		[self showDealerHand];
		
		[heroBetLabel setText:@""];
		[heroFirstBetLabel setText:@""];
		[villainBetLabel setText:@""];
		[villainFirstBetLabel setText:@""];
		
		float heroBetsWon = [self calcHeroBetsWon];
		NSInteger heroSingleBet = [self heroSingleBet];
		
		NSInteger heroBetAmountWon = heroBetsWon * heroSingleBet;	
		if (heroBetAmountWon == 1.5 * heroSingleBet) {
			[heroResultLabel setText:RESULT_BLACKJACK];
		} else if (heroBetAmountWon == 0) {
			[heroResultLabel setText:RESULT_PUSH];
		} else if (heroBetAmountWon > 0) {
			[heroResultLabel setText:RESULT_WIN];
		} else if (heroBetAmountWon < 0) {
			[heroResultLabel setText:RESULT_LOSS];
		}
		
		float villainBetsWon = [self calcVillainBetsWon];
		NSInteger villainSingleBet = [self villainSingleBet];
		
		NSInteger villainBetAmountWon = villainBetsWon * villainSingleBet;	
		if (villainBetAmountWon == 1.5 * villainSingleBet) {
			[villainResultLabel setText:RESULT_BLACKJACK];
		} else if (villainBetAmountWon == 0) {
			[villainResultLabel setText:RESULT_PUSH];
		} else if (villainBetAmountWon > 0) {
			[villainResultLabel setText:RESULT_WIN];
		} else if (villainBetAmountWon < 0) {
			[villainResultLabel setText:RESULT_LOSS];
		}	
		
		[self nextHand];
	}
}	

- (void) restoreDealtCardsAndTheRest {
	//BOOL isDealersTurn = GET_BOOLEAN_FLAG(applicationData[1], 0);
	//BOOL isHandOver = GET_BOOLEAN_FLAG(applicationData[1], 1);
	isHeroFirstHandDoubleDown = GET_BOOLEAN_FLAG(applicationData[1], 2);
	isHeroSecondHandDoubleDown = GET_BOOLEAN_FLAG(applicationData[1], 3);
	isDealerHandSoft = GET_BOOLEAN_FLAG(applicationData[1], 4);
	isHeroFirstHandSoft = GET_BOOLEAN_FLAG(applicationData[1], 5);
	isHeroSecondHandSoft = GET_BOOLEAN_FLAG(applicationData[1], 6);
	//BOOL isSecondBasesTurn = GET_BOOLEAN_FLAG(applicationData[1], 7);
	
	isVillainFirstHandDoubleDown = GET_BOOLEAN_FLAG(applicationData[2], 1);
	isVillainSecondHandDoubleDown = GET_BOOLEAN_FLAG(applicationData[2], 2);
	isVillainFirstHandSoft = GET_BOOLEAN_FLAG(applicationData[2], 3);
	isVillainSecondHandSoft = GET_BOOLEAN_FLAG(applicationData[2], 4);
	//BOOL areCardsDealt = GET_BOOLEAN_FLAG(applicationData[2], 5);
	
	if (gameState == kHUBJStateCardsToBeDealt) {
		[self dealFirstCard];
		return;
	}
	
	if (heroSecondHandValue == 0) {
		isHeroHandSoft = isHeroFirstHandSoft;
		heroHandValue = heroFirstHandValue;
	} else {
		isHeroHandSoft = isHeroSecondHandSoft;
		heroHandValue = heroSecondHandValue;
	}
	
	if (villainSecondHandValue == 0) {
		isVillainHandSoft = isVillainFirstHandSoft;
		villainHandValue = villainFirstHandValue;
	} else {
		isVillainHandSoft = isVillainSecondHandSoft;
		villainHandValue = villainSecondHandValue;
	}	
	
	/*
	 NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	 NSInteger heroFirstHandSoftValue = [self calcHeroFirstHandSoftValue];
	 NSInteger villainHandSoftValue = [self calcVillainHandSoftValue];
	 NSInteger villainFirstHandSoftValue = [self calcVillainFirstHandSoftValue];
	 */
	
	[self setEnabledBettingSystem:NO];

	heroCard0View.card = [deck dealOneCard];
	villainCard0View.card = [deck dealOneCard];	
	dealerCard0View.card = [deck dealOneCard];
	heroCard1View.card = [deck dealOneCard];
	villainCard1View.card = [deck dealOneCard];
	dealerCard1View.card = [deck dealOneCard];		
	
	BOOL heroFB = [self isHeroFirstBase];
	NSMutableArray* firstBaseCardViews = heroFB ? heroCardViews : villainCardViews;
	NSInteger firstBaseCardsNum = heroFB ? heroCardsNum : villainCardsNum;
	NSInteger firstBaseOtherCardsNum = heroFB ? heroOtherCardsNum : villainOtherCardsNum;
	CardView* firstBaseFirstCardView = heroFB ? heroFirstCardView : villainFirstCardView;
	CardView* firstBaseLastCardView = heroFB ? heroLastCardView : villainLastCardView;
	
	NSMutableArray* secondBaseCardViews = heroFB ? villainCardViews : heroCardViews;
	NSInteger secondBaseCardsNum = heroFB ? villainCardsNum : heroCardsNum;
	NSInteger secondBaseOtherCardsNum = heroFB ? villainOtherCardsNum : heroOtherCardsNum;
	CardView* secondBaseFirstCardView = heroFB ? villainFirstCardView : heroFirstCardView;
	CardView* secondBaseLastCardView = heroFB ? villainLastCardView : heroLastCardView;

	// restore first base cards
	[self restoreCards:firstBaseCardViews
			  cardsNum:firstBaseCardsNum
		 otherCardsNum:firstBaseOtherCardsNum
		 firstCardView:firstBaseFirstCardView
		  lastCardView:firstBaseLastCardView
	 ];
	
	// restore second base cards
	[self restoreCards:secondBaseCardViews
			  cardsNum:secondBaseCardsNum
		 otherCardsNum:secondBaseOtherCardsNum
		 firstCardView:secondBaseFirstCardView
		  lastCardView:secondBaseLastCardView
	 ];
	
	// restore dealer cards
	[self restoreDealerCards];
	
	// show all three parties' hands
	[self showHeroHand];
	
	if (heroOtherCardsNum >= 2) {
		[self showFirstHand:heroFirstHandLabel
					  value:heroFirstHandValue
		 ];
	}
	
	[self showVillainHand];
	
	if (villainOtherCardsNum >= 2) {
		[self showFirstHand:villainFirstHandLabel
					  value:villainFirstHandValue
		 ];
	}
	
	[self whoseTurnIsIt];
	
	/*
	if (heroOtherCardsNum == 0) {
		// hero has only one hand
		// hero hand
		for (int i=2; i < heroCardsNum; i++) {
			NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
			CardView *view = [heroCardViews objectAtIndex:cardViewIndex];
			view.card = [deck dealOneCard];
		}
				
		[self showHeroHand];
		
		if (isHandOver) {
			// this hand is over. hero stack is up to date.
			
			// turn up dealer's second card
			[self showDealersSecondCard];
			
			// deal the rest of dealer's hand
			for (int i=2; i < dealerCardsNum; i++) {
				NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
				CardView *view = [dealerCardViews objectAtIndex:cardViewIndex];
				view.card = [deck dealOneCard];
			}				
			
			[self showDealerHand];
			
			// show result
			[self showResult];
			
			// no need to update current bet or hero stack
			
			[self setEnabledBettingSystem:YES];

		} else {		
			// this hand is not over yet. hero stack needs to be updated
			if ([heroHandLabel.text isEqualToString:BLACKJACK] ||
				[heroHandLabel.text isEqualToString:BUSTED]) {
				isDealersTurn = YES;
			} else {
				if (heroHandSoftValue == 21)
					isDealersTurn = YES;
			}
			
			if (isDealersTurn) {				
				// deal to the end of this hand
				[self heroStands];
			} else {
				// it's hero's turn. set buttons
				[AppController changeTitleOfButton:dealStandButton to:STAND_BUTTON_TITLE];
				[AppController changeImageOfButton:dealStandButton to:STAND_BUTTON_IMAGE];
				[dealStandButton setHidden:NO];
				[hintButton setHidden:NO];
				[hitButton setHidden:NO];
				[doubleButton setHidden:[self heroStack] < [self userAmount]];
				
				if ([heroCard0View.card getBlackjackValue] ==
					[heroCard1View.card getBlackjackValue])
					[splitButton setHidden:[self heroStack] < [self userAmount]];					
			}
		}
	} else {
		// hero has two hands after a split
		if (heroOtherCardsNum == 1) {
			// the first hand is being played
			// split
			heroLastCardView.card = heroCard1View.card;
			heroCard1View.card = nil;

			// deal the rest of the first hero hand
			for (int i=1; i < heroCardsNum; i++) {
				NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
				CardView *view = [heroCardViews objectAtIndex:cardViewIndex];
				view.card = [deck dealOneCard];
			}
			
			[self showHeroHand];
			
			// check if the first hand is over
			BOOL isFirstHeroHandOver = NO;
			if ([heroHandLabel.text isEqualToString:BLACKJACK] ||
				[heroHandLabel.text isEqualToString:BUSTED] ||
				heroCard0View.card.rank == kRankAce) {
				isFirstHeroHandOver = YES;
			} else {
				NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
				
				if (heroHandSoftValue == 21)
					isFirstHeroHandOver = YES;
			}
			
			if (isFirstHeroHandOver) {
				// move hero's first hand to the left
				NSInteger lastCardViewIndex = 
					heroCardsNum >= MAX_CARD_NUM ? 
					MAX_CARD_NUM - 1 :
					heroCardsNum - 1;
				CardView *heroLastView = [heroCardViews objectAtIndex:lastCardViewIndex];
				heroFirstCardView.card = heroLastView.card;
				
				heroFirstHandLabel.text = heroHandLabel.text;
				
				for (int i=0; i < heroCardsNum; i++) {
					NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
					CardView *view = [heroCardViews objectAtIndex:cardViewIndex];
					view.card = nil;
				}
				
				heroOtherCardsNum = heroCardsNum;
				
				// move hero's second hand to the middle
				heroCard0View.card = heroLastCardView.card;
				heroLastCardView.card = nil;
				
				// deal the second card for hero's hand
				heroCard1View.card = [deck dealOneCard];
				
				heroCardsNum = 2;
				
				[self showHeroHand];
				
				// check if hero's second hand is over (Blackjack)
				if ([heroHandLabel.text isEqualToString:BLACKJACK] ||
					heroCard0View.card.rank == kRankAce) {
					// second hand is over. time to deal dealer's cards
					[self heroStands];
				} else {
					// second hand is not over yet. set buttons.
					[AppController changeTitleOfButton:dealStandButton to:STAND_BUTTON_TITLE];
					[AppController changeImageOfButton:dealStandButton to:STAND_BUTTON_IMAGE];
					[dealStandButton setHidden:NO];
					[hintButton setHidden:NO];
					[hitButton setHidden:NO];
					[doubleButton setHidden:[self heroStack] < [self userAmount]];				
					[splitButton setHidden:YES];
				}
				
			} else {
				// hero's first hand is not over yet. set buttons
				[AppController changeTitleOfButton:dealStandButton to:STAND_BUTTON_TITLE];
				[AppController changeImageOfButton:dealStandButton to:STAND_BUTTON_IMAGE];
				[dealStandButton setHidden:NO];
				[hintButton setHidden:NO];
				[hitButton setHidden:NO];
				
				if (heroCardsNum == 2)
					[doubleButton setHidden:[self heroStack] < [self userAmount]];
				else
					[doubleButton setHidden:YES];
				
				[splitButton setHidden:YES];
			}

		} else { // heroOtherCardsNum >= 2
			// the second hand is being played

			// display the last card in the first hand
			heroFirstCardView.card = heroCard0View.card;
			for (int i=1; i < heroOtherCardsNum; i++)
				heroFirstCardView.card = [deck dealOneCard];

			// figure out what the first hand is
			if (heroFirstHandSoftValue > 21) {
				[heroFirstHandLabel setText:BUSTED];
			} else {
				if (heroFirstHandSoftValue == 21 && heroOtherCardsNum == 2)
					[heroFirstHandLabel setText:BLACKJACK];
				else
					[heroFirstHandLabel setText:[NSString stringWithFormat:@"%d", heroFirstHandSoftValue]];
			}
			
			// the second hand
			heroCard0View.card = heroCard1View.card;
			heroCard1View.card = nil;
			
			for (int i=1; i < heroCardsNum; i++) {
				NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
				CardView *view = [heroCardViews objectAtIndex:cardViewIndex];
				view.card = [deck dealOneCard];
			}
			
			[self showHeroHand];
			
			if (isHandOver) {
				// this hand is over. hero stack is up to date.
				
				// turn up dealer's second card
				[self showDealersSecondCard];
				
				// deal the rest of dealer's hand
				for (int i=2; i < dealerCardsNum; i++) {
					NSInteger cardViewIndex = i > MAX_CARD_NUM - 1 ? MAX_CARD_NUM - 1 : i;
					CardView *view = [dealerCardViews objectAtIndex:cardViewIndex];
					view.card = [deck dealOneCard];
				}				
				
				[self showDealerHand];
				
				// show result
				[self showResult];
				
				// no need to update current bet or hero stack
				
				[self setEnabledBettingSystem:YES];
				
			} else {		
				// this hand is not over yet. hero stack needs to be updated
				if ([heroHandLabel.text isEqualToString:BLACKJACK] ||
					[heroHandLabel.text isEqualToString:BUSTED]) {
					isDealersTurn = YES;
				} else {
					if (heroHandSoftValue == 21)
						isDealersTurn = YES;
				}
				
				if (isDealersTurn) {
					// deal to the end of this hand
					[self heroStands];
				} else {
					// it's hero's turn. set buttons
					[AppController changeTitleOfButton:dealStandButton to:STAND_BUTTON_TITLE];
					[AppController changeImageOfButton:dealStandButton to:STAND_BUTTON_IMAGE];
					[dealStandButton setHidden:NO];
					[hintButton setHidden:NO];
					[hitButton setHidden:NO];
					[doubleButton setHidden:[self heroStack] < [self userAmount]];
					
					if ([heroCard0View.card getBlackjackValue] ==
						[heroCard1View.card getBlackjackValue])
						[splitButton setHidden:[self heroStack] < [self userAmount]];					
				}
			}
		}
	}*/
}

// pre-condition: heroApplicationData[0] == 1 
- (void) willRestoreFromApplicationData:(uint8_t*)heroApplicationData 
{
	//[[Applytics sharedService] log:[[self class] description]];
	
	[self resetStuff];
	
	villain = [[BlackjackVillain alloc] initWithGameModeView:self];
	
	[self setupInitialScreen];
	
	// copy data into applicaitonData
	memcpy(applicationData, heroApplicationData, HEADSUP_BLACKJACK_APPLICATION_DATA_LENGTH);
	
	// release passed-in hero application data for they are no longer needed
	free(heroApplicationData);
	
	handCount = [AppController read2ByteIntegerFrom:applicationData+4];
	[handCountLabel setText:[NSString stringWithFormat:@"%d", handCount]];
	
	NSInteger heroStack = [AppController read4ByteIntegerFrom:applicationData+6];
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroStack]];
	[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", heroStack]];
	
	currentHeroBet = [AppController read4ByteIntegerFrom:applicationData+10];
	[self setCurrentHeroBet:currentHeroBet];
	
	NSInteger villainStack = [AppController read4ByteIntegerFrom:applicationData+14];
	[villainStackLabel setText:[NSString stringWithFormat:@"%d", villainStack]];
	
	[self setCurrentVillainBet:[AppController read4ByteIntegerFrom:applicationData+18]];
	
	// restore cards
	dealerCardsNum = [AppController read2ByteIntegerFrom:applicationData+22];
	
	heroCardsNum = [AppController read2ByteIntegerFrom:applicationData+24];
	heroOtherCardsNum = [AppController read2ByteIntegerFrom:applicationData+26];
	villainCardsNum = [AppController read2ByteIntegerFrom:applicationData+28];
	villainOtherCardsNum = [AppController read2ByteIntegerFrom:applicationData+30];
	
	dealerHandValue = [AppController read2ByteIntegerFrom:applicationData+32];
	
	heroFirstHandValue = [AppController read2ByteIntegerFrom:applicationData+34];
	heroSecondHandValue = [AppController read2ByteIntegerFrom:applicationData+36];
	villainFirstHandValue = [AppController read2ByteIntegerFrom:applicationData+38];
	villainSecondHandValue = [AppController read2ByteIntegerFrom:applicationData+40];
	
	gameState = applicationData[42];
	// hero/villain actions
	NSString* heroAction = [self byte2action:applicationData[43]];
	NSString* villainAction = [self byte2action:applicationData[44]];
	[heroActionLabel setText:heroAction];
	[villainActionLabel setText:villainAction];
	
	if (dealerCardsNum >= MAX_CARD_NUM) {
		[dealerCardsNumLabel setText:[NSString stringWithFormat:@"%d", dealerCardsNum]];
		[dealerCardsNumLabel setHidden:NO];
		[dealerCardsLabel setHidden:NO];
	}		
	
	if (heroCardsNum >= MAX_CARD_NUM) {
		[heroCardsNumLabel setText:[NSString stringWithFormat:@"%d", heroCardsNum]];
		[heroCardsNumLabel setHidden:NO];
		[heroCardsLabel setHidden:NO];
	}	
	
	for (int cardIndex = 45; cardIndex <= 67; cardIndex++) {
		uint8_t data = applicationData[cardIndex];
		
		NSInteger rank = (data >> 2) & 0x0f;
		NSInteger suit = (data) & 0x03;
		Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
		
		[deck addCard:card];
		[card release];
	}
	
	BOOL heroFB = GET_BOOLEAN_FLAG(applicationData[2], 0);
	[heroFirstBase setHidden:!heroFB];
	[villainFirstBase setHidden:heroFB];
	
	// check if her and villain have placed their bets.	
	if (gameState == kHUBJStateFirstBasesTurnToBet) {
		if (heroFB) {
			[self resetButtons];
		} else {
			[villain firstToBet];
		}
	} else if (gameState == kHUBJStateSecondBasesTurnToBet) {
		if (heroFB) {
			[villain secondToBet];
		} else {
			[self resetButtons];
		}
	} else {
		[self restoreDealtCardsAndTheRest];
	}	
}

- (BOOL) hasVillainAlreadySplit {
	return 
	villainFirstCardView.card != nil ||
	villainLastCardView.card != nil;	
}

// called before the very first hand
- (void) willDisplayAtHand:(NSInteger)count 
				 heroStack:(NSInteger)heroStack
{		
	//[[Applytics sharedService] log:[[self class] description]];
	
	[self resetStuff];
	
	villain = [[BlackjackVillain alloc] initWithGameModeView:self];

	[self startNewTournament];
}	

@end
