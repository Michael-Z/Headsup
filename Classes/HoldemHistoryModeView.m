//
//  GameModeView.m
//  Headsup
//
//  Created by Haolan Qin on 1/26/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HoldemHistoryModeView.h"
#import "Constants.h"
#import "Hand.h"
#import "Card.h"
#import "CardView.h"
#import "HoldemHand.h"
#import "Action.h"
#import "AppController.h"
#import "MadeHand.h"
#import "GameModeView.h"

#define POST_BB_ACTION @"BB"
#define POST_SB_ACTION @"SB"
#define FOLD_ACTION @"Fold"
#define CHECK_ACTION @"Check"
#define CALL_ACTION @"Call"
#define BET_ACTION @"Bet"
#define RAISE_ACTION @"Raise to"

@implementation HoldemHistoryModeView

@synthesize navController;
@synthesize appController;
@synthesize gameModeView;

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

@synthesize prevActionButton;
@synthesize nextActionButton;

@synthesize endButton;
@synthesize lobbyButton;

@synthesize gameNameLabel;
@synthesize handCountLabel;

@synthesize smallBlindLabel;
@synthesize bigBlindLabel;

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
	hand = [[HoldemHand alloc] init];
	
	arrHeroStacks = [[NSMutableArray alloc] init];
	arrHeroActions = [[NSMutableArray alloc] init];
	arrHeroAmounts = [[NSMutableArray alloc] init];
	arrVillainStacks = [[NSMutableArray alloc] init];
	arrVillainActions = [[NSMutableArray alloc] init];
	arrVillainAmounts = [[NSMutableArray alloc] init];
	arrPots = [[NSMutableArray alloc] init];
	
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
	
	[arrHeroStacks release];
	[arrHeroActions release];
	[arrHeroAmounts release];
	[arrVillainStacks release];
	[arrVillainActions release];
	[arrVillainAmounts release];
	[arrPots release];
	
	
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

- (void) updateNumberLabel:(UILabel*)label addAmount:(NSInteger)amount {
	NSInteger currentValue = [[label text] integerValue];
	[label setText:[NSString stringWithFormat:@"%d", currentValue + amount]];
	[label setNeedsDisplay];
}

- (void) setNumberLabel:(UILabel*)label amount:(NSInteger)amount {
	[label setText:[NSString stringWithFormat:@"%d", amount]];
	[label setNeedsDisplay];
}	

- (NSInteger) retrieveNumberFromLabel:(UILabel*)label {
	return [[label text] integerValue];
}

- (NSInteger) potSize {
	return [self retrieveNumberFromLabel:potLabel];
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
	
	[allCards release];
	
	[hand0 release];
	[hand1 release];	
}	

