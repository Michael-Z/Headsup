//
//  GameModeView.m
//  Headsup
//
//  Created by Haolan Qin on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameModeView.h"
#import "Constants.h"
#import "Deck.h"
#import "Card.h"
#import "Hand.h"
#import "CardView.h"
#import "AppController.h"
#import "MadeHand.h"
#import "NoLimitHoldemVillainTAG.h"
#import "NoLimitHoldemVillainCS.h"
#import "HoldemHistoryModeView.h"
#import "HoldemHand.h"
#import "Action.h"

#define CHECK_BUTTON_TITLE	@"Check"
#define CALL_BUTTON_TITLE	@"Call"
#define BET_BUTTON_TITLE	@"Bet"
#define RAISE_BUTTON_TITLE	@"Raise"
#define ALLIN_BUTTON_TITLE  @"All-in"

#define CHECK_BUTTON_IMAGE	@"check.png"
#define CALL_BUTTON_IMAGE	@"call.png"
#define BET_BUTTON_IMAGE	@"bet.png"
#define RAISE_BUTTON_IMAGE	@"raise.png"
#define SMALL_BET_BUTTON_IMAGE		@"small_bet.png"
#define SMALL_RAISE_BUTTON_IMAGE	@"small_raise.png"
#define ALLIN_BUTTON_IMAGE  @"all_in.png"

#define POST_BB_ACTION @"BB"
#define POST_SB_ACTION @"SB"
#define FOLD_ACTION @"Fold"
#define CHECK_ACTION @"Check"
#define CALL_ACTION @"Call"
#define BET_ACTION @"Bet"
#define RAISE_ACTION @"Raise to"

#define STATUS_DEALING	@"Dealing..."
#define STATUS_THINKING @"Thinking..."
#define STATUS_WAITING @"Waiting..."
#define STATUS_SHOWDOWN	@"Showdown..."

#define MODE_1_PLAYER @"1p"
#define MODE_2_PLAYERS_IPHONE @"2p"
#define MODE_2_PLAYERS_BLUETOOTH @"2pBT"
#define MODE_2_PLAYERS_GAME_CENTER @"2pGC"


//#define SB 1
//#define BB 2
//#define BUYIN 75*BB

#define DEALING_DELAY 0.5
#define ALL_IN_DEALING_DELAY 3.0
#define SHOWDOWN_DELAY 8.0


@implementation GameModeView

@synthesize navController;
@synthesize appController;

@synthesize heroCard0View;
@synthesize heroCard1View;
@synthesize villainCard0View;
@synthesize villainCard1View;
@synthesize communityCard0View;
@synthesize communityCard1View;
@synthesize communityCard2View;
@synthesize communityCard3View;
@synthesize communityCard4View;
@synthesize heroDealerButton;
@synthesize heroStackLabel;
@synthesize heroActionLabel;
@synthesize heroAmountLabel;
@synthesize heroNameLabel;
@synthesize villainDealerButton;
@synthesize villainStackLabel;
@synthesize villainActionLabel;
@synthesize villainAmountLabel;
@synthesize villainNameLabel;
@synthesize potLabel;
@synthesize whoWonLabel;
@synthesize amountTextField;

@synthesize betRaiseButton;
@synthesize checkCallButton;
@synthesize foldButton;
@synthesize revealMyHandToMyselfButton;
@synthesize peekCounterLabel;

@synthesize howMuchMoreToCallLabel;
@synthesize howMuchMoreToBetRaiseLabel;
@synthesize howMuchMoreToBetRaiseForKeyboardLabel;


@synthesize betRaiseButtonForKeyboard;
@synthesize halfPotButton;
@synthesize potButton;
@synthesize allInButton;
@synthesize lessAmountButton;
@synthesize moreAmountButton;

@synthesize endButton;
@synthesize lobbyButton;
@synthesize historyButton;

@synthesize waitingIndicator;

@synthesize gameNameLabel;
@synthesize handCountLabel;

@synthesize amountSlider;

@synthesize dealer;
@synthesize deck;
@synthesize hand;

@synthesize gameMode;

@synthesize SB;
@synthesize BB;

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

- (BOOL) didHeroMakeNoMove {
	return [[heroActionLabel text] isEqualToString:@""];
}

- (BOOL) didHeroPostBB {
	return [[heroActionLabel text] isEqualToString:POST_BB_ACTION];
}

- (BOOL) didHeroCheck {
	return [[heroActionLabel text] isEqualToString:CHECK_ACTION];
}

- (BOOL) didHeroCall {
	return [[heroActionLabel text] isEqualToString:CALL_ACTION];
}

- (BOOL) didHeroBet {
	return [[heroActionLabel text] isEqualToString:BET_ACTION];
}

- (BOOL) didHeroRaise {
	return [[heroActionLabel text] isEqualToString:RAISE_ACTION];
}

- (BOOL) didVillainPostBB {
	return [[villainActionLabel text] isEqualToString:POST_BB_ACTION];
}

- (BOOL) didVillainCheck {
	return [[villainActionLabel text] isEqualToString:CHECK_ACTION];
}

- (BOOL) didVillainCall {
	return [[villainActionLabel text] isEqualToString:CALL_ACTION];
}

- (BOOL) didVillainBet {
	return [[villainActionLabel text] isEqualToString:BET_ACTION];
}

- (BOOL) didVillainRaise {
	return [[villainActionLabel text] isEqualToString:RAISE_ACTION];
}

- (void) showMyCardsButton {
	if (gameMode == kSinglePhoneMode || 
		((gameMode == kDualPhoneMode || gameMode == kGameCenterMode) && ![[NSUserDefaults standardUserDefaults] boolForKey:KEY_HERO_HOLE_CARDS_FACE_UP])) {
		revealMyHandToMyselfButton.hidden = NO;
		[revealMyHandToMyselfButton setEnabled:YES];
	}
}

- (void) hideMyCardsButton {
	revealMyHandToMyselfButton.hidden = YES;
	[revealMyHandToMyselfButton setNeedsDisplay];
}

