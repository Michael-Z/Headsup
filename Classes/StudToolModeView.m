//
//  HeadsupView.m
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "StudToolModeView.h"
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

#define DEALING_DELAY 0.2


@implementation StudToolModeView

@synthesize heroCard0View;
@synthesize heroCard1View;
@synthesize heroCard2View;
@synthesize heroCard3View;
@synthesize heroCard4View;
@synthesize heroCard5View;
@synthesize heroCard6View;

@synthesize villainCard0View;
@synthesize villainCard1View;
@synthesize villainCard2View;
@synthesize villainCard3View;
@synthesize villainCard4View;
@synthesize villainCard5View;
@synthesize villainCard6View;

@synthesize heroDealerButton;
@synthesize villainDealerButton;
@synthesize heroBringInButton;
@synthesize villainBringInButton;
@synthesize heroBlindButton;
@synthesize villainBlindButton;
@synthesize heroActLabel;
@synthesize villainActLabel;

@synthesize whoWonLabel;
@synthesize heroHandLabel;
@synthesize villainHandLabel;

@synthesize nextHandButton;
@synthesize nextStreetButton;
@synthesize allInButton;
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

- (void) willDisplay {
	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	heroCard5View.card = nil;
	heroCard6View.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
	villainCard5View.card = nil;
	villainCard6View.card = nil;
		
	[nextHandButton setEnabled:YES];
	
	nextStreetButton.hidden = YES;
	allInButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	
	
	heroDealerButton.hidden = !dealer;
	villainDealerButton.hidden = dealer;
	heroBringInButton.hidden = YES;
	villainBringInButton.hidden = YES;
	heroBlindButton.hidden = YES;
	villainBlindButton.hidden = YES;
	
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	[heroBringInButton setNeedsDisplay];
	[villainBringInButton setNeedsDisplay];
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

// true if hero's exposed hand is better than villain's
- (BOOL) isHeroExposedHandBetter {
	NSArray *allHeroExposedCardViews = [[NSArray arrayWithObjects:heroCard2View, heroCard3View, heroCard4View, heroCard5View, nil] retain];
	NSArray *allVillainExposedCardViews = [[NSArray arrayWithObjects:villainCard2View, villainCard3View, villainCard4View, villainCard5View, nil] retain];
	
	NSMutableArray *heroExposedCards = [[NSMutableArray alloc] init];
	NSMutableArray *villainExposedCards = [[NSMutableArray alloc] init];
	
	for (int i=0; i < [allHeroExposedCardViews count]; i++) {
		CardView *heroCardView = [allHeroExposedCardViews objectAtIndex:i];
		CardView *villainCardView = [allVillainExposedCardViews objectAtIndex:i];
		
		if (!heroCardView.hidden) {
			[heroExposedCards addObject:heroCardView.card];
			[villainExposedCards addObject:villainCardView.card];
		} else {
			break;
		}
	}
	
	NSComparisonResult result = [Hand compareStudExposedHands:heroExposedCards :villainExposedCards];
	
	[allHeroExposedCardViews release];
	[allVillainExposedCardViews release];
	
	[heroExposedCards release];
	[villainExposedCards release];
	
	return (result == NSOrderedDescending || ((result == NSOrderedSame) && dealer));
}

- (void) displayWhosFirstToAct {
	if ([self isHeroExposedHandBetter]) {
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
	} else {
		heroActLabel.hidden = YES;
		villainActLabel.hidden = NO;
	}
	
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
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
	
	heroBringInButton.hidden = YES;
	villainBringInButton.hidden = YES;
	[heroBringInButton setNeedsDisplay];
	[villainBringInButton setNeedsDisplay];
	
	heroActLabel.hidden = YES;
	villainActLabel.hidden = YES;
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];
	
	[whoWonLabel setText:@""];
	[heroHandLabel setText:@""];
	[villainHandLabel setText:@""];
	[whoWonLabel setNeedsDisplay];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setNeedsDisplay];
	
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	heroCard4View.faceUp = YES;
	heroCard5View.faceUp = YES;
	heroCard6View.faceUp = NO;
	
	villainCard0View.faceUp = NO;
	villainCard1View.faceUp = NO;
	villainCard2View.faceUp = YES;
	villainCard3View.faceUp = YES;
	villainCard4View.faceUp = YES;
	villainCard5View.faceUp = YES;
	villainCard6View.faceUp = NO;

	heroCard0View.card = nil;
	heroCard1View.card = nil;
	heroCard2View.card = nil;
	heroCard3View.card = nil;
	heroCard4View.card = nil;
	heroCard5View.card = nil;
	heroCard6View.card = nil;
	
	villainCard0View.card = nil;
	villainCard1View.card = nil;
	villainCard2View.card = nil;
	villainCard3View.card = nil;
	villainCard4View.card = nil;
	villainCard5View.card = nil;
	villainCard6View.card = nil;
	
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
	
	[handFSM input:kEventDealt];
	
	// intialize view for a new hand
	[self setEnabledAllButtons:YES];
	
	nextHandButton.hidden = NO;
	nextStreetButton.hidden = NO;
	revealMyHandToMyselfButton.hidden = NO;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
	
	// determine who brings it in
	if ([self isHeroExposedHandBetter]) {
		heroBringInButton.hidden = YES;
		villainBringInButton.hidden = NO;
	} else {
		heroBringInButton.hidden = NO;
		villainBringInButton.hidden = YES;
	}
	
	[heroBringInButton setNeedsDisplay];
	[villainBringInButton setNeedsDisplay];
	
	// displays who's first to act
	[self displayWhosFirstToAct];
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
	// set up model	
	[hand newHandWithType:kHand7Stud];
	
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

