//
//  GameModeView.m
//  Headsup
//
//  Created by Haolan Qin on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OmahaTrainingModeView.h"
#import "Constants.h"
#import "Deck.h"
#import "Card.h"
#import "Hand.h"
#import "CardView.h"
#import "AppController.h"
#import "MadeHand.h"

#define DELAY_TO_DEAL_NEXT_HOLE_CARD 0.2
#define DELAY_TO_DEAL_FLOP 9.0
#define DELAY_TO_DEAL_TURN_RIVER 9.0
#define SHOWDOWN_DELAY 15.0
#define INFO_DELAY 0.002
#define DELAY_DEAL_TO_THE_RIVER 9.0

#define SIMULATION_ITERATIONS 500

#define INVALID_PERCENTAGE 200

#define PLAY_BUTTON_TITLE @"Play"
#define PAUSE_BUTTON_TITLE @"Pause"
#define SAME_BUTTON_TITLE @"A"
#define DIFFERENT_BUTTON_TITLE @"B"

#define PLAY_BUTTON_IMAGE @"training_play.png"
#define PAUSE_BUTTON_IMAGE @"training_pause.png"
#define SAME_BUTTON_IMAGE @"mode_a.png"
#define DIFFERENT_BUTTON_IMAGE @"mode_b.png"

#define STATUS_DEALING	@"Dealing..."
#define STATUS_CALCULATING @"Calculating..."
#define STATUS_IDLING	@"Idling..."
#define STATUS_SHOWDOWN @"Showdown..."

@implementation OmahaTrainingModeView

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

@synthesize heroStatusLabel;
@synthesize heroPercentageLabel;
@synthesize heroHandLabel;
@synthesize heroOutsLabel;
@synthesize heroWinsLabel;
@synthesize villainStatusLabel;
@synthesize villainPercentageLabel;
@synthesize villainHandLabel;
@synthesize villainOutsLabel;
@synthesize villainWinsLabel;

@synthesize endButton;
@synthesize lobbyButton;

@synthesize waitingIndicator;

@synthesize gameNameLabel;
@synthesize handCountLabel;

@synthesize playPauseButton;
@synthesize skipButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize handButton;
@synthesize sameDifferentButton;

@synthesize deck;
@synthesize hand;



- (void) resetStuff {
	free(applicationData);
	applicationData = malloc(OMAHA_TRAINING_MODE_APPLICATION_DATA_LENGTH * sizeof(uint8_t));
	applicationData[0] = (uint8_t)0;
	
	[hand release];
	[deck release];
	hand = [[Hand alloc] init];
	deck = [[Deck alloc] init];		
	
	cardsDealt = [[NSMutableArray alloc] init];

	// reset end button
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
		
	endButton.hidden = YES;
	[endButton setNeedsDisplay];
	
	[sameDifferentButton setHidden:YES];
	[playPauseButton setHidden:YES];
	[skipButton setHidden:YES];
	[prevButton setHidden:YES];
	[nextButton setHidden:YES];	
	[handButton setHidden:YES];	
	
	handCount = 0;	
	
	heroOrVillainHand = YES;
}

- (void)setUpStuff {
	[self resetStuff];
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
	[cardsDealt release];

	[hand release];
	[deck release];
	
	free(applicationData);
	
    [super dealloc];
}

- (BOOL) isSameCardsMode {
	NSString *title = [sameDifferentButton titleForState:UIControlStateNormal];
	
	return [title isEqualToString:DIFFERENT_BUTTON_TITLE];
}

- (BOOL) isPaused {
	NSString *title = [playPauseButton titleForState:UIControlStateNormal];
	
	return [title isEqualToString:PLAY_BUTTON_TITLE];
}

- (void) updateNumberLabel:(UILabel*)label addAmount:(float)amount {
	float currentValue = [[label text] floatValue];
	[label setText:[NSString stringWithFormat:@"%.1f", currentValue + amount]];
	[label setNeedsDisplay];
}

// return N in B mode (run it N times mode)
- (NSInteger) currentCount {
	float heroWins = [[heroWinsLabel text] floatValue];
	float villainWins = [[villainWinsLabel text] floatValue];
	
	return heroWins + villainWins;
}

// return the number of cards to be dealt in B mode
- (NSInteger) currentSize {
	NSInteger retval = 0;
	
	if (hand.street == kStreetPreflop)
		retval = 5;
	else if (hand.street == kStreetFlop)
		retval = 2;
	else if (hand.street == kStreetTurn)
		retval = 1;
	
	return retval;
}

- (void) saveToApplicationData {
	// play or pause
	// save isPaused flag.
	SET_BOOLEAN_FLAG(applicationData[1], 
					 0, 
					 [self isPaused]);
	
	// save isSameCardsMode flag.
	SET_BOOLEAN_FLAG(applicationData[1], 
					 1, 
					 [self isSameCardsMode]);	
	
	// street
	applicationData[4] = (uint8_t)hand.street;
}	

- (void) savePercentagesInApplicationData {
	applicationData[18] = preflopHeroPercentage;
	applicationData[19] = preflopVillainPercentage;
	applicationData[20] = flopHeroPercentage;
	applicationData[21] = flopVillainPercentage;
}

- (NSData*) getApplicationData {
	return [[[NSData alloc] initWithBytes:applicationData length:OMAHA_TRAINING_MODE_APPLICATION_DATA_LENGTH] autorelease];
}

- (void) clearApplicationData {
	applicationData[0] = (uint8_t)0;
	[appController writeOmahaTrainingModeApplicationData:[self getApplicationData]];
}

/*
- (void) startWaitIndicator {
	waitingIndicator.hidden = NO;
	[waitingIndicator startAnimating];
}

- (void) stopWaitIndicator {
	waitingIndicator.hidden = YES;
	[waitingIndicator stopAnimating];
}*/

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

- (void) highlightWinningHand {
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
	
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						  villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
						  communityCard0View, communityCard1View,
						  communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	NSArray* winningHand = (result == NSOrderedAscending) ? hand1.cards : hand0.cards;
	
	for (CardView* cardView in allCards) {
		if (![self cardInGroup:cardView.card :winningHand])
			[cardView dullize];
	}
	
	[allCards release];
	
	[hand0 release];
	[hand1 release];	
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
	
	// award the pot to the winner and update screen.
	if (result == NSOrderedAscending) {
		// villain won
		[heroStatusLabel setText:@"Lost"];
		[heroStatusLabel setNeedsDisplay];
		[villainStatusLabel setText:@"Won"];
		[villainStatusLabel setNeedsDisplay];
	} else if (result == NSOrderedDescending) {
		// hero won
		[heroStatusLabel setText:@"Won"];
		[heroStatusLabel setNeedsDisplay];
		[villainStatusLabel setText:@"Lost"];
		[villainStatusLabel setNeedsDisplay];
	} else if (result == NSOrderedSame) {
		// split pot
		[heroStatusLabel setText:@"Split pot"];
		[heroStatusLabel setNeedsDisplay];
		[villainStatusLabel setText:@"Split pot"];
		[villainStatusLabel setNeedsDisplay];
	}
	
	
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						  villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
						  communityCard0View, communityCard1View,
						  communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	NSArray* winningHand = (result == NSOrderedAscending) ? hand1.cards : hand0.cards;
	
	for (CardView* cardView in allCards) {
		if (![self cardInGroup:cardView.card :winningHand])
			[cardView dullize];
	}
		
	[allCards release];
	
	[hand0 release];
	[hand1 release];	
}

- (void) displayWhoIsWinning:(NSComparisonResult)result {
	if (result == NSOrderedAscending) {
		// villain winning
		[heroStatusLabel setText:@"Losing"];
		[heroStatusLabel setNeedsDisplay];
		[villainStatusLabel setText:@"Winning"];
		[villainStatusLabel setNeedsDisplay];
	} else if (result == NSOrderedDescending) {
		// hero won
		[heroStatusLabel setText:@"Winning"];
		[heroStatusLabel setNeedsDisplay];
		[villainStatusLabel setText:@"Losing"];
		[villainStatusLabel setNeedsDisplay];
	} else if (result == NSOrderedSame) {
		// split pot
		[heroStatusLabel setText:@"Tieing"];
		[heroStatusLabel setNeedsDisplay];
		[villainStatusLabel setText:@"Tieing"];
		[villainStatusLabel setNeedsDisplay];
	}
}

