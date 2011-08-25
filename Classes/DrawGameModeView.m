//
//  GameModeView.m
//  Headsup
//
//  Created by Haolan Qin on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DrawGameModeView.h"
#import "Constants.h"
#import "Deck.h"
#import "Card.h"
#import "Hand.h"
#import "CardView.h"
#import "AppController.h"
#import "MadeHand.h"

#define CHECK_BUTTON_TITLE	@"Check"
#define CALL_BUTTON_TITLE	@"Call"
#define COMPLETE_BUTTON_TITLE @"Complete"
#define BET_BUTTON_TITLE	@"Bet"
#define RAISE_BUTTON_TITLE	@"Raise"
#define CAP_BUTTON_TITLE	@"Cap"
#define ALLIN_BUTTON_TITLE  @"All-in"

#define POST_BB_ACTION @"BB"
#define POST_SB_ACTION @"SB"
#define FOLD_ACTION @"Fold"
#define CHECK_ACTION @"Check"
#define CALL_ACTION @"Call"
#define BET_ACTION @"Bet"
#define RAISE_ACTION @"Raise to"
#define CAP_ACTION @"Cap at"
#define ALLIN_ACTION @"All-in"
#define PAT_ACTION @"Pat"
#define DISCARD_ACTION @"Draw"

#define ANTE 20
#define BRING_IN 25 
#define SB 200
#define BB 400
#define BUYIN 4*BB

#define DEALING_DELAY 0.2
#define ALL_IN_DEALING_DELAY 1.0
#define SHOWDOWN_DELAY 8.0

#define PAT_BUTTON_TITLE @"Stand Pat"
#define DISCARD_BUTTON_TITLE @"Discard"


@implementation DrawGameModeView

@synthesize heroCard0View;
@synthesize heroCard1View;
@synthesize heroCard2View;
@synthesize heroCard3View;
@synthesize heroCard4View;

@synthesize villainCard0View;
@synthesize villainCard1View;
@synthesize villainCard2View;
@synthesize villainCard3View;
@synthesize villainCard4View;

@synthesize heroDealerButton;
@synthesize heroStackLabel;
@synthesize heroActionLabel;
@synthesize heroAmountLabel;
@synthesize heroDrawActionLabel;
@synthesize villainDealerButton;
@synthesize villainStackLabel;
@synthesize villainActionLabel;
@synthesize villainAmountLabel;
@synthesize villainDrawActionLabel;

@synthesize potLabel;
@synthesize whoWonLabel;

@synthesize betRaiseButton;
@synthesize checkCallButton;
@synthesize foldButton;
@synthesize revealMyHandToMyselfButton;
@synthesize patDiscardButton;

@synthesize howMuchMoreToCallLabel;
@synthesize howMuchMoreToBetRaiseLabel;

@synthesize gameNameLabel;
@synthesize handCountLabel;

@synthesize dealer;
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