- (void) dealNextStreet {
	[self setEnabledAllButtons:YES];
	nextHandButton.hidden = NO;
	nextStreetButton.hidden = NO;
	revealMyHandToMyselfButton.hidden = NO;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];	
		
	/*
	if (dealer) {
		heroActLabel.hidden = YES;
		villainActLabel.hidden = NO;
	} else {
		heroActLabel.hidden = NO;
		villainActLabel.hidden = YES;
	}		
	
	[heroActLabel setNeedsDisplay];
	[villainActLabel setNeedsDisplay];*/
	
	[hand nextStreet];
	switch (hand.street) {
		case kStreetFourth:
			if (dealer) {
				[self playDealingCardsSound];
				heroCard3View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				villainCard3View.card = [deck dealOneCard];
			} else {
				[self playDealingCardsSound];
				villainCard3View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				heroCard3View.card = [deck dealOneCard];
			}
			break;
		case kStreetFifth:
			if (dealer) {
				[self playDealingCardsSound];
				heroCard4View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				villainCard4View.card = [deck dealOneCard];
			} else {
				[self playDealingCardsSound];
				villainCard4View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				heroCard4View.card = [deck dealOneCard];
			}
			break;
		case kStreetSixth:
			if (dealer) {
				[self playDealingCardsSound];
				heroCard5View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				villainCard5View.card = [deck dealOneCard];
			} else {
				[self playDealingCardsSound];
				villainCard5View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				heroCard5View.card = [deck dealOneCard];
			}
			break;
		case kStreetSeventh:
			if (dealer) {
				[self playDealingCardsSound];
				heroCard6View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				villainCard6View.card = [deck dealOneCard];
			} else {
				[self playDealingCardsSound];
				villainCard6View.card = [deck dealOneCard];
				[self playDealingCardsSound];
				heroCard6View.card = [deck dealOneCard];
			}
			
			nextStreetButton.hidden = YES;
			[nextStreetButton setNeedsDisplay];
			
			allInButton.hidden = NO;
			[allInButton setNeedsDisplay];
									
			break;
		default:
			NSLog(@"wrong street: %@", hand.street);
			break;
	}
	
	[handFSM input:kEventDealt];
	
	// displays who's first to act
	[self displayWhosFirstToAct];
}

- (void) endAllIn {
	nextHandButton.hidden = NO;
	[nextHandButton setEnabled:YES];
		
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
	
	[Hand calcBestHand:heroCard0View.card :heroCard1View.card :heroCard2View.card :heroCard3View.card :heroCard4View.card :heroCard5View.card :heroCard6View.card :hand0];
	[Hand calcBestHand:villainCard0View.card :villainCard1View.card :villainCard2View.card :villainCard3View.card :villainCard4View.card :villainCard5View.card :villainCard6View.card :hand1];
	NSComparisonResult result = [Hand compareHands:hand0 :hand1];
	
	if (result == NSOrderedDescending) {
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"You won!"];
	} else if (result == NSOrderedAscending) {
		[whoWonLabel setText:@"You lost"];
	} else {
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"Split pot"];
	}

	[heroHandLabel setText:[hand0 handDescription]];
	[villainHandLabel setText:[hand1 handDescription]];	
	
	NSArray* heroCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						 heroCard4View, heroCard5View, heroCard6View, nil] retain];
			
	for (CardView* cardView in heroCards) {
		if (![self cardInGroup:cardView.card :hand0.cards])
			[cardView dullize];
	}
	
	NSArray* villainCards = [[NSArray arrayWithObjects:villainCard0View, villainCard1View, villainCard2View, villainCard3View,
						   villainCard4View, villainCard5View, villainCard6View, nil] retain];
	
	for (CardView* cardView in villainCards) {
		if (![self cardInGroup:cardView.card :hand1.cards])
			[cardView dullize];
	}	
	
	[heroCards release];
	[villainCards release];
	
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
	heroCard6View.faceUp = YES;
	
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	villainCard6View.faceUp = YES;
	
	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard6View setNeedsDisplay];
	
	[villainCard0View setNeedsDisplay];
	[villainCard1View setNeedsDisplay];
	[villainCard6View setNeedsDisplay];
	
	nextHandButton.hidden = YES;
	nextStreetButton.hidden = YES;
	allInButton.hidden = YES;
	revealMyHandToMyselfButton.hidden = YES;
	[nextHandButton setNeedsDisplay];
	[nextStreetButton setNeedsDisplay];
	[allInButton setNeedsDisplay];
	[revealMyHandToMyselfButton setNeedsDisplay];
			
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
		} else if (handFSM.state == kStateNextStreetReadyToBeDealt) {
			[self dealNextStreet];
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

- (IBAction) nextStreetButtonPressed:(id)sender {
	[self startWaiting];
	[self stopVillainsWaiting];
	[revealMyHandToMyselfButton setEnabled:YES];
	
	// send next street request to the other phone
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kMessageNextReq];
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
	heroCard6View.faceUp = YES;

	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard6View setNeedsDisplay];
}

- (IBAction) concealMyHand:(id)sender {
	heroCard0View.faceUp = NO;
	heroCard1View.faceUp = NO;
	heroCard6View.faceUp = NO;

	[heroCard0View setNeedsDisplay];
	[heroCard1View setNeedsDisplay];
	[heroCard6View setNeedsDisplay];
}

@end
