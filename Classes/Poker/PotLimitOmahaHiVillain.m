//
//  Move.m
//  Headsup
//
//  Created by Haolan Qin on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PotLimitOmahaHiVillain.h"
#import "Card.h"
#import "CardView.h"
#import "Deck.h"
#import "Hand.h"
#import "MadeHand.h"
#import "Move.h"

@implementation PotLimitOmahaHiVillain
		
-(id)initWithGameModeView:(OmahaGameModeView*)view {
	if (self = [super init]) {
		gameModeView = view;
		
		deck = [[Deck alloc] init];	
		
		antiBluffHand = -1;
		antiBluffStreet = kStreetPreflop;
	}
	
	return self;
}

- (void) dealloc {
	[deck release];
	
	[super dealloc];
}

- (void) fold {
	[gameModeView villainMadeAMove:kMoveFold amount:0];
}

- (void) check {
	[gameModeView villainMadeAMove:kMoveCheck amount:0];
}

- (void) call {
	[gameModeView villainMadeAMove:kMoveCall amount:0];
}

- (void) bet:(NSInteger)amount {
	[gameModeView villainMadeAMove:kMoveBet amount:amount];
}

- (void) raise:(NSInteger)amount {
	[gameModeView villainMadeAMove:kMoveRaise amount:amount];
}

// meat of this class. the AI engine.

- (float) delay {
	// reseed RNG
	//srandomdev();
	
	// 3 5
	//return (2 + random() % 4);
	return 1.0;
}		

// returns YES or NO randomly based on percentage.
// e.g. if percentage == 80, it will return YES 80% of the time, NO 20% of the time.
- (BOOL) isRand:(NSInteger)percentage {
	// reseed RNG
	srandomdev();
	
	// 3 5
	return (random() % 100 < percentage);
}

/*- (BOOL) isVillainRiverHandStrong:(MadeHand*)villainHand {
	return 
		villainHand.handType == kHandStraightFlush ||
		villainHand.handType == kHandQuads ||
		villainHand.handType == kHandBoat ||
		villainHand.handType == kHandFlush ||
		villainHand.handType == kHandStraight ||
		villainHand.handType == kHandTrips;	
}*/

- (BOOL) isRiverHandWeak:(MadeHand*)hand {
	return 
	hand.handType == kHandHighCard ||
	hand.handType == kHandOnePair ||
	hand.handType == kHandTwoPair ||
	hand.handType == kHandTrips;
}

- (BOOL) isRiverHandSuperStrong:(MadeHand*)hand {
	return 
	hand.type == kTypeStraight ||
	hand.type == kTypeFlush ||
	hand.type == kTypeBoat ||
	hand.type == kTypeQuads ||
	hand.type == kTypeStraightFlush;
}

- (BOOL) isTurnHandWeak:(MadeHand*)hand {
	return 
	hand.handType == kHandHighCard ||
	hand.handType == kHandOnePair ||
	hand.handType == kHandTwoPair ||
	hand.handType == kHandTrips;
}

- (BOOL) isTurnHandSuperStrong:(MadeHand*)hand {
	return 
	hand.type == kTypeStraight ||
	hand.type == kTypeFlush ||
	hand.type == kTypeBoat ||
	hand.type == kTypeQuads ||
	hand.type == kTypeStraightFlush;
}

- (BOOL) isFlopHandWeak:(MadeHand*)hand {
	return 
	hand.handType == kHandHighCard ||
	hand.handType == kHandOnePair ||
	hand.handType == kHandTwoPair;
}

- (BOOL) isFlopHandSuperStrong:(MadeHand*)hand {
	return 
	hand.type == kTypeStraight ||
	hand.type == kTypeFlush ||
	hand.type == kTypeBoat ||
	hand.type == kTypeQuads ||
	hand.type == kTypeStraightFlush;
}


- (BOOL) isMonsterDraw:(MadeHand*)hand {
	return	hand.outs >= 13;
}