- (void)setUpStuff {
	hand = [[Hand alloc] init];
	deck = [[Deck alloc] init];		
	
	isHandStarted = NO;	
	
	isDealingGoingOn = NO;
	
	herosTurnToDraw = NO;
	
	// to indicate there's no such move yet.
	isMovePostponed = NO;
	
	handCount = 0;
	
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

- (void) playYourTurnSound {
	AudioServicesPlaySystemSound (self.soundFileObject);
}	

- (void) playFoldSound {
	AudioServicesPlaySystemSound (self.foldSoundFileObject);	
}

- (void) playCheckSound {
	AudioServicesPlaySystemSound (self.checkSoundFileObject);	
}

- (void) playCallSound {
	AudioServicesPlaySystemSound (self.callSoundFileObject);	
}

- (void) playBetSound {
	AudioServicesPlaySystemSound (self.betSoundFileObject);	
}

- (void) playRaiseSound {
	AudioServicesPlaySystemSound (self.raiseSoundFileObject);	
}

- (void) playDealingCardsSound {
	AudioServicesPlaySystemSound (self.dealingCardsSoundFileObject);	
}

- (void) playAllInSound {
	AudioServicesPlaySystemSound (self.allInSoundFileObject);	
}

- (void) playHeroWonPotSound {
	AudioServicesPlaySystemSound (self.wonPotSoundFileObject);	
}

- (void) playShowCardsSound {
	AudioServicesPlaySystemSound (self.showCardsSoundFileObject);	
}



- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (BOOL) isBetAction {
	NSString *betRaiseButtonTitle = [betRaiseButton titleForState:UIControlStateNormal];
	return	[betRaiseButtonTitle isEqualToString:BET_BUTTON_TITLE] ||
	[betRaiseButtonTitle isEqualToString:COMPLETE_BUTTON_TITLE];
}

- (BOOL) isBetAllInAction {
	NSString *betRaiseButtonTitle = [betRaiseButton titleForState:UIControlStateNormal];
	return	
	[betRaiseButtonTitle isEqualToString:ALLIN_BUTTON_TITLE] && 
	![[heroActionLabel text] isEqualToString:BET_ACTION];
}

- (BOOL) isRaiseAction {
	NSString *betRaiseButtonTitle = [betRaiseButton titleForState:UIControlStateNormal];
	return	[betRaiseButtonTitle isEqualToString:RAISE_BUTTON_TITLE];
}

- (BOOL) isCapAction {
	NSString *betRaiseButtonTitle = [betRaiseButton titleForState:UIControlStateNormal];
	return	[betRaiseButtonTitle isEqualToString:CAP_BUTTON_TITLE];
}

- (BOOL) isRaiseAllInAction {
	NSString *betRaiseButtonTitle = [betRaiseButton titleForState:UIControlStateNormal];
	return	
		[betRaiseButtonTitle isEqualToString:ALLIN_BUTTON_TITLE] && 
		[[heroActionLabel text] isEqualToString:BET_ACTION];
}

- (void) updateNumberLabel:(UILabel*)label addAmount:(NSInteger)amount {
	NSInteger currentValue = [[label text] integerValue];
	[label setText:[NSString stringWithFormat:@"%d", currentValue + amount]];
	[label setNeedsDisplay];
}

- (NSInteger) retrieveNumberFromLabel:(UILabel*)label {
	return [[label text] integerValue];
}

- (NSInteger) potSize {
	return [self retrieveNumberFromLabel:potLabel];
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

- (NSInteger) heroRaiseToAmount {
	NSInteger raiseToAmount = [self villainBetOrRaiseAmount] + (hand.isBigBetStreet ? BB : SB);
	NSInteger maxAmount = [self maxAmountAllowed];
	
	if (raiseToAmount > maxAmount)
		raiseToAmount = maxAmount;
	
	return raiseToAmount;
}

- (NSInteger) heroBetAmount {
	NSInteger betAmount = [hand isBigBetStreet] ? BB : SB;
	NSInteger maxAmount = [self maxAmountAllowed];
	
	if (betAmount > maxAmount)
		betAmount = maxAmount;
	
	return betAmount;	
}

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

- (void) displayDrawAction:(enum MoveType)move numDiscardedCards:(NSInteger)num
		   actionLabel:(UILabel*)actionLabel {
	if (move == kMovePat)
		[actionLabel setText:PAT_ACTION];
	else if (move == kMoveDiscard)
		[actionLabel setText:[NSString stringWithFormat:@"%@ %d", DISCARD_ACTION, num]];
	
	[actionLabel setNeedsDisplay];
}


- (void) changeTitleOfButton:(UIButton*)button to:(NSString*)title {
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateDisabled];
	[button setTitle:title forState:UIControlStateSelected];
	[button setNeedsDisplay];	
}

- (void) startWaitIndicator {
	//waitingIndicator.hidden = NO;
	//[waitingIndicator startAnimating];
}

- (void) stopWaitIndicator {
	//waitingIndicator.hidden = YES;
	//[waitingIndicator stopAnimating];
}


// hide all four action buttons
- (void) hideAllActionButtons {
	foldButton.hidden = YES;
	checkCallButton.hidden = YES;
	betRaiseButton.hidden = YES;
	patDiscardButton.hidden = YES;
	howMuchMoreToCallLabel.hidden = YES;
	howMuchMoreToBetRaiseLabel.hidden = YES;
		
	[foldButton setNeedsDisplay];
	[checkCallButton setNeedsDisplay];
	[betRaiseButton setNeedsDisplay];
	[patDiscardButton setNeedsDisplay];
	
	[howMuchMoreToCallLabel setNeedsDisplay];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
}

- (void) setEnabledAllActionButtons:(BOOL)enabled {
	[foldButton setEnabled:enabled];
	[checkCallButton setEnabled:enabled];
	[betRaiseButton setEnabled:enabled];		
}

// hide all cards and my cards button
- (void) hideAllCardsAndButton {
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = NO;
	heroCard3View.faceUp = NO;
	heroCard4View.faceUp = NO;

	villainCard0View.faceUp = NO;
	villainCard1View.faceUp = NO;
	villainCard2View.faceUp = NO;
	villainCard3View.faceUp = NO;
	villainCard4View.faceUp = NO;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
	
	revealMyHandToMyselfButton.hidden = YES;
	[revealMyHandToMyselfButton setNeedsDisplay];
}

- (void) showFoldButton {
	[self playYourTurnSound];
	
	foldButton.hidden = NO;
	[foldButton setEnabled:YES];
}

- (void) showCheckButton {
	[self changeTitleOfButton:checkCallButton to:CHECK_BUTTON_TITLE];
	checkCallButton.hidden = NO;
	[checkCallButton setEnabled:YES];
}

- (void) showCallButton {
	[self changeTitleOfButton:checkCallButton to:CALL_BUTTON_TITLE];
	checkCallButton.hidden = NO;
	[checkCallButton setEnabled:YES];	
	
	howMuchMoreToCallLabel.hidden = NO;
	[howMuchMoreToCallLabel setText:[NSString stringWithFormat:@"%d", [self callAmount]]];
	[howMuchMoreToCallLabel setNeedsDisplay];	
}

- (void) showBetButton {	
	if ([self heroBetAmount] >= [self heroStackSize])
		[self changeTitleOfButton:betRaiseButton to:ALLIN_BUTTON_TITLE];
	else
		[self changeTitleOfButton:betRaiseButton to:BET_BUTTON_TITLE];
	betRaiseButton.hidden = NO;
	[betRaiseButton setEnabled:YES];
	
	howMuchMoreToBetRaiseLabel.hidden = NO;
	[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", [self heroBetAmount]]];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];		
}

// show raise button if hero has chips left after calling.
// show all-in button if hero has to go all-in if he raises.
- (void) showRaiseButton {
	if (([self villainStackSize] == 0) || 
		([self maxAmountAllowed] <= [self villainBetOrRaiseAmount])) {
		betRaiseButton.hidden = YES;
		[betRaiseButton setNeedsDisplay];
	} else {
		NSString* raiseOrCap = 
		[self heroRaiseToAmount] - [self heroBetOrRaiseAmount] >= [self heroStackSize] ?
		ALLIN_BUTTON_TITLE :
		((hand.raiseCount == 2) ? CAP_BUTTON_TITLE : RAISE_BUTTON_TITLE);
		
		[self changeTitleOfButton:betRaiseButton to:raiseOrCap];
		betRaiseButton.hidden = NO;
		[betRaiseButton setEnabled:YES];	
		
		howMuchMoreToBetRaiseLabel.hidden = NO;
		[howMuchMoreToBetRaiseLabel setText:[NSString stringWithFormat:@"%d", [self heroRaiseToAmount] - [self heroBetOrRaiseAmount]]];
		[howMuchMoreToBetRaiseLabel setNeedsDisplay];
	}
}


- (void) showMyCardsButton {
	revealMyHandToMyselfButton.hidden = NO;
	[revealMyHandToMyselfButton setEnabled:YES];
}

- (void) hideMyCardsButton {
	revealMyHandToMyselfButton.hidden = YES;
	[revealMyHandToMyselfButton setNeedsDisplay];
}

- (void) displayWhoWon {
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	[Hand calcBestHand:heroCard0View.card :heroCard1View.card :heroCard2View.card :heroCard3View.card :heroCard4View.card :hand0];
	[Hand calcBestHand:villainCard0View.card :villainCard1View.card :villainCard2View.card :villainCard3View.card :villainCard4View.card :hand1];
	NSComparisonResult result = [Hand compareHands:hand0 :hand1];
		
	// award the pot to the winner and update screen.
	if (result == NSOrderedAscending) {
		// villain won
		NSArray* heroCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
							   heroCard4View, nil] retain];
		
		for (CardView* cardView in heroCards)
			[cardView dullize];
		
		[heroCards release];
		
		[whoWonLabel setText:@"You lost"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:villainStackLabel addAmount:[self potSize]];
	} else if (result == NSOrderedDescending) {
		// hero won
		NSArray* villainCards = [[NSArray arrayWithObjects:villainCard0View, villainCard1View, villainCard2View, villainCard3View,
								  villainCard4View, nil] retain];
		
		for (CardView* cardView in villainCards)
			[cardView dullize];
		
		[villainCards release];
		
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"You won!"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:heroStackLabel addAmount:[self potSize]];
	} else if (result == NSOrderedSame) {
		// split pot
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"Split pot"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:heroStackLabel addAmount:[self potSize] / 2];
		[self updateNumberLabel:villainStackLabel addAmount:[self potSize] / 2];
	}
		
	[hand0 release];
	[hand1 release];
	
	[NSTimer scheduledTimerWithTimeInterval:SHOWDOWN_DELAY target:self selector:@selector(afterDisplayingWhoWonTimerFireMethod) userInfo:nil repeats:NO];
}	