- (void) clearScreen {
	[heroHandLabel setText:@""]; 
	[heroHandLabel setNeedsDisplay];
	[heroOutsLabel setText:@""]; 
	[heroOutsLabel setNeedsDisplay];
	[villainHandLabel setText:@""]; 
	[villainHandLabel setNeedsDisplay];
	[villainOutsLabel setText:@""]; 
	[villainOutsLabel setNeedsDisplay];
	
	if ([self isSameCardsMode]) {
		[heroWinsLabel setText:@"0"];
		[villainWinsLabel setText:@"0"];
		[heroWinsLabel setHidden:NO];
		[villainWinsLabel setHidden:NO];
	} else {
		[heroWinsLabel setText:@""];
		[villainWinsLabel setText:@""];
		[heroWinsLabel setHidden:YES];
		[villainWinsLabel setHidden:YES];		
	}
	
	[heroStatusLabel setText:@""];
	[heroStatusLabel setNeedsDisplay];
	[villainStatusLabel setText:@""];
	[villainStatusLabel setNeedsDisplay];
	
	[heroPercentageLabel setText:@""];
	[heroPercentageLabel setNeedsDisplay];
	[villainPercentageLabel setText:@""];
	[villainPercentageLabel setNeedsDisplay];	
}	

- (void) displayPreflopPercentages {	
	[heroPercentageLabel setText:[NSString stringWithFormat:@"%d%%", preflopHeroPercentage]];
	[heroPercentageLabel setNeedsDisplay];
	[villainPercentageLabel setText:[NSString stringWithFormat:@"%d%%", preflopVillainPercentage]];
	[villainPercentageLabel setNeedsDisplay];
	
	if (preflopHeroPercentage > 50) {
		[self displayWhoIsWinning:NSOrderedDescending];
	} else if (preflopHeroPercentage < 50) {
		[self displayWhoIsWinning:NSOrderedAscending];
	} else { // if (preflopHeroPercentage == 50)
		[self displayWhoIsWinning:NSOrderedSame];
	}			
}

- (void) calculatePreflopPercentage {
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSMutableArray *remainingDeck = [[NSMutableArray alloc] init];
	
	NSInteger heroWinCount = 0;
	NSInteger heroLossCount = 0;
	NSInteger heroTieCount = 0;
	
	NSMutableArray *holeCards = [[NSMutableArray alloc] init];
	NSMutableArray *communityCards = [[NSMutableArray alloc] init];
	
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
	
	[remainingDeck removeObject:heroCard0View.card];
	[remainingDeck removeObject:heroCard1View.card];
	[remainingDeck removeObject:heroCard2View.card];
	[remainingDeck removeObject:heroCard3View.card];
	[remainingDeck removeObject:villainCard0View.card];
	[remainingDeck removeObject:villainCard1View.card];	
	[remainingDeck removeObject:villainCard2View.card];
	[remainingDeck removeObject:villainCard3View.card];	
	
	const NSInteger remainingCardsTotal = [remainingDeck count];	
	
	int* cardIndexes = malloc(sizeof(int) * 5);
	
	for (int i=0; i < SIMULATION_ITERATIONS; i++) {
		/*[remainingDeck removeAllObjects];
		 [remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
		 [remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
		 [remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
		 [remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
		 
		 [remainingDeck removeObject:heroCard0View.card];
		 [remainingDeck removeObject:heroCard1View.card];
		 [remainingDeck removeObject:heroCard2View.card];
		 [remainingDeck removeObject:heroCard3View.card];
		 [remainingDeck removeObject:villainCard0View.card];
		 [remainingDeck removeObject:villainCard1View.card];	
		 [remainingDeck removeObject:villainCard2View.card];
		 [remainingDeck removeObject:villainCard3View.card];
		 
		 NSInteger remainingCardsTotal = [remainingDeck count];
		 
		 NSInteger flopCard0Index = random() % remainingCardsTotal;
		 Card *flopCard0 = [remainingDeck objectAtIndex:flopCard0Index];
		 --remainingCardsTotal;
		 [remainingDeck removeObject:flopCard0];
		 
		 NSInteger flopCard1Index = random() % remainingCardsTotal;
		 Card *flopCard1 = [remainingDeck objectAtIndex:flopCard1Index];
		 --remainingCardsTotal;
		 [remainingDeck removeObject:flopCard1];
		 
		 NSInteger flopCard2Index = random() % remainingCardsTotal;
		 Card *flopCard2 = [remainingDeck objectAtIndex:flopCard2Index];
		 --remainingCardsTotal;
		 [remainingDeck removeObject:flopCard2];
		 
		 NSInteger turnCardIndex = random() % remainingCardsTotal;
		 Card *turnCard = [remainingDeck objectAtIndex:turnCardIndex];
		 --remainingCardsTotal;
		 [remainingDeck removeObject:turnCard];
		 
		 NSInteger riverCardIndex = random() % remainingCardsTotal;
		 Card *riverCard = [remainingDeck objectAtIndex:riverCardIndex];*/
		
		for (int j=0; j < 5; j++)
			cardIndexes[j] = random() % (remainingCardsTotal-j);
		
		for (int j=1; j < 5; j++) {
			int bigCount = 0;
			for (int k=0; k < j; k++) {
				if (cardIndexes[j] >= cardIndexes[k])
					++bigCount;
			}
			
			cardIndexes[j] += bigCount;
		}
		
		Card *flopCard0 = [remainingDeck objectAtIndex:cardIndexes[0]];
		Card *flopCard1 = [remainingDeck objectAtIndex:cardIndexes[1]];
		Card *flopCard2 = [remainingDeck objectAtIndex:cardIndexes[2]];
		Card *turnCard = [remainingDeck objectAtIndex:cardIndexes[3]];
		Card *riverCard = [remainingDeck objectAtIndex:cardIndexes[4]];
		
		
		[Hand calcOmahaBestHandFast
		 :heroCard0View.card 
		 :heroCard1View.card 
		 :heroCard2View.card 
		 :heroCard3View.card 
		 :flopCard0
		 :flopCard1
		 :flopCard2
		 :turnCard
		 :riverCard
		 :holeCards
		 :communityCards
		 :hand0];
		
		[Hand calcOmahaBestHandFast
		 :villainCard0View.card 
		 :villainCard1View.card 
		 :villainCard2View.card 
		 :villainCard3View.card 
		 :flopCard0
		 :flopCard1
		 :flopCard2
		 :turnCard
		 :riverCard
		 :holeCards
		 :communityCards
		 :hand1];
		
		NSComparisonResult r = [Hand compareHandsFast:hand0 :hand1];
		if (r == NSOrderedAscending) {
			++heroLossCount;
		} else if (r == NSOrderedDescending) {
			++heroWinCount;
		} else { // r == NSOrderedTheSame
			++heroTieCount;
		}			
	}
	
	free(cardIndexes);
	
	[holeCards release];
	[communityCards release];
	
	const NSInteger total = heroWinCount + heroLossCount + heroTieCount;
	preflopHeroPercentage = (heroWinCount * 1.0 + heroTieCount * .5) / total * 100;
	preflopVillainPercentage = 100 - preflopHeroPercentage;
	[self savePercentagesInApplicationData];
		
	[remainingDeck release];
	
	[hand0 release];
	[hand1 release];	
}

- (void) displayPreflopInfo {
	[self clearScreen];
	
	[sameDifferentButton setHidden:YES];	
	[playPauseButton setHidden:YES];
	[skipButton setHidden:YES];
	[prevButton setHidden:YES];
	[nextButton setHidden:YES];	
	[handButton setHidden:YES];	
	
	[self startWaitIndicator:STATUS_CALCULATING];
	infoTimer = [NSTimer scheduledTimerWithTimeInterval:INFO_DELAY target:self selector:@selector(displayPreflopInfoTimerMethod) userInfo:nil repeats:NO];
}