- (void) resetStuff {
	[hand release];
	[deck release];
	hand = [[Hand alloc] init];
	deck = [[Deck alloc] init];		
	
	[myVillainDeviceId release];
	myVillainDeviceId = nil;
	
	free(applicationData);
	applicationData = malloc(HOLDEM_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	applicationData[0] = (uint8_t)0;
	
	isHandStarted = NO;	
	
	isDealingGoingOn = NO;
	
	isAllIn = NO;

	// reset end button
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
	
	heroWantsToEndMatch = NO;
	villainWantsToEndMatch = NO;
	
	endButton.hidden = YES;
	[endButton setNeedsDisplay];

	revealMyHandToMyselfButton.hidden = YES;
	[revealMyHandToMyselfButton setNeedsDisplay];

	// to indicate there's no such move yet.
	isMovePostponed = NO;
	
	handCount = 0;	
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
	[hand release];
	[deck release];
	
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

    [super dealloc];
}

- (NSData*) getApplicationData {
	return [[[NSData alloc] initWithBytes:applicationData length:HOLDEM_APPLICATION_DATA_LENGTH] autorelease];
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


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (BOOL) isRaiseAction {
	NSString *betRaiseButtonTitle = [betRaiseButton titleForState:UIControlStateNormal];
	return	[betRaiseButtonTitle isEqualToString:RAISE_BUTTON_TITLE] ||
			[betRaiseButtonTitle isEqualToString:ALLIN_BUTTON_TITLE];
}

- (void) updateNumberLabel:(UILabel*)label addAmount:(NSInteger)amount {
	NSInteger currentValue = [[label text] integerValue];
	[label setText:[NSString stringWithFormat:@"%d", currentValue + amount]];
	[label setNeedsDisplay];
}

- (void) setNumberLabel:(UILabel*)label amount:(NSInteger)amount {
	[label setText:[NSString stringWithFormat:@"%d", amount]];
	[label setNeedsDisplay];
}	

///////////////////////////////
// hero/villain neutral methods
- (NSInteger) retrieveNumberFromLabel:(UILabel*)label {
	return [[label text] integerValue];
}

- (NSInteger) potSize {
	return [self retrieveNumberFromLabel:potLabel];
}

- (NSInteger) userAmount {
	return [[amountTextField text] integerValue];
}

- (NSInteger) heroStackSize {
	return [self retrieveNumberFromLabel:heroStackLabel];
}

- (NSInteger) villainStackSize {
	return [self retrieveNumberFromLabel:villainStackLabel];
}

- (NSInteger) heroBetOrRaiseAmount {
	return [self retrieveNumberFromLabel:heroAmountLabel];
	
}

- (NSInteger) villainBetOrRaiseAmount {
	return [self retrieveNumberFromLabel:villainAmountLabel];
}

// it's villain's turn. what's the effective pot size?
// if villain has enough chips left to at least call, then it's the same as pot size;
// otherwise certain amount needs to be deducted from the pot.
- (NSInteger) effectivePotSizeVillainsTurn {
	NSInteger potSize = [self potSize];
	NSInteger overbetAmount = [self heroBetOrRaiseAmount] - [self villainBetOrRaiseAmount] - [self villainStackSize];
	
	return overbetAmount > 0 ? (potSize - overbetAmount) : potSize;
}

- (NSInteger) potSizedBet {
	NSInteger pot = [self potSize];
	
	return pot / BB * BB;
}

- (NSInteger) halfPotSizedBet {
	NSInteger pot = [self potSize];
	
	return pot / 2 / BB * BB;
}

/////////////////////////////////////////////////////////////
// hero-centric methods
// note that if we find a bug in one of the two groups below,
// we need to fix it in both groups.
- (NSInteger) maxAmountAllowed {
	return [self heroStackSize] + [self heroBetOrRaiseAmount];
}

- (NSInteger) callAmount {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger diff = villainAmount - heroAmount;
	NSInteger heroStackSize = [self heroStackSize];
	if (diff > heroStackSize)
		diff = heroStackSize;

	return diff;
}

- (NSInteger) minRaiseAmount {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	
	NSInteger minRaiseAmount = villainAmount + (villainAmount - heroAmount);
	
	if (minRaiseAmount == BB)
		minRaiseAmount = BB * 2;
	
	if (minRaiseAmount % BB != 0)
		minRaiseAmount = minRaiseAmount / BB * BB + BB; 

	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	
	if (minRaiseAmount > maxAmountAllowed)
		minRaiseAmount = maxAmountAllowed;
	
	return minRaiseAmount;
}

- (NSInteger) potSizedRaise {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger pot = [self potSize];
	NSInteger callingAmount = villainAmount - heroAmount;
	// after calling the new pot size will be (pot + callingAmount);
	NSInteger newPot = pot + callingAmount;
	NSInteger psr = villainAmount + newPot;
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	
	if (psr >= maxAmountAllowed)
		psr = maxAmountAllowed;
	else
		psr = psr / BB * BB;
	
	return psr;
}

- (NSInteger) halfPotSizedRaise {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger pot = [self potSize];
	NSInteger callingAmount = villainAmount - heroAmount;
	// after calling the new pot size will be (pot + callingAmount);
	NSInteger newPot = pot + callingAmount;
	NSInteger psr = villainAmount + newPot / 2;
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	
	if (psr >= maxAmountAllowed)
		psr = maxAmountAllowed;
	else
		psr = psr / BB * BB;
	
	return psr;
}

- (BOOL) putVillainAllIn {
	return [self villainBetOrRaiseAmount] + [self villainStackSize] <= [self userAmount];
}

//////////////////////////
// villain-centric methods
- (NSInteger) maxAmountAllowedForVillain {
	return [self villainStackSize] + [self villainBetOrRaiseAmount];
}

- (NSInteger) callAmountForVillain {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger diff = heroAmount - villainAmount;
	NSInteger villainStackSize = [self villainStackSize];
	if (diff > villainStackSize)
		diff = villainStackSize;
	
	return diff;
}

- (NSInteger) minRaiseAmountForVillain {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	
	NSInteger minRaiseAmount = heroAmount + (heroAmount - villainAmount);
	
	if (minRaiseAmount == BB)
		minRaiseAmount = BB * 2;
	
	if (minRaiseAmount % BB != 0)
		minRaiseAmount = minRaiseAmount / BB * BB + BB; 
	
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (minRaiseAmount > maxAmountAllowed)
		minRaiseAmount = maxAmountAllowed;
	
	return minRaiseAmount;
}

- (NSInteger) potSizedRaiseForVillain {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger pot = [self potSize];
	NSInteger callingAmount = heroAmount - villainAmount;
	// after calling the new pot size will be (pot + callingAmount);
	NSInteger newPot = pot + callingAmount;
	NSInteger psr = heroAmount + newPot;
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (psr >= maxAmountAllowed)
		psr = maxAmountAllowed;
	else
		psr = psr / BB * BB;
	
	return psr;
}

- (NSInteger) nearPotSizedRaiseForVillain {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger pot = [self potSize];
	NSInteger callingAmount = heroAmount - villainAmount;
	// after calling the new pot size will be (pot + callingAmount);
	NSInteger newPot = pot + callingAmount;
	NSInteger psr = heroAmount + newPot * 2 / 3;
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (psr >= maxAmountAllowed)
		psr = maxAmountAllowed;
	else
		psr = psr / BB * BB;
	
	return psr;
}

- (NSInteger) halfPotSizedRaiseForVillain {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger pot = [self potSize];
	NSInteger callingAmount = heroAmount - villainAmount;
	// after calling the new pot size will be (pot + callingAmount);
	NSInteger newPot = pot + callingAmount;
	NSInteger psr = heroAmount + newPot / 2;
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (psr >= maxAmountAllowed)
		psr = maxAmountAllowed;
	else
		psr = psr / BB * BB;
	
	return psr;
}

- (NSInteger) potSizedBetForVillain {
	NSInteger pot = [self potSize];
	NSInteger psb = pot;
	
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (psb >= maxAmountAllowed)
		psb = maxAmountAllowed;
	else
		psb = psb / BB * BB;
	
	return psb;
}

// two thirds psb
- (NSInteger) nearPotSizedBetForVillain {
	NSInteger pot = [self potSize];
	NSInteger psb = pot * 2 / 3;
	
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (psb >= maxAmountAllowed)
		psb = maxAmountAllowed;
	else
		psb = psb / BB * BB;
	
	return psb;
}

- (NSInteger) halfPotSizedBetForVillain {
	NSInteger pot = [self potSize];
	
	NSInteger psb = pot / 2;
	
	NSInteger maxAmountAllowed = [self maxAmountAllowedForVillain];
	
	if (psb >= maxAmountAllowed)
		psb = maxAmountAllowed;
	else
		psb = psb / BB * BB;
	
	return psb;
}


/*- (BOOL) putVillainAllIn {
	return [self villainBetOrRaiseAmount] + [self villainStackSize] <= [self userAmount];
}*/
//////////////////////////////////////////////

- (void) displayAction:(NSString*)action amount:(NSInteger)amount 
		   actionLabel:(UILabel*)actionLabel amountLabel:(UILabel*)amountLabel {
	[actionLabel setText:action];
	
	if (amount == 0)
		[amountLabel setText:@""];
	else
		[amountLabel setText:[NSString stringWithFormat:@"%d", amount]];
	
	[actionLabel setNeedsDisplay];
	[amountLabel setNeedsDisplay];
}


- (void) setEnabledAllButtons: (BOOL)enabled {	
	[betRaiseButton setEnabled:enabled];
	[checkCallButton setEnabled:enabled];
	[revealMyHandToMyselfButton setEnabled:enabled];
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


// hide all three action buttons
- (void) hideAllActionButtons {
	foldButton.hidden = YES;
	checkCallButton.hidden = YES;
	betRaiseButton.hidden = YES;
	
	howMuchMoreToCallLabel.hidden = YES;
	howMuchMoreToBetRaiseLabel.hidden = YES;
	
	amountTextField.hidden = YES;
	amountSlider.hidden = YES;
	
	halfPotButton.hidden = YES;
	potButton.hidden = YES;
	allInButton.hidden = YES;
	
	lessAmountButton.hidden = YES;
	moreAmountButton.hidden = YES;
	
	[foldButton setNeedsDisplay];
	[checkCallButton setNeedsDisplay];
	[betRaiseButton setNeedsDisplay];
	
	[howMuchMoreToCallLabel setNeedsDisplay];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
	
	[amountTextField setNeedsDisplay];
	[amountSlider setNeedsDisplay];
	
	[halfPotButton setNeedsDisplay];
	[potButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	
	[lessAmountButton setNeedsDisplay];
	[moreAmountButton setNeedsDisplay];
}

- (void) setEnabledAllActionButtons:(BOOL)enabled {
	[foldButton setEnabled:enabled];
	[checkCallButton setEnabled:enabled];
	[betRaiseButton setEnabled:enabled];
		
	[amountTextField setEnabled:enabled];
	
	[halfPotButton setEnabled:enabled];
	[potButton setEnabled:enabled];
	[allInButton setEnabled:enabled];
	
	[lessAmountButton setEnabled:enabled];
	[moreAmountButton setEnabled:enabled];
}

// hide all cards and my cards button
- (void) hideAllCardsAndButton {
	if (gameMode == kSinglePlayerMode ||
		((gameMode == kDualPhoneMode || gameMode == kGameCenterMode) && [[NSUserDefaults standardUserDefaults] boolForKey:KEY_HERO_HOLE_CARDS_FACE_UP])) {
		heroCard0View.faceUp = YES;
		heroCard1View.faceUp = YES;
	} else {
		heroCard0View.faceUp = NO;
		heroCard1View.faceUp = NO;
	}
	/*if (gameMode == kSinglePlayerMode) {
		villainCard0View.faceUp = YES;
		villainCard1View.faceUp = YES;
	} else {*/
		villainCard0View.faceUp = NO;
		villainCard1View.faceUp = NO;
	//}
	communityCard0View.faceUp = YES;
	communityCard1View.faceUp = YES;
	communityCard2View.faceUp = YES;
	communityCard3View.faceUp = YES;
	communityCard4View.faceUp = YES;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	communityCard0View.card = nil;
	communityCard1View.card = nil;
	communityCard2View.card = nil;
	communityCard3View.card = nil;
	communityCard4View.card = nil;

	revealMyHandToMyselfButton.hidden = YES;
	[revealMyHandToMyselfButton setNeedsDisplay];
}

- (void) showFoldButton {
	[self playYourTurnSound];
	
	foldButton.hidden = NO;
	[foldButton setEnabled:YES];
}

- (void) showCheckButton {
	[AppController changeTitleOfButton:checkCallButton to:CHECK_BUTTON_TITLE];
	[AppController changeImageOfButton:checkCallButton to:CHECK_BUTTON_IMAGE];
	checkCallButton.hidden = NO;
	[checkCallButton setEnabled:YES];
}

- (void) showCallButton {
	[AppController changeTitleOfButton:checkCallButton to:CALL_BUTTON_TITLE];
	[AppController changeImageOfButton:checkCallButton to:CALL_BUTTON_IMAGE];
	checkCallButton.hidden = NO;
	[checkCallButton setEnabled:YES];
	
	howMuchMoreToCallLabel.hidden = NO;
	[howMuchMoreToCallLabel setText:[NSString stringWithFormat:@"%d", [self callAmount]]];
	[howMuchMoreToCallLabel setNeedsDisplay];
}

- (void) showBetButton {
	[amountTextField setText:[NSString stringWithFormat:@"%d", BB]];
	amountTextField.hidden = NO;
	[amountTextField setEnabled:YES];
	
	howMuchMoreToBetRaiseLabel.hidden = NO;
	NSString *more = [amountTextField text];
	[howMuchMoreToBetRaiseLabel setText:more];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
	[howMuchMoreToBetRaiseForKeyboardLabel setText:more];
	//[more release];
	
	amountSlider.hidden = NO;
	amountSlider.minimumValue = BB;
	amountSlider.maximumValue = [self maxAmountAllowed];
	amountSlider.value = amountSlider.minimumValue;
	[amountSlider setNeedsDisplay];
	
	halfPotButton.hidden = NO;
	potButton.hidden = NO;
	allInButton.hidden = NO;
	lessAmountButton.hidden = NO;
	moreAmountButton.hidden = NO;
	[halfPotButton setEnabled:YES];
	[potButton setEnabled:YES];
	[allInButton setEnabled:YES];
	[lessAmountButton setEnabled:YES];
	[moreAmountButton setEnabled:YES];
	
	[AppController changeTitleOfButton:betRaiseButton to:BET_BUTTON_TITLE];
	[AppController changeImageOfButton:betRaiseButton to:BET_BUTTON_IMAGE];
	betRaiseButton.hidden = NO;
	[betRaiseButton setEnabled:YES];
}

// show raise button if hero has chips left after calling.
// show all-in button if hero has to go all-in if he raises.
- (void) showRaiseButton {
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	NSInteger minRaiseAmount = [self minRaiseAmount];
	
	if (([self villainStackSize] == 0) || 
		(maxAmountAllowed <= villainAmount)) {
		amountTextField.hidden = YES;
		[amountTextField setNeedsDisplay];

		betRaiseButton.hidden = YES;
		[betRaiseButton setNeedsDisplay];
	} else if (maxAmountAllowed <= minRaiseAmount) {
		[amountTextField setText:[NSString stringWithFormat:@"%d", maxAmountAllowed]];
		amountTextField.hidden = NO;
		[amountTextField setEnabled:YES];

		[AppController changeTitleOfButton:betRaiseButton to:ALLIN_BUTTON_TITLE];
		[AppController changeImageOfButton:betRaiseButton to:ALLIN_BUTTON_IMAGE];
		betRaiseButton.hidden = NO;
		[betRaiseButton setEnabled:YES];		
	} else {
		[amountTextField setText:[NSString stringWithFormat:@"%d", minRaiseAmount]];
		amountTextField.hidden = NO;
		[amountTextField setEnabled:YES];
		
		howMuchMoreToBetRaiseLabel.hidden = NO;
		NSString *more = [NSString stringWithFormat:@"%d", minRaiseAmount - [self heroBetOrRaiseAmount]];
		[howMuchMoreToBetRaiseLabel setText:more];
		[howMuchMoreToBetRaiseLabel setNeedsDisplay];
		[howMuchMoreToBetRaiseForKeyboardLabel setText:more];
		//[more release];
		
		amountSlider.hidden = NO;
		amountSlider.minimumValue = minRaiseAmount;
		amountSlider.maximumValue = [self maxAmountAllowed];
		amountSlider.value = amountSlider.minimumValue;
		[amountSlider setNeedsDisplay];
		
		halfPotButton.hidden = NO;
		potButton.hidden = NO;
		allInButton.hidden = NO;
		lessAmountButton.hidden = NO;
		moreAmountButton.hidden = NO;
		[halfPotButton setEnabled:YES];
		[potButton setEnabled:YES];
		[allInButton setEnabled:YES];
		[lessAmountButton setEnabled:YES];
		[moreAmountButton setEnabled:YES];
		

		[AppController changeTitleOfButton:betRaiseButton to:RAISE_BUTTON_TITLE];
		[AppController changeImageOfButton:betRaiseButton to:RAISE_BUTTON_IMAGE];
		betRaiseButton.hidden = NO;
		[betRaiseButton setEnabled:YES];
	}
}

- (BOOL) cardInGroup :(Card*)card :(NSArray*)group {
	BOOL result = NO;
	
	for (Card *aCard in group) {
		if ([[aCard toString] compare:[card toString]] == NSOrderedSame) {
			result = YES;
			break;
		}
	}
	
	return result;
}

- (void) clearApplicationData {
	applicationData[0] = (uint8_t)0;
	[appController
	 writeHoldemApplicationData:[self getApplicationData] 
				villainDeviceId:myVillainDeviceId 
			   gameCenterIdPair:[appController getGameCenterIdPair]
					   gameMode:gameMode];
	
	//?? clear hand history
}

- (void) displayWhoWon {
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSComparisonResult result = [Hand 
								 calcWinnerHoleCard0:heroCard0View.card 
								 holeCard1:heroCard1View.card
								 holeCard2:villainCard0View.card
								 holeCard3:villainCard1View.card
								 communityCard0:communityCard0View.card
								 communityCard1:communityCard1View.card
								 communityCard2:communityCard2View.card
								 communityCard3:communityCard3View.card
								 communityCard4:communityCard4View.card
								 bestHandForFirstPlayer:hand0
								 bestHandForSecondPlayer:hand1];
	
	// award the pot to the winner and update screen.
	if (result == NSOrderedAscending) {
		// villain won
		[whoWonLabel setText:@"You lost"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:villainStackLabel addAmount:[self potSize]];
	} else if (result == NSOrderedDescending) {
		// hero won
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"You won!"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:heroStackLabel addAmount:[self potSize]];
		
		// check achievements
		if (gameMode == kSinglePlayerMode ||
			gameMode == kDualPhoneMode ||
			gameMode == kGameCenterMode) {
			[appController checkAchievementsForHand:hand0];
		}
	} else if (result == NSOrderedSame) {
		// split pot
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"Split pot"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:heroStackLabel addAmount:[self potSize] / 2];
		[self updateNumberLabel:villainStackLabel addAmount:[self potSize] / 2];
	}
	
	
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View,
						  villainCard0View, villainCard1View, communityCard0View, communityCard1View,
						  communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	NSArray* winningHand = (result == NSOrderedAscending) ? hand1.cards : hand0.cards;
	
	for (CardView* cardView in allCards) {
		if (![self cardInGroup:cardView.card :winningHand])
			[cardView dullize];
	}
	
	//
	if ([self heroStackSize] == 0 || [self villainStackSize] == 0)
		[self clearApplicationData];
	
	[allCards release];
	
	[hand0 release];
	[hand1 release];
	
	[endButton setHidden:YES];
	[lobbyButton setHidden:YES];
	showdownTimer = [NSTimer scheduledTimerWithTimeInterval:SHOWDOWN_DELAY target:self selector:@selector(afterDisplayingWhoWonTimerFireMethod) userInfo:nil repeats:NO];
}	

// showdown both hero's and villain's hands.
- (void) showdown {
	[self startWaitIndicator:STATUS_SHOWDOWN];

	[self hideMyCardsButton];
	[self hideAllActionButtons];
	
	[self playShowCardsSound];
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	
	lastHand.isVillainExposed = YES;
	
	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[villainCard0View setNeedsDisplay];
	[villainCard1View setNeedsDisplay];	
}	

// for single phone mode
- (void) swapHeroAndVillain {
	// clear peek counter
	peekCounterLabel.hidden = YES;
	[peekCounterLabel setText:@""];
	[peekCounterLabel setNeedsDisplay];
	
	// swap cards
	Card* heroCard0 = heroCard0View.card;
	Card* heroCard1 = heroCard1View.card;
	Card* villainCard0 = villainCard0View.card;
	Card* villainCard1 = villainCard1View.card;
	
	heroCard0View.card = villainCard0;
	heroCard1View.card = villainCard1;
	villainCard0View.card = heroCard0;
	villainCard1View.card = heroCard1;
	
	// swap player names
	NSString *heroName = [heroNameLabel text];
	NSString *villainName = [villainNameLabel text];
	
	[heroNameLabel setText:villainName];
	[villainNameLabel setText:heroName];
	[heroNameLabel setNeedsDisplay];
	[villainNameLabel setNeedsDisplay];
	
	// swap stack sizes
	NSInteger heroStackSize = [self heroStackSize];
	NSInteger villainStackSize = [self villainStackSize];
	
	[self setNumberLabel:heroStackLabel amount:villainStackSize];
	[self setNumberLabel:villainStackLabel amount:heroStackSize];
	
	// swap actions
	NSString *heroAction = [heroActionLabel text];
	NSString *villainAction = [villainActionLabel text];
	
	[heroActionLabel setText:villainAction];
	[villainActionLabel setText:heroAction];
	[heroActionLabel setNeedsDisplay];
	[villainActionLabel setNeedsDisplay];
	
	NSInteger heroBetOrRaiseAmount = [self heroBetOrRaiseAmount];
	NSInteger villainBetOrRaiseAmount = [self villainBetOrRaiseAmount];
	
	if (villainBetOrRaiseAmount == 0)
		[heroAmountLabel setText:@""];
	else
		[self setNumberLabel:heroAmountLabel amount:villainBetOrRaiseAmount];
	
	if (heroBetOrRaiseAmount == 0)
		[villainAmountLabel setText:@""];
	else
		[self setNumberLabel:villainAmountLabel amount:heroBetOrRaiseAmount];
	
	[heroAmountLabel setNeedsDisplay];
	[villainAmountLabel setNeedsDisplay];
	
	// toggle dealer buttons
	dealer = !dealer;
	heroDealerButton.hidden = !heroDealerButton.hidden;
	villainDealerButton.hidden = !villainDealerButton.hidden;
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
}

- (void) loadHandHistory:(HoldemHand*)holdemHand {
	// the following code is commented because I don't want to release save/load hand
	// history feature just yet. Jul 9, 2010 - Haolan

	/*
	// read history (the list of hands) file into listHands
	// hand
	NSString *fileName = [appController holdemHistoryFileName:myVillainDeviceId gameMode:gameMode];
	NSData *data = [appController readApplicationDataFromFile:fileName];
		
	uint16_t applicationDataLength;
	[data getBytes:&applicationDataLength length:2];
	
	uint8_t *holdemHandData = malloc(applicationDataLength);
	[data getBytes:holdemHandData];
	
	//??
	if (data == nil)
		holdemHandData[0] = (uint8_t)0;
	else
		[data getBytes:holdemHandData];
	
	uint8_t flagByte = holdemHandData[2];
	// 1st bit is reserved for effective data flag. 
	// 1 -> effective data   0 -> data that should be ignored.
	holdemHand.isHeroDealer = GET_BOOLEAN_FLAG(flagByte, 1);
	holdemHand.isVillainExposed = GET_BOOLEAN_FLAG(flagByte, 2);
	holdemHand.handCount = [AppController read2ByteIntegerFrom:holdemHandData+3];
	holdemHand.smallBlind = [AppController read2ByteIntegerFrom:holdemHandData+5]; 
	holdemHand.bigBlind = [AppController read2ByteIntegerFrom:holdemHandData+7]; 
	holdemHand.smallBlindPosted = [AppController read2ByteIntegerFrom:holdemHandData+9]; 
	holdemHand.bigBlindPosted = [AppController read2ByteIntegerFrom:holdemHandData+11]; 
	holdemHand.heroStack = [AppController read4ByteIntegerFrom:holdemHandData+13]; 
	holdemHand.villainStack = [AppController read4ByteIntegerFrom:holdemHandData+17]; 
	
	for (int cardIndex = 0; cardIndex <= 8; cardIndex++) {
		uint8_t data = holdemHandData[21 + cardIndex];
		
		NSInteger rank = (data >> 2) & 0x0f;
		NSInteger suit = (data) & 0x03;
		Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
		if (cardIndex == 0)
			holdemHand.heroCard0 = card;
		else if (cardIndex == 1)
			holdemHand.heroCard1 = card;
		else if (cardIndex == 2)
			holdemHand.villainCard0 = card;
		else if (cardIndex == 3)
			holdemHand.villainCard1 = card;
		else if (cardIndex == 4)
			holdemHand.communityCard0 = card;
		else if (cardIndex == 5)
			holdemHand.communityCard1 = card;
		else if (cardIndex == 6)
			holdemHand.communityCard2 = card;
		else if (cardIndex == 7)
			holdemHand.communityCard3 = card;
		else if (cardIndex == 8)
			holdemHand.communityCard4 = card;
	}
	
	// load hand history
	//[hand.arrActions release];
	//hand.arrActions = nil;
	//holdemHand.arrActions = [[NSMutableArray alloc] init];
	
	// from applicationData[30], 10 bytes per Action
	for (int actionStartIndex=30; actionStartIndex < applicationDataLength; actionStartIndex+=10) {
		Action *action = [[Action alloc] init];
		
		uint8_t flagByte = holdemHandData[actionStartIndex];
		action.isHero = GET_BOOLEAN_FLAG(flagByte, 0);
		action.isHandOver = GET_BOOLEAN_FLAG(flagByte, 1);
		action.isAllIn = GET_BOOLEAN_FLAG(flagByte, 2);
		action.action = holdemHandData[actionStartIndex+1];
		action.amount = [AppController read4ByteIntegerFrom:holdemHandData+actionStartIndex+2];
		action.additionalAmount = [AppController read4ByteIntegerFrom:holdemHandData+actionStartIndex+6];
		
		[holdemHand.arrActions addObject:action];
		[action release];
	}	
	 */
}

- (void) saveLastHand {
	// the following code is commented because I don't want to release save/load hand
	// history feature just yet. Jul 9, 2010 - Haolan
	/*
	if (lastHand != nil) {
		uint16_t handHistoryDataLength = 30 + [lastHand.arrActions count] * 10;
		uint8_t *handHistoryData = malloc(handHistoryDataLength);
		handHistoryData[0] = (uint8_t)0;
		handHistoryData[1] = (uint8_t)0;
		*handHistoryData = handHistoryDataLength;
		uint8_t flagByte = 0;
		SET_BOOLEAN_FLAG(flagByte, 0, 1);
		SET_BOOLEAN_FLAG(flagByte, 1, lastHand.isHeroDealer);
		SET_BOOLEAN_FLAG(flagByte, 2, lastHand.isVillainExposed);
		handHistoryData[2] = flagByte;
		[AppController write2ByteInteger:lastHand.handCount To:handHistoryData+3];
		[AppController write2ByteInteger:lastHand.smallBlind To:handHistoryData+5];
		[AppController write2ByteInteger:lastHand.bigBlind To:handHistoryData+7];
		[AppController write2ByteInteger:lastHand.smallBlindPosted To:handHistoryData+9];
		[AppController write2ByteInteger:lastHand.bigBlindPosted To:handHistoryData+11];
		[AppController write4ByteInteger:lastHand.heroStack To:handHistoryData+13];
		[AppController write4ByteInteger:lastHand.villainStack To:handHistoryData+17];

		NSArray* allCards = [[NSArray arrayWithObjects:
							  lastHand.heroCard0, 
							  lastHand.heroCard1,
							  lastHand.villainCard0, 
							  lastHand.villainCard1, 
							  lastHand.communityCard0, 
							  lastHand.communityCard1,
							  lastHand.communityCard2, 
							  lastHand.communityCard3, 
							  lastHand.communityCard4, 
							  nil] retain];
		
		int cardsNum = [allCards count];
		for (int cardIndex=0; cardIndex<9; cardIndex++) {
			uint8_t cardByte;
			if (cardIndex >= cardsNum) {
				cardByte = 0;
			} else {
				Card *card = [allCards objectAtIndex:cardIndex];
				cardByte = (uint8_t)((card.rank << 2) | card.suit);
			}
			
			handHistoryData[21+cardIndex] = cardByte;
		}
		
		[allCards release];
		
		// actions
		for (int actionIndex=0; actionIndex < [lastHand.arrActions count]; actionIndex++) {
			Action *action = (Action*)[lastHand.arrActions objectAtIndex:actionIndex];
			uint8_t *data = handHistoryData+30+actionIndex*10;
			uint8_t flagByte = 0;
			SET_BOOLEAN_FLAG(flagByte, 0, action.isHero);
			SET_BOOLEAN_FLAG(flagByte, 1, action.isHandOver);
			SET_BOOLEAN_FLAG(flagByte, 2, action.isAllIn);
			data[0] = flagByte;
			data[1] = action.action;
			[AppController write4ByteInteger:action.amount To:data+2];
			[AppController write4ByteInteger:action.additionalAmount To:data+6];			
		}
				
		NSData *handHistoryDataObject = 
		[[NSData alloc] initWithBytes:handHistoryData length:handHistoryDataLength];
		
		NSString *fileName = [appController holdemHistoryFileName:myVillainDeviceId gameMode:gameMode];
		[appController writeApplicationData:handHistoryDataObject toFile:fileName];
		
		NSLog(@"hand history saved to file %@: %d", fileName, handHistoryDataLength);
		
		[handHistoryDataObject release];
		free(handHistoryData);
	}
	*/
}	

// start a new hand. it does nothing when hero is not the dealer for the new hand.
// it deals the new hand as the dealer when hero is the dealer for the new hand.
// note that !dealer means hero is not the dealer for the hand that just ended, which
// indicates hero is the dealer for the new hand.
- (void) startNewHand {	
	// save last hand (stored in variable lastHand) in hand history
	[self saveLastHand];
	
	// reinitialize lastHand
	[lastHand release];
	lastHand = nil;
	lastHand = [[HoldemHand alloc] init];
	
	isAllIn = NO;
	
	if (BUILD == HU_MIXED && handCount % 4 == 0) {
		[self removeFromSuperview];
		[appController 
		 gameEndedAtHand:handCount 
		 game:kGameHoldem 
		 heroStack:[self heroStackSize] 
		 villainStack:[self villainStackSize]
		 smallBlind:SB
		 bigBlind:BB
		];
	} else {		
		if (!isHandStarted) {
			if (gameMode == kSinglePhoneMode) {
				if (dealer)
					[self swapHeroAndVillain];
				
				[self dealNewHandAsDealer];
			} else {
				if (!dealer) {
					[self dealNewHandAsDealer];
				} else {
					if (gameMode == kSinglePlayerMode) {
						[villain dealNewHandAsDealer];
					}
				}
			}
		}
	}
}

- (void) dealNextStreetCards {
	Action *action = [[Action alloc] init];
	
	action.isAllIn = isAllIn;
	
	[hand nextStreet];
	switch (hand.street) {
		case kStreetFlop:
			[self playDealingCardsSound];
			communityCard0View.card = [deck dealOneCard];
			[self playDealingCardsSound];
			communityCard1View.card = [deck dealOneCard];
			[self playDealingCardsSound];
			communityCard2View.card = [deck dealOneCard];
			
			lastHand.communityCard0 = communityCard0View.card;
			lastHand.communityCard1 = communityCard1View.card;
			lastHand.communityCard2 = communityCard2View.card;
			
			action.action = kActionFlop;
			action.isHandOver = NO;
			
			break;
		case kStreetTurn:
			[self playDealingCardsSound];
			communityCard3View.card = [deck dealOneCard];
			
			lastHand.communityCard3 = communityCard3View.card;

			action.action = kActionTurn;
			action.isHandOver = NO;

			break;
		case kStreetRiver:
			[self playDealingCardsSound];
			communityCard4View.card = [deck dealOneCard];
			
			lastHand.communityCard4 = communityCard4View.card;
			
			action.action = kActionRiver;
			action.isHandOver = isAllIn;

			break;
		default:
			NSLog(@"wrong street: %d", hand.street);
			break;
	}	
	
	Action *lastSavedAction = [lastHand.arrActions lastObject];
	
	// store this action in lastHand only if last stored action is not identical
	// to this action. This happens when lastHand is restored from saved data file and
	// this action has been restored as the last action.
	if (lastSavedAction == nil ||
		lastSavedAction.action != action.action) {
		[lastHand.arrActions addObject:action];
	}
	
	[action release];
}

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (gameMode == kDualPhoneMode || gameMode == kGameCenterMode) {
		[self clearApplicationData];
		[navController popViewControllerAnimated:YES];
		[appController setupServer];
	} else {
		if (buttonIndex == 0) {
            if ([AppController isFreeVersion]) {
                //[GSAdEngine displayFullScreenAdForSlotNamed:@"fullscreenSlot"];
                
                [(MyViewController*)appController.viewController.topViewController displayFullscreenAd];
            }
            
			if (gameMode == kSinglePlayerMode) {
				[villain killAllActiveTimers];
				[villain release];
				villain = nil;
				[self clearApplicationData];
			} else if (gameMode == kSinglePhoneMode) {
				[self clearApplicationData];			
			}
			
			dealer = YES;
			
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			NSInteger heroStack = [defaults integerForKey:KEY_NLHOLDEM_HERO_STACK];
			NSInteger villainStack = [defaults integerForKey:KEY_NLHOLDEM_VILLAIN_STACK];
			NSInteger smallBlind = [defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND];
			NSInteger bigBlind = [defaults integerForKey:KEY_NLHOLDEM_BIG_BLIND];	
			
			[self willDisplayAtHand:0
						  heroStack:heroStack 
					   villainStack:villainStack
						 smallBlind:smallBlind
						   bigBlind:bigBlind
					villainDeviceId:nil
						   gameMode:gameMode];	
		} else {
			// do nothing
		}
	}
}

- (BOOL) isMatchOver {
	BOOL over = NO;
	
	if (gameMode == kSinglePlayerMode) {
		if ([self heroStackSize] == 0 || [self villainStackSize] == 0) {
			over = YES;
			
			if ([self villainStackSize] == 0) {
				[appController incrementHighScoreHoldemSinglePlayer];
			}
			
			AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This headsup match is over" 
																message:[self heroStackSize] == 0 ? @"You lost. Sorry" : @"You won. Congratulations!"
															   delegate:self
													  cancelButtonTitle:@"OK" 
													  otherButtonTitles:nil];
			[alertView show];
			[alertView release];			
		}
		
	} else if (gameMode == kSinglePhoneMode) {
			if ([self heroStackSize] == 0 || [self villainStackSize] == 0) {
				over = YES;
				AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
				NSString *heroName = [heroNameLabel text];
				NSString *villainName = [villainNameLabel text];
				BOOL didHeroLose = ([self heroStackSize] == 0);
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This headsup match is over" 
																	message:[NSString stringWithFormat:@"%@ won. %@ lost.",  didHeroLose ? villainName : heroName, didHeroLose ? heroName : villainName]
																   delegate:self
														  cancelButtonTitle:@"OK" 
														  otherButtonTitles:nil];
				[alertView show];
				[alertView release];			
			}
			
	} else {
		if ([self heroStackSize] == 0) {
			// set ignoreOpponentDisconnect flag
			[appController ignoreOpponentDisconnect];

			over = YES;
			AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This headsup match is over" message:@"You lost. Sorry" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];				
		} else if ([self villainStackSize] == 0) {
			// set ignoreOpponentDisconnect flag
			[appController ignoreOpponentDisconnect];

			over = YES;
			
			if (gameMode == kDualPhoneMode) {
				[appController incrementHighScoreHoldemBluetooth];
			} else if (gameMode == kGameCenterMode) {
				[appController incrementHighScoreHoldemInternet];
			}
			
			AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
			UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This headsup match is over" message:@"You won. Congratulations!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alertView show];
			[alertView release];
		}
	}
	
	return over;
}
		

