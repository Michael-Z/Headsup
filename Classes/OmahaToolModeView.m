//
//  HeadsupView.m
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OmahaToolModeView.h"
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

#define ALL_IN_IMAGE @"allin_smallfont.png"
#define SHOWDOWN_IMAGE @"showdown.png"

#define NEW_HAND_HELP_STRING @"Tap 'New Hand' to start a new hand"
#define NEXT_STREET_FLOP_HELP_STRING @"Tap 'Next Street' to see the flop"
#define NEXT_STREET_TURN_HELP_STRING @"Tap 'Next Street' to see the turn"
#define NEXT_STREET_RIVER_HELP_STRING @"Tap 'Next Street' to see the river"
#define ALL_IN_HELP_STRING @"Tap 'All In!' to go all-in or call all-in"
#define SHOWDOWN_HELP_STRING @"Tap 'Showdown' to table your hand"
#define ALL_IN_INDICATOR_STRING @"You are all-in. Good luck"

#define HEROS_HAND @"Your hand: "
#define VILLAINS_HAND @"Opponent's hand: "

#define DEALING_DELAY 0.2
#define SHOWDOWN_DELAY 12.0


@implementation OmahaToolModeView

@synthesize navController;
@synthesize appController;

@synthesize heroCard0View;
@synthesize heroCard1View;
@synthesize heroCard2View;
@synthesize heroCard3View;

@synthesize villainCard0View;
@synthesize villainCard1View;
@synthesize villainCard2View;
@synthesize villainCard3View;

@synthesize communityCard0View;
@synthesize communityCard1View;
@synthesize communityCard2View;
@synthesize communityCard3View;
@synthesize communityCard4View;

@synthesize status0Label;
@synthesize status1Label;
@synthesize status2Label;

@synthesize heroDealerButton;
@synthesize villainDealerButton;
@synthesize heroBlindButton;
@synthesize villainBlindButton;
@synthesize heroActLabel;
@synthesize villainActLabel;

@synthesize nextHandButton;
@synthesize nextStreetButton;
@synthesize allInButton;
@synthesize revealMyHandToMyselfButton;
@synthesize waitingIndicator;
@synthesize villainsWaitingIndicator;
@synthesize villainsWaitingLabel;

@synthesize handCountLabel;

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

- (void) willDisplayAtHand:(NSInteger)count {
	//[[Applytics sharedService] log:[[self class] description]];
	
	handCount = count;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;

	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;

	communityCard0View.card = nil;
	communityCard1View.card = nil;
	communityCard2View.card = nil;
	communityCard3View.card = nil;
	communityCard4View.card = nil;
	
	//[newHandButton setEnabled:YES];
	
	nextHandButton.hidden = YES;
	nextStreetButton.hidden = YES;
	allInButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	
	
	heroDealerButton.hidden = YES;
	villainDealerButton.hidden = YES;
	heroBlindButton.hidden = YES;
	villainBlindButton.hidden = YES;
	heroActLabel.hidden = YES;
	villainActLabel.hidden = YES;
	
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	[heroBlindButton setNeedsDisplay];
	[villainBlindButton setNeedsDisplay];
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
	
	
	[status0Label setText:NEW_HAND_HELP_STRING];
	[status0Label setNeedsDisplay];
	
	[status1Label setText:@""];
	[status1Label setNeedsDisplay];
	
	[status2Label setText:@""];
	[status2Label setNeedsDisplay];
	
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
	
	villainsWaitingIndicator.hidden = YES;
	[villainsWaitingIndicator stopAnimating];
	
	[villainsWaitingLabel setText:@""];
	[villainsWaitingLabel setNeedsDisplay];
	
	// deal a new hand automatically
	handFSM.state = kStateNewStarted;
	[self makeNewHandReadyToBeDealt];
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
	
	handCount = 0;
	
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
		
		heroDealerButton.hidden = NO;
		villainDealerButton.hidden = YES;
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
		
		[self changeImageOfButton:heroBlindButton to:[UIImage imageNamed:@"SB.png"]];
		[self changeImageOfButton:villainBlindButton to:[UIImage imageNamed:@"BB.png"]];		
		
	} else {
		
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
	//[newHandButton setUserInteractionEnabled:enabled];
	//[nextStreetButton setUserInteractionEnabled:enabled];
	//[allInButton setUserInteractionEnabled:enabled];
	//[revealMyHandToMyselfButton setUserInteractionEnabled:enabled];
	
	[nextHandButton setEnabled:enabled];
	[nextStreetButton setEnabled:enabled];
	[allInButton setEnabled:enabled];
	[revealMyHandToMyselfButton setEnabled:enabled];
}