// showdown both hero's and villain's hands.
- (void) showdown {
	[self startWaitIndicator];

	[self hideMyCardsButton];
	[self hideAllActionButtons];
	
	[self playShowCardsSound];
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	heroCard4View.faceUp = YES;

	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	villainCard2View.faceUp = YES;
	villainCard3View.faceUp = YES;
	villainCard4View.faceUp = YES;
	
	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard2View setNeedsDisplay];
	[heroCard3View setNeedsDisplay];
	[heroCard4View setNeedsDisplay];

	[villainCard0View setNeedsDisplay];
	[villainCard1View setNeedsDisplay];	
	[villainCard2View setNeedsDisplay];
	[villainCard3View setNeedsDisplay];	
	[villainCard4View setNeedsDisplay];
}	

// start a new hand. it does nothing when hero is not the dealer for the new hand.
// it deals the new hand as the dealer when hero is the dealer for the new hand.
// note that !dealer means hero is not the dealer for the hand that just ended, which
// indicates hero is the dealer for the new hand.
- (void) startNewHand {
	if (!isHandStarted) {
		if (!dealer)
			[self dealNewHandAsDealer];
	}
}

- (BOOL) isMatchOver {
	BOOL over = NO;
	
	if ([self heroStackSize] == 0) {
		over = YES;
		AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This headsup match is over" message:@"You lost. Sorry" delegate:[[UIApplication sharedApplication] delegate] cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];				
	} else if ([self villainStackSize] == 0) {
		over = YES;
		AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"This headsup match is over" message:@"You won. Congratulations!" delegate:[[UIApplication sharedApplication] delegate] cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	return over;
}
		

// called after showdown
// we have to be careful with this timer method. even though this is a single-threaded program,
// if hero is not the dealer after this all-in hand, it's possible that this method is triggered
// after the next hand is already dealt!
- (void)afterDisplayingWhoWonTimerFireMethod {
	if (!isHandStarted) {
		// checks if one guy has lost all the chips
		if (![self isMatchOver]) {
			[self startNewHand];	
		}
	}
}	

- (void)beforeDealingNextStreetTimerFireMethod {
/*	[self dealNextStreetCards];
	
	if (hand.street == kStreetSeventh) {
		[timer invalidate];
		
		[self displayWhoWon];			
	}*/
	
}	


- (void) handleAllIn {
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
	
	if (hand.street == kStreetRoundTwo) {
		[self displayWhoWon];	
	} else {
		timer = [NSTimer scheduledTimerWithTimeInterval:ALL_IN_DEALING_DELAY target:self selector:@selector(beforeDealingNextStreetTimerFireMethod) userInfo:nil repeats:YES];		
	}
}

- (void)addMove {
	isHandStarted = NO;
	[hand addMove];
}

// time to let players draw cards. if hero is first to draw, show pat/discard button. 
// otherwise do nothing.
- (void) drawMoreCards {
	[self hideAllActionButtons];
	
	[self displayAction:@"" amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	[self displayAction:@"" amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	[hand nextStreet];
	
	if (!dealer) {
		herosTurnToDraw = YES;
		
		[self changeTitleOfButton:patDiscardButton to:PAT_BUTTON_TITLE];
		patDiscardButton.hidden = NO;
		[patDiscardButton setEnabled:YES];
	}
}

// foldButtonPressed
- (IBAction) fold:(id)sender {
	[self setEnabledAllActionButtons:NO];

	[self playFoldSound];
	
	[self addMove];

	[self startWaitIndicator];
	
	[self displayAction:FOLD_ACTION amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	
	// award the pot to villain
	[self updateNumberLabel:villainStackLabel addAmount:[self potSize]];
	
	// hero has just folded. send a message to villain and this hand is over.
	// deal the next hand if we are the dealer.
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMoveFold];
	
	[self startNewHand];
}

- (void) checkButtonPressed {
	[self playCheckSound];
	
	[self startWaitIndicator];
	
	[self displayAction:CHECK_ACTION amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];

	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMoveCheck];	
	
	// hero has just checked. if this is the first round, it's time to draw.
	// otherwise, if hero's dealer, show down because it just went check-check;
	// if hero is not the dealer, it's villain's turn.
	if (hand.street == kStreetRoundOne) {
		[self drawMoreCards];
	} else {
		if (dealer)
			[self handleAllIn];
		else
			[self hideAllActionButtons];
	}
}

- (void) callButtonPressed {
	[self startWaitIndicator];

	// update numbers
	NSInteger heroAmount = [self heroBetOrRaiseAmount];
	NSInteger diff = [self callAmount];
	
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabel addAmount:-diff];

	[self displayAction:CALL_ACTION amount:(heroAmount + diff) actionLabel:heroActionLabel amountLabel:heroAmountLabel];
	
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMoveCall];
	
	if ([self heroStackSize] == 0 || [self villainStackSize] == 0) {
		[self playAllInSound];
		[self handleAllIn];
	} else {
		[self playCallSound];
	
		// hero's just called. if this is round one and the very first move then it's 
		// villain's turn; if it's not the first move then time to draw.
		// if this is round two, show down hands.		
		if (hand.street == kStreetRoundOne) {
			if (hand.moveCount == 1)
				[self hideAllActionButtons];
			else
				[self drawMoreCards];
		} else {
			[self handleAllIn];
		}
	}
}