- (void) displayPreflopInfoTimerMethod {
	infoTimer = nil;
	
	if (preflopHeroPercentage == INVALID_PERCENTAGE) {
		[self calculatePreflopPercentage];
	}
	
	[self displayPreflopPercentages];	
	
	[playPauseButton setHidden:NO];
	[skipButton setHidden:NO];
	
	if ([self isPaused]) {
		[sameDifferentButton setHidden:NO];
		[prevButton setHidden:YES];
		[nextButton setHidden:NO];	
		[handButton setHidden:YES];
	}
	
	[self stopWaitIndicator];
	
	if (![self isPaused]) {
		if ([self isSameCardsMode]) {
			[self startWaitIndicator:STATUS_IDLING];
			
			dealToTheRiverTimer = 
			[NSTimer scheduledTimerWithTimeInterval:DELAY_DEAL_TO_THE_RIVER
											 target:self 
										   selector:@selector(dealToTheRiver) 
										   userInfo:nil 
											repeats:YES];
		} else {			
			[self startWaitIndicator:STATUS_IDLING];
			
			allInDealingTimer = 
			[NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_FLOP 
											 target:self 
										   selector:@selector(beforeDealingNextStreetTimerFireMethod) 
										   userInfo:nil 
											repeats:NO];	
		}
	}
}	

- (void) displayFlopPercentages {
	[heroPercentageLabel setText:[NSString stringWithFormat:@"%d%%", flopHeroPercentage]];
	[heroPercentageLabel setNeedsDisplay];
	[villainPercentageLabel setText:[NSString stringWithFormat:@"%d%%", flopVillainPercentage]];
	[villainPercentageLabel setNeedsDisplay];
}	

- (void) calculateFlopPercentage {
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSMutableArray *remainingDeck = [[NSMutableArray alloc] init];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
	
	[remainingDeck removeObject:heroCard0View.card];
	[remainingDeck removeObject:heroCard1View.card];
	[remainingDeck removeObject:heroCard2View.card];
	[remainingDeck removeObject:heroCard3View.card];
	[remainingDeck removeObject:villainCard0View.card];
	[remainingDeck removeObject:villainCard1View.card];
	[remainingDeck removeObject:villainCard2View.card];
	[remainingDeck removeObject:villainCard3View.card];
	[remainingDeck removeObject:communityCard0View.card];
	[remainingDeck removeObject:communityCard1View.card];
	[remainingDeck removeObject:communityCard2View.card];	
	
	NSInteger heroWinCount = 0;
	NSInteger heroLossCount = 0;
	NSInteger heroTieCount = 0;
	const NSInteger remainingCardsTotal = [remainingDeck count];

	NSMutableArray *holeCards = [[NSMutableArray alloc] init];
	NSMutableArray *communityCards = [[NSMutableArray alloc] init];

	for (int i=0; i < remainingCardsTotal - 1; i++) {
		for (int j=i+1; j < remainingCardsTotal; j++) {
			Card *turnCard = [remainingDeck objectAtIndex:i];
			Card *riverCard = [remainingDeck objectAtIndex:j];
			
			[Hand calcOmahaBestHandFast
			 :heroCard0View.card 
			 :heroCard1View.card 
			 :heroCard2View.card 
			 :heroCard3View.card 
			 :communityCard0View.card 
			 :communityCard1View.card 
			 :communityCard2View.card 
			 :turnCard
			 :riverCard
			 :holeCards
			 :communityCards
			 :hand0];
			
			[Hand calcOmahaBestHandFast
			 :villainCard0View.card 
			 :villainCard1View.card 
			 :villainCard2View.card 
			 :villainCard3View.card 
			 :communityCard0View.card 
			 :communityCard1View.card 
			 :communityCard2View.card 
			 :turnCard
			 :riverCard
			 :holeCards
			 :communityCards
			 :hand1];
			
			NSComparisonResult r = [Hand compareHandsFast:hand0 :hand1];
			
			if (r == NSOrderedAscending) {
				++heroLossCount;
			} else if (r == NSOrderedDescending) {
				++heroWinCount;
			} else { // r == NSOrderedTheSame
				++heroTieCount;
			}
			
		}
	}

	[holeCards release];
	[communityCards release];


	const NSInteger total = heroWinCount + heroLossCount + heroTieCount;
	flopHeroPercentage = (heroWinCount * 1.0 + heroTieCount * .5) / total * 100;
	flopVillainPercentage = 100 - flopHeroPercentage;
	[self savePercentagesInApplicationData];
	
	[remainingDeck release];
	
	[hand0 release];
	[hand1 release];	
}

- (void) displayFlopInfo {
	[self clearScreen];
	
	[sameDifferentButton setHidden:YES];
	[playPauseButton setHidden:YES];
	[skipButton setHidden:YES];
	[prevButton setHidden:YES];
	[nextButton setHidden:YES];	
	[handButton setHidden:YES];		
	
	[self startWaitIndicator:STATUS_CALCULATING];
	infoTimer = [NSTimer scheduledTimerWithTimeInterval:INFO_DELAY target:self selector:@selector(displayFlopInfoTimerMethod) userInfo:nil repeats:NO];
}

- (void) displayFlopInfoTimerMethod {
	infoTimer = nil;
	
	// calculate outs		
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSMutableArray *remainingDeck = [[NSMutableArray alloc] init];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
	
	NSComparisonResult result;
		
	NSInteger numWinningOuts = 0;
	NSInteger numTieingOuts = 0;

	[Hand calcOmahaBestHand
	 :heroCard0View.card 
	 :heroCard1View.card 
	 :heroCard2View.card 
	 :heroCard3View.card 
	 :communityCard0View.card 
	 :communityCard1View.card 
	 :communityCard2View.card 
	 :hand0];
	
	[Hand calcOmahaBestHand
	 :villainCard0View.card 
	 :villainCard1View.card 
	 :villainCard2View.card 
	 :villainCard3View.card 
	 :communityCard0View.card 
	 :communityCard1View.card 
	 :communityCard2View.card 
	 :hand1];
	
	[heroHandLabel setText:[hand0 detailedHandDescription]];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setText:[hand1 detailedHandDescription]];
	[villainHandLabel setNeedsDisplay];
	
	result = [Hand compareHands:hand0 :hand1];
	[self displayWhoIsWinning :result];
	
	
	[remainingDeck removeObject:heroCard0View.card];
	[remainingDeck removeObject:heroCard1View.card];
	[remainingDeck removeObject:heroCard2View.card];
	[remainingDeck removeObject:heroCard3View.card];
	[remainingDeck removeObject:villainCard0View.card];
	[remainingDeck removeObject:villainCard1View.card];
	[remainingDeck removeObject:villainCard2View.card];
	[remainingDeck removeObject:villainCard3View.card];
	[remainingDeck removeObject:communityCard0View.card];
	[remainingDeck removeObject:communityCard1View.card];
	[remainingDeck removeObject:communityCard2View.card];			
	
	for (Card *card in remainingDeck) {
		[Hand calcOmahaBestHandFast
		 :heroCard0View.card 
		 :heroCard1View.card 
		 :heroCard2View.card 
		 :heroCard3View.card 
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :card
		 :hand0];
		
		[Hand calcOmahaBestHandFast
		 :villainCard0View.card 
		 :villainCard1View.card 
		 :villainCard2View.card 
		 :villainCard3View.card 
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :card
		 :hand1];
		
		NSComparisonResult r = [Hand compareHandsFast:hand0 :hand1];
		
		if (result == NSOrderedAscending) {
			if (r == NSOrderedDescending)
				++numWinningOuts;
			else if (r == NSOrderedSame)
				++numTieingOuts;
		} else if (result == NSOrderedDescending) {
			if (r == NSOrderedAscending)
				++numWinningOuts;
			else if (r == NSOrderedSame)
				++numTieingOuts;
		} else { // result == NSOrderedTheSame
			if (r == NSOrderedDescending)
				++numWinningOuts;
			else if (r == NSOrderedSame)
				++numTieingOuts;					
		}
	}
	
	[remainingDeck release];
	
	[hand0 release];
	[hand1 release];	
	
	if (flopHeroPercentage == INVALID_PERCENTAGE) {
		[self calculateFlopPercentage];
	}
	
	[heroOutsLabel setText:@""];
	[heroOutsLabel setNeedsDisplay];
	[villainOutsLabel setText:@""];
	[villainOutsLabel setNeedsDisplay];
	
	if (result == NSOrderedAscending) {
		[heroOutsLabel setText:[NSString stringWithFormat:@"%d outs", numWinningOuts + numTieingOuts]];
	} else if (result == NSOrderedDescending) {
		[villainOutsLabel setText:[NSString stringWithFormat:@"%d outs", numWinningOuts + numTieingOuts]];
	} else { // result == NSOrderedTheSame
		[heroOutsLabel setText:[NSString stringWithFormat:@"%d outs", numWinningOuts + numTieingOuts]];
	}			

	[self displayFlopPercentages];
		
	[playPauseButton setHidden:NO];
	[skipButton setHidden:NO];
	
	if ([self isPaused]) {
		[sameDifferentButton setHidden:NO];
		
		if (![self isSameCardsMode])
			[prevButton setHidden:NO];
		[nextButton setHidden:NO];	
		if (![self isSameCardsMode])
			[handButton setHidden:NO];	
	}		
	
	[self stopWaitIndicator];
	
	if (![self isSameCardsMode] && ![self isPaused]) {
		[self startWaitIndicator:STATUS_IDLING];

		allInDealingTimer = 
		[NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_FLOP target:self selector:@selector(beforeDealingNextStreetTimerFireMethod) userInfo:nil repeats:YES];		
	}
}