- (void) pushButtonsSnapshot {
	newHandButtonEnabled = [nextHandButton isEnabled];
	nextStreetButtonEnabled = [nextStreetButton isEnabled];
	allInButtonEnabled = [allInButton isEnabled];
	revealMyHandToMyselfButtonEnabled = [revealMyHandToMyselfButton isEnabled];
}

- (void) popButtonsSnapshot {
	//[newHandButton setUserInteractionEnabled:newHandButtonEnabled];
	//[nextStreetButton setUserInteractionEnabled:nextStreetButtonEnabled];
	//[allInButton setUserInteractionEnabled:allInButtonEnabled];
	//[revealMyHandToMyselfButton setUserInteractionEnabled:revealMyHandToMyselfButtonEnabled];
	
	[nextHandButton setEnabled:newHandButtonEnabled];
	[nextStreetButton setEnabled:nextStreetButtonEnabled];
	[allInButton setEnabled:allInButtonEnabled];
	[revealMyHandToMyselfButton setEnabled:revealMyHandToMyselfButtonEnabled];
}

- (void) dealNewHand {
	nextHandButton.hidden = YES;
	nextStreetButton.hidden = YES;
	allInButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = NO;
	heroCard3View.faceUp = NO;

	villainCard0View.faceUp = NO;
	villainCard1View.faceUp = NO;
	villainCard2View.faceUp = NO;
	villainCard3View.faceUp = NO;

	communityCard0View.faceUp = YES;
	communityCard1View.faceUp = YES;
	communityCard2View.faceUp = YES;
	communityCard3View.faceUp = YES;
	communityCard4View.faceUp = YES;
	
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;

	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;

	communityCard0View.card = nil;
	communityCard1View.card = nil;
	communityCard2View.card = nil;
	communityCard3View.card = nil;
	communityCard4View.card = nil;
		
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
	
	[handFSM input:kEventDealt];
	
	// intialize view for a new hand
	[self setEnabledAllButtons:YES];
	
	nextHandButton.hidden = NO;
	nextStreetButton.hidden = NO;
	allInButton.hidden = NO;
	revealMyHandToMyselfButton.hidden = NO;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	
	
	[AppController changeTitleOfButton:allInButton to:ALL_IN_STRING];	
	[AppController changeImageOfButton:allInButton to:ALL_IN_IMAGE];
	
	// set up help text
	[status0Label setText:NEW_HAND_HELP_STRING];
	[status0Label setNeedsDisplay];
	[status1Label setText:NEXT_STREET_FLOP_HELP_STRING];
	[status1Label setNeedsDisplay];
	[status2Label setText:ALL_IN_HELP_STRING];
	[status2Label setNeedsDisplay];	
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
	
	// update hand count
	[handCountLabel setText:[NSString stringWithFormat:@"%d", ++handCount]];
	
	// set up model	
	[hand newHand];
	
	if (dealer) {
		[deck shuffleUpAndDeal:kHandOmaha];
		// send cards to the other phone
		uint8_t *message = malloc(14 * sizeof(uint8_t));
		message[0] = (uint8_t)kMessageCards;
		NSInteger cardsCount = [deck getNumOfCards];
		for (int i=1; i <= cardsCount; i++) {
			Card *card = [deck getCardAtIndex:i-1];
			message[i] = (uint8_t)((card.rank << 2) | card.suit);
		}
		
		[appController sendArray:message size:14];
		free(message);
		[handFSM input:kEventSendCards];
		
		[self dealNewHand];
		
		[self endWaiting];
	}
}

