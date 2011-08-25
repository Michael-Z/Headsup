//
//  HeadsupView.m
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DrawToolModeView.h"
#import "Constants.h"
#import "Deck.h"
#import "Card.h"
#import "Hand.h"
#import "MadeHand.h"
#import "HandFSM.h"
#import "CardView.h"
#import "AppController.h"

#define DEALER_STRING @"Dealer"
#define NOT_DEALER_STRING @""
#define BIG_BLIND_STRING @"Big Blind"
#define SMALL_BLIND_STRING @"Small Blind"
#define FIRST_TO_ACT_STRING @"You First"
#define SECOND_TO_ACT_STRING @"You Second"
#define ALL_IN_STRING @"All In!"
#define SHOWDOWN_STRING @"Showdown"
#define NEW_HAND_HELP_STRING @"Tap 'New Hand' to start a new hand"
#define NEXT_STREET_FLOP_HELP_STRING @"Tap 'Next Street' to see the flop"
#define NEXT_STREET_TURN_HELP_STRING @"Tap 'Next Street' to see the turn"
#define NEXT_STREET_RIVER_HELP_STRING @"Tap 'Next Street' to see the river"
#define ALL_IN_HELP_STRING @"Tap 'All In!' to go all-in or call all-in"
#define SHOWDOWN_HELP_STRING @"Tap 'Showdown' to table your hand"
#define ALL_IN_INDICATOR_STRING @"You are all-in. Good luck"

#define HEROS_HAND @"Your hand: "
#define VILLAINS_HAND @"Opponent's hand: "

#define PAT_BUTTON_TITLE @"Stand Pat"
#define DISCARD_BUTTON_TITLE @"Discard"

#define PAT_ACTION @"Pat"
#define DISCARD_ACTION @"Draw"


#define DEALING_DELAY 0.2


@implementation DrawToolModeView

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
@synthesize villainDealerButton;
@synthesize heroBlindButton;
@synthesize villainBlindButton;
@synthesize heroActLabel;
@synthesize villainActLabel;

@synthesize whoWonLabel;
@synthesize heroHandLabel;
@synthesize villainHandLabel;

@synthesize heroDrawActionLabel;
@synthesize villainDrawActionLabel;

@synthesize newHandButton;
@synthesize allInButton;
@synthesize patDiscardButton;
@synthesize revealMyHandToMyselfButton;
@synthesize waitingIndicator;
@synthesize villainsWaitingIndicator;
@synthesize villainsWaitingLabel;

@synthesize dealer;
@synthesize deck;
@synthesize handFSM;

@synthesize dealingCardsSoundFileURLRef;
@synthesize dealingCardsSoundFileObject;

@synthesize allInSoundFileURLRef;
@synthesize allInSoundFileObject;

@synthesize wonPotSoundFileURLRef;
@synthesize wonPotSoundFileObject;

@synthesize showCardsSoundFileURLRef;
@synthesize showCardsSoundFileObject;

- (void) displayDrawAction:(enum MoveType)move numDiscardedCards:(NSInteger)num
			   actionLabel:(UILabel*)actionLabel {
	if (move == kMovePat)
		[actionLabel setText:PAT_ACTION];
	else if (move == kMoveDiscard) {
		NSString *strCards = num == 1 ? @"Card" : @"Cards";
		[actionLabel setText:[NSString stringWithFormat:@"%@ %d %@", DISCARD_ACTION, num, strCards]];
		[strCards release];
	}
	
	[actionLabel setNeedsDisplay];
}

- (void) changeTitleOfButton:(UIButton*)button to:(NSString*)title {
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateHighlighted];
	[button setTitle:title forState:UIControlStateDisabled];
	[button setTitle:title forState:UIControlStateSelected];
	[button setNeedsDisplay];	
}