// called after showdown
// we have to be careful with this timer method. even though this is a single-threaded program,
// if hero is not the dealer after this all-in hand, it's possible that this method is triggered
// after the next hand is already dealt!
- (void)afterDisplayingWhoWonTimerFireMethod {
	[showdownTimer invalidate];
	showdownTimer = nil;
	
	[endButton setHidden:(gameMode == kDualPhoneMode || gameMode == kGameCenterMode)];
	[lobbyButton setHidden:(gameMode == kDualPhoneMode || gameMode == kGameCenterMode)];
	
	if (!isHandStarted) {
		// checks if one guy has lost all the chips
		if (![self isMatchOver])
			[self startNewHand];	
	}
}	

- (void)beforeDealingNextStreetTimerFireMethod {
	[self dealNextStreetCards];
	
	if (hand.street == kStreetRiver) {
		[allInDealingTimer invalidate];
		allInDealingTimer = nil;

		[self displayWhoWon];			
	}
	
}	

- (void) killAllActiveTimers {
	[showdownTimer invalidate];
	showdownTimer = nil;
	
	[allInDealingTimer invalidate];
	allInDealingTimer = nil;
	
	[holeCardsDealingTimer invalidate];
	holeCardsDealingTimer = nil;
	
	[villain killAllActiveTimers];
}