- (IBAction) checkCall:(id)sender {
	[self setEnabledAllActionButtons:NO];

	[self addMove];

	if ([[checkCallButton titleForState:UIControlStateNormal] compare:CHECK_BUTTON_TITLE] == NSOrderedSame) {
		[self checkButtonPressed];		
	} else {
		[self callButtonPressed];
	}
}

- (IBAction) betRaise:(id)sender {
	[self setEnabledAllActionButtons:NO];
	
	[self addMove];
	
	NSString *action = @"";
	NSInteger amount = 0;
	uint8_t move = kMoveBet;
	
	if ([self isBetAction]) {
		action = BET_ACTION;
		amount = [self heroBetAmount];
		move = kMoveBet;
	} else if ([self isBetAllInAction]) {
		action = ALLIN_ACTION;
		amount = [self heroStackSize];
		move = kMoveBet;
	} else if ([self isRaiseAction]) {
		action = RAISE_ACTION;
		amount = [self heroRaiseToAmount];
		move = kMoveRaise;
	} else if ([self isCapAction]) {
		action = CAP_ACTION;
		amount = [self heroRaiseToAmount];
		move = kMoveRaise;
	} else if ([self isRaiseAllInAction]) {
		action = ALLIN_ACTION;
		amount = [self heroStackSize];
		move = kMoveRaise;
	}
	
	// update numbers
	NSInteger diff = amount - [self heroBetOrRaiseAmount];
	[self updateNumberLabel:potLabel addAmount:diff];
	[self updateNumberLabel:heroStackLabel addAmount:-diff];
	
	[self displayAction:action amount:amount actionLabel:heroActionLabel amountLabel:heroAmountLabel];

	if (([self heroStackSize] == 0) ||
		([self villainBetOrRaiseAmount] + [self villainStackSize] <= amount)) {
		[self playAllInSound];
	} else if (action == BET_ACTION) {
		hand.raiseCount = 1;
		[self playBetSound];
	} else if (action == RAISE_ACTION) {
		hand.raiseCount += 2;
		[self playRaiseSound];
	}
	
	[self startWaitIndicator];
	
	uint8_t *message = malloc(5 * sizeof(uint8_t));
	message[0] = move;
	message[1] = (uint8_t)((amount >> 24) & 0xff);
	message[2] = (uint8_t)((amount >> 16) & 0xff);
	message[3] = (uint8_t)((amount >>  8) & 0xff);
	message[4] = (uint8_t)( amount        & 0xff);
	
	[(AppController*)[[UIApplication sharedApplication] delegate] sendArray:message size:5];
	free(message);	
	
	[self hideAllActionButtons];		
}