- (void) willDisplay {
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
		
	[newHandButton setEnabled:YES];
	
	allInButton.hidden = YES;
	patDiscardButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	[patDiscardButton setNeedsDisplay];
	
	heroDealerButton.hidden = !dealer;
	villainDealerButton.hidden = dealer;
	heroBlindButton.hidden = YES;
	villainBlindButton.hidden = YES;
	
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	[heroBlindButton setNeedsDisplay];
	[villainBlindButton setNeedsDisplay];

	heroActLabel.hidden = YES;
	villainActLabel.hidden = YES;
	[whoWonLabel setText:@""];
	[heroHandLabel setText:@""];
	[villainHandLabel setText:@""];
	
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
	[whoWonLabel setNeedsDisplay];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setNeedsDisplay];
	
	[heroDrawActionLabel setText:@""];
	[villainDrawActionLabel setText:@""];
	[heroDrawActionLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
	
		
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
	
	villainsWaitingIndicator.hidden = YES;
	[villainsWaitingIndicator stopAnimating];
	
	[villainsWaitingLabel setText:@""];
	[villainsWaitingLabel setNeedsDisplay];	
}

+(void) logMadeHand:(MadeHand*)hand {
	/*NSMutableArray *cards = hand.cards;
	NSLog(@"best hand %x: %@ %@ %@ %@ %@", 
		  hand.handType,
		  [[cards objectAtIndex:0] toString],
		  [[cards objectAtIndex:1] toString],
		  [[cards objectAtIndex:2] toString],
		  [[cards objectAtIndex:3] toString],
		  [[cards objectAtIndex:4] toString]);*/
}


- (void)setUpStuff {
	hand = [[Hand alloc] init];
	deck = [[Deck alloc] init];
	
	handFSM = [[HandFSM alloc] init];	
	
	heroCard0View.card = nil;
	
	// Get the main bundle for the app
	CFBundleRef mainBundle;
	mainBundle = CFBundleGetMainBundle ();	
	
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
	[handFSM release];
	
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

- (void) changeImageOfButton:(UIButton*)button to:(UIImage*)image {
	[button setImage:image forState:UIControlStateNormal];
	[button setImage:image forState:UIControlStateHighlighted];
	[button setImage:image forState:UIControlStateDisabled];
	[button setImage:image forState:UIControlStateSelected];
	[button setNeedsDisplay];	
}

- (void) handleDealerButtonForNewHand {
	if (self.dealer)
		self.dealer = NO;
	else
		self.dealer = YES;
	
	heroBlindButton.hidden = NO;
	villainBlindButton.hidden = NO;
	
	if (self.dealer) {
		
		herosTurnToDraw = NO;
		
		heroDealerButton.hidden = NO;
		villainDealerButton.hidden = YES;
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
		
		[self changeImageOfButton:heroBlindButton to:[UIImage imageNamed:@"SB.png"]];
		[self changeImageOfButton:villainBlindButton to:[UIImage imageNamed:@"BB.png"]];		
		
	} else {
		
		herosTurnToDraw = YES;
		
		heroDealerButton.hidden = YES;
		villainDealerButton.hidden = NO;
		heroActLabel.hidden = YES;
		villainActLabel.hidden = NO;
		
		[self changeImageOfButton:heroBlindButton to:[UIImage imageNamed:@"BB.png"]];
		[self changeImageOfButton:villainBlindButton to:[UIImage imageNamed:@"SB.png"]];		
	}
	
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];		
}

- (void) setEnabledAllButtons: (BOOL)enabled {
	[newHandButton setEnabled:enabled];
	[patDiscardButton setEnabled:enabled];
	[allInButton setEnabled:enabled];
	[revealMyHandToMyselfButton setEnabled:enabled];
}

- (void) pushButtonsSnapshot {
	newHandButtonEnabled = [newHandButton isEnabled];
	allInButtonEnabled = [allInButton isEnabled];
	revealMyHandToMyselfButtonEnabled = [revealMyHandToMyselfButton isEnabled];
}

- (void) popButtonsSnapshot {
	[newHandButton setEnabled:newHandButtonEnabled];
	[allInButton setEnabled:allInButtonEnabled];
	[revealMyHandToMyselfButton setEnabled:revealMyHandToMyselfButtonEnabled];
}