- (BOOL) isDecentDraw:(MadeHand*)hand {
	return	hand.outs >= 8 && hand.outs <= 12;
}

- (Move*) bluff:(NSInteger)betPercentage 
		   call:(NSInteger)callPercentage 
	  callRaise:(NSInteger)callRaisePercentage {
	Move *move;
	
	if ([gameModeView didHeroMakeNoMove] || [gameModeView didHeroCheck]) {
		// villain is first to act or checked to.
		if ([self isRand:betPercentage])
			move = [[Move alloc] initWithMove:kMoveBet Amount:[gameModeView potSizedBetForVillain]];
		else
			move = [[Move alloc] initWithMove:kMoveCheck Amount:0];
	} else if ([gameModeView didHeroBet]) {
		// hero bet
		if ([self isRand:callPercentage])
			move = [[Move alloc] initWithMove:kMoveCall Amount:0];
		else				
			move = [[Move alloc] initWithMove:kMoveFold Amount:0];		
	} else {
		// hero raised
		if ([self isRand:callRaisePercentage])
			move = [[Move alloc] initWithMove:kMoveCall Amount:0];
		else				
			move = [[Move alloc] initWithMove:kMoveFold Amount:0];		
	}
	
	return [move autorelease];;
}

// bet out betPercentage, call callPercentage, fold to any raise
- (Move*) bluff:(NSInteger)betPercentage call:(NSInteger)callPercentage{
	return [self bluff:betPercentage call:callPercentage callRaise:0];
}

// bet out betPercentage. goNuts: YES
- (Move*) bet:(NSInteger)betPercentage goNuts:(BOOL)goNuts willFold:(BOOL)willFold {
	Move *move;
	
	if ([gameModeView didHeroMakeNoMove] || [gameModeView didHeroCheck]) {
		// villain is first to act or checked to.
		// if villain won't fold and is checked to, he is going to bet 100% of the time.
		if ([gameModeView didHeroCheck] && !willFold
			|| [self isRand:betPercentage])
			move = [[Move alloc] initWithMove:kMoveBet Amount:[gameModeView potSizedBetForVillain]];
		else
			move = [[Move alloc] initWithMove:kMoveCheck Amount:0];
	} else if ([gameModeView didHeroBet]) {
		// hero bet
		if (goNuts)
			move = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]];
		else				
			move = [[Move alloc] initWithMove:kMoveCall Amount:0];
	} else {
		// hero raised
		if (goNuts)
			move = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView maxAmountAllowedForVillain]];
		else {
			if (willFold)
				move = [[Move alloc] initWithMove:kMoveFold Amount:0];
			else
				move = [[Move alloc] initWithMove:kMoveCall Amount:0];
		}
	}
	
	return [move autorelease];
}

// raise or call
- (Move*) threeBet:(NSInteger)raisePercentage {
	Move *move;
	
	if ([self isRand:raisePercentage])
		move = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]];
	else				
		move = [[Move alloc] initWithMove:kMoveCall Amount:0];
	
	return [move autorelease];
}

// raise or call
- (Move*) fourBet:(NSInteger)raisePercentage {
	Move *move;
	
	if ([self isRand:raisePercentage])
		move = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]];
	else				
		move = [[Move alloc] initWithMove:kMoveCall Amount:0];
	
	return [move autorelease];
}

// villain is getting bluffed by hero. we need to play back by raising/calling some
// percentage of the time. once we decide to raise/call to counter hero's bluff we will
// not fold in the street.
- (Move*) antiBluffRaise:(NSInteger)raisePercentage call:(NSInteger)callPercentage {
	Move *move;
	
	NSInteger handCount = [[gameModeView.handCountLabel text] intValue];
	enum Street street = gameModeView.hand.street;

	if (antiBluffHand == handCount && antiBluffStreet == street) {
		// we have made a counter bluff move in this street. we won't fold.
		move = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]];
	} else {
		antiBluffHand = handCount;
		antiBluffStreet = street;

		if ([self isRand:raisePercentage]) {
			move = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]];
		} else if ([self isRand:callPercentage]) {
			move = [[Move alloc] initWithMove:kMoveCall Amount:0];		
		} else {
			move = [[Move alloc] initWithMove:kMoveFold Amount:0];
		}
	}
	
	return [move autorelease];
}

