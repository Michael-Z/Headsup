//
//  GameModeView.m
//  Headsup
//
//  Created by Haolan Qin on 10/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "BlackjackGameModeView.h"
#import "Constants.h"
#import "Deck.h"
#import "Card.h"
#import "CardView.h"

#define DEAL_BUTTON_TITLE	@"Deal"
#define STAND_BUTTON_TITLE	@"Stand"
#define DEAL_BUTTON_IMAGE @"deal.png"
#define STAND_BUTTON_IMAGE @"stand.png"

#define HIT @"Hit"
#define STAND @"Stand"
#define DOUBLE @"Double Down"
#define SPLIT @"Split"

#define BLACKJACK @"Blackjack"
#define BUSTED @"Busted"

#define PUSH @"Push"
#define DEALER_BLACKJACK @"Dealer Got Blackjack"
#define DEALER_BUSTED @"Dealer Busted"
#define DEALER_WON @"Dealer Won"
#define HERO_BLACKJACK @"You Got Blackjack"
#define HERO_BUSTED @"You Busted"
#define HERO_WON @"You Won"

#define ANIMATION_SPLIT @"ANIMATION_SPLIT"
#define ANIMATION_MIDDLE_TO_LEFT_ONE_CARD @"ANIMATION_MIDDLE_TO_LEFT_ONE_CARD"
#define ANIMATION_MIDDLE_TO_LEFT @"ANIMATION_MIDDLE_TO_LEFT"
#define ANIMATION_RIGHT_TO_MIDDLE @"ANIMATION_RIGHT_TO_MIDDLE"
#define ANIMATION_MIDDLE_TO_LEFT_ONE_CARD_ACE @"ANIMATION_MIDDLE_TO_LEFT_ONE_CARD_ACE"
#define ANIMATION_MIDDLE_TO_LEFT_ACE @"ANIMATION_MIDDLE_TO_LEFT_ACE"
#define ANIMATION_RIGHT_TO_MIDDLE_ACE @"ANIMATION_RIGHT_TO_MIDDLE_ACE"

#define HERO_STACK 1000
#define MIN_BET 10
#define MID_BET 30
#define BIG_BET 100

#define DEALING_DELAY 0.5
#define DEALER_DEALING_DELAY 1.0

#define CARD_SLIDING_LONG_DURATION 0.8
#define CARD_SLIDING_SHORT_DURATION 0.2

#define MAX_CARD_NUM 5

#define STATUS_DEALING	@"Dealing..."
#define STATUS_SHOWDOWN @"Showdown..."

@implementation BlackjackGameModeView

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

@synthesize dealerCardsNumLabel;
@synthesize dealerCardsLabel;
@synthesize heroCardsNumLabel;
@synthesize heroCardsLabel;

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
		
	free(applicationData);
	applicationData = malloc(BLACKJACK_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
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
	return [[[NSData alloc] initWithBytes:applicationData length:BLACKJACK_APPLICATION_DATA_LENGTH] autorelease];
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

/*- (void) updateNumberLabel:(UILabel*)label addAmount:(float)amount {
	float currentValue = [[label text] floatValue];
	[label setText:[NSString stringWithFormat:@"%.2f", currentValue + amount]];
	[label setNeedsDisplay];
}*/

- (void) updateNumberLabel:(UILabel*)label addAmount:(NSInteger)amount {
 NSInteger currentValue = [[label text] intValue];
 [label setText:[NSString stringWithFormat:@"%d", currentValue + amount]];
}

- (NSInteger) userAmount {
	return [[amountTextField text] integerValue];
}

- (NSInteger) singleBet {
	NSInteger bet = [self userAmount];
	NSInteger retval;
	
	if (heroFirstCardView.card == nil && isFirstHandDoubleDown)
		retval = bet / 2;
	else if (heroFirstCardView.card != nil && isSecondHandDoubleDown)
		retval = bet / 2;
	else
		retval = bet;
	
	return retval;
}

- (NSInteger) heroStack {
	return [heroStackLabel.text intValue];
}

- (NSInteger) heroBetAmount {
	return [amountTextField.text intValue];
}

- (NSInteger) heroTotalChips {
	return [self heroStack] + [self heroBetAmount];
}

- (NSInteger) maxAmountAllowed {
	NSInteger heroTotalChips = [self heroStack] + [self userAmount];
	NSInteger maxBet = heroTotalChips / MIN_BET * MIN_BET;
	
	return maxBet;
}

- (void) clearApplicationData {
	applicationData[0] = (uint8_t)0;
	[appController writeBlackjackGameModeApplicationData:[self getApplicationData]];
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
        if ([AppController isFreeVersion]) {
            [GSAdEngine displayFullScreenAdForSlotNamed:@"fullscreenSlot"];
        }
        
		[self killAllActiveTimers];
		[self clearApplicationData];
		[self willDisplayAtHand:0 heroStack:1000];
	} else {
		// do nothing
	}
}