- (void) patButtonPressed {
	herosTurnToDraw = NO;	
	patDiscardButton.hidden = YES;
	[patDiscardButton setNeedsDisplay];
	
	[self displayDrawAction:kMovePat numDiscardedCards:0 actionLabel:heroDrawActionLabel];
	
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMovePat];
}

- (void) discardButtonPressed {
	herosTurnToDraw = NO;
	patDiscardButton.hidden = YES;
	[patDiscardButton setNeedsDisplay];
		
	// discard and draw cards
	NSInteger numDiscardedCards = 0;
	
	NSArray* heroCardViews = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						   heroCard4View, nil] retain];
	
	for (CardView *cardView in heroCardViews) {
		if (cardView.dull) {
			++numDiscardedCards;
			
			cardView.card = [deck dealOneCard];
		}
	}
	
	[heroCardViews release];
	
	[self displayDrawAction:kMoveDiscard numDiscardedCards:numDiscardedCards actionLabel:heroDrawActionLabel];
	
	// send message
	uint8_t *message = malloc(5 * sizeof(uint8_t));
	message[0] = kMoveDiscard;
	message[1] = (uint8_t)(numDiscardedCards);
	
	[(AppController*)[[UIApplication sharedApplication] delegate] sendArray:message size:2];
	free(message);		
}