- (Move*) riverMove {
	Move *move;
	
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSComparisonResult result = [Hand 
								 calcOmahaWinnerHoleCard0:gameModeView.heroCard0View.card 
								 holeCard1:gameModeView.heroCard1View.card
								 holeCard2:gameModeView.heroCard2View.card
								 holeCard3:gameModeView.heroCard3View.card
								 holeCard4:gameModeView.villainCard0View.card
								 holeCard5:gameModeView.villainCard1View.card
								 holeCard6:gameModeView.villainCard2View.card
								 holeCard7:gameModeView.villainCard3View.card
								 communityCard0:gameModeView.communityCard0View.card
								 communityCard1:gameModeView.communityCard1View.card
								 communityCard2:gameModeView.communityCard2View.card
								 communityCard3:gameModeView.communityCard3View.card
								 communityCard4:gameModeView.communityCard4View.card
								 bestHandForFirstPlayer:hand0
								 bestHandForSecondPlayer:hand1];
	
	if (result == NSOrderedAscending || result == NSOrderedSame) {
		// villain won
		if ([self isRiverHandWeak:hand1]) {
			// villain has trips or worse
			if (hand1.handType == kHandHighCard ||
				hand1.handType == kHandOnePair ||
				hand1.handType == kHandTwoPair)
				move = [self bluff:50 call:35 callRaise:35];
			else
				move = [self bluff:40 call:70 callRaise:50];			
		} else {
			// villain has better than trips
			if ([self isRiverHandSuperStrong:hand1]) {
				// villain's hand is super strong. he's not folding.
				move = [self bet:70 goNuts:YES willFold:NO];
			} else {
				// villain's hand is not super strong. he could find a fold.
				move = [self bet:70 goNuts:NO willFold:NO];
			}
		}
		
	} else { //if (result == NSOrderedDescending) {
		// hero won
		if ([self isRiverHandWeak:hand0]) {
			// hero has trips or worse
			if (hand1.handType == kHandHighCard ||
				hand1.handType == kHandOnePair ||
				hand1.handType == kHandTwoPair)
				move = [self bluff:50 call:0];
			else
				move = [self bluff:40 call:30];			
		} else {
			// hero has better than trips
			if ([self isRiverHandWeak:hand1]) {
				// villain has trips or worse
				if (hand1.handType == kHandHighCard ||
					hand1.handType == kHandOnePair ||
					hand1.handType == kHandTwoPair)
					move = [self bluff:20 call:0];
				else
					move = [self bluff: 0 call:20];
			} else {
				// villain has better than trips
				if ([self isRiverHandSuperStrong:hand1]) {
					// villain's hand is super strong. he's not folding.
					move = [self bet:60 goNuts:YES willFold:NO];
				} else {
					// villain's hand is not super strong. he could find a fold.
					move = [self bet:40 goNuts:NO willFold:YES];
				}
			}
		}

	} /*else if (result == NSOrderedSame) {
		// split pot
	}*/
	
	[hand0 release];
	[hand1 release];
	
	//[move autorelease];
	return move;
}	