- (void) displayTurnInfo {
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSMutableArray *remainingDeck = [[NSMutableArray alloc] init];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
	
	NSComparisonResult result;
	
	NSInteger heroPercentage, villainPercentage;
	
	[Hand calcOmahaBestHand
	 :heroCard0View.card 
	 :heroCard1View.card 
	 :heroCard2View.card 
	 :heroCard3View.card 
	 :communityCard0View.card 
	 :communityCard1View.card 
	 :communityCard2View.card 
	 :communityCard3View.card
	 :hand0];
	
	[Hand calcOmahaBestHand
	 :villainCard0View.card 
	 :villainCard1View.card 
	 :villainCard2View.card 
	 :villainCard3View.card 
	 :communityCard0View.card 
	 :communityCard1View.card 
	 :communityCard2View.card 
	 :communityCard3View.card
	 :hand1];
	
	[heroHandLabel setText:[hand0 detailedHandDescription]];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setText:[hand1 detailedHandDescription]];
	[villainHandLabel setNeedsDisplay];
	
	result = [Hand compareHands:hand0 :hand1];
	[self displayWhoIsWinning :result];
	
	
	[remainingDeck removeObject:heroCard0View.card];
	[remainingDeck removeObject:heroCard1View.card];
	[remainingDeck removeObject:heroCard2View.card];
	[remainingDeck removeObject:heroCard3View.card];
	[remainingDeck removeObject:villainCard0View.card];
	[remainingDeck removeObject:villainCard1View.card];
	[remainingDeck removeObject:villainCard2View.card];
	[remainingDeck removeObject:villainCard3View.card];
	[remainingDeck removeObject:communityCard0View.card];
	[remainingDeck removeObject:communityCard1View.card];
	[remainingDeck removeObject:communityCard2View.card];
	[remainingDeck removeObject:communityCard3View.card];
	
	NSInteger numWinningOuts = 0;
	NSInteger numTieingOuts = 0;
	
	NSMutableArray *holeCards = [[NSMutableArray alloc] init];
	NSMutableArray *communityCards = [[NSMutableArray alloc] init];
	
	for (Card *card in remainingDeck) {
		[Hand calcOmahaBestHandFast
		 :heroCard0View.card 
		 :heroCard1View.card 
		 :heroCard2View.card 
		 :heroCard3View.card 
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :communityCard3View.card
		 :card
		 :holeCards
		 :communityCards
		 :hand0];
		
		[Hand calcOmahaBestHandFast
		 :villainCard0View.card 
		 :villainCard1View.card 
		 :villainCard2View.card 
		 :villainCard3View.card 
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :communityCard3View.card
		 :card
		 :holeCards
		 :communityCards
		 :hand1];
		
		NSComparisonResult r = [Hand compareHandsFast:hand0 :hand1];
		
		if (result == NSOrderedAscending) {
			if (r == NSOrderedDescending)
				++numWinningOuts;
			else if (r == NSOrderedSame)
				++numTieingOuts;
		} else if (result == NSOrderedDescending) {
			if (r == NSOrderedAscending)
				++numWinningOuts;
			else if (r == NSOrderedSame)
				++numTieingOuts;
		} else { // result == NSOrderedTheSame
			if (r == NSOrderedDescending)
				++numWinningOuts;
			else if (r == NSOrderedSame)
				++numTieingOuts;					
		}
	}
	
	[holeCards release];
	[communityCards release];

	
	[heroOutsLabel setText:@""];
	[heroOutsLabel setNeedsDisplay];
	[villainOutsLabel setText:@""];
	[villainOutsLabel setNeedsDisplay];
	
	if (result == NSOrderedAscending) {
		[heroOutsLabel setText:[NSString stringWithFormat:@"%d outs", numWinningOuts + numTieingOuts]];
		heroPercentage = (numWinningOuts * 1.0 + numTieingOuts * .5) / 44 * 100;
		villainPercentage = 100 - heroPercentage;
	} else if (result == NSOrderedDescending) {
		[villainOutsLabel setText:[NSString stringWithFormat:@"%d outs", numWinningOuts + numTieingOuts]];
		villainPercentage = (numWinningOuts * 1.0 + numTieingOuts * .5) / 44 * 100;
		heroPercentage = 100 - villainPercentage;
	} else { // result == NSOrderedTheSame
		[heroOutsLabel setText:[NSString stringWithFormat:@"%d outs", numWinningOuts + numTieingOuts]];
		heroPercentage = (numWinningOuts * 1.0 + numTieingOuts * .5) / 44 * 100;
		villainPercentage = 100 - heroPercentage;				
	}			
	
	[heroPercentageLabel setText:[NSString stringWithFormat:@"%d%%", heroPercentage]];
	[heroPercentageLabel setNeedsDisplay];
	[villainPercentageLabel setText:[NSString stringWithFormat:@"%d%%", villainPercentage]];
	[villainPercentageLabel setNeedsDisplay];
	
	[remainingDeck release];
	
	[hand0 release];
	[hand1 release];	
}

- (void) displayRiverInfo {	
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSMutableArray *remainingDeck = [[NSMutableArray alloc] init];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
	
	NSComparisonResult result;
	
	NSInteger heroPercentage, villainPercentage;
	
	[Hand calcOmahaBestHand
	 :heroCard0View.card 
	 :heroCard1View.card 
	 :heroCard2View.card 
	 :heroCard3View.card 
	 :communityCard0View.card 
	 :communityCard1View.card 
	 :communityCard2View.card 
	 :communityCard3View.card
	 :communityCard4View.card
	 :hand0];
	
	[Hand calcOmahaBestHand
	 :villainCard0View.card 
	 :villainCard1View.card 
	 :villainCard2View.card 
	 :villainCard3View.card 
	 :communityCard0View.card 
	 :communityCard1View.card 
	 :communityCard2View.card 
	 :communityCard3View.card
	 :communityCard4View.card
	 :hand1];
	
	[heroHandLabel setText:[hand0 detailedHandDescription]];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setText:[hand1 detailedHandDescription]];
	[villainHandLabel setNeedsDisplay];
	
	[heroOutsLabel setText:@""];
	[heroOutsLabel setNeedsDisplay];
	[villainOutsLabel setText:@""];
	[villainOutsLabel setNeedsDisplay];
	
	result = [Hand compareHands:hand0 :hand1];
	
	if (result == NSOrderedAscending) {
		heroPercentage = 0;
		villainPercentage = 100;
	} else if (result == NSOrderedDescending) {
		heroPercentage = 100;
		villainPercentage = 0;
	} else { // result == NSOrderedTheSame
		heroPercentage = 50;
		villainPercentage = 50;
	}			
	
	[heroPercentageLabel setText:[NSString stringWithFormat:@"%d%%", heroPercentage]];
	[heroPercentageLabel setNeedsDisplay];
	[villainPercentageLabel setText:[NSString stringWithFormat:@"%d%%", villainPercentage]];
	[villainPercentageLabel setNeedsDisplay];			
	
	[remainingDeck release];
	
	[hand0 release];
	[hand1 release];	
}