- (void) dealNextStreet {
	[self setEnabledAllButtons:YES];
	nextHandButton.hidden = NO;
	nextStreetButton.hidden = NO;
	allInButton.hidden = NO;
	revealMyHandToMyselfButton.hidden = NO;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];	
			
	if (dealer) {
		heroActLabel.hidden = YES;
		villainActLabel.hidden = NO;
	} else {
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
	}		
	
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
	
	[hand nextStreet];
	switch (hand.street) {
		case kStreetFlop:
			[self playDealingCardsSound];
			communityCard0View.card = [deck dealOneCard];
			[self playDealingCardsSound];
			communityCard1View.card = [deck dealOneCard];
			[self playDealingCardsSound];
			communityCard2View.card = [deck dealOneCard];
			
			[status0Label setText:NEW_HAND_HELP_STRING];
			[status0Label setNeedsDisplay];
			[status1Label setText:NEXT_STREET_TURN_HELP_STRING];
			[status1Label setNeedsDisplay];
			[status2Label setText:ALL_IN_HELP_STRING];
			[status2Label setNeedsDisplay];			
			break;
		case kStreetTurn:
			[self playDealingCardsSound];
			communityCard3View.card = [deck dealOneCard];
			
			[status0Label setText:NEW_HAND_HELP_STRING];
			[status0Label setNeedsDisplay];
			[status1Label setText:NEXT_STREET_RIVER_HELP_STRING];
			[status1Label setNeedsDisplay];
			[status2Label setText:ALL_IN_HELP_STRING];
			[status2Label setNeedsDisplay];			
			break;
		case kStreetRiver:
			[self playDealingCardsSound];
			communityCard4View.card = [deck dealOneCard];
			nextStreetButton.hidden = YES;
			[nextStreetButton setNeedsDisplay];

			[AppController changeTitleOfButton:allInButton to:SHOWDOWN_STRING];
			[AppController changeImageOfButton:allInButton to:SHOWDOWN_IMAGE];
			
			[status0Label setText:NEW_HAND_HELP_STRING];
			[status0Label setNeedsDisplay];
			[status1Label setText:SHOWDOWN_HELP_STRING];
			[status1Label setNeedsDisplay];
			[status2Label setText:@""];
			[status2Label setNeedsDisplay];			
						
			break;
		default:
			NSLog(@"wrong street: %@", hand.street);
			break;
	}
	
	[handFSM input:kEventDealt];
}

- (void) endAllIn {
	//newHandButton.hidden = NO;
	//[newHandButton setEnabled:YES];
		
	[handFSM input:kEventDealt];		
	
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];	
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