- (Move*) turnMove {
	Move *move;
	
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSComparisonResult result = [Hand 
								 calcOmahaWinnerHoleCard0:gameModeView.heroCard0View.card 
								 holeCard1:gameModeView.heroCard1View.card
								 holeCard2:gameModeView.heroCard2View.card
								 holeCard3:gameModeView.heroCard3View.card
								 holeCard4:gameModeView.villainCard0View.card
								 holeCard5:gameModeView.villainCard1View.card
								 holeCard6:gameModeView.villainCard2View.card
								 holeCard7:gameModeView.villainCard3View.card
								 communityCard0:gameModeView.communityCard0View.card
								 communityCard1:gameModeView.communityCard1View.card
								 communityCard2:gameModeView.communityCard2View.card
								 communityCard3:gameModeView.communityCard3View.card
								 bestHandForFirstPlayer:hand0
								 bestHandForSecondPlayer:hand1];
	
	if (result == NSOrderedAscending || result == NSOrderedSame) {
		// villain won
		if ([self isTurnHandWeak:hand1]) {
			// villain has worse than true two pair
			
			// villain's made hand is weak but he might have a strong draw.
			if ([self isMonsterDraw:hand1]) {
				// villain has a monster draw.
				move = [self bet:30 goNuts:YES willFold:NO];
			} else {
				// villain does not have a monster draw but could still have a decent draw.
				
				if ([self isDecentDraw:hand1]) {
					// villain has a decent draw. won't fold.
					move = [self bluff:30 call:100 callRaise:100];
				} else {
					// villain doesn't have a decent draw.
					if (hand1.handType == kHandHighCard ||
						hand1.handType == kHandOnePair)
						move = [self bluff:50 call:40 callRaise:40];
					else
						move = [self bluff:40 call:70 callRaise:60];	
				}
			}
		} else {
			// villain has true two pair or better
			if ([self isTurnHandSuperStrong:hand1]) {
				// villain's hand is super strong. he's not folding.
				move = [self bet:70 goNuts:YES willFold:NO];
			} else {
				// villain's hand is not super strong. he could find a fold.
				move = [self bet:70 goNuts:NO willFold:NO];
			}
		}
		
		// if villain has a better hand and still decides to fold, he's getting
		// bluffed by hero. we should call/raise certain percentage of the time.
		if (move.move == kMoveFold) {
			// current move object is no longer needed.
			//[move release];
			
			move = [self antiBluffRaise:10 call:30];
		}				
		
	} else { //if (result == NSOrderedDescending) {
		// hero won
		
		// hero has a better made hand but villain might have draws.		
		if ([self isMonsterDraw:hand1]) {
			// villain has a monster draw.
			move = [self bluff:30 call:100];
		} else {
			if ([self isDecentDraw:hand1]) {
				// villain has a decent draw. won't fold.
				move = [self bluff:20 call:100];
			} else {				
				
				if ([self isTurnHandWeak:hand0]) {
					// hero has worse than true two pair
					if (hand0.handType == kHandHighCard ||
						hand0.handType == kHandOnePair)
						move = [self bluff:50 call:0];
					else
						move = [self bluff:40 call:30];			
				} else {
					// hero has true two pair or better
					if ([self isTurnHandWeak:hand1]) {
						// villain has worse than true two pair
						if (hand1.handType == kHandHighCard ||
							hand1.handType == kHandOnePair)
							move = [self bluff:20 call:0];
						else
							move = [self bluff: 0 call:20];
					} else {
						// villain has true two pair or better
						if ([self isTurnHandSuperStrong:hand1]) {
							// villain's hand is super strong. he's not folding.
							move = [self bet:60 goNuts:YES willFold:NO];
						} else {
							// villain's hand is not super strong. he could find a fold.
							move = [self bet:40 goNuts:NO willFold:YES];
						}
					}
				}
			}
		}
	} /*else if (result == NSOrderedSame) {
		// split pot
	}*/
	
	// if villain has a decent hand and pot odds and implied odds are too good to fold
	// villain should call instead of fold.
	if (move.move == kMoveFold) {
		NSInteger callAmount = [gameModeView callAmountForVillain];
		NSInteger pot = [gameModeView effectivePotSizeVillainsTurn];
		NSInteger heroStack = [gameModeView heroStackSize];
		NSInteger villainStack = [gameModeView villainStackSize] - callAmount;
		
		NSInteger effectiveStack = heroStack > villainStack ? villainStack : heroStack;
		NSInteger potentialPot = pot + effectiveStack;
		
		if (hand1.outs >= 8) {
			if (callAmount == gameModeView.BB || callAmount * 3 <= pot && callAmount * 5 <= potentialPot)
				move.move = kMoveCall;
		} else if (hand1.outs >= 4) {
			if (callAmount == gameModeView.BB || callAmount * 6 <= pot && callAmount * 12 <= potentialPot)
				move.move == kMoveCall;
		}		
	}		
	
	[hand0 release];
	[hand1 release];
	
	//[move autorelease];
	return move;
}	