- (void) dealNextStreetCards {
	[hand nextStreet];

	switch (hand.street) {
		case kStreetFlop:
			communityCard0View.card = [deck dealOneCard];
			communityCard1View.card = [deck dealOneCard];
			communityCard2View.card = [deck dealOneCard];
			
			[self displayFlopInfo];
						
			break;
			
		case kStreetTurn:
			communityCard3View.card = [deck dealOneCard];
							
			[self displayTurnInfo];
			break;
			
		case kStreetRiver:
			communityCard4View.card = [deck dealOneCard];
						
			[self displayRiverInfo];
			break;
		default:
			NSLog(@"wrong street: %u", hand.street);
			break;
	}	
	
}

		

// called after showdown
// we have to be careful with this timer method. even though this is a single-threaded program,
// if hero is not the dealer after this all-in hand, it's possible that this method is triggered
// after the next hand is already dealt!
- (void)afterDisplayingWhoWonTimerFireMethod {
	[showdownTimer invalidate];
	showdownTimer = nil;
	
	[self dealNewHandAsDealer];	
}	

- (void)beforeDealingNextStreetTimerFireMethod {
	[self dealNextStreetCards];
	
	[self saveToApplicationData];
	
	if (hand.street == kStreetRiver) {
		[allInDealingTimer invalidate];
		allInDealingTimer = nil;

		[self displayWhoWon];
		[self startWaitIndicator:STATUS_SHOWDOWN];
		showdownTimer = [NSTimer scheduledTimerWithTimeInterval:SHOWDOWN_DELAY target:self selector:@selector(afterDisplayingWhoWonTimerFireMethod) userInfo:nil repeats:NO];
	}
	
}	

- (void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	if (buttonIndex == 0) {
		[self willDisplay];
	} else {
		// do nothing
	}	
}

- (void) killAllActiveTimers {
	[showdownTimer invalidate];
	showdownTimer = nil;
	
	[allInDealingTimer invalidate];
	allInDealingTimer = nil;
	
	[holeCardsDealingTimer invalidate];
	holeCardsDealingTimer = nil;	
	
	[infoTimer invalidate];
	infoTimer = nil;
	
	[dealToTheRiverTimer invalidate];
	dealToTheRiverTimer = nil;
	
	[self stopWaitIndicator];
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
	[appController writeOmahaTrainingModeApplicationData:[self getApplicationData]];
	
	[navController popViewControllerAnimated:YES];
}

- (void) brightizeAllCards {
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						  villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
						  communityCard0View, communityCard1View,
						  communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	for (CardView* cardView in allCards) {
		if (cardView.dull)
			[cardView toggleDull];
	}
	
	[allCards release];
}	

- (IBAction) sameDifferentButtonPressed:(id)sender {
	NSString *title = [sameDifferentButton titleForState:UIControlStateNormal];
	
	if ([title isEqualToString:SAME_BUTTON_TITLE]) {
		[AppController changeTitleOfButton:sameDifferentButton to:DIFFERENT_BUTTON_TITLE];
		[AppController changeImageOfButton:sameDifferentButton to:DIFFERENT_BUTTON_IMAGE];
		
		[prevButton setHidden:YES];
		
		[handButton setHidden:YES];
		
		[heroWinsLabel setText:@"0"];
		[villainWinsLabel setText:@"0"];	
		
		[heroWinsLabel setHidden:NO];
		[villainWinsLabel setHidden:NO];
	} else {
		[AppController changeTitleOfButton:sameDifferentButton to:SAME_BUTTON_TITLE];
		[AppController changeImageOfButton:sameDifferentButton to:SAME_BUTTON_IMAGE];
		
		if (hand.street != kStreetPreflop)
			[prevButton setHidden:NO];
		
		if (hand.street == kStreetPreflop)
			[handButton setHidden:YES];
		else
			[handButton setHidden:NO];
		
		[heroWinsLabel setHidden:YES];
		[villainWinsLabel setHidden:YES];
		
		[heroHandLabel setText:@""];
		[heroHandLabel setNeedsDisplay];
		[villainHandLabel setText:@""];
		[villainHandLabel setNeedsDisplay];		
		
		[self brightizeAllCards];
		
		if (hand.street == kStreetPreflop) {
			communityCard0View.card = nil;
			communityCard1View.card = nil;
			communityCard2View.card = nil;
			communityCard3View.card = nil;
			communityCard4View.card = nil;
		} else if (hand.street == kStreetFlop) {
			communityCard3View.card = nil;
			communityCard4View.card = nil;
		} else if (hand.street == kStreetTurn) {
			communityCard4View.card = nil;
		}
	}
	
	[cardsDealt removeAllObjects];

	[self saveToApplicationData];
}