- (void) killAllActiveTimers {
	[dealerCardsDealingTimer invalidate];
	dealerCardsDealingTimer = nil;
		
	[holeCardsDealingTimer invalidate];
	holeCardsDealingTimer = nil;
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

- (void) setCurrentBet:(NSInteger)bet {
	currentBet = bet;
	
	[amountTextField setText:[NSString stringWithFormat:@"%d", currentBet]];
}

// called when keyboard is dismissed.
// we need to correct bet/raise when this method is called.
- (void)keyboardDismissed {
	// hide the deal button
	[dealButtonForKeyboard setHidden:YES];
	[heroStackLabelForKeyboard setHidden:YES];
	
	// validate user input
	NSInteger amount = [self validateAmount];
	
	float diff = currentBet - amount;
	[self updateNumberLabel:heroStackLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:diff];
	
	[self setCurrentBet:amount];
}

- (void) keyboardDisplayed {
	[dealButtonForKeyboard setHidden:NO];
	[heroStackLabelForKeyboard setHidden:NO];
}

- (BOOL) isSoft:(enum Party)party {
	BOOL isDealer = (party == kPartyDealer);
	NSMutableArray *cardViews = isDealer ? dealerCardViews : heroCardViews;
	NSInteger cardsNum = isDealer ? dealerCardsNum : heroCardsNum;
	
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
	BOOL isDealer = (party == kPartyDealer);
	NSMutableArray *cardViews = isDealer ? dealerCardViews : heroCardViews;
	NSInteger cardsNum = isDealer ? dealerCardsNum : heroCardsNum;
	
	BOOL retval = NO;
	
	// To count as Blackjack, a hand must have only two cards with a total of
	// 21 and it cannot be in a splitting hand.
	if (cardsNum == 2 && 
		(party == kPartyDealer || 
		 (party == kPartyHero && heroOtherCardsNum == 0))) {
			
		Card *card0 = ((CardView*)[cardViews objectAtIndex:0]).card;
		Card *card1 = ((CardView*)[cardViews objectAtIndex:1]).card;
		
		retval = ((card0.rank == kRankAce || 
				   card1.rank == kRankAce) &&
				  [card0 getBlackjackValue] + [card1 getBlackjackValue] == 11);
	}
	
	return retval;
}

// hard value
- (NSInteger) calcTotalValue:(enum Party) party {
	BOOL isDealer = (party == kPartyDealer);
	NSMutableArray *cardViews = isDealer ? dealerCardViews : heroCardViews;
	NSInteger cardsNum = isDealer ? dealerCardsNum : heroCardsNum;
	
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

- (void) setEnabledBettingSystem:(BOOL)isEnabled {
	[noBetButton setHidden:!isEnabled];
	[minBetButton setHidden:!isEnabled];
	[midBetButton setHidden:!isEnabled];
	[bigBetButton setHidden:!isEnabled];
	[maxBetButton setHidden:!isEnabled];
	
	[amountTextField setEnabled:isEnabled];
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
	[self setEnabledBettingSystem:NO];
	
	[handCountLabel setText:[NSString stringWithFormat:@"%d", ++handCount]];
	
	isFirstHandDoubleDown = NO;
	isSecondHandDoubleDown = NO;

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
	
	dealerCardsNum = 0;
	heroCardsNum = 0;
	heroOtherCardsNum = 0;
	
	isDealerHandSoft = NO;
	isHeroHandSoft = NO;
	isHeroFirstHandSoft = NO;
	isHeroSecondHandSoft = NO;
	dealerHandValue = 0;
	heroHandValue = 0;
	heroFirstHandValue = 0;
	heroSecondHandValue = 0;
	
	// reset buttons
	[hintButton setHidden:YES];
	[hintLabel setText:@""];
	[surrenderButton setHidden:YES];
		
	// reset labels
	[dealerHandLabel setText:@""];
	[heroHandLabel setText:@""];
	[heroFirstHandLabel setText:@""];
	[resultLabel setText:@""];
	
	[dealerCardsNumLabel setHidden:YES];
	[dealerCardsLabel setHidden:YES];
	[heroCardsNumLabel setHidden:YES];
	[heroCardsLabel setHidden:YES];
	
	// auto-save point
	// clear all boolean flags
	applicationData[1] = (uint8_t)0;
	//SET_BOOLEAN_FLAG(applicationData[1], 0, dealer);
	// save applicationData[4-23]
	[self saveToApplicationData];
	// cards applicationData[24-46] have already been set
	
	// flag bit
	applicationData[0] = (uint8_t)1;	
}

// update hero stack based on results indicated in dealer's hand label, hero's hand label
// and hero's first hand label
- (void) processResults {
	[self stopWaitIndicator];

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
			if (isFirstHandDoubleDown)
				betsWon -= 1;
		} else if ([heroFirstHandLabel.text isEqualToString:@""])
			betsWon += 0;
		else {
			betsWon += 1;				
			if (isFirstHandDoubleDown)
				betsWon += 1;
		}
		
		if ([heroHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (heroFirstCardView.card == nil && isFirstHandDoubleDown)
				betsWon -= 1;
			else if (heroFirstCardView.card != nil && isSecondHandDoubleDown)
				betsWon -= 1;
		} else {
			betsWon += 1;
			if (heroFirstCardView.card == nil && isFirstHandDoubleDown)
				betsWon += 1;
			else if (heroFirstCardView.card != nil && isSecondHandDoubleDown)
				betsWon += 1;
		}
	} else { // dealer has 17 to 21
		if ([heroFirstHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (isFirstHandDoubleDown)
				betsWon -= 1;
		} else if ([heroFirstHandLabel.text isEqualToString:@""])
			betsWon += 0;
		else {
			if (dealerHandSoftValue > heroFirstHandSoftValue) {
				betsWon -= 1;
				if (isFirstHandDoubleDown)
					betsWon -= 1;
			} else if (dealerHandSoftValue < heroFirstHandSoftValue) {
				betsWon += 1;
				if (isFirstHandDoubleDown)
					betsWon += 1;
			} else
				betsWon += 0;
		}
		
		if ([heroHandLabel.text isEqualToString:BLACKJACK])
			betsWon += 1.5;
		else if ([heroHandLabel.text isEqualToString:BUSTED]) {
			betsWon -= 1;
			if (heroFirstCardView.card == nil && isFirstHandDoubleDown)
				betsWon -= 1;
			else if (heroFirstCardView.card != nil && isSecondHandDoubleDown)
				betsWon -= 1;
		} else {			
			if (dealerHandSoftValue > heroHandSoftValue) {
				betsWon -= 1;
				if (heroFirstCardView.card == nil && isFirstHandDoubleDown)
					betsWon -= 1;
				else if (heroFirstCardView.card != nil && isSecondHandDoubleDown)
					betsWon -= 1;				
			} else if (dealerHandSoftValue < heroHandSoftValue) {
				betsWon += 1;
				if (heroFirstCardView.card == nil && isFirstHandDoubleDown)
					betsWon += 1;
				else if (heroFirstCardView.card != nil && isSecondHandDoubleDown)
					betsWon += 1;
			} else
				betsWon += 0;
		}		
	}
	
	// play sound
	if (betsWon > 0) {
		[self playHeroWonPotSound];
	} else if (betsWon < 0) {
		[self playYourTurnSound];
	}
	
	// display who won
	if ([dealerHandLabel.text isEqualToString:BLACKJACK]) {
		if ([heroHandLabel.text isEqualToString:BLACKJACK]) {
			[resultLabel setText:PUSH];
		} else {
			[resultLabel setText:DEALER_BLACKJACK];
		}
	} else if ([dealerHandLabel.text isEqualToString:BUSTED]) {
		if (![heroHandLabel.text isEqualToString:BUSTED] &&
			![heroFirstHandLabel.text isEqualToString:BUSTED]) {
			[resultLabel setText:DEALER_BUSTED];
		} else {
			if (betsWon > 0) {
				[resultLabel setText:HERO_WON];
			} else if (betsWon < 0) {
				[resultLabel setText:DEALER_WON];
			} else { // betsWon == 0
				[resultLabel setText:PUSH];
			}
		}
	} else {
		// dealer is not busted but hero might be
		if ([heroHandLabel.text isEqualToString:BLACKJACK]) {
			[resultLabel setText:HERO_BLACKJACK];
		} else if ([heroHandLabel.text isEqualToString:BUSTED] &&
				   ([heroFirstHandLabel.text isEqualToString:@""] ||
					[heroFirstHandLabel.text isEqualToString:BUSTED])) {
			[resultLabel setText:HERO_BUSTED];
		} else {
			if (betsWon > 0) {
				[resultLabel setText:HERO_WON];
			} else if (betsWon < 0) {
				[resultLabel setText:DEALER_WON];
			} else { // betsWon == 0
				[resultLabel setText:PUSH];
			}
		}
	}

	NSInteger singleBet = [self singleBet];
	
	// calculate hero's total chips left.
	// number of single bets put in by hero in this hand
	NSInteger betsPutIn = 0;
	if (heroOtherCardsNum == 0) {
		// hero has one hand
		betsPutIn = isFirstHandDoubleDown ? 2 : 1;
	} else {
		// hero has two hands
		betsPutIn = (isFirstHandDoubleDown ? 2 : 1) + 
					(isSecondHandDoubleDown ? 2 : 1);
	}
	NSInteger heroTotalChips = [self heroStack] + (betsPutIn + betsWon) * singleBet;
	//NSLog(@"%d %d %d %f %d", heroTotalChips, [self heroStack], betsPutIn, betsWon, singleBet);
	
	if (heroTotalChips < MIN_BET) {
		// hero doesn't have enought to make a min bet.
		[self setCurrentBet:0];
		[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroTotalChips]];
		[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", heroTotalChips]];
	} else if (heroTotalChips < singleBet) {
		// hero doesn't have enough to make the same bet. let him bet the minimum.
		[self setCurrentBet:MIN_BET];
		[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroTotalChips - MIN_BET]];
		[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", heroTotalChips - MIN_BET]];
	} else {
		// hero has plenty of chips
		[self setCurrentBet:singleBet];
		[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroTotalChips - singleBet]];
		[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", heroTotalChips - singleBet]];
	}
			
	// this hand is over
	SET_BOOLEAN_FLAG(applicationData[1], 1, YES);
	[self saveToApplicationData];
	
	[self resetButtons];
	
	// check if hero has too few chips left
	if (currentBet == 0) {
		AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);

		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"More Chips For You" 
															message:@"The casino is about to refill your chip stack"
														   delegate:self
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];	
		[alertView show];
		[alertView release];			
	}	
}