- (Move*) flopMove {
	Move *move;
	
	MadeHand* hand0 = [[MadeHand alloc] init];
	MadeHand* hand1 = [[MadeHand alloc] init];
	
	NSComparisonResult result = [Hand 
								 calcOmahaWinnerHoleCard0:gameModeView.heroCard0View.card 
								 holeCard1:gameModeView.heroCard1View.card
								 holeCard2:gameModeView.heroCard2View.card
								 holeCard3:gameModeView.heroCard3View.card
								 holeCard4:gameModeView.villainCard0View.card
								 holeCard5:gameModeView.villainCard1View.card
								 holeCard6:gameModeView.villainCard2View.card
								 holeCard7:gameModeView.villainCard3View.card
								 communityCard0:gameModeView.communityCard0View.card
								 communityCard1:gameModeView.communityCard1View.card
								 communityCard2:gameModeView.communityCard2View.card
								 bestHandForFirstPlayer:hand0
								 bestHandForSecondPlayer:hand1];
	
	if (result == NSOrderedAscending || result == NSOrderedSame) {
		// villain won
		if ([self isFlopHandWeak:hand1]) {
			// villain has worse than true two pair

			// villain's made hand is weak but he might have a strong draw.
			if ([self isMonsterDraw:hand1]) {
				// villain has a monster draw.
				move = [self bet:30 goNuts:YES willFold:NO];
			} else {
				// villain does not have a monster draw but could still have a decent draw.

				if ([self isDecentDraw:hand1]) {
					// villain has a decent draw. won't fold.
					move = [self bluff:30 call:100 callRaise:100];
				} else {
					// villain doesn't have a decent draw.
					if (hand1.handType == kHandHighCard ||
						hand1.handType == kHandOnePair) {
						// villain has no pair of non-top pair
						move = [self bluff:50 call:40 callRaise:40];
					} else {
						// villain has top pair or over pair
						move = [self bluff:40 call:70 callRaise:50];
					}
				}
			}
		} else {
			// villain has true two pair or better
			if ([self isFlopHandSuperStrong:hand1]) {
				// villain's hand is super strong. he's not folding.
				move = [self bet:70 goNuts:YES willFold:NO];
			} else {
				// villain's hand is not super strong. he could find a fold.
				move = [self bet:70 goNuts:NO willFold:NO];
			}
		}
		
		// if villain has a better hand and still decides to fold, he's getting
		// bluffed by hero. we should call/raise certain percentage of the time.
		if (move.move == kMoveFold) {
			// current move object is no longer needed.
			//[move release];
			
			move = [self antiBluffRaise:10 call:30];
		}		
		
	} else { //if (result == NSOrderedDescending) {
		// hero won
		
		// hero has a better made hand but villain might have draws.		
		if ([self isMonsterDraw:hand1]) {
			// villain has a monster draw.
			move = [self bet:30 goNuts:YES willFold:NO];
		} else {
			if ([self isDecentDraw:hand1]) {
				// villain has a decent draw. won't fold.
				move = [self bluff:30 call:100];
			} else {				
				if ([self isFlopHandWeak:hand0]) {
					// hero has worse than true two pair
					if (hand0.handType == kHandHighCard ||
						hand0.handType == kHandOnePair)
						move = [self bluff:50 call:0];
					else
						move = [self bluff:40 call:30];			
				} else {
					// hero has true two pair or better
					if ([self isFlopHandWeak:hand1]) {
						// villain has worse than true two pair
						if (hand1.handType == kHandHighCard ||
							hand1.handType == kHandOnePair)
							move = [self bluff:20 call:0];
						else
							move = [self bluff: 0 call:20];
					} else {
						// villain has true two pair or better
						if ([self isFlopHandSuperStrong:hand1]) {
							// villain's hand is super strong. he's not folding.
							move = [self bet:60 goNuts:YES willFold:NO];
						} else {
							// villain's hand is not super strong. he could find a fold.
							move = [self bet:40 goNuts:NO willFold:YES];
						}
					}
				}
			}
		}
		
	} /*else if (result == NSOrderedSame) {
		// split pot
	}*/
	
	// if villain has a decent hand and pot odds and implied odds are too good to fold
	// villain should call instead of fold.
	if (move.move == kMoveFold) {
		NSInteger callAmount = [gameModeView callAmountForVillain];
		NSInteger pot = [gameModeView effectivePotSizeVillainsTurn];
		NSInteger heroStack = [gameModeView heroStackSize];
		NSInteger villainStack = [gameModeView villainStackSize] - callAmount;
		
		NSInteger effectiveStack = heroStack > villainStack ? villainStack : heroStack;
		NSInteger potentialPot = pot + effectiveStack;

		if (hand1.outs >= 8) {
			if (callAmount == gameModeView.BB || callAmount * 3 <= pot && callAmount * 5 <= potentialPot)
				move.move = kMoveCall;
		} else if (hand1.outs >= 4) {
			if (callAmount == gameModeView.BB || callAmount * 6 <= pot && callAmount * 12 <= potentialPot)
				move.move == kMoveCall;
		}		
	}	
	
	[hand0 release];
	[hand1 release];
	
	//[move autorelease];
	return move;
}	