// isGoingBacking: YES going backwards in cardsDealt. currentCount - 1 should
//                 be used and hero/villain wins should NOT be updated.
- (void) dealToTheRiverTwoCases:(BOOL)isGoingBack {
	[self brightizeAllCards];
	
	if ([self isPaused])
		[handButton setHidden:NO];
	
	NSMutableArray *remainingDeck = [[NSMutableArray alloc] init];
	
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[remainingDeck addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];	
	
	[remainingDeck removeObject:heroCard0View.card];
	[remainingDeck removeObject:heroCard1View.card];
	[remainingDeck removeObject:heroCard2View.card];
	[remainingDeck removeObject:heroCard3View.card];
	[remainingDeck removeObject:villainCard0View.card];
	[remainingDeck removeObject:villainCard1View.card];	
	[remainingDeck removeObject:villainCard2View.card];
	[remainingDeck removeObject:villainCard3View.card];	
	
	NSInteger currentCount = [self currentCount];
	NSInteger currentSize = [self currentSize];
	NSInteger currentPos = currentCount * currentSize;
	
	if (isGoingBack)
		currentPos -= currentSize;
	
	// newCards: YES new cards are to be dealt and stored in cardsDealt
	//           NO cards in cardsDealt are going to be used based on 
	//           currentCount and currentSize
	BOOL newCards = (currentPos == [cardsDealt count]);
	
	if (hand.street == kStreetPreflop) {
		// remove nothing
		
		Card *flopCard0, *flopCard1, *flopCard2, *turnCard, *riverCard;
		
		if (newCards) {
			NSInteger remainingCardsTotal = [remainingDeck count];
			
			NSInteger flopCard0Index = random() % remainingCardsTotal;
			--remainingCardsTotal;
			flopCard0 = [remainingDeck objectAtIndex:flopCard0Index];
			[remainingDeck removeObject:flopCard0];
			
			NSInteger flopCard1Index = random() % remainingCardsTotal;
			--remainingCardsTotal;
			flopCard1 = [remainingDeck objectAtIndex:flopCard1Index];
			[remainingDeck removeObject:flopCard1];
			
			NSInteger flopCard2Index = random() % remainingCardsTotal;
			--remainingCardsTotal;
			flopCard2 = [remainingDeck objectAtIndex:flopCard2Index];
			[remainingDeck removeObject:flopCard2];
			
			NSInteger turnCardIndex = random() % remainingCardsTotal;
			--remainingCardsTotal;
			turnCard = [remainingDeck objectAtIndex:turnCardIndex];
			[remainingDeck removeObject:turnCard];
			
			NSInteger riverCardIndex = random() % remainingCardsTotal;
			riverCard = [remainingDeck objectAtIndex:riverCardIndex];
			
			[cardsDealt insertObject:flopCard0 atIndex:[cardsDealt count]];
			[cardsDealt insertObject:flopCard1 atIndex:[cardsDealt count]];
			[cardsDealt insertObject:flopCard2 atIndex:[cardsDealt count]];
			[cardsDealt insertObject:turnCard atIndex:[cardsDealt count]];
			[cardsDealt insertObject:riverCard atIndex:[cardsDealt count]];
			
		} else {
			flopCard0 = (Card*)[cardsDealt objectAtIndex:currentPos];
			flopCard1 = (Card*)[cardsDealt objectAtIndex:currentPos+1];
			flopCard2 = (Card*)[cardsDealt objectAtIndex:currentPos+2];
			turnCard = (Card*)[cardsDealt objectAtIndex:currentPos+3];
			riverCard = (Card*)[cardsDealt objectAtIndex:currentPos+4];
		}
		
		communityCard0View.card = flopCard0;
		communityCard1View.card = flopCard1;
		communityCard2View.card = flopCard2;
		communityCard3View.card = turnCard;
		communityCard4View.card = riverCard;
		
	} else if (hand.street == kStreetFlop) {
		// remove flop cards
		[remainingDeck removeObject:communityCard0View.card];
		[remainingDeck removeObject:communityCard1View.card];
		[remainingDeck removeObject:communityCard2View.card];	
		
		NSInteger remainingCardsTotal = [remainingDeck count];
		
		Card *turnCard, *riverCard;
		
		if (newCards) {
			NSInteger turnCardIndex = random() % remainingCardsTotal;
			--remainingCardsTotal;
			turnCard = [remainingDeck objectAtIndex:turnCardIndex];
			[remainingDeck removeObject:turnCard];
			
			NSInteger riverCardIndex = random() % remainingCardsTotal;
			riverCard = [remainingDeck objectAtIndex:riverCardIndex];
			
			[cardsDealt insertObject:turnCard atIndex:[cardsDealt count]];
			[cardsDealt insertObject:riverCard atIndex:[cardsDealt count]];
			
		} else {
			turnCard = (Card*)[cardsDealt objectAtIndex:currentPos];
			riverCard = (Card*)[cardsDealt objectAtIndex:currentPos+1];
		}
		
		communityCard3View.card = turnCard;
		communityCard4View.card = riverCard;
		
	} else if (hand.street == kStreetTurn) {
		// remove flop and turn cards
		[remainingDeck removeObject:communityCard0View.card];
		[remainingDeck removeObject:communityCard1View.card];
		[remainingDeck removeObject:communityCard2View.card];
		[remainingDeck removeObject:communityCard3View.card];
		
		Card* riverCard;
		
		if (newCards) {
			NSInteger remainingCardsTotal = [remainingDeck count];
			NSInteger riverCardIndex = random() % remainingCardsTotal;
			riverCard = [remainingDeck objectAtIndex:riverCardIndex];			
			
			[cardsDealt insertObject:riverCard atIndex:[cardsDealt count]];
		} else {
			riverCard = (Card*)[cardsDealt objectAtIndex:currentPos];
		}
		
		communityCard4View.card = riverCard;
	}
	
	// display who's the winner
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
	
	// update the two counters
	if (!isGoingBack) {
		if (result == NSOrderedAscending) {
			// villain won
			[self updateNumberLabel:villainWinsLabel addAmount:1];
		} else if (result == NSOrderedDescending) {
			// hero won
			[self updateNumberLabel:heroWinsLabel addAmount:1];
		} else if (result == NSOrderedSame) {
			// split pot .5
			[self updateNumberLabel:heroWinsLabel addAmount:.5];
			[self updateNumberLabel:villainWinsLabel addAmount:.5];
		}
	}
	
	[heroHandLabel setText:[hand0 detailedHandDescription]];
	[heroHandLabel setNeedsDisplay];
	[villainHandLabel setText:[hand1 detailedHandDescription]];
	[villainHandLabel setNeedsDisplay];		
	
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View,
						  heroCard2View, heroCard3View,
						  villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
						  communityCard0View, communityCard1View,
						  communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	NSArray* winningHand = (result == NSOrderedAscending) ? hand1.cards : hand0.cards;
	
	for (CardView* cardView in allCards) {
		if (![self cardInGroup:cardView.card :winningHand])
			[cardView dullize];
	}
	
	[allCards release];
	
	[hand0 release];
	[hand1 release];			
	
	[remainingDeck release];
}

- (void) dealToTheRiver {
	[self dealToTheRiverTwoCases:NO];
}

- (IBAction) playPauseButtonPressed:(id)sender {
	if ([self isSameCardsMode]) {		
		if ([self isPaused]) {
			[AppController changeTitleOfButton:playPauseButton to:PAUSE_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PAUSE_BUTTON_IMAGE];
			
			[sameDifferentButton setHidden:YES];
			[prevButton setHidden:YES];
			[nextButton setHidden:YES];
			[handButton setHidden:YES];
			
			[self startWaitIndicator:STATUS_SHOWDOWN];
			[self dealToTheRiver];
			dealToTheRiverTimer = 
			[NSTimer scheduledTimerWithTimeInterval:DELAY_DEAL_TO_THE_RIVER
											 target:self 
										   selector:@selector(dealToTheRiver) 
										   userInfo:nil 
											repeats:YES];
			
		} else {
			[AppController changeTitleOfButton:playPauseButton to:PLAY_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PLAY_BUTTON_IMAGE];
			
			[sameDifferentButton setHidden:NO];
			
			if ([self currentCount] >= 2)
				[prevButton setHidden:NO];
			[nextButton setHidden:NO];
			
			if (communityCard4View.card != nil)
				[handButton setHidden:NO];
			
			[self killAllActiveTimers];
		}
		
	} else {		
		if ([self isPaused]) {
			[AppController changeTitleOfButton:playPauseButton to:PAUSE_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PAUSE_BUTTON_IMAGE];
			
			[sameDifferentButton setHidden:YES];
			[prevButton setHidden:YES];
			[nextButton setHidden:YES];	
			[handButton setHidden:YES];	
			
			if (hand.street == kStreetPreflop) {
				// dealing flop will fire the timer
				[self beforeDealingNextStreetTimerFireMethod];			
			} else if (hand.street == kStreetFlop) {
				// dealing turn will not fire the timer thus the timer needs to be fired
				// manually.
				[self beforeDealingNextStreetTimerFireMethod];
				
				[self startWaitIndicator:STATUS_IDLING];
				
				allInDealingTimer = 
				[NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_TURN_RIVER 
												 target:self 
											   selector:@selector(beforeDealingNextStreetTimerFireMethod) 
											   userInfo:nil 
												repeats:YES];
				
			} else if (hand.street == kStreetTurn) {
				// dealing river will fire the showdown timer
				[self beforeDealingNextStreetTimerFireMethod];			
			} else { // if (hand.street == kStreetRiver)
				// dealing hole cards will fire the timer
				[self dealNewHandAsDealer];
			}
		} else {
			[AppController changeTitleOfButton:playPauseButton to:PLAY_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PLAY_BUTTON_IMAGE];
			
			if (hand.street != kStreetRiver)		
				[sameDifferentButton setHidden:NO];
			
			if (hand.street != kStreetPreflop)
				[prevButton setHidden:NO];
			
			[nextButton setHidden:NO];	
			
			if (hand.street != kStreetPreflop)
				[handButton setHidden:NO];	
			
			[self killAllActiveTimers];
		}		
	}
	
	[self saveToApplicationData];
}

- (IBAction) skipButtonPressed:(id)sender {
	[cardsDealt removeAllObjects];

	[self killAllActiveTimers];
	[self dealNewHandAsDealer];
}