- (IBAction) patOrDiscard:(id)sender {
	if ([[patDiscardButton titleForState:UIControlStateNormal] isEqualToString:PAT_BUTTON_TITLE])
		[self patButtonPressed];
	else
		[self discardButtonPressed];
}


- (IBAction) revealMyHandToMyself:(id)sender {
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	heroCard4View.faceUp = YES;

	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard2View setNeedsDisplay];
	[heroCard3View setNeedsDisplay];
	[heroCard4View setNeedsDisplay];
}

- (IBAction) concealMyHand:(id)sender {
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = NO;
	heroCard3View.faceUp = NO;
	heroCard4View.faceUp = NO;

	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard2View setNeedsDisplay];
	[heroCard3View setNeedsDisplay];
	[heroCard4View setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (herosTurnToDraw) {
		// We only support single touches, so anyObject retrieves just that touch from touches
		UITouch *touch = [touches anyObject];
		
		// Animate the first touch
		CGPoint touchPoint = [touch locationInView:self];
		
		NSArray *heroCardViews = 
		[[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View, heroCard4View, nil] retain];
		
		for (CardView *cardView in heroCardViews) {
			CGRect rect = [cardView frame];
			if ((touchPoint.x > rect.origin.x) &&
				(touchPoint.x < rect.origin.x + rect.size.width) &&
				(touchPoint.y > rect.origin.y) &&
				(touchPoint.y < rect.origin.y + rect.size.height)){
				[cardView toggleDull];
				break;
			}
		}
		
		BOOL anyCardSelected = NO;
		for (CardView *cardView in heroCardViews) {
			if (cardView.dull) {
				anyCardSelected = YES;
				break;
			}
		}
		
		if (anyCardSelected) {
			[self changeTitleOfButton:patDiscardButton to:DISCARD_BUTTON_TITLE];
		} else {
			[self changeTitleOfButton:patDiscardButton to:PAT_BUTTON_TITLE];		
		}
		
		[patDiscardButton setNeedsDisplay];
		
		[heroCardViews release];
	}
}