- (Move*) preflopMove {
	Move *move;
	
	// villain hole cards
	Card *c0 = gameModeView.villainCard0View.card;
	Card *c1 = gameModeView.villainCard1View.card;
	Card *c2 = gameModeView.villainCard2View.card;
	Card *c3 = gameModeView.villainCard3View.card;

	// hero hole cards
	/*Card *c4 = gameModeView.heroCard0View.card;
	Card *c5 = gameModeView.heroCard1View.card;
	Card *c6 = gameModeView.heroCard2View.card;
	Card *c7 = gameModeView.heroCard3View.card;
	*/
	if (gameModeView.dealer) {
		// villain is BB. play tighter.
		if ([gameModeView didHeroCall]) {
			// dealer flat called
			if ([Hand isOmahaPremium:c0 :c1 :c2 :c3]) {
				//pfr oop with premium hands and sub-premium hands
				move = [[[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]] autorelease];
			} else {
				move = [[[Move alloc] initWithMove:kMoveCheck Amount:0] autorelease];
			}
		} else {
			// hero open raised. fold, call or 3-bet. 
			if ([gameModeView didVillainRaise]) {
				// hero 4-bet after villain's 3-bet
				if ([Hand isOmahaFelting:c0 :c1 :c2 :c3])
					move = [[[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]] autorelease];
				else
					move = [[[Move alloc] initWithMove:kMoveFold Amount:0] autorelease];
			} else {
				// hero open raised
				if ([Hand isOmahaFelting:c0 :c1 :c2 :c3])
					move = [self threeBet:90];
				else if ([Hand isOmahaRundown:c0 :c1 :c2 :c3])
					// 3-bet some speculative hands to balance our range.
					move = [[[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]] autorelease];
				else if ([Hand isOmahaTrash:c0 :c1 :c2 :c3])
					// only fold trash to an open raise because it's hard to play postflop
					move = [[[Move alloc] initWithMove:kMoveFold Amount:0] autorelease];
				else
					move = [[[Move alloc] initWithMove:kMoveCall Amount:0] autorelease];	
			}
		}
		
	} else {
		// villain is dealer. play more aggro.
		if ([gameModeView didHeroPostBB]) {
			// first to act. open or call.
			if ([Hand isOmahaPremium:c0 :c1 :c2 :c3] ||
				[Hand isOmahaMarginal:c0 :c1 :c2 :c3]) {
				move = [[[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView potSizedRaiseForVillain]] autorelease];
			} else {
				// playable and trash
				move = [[[Move alloc] initWithMove:kMoveCall Amount:0] autorelease];
			}
		} else {
			// hero 3-bet villain's open raise. fold, call or 4-bet
			if ([Hand isOmahaFelting:c0 :c1 :c2 :c3])
				move = [self fourBet:80];
			else if ([Hand isOmahaTrash:c0 :c1 :c2 :c3])
				move = [[[Move alloc] initWithMove:kMoveFold Amount:0] autorelease];
			else
				move = [[[Move alloc] initWithMove:kMoveCall Amount:0] autorelease];
				
		}
	}
	
	// if pot odds are too good to fold villain should call instead of fold.
	if (move.move == kMoveFold) {
		NSInteger callAmount = [gameModeView callAmountForVillain];
		NSInteger pot = [gameModeView effectivePotSizeVillainsTurn];
		
		if (callAmount * 3 <= pot) {
			move.move == kMoveCall;
		}
	}
	
	// if villain has a better starting hand and still decides to fold, he's getting
	// bluffed by hero. we should call/raise certain percentage of the time.
	/*
	if (move.move == kMoveFold && 
		[Hand calcOmahaWinnerHoleCard0:c4 
							 holeCard1:c5 
							 holeCard2:c6 
							 holeCard3:c7
							 holeCard4:c0
							 holeCard5:c1
							 holeCard6:c2
							 holeCard7:c3		 
		] == NSOrderedAscending) {
		// current move object is no longer needed.
		[move release];
		
		move = [self antiBluffRaise:20 call:20];
	}
	*/
	
	//[move autorelease];
	return move;
}