- (IBAction) prevButtonPressed:(id)sender {
	if ([self isSameCardsMode]) {
		// B mode (run it N times mode)
		NSInteger count = [self currentCount];
		
		// decrement hero/villain wins count
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
		
		[hand0 release];
		[hand1 release];
		
		// update the two counters
		if (result == NSOrderedAscending) {
			// villain won
			[self updateNumberLabel:villainWinsLabel addAmount:-1];
		} else if (result == NSOrderedDescending) {
			// hero won
			[self updateNumberLabel:heroWinsLabel addAmount:-1];
		} else if (result == NSOrderedSame) {
			// split pot .5
			[self updateNumberLabel:heroWinsLabel addAmount:-.5];
			[self updateNumberLabel:villainWinsLabel addAmount:-.5];
		}
		
		// deal cards to the river
		[self dealToTheRiverTwoCases:YES];
		
		if (count == 2)
			[prevButton setHidden:YES];
		
	} else {
		// A mode (regular mode)
		
		if (hand.street == kStreetPreflop) {
		} else if (hand.street == kStreetFlop) {
			hand.street = kStreetPreflop;
			
			[deck undealOneCard:communityCard2View.card];
			[deck undealOneCard:communityCard1View.card];
			[deck undealOneCard:communityCard0View.card];
			
			communityCard0View.card = nil;
			communityCard1View.card = nil;
			communityCard2View.card = nil;
			
			[self displayPreflopInfo];
			
		} else if (hand.street == kStreetTurn) {
			hand.street = kStreetFlop;
			[deck undealOneCard:communityCard3View.card];
			
			communityCard3View.card = nil;
			
			[self displayFlopInfo];
			
		} else { // if (hand.street == kStreetRiver)
			[sameDifferentButton setHidden:NO];
			
			hand.street = kStreetTurn;
			[deck undealOneCard:communityCard4View.card];
			
			communityCard4View.card = nil;
			
			[self brightizeAllCards];
			
			[self displayTurnInfo];
		}
		
		[self saveToApplicationData];
	}
}

- (IBAction) nextButtonPressed:(id)sender {	
	if ([self isSameCardsMode]) {
		// B mode (run it N times mode)
		
		[self dealToTheRiver];
		
		// there's nothing to go back to when the count is 
		// 0 (no hands in cardsDealt) or 1 (one hand in cardsDealt,
		// but that hand is currently being displayed)
		if ([self currentCount] >= 2)
			[prevButton setHidden:NO];
		
	} else {
		// A mode (regular mode)
		if (hand.street == kStreetPreflop) {
			[self dealNextStreetCards];
		} else if (hand.street == kStreetFlop) {
			[self dealNextStreetCards];
		} else if (hand.street == kStreetTurn) {
			[sameDifferentButton setHidden:YES];
			[self dealNextStreetCards];
			[self displayWhoWon];
		} else { // if (hand.street == kStreetRiver)
			[self dealNewHandAsDealer];
		}		
	}
	
	[self saveToApplicationData];
}

// restore cards' dull states. river showdown or all bright 
// cards otherwise.
- (void) restoreCards {
	if (hand.street == kStreetRiver || [self isSameCardsMode]) {		
		[self brightizeAllCards];
		[self highlightWinningHand];
	} else {
		NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
							  villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
							  communityCard0View, communityCard1View,
							  communityCard2View, communityCard3View, communityCard4View, nil] retain];
				
		for (CardView* cardView in allCards) {
			if (cardView != nil && cardView.dull)
				[cardView toggleDull];
		}
		
		[allCards release];
	}	
}

- (void) highlightHand:(BOOL)isHeroHand {
	MadeHand* bestHand = [[MadeHand alloc] init];
	
	if (hand.street == kStreetRiver || [self isSameCardsMode]) {
		[self brightizeAllCards];
		
		[Hand calcOmahaBestHand
		 :isHeroHand ? heroCard0View.card : villainCard0View.card
		 :isHeroHand ? heroCard1View.card : villainCard1View.card
		 :isHeroHand ? heroCard2View.card : villainCard2View.card
		 :isHeroHand ? heroCard3View.card : villainCard3View.card
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :communityCard3View.card 
		 :communityCard4View.card
		 :bestHand];
		
	} else if (hand.street == kStreetFlop) {
		[Hand calcOmahaBestHand
		 :isHeroHand ? heroCard0View.card : villainCard0View.card
		 :isHeroHand ? heroCard1View.card : villainCard1View.card
		 :isHeroHand ? heroCard2View.card : villainCard2View.card
		 :isHeroHand ? heroCard3View.card : villainCard3View.card
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :bestHand];
		
	} else if (hand.street == kStreetTurn) {
		[Hand calcOmahaBestHand
		 :isHeroHand ? heroCard0View.card : villainCard0View.card
		 :isHeroHand ? heroCard1View.card : villainCard1View.card
		 :isHeroHand ? heroCard2View.card : villainCard2View.card
		 :isHeroHand ? heroCard3View.card : villainCard3View.card
		 :communityCard0View.card 
		 :communityCard1View.card 
		 :communityCard2View.card 
		 :communityCard3View.card 
		 :bestHand];
	}
	
	NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View, heroCard2View, heroCard3View,
						  villainCard0View, villainCard1View, villainCard2View, villainCard3View, 
						  communityCard0View, communityCard1View,
						  communityCard2View, communityCard3View, communityCard4View, nil] retain];
	
	
	for (CardView* cardView in allCards) {
		if (cardView != nil &&
			![self cardInGroup:cardView.card :bestHand.cards])
			[cardView dullize];
	}
	
	[allCards release];
	
	[bestHand release];	
}

// highlight hero's and villain's hand alternatively
- (IBAction) handButtonPressed:(id)sender {
	if (hand.street == kStreetRiver || [self isSameCardsMode]) {
		// if this is river, the winning hand (and in the case of split pot, hero's hand) is already highlighted.
		// thus we always want to highlight the losing hand.
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
		
		// update the two counters
		if (result == NSOrderedAscending) {
			// villain won
			[self highlightHand:YES];
		} else if (result == NSOrderedDescending) {
			// hero won
			[self highlightHand:NO];
		} else if (result == NSOrderedSame) {
			// split pot
			[self highlightHand:NO];
		}
		
		[hand0 release];
		[hand1 release];			
		
	} else {
		[self highlightHand:heroOrVillainHand];
		
		heroOrVillainHand = !heroOrVillainHand;
	}
}

- (IBAction) handButtonReleased:(id)sender {
	[self restoreCards];
}

- (void) resetForNewHand {
	[handCountLabel setText:[NSString stringWithFormat:@"%d", ++handCount]];
		
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	villainCard2View.faceUp = YES;
	villainCard3View.faceUp = YES;
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
	
	preflopHeroPercentage = INVALID_PERCENTAGE;
	preflopVillainPercentage = INVALID_PERCENTAGE;
	flopHeroPercentage = INVALID_PERCENTAGE;
	flopVillainPercentage = INVALID_PERCENTAGE;	
	[self savePercentagesInApplicationData];	
		
	[hand newHand];
	
	// hand count
	applicationData[2] = (uint8_t)((handCount >>  8) & 0xff);
	applicationData[3] = (uint8_t)( handCount        & 0xff);
	// save applicationData[4]
	[self saveToApplicationData];
	// cards applicationData[5-13] have already been set
	
	// flag bit
	applicationData[0] = (uint8_t)1;	
}

- (void) setupInitialScreen {
	[handCountLabel setText:@""];
	
	[heroStatusLabel setText:@""];
	[heroPercentageLabel setText:@""];
	[heroOutsLabel setText:@""];
	[heroHandLabel setText:@""];
	[heroWinsLabel setText:@""];
	[villainStatusLabel setText:@""];
	[villainPercentageLabel setText:@""];
	[villainOutsLabel setText:@""];
	[villainHandLabel setText:@""];
	[villainWinsLabel setText:@""];	
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	heroCard2View.faceUp = YES;
	heroCard3View.faceUp = YES;
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	villainCard2View.faceUp = YES;
	villainCard3View.faceUp = YES;
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
	
	endButton.hidden = NO;
	[endButton setNeedsDisplay];
	
	[AppController changeTitleOfButton:sameDifferentButton to:SAME_BUTTON_TITLE];
	[AppController changeImageOfButton:sameDifferentButton to:SAME_BUTTON_IMAGE];
	[sameDifferentButton setHidden:YES];	
	[AppController changeTitleOfButton:playPauseButton to:PAUSE_BUTTON_TITLE];
	[AppController changeImageOfButton:playPauseButton to:PAUSE_BUTTON_IMAGE];
	[playPauseButton setHidden:NO];
	[skipButton setHidden:NO];
	[prevButton setHidden:YES];
	[nextButton setHidden:YES];	
	[handButton setHidden:YES];	
}