- (void) dealNewHand {
	newHandButton.hidden = YES;
	allInButton.hidden = YES;
	patDiscardButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[newHandButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[patDiscardButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
			
	[whoWonLabel setText:@""];
	[heroHandLabel setText:@""];
	[villainHandLabel setText:@""];
	[whoWonLabel setNeedsDisplay];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setNeedsDisplay];
	
	[heroDrawActionLabel setText:@""];
	[villainDrawActionLabel setText:@""];
	[heroDrawActionLabel setNeedsDisplay];
	[villainDrawActionLabel setNeedsDisplay];
	
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
	
	[self playDealingCardsSound];
	if (dealer)
		heroCard0View.card = [deck dealOneCard];
	else
		villainCard0View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSecondCardTimerMethod) userInfo:nil repeats:NO];
}	

- (void) dealSecondCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		villainCard0View.card = [deck dealOneCard];
	else
		heroCard0View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealThirdCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		heroCard1View.card = [deck dealOneCard];
	else
		villainCard1View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFourthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		villainCard1View.card = [deck dealOneCard];
	else
		heroCard1View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealFifthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFifthCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		heroCard2View.card = [deck dealOneCard];
	else
		villainCard2View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSixthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSixthCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		villainCard2View.card = [deck dealOneCard];
	else
		heroCard2View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealSeventhCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSeventhCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		heroCard3View.card = [deck dealOneCard];
	else
		villainCard3View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealEighthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealEighthCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		villainCard3View.card = [deck dealOneCard];
	else
		heroCard3View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealNinethCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealNinethCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		heroCard4View.card = [deck dealOneCard];
	else
		villainCard4View.card = [deck dealOneCard];
	
	[NSTimer scheduledTimerWithTimeInterval:DEALING_DELAY target:self selector:@selector(dealTenthCardTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealTenthCardTimerMethod {
	[self playDealingCardsSound];
	if (dealer)
		villainCard4View.card = [deck dealOneCard];
	else
		heroCard4View.card = [deck dealOneCard];
	
	[handFSM input:kEventDealt];
	
	// intialize view for a new hand
	[self setEnabledAllButtons:YES];
	
	newHandButton.hidden = NO;
	revealMyHandToMyselfButton.hidden = NO;
	[newHandButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	
	if (!dealer) {
		herosTurnToDraw = YES;
		patDiscardButton.hidden = NO;
		[patDiscardButton setNeedsDisplay];
	}
}


- (void) startWaiting {
	waitingIndicator.hidden = NO;
	[waitingIndicator startAnimating];
	
	// push buttons snapshot
	[self pushButtonsSnapshot];
	
	// disable all buttons
	[self setEnabledAllButtons:NO];
}	

- (void) endWaiting {	
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];	
}

- (void) startVillainsWaiting {
	villainsWaitingIndicator.hidden = NO;
	[villainsWaitingIndicator startAnimating];
	
	[villainsWaitingLabel setText:@"Opponent is waiting on you"];
	[villainsWaitingLabel setNeedsDisplay];
}

- (void) stopVillainsWaiting {
	villainsWaitingIndicator.hidden = YES;
	[villainsWaitingIndicator stopAnimating];
	
	[villainsWaitingLabel setText:@""];
	[villainsWaitingLabel setNeedsDisplay];
}	

- (void) makeNewHandReadyToBeDealt {
	// dealer button
	[self handleDealerButtonForNewHand];

	// set up model	
	[hand newHandWithType:kHand5CardSingleDraw];
	
	if (dealer) {
		[deck shuffleUpAndDeal:kHand7Stud];
		// send cards to the other phone
		uint8_t *message = malloc(15 * sizeof(uint8_t));
		message[0] = (uint8_t)kMessageCards;
		NSInteger cardsCount = [deck getNumOfCards];
		for (int i=1; i <= cardsCount; i++) {
			Card *card = [deck getCardAtIndex:i-1];
			message[i] = (uint8_t)((card.rank << 2) | card.suit);
		}
		
		[(AppController*)[[UIApplication sharedApplication] delegate] sendArray:message size:15];
		free(message);
		[handFSM input:kEventSendCards];
		
		[self dealNewHand];
		
		[self endWaiting];
	}
}

- (void) endAllIn {
	newHandButton.hidden = NO;
	[newHandButton setEnabled:YES];
		
	[handFSM input:kEventDealt];		
	
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];	
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
	} else if (result == NSOrderedSame) {
		// split pot
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"Split pot"];
		[whoWonLabel setNeedsDisplay];
	}
	
	[heroHandLabel setText:[hand0 handDescription]];
	[villainHandLabel setText:[hand1 handDescription]];	
	
	[hand0 release];
	[hand1 release];	
}