- (void) displayWhoWon {
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSComparisonResult result = [Hand 
								 calcOmahaWinnerHoleCard0:heroCard0View.card 
								 holeCard1:heroCard1View.card
								 holeCard2:heroCard2View.card
								 holeCard3:heroCard3View.card
								 holeCard4:villainCard0View.card
								 holeCard5:villainCard1View.card
								 holeCard6:villainCard2View.card								 
								 holeCard7:villainCard3View.card 
								 communityCard0:communityCard0View.card
								 communityCard1:communityCard1View.card
								 communityCard2:communityCard2View.card
								 communityCard3:communityCard3View.card
								 communityCard4:communityCard4View.card
								 bestHandForFirstPlayer:hand0
								 bestHandForSecondPlayer:hand1];
	
	if (result == NSOrderedDescending) {
		[self playHeroWonPotSound];
		[status0Label setText:@"You won!"];
	} else if (result == NSOrderedAscending) {
		[status0Label setText:@"You lost"];
	} else {
		[self playHeroWonPotSound];
		[status0Label setText:@"Split pot"];
	}
		
	if (hand0.handType == kHandStraightFlush)
		[status1Label setText:[NSString stringWithFormat:@"%@straight flush", HEROS_HAND]];
	else if (hand0.handType == kHandQuads)
		[status1Label setText:[NSString stringWithFormat:@"%@four of a kind", HEROS_HAND]];
	else if (hand0.handType == kHandBoat)
		[status1Label setText:[NSString stringWithFormat:@"%@full house", HEROS_HAND]];
	else if (hand0.handType == kHandFlush)
		[status1Label setText:[NSString stringWithFormat:@"%@flush", HEROS_HAND]];
	else if (hand0.handType == kHandStraight)
		[status1Label setText:[NSString stringWithFormat:@"%@straight", HEROS_HAND]];
	else if (hand0.handType == kHandTrips)
		[status1Label setText:[NSString stringWithFormat:@"%@three of a kind", HEROS_HAND]];
	else if (hand0.handType == kHandTwoPair)
		[status1Label setText:[NSString stringWithFormat:@"%@two pair", HEROS_HAND]];
	else if (hand0.handType == kHandOnePair)
		[status1Label setText:[NSString stringWithFormat:@"%@one pair", HEROS_HAND]];
	else
		[status1Label setText:[NSString stringWithFormat:@"%@no pair", HEROS_HAND]];
	
	if (hand1.handType == kHandStraightFlush)
		[status2Label setText:[NSString stringWithFormat:@"%@straight flush", VILLAINS_HAND]];
	else if (hand1.handType == kHandQuads)
		[status2Label setText:[NSString stringWithFormat:@"%@four of a kind", VILLAINS_HAND]];
	else if (hand1.handType == kHandBoat)
		[status2Label setText:[NSString stringWithFormat:@"%@full house", VILLAINS_HAND]];
	else if (hand1.handType == kHandFlush)
		[status2Label setText:[NSString stringWithFormat:@"%@flush", VILLAINS_HAND]];
	else if (hand1.handType == kHandStraight)
		[status2Label setText:[NSString stringWithFormat:@"%@straight", VILLAINS_HAND]];
	else if (hand1.handType == kHandTrips)
		[status2Label setText:[NSString stringWithFormat:@"%@three of a kind", VILLAINS_HAND]];
	else if (hand1.handType == kHandTwoPair)
		[status2Label setText:[NSString stringWithFormat:@"%@two pair", VILLAINS_HAND]];
	else if (hand1.handType == kHandOnePair)
		[status2Label setText:[NSString stringWithFormat:@"%@one pair", VILLAINS_HAND]];
	else
		[status2Label setText:[NSString stringWithFormat:@"%@no pair", VILLAINS_HAND]];

	
	[status0Label setNeedsDisplay];
	[status1Label setNeedsDisplay];
	[status2Label setNeedsDisplay];
	
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						 villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
						  communityCard0View, communityCard1View,
						 communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	NSArray* winningHand = result == NSOrderedAscending ? hand1.cards : hand0.cards;
		
	for (CardView* cardView in allCards) {
		if (![self cardInGroup:cardView.card :winningHand])
			[cardView dullize];
	}
	
	[allCards release];
	
	[hand0 release];
	[hand1 release];
	
	[NSTimer scheduledTimerWithTimeInterval:SHOWDOWN_DELAY target:self selector:@selector(afterDisplayingWhoWonTimerFireMethod) userInfo:nil repeats:NO];
}	

// called after showdown
// we have to be careful with this timer method. even though this is a single-threaded program,
// if hero is not the dealer after this all-in hand, it's possible that this method is triggered
// after the next hand is already dealt!
- (void)afterDisplayingWhoWonTimerFireMethod {
	// the following code will NOT work because of timeing issue.
	// instead we need to simulate clicking the new hand button.
	//handFSM.state = kStateNewStarted;
	//[self stateChanged];
	
	// send new hand request to the other phone
	[self stopVillainsWaiting];
	[appController send:kMessageNewReq];
	[handFSM input:kEventSendNewReq];
	
	if (handFSM.state == kStateNewStarted ||
		handFSM.state == kStateCancelled) {
		[self stateChanged];
	}		
}	


- (void)timerFireMethod {
	[hand nextStreet];
	switch (hand.street) {
		case kStreetFlop:
			[self playDealingCardsSound];
			communityCard0View.card = [deck dealOneCard];
			[self playDealingCardsSound];
			communityCard1View.card = [deck dealOneCard];
			[self playDealingCardsSound];
			communityCard2View.card = [deck dealOneCard];
			break;
		case kStreetTurn:
			[self playDealingCardsSound];
			communityCard3View.card = [deck dealOneCard];
			break;
		case kStreetRiver:
			[timer invalidate];
			
			[self playDealingCardsSound];
			communityCard4View.card = [deck dealOneCard];
			
			[self displayWhoWon];
			[self endAllIn];
			
			break;
		default:
			NSLog(@"wrong street: %@", hand.street);
			break;
	}
}	