- (void) dealFirstCard {
	[self playDealingCardsSound];
	heroCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardTimerMethod {
	[self playDealingCardsSound];
	dealerCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardTimerMethod {
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) showDealersSecondCard {
	[self playDealingCardsSound];
	
	SET_BOOLEAN_FLAG(applicationData[1], 0, YES);

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

- (void) dealFourthCardTimerMethod {
	holeCardsDealingTimer = nil;
	
	[self playDealingCardsSound];
	dealerCard1View.card = [deck dealOneCard];
	
	[self stopWaitIndicator];
	
	// update points
	dealerCardsNum = 2;
	heroCardsNum = 2;
	
	isDealerHandSoft = [self isSoft:kPartyDealer];
	isHeroHandSoft = [self isSoft:kPartyHero];
	isHeroFirstHandSoft = isHeroHandSoft;
	dealerHandValue = [self calcTotalValue:kPartyDealer];
	heroHandValue = [self calcTotalValue:kPartyHero];
	heroFirstHandValue = heroHandValue;
	
	[self saveToApplicationData];
	
	if ([self isBlackjack:kPartyHero]) {
		// hero got blackjack
		[heroHandLabel setText:BLACKJACK];
		
		if ([self isBlackjack:kPartyDealer]) {
			// dealer got blackjack as well. it's a push
			[self showDealersSecondCard];
			
			[dealerHandLabel setText:BLACKJACK];
			
			[resultLabel setText:PUSH];
			
			// hero gets his bet back
			[self processResults];
		} else {
			// dealer didn't get blackjack. hero won.
			[self showDealersSecondCard];
			
			[dealerHandLabel setText:[NSString stringWithFormat:@"%d", 
									  [self calcDealerHandSoftValue]]];
			
			[resultLabel setText:HERO_BLACKJACK];
			
			// hero gets his bet back + 1.5 his bet
			[self processResults];
		}
		
		// no need to change the buttons
	} else {
		
		// hero didn't get blackjack
		[heroHandLabel setText:[NSString stringWithFormat:@"%d", 
								[self calcHeroHandSoftValue]]];
		
		if ([self isBlackjack:kPartyDealer]) {
			// dealer got blackjack. dealer won.
			[self showDealersSecondCard];
			
			[dealerHandLabel setText:BLACKJACK];
			
			[resultLabel setText:DEALER_BLACKJACK];
			
			// hero stack unchanged.
			[self processResults];
			
			// no need to change the buttons.
		} else {
			// dealer didn't get blackjack. it's hero's turn to play.
			
			// set buttons
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

- (void) dealNewHand {
	[self startWaitIndicator:STATUS_DEALING];
	
	[self resetForNewHand];
	[dealStandButton setHidden:YES];
		
	[deck shuffleUpAndDeal:kHandBlackjack];
	// save cards just dealt in application data
	NSInteger cardsCount = [deck getNumOfCards];
	for (int i=0; i < cardsCount; i++) {
		Card *card = [deck getCardAtIndex:i];
		applicationData[24+i] = (uint8_t)((card.rank << 2) | card.suit);
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
	[appController writeBlackjackGameModeApplicationData:[self getApplicationData]];
	
	[navController popViewControllerAnimated:YES];
}

- (IBAction) noBetButtonPressed:(id)sender {
	[self updateNumberLabel:heroStackLabel addAmount:currentBet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:currentBet];
	
	[self setCurrentBet:0];
	
	//[dealStandButton setHidden:YES];
	
	[self saveToApplicationData];
}

- (void) addBet:(NSInteger) additionalBet {	
	[self setCurrentBet:(currentBet + additionalBet)];
	
	[self updateNumberLabel:heroStackLabel addAmount:-additionalBet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:-additionalBet];
	
	[dealStandButton setHidden:NO];	
	
	[self saveToApplicationData];
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
		heroOtherCardsNum == 0 &&
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
	NSString* bestMove = (NSString*)[strategyCard objectAtIndex:heroIndex * 10 + dealerIndex];
	
	// hero is only allowed to double on a two-card hand.
	if ([bestMove isEqualToString:DOUBLE] && (heroCardsNum != 2)) {
		bestMove = HIT;
	}
	
	[hintLabel setText:bestMove];
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
	if (isFirstHandDoubleDown) {
		NSInteger originalBet = [self userAmount] / 2;
		[self setCurrentBet:originalBet];
	}
	
	// move first hand to the left side
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	
	if ([self isBlackjack:kPartyHero]) {
		[heroFirstHandLabel setText:BLACKJACK];
	} else {		
		if (heroHandSoftValue > 21)
			[heroFirstHandLabel setText:BUSTED];
		else 
			[heroFirstHandLabel setText:[NSString stringWithFormat:@"%d", heroHandSoftValue]];
	}
	
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
		animationId:ANIMATION_MIDDLE_TO_LEFT_ONE_CARD
		   duration:CARD_SLIDING_LONG_DURATION];
}

// this method is called when it's dealer turn to play, not necessarily
// when the "stand" button is pressed.
- (void) heroStands {
	[self startWaitIndicator:STATUS_SHOWDOWN];

	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];
	
	if (heroLastCardView.card == nil) {
		// display results
		[self showDealersSecondCard];
		
		// show dealer's hand
		[self showDealerHand];
		
		if ([self calcDealerHandSoftValue] >= 17) {
			[self processResults];
		} else {
			dealerCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALER_DEALING_DELAY target:self selector:@selector(dealNextDealerCardTimerMethod) userInfo:nil repeats:NO];
		}
	} else {
		// this is the first hand of two hands		
		[self dealSecondHeroHand];
	}
}	

- (void)animationDidStop:(NSString *)animationID 
				finished:(NSNumber *)finished
				 context:(void *)context {
	
	[self restoreAnimatedCardView];

	if ([animationID isEqualToString:ANIMATION_SPLIT]) {
		[self postSplitAnimation];
	} else if ([animationID isEqualToString:ANIMATION_MIDDLE_TO_LEFT_ONE_CARD]) {
		[self postMiddleToLeftOneCardAnimation];
	} else if ([animationID isEqualToString:ANIMATION_MIDDLE_TO_LEFT]) {
		[self postMiddleToLeftAnimation];
	} else if ([animationID isEqualToString:ANIMATION_RIGHT_TO_MIDDLE]) {
		[self postRightToMiddleAnimation];
	} else if ([animationID isEqualToString:ANIMATION_MIDDLE_TO_LEFT_ONE_CARD_ACE]) {
		[self postMiddleToLeftOneCardAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_MIDDLE_TO_LEFT_ACE]) {
		[self postMiddleToLeftAceAnimation];
	} else if ([animationID isEqualToString:ANIMATION_RIGHT_TO_MIDDLE_ACE]) {
		[self postRightToMiddleAceAnimation];
	}	
}

- (void) postMiddleToLeftOneCardAnimation {
	[self saveToApplicationData];
	
	if (animationHeroCardViewIndex == 0) {
		// move first hand to the left
		[self slideCard:heroCard0View 
					 to:heroFirstCardView 
			animationId:ANIMATION_MIDDLE_TO_LEFT
			   duration:CARD_SLIDING_LONG_DURATION];
	} else {
		--animationHeroCardViewIndex;
		// keep shifting card to the next spot on the left side
		[self slideCard:(CardView*)[heroCardViews objectAtIndex:animationHeroCardViewIndex+1]
					 to:(CardView*)[heroCardViews objectAtIndex:animationHeroCardViewIndex]
			animationId:ANIMATION_MIDDLE_TO_LEFT_ONE_CARD
			   duration:CARD_SLIDING_SHORT_DURATION];		
	}
}

- (void) postMiddleToLeftAnimation {
	[self saveToApplicationData];
	
	// move second hand to the middle
	[self slideCard:heroLastCardView 
				 to:heroCard0View 
		animationId:ANIMATION_RIGHT_TO_MIDDLE
		   duration:CARD_SLIDING_LONG_DURATION];		
}

- (void) postRightToMiddleAnimation {	
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
		
		[doubleButton setHidden:[self heroStack] < [self userAmount]];
		[hitButton setHidden:NO];
		[dealStandButton setHidden:NO];		
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
	[splitButton setHidden:YES];
	[doubleButton setHidden:YES];
	[hitButton setHidden:YES];
	[dealStandButton setHidden:YES];
	
	[heroHandLabel setText:@""];
		
	[self slideCard:heroCard1View 
				 to:heroLastCardView 
		animationId:ANIMATION_SPLIT
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (void) postMiddleToLeftOneCardAceAnimation {
	// move first hand to the left
	[self slideCard:heroCard0View 
				 to:heroFirstCardView 
		animationId:ANIMATION_MIDDLE_TO_LEFT_ACE
		   duration:CARD_SLIDING_LONG_DURATION];
}

- (void) postMiddleToLeftAceAnimation {	
	heroCard0View.card = nil;
	heroOtherCardsNum = 2;
	
	[self saveToApplicationData];
	
	// move second hand to the middle
	[self slideCard:heroLastCardView 
				 to:heroCard0View 
		animationId:ANIMATION_RIGHT_TO_MIDDLE_ACE
		   duration:CARD_SLIDING_LONG_DURATION];
}	

- (void) postRightToMiddleAceAnimation {
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

- (void) postSplitAnimation {	
	NSInteger bet = [self userAmount];
	[self updateNumberLabel:heroStackLabel addAmount:-bet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:-bet];

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
		[heroFirstHandLabel setText:heroHandLabel.text];
		[heroHandLabel setText:@""];
		
		// move first hand to the left
		[self slideCard:heroCard1View 
					 to:heroCard0View 
			animationId:ANIMATION_MIDDLE_TO_LEFT_ONE_CARD_ACE
			   duration:CARD_SLIDING_LONG_DURATION];
	} else {
		// not splitting aces
		NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
		if (heroHandSoftValue == 21) {		
			[self dealSecondHeroHand];
		} else {
			[heroHandLabel setText:[NSString stringWithFormat:@"%d", heroHandSoftValue]];
			
			[self saveToApplicationData];
			
			[doubleButton setHidden:[self heroStack] < [self userAmount]];
			[hitButton setHidden:NO];
			[dealStandButton setHidden:NO];			
		}
	}
}

- (IBAction) doubleButtonPressed:(id)sender {
	NSInteger bet = [self userAmount];
	[self updateNumberLabel:heroStackLabel addAmount:-bet];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:-bet];
	[self setCurrentBet:(bet * 2)];
	
	if (heroFirstCardView.card == nil)
		isFirstHandDoubleDown = YES;
	else 
		isSecondHandDoubleDown = YES;
	
	[self saveToApplicationData];
		
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
	
	[self saveToApplicationData];
			
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	if (heroHandSoftValue > 21) {
		// hero busted
		[heroHandLabel setText:BUSTED];
		
		if (heroLastCardView.card == nil) {
			// hero's only hand or second hand of two hands
			if ([heroFirstHandLabel.text isEqualToString:@""] ||
				[heroFirstHandLabel.text isEqualToString:BUSTED]) {
				// hero's only hand is busted or both hands are busted. this hand is over.
				
				// show dealer's hand
				[self showDealersSecondCard];
				
				[dealerHandLabel setText:[NSString stringWithFormat:@"%d", 
										  [self calcDealerHandSoftValue]]];
				
				[resultLabel setText:HERO_BUSTED];
				
				// hero stack unchanged
				[self processResults];
			} else {
				// this busted hand is hero's second hand and his first hand is not busted.
				// dealer must play to soft 17 or up.
				[self heroStands];
			}
		} else {
			// this busted hand is the first hand of two hands
			[self dealSecondHeroHand];			
		}		
		
	} else {
		[heroHandLabel setText:[NSString stringWithFormat:@"%d", 
								[self calcHeroHandSoftValue]]];
		[self heroStands];
	}	
}

- (IBAction) hitButtonPressed:(id)sender {
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
	
	if (heroHandSoftValue > 21) {
		// hero busted
		[heroHandLabel setText:BUSTED];
		
		if (heroLastCardView.card == nil) {
			// hero's only hand or second hand of two hands
			if ([heroFirstHandLabel.text isEqualToString:@""] ||
				[heroFirstHandLabel.text isEqualToString:BUSTED]) {
				// hero's only hand is busted or both hands are busted. this hand is over.
				
				// show dealer's hand
				[self showDealersSecondCard];
				
				[dealerHandLabel setText:[NSString stringWithFormat:@"%d", 
										  [self calcDealerHandSoftValue]]];
								
				[resultLabel setText:HERO_BUSTED];
				
				// hero stack unchanged
				[self processResults];
			} else {
				// this busted hand is hero's second hand and his first hand is not busted.
				// dealer must play to soft 17 or up.
				[self heroStands];
			}
		} else {
			// this busted hand is the first hand of two hands
			[self dealSecondHeroHand];			
		}
	} else if (heroHandSoftValue == 21) {
		if (heroLastCardView.card == nil) {
			[heroHandLabel setText:@"21"];
			[self heroStands];
		} else {
			// this 21 hand is the first hand of two hands			
			[self dealSecondHeroHand];
		}
	} else {
		[heroHandLabel setText:[NSString stringWithFormat:@"%d", 
								[self calcHeroHandSoftValue]]];
		
		[self saveToApplicationData];
	}	
}

- (IBAction) dealStandButtonPressed:(id)sender {
	NSString *dealStandButtonTitle = [dealStandButton titleForState:UIControlStateNormal];
	
	if ([dealStandButtonTitle isEqualToString:DEAL_BUTTON_TITLE]) {
		if ([self userAmount] >= MIN_BET) {
			// deal new hand
			[self dealNewHand];
		}
	} else {
		// stand
		// dealer has soft 17 or up: stand; otherwise hit him until
		// he either gets soft 17 or up or busts.
		[self heroStands];		
	}
}

- (IBAction) dealButtonForKeyboardPressed:(id)sender {
	// dismiss the keyboard
	[amountTextField resignFirstResponder];

	// deal
	[self dealNewHand];
}

- (IBAction) amountValueChanged:(id)sender {
	NSInteger amount = [self userAmount];
		
	BOOL amountNeedsToChange = NO;
	if (amount > [self maxAmountAllowed]) {
		amount = [self maxAmountAllowed];
		amountNeedsToChange = YES;
	}
	
	NSInteger diff = currentBet - amount;
	[self updateNumberLabel:heroStackLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabelForKeyboard addAmount:diff];	
	
	currentBet = amount;
	
	if (amountNeedsToChange)
		[amountTextField setText:[NSString stringWithFormat:@"%d", currentBet]];
}

- (void) saveToApplicationData {
	// double down flags
	SET_BOOLEAN_FLAG(applicationData[1], 2, isFirstHandDoubleDown);
	SET_BOOLEAN_FLAG(applicationData[1], 3, isSecondHandDoubleDown);
	SET_BOOLEAN_FLAG(applicationData[1], 4, isDealerHandSoft);
	SET_BOOLEAN_FLAG(applicationData[1], 5, isHeroFirstHandSoft);
	SET_BOOLEAN_FLAG(applicationData[1], 6, isHeroSecondHandSoft);

	// hand count
	[AppController write2ByteInteger:handCount To:applicationData+2];
	// hero stack (balance - bet amount)
	NSInteger amount = [heroStackLabel.text intValue];
	[AppController write4ByteInteger:amount To:applicationData+4];
	// bet amount
	amount = [amountTextField.text intValue];
	[AppController write4ByteInteger:amount To:applicationData+8];
	// dealer's number of cards
	[AppController write2ByteInteger:dealerCardsNum To:applicationData+12];	
	// hero's number of cards (hand in play)
	[AppController write2ByteInteger:heroCardsNum To:applicationData+14];		
	// hero's number of cards (hand not in play)
	[AppController write2ByteInteger:heroOtherCardsNum To:applicationData+16];
	// dealer hand hard value
	[AppController write2ByteInteger:dealerHandValue To:applicationData+18];
	// hero first hand hard value
	[AppController write2ByteInteger:heroFirstHandValue To:applicationData+20];
	// hero second hand hard value
	[AppController write2ByteInteger:heroSecondHandValue To:applicationData+22];	
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
	
	[handCountLabel setText:@"0"];
	
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
	
	// reset buttons
	[endButton setHidden:NO];
	[hintButton setHidden:YES];
	[hintLabel setText:@""];
	[surrenderButton setHidden:YES];
	
	[self resetButtons];
	
	// reset labels
	[dealerHandLabel setText:@""];
	[heroHandLabel setText:@""];
	[heroFirstHandLabel setText:@""];
	[resultLabel setText:@""];	
	
	[dealerCardsNumLabel setHidden:YES];
	[dealerCardsLabel setHidden:YES];
	[heroCardsNumLabel setHidden:YES];
	[heroCardsLabel setHidden:YES];	
	
	[dealButtonForKeyboard setHidden:YES];
	[heroStackLabelForKeyboard setHidden:YES];
    
    [self stopWaitIndicator];
}

// pre-condition: heroApplicationData[0] == 1 
- (void) willRestoreFromApplicationData:(uint8_t*)heroApplicationData 
{
	//[[Applytics sharedService] log:[[self class] description]];
	
	[self resetStuff];
	
	//[self willDisplayAtHand:0 heroStack:1000];
	//return;
	[self setupInitialScreen];

	// copy data into applicaitonData
	memcpy(applicationData, heroApplicationData, BLACKJACK_APPLICATION_DATA_LENGTH);
	
	// release passed-in hero application data for they are no longer needed
	free(heroApplicationData);
		
	handCount = [AppController read2ByteIntegerFrom:applicationData+2];
	[handCountLabel setText:[NSString stringWithFormat:@"%d", handCount]];
		
	NSInteger heroStack = [AppController read4ByteIntegerFrom:applicationData+4];
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroStack]];
	[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", heroStack]];
	
	currentBet = [AppController read4ByteIntegerFrom:applicationData+8];
	[self setCurrentBet:currentBet];

	// restore cards
	dealerCardsNum = [AppController read2ByteIntegerFrom:applicationData+12];
	heroCardsNum = [AppController read2ByteIntegerFrom:applicationData+14];
	heroOtherCardsNum = [AppController read2ByteIntegerFrom:applicationData+16];
	dealerHandValue = [AppController read2ByteIntegerFrom:applicationData+18];
	heroFirstHandValue = [AppController read2ByteIntegerFrom:applicationData+20];
	heroSecondHandValue = [AppController read2ByteIntegerFrom:applicationData+22];
	
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
	
	for (int cardIndex = 24; cardIndex <= 46; cardIndex++) {
		uint8_t data = applicationData[cardIndex];
		
		NSInteger rank = (data >> 2) & 0x0f;
		NSInteger suit = (data) & 0x03;
		Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
		[deck addCard:card];	
		[card release];
	}
	
	heroCard0View.card = [deck dealOneCard];
	dealerCard0View.card = [deck dealOneCard];
	heroCard1View.card = [deck dealOneCard];
	dealerCard1View.card = [deck dealOneCard];

	BOOL isDealersTurn = GET_BOOLEAN_FLAG(applicationData[1], 0);
	BOOL isHandOver = GET_BOOLEAN_FLAG(applicationData[1], 1);
	isFirstHandDoubleDown = GET_BOOLEAN_FLAG(applicationData[1], 2);
	isSecondHandDoubleDown = GET_BOOLEAN_FLAG(applicationData[1], 3);
	isDealerHandSoft = GET_BOOLEAN_FLAG(applicationData[1], 4);
	isHeroFirstHandSoft = GET_BOOLEAN_FLAG(applicationData[1], 5);
	isHeroSecondHandSoft = GET_BOOLEAN_FLAG(applicationData[1], 6);
	
	if (heroSecondHandValue == 0) {
		isHeroHandSoft = isHeroFirstHandSoft;
		heroHandValue = heroFirstHandValue;
	} else {
		isHeroHandSoft = isHeroSecondHandSoft;
		heroHandValue = heroSecondHandValue;
	}
	
	NSInteger heroHandSoftValue = [self calcHeroHandSoftValue];
	NSInteger heroFirstHandSoftValue = [self calcHeroFirstHandSoftValue];

	[self setEnabledBettingSystem:NO];

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
					
					if (heroOtherCardsNum == 2)
						[doubleButton setHidden:[self heroStack] < [self userAmount]];					
				}
			}
		}
	}
}

// called before the very first hand
- (void) willDisplayAtHand:(NSInteger)count 
				 heroStack:(NSInteger)heroStack
{		
	//[[Applytics sharedService] log:[[self class] description]];
	
	[self resetStuff];
	
	[self setupInitialScreen];
	
	[self setCurrentBet:MIN_BET];
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", (HERO_STACK - currentBet)]];
	[heroStackLabelForKeyboard setText:[NSString stringWithFormat:@"%d", (HERO_STACK - currentBet)]];
	
	[dealButtonForKeyboard setHidden:YES];
	[heroStackLabelForKeyboard setHidden:YES];
}	

@end