- (void) villainFolded {
	[self displayAction:FOLD_ACTION amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// award the pot to hero
	[self playHeroWonPotSound];
	[self updateNumberLabel:heroStackLabel addAmount:[self potSize]];
	
	// villain has just folded. the hand is over. start a new 
	// hand if we are the new dealer. otherwise just wait for
	// the cards.
	[self startNewHand];
}

- (void) villainChecked {	
	[self displayAction:CHECK_ACTION amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// villain has just checked. if this is round one, draw cards.
	// otherwise, if hero's not the dealer, showdown because it just went check-check;
	// if hero is the dealer, it's hero's turn.
	if (hand.street == kStreetRoundOne) {
		[self drawMoreCards];
	} else {
		if (dealer) {
			[self stopWaitIndicator];
			
			[self hideAllActionButtons];
			[self showFoldButton];
			[self showCheckButton];
			[self showBetButton];
		} else {
			[self handleAllIn];
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
	
	if ([self heroStackSize] == 0 || [self villainStackSize] == 0) {
		[self handleAllIn];
	} else {	
		// villain has just called. if this is round one and the call was the very first move then it's 
		// hero's turn; if it's not the first move then draw cards.
		// if this is round two, show down both hands.
		if (hand.street == kStreetRoundOne) {
			if (hand.moveCount == 1) {
				[self stopWaitIndicator];
				
				[self hideAllActionButtons];
				[self showFoldButton];
				[self showCheckButton];
				[self showRaiseButton];
			} else {
				[self drawMoreCards];
			}
		} else {
			[self handleAllIn];
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
	
	[self displayAction:(hand.raiseCount <= 2) ? RAISE_ACTION : CAP_ACTION amount:amount actionLabel:villainActionLabel amountLabel:villainAmountLabel];
	
	// show buttons for hero
	[self showFoldButton];
	[self showCallButton];
	
	if (hand.raiseCount <= 2)
		[self showRaiseButton];
}

- (void) villainStoodPat {
	if (dealer) {
		herosTurnToDraw = YES;
		patDiscardButton.hidden = NO;
		[self changeTitleOfButton:patDiscardButton to:PAT_BUTTON_TITLE];
		[patDiscardButton setEnabled:YES];
		
		[self displayDrawAction:kMovePat numDiscardedCards:0 actionLabel:villainDrawActionLabel];
	} else {
		[self hideAllActionButtons];
		[self showFoldButton];
		[self showCheckButton];
		[self showBetButton];
	}
}

- (void) villainDiscardedCards:(NSInteger)numDiscardedCards {
	if (dealer) {
		herosTurnToDraw = YES;
		patDiscardButton.hidden = NO;
		[self changeTitleOfButton:patDiscardButton to:PAT_BUTTON_TITLE];
		[patDiscardButton setEnabled:YES];
		
		[self displayDrawAction:kMoveDiscard numDiscardedCards:numDiscardedCards actionLabel:villainDrawActionLabel];
		
		for (int i=0; i < numDiscardedCards; i++)
			[deck dealOneCard];
	} else {
		[self hideAllActionButtons];
		[self showFoldButton];
		[self showCheckButton];
		[self showBetButton];
	}	
}

- (void) handleVillainsMove:(enum MoveType) move amount:(NSInteger)amount {
	[self startWaitIndicator];
	
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
	} else if (move == kMovePat) {
		[self villainStoodPat];
	} else if (move == kMoveDiscard) {
		[self villainDiscardedCards:amount];
	}
}	

- (void) villainMadeAMove:(enum MoveType) move amount:(NSInteger)amount {
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


- (void) resetForNewHand {
	[handCountLabel setText:[NSString stringWithFormat:@"%d", ++handCount]];
		
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = NO;
	heroCard3View.faceUp = NO;
	heroCard4View.faceUp = NO;

	villainCard0View.faceUp = NO;
	villainCard1View.faceUp = NO;
	villainCard2View.faceUp = NO;
	villainCard3View.faceUp = NO;
	villainCard4View.faceUp = NO;
		
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
			
	[hand newHandWithType:kHand5CardSingleDraw];
}

- (void) dealFirstCardNonDealer {
	[self playDealingCardsSound];
	villainCard0View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard0View.card = [deck dealOneCard];

	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];

	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFifthCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFifthCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard2View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSixthCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSixthCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard2View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSeventhCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSeventhCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard3View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealEighthCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealEighthCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard3View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealNinethCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealNinethCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard4View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealTenthCardNonDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealTenthCardNonDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard4View.card = [deck dealOneCard];
	[self showMyCardsButton];	
	
	isDealingGoingOn = NO;

	[self startWaitIndicator];
			
	if (([self villainStackSize] == 0) ||
		([self heroStackSize] == 0) && ([self heroBetOrRaiseAmount] <= [self villainBetOrRaiseAmount])) {
		// this is necessary to set isHandStarted correctly because this is a special "no move all-in" hand.
		[self addMove];
		[self handleAllIn];
	}
	
	if (isMovePostponed) {
		NSLog(@"handling postponed move");
		
		isMovePostponed = NO;
		[self handleVillainsMove:postponedVillainsFirstMove amount:postponedVillainsFirstMoveAmount];		
	}
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
	[self dealFirstCardNonDealer];
}

- (void) dealFirstCardDealer {
	[self playDealingCardsSound];
	heroCard0View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard0View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard1View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard1View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFifthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFifthCardDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard2View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSixthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSixthCardDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard2View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSeventhCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSeventhCardDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard3View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealEighthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealEighthCardDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard3View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealNinethCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealNinethCardDealerTimerMethod {
	[self playDealingCardsSound];
	heroCard4View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealTenthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealTenthCardDealerTimerMethod {
	[self playDealingCardsSound];
	villainCard4View.card = [deck dealOneCard];
	[self showMyCardsButton];	
	
	isDealingGoingOn = NO;
	
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
	}
}

// hero is the dealer.
- (void) dealNewHandAsDealer {	
	if ((BUILD == HU_DRAW_FREE) && (handCount >= 10)) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Download Headsup Draw Poker today!" delegate:[[UIApplication sharedApplication] delegate] cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}	
	
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
	
	[deck shuffleUpAndDeal:kHand5CardSingleDraw];
	// send cards to the other phone
	uint8_t *message = malloc(21 * sizeof(uint8_t));
	message[0] = (uint8_t)kMoveCards;
	NSInteger cardsCount = [deck getNumOfCards];
	for (int i=1; i <= cardsCount; i++) {
		Card *card = [deck getCardAtIndex:i-1];
		message[i] = (uint8_t)((card.rank << 2) | card.suit);
	}
	
	[(AppController*)[[UIApplication sharedApplication] delegate] sendArray:message size:21];
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
	[self dealFirstCardDealer];
}

- (void) setupInitialScreen {
	[handCountLabel setText:@"0"];
	
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = NO;
	heroCard3View.faceUp = NO;
	heroCard4View.faceUp = NO;
	
	villainCard0View.faceUp = NO;
	villainCard1View.faceUp = NO;
	villainCard2View.faceUp = NO;
	villainCard3View.faceUp = NO;
	villainCard4View.faceUp = NO;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
	
	[self hideMyCardsButton];
	[self hideAllActionButtons];
	
	heroDealerButton.hidden = YES;
	villainDealerButton.hidden = YES;
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	
	[heroActionLabel setText:@""];
	[heroAmountLabel setText:@""];
	[heroDrawActionLabel setText:@""];
	[villainActionLabel setText:@""];
	[villainAmountLabel setText:@""];
	[villainDrawActionLabel setText:@""];
	[potLabel setText:@""];
	[whoWonLabel setText:@""];
	[howMuchMoreToCallLabel setText:@""];
	[howMuchMoreToBetRaiseLabel setText:@""];
	
	[heroActionLabel setNeedsDisplay];
	[heroAmountLabel setNeedsDisplay];
	[heroDrawActionLabel setNeedsDisplay];
	[villainActionLabel setNeedsDisplay];
	[villainAmountLabel setNeedsDisplay];
	[villainDrawActionLabel setNeedsDisplay];
	[potLabel setNeedsDisplay];
	[whoWonLabel setNeedsDisplay];
	[howMuchMoreToCallLabel setNeedsDisplay];
	[howMuchMoreToBetRaiseLabel setNeedsDisplay];
	
	[heroStackLabel setText:[NSString stringWithFormat:@"%d", BUYIN]];
	[villainStackLabel setText:[NSString stringWithFormat:@"%d", BUYIN]];
}

// called before the very first hand
- (void) willDisplay {
	isMovePostponed = NO;
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



@end