- (void) dealAllIn {
	[self playShowCardsSound];
		
	heroActLabel.hidden = YES;
	villainActLabel.hidden = YES;
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
	
	
	[status0Label setText:[[allInButton titleForState:0] isEqualToString:SHOWDOWN_STRING] ? @"" : ALL_IN_INDICATOR_STRING];
	[status0Label setNeedsDisplay];
	[status1Label setText:@""];
	[status1Label setNeedsDisplay];
	[status2Label setText:@""];
	[status2Label setNeedsDisplay];		
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;

	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	villainCard2View.faceUp = YES;
	villainCard3View.faceUp = YES;
	
	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard2View setNeedsDisplay];
	[heroCard3View setNeedsDisplay];

	[villainCard0View setNeedsDisplay];
	[villainCard1View setNeedsDisplay];
	[villainCard2View setNeedsDisplay];
	[villainCard3View setNeedsDisplay];
	
	nextHandButton.hidden = YES;
	nextStreetButton.hidden = YES;
	allInButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];		
	
	if (hand.street == kStreetRiver) {
		// this hand is over. this is actually not an all-in. It's a showdown.
			
		[self displayWhoWon];
		[self endAllIn];
	} else {
		// all-in action. start the timer.
		timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerFireMethod) userInfo:nil repeats:YES];
	}		
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
		} else if (handFSM.state == kStateNextStreetReadyToBeDealt) {
			[self dealNextStreet];
		}
		
		[self endWaiting];
	} else if (handFSM.state == kStateAllInReadyToBeDealt) {
		[self dealAllIn];
	} else if (handFSM.state == kStateNewStarted) {
		if (BUILD == HU_MIXED && handCount % 4 == 0) {
			[self removeFromSuperview];
			[appController toolEndedAtHand:handCount game:kGameOmahaHi];
		} else {
			[self makeNewHandReadyToBeDealt];
		}
	}	
}

- (IBAction) newHandButtonPressed:(id)sender {	
	[self startWaiting];
	[self stopVillainsWaiting];
	if (revealMyHandToMyselfButtonEnabled)
		[revealMyHandToMyselfButton setEnabled:YES];
		
	// send new hand request to the other phone
	[appController send:kMessageNewReq];
	[handFSM input:kEventSendNewReq];

	if (handFSM.state == kStateNewStarted ||
		handFSM.state == kStateCancelled) {
		[self stateChanged];
	}
}

- (IBAction) nextStreetButtonPressed:(id)sender {
	[self startWaiting];
	[self stopVillainsWaiting];
	[revealMyHandToMyselfButton setEnabled:YES];
	
	// send next street request to the other phone
	[appController send:kMessageNextReq];
	[handFSM input:kEventSendNextReq];
	
	if (handFSM.state == kStateNextStreetReadyToBeDealt ||
		handFSM.state == kStateCancelled) {
		[self stateChanged];
	}	
}

- (IBAction) allInButtonPressed:(id)sender {
	[self playAllInSound];

	[self startWaiting];
	[self stopVillainsWaiting];
	
	// send all in request to the other phone
	[appController send:kMessageAllInReq];
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

	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard2View setNeedsDisplay];
	[heroCard3View setNeedsDisplay];
}

- (IBAction) concealMyHand:(id)sender {
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = NO;
	heroCard3View.faceUp = NO;

	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard2View setNeedsDisplay];
	[heroCard3View setNeedsDisplay];
}

/*- (void) alertView: (UIAlertView*)alertView clickedButtonAtIndex: (NSInteger)buttonIndex {
	NSLog(@"index: %x", buttonIndex);
	
	// check if "Yes" button is clicked.
	if (buttonIndex == 1) {
		[showMyHandToVillainButton setEnabled: NO];
		[revealMyHandToMyselfButton setEnabled: NO];
	
		heroCard0View.faceUp = YES;
		heroCard1View.faceUp = YES;
	
		[heroCard0View setNeedsDisplay];
		[heroCard1View setNeedsDisplay];
	
		[appController send:kMessageHoleCards];
	}
}	

- (IBAction) showMyHandToVillain:(id)sender {
	UIAlertView*			alertView;
	
	alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to expose your hand to your opponent?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alertView show];
	[alertView release];	
}

- (void) revealVillainsHand {
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	
	[villainCard0View setNeedsDisplay];
	[villainCard1View setNeedsDisplay];	
}*/

@end