- (void) dealAllIn {
	[self playShowCardsSound];
		
	heroActLabel.hidden = YES;
	villainActLabel.hidden = YES;
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];

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
	
	newHandButton.hidden = YES;
	allInButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	patDiscardButton.hidden = YES;
	[newHandButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	[patDiscardButton setNeedsDisplay];
			
	[self displayWhoWon];
	[self endAllIn];
}

- (void) stateChanged {
	if (handFSM.state == kStateCancelled ||
		handFSM.state == kStateNewHandReadyToBeDealt ||
		handFSM.state == kStateNextStreetReadyToBeDealt) {
		if (handFSM.state == kStateCancelled) {
			[handFSM input:kEventGetReady];
			// pop buttons snapshot
			[self popButtonsSnapshot];
		} else if (handFSM.state == kStateNewHandReadyToBeDealt) {
			[self dealNewHand];
		}
		
		[self endWaiting];
	} else if (handFSM.state == kStateAllInReadyToBeDealt) {
		[self dealAllIn];
	} else if (handFSM.state == kStateNewStarted) {
		[self makeNewHandReadyToBeDealt];
	}	
}

- (IBAction) newHandButtonPressed:(id)sender {	
	[self startWaiting];
	[self stopVillainsWaiting];
	if (revealMyHandToMyselfButtonEnabled)
		[revealMyHandToMyselfButton setEnabled:YES];
		
	// send new hand request to the other phone
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMessageNewReq];
	[handFSM input:kEventSendNewReq];

	if (handFSM.state == kStateNewStarted ||
		handFSM.state == kStateCancelled) {
		[self stateChanged];
	}
}

- (void) patButtonPressed {
	herosTurnToDraw = NO;	
	patDiscardButton.hidden = YES;
	[patDiscardButton setNeedsDisplay];
	
	[self displayDrawAction:kMovePat numDiscardedCards:0 actionLabel:heroDrawActionLabel];
	
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMovePat];
	
	if (dealer) {
		allInButton.hidden = NO;
		[allInButton setNeedsDisplay];
		
		heroActLabel.hidden = YES;
		villainActLabel.hidden = NO;
		[heroActLabel setNeedsDisplay];
		[villainActLabel setNeedsDisplay];
	}
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
	
	if (dealer) {
		allInButton.hidden = NO;
		[allInButton setNeedsDisplay];
		
		heroActLabel.hidden = YES;
		villainActLabel.hidden = NO;
		[heroActLabel setNeedsDisplay];
		[villainActLabel setNeedsDisplay];
	}	
}

- (IBAction) patDiscardButtonPressed:(id)sender {
	if ([[patDiscardButton titleForState:UIControlStateNormal] isEqualToString:PAT_BUTTON_TITLE])
		[self patButtonPressed];
	else
		[self discardButtonPressed];
}

- (IBAction) allInButtonPressed:(id)sender {
	[self playAllInSound];

	[self startWaiting];
	[self stopVillainsWaiting];
	
	// send all in request to the other phone
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMessageAllInReq];
	[handFSM input:kEventSendAllInReq];
	
	if (handFSM.state == kStateAllInReadyToBeDealt ||
		handFSM.state == kStateCancelled) {
		[self stateChanged];
	}		
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

- (void) villainStoodPat {
	if (dealer) {
		herosTurnToDraw = YES;
		patDiscardButton.hidden = NO;
		[self changeTitleOfButton:patDiscardButton to:PAT_BUTTON_TITLE];
		[patDiscardButton setEnabled:YES];
		
		[self displayDrawAction:kMovePat numDiscardedCards:0 actionLabel:villainDrawActionLabel];
	} else {
		allInButton.hidden = NO;
		[allInButton setNeedsDisplay];
		
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
		[heroActLabel setNeedsDisplay];
		[villainActLabel setNeedsDisplay];
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
		allInButton.hidden = NO;
		[allInButton setNeedsDisplay];
		
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
		[heroActLabel setNeedsDisplay];
		[villainActLabel setNeedsDisplay];
	}	
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


@end