- (void) displayWhoWonHeroFolded:(BOOL)didHeroFold {
	if (didHeroFold) {
		// hero folded. villain won
		[whoWonLabel setText:@"You lost"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:villainStackLabel addAmount:[self potSize]];
	} else {
		// villain folded. hero won
		[self playHeroWonPotSound];
		[whoWonLabel setText:@"You won!"];
		[whoWonLabel setNeedsDisplay];
		[self updateNumberLabel:heroStackLabel addAmount:[self potSize]];
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

- (IBAction) endButtonPressed:(id)sender {
	[navController popViewControllerAnimated:YES];
}

- (IBAction) lobbyButtonPressed:(id)sender {
	[navController popViewControllerAnimated:YES];
}

- (void) pushLabels {
	[arrHeroStacks addObject:[heroStackLabel text]];
	[arrHeroActions addObject:[heroActionLabel text]];
	[arrHeroAmounts addObject:[heroAmountLabel text]];
	[arrVillainStacks addObject:[villainStackLabel text]];
	[arrVillainActions addObject:[villainActionLabel text]];
	[arrVillainAmounts addObject:[villainAmountLabel text]];
	[arrPots addObject:[potLabel text]];
}	

- (void) displayCurrentAction {
	Action *action = (Action*)[hand.arrActions objectAtIndex:actionIndex];
	
	// update herostack, heroaction, heroamount, villainstack, villainaction, villainamount,
	// potsize, card views
	
	if (action.action == kActionFlop) {
		communityCard0View.card = hand.communityCard0;
		communityCard1View.card = hand.communityCard1;
		communityCard2View.card = hand.communityCard2;
		
		if (!action.isAllIn) {
			[self displayAction:@"" amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
			[self displayAction:@"" amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
		}
	} else if (action.action == kActionTurn) {
		communityCard3View.card = hand.communityCard3;

		if (!action.isAllIn) {
			[self displayAction:@"" amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
			[self displayAction:@"" amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
		}
	} else if (action.action == kActionRiver) {
		communityCard4View.card = hand.communityCard4;

		if (!action.isAllIn) {
			[self displayAction:@"" amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];
			[self displayAction:@"" amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];
		}
		
		if (action.isHandOver) {
			[self displayWhoWon];
		}

	} else if (action.action == kActionFold) {
		if (action.isHero) {
			[self displayAction:FOLD_ACTION amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];			
		} else {
			[self displayAction:FOLD_ACTION amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];			
		}			
		
		[self displayWhoWonHeroFolded:action.isHero];
	} else if (action.action == kActionCheck) {
		if (action.isHero) {
			[self displayAction:CHECK_ACTION amount:0 actionLabel:heroActionLabel amountLabel:heroAmountLabel];			
		} else {
			[self displayAction:CHECK_ACTION amount:0 actionLabel:villainActionLabel amountLabel:villainAmountLabel];			
		}	
		
		if (action.isHandOver) {
			[self displayWhoWon];
		}
		
	} else if (action.action == kActionCall) {
		if (action.isHero) {
			[self displayAction:CALL_ACTION amount:action.amount actionLabel:heroActionLabel amountLabel:heroAmountLabel];
			[self updateNumberLabel:heroStackLabel addAmount:-action.additionalAmount];
		} else {
			[self displayAction:CALL_ACTION amount:action.amount actionLabel:villainActionLabel amountLabel:villainAmountLabel];
			[self updateNumberLabel:villainStackLabel addAmount:-action.additionalAmount];
		}
		
		[self updateNumberLabel:potLabel addAmount:action.additionalAmount];
		
		if (action.isHandOver) {
			[self displayWhoWon];
		}
		
	} else if (action.action == kActionBet) {
		if (action.isHero) {
			[self displayAction:BET_ACTION amount:action.amount actionLabel:heroActionLabel amountLabel:heroAmountLabel];
			[self updateNumberLabel:heroStackLabel addAmount:-action.additionalAmount];
		} else {
			[self displayAction:BET_ACTION amount:action.amount actionLabel:villainActionLabel amountLabel:villainAmountLabel];
			[self updateNumberLabel:villainStackLabel addAmount:-action.additionalAmount];
		}
		
		[self updateNumberLabel:potLabel addAmount:action.additionalAmount];

	} else if (action.action == kActionRaise) {
		if (action.isHero) {
			[self displayAction:RAISE_ACTION amount:action.amount actionLabel:heroActionLabel amountLabel:heroAmountLabel];
			[self updateNumberLabel:heroStackLabel addAmount:-action.additionalAmount];
		} else {
			[self displayAction:RAISE_ACTION amount:action.amount actionLabel:villainActionLabel amountLabel:villainAmountLabel];
			[self updateNumberLabel:villainStackLabel addAmount:-action.additionalAmount];
		}	
		
		[self updateNumberLabel:potLabel addAmount:action.additionalAmount];
	}
	
	if (actionIndex +1 == [arrPots count]) {
		[self pushLabels];
	}
}

- (void) reverseCurrentAction {
	if (actionIndex == [hand.arrActions count] - 1) {
		[whoWonLabel setText:@""];

		if (communityCard4View.card != nil) {
			NSArray* allCards = [[NSArray arrayWithObjects:heroCard0View, heroCard1View,
								  villainCard0View, villainCard1View, communityCard0View, communityCard1View,
								  communityCard2View, communityCard3View, communityCard4View, nil] retain];
						
			for (CardView* cardView in allCards) {
				if (cardView.dull)
					[cardView toggleDull];
			}
			
			[allCards release];
		}		
	}
		
	Action *action = (Action*)[hand.arrActions objectAtIndex:actionIndex];
	
	if (action.action == kActionFlop) {
		communityCard0View.card = nil;
		communityCard1View.card = nil;
		communityCard2View.card = nil;		
	} else if (action.action == kActionTurn) {
		communityCard3View.card = nil;
	} else if (action.action == kActionRiver) {
		communityCard4View.card = nil;
	}
	
	//
	NSString *heroStack = [arrHeroStacks objectAtIndex:actionIndex];
	NSString *heroAction = [arrHeroActions objectAtIndex:actionIndex];
	NSString *heroAmount = [arrHeroAmounts objectAtIndex:actionIndex];
	NSString *villainStack = [arrVillainStacks objectAtIndex:actionIndex];
	NSString *villainAction = [arrVillainActions objectAtIndex:actionIndex];
	NSString *villainAmount = [arrVillainAmounts objectAtIndex:actionIndex];
	NSString *pot = [arrPots objectAtIndex:actionIndex];
	
	[heroStackLabel setText:heroStack];
	[heroActionLabel setText:heroAction];
	[heroAmountLabel setText:heroAmount];
	[villainStackLabel setText:villainStack];
	[villainActionLabel setText:villainAction];
	[villainAmountLabel setText:villainAmount];
	[potLabel setText:pot];
}

- (IBAction) prevActionButtonPressed:(id)sender {
	[self reverseCurrentAction];

	--actionIndex;
	[actionIndexLabel setText:[NSString stringWithFormat:@"%d", actionIndex+1]];
	
	if (actionIndex < 0) {
		[prevActionButton setHidden:YES];
		[firstActionButton setHidden:YES];
	}
	
	[nextActionButton setHidden:NO];
	[lastActionButton setHidden:NO];
}

- (IBAction) nextActionButtonPressed:(id)sender {
	++actionIndex;
	
	[actionIndexLabel setText:[NSString stringWithFormat:@"%d", actionIndex+1]];
	
	[prevActionButton setHidden:NO];
	[firstActionButton setHidden:NO];
	
	if (actionIndex >= [hand.arrActions count] - 1) {
		[nextActionButton setHidden:YES];
		[lastActionButton setHidden:YES];
	}
	
	[self displayCurrentAction];
}

- (IBAction) firstActionButtonPressed {
	for ( ; actionIndex >= 0; --actionIndex)
		[self reverseCurrentAction];
	
	actionIndex = -1;
	
	[actionIndexLabel setText:[NSString stringWithFormat:@"%d", 0]];
	
	[prevActionButton setHidden:YES];
	[firstActionButton setHidden:YES];
	
	[nextActionButton setHidden:NO];
	[lastActionButton setHidden:NO];
}

- (IBAction) lastActionButtonPressed {
	const NSInteger actionTotal = [hand.arrActions count];
	for (actionIndex = actionIndex+1; actionIndex < actionTotal; ++actionIndex)
		[self displayCurrentAction];
	
	actionIndex = actionTotal - 1;
	
	[actionIndexLabel setText:[NSString stringWithFormat:@"%d", actionTotal]];
	
	[prevActionButton setHidden:NO];
	[firstActionButton setHidden:NO];
	
	[nextActionButton setHidden:YES];
	[lastActionButton setHidden:YES];	
}


- (void) setupInitialScreen {
	[prevActionButton setHidden:YES];
	[firstActionButton setHidden:YES];
	[nextActionButton setHidden:([hand.arrActions count] == 0)];
	[lastActionButton setHidden:([hand.arrActions count] == 0)];
	
	[handCountLabel setText:@"0"];
	
	heroCard0View.faceUp = YES;
	heroCard1View.faceUp = YES;
	
	villainCard0View.faceUp = YES;
	villainCard1View.faceUp = YES;
	
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
	
	heroDealerButton.hidden = YES;
	villainDealerButton.hidden = YES;
	[heroDealerButton setNeedsDisplay];
	[villainDealerButton setNeedsDisplay];
	
	[heroActionLabel setText:@""];
	[heroAmountLabel setText:@""];
	[villainActionLabel setText:@""];
	[villainAmountLabel setText:@""];
	[potLabel setText:@""];
	[whoWonLabel setText:@""];
	[smallBlindLabel setText:@""];
	[bigBlindLabel setText:@""];
	
	[heroActionLabel setNeedsDisplay];
	[heroAmountLabel setNeedsDisplay];
	[villainActionLabel setNeedsDisplay];
	[villainAmountLabel setNeedsDisplay];
	[potLabel setNeedsDisplay];
	[whoWonLabel setNeedsDisplay];
	[smallBlindLabel setNeedsDisplay];
	[bigBlindLabel setNeedsDisplay];
	
	[endButton setHidden:NO];
	[lobbyButton setHidden:NO];
		
	[heroNameLabel setText:@""];
	[villainNameLabel setText:@""];
	
	[heroNameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_HERO_NAME]];
	[villainNameLabel setText:[[NSUserDefaults standardUserDefaults] stringForKey:KEY_VILLAIN_NAME]];
	
	[heroNameLabel setNeedsDisplay];
	[villainNameLabel setNeedsDisplay];
	
	// dealing the 4 hole cards set up the screen
	[heroDealerButton setHidden:!hand.isHeroDealer];
	[villainDealerButton setHidden:hand.isHeroDealer];

	villainCard0View.faceUp = hand.isVillainExposed;
	villainCard1View.faceUp = hand.isVillainExposed;

	heroCard0View.card = hand.heroCard0;
	heroCard1View.card = hand.heroCard1;
	villainCard0View.card = hand.villainCard0;
	villainCard1View.card = hand.villainCard1;

	[self setNumberLabel:handCountLabel amount:hand.handCount];
	
	[self setNumberLabel:smallBlindLabel amount:hand.smallBlind];
	[self setNumberLabel:bigBlindLabel amount:hand.bigBlind];
	
	[self setNumberLabel:heroStackLabel amount:hand.heroStack];
	[self setNumberLabel:villainStackLabel amount:hand.villainStack];
	
	// dealer is small blind
	if (hand.isHeroDealer) {
		[self displayAction:POST_SB_ACTION 
					 amount:hand.smallBlindPosted 
				actionLabel:heroActionLabel 
				amountLabel:heroAmountLabel];
		
		[self displayAction:POST_BB_ACTION 
					 amount:hand.bigBlindPosted 
				actionLabel:villainActionLabel 
				amountLabel:villainAmountLabel];		
	} else {
		[self displayAction:POST_SB_ACTION 
					 amount:hand.smallBlindPosted 
				actionLabel:villainActionLabel 
				amountLabel:villainAmountLabel];
		
		[self displayAction:POST_BB_ACTION 
					 amount:hand.bigBlindPosted 
				actionLabel:heroActionLabel 
				amountLabel:heroAmountLabel];				
	}
	
	// pot = small blind + big blind
	[self setNumberLabel:potLabel amount:(hand.smallBlindPosted + hand.bigBlindPosted)];
	
	[arrHeroStacks removeAllObjects];
	[arrHeroActions removeAllObjects];
	[arrHeroAmounts removeAllObjects];
	[arrVillainStacks removeAllObjects];
	[arrVillainActions removeAllObjects];
	[arrVillainAmounts removeAllObjects];
	[arrPots removeAllObjects];
	
	[self pushLabels];	
}

- (void) willDisplay {
	[hand.arrActions removeAllObjects];
	[gameModeView loadHandHistory:hand];
	
	// 
	handIndex = 0;
	actionIndex = -1;
	
	[handIndexLabel setText:@"1"];
	[handTotalLabel setText:@"1"];


	[actionIndexLabel setText:@"0"];
	[actionTotalLabel setText:[NSString stringWithFormat:@"%d", [hand.arrActions count]]];
	 		
	[self setupInitialScreen];
}	

@end