- (NSString *) getVillainDeviceId {
	return myVillainDeviceId;
}


- (void) updateAllInFlagInApplicationData {
	SET_BOOLEAN_FLAG(applicationData[1], 1, isAllIn);
}

- (void) handleAllIn {
	//
	isAllIn = YES;
	
	// set the flag in applicationData
	[self updateAllInFlagInApplicationData];
	
	// return uncalled amount
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	
	if (heroAmount > villainAmount) {
		NSInteger uncalledAmount = heroAmount - villainAmount;
		[self updateNumberLabel:heroAmountLabel addAmount:-uncalledAmount];
		[self updateNumberLabel:heroStackLabel addAmount:uncalledAmount];
		[self updateNumberLabel:potLabel addAmount:-uncalledAmount];
		
	} else if (heroAmount < villainAmount) {
		NSInteger uncalledAmount = villainAmount - heroAmount;
		[self updateNumberLabel:villainAmountLabel addAmount:-uncalledAmount];
		[self updateNumberLabel:villainStackLabel addAmount:uncalledAmount];
		[self updateNumberLabel:potLabel addAmount:-uncalledAmount];
	}
	
	[self showdown];
	
	if (hand.street == kStreetRiver) {
		[self displayWhoWon];	
	} else {
		allInDealingTimer = [NSTimer scheduledTimerWithTimeInterval:ALL_IN_DEALING_DELAY target:self selector:@selector(beforeDealingNextStreetTimerFireMethod) userInfo:nil repeats:YES];		
	}
}

- (void) villainsTurnToAct {
	if (gameMode == kSinglePhoneMode) {
		// in this mode, hero is first to act.
		[self swapHeroAndVillain];
		[self playYourTurnSound];
		[self hideAllActionButtons];
		
		if ([self didVillainCheck]) {
			[self showFoldButton];
			[self showCheckButton];
			[self showBetButton];	
		} else if ([self didVillainCall]) {
			[self showFoldButton];
			[self showCheckButton];
			[self showRaiseButton];
		} else if ([self didVillainBet] || [self didVillainRaise]) {
			[self showFoldButton];
			[self showCallButton];
			[self showRaiseButton];
		} else { // villain is first to act in this street.
			[self showFoldButton];
			[self showCheckButton];
			[self showBetButton];			
		}
	} else if (gameMode == kSinglePlayerMode) {
		if ([self didHeroCheck])
			[villain heroChecked:NO];
		else if ([self didHeroCall])
			[villain heroCalled:NO];
		else if ([self didHeroBet])
			[villain heroBet];
		else if ([self didHeroRaise])
			[villain heroRaised];
		else
			[villain villainFirstToAct];
	} else if (gameMode == kDualPhoneMode ||
			   gameMode == kGameCenterMode) {
		[self startWaitIndicator:STATUS_THINKING];
	}
}

- (void) dealNextStreet {
	[self hideAllActionButtons];
	
	if (hand.street == kStreetRiver) {
		// showdown and pause for a few seconds. then deal the next hand.
		[self showdown];
		[self displayWhoWon];	
	} else {
		[self displayAction:@"" amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
		[self displayAction:@"" amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];

		[self dealNextStreetCards];
		
		// it's hero's turn if hero's is not the dealer.
		if (!dealer) {
			[self stopWaitIndicator];
			[self playYourTurnSound];
			[self hideAllActionButtons];
			[self showFoldButton];
			[self showCheckButton];
			[self showBetButton];
		} else {
			[self villainsTurnToAct];
		}
	}
}

- (void)addMove {
	isHandStarted = NO;
	[hand addMove];
}

- (NSInteger) validateAmount {
	NSInteger amount = [self userAmount];
	
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	
	if (amount >= maxAmountAllowed) {
		amount = maxAmountAllowed;
	} else {
		if ([self isRaiseAction]) {
			// raise. minimum raise is the min of max raise and (villain amount + villain raise)
			NSInteger minRaiseAmount = [self minRaiseAmount];
			
			if (amount < minRaiseAmount) {
				amount = minRaiseAmount;
			} else {
				amount = amount / BB * BB;
			}
			
		} else {
			// bet. any amount less than the max is okay as long as it's BB's multiples (1 or more)
			amount = amount / BB * BB;
			
			if (amount < BB)
				amount = BB;
		}
	}
	
	return amount;
}

// called when keyboard is dismissed.
// we need to correct bet/raise when this method is called.
- (void)keyboardDismissed {
	// hide the bet/raise button
	betRaiseButtonForKeyboard.hidden = YES;
	howMuchMoreToBetRaiseForKeyboardLabel.hidden = YES;
	[betRaiseButtonForKeyboard setNeedsDisplay];
	[howMuchMoreToBetRaiseForKeyboardLabel setNeedsDisplay];
	
	// validate user input
	NSInteger amount = [self validateAmount];
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];	
	
	howMuchMoreToBetRaiseLabel.hidden = NO;
	NSString *more = [NSString stringWithFormat:@"%d", [self userAmount]-[self heroBetOrRaiseAmount]];
	[howMuchMoreToBetRaiseLabel setText:more];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
	[howMuchMoreToBetRaiseForKeyboardLabel setText:more];
	//[more release];
}

- (void) keyboardDisplayed {
	if (!betRaiseButton.hidden) {
		if ([self isRaiseAction]) {
			[AppController changeTitleOfButton:betRaiseButtonForKeyboard to:RAISE_BUTTON_TITLE];
			[AppController changeImageOfButton:betRaiseButtonForKeyboard to:SMALL_RAISE_BUTTON_IMAGE];
		} else {
			[AppController changeTitleOfButton:betRaiseButtonForKeyboard to:BET_BUTTON_TITLE];
			[AppController changeImageOfButton:betRaiseButtonForKeyboard to:SMALL_BET_BUTTON_IMAGE];
		}
		
		betRaiseButtonForKeyboard.hidden = NO;
		howMuchMoreToBetRaiseForKeyboardLabel.hidden = NO;
		[betRaiseButtonForKeyboard setNeedsDisplay];
		[howMuchMoreToBetRaiseForKeyboardLabel setNeedsDisplay];
	}
}