- (BOOL) isVillainPotCommitted {
	NSInteger villainStack = [gameModeView villainStackSize];
	NSInteger pot = [gameModeView effectivePotSizeVillainsTurn];
	
	return (villainStack * 3 <= pot);
}

- (void) makeAMove:(Move*)move {
	if (move.move == kMoveFold) {
		// our engine decides to fold. but we should call if
		// 1. we have a good draw and we have the odds to call based on 
		//    pot odds and implied odds.
		// 2. we are getting really good pot odds such as when hero min bets or min raises.
		// and we should go all-in if 
		// 1. we are pot commited
		if ([self isVillainPotCommitted]) {
			// pot committed
			Move *allin = [[Move alloc] initWithMove:kMoveRaise Amount:[gameModeView maxAmountAllowedForVillain]];
			[allin autorelease];
			[self makeAMove:allin];
		} else {
			[self fold];
		}
	} else if (move.move == kMoveCheck) {
		[self check];
	} else if (move.move == kMoveCall) {
		[self call];
	} else if (move.move == kMoveBet) {
		[self bet:move.amount];
	} else if (move.move == kMoveRaise) {
		// if villain intends to raise but hero has already gone all-in (no chips left)
		// or villain's "raise" amount is not greater than hero's current bet/raise amount.
		// note that at this point villain has not acted yet.
		if ([[gameModeView.heroStackLabel text] isEqualToString:@"0"] ||
			move.amount <= [gameModeView heroBetOrRaiseAmount])
			[self call];
		else
			[self raise:move.amount];
	} else {
		NSLog(@"unknown move type: %d", move.move);
	}
}

- (void)villainFirstToAct {
	timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(villainFirstToActTimerMethod) userInfo:nil repeats:NO];
}