- (void) dealFirstCardDealer {
	[sameDifferentButton setHidden:YES];
	[playPauseButton setHidden:YES];
	[skipButton setHidden:YES];
	[prevButton setHidden:YES];
	[nextButton setHidden:YES];		
	[handButton setHidden:YES];		
	
	[self clearScreen];
	
	heroCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealSecondCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSecondCardDealerTimerMethod {
	villainCard0View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealThirdCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealThirdCardDealerTimerMethod {
	heroCard1View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealFourthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFourthCardDealerTimerMethod {
	villainCard1View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealFifthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealFifthCardDealerTimerMethod {
	heroCard2View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealSixthCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSixthCardDealerTimerMethod {
	villainCard2View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealSeventhCardDealerTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealSeventhCardDealerTimerMethod {
	heroCard3View.card = [deck dealOneCard];
	
	holeCardsDealingTimer = [NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_NEXT_HOLE_CARD target:self selector:@selector(dealEighthCardDealerTimerMethod) userInfo:nil repeats:NO];
}


- (void) dealEighthCardDealerTimerMethod {
	holeCardsDealingTimer = nil;
	villainCard3View.card = [deck dealOneCard];
	
	[self stopWaitIndicator];
	
	[self displayPreflopInfo];		
}

// hero is the dealer.
- (void) dealNewHandAsDealer {		
	[self startWaitIndicator:STATUS_DEALING];
	
	[deck shuffleUpAndDeal:kHandOmaha];
	
	// save cards just dealt in application data
	for (int i=0; i < 13; i++) {
		Card *card = [deck getCardAtIndex:i];
		applicationData[5+i] = (uint8_t)((card.rank << 2) | card.suit);
	}
	
	[self resetForNewHand];
	[self dealFirstCardDealer];	
}

- (void) willRestoreFromApplicationData:(uint8_t*)appData {
	//[[Applytics sharedService] log:[[self class] description]];
	
	[self resetStuff];
	
	[self setupInitialScreen];

	// copy data into applicaitonData
	memcpy(applicationData, appData, OMAHA_TRAINING_MODE_APPLICATION_DATA_LENGTH);
	
	// release passed-in application data for it's no longer needed
	free(appData);
		
	handCount = ((applicationData[2] << 8)  & 0xff00) |
				 (applicationData[3]        & 0x00ff); 
	[handCountLabel setText:[NSString stringWithFormat:@"%d", handCount]];
	
	hand.street = applicationData[4];
	
	// restore 13 cards
	for (int cardIndex = 5; cardIndex <= 17; cardIndex++) {
		uint8_t data = applicationData[cardIndex];
		
		NSInteger rank = (data >> 2) & 0x0f;
		NSInteger suit = (data) & 0x03;
		Card* card = [[Card alloc] initWithSuit:suit Rank:rank];
		[deck addCard:card];	
		[card release];
	}
		
	// deal cards
	heroCard0View.card = [deck dealOneCard];
	villainCard0View.card = [deck dealOneCard];
	heroCard1View.card = [deck dealOneCard];
	villainCard1View.card = [deck dealOneCard];
	heroCard2View.card = [deck dealOneCard];
	villainCard2View.card = [deck dealOneCard];
	heroCard3View.card = [deck dealOneCard];
	villainCard3View.card = [deck dealOneCard];
	
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

	preflopHeroPercentage = applicationData[18];
	preflopVillainPercentage = applicationData[19];
	flopHeroPercentage = applicationData[20];
	flopVillainPercentage = applicationData[21];
	
	if (hand.street == kStreetPreflop) {
		[self displayPreflopInfo];
	} else if (hand.street == kStreetFlop) {
		[self displayFlopInfo];
	} else if (hand.street == kStreetTurn) {
		[self displayTurnInfo];
	} else { // if (hand.street == kStreetRiver)
		[self displayRiverInfo];
		[self displayWhoWon];
	}
		
	BOOL isPaused = GET_BOOLEAN_FLAG(applicationData[1], 0);
	BOOL isSameCardsMode = GET_BOOLEAN_FLAG(applicationData[1], 1);
	
	if (isSameCardsMode) {
		[AppController changeTitleOfButton:sameDifferentButton to:DIFFERENT_BUTTON_TITLE];
		[AppController changeImageOfButton:sameDifferentButton to:DIFFERENT_BUTTON_IMAGE];
		
		[heroWinsLabel setText:@"0"];
		[heroWinsLabel setHidden:NO];
		[villainWinsLabel setText:@"0"];
		[villainWinsLabel setHidden:NO];
		
		if (isPaused) {
			[AppController changeTitleOfButton:playPauseButton to:PLAY_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PLAY_BUTTON_IMAGE];
			
			[sameDifferentButton setHidden:NO];
			[prevButton setHidden:YES];
			[nextButton setHidden:NO];
			[handButton setHidden:YES];
		} else {
			[AppController changeTitleOfButton:playPauseButton to:PAUSE_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PAUSE_BUTTON_IMAGE];
			
			// note that if hand.street == kStreetPreflop, the dealToTheRiverTimer has already
			// fired when displayPreflopInfo is called.
			if (hand.street != kStreetPreflop) {
				dealToTheRiverTimer = 
				[NSTimer scheduledTimerWithTimeInterval:DELAY_DEAL_TO_THE_RIVER
												 target:self 
											   selector:@selector(dealToTheRiver) 
											   userInfo:nil 
												repeats:YES];
			}
		}
		
	} else {
		[AppController changeTitleOfButton:sameDifferentButton to:SAME_BUTTON_TITLE];
		[AppController changeImageOfButton:sameDifferentButton to:SAME_BUTTON_IMAGE];
		
		if (isPaused) {
			[AppController changeTitleOfButton:playPauseButton to:PLAY_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PLAY_BUTTON_IMAGE];
			
			if (hand.street != kStreetRiver)
				[sameDifferentButton setHidden:NO];
			
			if (hand.street == kStreetTurn ||
				hand.street == kStreetRiver) {
				[prevButton setHidden:NO];
				[nextButton setHidden:NO];
				[handButton setHidden:NO];
			}
		} else {
			[AppController changeTitleOfButton:playPauseButton to:PAUSE_BUTTON_TITLE];
			[AppController changeImageOfButton:playPauseButton to:PAUSE_BUTTON_IMAGE];
			
			// note that if hand.street == kStreetRiver, the showdown timer will be started.
			// if hand.street == kStreetPreflop or kStreetFlop, the timer has already fired
			// when displayPreflop/FlopInfo is called.
			if (hand.street == kStreetTurn) {
				allInDealingTimer = 
				[NSTimer scheduledTimerWithTimeInterval:DELAY_TO_DEAL_TURN_RIVER 
												 target:self 
											   selector:@selector(beforeDealingNextStreetTimerFireMethod) 
											   userInfo:nil 
												repeats:YES];
			} else if (hand.street == kStreetRiver) {
				[self startWaitIndicator:STATUS_SHOWDOWN];
				showdownTimer = [NSTimer scheduledTimerWithTimeInterval:SHOWDOWN_DELAY target:self selector:@selector(afterDisplayingWhoWonTimerFireMethod) userInfo:nil repeats:NO];
			}
		}
	}	
}

- (void) willDisplay {
	//[[Applytics sharedService] log:[[self class] description]];
	
	[self resetStuff];
	
	[self setupInitialScreen];
	[self dealNewHandAsDealer];
}	

@end