- (void) endMatch {
	// stop waiting indicator
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
	
	// kill all timers
	[self killAllActiveTimers];

	// clear application data so this match will NOT be auto-resumed when hero and 
	// villain reconnect.
	//[self clearApplicationData];
	
	// set ignoreOpponentDisconnect flag
	[appController ignoreOpponentDisconnect];
	
	// prompt hero that the match has ended upon mutual agreement.
	UIAlertView* alertView = 
		[[UIAlertView alloc] initWithTitle:@"This headsup match is over" 
							message:@"You both have agreed to end it" 
			delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	[alertView show];
	[alertView release];					
}

- (IBAction) endButtonPressed:(id)sender {
	if (gameMode == kSinglePlayerMode || gameMode == kSinglePhoneMode) {
		UIAlertView* alertView = 
		[[UIAlertView alloc] initWithTitle:@"Reset the game?" 
								   message:nil
								  delegate:self
						 cancelButtonTitle:@"Yes" 
						 otherButtonTitles:@"No", nil];	
		[alertView show];
		[alertView release];	
				
	} else { // gameMode == kDualPhoneMode
		// hero wants to end this match
		heroWantsToEndMatch = YES;
		// send end request to villain
		[appController send:kMoveEndMatch];
		
		if (villainWantsToEndMatch) {
			// villain wants to end this match, too. so let's end it.
			[self endMatch];
		} else {
			// we don't know if villain wants to end it or not. disable this button
			// wait for villain's response.
			[endButton setEnabled:NO];
			
			waitingIndicator.hidden = NO;
			[waitingIndicator startAnimating];
		}
	}
}

- (IBAction) lobbyButtonPressed:(id)sender {
	[self saveToApplicationData];
	
	[appController
	 writeHoldemApplicationData:[self getApplicationData] 
	 villainDeviceId:myVillainDeviceId 
	 gameCenterIdPair:nil
	 gameMode:gameMode];
	
	[self saveLastHand];
	
	//NSLog(@"%@ %@ %d", [navController visibleViewController], [navController topViewController], [[navController viewControllers] count]);
	
	[navController popViewControllerAnimated:YES];
}

- (IBAction) historyButtonPressed:(id)sender {
	// the following code is commented because I don't want to release save/load hand
	// history feature just yet. Jul 9, 2010 - Haolan

	/*
	if (historyViewController == nil) {
		historyViewController = 
		[[MyViewController alloc] initWithNibName:
		 BUILD == HU_FREE || BUILD == HU_HOLDEM_FREE ? @"HoldemHistoryModeAdView" : @"HoldemHistoryModeView" 
										   bundle:[NSBundle mainBundle]];
		
		HoldemHistoryModeView* holdemHistoryModeView = (HoldemHistoryModeView*)[historyViewController view];
		holdemHistoryModeView.navController = navController;
		holdemHistoryModeView.appController = appController;
		holdemHistoryModeView.gameModeView = self;
	}
	
	[navController pushViewController:historyViewController animated:YES];

	HoldemHistoryModeView* holdemHistoryModeView = (HoldemHistoryModeView*)[historyViewController view];
	[holdemHistoryModeView willDisplay];
	 */
}

- (void) villainRequestedToEndMatch {
	// villain wants to end this match
	villainWantsToEndMatch = YES;
	
	if (heroWantsToEndMatch) {
		// hero wants to end this match, too. so let's end it.
		[self endMatch];
	} else {
		// we don't know if hero wants to end it or not.
		// do nothing.
	}
}

- (void) abandonedEndMathRequest {
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
	
	heroWantsToEndMatch = NO;
	villainWantsToEndMatch = NO;
	[endButton setEnabled:YES];
}

- (void) showThinking {
	if (gameMode != kSinglePhoneMode) {
		[self startWaitIndicator:STATUS_THINKING];
	}
}	

- (void) showWaiting {
	if (gameMode == kGameCenterMode) {
		[self startWaitIndicator:STATUS_WAITING];
	}
}

// foldButtonPressed
- (IBAction) fold:(id)sender {
	Action *action = [[Action alloc] init];
	action.action = kActionFold;
	//action.amount = heroAmount + diff;
	//action.additionalAmount = diff;
	// ?? for single phone mode this is not always correct
	action.isHero = YES;
	action.isHandOver = YES;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	[self abandonedEndMathRequest];
	
	[self setEnabledAllActionButtons:NO];

	[self playFoldSound];
	
	[self addMove];

	[self showThinking];
	
	[self displayAction:FOLD_ACTION amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	
	// award the pot to villain
	[self updateNumberLabel:villainStackLabel addAmount:[self potSize]];
	
	// auto-save
	[self saveToApplicationData];
	
	if (gameMode == kSinglePhoneMode) {
		// do nothing
	} else if (gameMode == kSinglePlayerMode) {
		[villain heroFolded];
	} else {
		// hero has just folded. send a message to villain and this hand is over.
		// deal the next hand if we are the dealer.
		[appController send:kMoveFold];
	}
	
	[self startNewHand];
}

- (void) checkButtonPressed {
	Action *action = [[Action alloc] init];
	action.action = kActionCheck;
	//action.amount = heroAmount + diff;
	//action.additionalAmount = diff;
	// ?? for single phone mode this is not always correct
	action.isHero = YES;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	[self playCheckSound];
	
	[self showThinking];
	
	[self displayAction:CHECK_ACTION amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	
	// auto-save
	[self saveToApplicationData];
	
	// hero has just checked. if this is preflop, the street is over.
	// otherwise, if hero's dealer, the street is over because it just went check-check;
	// if hero is not the dealer, it's villain's turn.
	if (hand.street == kStreetPreflop) {
		[self dealNextStreet];
	} else {
		if (dealer) {
			if (hand.street == kStreetRiver)
				action.isHandOver = YES;
			
			[self dealNextStreet];
		} else {
			[self hideAllActionButtons];
			
			BOOL isHandOver = (showdownTimer != nil);
			action.isHandOver = isHandOver;
			
			if (gameMode == kSinglePhoneMode) {
				if (!isHandOver) {
					[self swapHeroAndVillain];
					[self showFoldButton];
					[self showCheckButton];
					[self showBetButton];					
				}
			} else if (gameMode == kSinglePlayerMode) {
				[villain heroChecked:isHandOver];
			}
		}
	}
	
	if (gameMode == kDualPhoneMode || gameMode == kGameCenterMode) {
		[appController send:kMoveCheck];	
	}	
}

- (void) callButtonPressed {
	[self showThinking];
	
	// update numbers
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger diff = [self callAmount];
		
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabel addAmount:-diff];

	[self displayAction:CALL_ACTION amount:(heroAmount + diff) actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	
	// auto-save
	[self saveToApplicationData];
	
	Action *action = [[Action alloc] init];
	action.action = kActionCall;
	action.amount = heroAmount + diff;
	action.additionalAmount = diff;
	// ?? for single phone mode this is not always correct
	action.isHero = YES;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	if ([self heroStackSize] == 0 || [self villainStackSize] == 0) {
		action.isAllIn = YES;
		[self playAllInSound];
		[self handleAllIn];
	} else {
		action.isAllIn = NO;
		[self playCallSound];
	
		// hero's just called. if this is preflop and the very first move then it's 
		// villain's turn; if it's not the first move then the street is over.
		// if this is not preflop, the street is over.
		if ([self didVillainPostBB]) {
			[self hideAllActionButtons];
			
			BOOL isHandOver = (isAllIn || showdownTimer);
			action.isHandOver = isHandOver;
			if (gameMode == kSinglePhoneMode) {
				if (!isHandOver) {
					[self swapHeroAndVillain];
					[self showFoldButton];
					[self showCheckButton];
					[self showRaiseButton];					
				}
			} else if (gameMode == kSinglePlayerMode) {
				[villain heroCalled:isHandOver];
			}
		} else {
			if (hand.street == kStreetRiver)
				action.isHandOver = YES;

			[self dealNextStreet];
		}
	}
	
	if (gameMode == kDualPhoneMode || gameMode == kGameCenterMode) {
		[appController send:kMoveCall];
	}	
}

- (IBAction) checkCall:(id)sender {
	[self abandonedEndMathRequest];

	[self setEnabledAllActionButtons:NO];

	[self addMove];

	if ([[checkCallButton titleForState:UIControlStateNormal] compare:CHECK_BUTTON_TITLE] == NSOrderedSame) {
		[self checkButtonPressed];		
	} else {
		[self callButtonPressed];
	}
}

- (void) betButtonPressed:(NSInteger)amount {	
	if (([self heroStackSize] == 0) || [self putVillainAllIn])
		[self playAllInSound];
	else
		[self playBetSound];
	
	[self showThinking];
	
	[self hideAllActionButtons];
	
	[amountTextField setText:@""];
	[amountTextField setNeedsDisplay];
	
	if (gameMode == kSinglePhoneMode) {
		[self swapHeroAndVillain];
		[self showFoldButton];
		[self showCallButton];
		[self showRaiseButton];		
	} else if (gameMode == kSinglePlayerMode) {
		[villain heroBet];
	} else {			
		uint8_t *message = malloc(5 * sizeof(uint8_t));
		message[0] = (uint8_t)kMoveBet;
		message[1] = (uint8_t)((amount >> 24) & 0xff);
		message[2] = (uint8_t)((amount >> 16) & 0xff);
		message[3] = (uint8_t)((amount >>  8) & 0xff);
		message[4] = (uint8_t)( amount        & 0xff);
		
		[appController sendArray:message size:5];
		free(message);	
	}	
}

- (void) raiseButtonPressed:(NSInteger)amount {
	if (([self heroStackSize] == 0) || [self putVillainAllIn])
		[self playAllInSound];
	else
		[self playRaiseSound];
	
	[self showThinking];
			
	[self hideAllActionButtons];
	
	[amountTextField setText:@""];
	[amountTextField setNeedsDisplay];
	
	if (gameMode == kSinglePhoneMode) {
		[self swapHeroAndVillain];
		[self showFoldButton];
		[self showCallButton];
		[self showRaiseButton];		
	} else if (gameMode == kSinglePlayerMode) {
		[villain heroRaised];
	} else {		
		uint8_t *message = malloc(5 * sizeof(uint8_t));
		message[0] = (uint8_t)kMoveRaise;
		message[1] = (uint8_t)((amount >> 24) & 0xff);
		message[2] = (uint8_t)((amount >> 16) & 0xff);
		message[3] = (uint8_t)((amount >>  8) & 0xff);
		message[4] = (uint8_t)( amount        & 0xff);
		
		[appController sendArray:message size:5];
		free(message);
	}	
}

- (void) betRaiseButtonPressed {
	[self setEnabledAllActionButtons:NO];

	// update numbers
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger newHeroAmount = [self userAmount];
	NSInteger diff = newHeroAmount - heroAmount;	
	NSInteger heroStackSize = [self heroStackSize];
	if (diff > heroStackSize)
		diff = heroStackSize;
	
	newHeroAmount = heroAmount + diff;
	
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabel addAmount:-diff];
	
	[self addMove];
	
	Action *action = [[Action alloc] init];
	//action.action = kActionBet;
	action.amount = newHeroAmount;
	action.additionalAmount = diff;
	// ?? for single phone mode this is not always correct
	action.isHero = YES;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	if ([self isRaiseAction]) {
		action.action = kActionRaise;
		[self displayAction:RAISE_ACTION amount:newHeroAmount actionLabel:heroActionLabel amountLabel:heroAmountLabel];
		// auto-save
		[self saveToApplicationData];
		[self raiseButtonPressed:newHeroAmount];
	} else {
		action.action = kActionBet;
		[self displayAction:BET_ACTION amount:newHeroAmount actionLabel:heroActionLabel amountLabel:heroAmountLabel];
		// auto-save
		[self saveToApplicationData];
		[self betButtonPressed:newHeroAmount];
	}
}	

- (IBAction) betRaise:(id)sender {
	[self abandonedEndMathRequest];

	[self betRaiseButtonPressed];
}

- (IBAction) revealMyHandToMyself:(id)sender {
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	
	if (gameMode == kSinglePhoneMode) {
		peekCounterLabel.hidden = NO;
		NSString *peekCountString = [peekCounterLabel text];
		
		NSInteger peekCount = [peekCountString intValue] + 1;
		
		[peekCounterLabel setText:[NSString stringWithFormat:@"%d", peekCount]];
		[peekCounterLabel setNeedsDisplay];
	}
}

- (IBAction) concealMyHand:(id)sender {
	// if isAllIn is YES, we always want to show hole cards.
	if (!isAllIn) {
		heroCard0View.faceUp = NO;
		heroCard1View.faceUp = NO;
		[heroCard0View setNeedsDisplay];
		[heroCard1View setNeedsDisplay];
	}
}

- (IBAction) betRaiseButtonForKeyboardPressed:(id)sender {
	// dismiss the keyboard
	[amountTextField resignFirstResponder];
	
	// trigger bet/raise action
	[self betRaiseButtonPressed];
}

- (IBAction) halfPotButtonPressed:(id)sender {
	NSInteger amount = [self isRaiseAction] ? [self halfPotSizedRaise] : [self halfPotSizedBet];
	
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];
	[amountTextField setNeedsDisplay];	
	
	[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", amount - [self heroBetOrRaiseAmount]]];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
}

- (IBAction) potButtonPressed:(id)sender {
	NSInteger amount = [self isRaiseAction] ? [self potSizedRaise] : [self potSizedBet];
	
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];
	[amountTextField setNeedsDisplay];
	
	[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", amount - [self heroBetOrRaiseAmount]]];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
}

- (IBAction) allInButtonPressed:(id)sender {
	NSInteger amount = [self maxAmountAllowed];
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];
	[amountTextField setNeedsDisplay];
	
	[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", amount - [self heroBetOrRaiseAmount]]];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
}

- (IBAction) lessAmountButtonPressed:(id)sender {
	NSInteger amount = [self userAmount] - BB;
	NSInteger minAmountAllowed = [self isRaiseAction] ? [self minRaiseAmount] : BB;
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	
	if (minAmountAllowed > maxAmountAllowed)
		minAmountAllowed = maxAmountAllowed;
	
	if (amount < minAmountAllowed)
		amount = minAmountAllowed;
	
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];
	[amountTextField setNeedsDisplay];
	
	[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", amount - [self heroBetOrRaiseAmount]]];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
}

- (IBAction) moreAmountButtonPressed:(id)sender {
	NSInteger amount = [self userAmount] + BB;
	NSInteger maxAmountAllowed = [self maxAmountAllowed];
	if (amount > maxAmountAllowed)
		amount = maxAmountAllowed;
	
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];
	[amountTextField setNeedsDisplay];
	
	[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", amount - [self heroBetOrRaiseAmount]]];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
}

- (void) setAmountInTextFieldBasedOnSliderValueWithMidValue:(NSInteger)midValue{
	NSInteger sliderValue = amountSlider.value;
	NSInteger min = amountSlider.minimumValue;
	NSInteger max = amountSlider.maximumValue;
	NSInteger mid = (max-min) /2;

	NSInteger amountValue = 0;
	
	if (midValue >= mid) {
		amountValue = sliderValue;
	} else {
		float a, b;
		if (sliderValue <= mid) {
			a = 2.0 * (midValue - min) / (max - 3*min);
			b = (1-a)*min;
		} else {
			a = 2.0 * (max - midValue) / (max + min);
			b = (1-a)*max;
		}
		
		amountValue = a * sliderValue + b;
	}
	
	amountValue = amountValue / BB * BB;
	[amountTextField setText:[NSString stringWithFormat:@"%d", amountValue]];
	[amountTextField setNeedsDisplay];
}	

- (IBAction) amountSliderThumbMoved:(id)sender {
	/*NSInteger amount = amountSlider.value;
	amount = amount / BB * BB;
	[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];
	[amountTextField setNeedsDisplay];*/
	
	
	NSInteger midValue = [self isRaiseAction] ? 1.2 * [self potSizedRaise] : 1.5 * [self potSize];
	
	[self setAmountInTextFieldBasedOnSliderValueWithMidValue:midValue];
}

- (IBAction) amountValueChanged:(id)sender {
	NSInteger amount = [self userAmount];
	
	if (amount > [self maxAmountAllowed]) {
		amount = [self maxAmountAllowed];
		[amountTextField setText:[NSString stringWithFormat:@"%d", amount]];	
	} else {
		NSString *howMuchMore = [NSString stringWithFormat:@"%d",[self userAmount] - [self heroBetOrRaiseAmount]];
		[howMuchMoreToBetRaiseForKeyboardLabel setText:howMuchMore];
		[howMuchMoreToBetRaiseForKeyboardLabel setNeedsDisplay];
		
		[howMuchMoreToBetRaiseLabel setText:howMuchMore];
		[howMuchMoreToBetRaiseLabel setNeedsDisplay];		
	}
}

- (void) villainFolded {
	Action *action = [[Action alloc] init];
	action.action = kActionFold;
	action.isHero = NO;
	action.isHandOver = YES;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	[self displayAction:FOLD_ACTION amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// award the pot to hero
	[self playHeroWonPotSound];
	[self updateNumberLabel:heroStackLabel addAmount:[self potSize]];
	
	// auto-save
	[self saveToApplicationData];
	
	// villain has just folded. the hand is over. start a new 
	// hand if we are the new dealer. otherwise just wait for
	// the cards.
	[self startNewHand];
}

- (void) villainChecked {	
	Action *action = [[Action alloc] init];
	action.action = kActionCheck;
	action.isHero = NO;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	[self displayAction:CHECK_ACTION amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// auto-save
	[self saveToApplicationData];

	// villain has just checked. if this is preflop, the street is over.
	// otherwise, if hero's not the dealer, the street is over because it just went check-check;
	// if hero is the dealer, it's hero's turn.
	if (hand.street == kStreetPreflop) {
		[self dealNextStreet];
	} else {
		if (dealer) {
			[self stopWaitIndicator];

			[self hideAllActionButtons];
			[self showFoldButton];
			[self showCheckButton];
			[self showBetButton];
		} else {
			if (hand.street == kStreetRiver)
				action.isHandOver = YES;

			[self dealNextStreet];
		}
	}
}

- (void) villainCalled {
	// update numbers
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger diff = heroAmount - villainAmount;
	NSInteger villainStackSize = [self villainStackSize];
	if (diff > villainStackSize)
		diff = villainStackSize;
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:villainStackLabel addAmount:-diff];
	
	[self displayAction:CALL_ACTION amount:(villainAmount + diff) actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// auto-save
	[self saveToApplicationData];
	
	Action *action = [[Action alloc] init];
	action.action = kActionCall;
	action.amount = villainAmount + diff;
	action.additionalAmount = diff;
	action.isHero = NO;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];
	
	if ([self heroStackSize] == 0 || [self villainStackSize] == 0) {
		action.isAllIn = YES;
		if (hand.street == kStreetRiver)
			action.isHandOver = YES;
		
		[self handleAllIn];
	} else {
	
		// villain has just called. if this is preflop and the call was the very first move then it's 
		// hero's turn; if it's not the first move then the street is over.
		// if this is not preflop, the street is over.
		
		// villain has just called. if this is preflop, it's hero's turn.
		// otherwise the street is over. if it's the river then the hand 
		// is over as well. otherwise deal the next street.
		if ([self didHeroPostBB]) {
			[self stopWaitIndicator];

			[self hideAllActionButtons];
			[self showFoldButton];
			[self showCheckButton];
			[self showRaiseButton];
		} else {
			if (hand.street == kStreetRiver)
				action.isHandOver = YES;

			[self dealNextStreet];
		}
	}
}

- (void) villainBetAmount:(NSInteger)amount {
	// villain has just bet. it's hero's turn.
	[self stopWaitIndicator];
	
	// update numbers
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger diff = amount - villainAmount;
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:villainStackLabel addAmount:-diff];	
	
	[self displayAction:BET_ACTION amount:amount actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// auto-save
	[self saveToApplicationData];
	
	Action *action = [[Action alloc] init];
	action.action = kActionBet;
	action.amount = villainAmount + diff;
	action.additionalAmount = diff;
	action.isHero = NO;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];	
	[action release];

	// show buttons for hero
	[self showFoldButton];
	[self showCallButton];
	[self showRaiseButton];
}

- (void) villainRaisedToAmount:(NSInteger)amount {
	// villain has just raised. it's hero's turn.
	[self stopWaitIndicator];
	
	// update numbers
	NSInteger villainAmount = [self villainBetOrRaiseAmount];
	NSInteger diff = amount - villainAmount;
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:villainStackLabel addAmount:-diff];	
	
	[self displayAction:RAISE_ACTION amount:amount actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// auto-save
	[self saveToApplicationData];
	
	Action *action = [[Action alloc] init];
	action.action = kActionRaise;
	action.amount = villainAmount + diff;
	action.additionalAmount = diff;
	action.isHero = NO;
	action.isHandOver = NO;
	action.isAllIn = NO;
	
	[lastHand.arrActions addObject:action];		
	[action release];

	// show buttons for hero
	[self showFoldButton];
	[self showCallButton];
	[self showRaiseButton];
}

- (void) handleVillainsMove:(enum MoveType) move amount:(NSInteger)amount {
	[self showThinking];
	
	[self addMove];
	
	if (move == kMoveFold) {
		[self villainFolded];
	} else if (move == kMoveCheck) {
		[self villainChecked];
	} else if (move == kMoveCall) {
		[self villainCalled];
	} else if (move == kMoveBet ||
			   move == kMoveRaise) {
		if (move == kMoveBet)
			[self villainBetAmount:amount];
		else if (move == kMoveRaise)
			[self villainRaisedToAmount:amount];
	}
}	

- (void) villainMadeAMove:(enum MoveType) move amount:(NSInteger)amount {
	[self abandonedEndMathRequest];

	if (isDealingGoingOn) {
		// this is villain (dealer)'s first move and hero's dealing is not over yet.
		// handling of this move must be postponed.
		NSLog(@"move postponed");
		isMovePostponed = YES;
		postponedVillainsFirstMove = move;
		postponedVillainsFirstMoveAmount = amount;
	} else {
		//
		[self handleVillainsMove:move amount:amount];
	}
}

- (uint8_t) getByteForAction:(NSString*) action {
	uint8_t retval = (uint8_t)0;
	
	if ([action isEqualToString:@""])
		retval = (uint8_t)0;
	else if ([action isEqualToString:POST_BB_ACTION])
		retval = (uint8_t)1;
	else if ([action isEqualToString:POST_SB_ACTION])
		retval = (uint8_t)2;
	else if ([action isEqualToString:FOLD_ACTION])
		retval = (uint8_t)3;
	else if ([action isEqualToString:CHECK_ACTION])
		retval = (uint8_t)4;
	else if ([action isEqualToString:CALL_ACTION])
		retval = (uint8_t)5;
	else if ([action isEqualToString:BET_ACTION])
		retval = (uint8_t)6;
	else if ([action isEqualToString:RAISE_ACTION])
		retval = (uint8_t)7;
	
	return retval;
}	

- (NSString*) getActionForByte:(uint8_t) action {
	NSString *retval = @"";
	
	if (action == 0)
		retval = @"";
	else if (action == 1)
		retval = POST_BB_ACTION;
	else if (action == 2)
		retval = POST_SB_ACTION;
	else if (action == 3)
		retval = FOLD_ACTION;
	else if (action == 4)
		retval = CHECK_ACTION;
	else if (action == 5)
		retval = CALL_ACTION;
	else if (action == 6)
		retval = BET_ACTION;
	else if (action == 7)
		retval = RAISE_ACTION;
	
	return retval;
}	


- (void) saveToApplicationData {
	//dealer button
	SET_BOOLEAN_FLAG(applicationData[1], 0, dealer);

	// move count
	applicationData[4] = (uint8_t)hand.moveCount;
	// villain stack
	NSInteger amount = [self villainStackSize];
	applicationData[5] = (uint8_t)((amount >> 24) & 0xff);
	applicationData[6] = (uint8_t)((amount >> 16) & 0xff);
	applicationData[7] = (uint8_t)((amount >>  8) & 0xff);
	applicationData[8] = (uint8_t)( amount        & 0xff);
	// hero stack
	amount = [self heroStackSize];
	applicationData[ 9] = (uint8_t)((amount >> 24) & 0xff);
	applicationData[10] = (uint8_t)((amount >> 16) & 0xff);
	applicationData[11] = (uint8_t)((amount >>  8) & 0xff);
	applicationData[12] = (uint8_t)( amount        & 0xff);
	// small blind
	applicationData[13] = (uint8_t)((SB >> 8) & 0xff);
	applicationData[14] = (uint8_t)( SB       & 0xff);
	// big blind
	applicationData[15] = (uint8_t)((BB >> 8) & 0xff);
	applicationData[16] = (uint8_t)( BB       & 0xff);
	// pot size
	amount = [self potSize];
	applicationData[17] = (uint8_t)((amount >> 24) & 0xff);
	applicationData[18] = (uint8_t)((amount >> 16) & 0xff);
	applicationData[19] = (uint8_t)((amount >>  8) & 0xff);
	applicationData[20] = (uint8_t)( amount        & 0xff);
	// villain action
	applicationData[21] = [self getByteForAction:[villainActionLabel text]];
	// villain amount
	amount = [self villainBetOrRaiseAmount];
	applicationData[22] = (uint8_t)((amount >> 24) & 0xff);
	applicationData[23] = (uint8_t)((amount >> 16) & 0xff);
	applicationData[24] = (uint8_t)((amount >>  8) & 0xff);
	applicationData[25] = (uint8_t)( amount        & 0xff);
	// hero action
	applicationData[26] = [self getByteForAction:[heroActionLabel text]];
	// hero amount
	amount = [self heroBetOrRaiseAmount];
	applicationData[27] = (uint8_t)((amount >> 24) & 0xff);
	applicationData[28] = (uint8_t)((amount >> 16) & 0xff);
	applicationData[29] = (uint8_t)((amount >>  8) & 0xff);
	applicationData[30] = (uint8_t)( amount        & 0xff);
	// street
	applicationData[31] = (uint8_t)hand.street;
}	

- (NSString*) getGameModeLabelString {
	NSString *retval = @"";
	
	if (gameMode == kSinglePlayerMode) {
		retval = MODE_1_PLAYER;
	} else if (gameMode == kSinglePhoneMode) {
		retval = MODE_2_PLAYERS_IPHONE;
	} else if (gameMode == kDualPhoneMode) {
		retval = MODE_2_PLAYERS_BLUETOOTH;
	} else if (gameMode == kGameCenterMode) {
		retval = MODE_2_PLAYERS_GAME_CENTER;
	}
	
	return retval;
}

// pre-condition: heroApplicationData[0] == 1 or villainApplicationData[0] == 1
//                they can't both be 0.
- (void) willRestoreFromHeroApplicationData:(uint8_t*)heroApplicationData 
					 villainApplicationData:(uint8_t*)villainApplicationData
							villainDeviceId:(NSString*)villainDeviceId
								   gameMode:(enum GameMode)mode
{
	// set single player mode
	gameMode = mode;
	[gameModeLabel setText:[self getGameModeLabelString]];
	
	[self stopWaitIndicator];
	
	//[[Applytics sharedService] 
	 //log:[NSString stringWithFormat:@"%@ %d", [[self class] description], gameMode]];
	
	[lastHand release];
	lastHand = nil;
	lastHand = [[HoldemHand alloc] init];
	[self loadHandHistory:lastHand];
	
	[self resetStuff];
	
	if (gameMode == kSinglePlayerMode) {
		villain = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_ADVANCED_AI] ?
					[[NoLimitHoldemVillainTAG alloc] initWithGameModeView:self] :		
					[[NoLimitHoldemVillainCS alloc] initWithGameModeView:self];
	}	

	// saves villain device id
	myVillainDeviceId = villainDeviceId;
	
	// first set up a clean interface
	[self setupInitialScreen];
	
	// pick either hero's or villain's application data
	// based on applicationData[0] == 1?, bigger hand count?, bigger move count?
	// bigger device id string? in that order.
	BOOL isHeroPicked = NO;
	uint8_t *data;
	
	if (gameMode != kDualPhoneMode && gameMode != kGameCenterMode) {
		isHeroPicked = YES;
		data = heroApplicationData;
	} else {
		if (villainApplicationData[0] == 0) {
			isHeroPicked = YES;
			data = heroApplicationData;
		} else if (heroApplicationData[0] == 0) {
			isHeroPicked = NO;
			data = villainApplicationData;
		} else {
			// both applicationData[0] == 1
			NSInteger heroHandCount = ((heroApplicationData[2] << 8)  & 0xff00) |
									   (heroApplicationData[3]        & 0x00ff); 
			
			NSInteger villainHandCount = ((villainApplicationData[2] << 8)  & 0xff00) |
										  (villainApplicationData[3]        & 0x00ff); 
			
			if (heroHandCount > villainHandCount) {
				isHeroPicked = YES;
				data = heroApplicationData;
			} else if (heroHandCount < villainHandCount) {
				isHeroPicked = NO;
				data = villainApplicationData;
			} else { // if (heroHandCount == villainHandCount)
				NSInteger heroMoveCount = heroApplicationData[4];
				NSInteger villainMoveCount = villainApplicationData[4];
				
				if (heroMoveCount > villainMoveCount) {
					isHeroPicked = YES;
					data = heroApplicationData;
				} else if (heroMoveCount < villainMoveCount) {
					isHeroPicked = NO;
					data = villainApplicationData;
				} else { // if (heroMoveCount == villainMoveCount)
					
					NSComparisonResult result = NSOrderedDescending;
					
					if (gameMode == kGameCenterMode) {
						result = [appController.localPlayerId compare:appController.remotePlayerId];
					} else {
						NSString *heroDeviceId = [AppController getDeviceId]; //[[UIDevice currentDevice] uniqueIdentifier];
						result = [heroDeviceId compare:villainDeviceId];
					}
					
					isHeroPicked = (result == NSOrderedDescending);
					data = isHeroPicked ? heroApplicationData : villainApplicationData;
				}
			}
		}
	}

	// copy data into applicaitonData
	memcpy(applicationData, data, HOLDEM_APPLICATION_DATA_LENGTH);
	
	// release passed-in hero/villain application data for they are no longer needed
	free(heroApplicationData);
	free(villainApplicationData);
	
	dealer = (GET_BOOLEAN_FLAG(applicationData[1], 0) == isHeroPicked);
	isAllIn = GET_BOOLEAN_FLAG(applicationData[1], 1);
	heroDealerButton.hidden = !dealer;
	villainDealerButton.hidden = dealer;
	[self.heroDealerButton setNeedsDisplay];
	[self.villainDealerButton setNeedsDisplay];
		
	handCount = ((applicationData[2] << 8)  & 0xff00) |
				 (applicationData[3]        & 0x00ff); 
	[handCountLabel setText:[NSString stringWithFormat:@"%d", handCount]];
	
	// the following code is commented because I don't want to release save/load hand
	// history feature just yet. Jul 9, 2010 - Haolan
	/*
	if (gameMode == kSinglePlayerMode &&
		handCount >= 1) {
		[historyButton setHidden:NO];
	} else {
		[historyButton setHidden:YES];
	}*/
	
	if (gameMode == kSinglePhoneMode) {
		if (handCount % 2 != dealer) {
			NSString *heroName = [heroNameLabel text];
			NSString *villainName = [villainNameLabel text];
			
			[heroNameLabel setText:villainName];
			[villainNameLabel setText:heroName];
			[heroNameLabel setNeedsDisplay];
			[villainNameLabel setNeedsDisplay];
		}
	}
	
	hand.moveCount = applicationData[4];
	
	NSInteger heroStackIndex = isHeroPicked ? 9 : 5;
	NSInteger heroStack = ((applicationData[heroStackIndex  ] << 24) & 0xff000000) |
						  ((applicationData[heroStackIndex+1] << 16) & 0x00ff0000) |
						  ((applicationData[heroStackIndex+2] << 8)  & 0x0000ff00) |
						   (applicationData[heroStackIndex+3]        & 0x000000ff); 
	
	NSInteger villainStackIndex = isHeroPicked ? 5 : 9;
	NSInteger villainStack = ((applicationData[villainStackIndex  ] << 24) & 0xff000000) |
							 ((applicationData[villainStackIndex+1] << 16) & 0x00ff0000) |
							 ((applicationData[villainStackIndex+2] << 8)  & 0x0000ff00) |
							  (applicationData[villainStackIndex+3]        & 0x000000ff); 	
	
	SB = ((applicationData[13] << 8)  & 0xff00) |
		  (applicationData[14]        & 0x00ff); 	

	BB = ((applicationData[15] << 8)  & 0xff00) |
		  (applicationData[16]        & 0x00ff); 	

	NSInteger pot = ((applicationData[17] << 24) & 0xff000000) |
					((applicationData[18] << 16) & 0x00ff0000) |
					((applicationData[19] << 8)  & 0x0000ff00) |
					 (applicationData[20]        & 0x000000ff); 	

	[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroStack]];
	[villainStackLabel setText:[NSString stringWithFormat:@"%d", villainStack]];
	[potLabel setText:[NSString stringWithFormat:@"%d", pot]];
	
	NSInteger heroActionIndex = isHeroPicked ? 26 : 21;
	[heroActionLabel setText:[self getActionForByte:applicationData[heroActionIndex]]];
	
	NSInteger heroAmountIndex = isHeroPicked ? 27 : 22;
	NSInteger heroAmount = ((applicationData[heroAmountIndex  ] << 24) & 0xff000000) |
						   ((applicationData[heroAmountIndex+1] << 16) & 0x00ff0000) |
						   ((applicationData[heroAmountIndex+2] << 8)  & 0x0000ff00) |
							(applicationData[heroAmountIndex+3]        & 0x000000ff); 
	
	if (heroAmount > 0)
		[heroAmountLabel setText:[NSString stringWithFormat:@"%d", heroAmount]];

	NSInteger villainActionIndex = isHeroPicked ? 21 : 26;
	[villainActionLabel setText:[self getActionForByte:applicationData[villainActionIndex]]];

	NSInteger villainAmountIndex = isHeroPicked ? 22 : 27;
	NSInteger villainAmount = ((applicationData[villainAmountIndex  ] << 24) & 0xff000000) |
						   ((applicationData[villainAmountIndex+1] << 16) & 0x00ff0000) |
						   ((applicationData[villainAmountIndex+2] << 8)  & 0x0000ff00) |
							(applicationData[villainAmountIndex+3]        & 0x000000ff); 
	
	if (villainAmount > 0)
		[villainAmountLabel setText:[NSString stringWithFormat:@"%d", villainAmount]];
	
	hand.street = applicationData[31];
	
	// restore 9 cards
	for (int cardIndex = 32; cardIndex <= 40; cardIndex++) {
		uint8_t data = applicationData[cardIndex];
		
		NSInteger rank = (data >> 2) & 0x0f;
		NSInteger suit = (data) & 0x03;
		Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
		[deck addCard:card];	
		[card release];
	}
	
	// check if the hand is over
	if ([[heroActionLabel text] isEqualToString:FOLD_ACTION] ||
		[[villainActionLabel text] isEqualToString:FOLD_ACTION]) {
		[self startNewHand];
		return;
	}
	
	// this hand is not over yet.
	// deal cards
	if (dealer) {
		heroCard0View.card = [deck dealOneCard];
		villainCard0View.card = [deck dealOneCard];
		heroCard1View.card = [deck dealOneCard];
		villainCard1View.card = [deck dealOneCard];
	} else {
		villainCard0View.card = [deck dealOneCard];
		heroCard0View.card = [deck dealOneCard];
		villainCard1View.card = [deck dealOneCard];
		heroCard1View.card = [deck dealOneCard];
	}
	
	if (hand.street == kStreetPreflop) {
	} else {
		communityCard0View.card = [deck dealOneCard];
		communityCard1View.card = [deck dealOneCard];
		communityCard2View.card = [deck dealOneCard];
		
		if (hand.street == kStreetFlop) {
		} else {
			communityCard3View.card = [deck dealOneCard];
			
			if (hand.street == kStreetTurn) {
			} else { // if (hand.street == kStreetRiver)
				communityCard4View.card = [deck dealOneCard];
			}
		}
	}
	
	// show peek button
	[self showMyCardsButton];
	
	// check if it's all-in
	if (isAllIn) {
		[self playAllInSound];
		[self handleAllIn];
	} else {
		// not all-in yet
		if (hand.street == kStreetPreflop) {
			// check if this street is over
			if (([[heroActionLabel text] isEqualToString:CHECK_ACTION] ||
				 [[villainActionLabel text] isEqualToString:CHECK_ACTION]) ||
				((([[heroActionLabel text] isEqualToString:CALL_ACTION] ||
				  [[villainActionLabel text] isEqualToString:CALL_ACTION])) &&
				![self didHeroPostBB] && ![self didVillainPostBB] &&
				[self heroBetOrRaiseAmount] == [self villainBetOrRaiseAmount])) {
				// this street is over
				[self dealNextStreet];
			} else {
				// this street is not over
				// check if it's hero's turn to act.
				if (dealer) {
					if ([[heroActionLabel text] isEqualToString:POST_SB_ACTION]) {
						[self showFoldButton];
						[self showCallButton];
						[self showRaiseButton];
					} else if ([self heroBetOrRaiseAmount] < [self villainBetOrRaiseAmount]) {
						[self showFoldButton];
						[self showCallButton];
						[self showRaiseButton];
					} else {
						[self villainsTurnToAct];
					}
				} else {
					if ([[villainActionLabel text] isEqualToString:CALL_ACTION] &&
						[[heroActionLabel text] isEqualToString:POST_BB_ACTION]) {
						[self showFoldButton];
						[self showCheckButton];
						[self showRaiseButton];
					} else if ([self heroBetOrRaiseAmount] < [self villainBetOrRaiseAmount]) {
						[self showFoldButton];
						[self showCallButton];
						[self showRaiseButton];
					} else {
						[self villainsTurnToAct];
					}					
				}
				
			}

		} else {
			if (([[heroActionLabel text] isEqualToString:CALL_ACTION] ||
				 [[villainActionLabel text] isEqualToString:CALL_ACTION]) ||
				(dealer &&
				 [[heroActionLabel text] isEqualToString:CHECK_ACTION]) ||
				(!dealer &&
				 [[villainActionLabel text] isEqualToString:CHECK_ACTION])) {
				// this street is over
				[self dealNextStreet];
			} else {
				// this street is not over
				// check if it's hero's turn to act.
				if (dealer) {
					if ([[villainActionLabel text] isEqualToString:CHECK_ACTION] &&
						[[heroActionLabel text] isEqualToString:@""]) {
						[self showFoldButton];
						[self showCheckButton];
						[self showBetButton];
					} else if ([self heroBetOrRaiseAmount] < [self villainBetOrRaiseAmount]) {
						[self showFoldButton];
						[self showCallButton];
						[self showRaiseButton];
					} else {
						[self villainsTurnToAct];
					}					
				} else {
					if ([[heroActionLabel text] isEqualToString:@""]) {
						[self showFoldButton];
						[self showCheckButton];
						[self showBetButton];
					} else if ([self heroBetOrRaiseAmount] < [self villainBetOrRaiseAmount]) {
						[self showFoldButton];
						[self showCallButton];
						[self showRaiseButton];
					} else {
						[self villainsTurnToAct];
					}					
				}
			}
			
		}
	}	
}