- (void) dealNewHandAsDealer {
	// gameModeView.dealer means hero was dealer last hand. so villain
	// is the dealer for this hand.
	if (gameModeView.dealer) {
		// deal the new hand
		[deck shuffleUpAndDeal:kHandOmaha];
		
		[gameModeView.deck clearArrays];
		
		for (int i=0; i < 13; i++) {			
			Card *myCard = [deck getCardAtIndex:i];
			Card* card = [[Card alloc] initWithSuit:myCard.suit Rank:myCard.rank];
			[gameModeView.deck addCard:card];
			[card release];
			
			// save received card to application data
			[gameModeView saveToApplicationDataAtIndex:i card:(uint8_t)((card.rank << 2) | card.suit)];
		}
		
		[gameModeView dealNewHandAsNonDealer];	
		
		// villain's turn to make the first move
		//[self makeAMove:[self preflopMove]];
	}	
}


- (void) heroFolded {
	// hero folded. start a new hand.
	//[self startNewHand];
}

- (void) heroCheckedTimerMethod {
	timer = nil;
	
	if (gameModeView.hand.street == kStreetRiver) {
		[self makeAMove:[self riverMove]];
	} else if (gameModeView.hand.street == kStreetTurn) {
		[self makeAMove:[self turnMove]];
	} else if (gameModeView.hand.street == kStreetFlop) {
		[self makeAMove:[self flopMove]];		
	} else {
		[self makeAMove:[self preflopMove]];		
	}
}	

- (void) heroChecked:(BOOL)isHandOver {
	//if (!isHandOver && !(!gameModeView.dealer && [gameModeView didHeroMakeNoMove])) {
	if (!isHandOver) {
		timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(heroCheckedTimerMethod) userInfo:nil repeats:NO];
	}
}

- (void) villainFirstToActTimerMethod {
	timer = nil;
	
	if (gameModeView.hand.street == kStreetRiver) {
		[self makeAMove:[self riverMove]];
	} else if (gameModeView.hand.street == kStreetTurn) {
		[self makeAMove:[self turnMove]];
	} else if (gameModeView.hand.street == kStreetFlop) {
		[self makeAMove:[self flopMove]];
	} else {
		[self makeAMove:[self preflopMove]];		
	}
}

- (void) heroCalledTimerMethod {
	timer = nil;

	if (gameModeView.hand.street == kStreetRiver) {
		[self makeAMove:[self riverMove]];
	} else if (gameModeView.hand.street == kStreetTurn) {
		[self makeAMove:[self turnMove]];
	} else if (gameModeView.hand.street == kStreetFlop) {
		[self makeAMove:[self flopMove]];		
	} else {		
		[self makeAMove:[self preflopMove]];			
	}
}

- (void) heroCalled:(BOOL)isHandOver {
	//if (!isHandOver && !(!gameModeView.dealer && [gameModeView didHeroMakeNoMove])) {
	if (!isHandOver) {
		timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(heroCalledTimerMethod) userInfo:nil repeats:NO];
	}
}

- (void) heroBetTimerMethod {
	timer = nil;

	if (gameModeView.hand.street == kStreetRiver) {
		[self makeAMove:[self riverMove]];
	} else if (gameModeView.hand.street == kStreetTurn) {
		[self makeAMove:[self turnMove]];		
	} else if (gameModeView.hand.street == kStreetFlop) {
		[self makeAMove:[self flopMove]];
	} else {		
		[self makeAMove:[self preflopMove]];	
	}
}	

- (void) heroBet {
	timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(heroBetTimerMethod) userInfo:nil repeats:NO];	
}

- (void) heroRaisedTimerMethod {
	timer = nil;

	if (gameModeView.hand.street == kStreetRiver) {
		[self makeAMove:[self riverMove]];
	} else if (gameModeView.hand.street == kStreetTurn) {
		[self makeAMove:[self turnMove]];
	} else if (gameModeView.hand.street == kStreetFlop) {
		[self makeAMove:[self flopMove]];
	} else {		
		[self makeAMove:[self preflopMove]];	
	}
}	

- (void) heroRaised {
	timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(heroRaisedTimerMethod) userInfo:nil repeats:NO];		
}

- (void) killAllActiveTimers {
	[timer invalidate];
	timer = nil;
}

@end