- (void) resetForNewHand {
	[handCountLabel setText:[NSString stringWithFormat:@"%d", ++handCount]];
	
	// the following code is commented because I don't want to release save/load hand
	// history feature just yet. Jul 9, 2010 - Haolan
	/*
	if (gameMode == kSinglePlayerMode &&
		handCount >= 1) {
		[historyButton setHidden:NO];
	} else {
		[historyButton setHidden:YES];
	}*/
		
	if (gameMode == kSinglePlayerMode ||
		((gameMode == kDualPhoneMode || gameMode == kGameCenterMode) && [[NSUserDefaults standardUserDefaults] boolForKey:KEY_HERO_HOLE_CARDS_FACE_UP])) {
		heroCard0View.faceUp = YES;
		heroCard1View.faceUp = YES;
	} else {
		heroCard0View.faceUp = NO;
		heroCard1View.faceUp = NO;
	}
	/*if (gameMode == kSinglePlayerMode) {
		villainCard0View.faceUp = YES;
		villainCard1View.faceUp = YES;
	} else {*/
		villainCard0View.faceUp = NO;
		villainCard1View.faceUp = NO;
	//}
	communityCard0View.faceUp = YES;
	communityCard1View.faceUp = YES;
	communityCard2View.faceUp = YES;
	communityCard3View.faceUp = YES;
	communityCard4View.faceUp = YES;	
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	communityCard0View.card = nil;
	communityCard1View.card = nil;
	communityCard2View.card = nil;
	communityCard3View.card = nil;
	communityCard4View.card = nil;	
	
	[hand newHand];
	
	// auto-save point
	// dealer button
	applicationData[1] = (uint8_t)0;
	SET_BOOLEAN_FLAG(applicationData[1], 0, dealer);
	// all-in flag
	[self updateAllInFlagInApplicationData];
	// hand count
	applicationData[2] = (uint8_t)((handCount >>  8) & 0xff);
	applicationData[3] = (uint8_t)( handCount        & 0xff);
	// save applicationData[4-31]
	[self saveToApplicationData];
	// cards applicationData[32-40] have already been set
	
	// flag bit
	applicationData[0] = (uint8_t)1;	
}

- (void) dealFirstCardNonDealer {
	[self playDealingCardsSound];
	villainCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard0View.card = [deck dealOneCard];

	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];

	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardNonDealerTimerMethod {
	holeCardsDealingTimer = nil;
	
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	lastHand.heroCard0 = heroCard0View.card;
	lastHand.heroCard1 = heroCard1View.card;
	lastHand.villainCard0 = villainCard0View.card;
	lastHand.villainCard1 = villainCard1View.card;
	[self showMyCardsButton];	
	
	isDealingGoingOn = NO;

	[self showThinking];
		
	if (([self villainStackSize] == 0) ||
		(([self heroStackSize] == 0) && ([self heroBetOrRaiseAmount] <= [self villainBetOrRaiseAmount]))) {
		// this is necessary to set isHandStarted correctly because this is a special "no move all-in" hand.
		[self addMove];
		[self handleAllIn];
	}
	
	if (isMovePostponed) {
		NSLog(@"handling postponed move");
		
		isMovePostponed = NO;
		[self handleVillainsMove:postponedVillainsFirstMove amount:postponedVillainsFirstMoveAmount];		
	}
	
	if (gameMode == kSinglePlayerMode) {
		[villain villainFirstToAct];
	}	
}

- (void) saveToLastHand:(NSInteger)trueBBAmount {
	lastHand.isHeroDealer = dealer;
	lastHand.isVillainExposed = NO;
	lastHand.handCount = handCount;
	lastHand.smallBlind = SB;
	lastHand.bigBlind = BB;
	lastHand.smallBlindPosted = SB;
	lastHand.bigBlindPosted = trueBBAmount;
	lastHand.heroStack = [self heroStackSize];
	lastHand.villainStack = [self villainStackSize];
}	

// hero is not the dealer.
// called when kMoveCards is received by this phone.
// note that because the showdown method is triggered by a timer,
// it's possible that when this is called, the match over check has NOT
// been performed yet, meaning one of the players could already be out of
// chips at this point.
- (void) dealNewHandAsNonDealer {	
	if ([self isMatchOver])
		return;
	
	[self startWaitIndicator:STATUS_DEALING];

	// 
	isHandStarted = YES;	
	
	isDealingGoingOn = YES;

	// hero is not the dealer. update gui to reflect that.
	dealer = NO;
	heroDealerButton.hidden = YES;
	villainDealerButton.hidden = NO;
	[self.heroDealerButton setNeedsDisplay];
	[self.villainDealerButton setNeedsDisplay];
	
	[whoWonLabel setText:@""];
	[whoWonLabel setNeedsDisplay];
	
	[self hideAllCardsAndButton];
	[self hideAllActionButtons];
	
	// hero's stack might be < a big blind
	NSInteger heroStackSize = [self heroStackSize];
	NSInteger trueBBAmount = (heroStackSize <= BB) ? heroStackSize : BB;
	
	[self updateNumberLabel:heroStackLabel addAmount:-trueBBAmount];
	[self updateNumberLabel:villainStackLabel addAmount:-SB];	
	
	[potLabel setText:[NSString stringWithFormat:@"%d", trueBBAmount+SB]];
	
	[self displayAction:POST_BB_ACTION amount:trueBBAmount actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	[self displayAction:POST_SB_ACTION amount:SB actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	[self resetForNewHand];
	
	[self saveToLastHand:trueBBAmount];
	
	[self dealFirstCardNonDealer];
	
	/*[self dealNewHand];
	
	[self startWaitIndicator];

	isHandStarted = YES;	
	
	if (([self villainStackSize] == 0) ||
		([self heroStackSize] == 0) && ([self heroBetOrRaiseAmount] <= [self villainBetOrRaiseAmount])) {
		// this is necessary to set isHandStarted correctly because this is a special "no move all-in" hand.
		[self addMove];
		[self handleAllIn];
	}*/
}

- (void) dealFirstCardDealer {
	[self playDealingCardsSound];
	heroCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardDealerTimerMethod {
	holeCardsDealingTimer = nil;
	
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];
	lastHand.heroCard0 = heroCard0View.card;
	lastHand.heroCard1 = heroCard1View.card;
	lastHand.villainCard0 = villainCard0View.card;
	lastHand.villainCard1 = villainCard1View.card;	
	[self showMyCardsButton];	
	
	isDealingGoingOn = NO;
	
	if (([self heroStackSize] == 0) ||
		(([self villainStackSize] == 0) && ([self villainBetOrRaiseAmount] <= [self heroBetOrRaiseAmount]))) {
		// this is necessary to set isHandStarted correctly because this is a special "no move all-in" hand.
		[self addMove];
		[self handleAllIn];
	} else {		
		[self showFoldButton];
		[self showCallButton];
		[self showRaiseButton];	
		
		[self stopWaitIndicator];
	}
}

- (void) saveToApplicationDataAtIndex:(NSInteger)index card:(uint8_t)data {
	applicationData[32+index] = data;
}

// hero is the dealer.
- (void) dealNewHandAsDealer {	
	[self startWaitIndicator:STATUS_DEALING];

	isDealingGoingOn = YES;

	// hero is the dealer. update gui to reflect that.
	dealer = YES;
	heroDealerButton.hidden = NO;
	villainDealerButton.hidden = YES;
	[self.heroDealerButton setNeedsDisplay];
	[self.villainDealerButton setNeedsDisplay];
	
	[whoWonLabel setText:@""];
	[whoWonLabel setNeedsDisplay];
	
	[self hideAllCardsAndButton];
	[self hideAllActionButtons];
		
	[deck shuffleUpAndDeal:kHandHoldem];
	// send cards to the other phone
	uint8_t *message = malloc(10 * sizeof(uint8_t));
	message[0] = (uint8_t)kMoveCards;
	NSInteger cardsCount = [deck getNumOfCards];
	for (int i=1; i <= cardsCount; i++) {
		Card *card = [deck getCardAtIndex:i-1];
		message[i] = (uint8_t)((card.rank << 2) | card.suit);
	}
	
	for (int i=1; i <= cardsCount; i++) {
		applicationData[31+i] = message[i];
	}
	
	if (gameMode == kDualPhoneMode || gameMode == kGameCenterMode)
		[appController sendArray:message size:10];
	free(message);
	
	// villain's stack might be < a big blind
	NSInteger villainStackSize = [self villainStackSize];
	NSInteger trueBBAmount = (villainStackSize <= BB) ? villainStackSize : BB;
	
	[self updateNumberLabel:heroStackLabel addAmount:-SB];
	[self updateNumberLabel:villainStackLabel addAmount:-trueBBAmount];	
	
	[potLabel setText:[NSString stringWithFormat:@"%d", trueBBAmount+SB]];
	
	[self displayAction:POST_SB_ACTION amount:SB actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	[self displayAction:POST_BB_ACTION amount:trueBBAmount actionLabel:villainActionLabel amountLabel:villainAmountLabel];	
	
	[self resetForNewHand];
	
	[self saveToLastHand:trueBBAmount];

	[self dealFirstCardDealer];
	
	/*
	[self dealNewHand];
	
	if (([self heroStackSize] == 0) ||
		([self villainStackSize] == 0) && ([self villainBetOrRaiseAmount] <= [self heroBetOrRaiseAmount])) {
		// this is necessary to set isHandStarted correctly because this is a special "no move all-in" hand.
		[self addMove];
		[self handleAllIn];
	} else {		
		[self showFoldButton];
		[self showCallButton];
		[self showRaiseButton];	
		
		[self stopWaitIndicator];
	}*/
}

- (void) setupInitialScreen {
	[handCountLabel setText:@"0"];
	
	if (gameMode == kSinglePlayerMode ||
		((gameMode == kDualPhoneMode || gameMode == kGameCenterMode) && [[NSUserDefaults standardUserDefaults] boolForKey:KEY_HERO_HOLE_CARDS_FACE_UP])) {
		heroCard0View.faceUp = YES;
		heroCard1View.faceUp = YES;
	} else {
		heroCard0View.faceUp = NO;
		heroCard1View.faceUp = NO;
	}
	/*if (gameMode == kSinglePlayerMode) {
		villainCard0View.faceUp = YES;
		villainCard1View.faceUp = YES;
	} else {*/
		villainCard0View.faceUp = NO;
		villainCard1View.faceUp = NO;
	//}
	communityCard0View.faceUp = YES;
	communityCard1View.faceUp = YES;
	communityCard2View.faceUp = YES;
	communityCard3View.faceUp = YES;
	communityCard4View.faceUp = YES;	
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	communityCard0View.card = nil;
	communityCard1View.card = nil;
	communityCard2View.card = nil;
	communityCard3View.card = nil;
	communityCard4View.card = nil;
	
	[self hideMyCardsButton];
	[self hideAllActionButtons];
	
	heroDealerButton.hidden = YES;
	villainDealerButton.hidden = YES;
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	
	[heroActionLabel setText:@""];
	[heroAmountLabel setText:@""];
	[villainActionLabel setText:@""];
	[villainAmountLabel setText:@""];
	[potLabel setText:@""];
	[howMuchMoreToCallLabel setText:@""];
	[howMuchMoreToBetRaiseLabel setText:@""];
	[whoWonLabel setText:@""];
	
	[heroActionLabel setNeedsDisplay];
	[heroAmountLabel setNeedsDisplay];
	[villainActionLabel setNeedsDisplay];
	[villainAmountLabel setNeedsDisplay];
	[potLabel setNeedsDisplay];
	[howMuchMoreToCallLabel setNeedsDisplay];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
	[whoWonLabel setNeedsDisplay];

	[endButton setHidden:(gameMode == kDualPhoneMode || gameMode == kGameCenterMode)];
	[lobbyButton setHidden:(gameMode == kDualPhoneMode || gameMode == kGameCenterMode)];
	
	[self showMyCardsButton];
	
	// single phone mode
	[heroNameLabel setText:@""];
	[villainNameLabel setText:@""];
	peekCounterLabel.hidden = YES;
	[peekCounterLabel setText:@""];
	
	if (gameMode == kSinglePhoneMode || gameMode == kGameCenterMode) {
		[heroNameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_HERO_NAME]];
		[villainNameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_VILLAIN_NAME]];
	}
	
	[heroNameLabel setNeedsDisplay];
	[villainNameLabel setNeedsDisplay];
	[peekCounterLabel setNeedsDisplay];
	
	//[heroStackLabel setText:[NSString stringWithFormat:@"%d", BUYIN]];
	//[villainStackLabel setText:[NSString stringWithFormat:@"%d", BUYIN]];
}

- (void) updateHeroAndVillainNames {
	[heroNameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_HERO_NAME]];
	[villainNameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_VILLAIN_NAME]];
}

// called before the very first hand
- (void) willDisplayAtHand:(NSInteger)count 
				 heroStack:(NSInteger)heroStack 
			  villainStack:(NSInteger)villainStack 
				smallBlind:(NSInteger)smallBlind
				  bigBlind:(NSInteger)bigBlind
		   villainDeviceId:(NSString*)villainDeviceId
				  gameMode:(enum GameMode)mode
{	
	// set game mode
	gameMode = mode;
	[gameModeLabel setText:[self getGameModeLabelString]];
	
	[historyButton setHidden:YES];
	
	//[[Applytics sharedService] 
	 //log:[NSString stringWithFormat:@"%@ %d", [[self class] description], gameMode]];
	
	[self resetStuff];
	
	if (gameMode == kSinglePlayerMode) {
		villain = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_ADVANCED_AI] ?
					[[NoLimitHoldemVillainTAG alloc] initWithGameModeView:self] :		
					[[NoLimitHoldemVillainCS alloc] initWithGameModeView:self];
	}
	
	// saves villain device id
	myVillainDeviceId = villainDeviceId;
	
	handCount = count;
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", heroStack]];
	[villainStackLabel setText:[NSString stringWithFormat:@"%d", villainStack]];
	SB = smallBlind;
	BB = bigBlind;
	
	isMovePostponed = NO;
	isAllIn = NO;
	// isHandStarted means we have already received cards from the other phone, which indicates
	// villain's the dealer for this hand while hero's the BB. In that case nothing needs to
	// be done.
	if (!isHandStarted) {
		[self setupInitialScreen];
		// check if hero is the dealer for the first hand.
		if (dealer)
			[self dealNewHandAsDealer];
	}
}	

- (void) processRightSwipe {
	if (!lobbyButton.hidden && lobbyButton.enabled) {
		NSLog(@"right swipe");
	}
}

- (void) processLeftSwipe {
	if (!historyButton.hidden && historyButton.enabled) {
		NSLog(@"left swipe");
	}
}

#define HORIZ_SWIPE_DRAG_MIN 130 
#define VERT_SWIPE_DRAG_MAX	50
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject]; 
	startTouchPosition = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject]; CGPoint currentTouchPosition = [touch locationInView:self];
	// If the swipe tracks correctly.
	if (fabsf(startTouchPosition.x - currentTouchPosition.x) >= HORIZ_SWIPE_DRAG_MIN &&
		fabsf(startTouchPosition.y - currentTouchPosition.y) <= VERT_SWIPE_DRAG_MAX)
	{
		// It appears to be a swipe. 
		if (startTouchPosition.x < currentTouchPosition.x)
			[self processRightSwipe]; //[self myProcessRightSwipe:touches withEvent:event]; 
		else
			[self processLeftSwipe]; //[self myProcessLeftSwipe:touches withEvent:event];
	} else {
		// Process a non-swipe event.
	}
}


@end
