//
//  Hand.m
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Hand.h"
#import "Constants.h"
#import "Card.h"
#import "MadeHand.h"

int *histogram = nil;
int *histogramCount = nil;
int *histogramRanks = nil;
MadeHand *histogramHand = nil;

@implementation Hand

@synthesize street;
@synthesize moveCount;
@synthesize raiseCount;
@synthesize isBigBetStreet;

+ (NSInteger)calcTotalCardsToBeDealt: (enum HandGame)handGame {
	NSInteger num = 0;
	
	switch (handGame) {
		case kHandHoldem:
			num = 9;
			break;
		case kHandOmaha:
			num = 13;
			break;
		case kHand7Stud:
			num = 14;
			break;
		case kHand5CardSingleDraw:
			num = 20;
			break;	
		case kHand5CardTrippleDraw:
			num = 40;
			break;				
		case kHandBadugi:
			num = 32;
			break;	
		case kHandBlackjack:
			num = 23;
			break;
		default:
			num = 0;
			break;
	}
	
	return num;
}

- (void)newHand {
	street = kStreetPreflop;
	moveCount = 0;
	raiseCount = 0;
	isBigBetStreet = NO;
}

- (void)newHandWithType:(enum HandGame)handGame {
	moveCount = 0;
	raiseCount = 0;
	isBigBetStreet = NO;
	
	type = handGame;
	
	if (type == kHandHoldem || type == kHandOmaha)
		street = kStreetPreflop;
	else if (type == kHand7Stud)
		street = kStreetThird;
	else if (type == kHand5CardSingleDraw || type == kHand5CardTrippleDraw)
		street = kStreetRoundOne;
}

- (void)nextStreet {
	raiseCount = 0;
	if (type == kHandHoldem || type == kHandOmaha) {
		switch (street) {
			case kStreetPreflop:
				street = kStreetFlop;
				break;
			case kStreetFlop:
				street = kStreetTurn;
				break;
			case kStreetTurn:
				street = kStreetRiver;
				break;
			default:
				NSLog(@"wrong street: %d", street);
				break;
		}
	} else if (type == kHand7Stud) {
		switch (street) {
			case kStreetThird:
				street = kStreetFourth;
				break;
			case kStreetFourth:
				street = kStreetFifth;
				isBigBetStreet = YES;
				break;
			case kStreetFifth:
				street = kStreetSixth;
				isBigBetStreet = YES;
				break;
			case kStreetSixth:
				street = kStreetSeventh;
				isBigBetStreet = YES;
				break;
			default:
				NSLog(@"wrong street: %@", street);
				break;
		}		
	} else if (type == kHand5CardSingleDraw || type == kHand5CardTrippleDraw) {
		switch (street) {
			case kStreetRoundOne:
				street = kStreetRoundTwo;
				break;
			case kStreetRoundTwo:
				street = kStreetRoundThree;
				break;
			case kStreetRoundThree:
				street = kStreetRoundFour;
				break;
			default:
				NSLog(@"wrong street: %@", street);
				break;
		}		
	}
}

- (void) addMove {
	++moveCount;
}


+ (NSComparisonResult) compareStraightFlush:(NSArray*)hand0 :(NSArray*)hand1 {
	return [self compareStraight:hand0 :hand1];
}

+ (NSComparisonResult) compareQuads:(NSArray*)hand0 :(NSArray*)hand1 {
	enum Rank quad0, kicker0, quad1, kicker1;
	
	Card *card0Hand0 = (Card*)[hand0 objectAtIndex:0];
	Card *card1Hand0 = (Card*)[hand0 objectAtIndex:1];
	Card *card4Hand0 = (Card*)[hand0 objectAtIndex:4];
	
	if (card0Hand0.rank == card1Hand0.rank) {
		quad0 = card0Hand0.rank;
		kicker0 = card4Hand0.rank;
	} else {
		quad0 = card1Hand0.rank;
		kicker0 = card0Hand0.rank;
	}
	
	
	Card *card0Hand1 = (Card*)[hand1 objectAtIndex:0];
	Card *card1Hand1 = (Card*)[hand1 objectAtIndex:1];
	Card *card4Hand1 = (Card*)[hand1 objectAtIndex:4];
	
	if (card0Hand1.rank == card1Hand1.rank) {
		quad1 = card0Hand1.rank;
		kicker1 = card4Hand1.rank;
	} else {
		quad1 = card1Hand1.rank;
		kicker1 = card0Hand1.rank;
	}	
	
	if (quad0 > quad1)
		return NSOrderedDescending;
	else if (quad0 < quad1)
		return NSOrderedAscending;
	else { // if quad0 == quad1 
		if (kicker0 > kicker1)
			return NSOrderedDescending;
		else if (kicker0 < kicker1)
			return NSOrderedAscending;
		else
			return NSOrderedSame;
	}
}

+ (NSComparisonResult) compareBoat:(NSArray*)hand0 :(NSArray*)hand1 {
	enum Rank boat0, kicker0, boat1, kicker1;
	
	Card *card0Hand0 = (Card*)[hand0 objectAtIndex:0];
	Card *card2Hand0 = (Card*)[hand0 objectAtIndex:2];
	Card *card4Hand0 = (Card*)[hand0 objectAtIndex:4];
	
	if (card0Hand0.rank == card2Hand0.rank) {
		boat0 = card0Hand0.rank;
		kicker0 = card4Hand0.rank;
	} else {
		boat0 = card2Hand0.rank;
		kicker0 = card0Hand0.rank;
	}
	
	
	Card *card0Hand1 = (Card*)[hand1 objectAtIndex:0];
	Card *card2Hand1 = (Card*)[hand1 objectAtIndex:2];
	Card *card4Hand1 = (Card*)[hand1 objectAtIndex:4];
	
	if (card0Hand1.rank == card2Hand1.rank) {
		boat1 = card0Hand1.rank;
		kicker1 = card4Hand1.rank;
	} else {
		boat1 = card2Hand1.rank;
		kicker1 = card0Hand1.rank;
	}	
	
	if (boat0 > boat1)
		return NSOrderedDescending;
	else if (boat0 < boat1)
		return NSOrderedAscending;
	else { // if boat0 == boat1 
		if (kicker0 > kicker1)
			return NSOrderedDescending;
		else if (kicker0 < kicker1)
			return NSOrderedAscending;
		else
			return NSOrderedSame;
	}
}

+ (NSComparisonResult) compareFlush:(NSArray*)hand0 :(NSArray*)hand1 {
	return [self compareHighCard:hand0 :hand1];
}

+ (NSComparisonResult) compareStraight:(NSArray*)hand0 :(NSArray*)hand1 {
	Card *card0 = (Card*)[hand0 objectAtIndex:4];
	Card *card1 = (Card*)[hand1 objectAtIndex:4];
	
	if (card0.rank > card1.rank)
		return NSOrderedDescending;
	else if (card0.rank < card1.rank)
		return NSOrderedAscending;
	else
		return NSOrderedSame;	
}

+ (NSComparisonResult) compareHighCardTotal:(NSInteger)total :(NSArray*)hand0 :(NSArray*)hand1 {
	NSComparisonResult result = NSOrderedSame;
	
	for (int i=total-1; i>=0; i--) {
		Card *card0 = (Card*)[hand0 objectAtIndex:i];
		Card *card1 = (Card*)[hand1 objectAtIndex:i];
		
		if (card0.rank > card1.rank) {
			result = NSOrderedDescending;
			break;
		} else if (card0.rank < card1.rank) {
			result = NSOrderedAscending;
			break;
		}
	}
	
	return result;
}

+ (enum Rank) calcTrips:(NSArray*)hand :(NSMutableArray*)nonTripsCards {
	// 3-2, 1-3-1 or 2-3
	Card *card0 = (Card*)[hand objectAtIndex:0];
	Card *card1 = (Card*)[hand objectAtIndex:1];
	Card *card2 = (Card*)[hand objectAtIndex:2];
	Card *card3 = (Card*)[hand objectAtIndex:3];
	Card *card4 = (Card*)[hand objectAtIndex:4];
	
	if (card0.rank == card2.rank) {
		// 3-2
		[nonTripsCards addObject:card3];
		[nonTripsCards addObject:card4];
		return card0.rank;
	} else if (card1.rank == card3.rank) {
		// 1-3-1
		[nonTripsCards addObject:card0];
		[nonTripsCards addObject:card4];
		return card1.rank;
	} else { // if (card2.rank == card4.rank)
		// 2-3
		[nonTripsCards addObject:card0];
		[nonTripsCards addObject:card1];
		return card2.rank;
	}
}

+ (NSComparisonResult) compareTrips:(NSArray*)hand0 :(NSArray*)hand1 {
	NSComparisonResult result = NSOrderedSame;
	
	NSMutableArray *nonTripsCards0 = [[NSMutableArray alloc] init];
	NSMutableArray *nonTripsCards1 = [[NSMutableArray alloc] init];
	
	enum Rank trips0 = [self calcTrips:hand0 :nonTripsCards0];
	enum Rank trips1 = [self calcTrips:hand1 :nonTripsCards1];
	
	if (trips0 > trips1)
		result = NSOrderedDescending;
	else if (trips0 < trips1)
		result = NSOrderedAscending;
	else { // if (trips0 == trips1)
		result = [self compareHighCardTotal:2 :nonTripsCards0 :nonTripsCards1];
	}	
	
	[nonTripsCards0 release];
	[nonTripsCards1 release];
	
	return result;	
}

+ (NSComparisonResult) compareTwoPair:(NSArray*)hand0 :(NSArray*)hand1 {
	// higher pair
	enum Rank pair0Hand0;
	enum Rank pair1Hand0;
	enum Rank kicker0;
	
	// 1-2-2, 2-1-2 or 2-2-1
	Card *card0Hand0 = (Card*)[hand0 objectAtIndex:0];
	Card *card1Hand0 = (Card*)[hand0 objectAtIndex:1];
	Card *card2Hand0 = (Card*)[hand0 objectAtIndex:2];
	Card *card3Hand0 = (Card*)[hand0 objectAtIndex:3];
	Card *card4Hand0 = (Card*)[hand0 objectAtIndex:4];
	
	if (card0Hand0.rank == card1Hand0.rank &&
		card2Hand0.rank == card3Hand0.rank) {
		// 2-2-1
		pair0Hand0 = card2Hand0.rank;
		pair1Hand0 = card0Hand0.rank;
		kicker0 = card4Hand0.rank;		
	} else if (card0Hand0.rank == card1Hand0.rank &&
			   card3Hand0.rank == card4Hand0.rank) {
		// 2-1-2
		pair0Hand0 = card4Hand0.rank;
		pair1Hand0 = card0Hand0.rank;
		kicker0 = card2Hand0.rank;		
	} else {
		// 1-2-2
		pair0Hand0 = card4Hand0.rank;
		pair1Hand0 = card2Hand0.rank;
		kicker0 = card0Hand0.rank;
	}
		
	
	// higher pair
	enum Rank pair0Hand1;
	enum Rank pair1Hand1;
	enum Rank kicker1;
	
	// 1-2-2, 2-1-2 or 2-2-1
	Card *card0Hand1 = (Card*)[hand1 objectAtIndex:0];
	Card *card1Hand1 = (Card*)[hand1 objectAtIndex:1];
	Card *card2Hand1 = (Card*)[hand1 objectAtIndex:2];
	Card *card3Hand1 = (Card*)[hand1 objectAtIndex:3];
	Card *card4Hand1 = (Card*)[hand1 objectAtIndex:4];
	
	if (card0Hand1.rank == card1Hand1.rank &&
		card2Hand1.rank == card3Hand1.rank) {
		// 2-2-1
		pair0Hand1 = card2Hand1.rank;
		pair1Hand1 = card0Hand1.rank;
		kicker1 = card4Hand1.rank;		
	} else if (card0Hand1.rank == card1Hand1.rank &&
			   card3Hand1.rank == card4Hand1.rank) {
		// 2-1-2
		pair0Hand1 = card4Hand1.rank;
		pair1Hand1 = card0Hand1.rank;
		kicker1 = card2Hand1.rank;		
	} else {
		// 1-2-2
		pair0Hand1 = card4Hand1.rank;
		pair1Hand1 = card2Hand1.rank;
		kicker1 = card0Hand1.rank;
	}
	
	
	if (pair0Hand0 > pair0Hand1)
		return NSOrderedDescending;
	else if (pair0Hand0 < pair0Hand1)
		return NSOrderedAscending;
	else { // if (pair0Hand0 == pair0Hand1)
		if (pair1Hand0 > pair1Hand1)
			return NSOrderedDescending;
		else if (pair1Hand0 < pair1Hand1)
			return NSOrderedAscending;
		else { // if (pair1Hand0 == pair1Hand1)
			if (kicker0 > kicker1)
				return NSOrderedDescending;
			else if (kicker0 < kicker1)
				return NSOrderedAscending;
			else
				return NSOrderedSame;
		}	
	}
}

+ (enum Rank) calcOnePair:(NSArray*)hand :(NSMutableArray*)nonPairCards {
	Card *card0 = (Card*)[hand objectAtIndex:0];
	Card *card1 = (Card*)[hand objectAtIndex:1];
	Card *card2 = (Card*)[hand objectAtIndex:2];
	Card *card3 = (Card*)[hand objectAtIndex:3];
	Card *card4 = (Card*)[hand objectAtIndex:4];
	
	if (card0.rank == card1.rank) {
		[nonPairCards addObject:card2];
		[nonPairCards addObject:card3];
		[nonPairCards addObject:card4];
		return card0.rank;
	} else if (card1.rank == card2.rank) {
		[nonPairCards addObject:card0];
		[nonPairCards addObject:card3];
		[nonPairCards addObject:card4];
		return card1.rank;		
	} else if (card2.rank == card3.rank) {
		[nonPairCards addObject:card0];
		[nonPairCards addObject:card1];
		[nonPairCards addObject:card4];
		return card2.rank;		
	} else { // if (card3.rank == card4.rank)
		[nonPairCards addObject:card0];
		[nonPairCards addObject:card1];
		[nonPairCards addObject:card2];
		return card3.rank;		
	}	
}


+ (NSComparisonResult) compareOnePair:(NSArray*)hand0 :(NSArray*)hand1 {
	NSComparisonResult result = NSOrderedSame;
	
	NSMutableArray *nonPairCards0 = [[NSMutableArray alloc] init];
	NSMutableArray *nonPairCards1 = [[NSMutableArray alloc] init];
	
	enum Rank pair0 = [self calcOnePair:hand0 :nonPairCards0];
	enum Rank pair1 = [self calcOnePair:hand1 :nonPairCards1];
	
	if (pair0 > pair1)
		result = NSOrderedDescending;
	else if (pair0 < pair1)
		result = NSOrderedAscending;
	else { // if (pair0 == pair1)
		result = [self compareHighCardTotal:3 :nonPairCards0 :nonPairCards1];
	}	
	
	[nonPairCards0 release];
	[nonPairCards1 release];
	
	return result;
}

+ (NSComparisonResult) compareHighCard:(NSArray*)hand0 :(NSArray*)hand1 {
	return [self compareHighCardTotal:5 :hand0 :hand1];
}


+ (BOOL) isStraightFlush:(NSArray*)cards {
	return [self isStraight:cards] && [self isFlush:cards];
}

+ (BOOL) isQuads:(NSArray*)cards {
	Card *card0 = (Card*)[cards objectAtIndex:0];
	Card *card1 = (Card*)[cards objectAtIndex:1];
	//Card *card2 = (Card*)[cards objectAtIndex:2];
	Card *card3 = (Card*)[cards objectAtIndex:3];
	Card *card4 = (Card*)[cards objectAtIndex:4];
	
	return (card0.rank == card3.rank) || (card1.rank == card4.rank);
}

+ (BOOL) isBoat:(NSArray*)cards {
	Card *card0 = (Card*)[cards objectAtIndex:0];
	Card *card1 = (Card*)[cards objectAtIndex:1];
	Card *card2 = (Card*)[cards objectAtIndex:2];
	Card *card3 = (Card*)[cards objectAtIndex:3];
	Card *card4 = (Card*)[cards objectAtIndex:4];
	
	return 
	((card0.rank == card1.rank) && (card2.rank == card4.rank)) ||
	((card0.rank == card2.rank) && (card3.rank == card4.rank));
}

+ (BOOL) isFlush:(NSArray*)cards {
	Card *card0 = (Card*)[cards objectAtIndex:0];
	Card *card1 = (Card*)[cards objectAtIndex:1];
	Card *card2 = (Card*)[cards objectAtIndex:2];
	Card *card3 = (Card*)[cards objectAtIndex:3];
	Card *card4 = (Card*)[cards objectAtIndex:4];
	
	return 
	(card0.suit == card1.suit) && 
	(card1.suit == card2.suit) &&
	(card2.suit == card3.suit) && 
	(card3.suit == card4.suit);
}

+ (BOOL) isStraight:(NSArray*)cards {
	Card *card0 = (Card*)[cards objectAtIndex:0];
	Card *card1 = (Card*)[cards objectAtIndex:1];
	Card *card2 = (Card*)[cards objectAtIndex:2];
	Card *card3 = (Card*)[cards objectAtIndex:3];
	Card *card4 = (Card*)[cards objectAtIndex:4];
	return 
	(((card0.rank + 1) == card1.rank) ||
	 ((card0.rank == kRankAce) && (card1.rank == kRankTwo))
	) && 
	((card1.rank + 1) == card2.rank) &&
	((card2.rank + 1) == card3.rank) && 
	((card3.rank + 1) == card4.rank);
}

+ (BOOL) isTrips:(NSArray*)cards {
	Card *card0 = (Card*)[cards objectAtIndex:0];
	Card *card1 = (Card*)[cards objectAtIndex:1];
	Card *card2 = (Card*)[cards objectAtIndex:2];
	Card *card3 = (Card*)[cards objectAtIndex:3];
	Card *card4 = (Card*)[cards objectAtIndex:4];
	
	return 
	(card0.rank == card2.rank) || 
	(card1.rank == card3.rank) ||
	(card2.rank == card4.rank);
}

+ (BOOL) isTwoPair:(NSArray*)cards {
	Card *card0 = (Card*)[cards objectAtIndex:0];
	Card *card1 = (Card*)[cards objectAtIndex:1];
	Card *card2 = (Card*)[cards objectAtIndex:2];
	Card *card3 = (Card*)[cards objectAtIndex:3];
	Card *card4 = (Card*)[cards objectAtIndex:4];
	
	return 
	((card0.rank == card1.rank) && (card2.rank == card3.rank)) ||
	((card0.rank == card1.rank) && (card3.rank == card4.rank)) ||
	((card1.rank == card2.rank) && (card3.rank == card4.rank));
}

+ (BOOL) isOnePair:(NSArray*)cards {
	BOOL retval = NO;
	NSInteger cardsTotal = [cards count];
	
	if (cardsTotal == 5) {
		Card *card0 = (Card*)[cards objectAtIndex:0];
		Card *card1 = (Card*)[cards objectAtIndex:1];
		Card *card2 = (Card*)[cards objectAtIndex:2];
		Card *card3 = (Card*)[cards objectAtIndex:3];
		Card *card4 = (Card*)[cards objectAtIndex:4];
		
		retval =
		(card0.rank == card1.rank) ||
		(card1.rank == card2.rank) ||
		(card2.rank == card3.rank) || 
		(card3.rank == card4.rank);
	} else if (cardsTotal == 4) {
		Card *card0 = (Card*)[cards objectAtIndex:0];
		Card *card1 = (Card*)[cards objectAtIndex:1];
		Card *card2 = (Card*)[cards objectAtIndex:2];
		Card *card3 = (Card*)[cards objectAtIndex:3];
		
		retval =
		(card0.rank == card1.rank) ||
		(card1.rank == card2.rank) ||
		(card2.rank == card3.rank);
	} else if (cardsTotal == 3) {
		Card *card0 = (Card*)[cards objectAtIndex:0];
		Card *card1 = (Card*)[cards objectAtIndex:1];
		Card *card2 = (Card*)[cards objectAtIndex:2];
		
		retval =
		(card0.rank == card1.rank) ||
		(card1.rank == card2.rank);
	}		
	
	return retval;
}

// precondition: no trips or two pair board?
// board could contain 3, 4 or 5 cards
+ (enum TrueHandType) calcTrueType:(NSMutableArray*)cards 
						 holeCard0:(Card*)holeCard0
						 holeCard1:(Card*)holeCard1
							 board:(NSMutableArray*)board
						  handType:(enum HandType)handType {
	enum TrueHandType type = kTypeHighCard;
	
	[board sortUsingSelector:@selector(compare:)];
	
	NSInteger communityCardsNum = [board count];
	if (communityCardsNum == 5) {	
		// on the river
		if (handType == kHandStraightFlush)
			type = kTypeStraightFlush;
		else if (handType == kHandQuads)
			type = kTypeQuads;
		else if (handType == kHandBoat)
			type = kTypeBoat;
		else if (handType == kHandFlush)
			type = kTypeFlush;
		else if (handType == kHandStraight)
			type = kTypeStraight;
		else if (handType == kHandTrips) {
			type = kTypeTrips;
		} else if (handType == kHandTwoPair) {
			// check if the board has one pair
			if ([self isOnePair:board]) {
				// board has one pair				
				enum Rank rank4 = ((Card*)[board objectAtIndex:4]).rank;
				enum Rank rank3 = ((Card*)[board objectAtIndex:3]).rank;
				enum Rank rank2 = ((Card*)[board objectAtIndex:2]).rank;
				
				enum Rank topBoardRank = rank4 == rank3 ? rank2 : rank4;
				
				if (holeCard0.rank == holeCard1.rank) {
					// pocket pair
					if (holeCard0.rank > topBoardRank)
						type = kTypeOverPair;
					else
						type = kTypeNonTopPair;
				} else {
					// non-pocket pair
					if (topBoardRank == holeCard0.rank ||
						topBoardRank == holeCard1.rank)
						type = kTypeTopPair;
					else
						type = kTypeNonTopPair;
				}			

			} else {
				// board is not paired
				type = kTypeTwoPair;
			}		
		} else if (handType == kHandOnePair) {
			// check if the board has one pair
			if ([self isOnePair:board]) {
				// board has one pair
				type = kTypeHighCard;
			} else {
				// board is not paired
				enum Rank topBoardRank = ((Card*)[board lastObject]).rank;
				if (holeCard0.rank == holeCard1.rank) {
					// pocket pair
					if (holeCard0.rank > topBoardRank)
						type = kTypeOverPair;
					else
						type = kTypeNonTopPair;
				} else {
					// non-pocket pair
					if (topBoardRank == holeCard0.rank ||
						topBoardRank == holeCard1.rank)
						type = kTypeTopPair;
					else
						type = kTypeNonTopPair;
				}
			}
		} else if (handType == kHandHighCard) {
			type = kTypeHighCard;
		} else {
			NSLog(@"unknown hand type: %d", handType);
		}
	} else if (communityCardsNum == 4) {
		// on the turn
		if (handType == kHandStraightFlush)
			type = kTypeStraightFlush;
		else if (handType == kHandQuads)
			type = kTypeQuads;
		else if (handType == kHandBoat)
			type = kTypeBoat;
		else if (handType == kHandFlush)
			type = kTypeFlush;
		else if (handType == kHandStraight)
			type = kTypeStraight;
		else if (handType == kHandTrips) {
			type = kTypeTrips;
		} else if (handType == kHandTwoPair) {
			// check if the board has one pair
			if ([self isOnePair:board]) {
				// board has one pair				
				enum Rank rank3 = ((Card*)[board objectAtIndex:3]).rank;
				enum Rank rank2 = ((Card*)[board objectAtIndex:2]).rank;
				enum Rank rank1 = ((Card*)[board objectAtIndex:1]).rank;
				
				enum Rank topBoardRank = rank3 == rank2 ? rank1 : rank3;
				
				if (holeCard0.rank == holeCard1.rank) {
					// pocket pair
					if (holeCard0.rank > topBoardRank)
						type = kTypeOverPair;
					else
						type = kTypeNonTopPair;
				} else {
					// non-pocket pair
					if (topBoardRank == holeCard0.rank ||
						topBoardRank == holeCard1.rank)
						type = kTypeTopPair;
					else
						type = kTypeNonTopPair;
				}			
				
			} else {
				// board is not paired
				type = kTypeTwoPair;
			}		
		} else if (handType == kHandOnePair) {
			// check if the board has one pair
			if ([self isOnePair:board]) {
				// board has one pair
				type = kTypeHighCard;
			} else {
				// board is not paired
				enum Rank topBoardRank = ((Card*)[board lastObject]).rank;
				if (holeCard0.rank == holeCard1.rank) {
					// pocket pair
					if (holeCard0.rank > topBoardRank)
						type = kTypeOverPair;
					else
						type = kTypeNonTopPair;
				} else {
					// non-pocket pair
					if (topBoardRank == holeCard0.rank ||
						topBoardRank == holeCard1.rank)
						type = kTypeTopPair;
					else
						type = kTypeNonTopPair;
				}
			}
		} else if (handType == kHandHighCard) {
			type = kTypeHighCard;
		} else {
			NSLog(@"unknown hand type: %d", handType);
		}
	} else if (communityCardsNum == 3) {
		// on the turn
		if (handType == kHandStraightFlush)
			type = kTypeStraightFlush;
		else if (handType == kHandQuads)
			type = kTypeQuads;
		else if (handType == kHandBoat)
			type = kTypeBoat;
		else if (handType == kHandFlush)
			type = kTypeFlush;
		else if (handType == kHandStraight)
			type = kTypeStraight;
		else if (handType == kHandTrips) {
			type = kTypeTrips;
		} else if (handType == kHandTwoPair) {
			// check if the board has one pair
			if ([self isOnePair:board]) {
				// board has one pair				
				enum Rank rank2 = ((Card*)[board objectAtIndex:2]).rank;
				enum Rank rank1 = ((Card*)[board objectAtIndex:1]).rank;
				enum Rank rank0 = ((Card*)[board objectAtIndex:0]).rank;
				
				enum Rank topBoardRank = rank2 == rank1 ? rank0 : rank2;
				
				if (holeCard0.rank == holeCard1.rank) {
					// pocket pair
					if (holeCard0.rank > topBoardRank)
						type = kTypeOverPair;
					else
						type = kTypeNonTopPair;
				} else {
					// non-pocket pair
					if (topBoardRank == holeCard0.rank ||
						topBoardRank == holeCard1.rank)
						type = kTypeTopPair;
					else
						type = kTypeNonTopPair;
				}			
				
			} else {
				// board is not paired
				type = kTypeTwoPair;
			}		
		} else if (handType == kHandOnePair) {
			// check if the board has one pair
			if ([self isOnePair:board]) {
				// board has one pair
				type = kTypeHighCard;
			} else {
				// board is not paired
				enum Rank topBoardRank = ((Card*)[board lastObject]).rank;
				if (holeCard0.rank == holeCard1.rank) {
					// pocket pair
					if (holeCard0.rank > topBoardRank)
						type = kTypeOverPair;
					else
						type = kTypeNonTopPair;
				} else {
					// non-pocket pair
					if (topBoardRank == holeCard0.rank ||
						topBoardRank == holeCard1.rank)
						type = kTypeTopPair;
					else
						type = kTypeNonTopPair;
				}
			}
		} else if (handType == kHandHighCard) {
			type = kTypeHighCard;
		} else {
			NSLog(@"unknown hand type: %d", handType);
		}
	}			
	
	return type;
}

+ (BOOL) isFlushDraw:(NSMutableArray*)board
		   holeCard0:(Card*)holeCard0
		   holeCard1:(Card*)holeCard1 {
	NSInteger boardSize = [board count];
	BOOL retval;
	
	if (holeCard0.suit == holeCard1.suit) {
		NSInteger count = 0;
		for (int i=0; i < boardSize; i++) {
			Card *card = (Card*)[board objectAtIndex:i];
			if (card.suit == holeCard0.suit)
				++count;
		}
		
		retval = (count == 2);
	} else {
		NSInteger count0 = 0;
		NSInteger count1 = 0;
		for (int i=0; i < boardSize; i++) {
			Card *card = (Card*)[board objectAtIndex:i];
			if (card.suit == holeCard0.suit)
				++count0;
			else if (card.suit == holeCard1.suit)
				++count1;
		}
		
		retval = (count0 == 3 || count1 == 3);
	}
	
	return retval;
}

+ (BOOL) isOpenEndedStraightDraw:(NSMutableArray*)board
					   holeCard0:(Card*)holeCard0
					   holeCard1:(Card*)holeCard1 {
	// holds unique ranks
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:holeCard0];
	if (holeCard1.rank != holeCard0.rank)
		[cards addObject:holeCard1];
	NSInteger boardSize = [board count];
	for (int i=0; i< boardSize; i++) {
		Card *boardCard = (Card*)[board objectAtIndex:i];
		BOOL isDuplicate = NO;
		for (int j=0; j < [cards count]; j++) {
			Card *c = (Card*)[cards objectAtIndex:j];
			if (c.rank == boardCard.rank) {
				isDuplicate = YES;
				break;
			}
		}
		
		if (!isDuplicate)
			[cards addObject:boardCard];
	}
	
	[cards sortUsingSelector:@selector(compare:)];
	
	NSInteger cardsSize = [cards count];
	BOOL retval = NO; 

	if (cardsSize < 4) {
		retval = NO;
	} else {
		for (int i=0; i <= cardsSize - 4; i++) {
			Card *lowest = (Card*)[cards objectAtIndex:i];
			Card *highest = (Card*)[cards objectAtIndex:i+3];
			
			if (highest.rank - lowest.rank == 3 && highest.rank != kRankAce) {
				retval = YES;
				break;
			}
		}
	}
	
	[cards release];
	
	
	return retval;
}

+ (BOOL) isDoubleGutterStraightDraw:(NSMutableArray*)board
						  holeCard0:(Card*)holeCard0
						  holeCard1:(Card*)holeCard1 {
	
	// holds unique ranks
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:holeCard0];
	if (holeCard1.rank != holeCard0.rank)
		[cards addObject:holeCard1];
	NSInteger boardSize = [board count];
	for (int i=0; i< boardSize; i++) {
		Card *boardCard = (Card*)[board objectAtIndex:i];
		BOOL isDuplicate = NO;
		for (int j=0; j < [cards count]; j++) {
			Card *c = (Card*)[cards objectAtIndex:j];
			if (c.rank == boardCard.rank) {
				isDuplicate = YES;
				break;
			}
		}
		
		if (!isDuplicate)
			[cards addObject:boardCard];
	}
	
	[cards sortUsingSelector:@selector(compare:)];
	
	NSInteger cardsSize = [cards count];
	if (cardsSize < 5) {
		[cards release];
		return NO;
	}
	
	BOOL retval = NO;
	for (int i=0; i <= cardsSize - 5; i++) {
		Card *c0 = (Card*)[cards objectAtIndex:i];
		Card *c1 = (Card*)[cards objectAtIndex:i+1];
		Card *c2 = (Card*)[cards objectAtIndex:i+2];
		Card *c3 = (Card*)[cards objectAtIndex:i+3];
		Card *c4 = (Card*)[cards objectAtIndex:i+4];
		
		if ((c1.rank == c0.rank + 2 &&
			c2.rank == c1.rank + 1 &&
			c3.rank == c2.rank + 1 &&
			c4.rank == c3.rank + 2) ||
			(c0.rank == kRankThree &&
			c1.rank == kRankFour &&
			c2.rank == kRankFive &&
			c3.rank == kRankSeven &&
			((Card*)[cards lastObject]).rank == kRankAce)
			) {
			retval = YES;
			break;
		}
	}
	
	if (!retval && cardsSize >= 6) {
		for (int i=0; i <= cardsSize - 6; i++) {
			Card *c0 = (Card*)[cards objectAtIndex:i];
			Card *c1 = (Card*)[cards objectAtIndex:i+1];
			Card *c2 = (Card*)[cards objectAtIndex:i+2];
			Card *c3 = (Card*)[cards objectAtIndex:i+3];
			Card *c4 = (Card*)[cards objectAtIndex:i+4];
			Card *c5 = (Card*)[cards objectAtIndex:i+5];
			
			if ((c1.rank == c0.rank + 1 &&
				c2.rank == c1.rank + 2 &&
				c3.rank == c2.rank + 1 &&
				c4.rank == c3.rank + 2 &&
				c5.rank == c4.rank + 1) ||
				(c0.rank == kRankTwo &&
				c1.rank == kRankFour &&
				c2.rank == kRankFive &&
				c3.rank == kRankSeven &&
				c4.rank == kRankEight &&
				((Card*)[cards lastObject]).rank == kRankAce)
				) {
				retval = YES;
				break;
			}
		}		
	}
	
	[cards release];
	
	
	return retval;
}

+ (BOOL) isGutShotStraightDraw:(NSMutableArray*)board
					 holeCard0:(Card*)holeCard0
					 holeCard1:(Card*)holeCard1 {
	// holds unique ranks
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:holeCard0];
	if (holeCard1.rank != holeCard0.rank)
		[cards addObject:holeCard1];
	NSInteger boardSize = [board count];
	for (int i=0; i< boardSize; i++) {
		Card *boardCard = (Card*)[board objectAtIndex:i];
		BOOL isDuplicate = NO;
		for (int j=0; j < [cards count]; j++) {
			Card *c = (Card*)[cards objectAtIndex:j];
			if (c.rank == boardCard.rank) {
				isDuplicate = YES;
				break;
			}
		}
		
		if (!isDuplicate)
			[cards addObject:boardCard];
	}
	
	[cards sortUsingSelector:@selector(compare:)];
	
	NSInteger cardsSize = [cards count];
	BOOL retval = NO;

	if (cardsSize < 4) {
		retval = NO;
	} else {
		for (int i=0; i <= cardsSize - 4; i++) {
			Card *lowest = (Card*)[cards objectAtIndex:i];
			Card *highest = (Card*)[cards objectAtIndex:i+3];
			
			if (highest.rank - lowest.rank == 4 ||
				(highest.rank == kRankFive &&
				((Card*)[cards lastObject]).rank == kRankAce)
				) {
				retval = YES;
				break;
			}
		}
	}
	
	[cards release];
	
	
	return retval;
}

+ (BOOL) isTwoOverCardsDraw:(NSMutableArray*)board
				  holeCard0:(Card*)holeCard0
				  holeCard1:(Card*)holeCard1 {
	NSInteger boardSize = [board count];
	
	BOOL retval = YES;
	for (int i=0; i < boardSize; i++) {
		Card *card = (Card*)[board objectAtIndex:i];
		if (holeCard0.rank <= card.rank || holeCard1.rank <= card.rank) {
			retval = NO;
			break;
		}
	}
	
	return retval;
}

// board has 3 or 4 cards
+ (void) calcDraws:(MadeHand*)hand 
		 holeCard0:(Card*)holeCard0
		 holeCard1:(Card*)holeCard1
			 board:(NSMutableArray*)board {
	hand.fd = [self isFlushDraw:board holeCard0:holeCard0 holeCard1:holeCard1];
	hand.oesd = [self isOpenEndedStraightDraw:board holeCard0:holeCard0 holeCard1:holeCard1];
	hand.dgsd = [self isDoubleGutterStraightDraw:board holeCard0:holeCard0 holeCard1:holeCard1];
	hand.gssd = [self isGutShotStraightDraw:board holeCard0:holeCard0 holeCard1:holeCard1];
	hand.tocd = [self isTwoOverCardsDraw:board holeCard0:holeCard0 holeCard1:holeCard1];
	
	//NSLog(@"%d %d %d %d %d", hand.fd, hand.oesd, hand.dgsd, hand.gssd, hand.tocd);
}

+ (NSComparisonResult) compareHandsFast:(MadeHand*)hand0 :(MadeHand*)hand1 {
	NSComparisonResult retval = NSOrderedSame;
	if (hand0.handType > hand1.handType) {
		retval = NSOrderedDescending;
	} else if (hand0.handType < hand1.handType) {
		retval = NSOrderedAscending;		
	} else { // if (hand0.handType == hand1.handType)
		if (hand0.handType == kHandHighCard || hand0.handType == kHandFlush) {
			if (hand0.sortedCards[4] > hand1.sortedCards[4])
				retval = NSOrderedDescending;
			else if (hand0.sortedCards[4] < hand1.sortedCards[4])
				retval = NSOrderedAscending;
			else {
				if (hand0.sortedCards[3] > hand1.sortedCards[3])
					retval = NSOrderedDescending;
				else if (hand0.sortedCards[3] < hand1.sortedCards[3])
					retval = NSOrderedAscending;
				else {
					if (hand0.sortedCards[2] > hand1.sortedCards[2])
						retval = NSOrderedDescending;
					else if (hand0.sortedCards[2] < hand1.sortedCards[2])
						retval = NSOrderedAscending;
					else {
						if (hand0.sortedCards[1] > hand1.sortedCards[1])
							retval = NSOrderedDescending;
						else if (hand0.sortedCards[1] < hand1.sortedCards[1])
							retval = NSOrderedAscending;
						else {
							if (hand0.sortedCards[0] > hand1.sortedCards[0])
								retval = NSOrderedDescending;
							else if (hand0.sortedCards[0] < hand1.sortedCards[0])
								retval = NSOrderedAscending;
							else
								retval = NSOrderedSame;
						}
					}
				}
			}
			
		} else if (hand0.handType == kHandOnePair) {
			if (hand0.pair > hand1.pair)
				retval = NSOrderedDescending;
			else if (hand0.pair < hand1.pair)
				retval = NSOrderedAscending;
			else {
				if (hand0.pairKickerHi > hand1.pairKickerHi)
					retval = NSOrderedDescending;
				else if (hand0.pairKickerHi < hand1.pairKickerHi)
					retval = NSOrderedAscending;
				else {
					if (hand0.pairKickerMid > hand1.pairKickerMid)
						retval = NSOrderedDescending;
					else if (hand0.pairKickerMid < hand1.pairKickerMid)
						retval = NSOrderedAscending;
					else {
						if (hand0.pairKickerLo > hand1.pairKickerLo)
							retval = NSOrderedDescending;
						else if (hand0.pairKickerLo < hand1.pairKickerLo)
							retval = NSOrderedAscending;
						else
							retval = NSOrderedSame;
					}
				}
			}
			
		} else if (hand0.handType == kHandTwoPair) {
			if (hand0.twoPairHi > hand1.twoPairHi)
				retval = NSOrderedDescending;
			else if (hand0.twoPairHi < hand1.twoPairHi)
				retval = NSOrderedAscending;
			else {
				if (hand0.twoPairLo > hand1.twoPairLo)
					retval = NSOrderedDescending;
				else if (hand0.twoPairLo < hand1.twoPairLo)
					retval = NSOrderedAscending;
				else {
					if (hand0.twoPairKicker > hand1.twoPairKicker)
						retval = NSOrderedDescending;
					else if (hand0.twoPairKicker < hand1.twoPairKicker)
						retval = NSOrderedAscending;
					else
						retval = NSOrderedSame;
				}
			}
			
		} else if (hand0.handType == kHandTrips) {
			if (hand0.trip > hand1.trip)
				retval = NSOrderedDescending;
			else if (hand0.trip < hand1.trip)
				retval = NSOrderedAscending;
			else {
				if (hand0.tripKickerHi > hand1.tripKickerHi)
					retval = NSOrderedDescending;
				else if (hand0.tripKickerHi < hand1.tripKickerHi)
					retval = NSOrderedAscending;
				else {
					if (hand0.tripKickerLo > hand1.tripKickerLo)
						retval = NSOrderedDescending;
					else if (hand0.tripKickerLo < hand1.tripKickerLo)
						retval = NSOrderedAscending;
					else
						retval = NSOrderedSame;
				}
			}
			
		} else if (hand0.handType == kHandStraight || hand0.handType == kHandStraightFlush) {
			if (hand0.straightHi > hand1.straightHi)
				retval = NSOrderedDescending;
			else if (hand0.straightHi < hand1.straightHi)
				retval = NSOrderedAscending;
			else
				retval = NSOrderedSame;		
			
		} else if (hand0.handType == kHandBoat) {
			if (hand0.boatTrip > hand1.boatTrip)
				retval = NSOrderedDescending;
			else if (hand0.boatTrip < hand1.boatTrip)
				retval = NSOrderedAscending;
			else {
				if (hand0.boatPair > hand1.boatPair)
					retval = NSOrderedDescending;
				else if (hand0.boatPair < hand1.boatPair)
					retval = NSOrderedAscending;
				else
					retval = NSOrderedSame;
			}
			
		} else if (hand0.handType == kHandQuads) {
			if (hand0.quad > hand1.quad)
				retval = NSOrderedDescending;
			else if (hand0.quad < hand1.quad)
				retval = NSOrderedAscending;
			else {
				if (hand0.quadKicker > hand1.quadKicker)
					retval = NSOrderedDescending;
				else if (hand0.quadKicker < hand1.quadKicker)
					retval = NSOrderedAscending;
				else
					retval = NSOrderedSame;
			}
			
		} else {
			NSLog(@"unknown hand type: %d", hand0.handType);
		}
	}
	
	
	return retval;
}

+ (void) calcBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4
						  :(MadeHand*)madeHand {
	
	// this array needs to be made static for the class.
	// each element reps a card rank 
	// ([0] & [1] are not used. [14] reps Ace.
	if (histogram == nil)
		histogram = malloc(sizeof(int) * 15);
	
	// this array needs to be made static for the class.
	// each element reps the histogram count for the card.
	if (histogramCount == nil)
		histogramCount = malloc(sizeof(int) * 5);
	
	// this array needs to be made static for the class.
	// each element reps the card's rank.
	if (histogramRanks == nil)
		histogramRanks = malloc(sizeof(int) * 5);
	
	histogramRanks[0] = c0.rank;
	histogramRanks[1] = c1.rank;
	histogramRanks[2] = c2.rank;
	histogramRanks[3] = c3.rank;
	histogramRanks[4] = c4.rank;
	
	// clears histogram array. 
	for (int i=0; i<15; i++)
		histogram[i] = 0;
	
	// populate histogram
	for (int i=0; i<5; i++)
		++histogram[histogramRanks[i]];
	
	// add up all 5 cards' histogram value.
	int sum = 0;
	for (int i=0; i<5; i++) {
		int count = histogram[histogramRanks[i]];
		histogramCount[i] = count;
		sum += count;
	}
	
	// determine hand type based on the sum.
	// Alas there's no 15. Poker is almost mathematically beautiful.
	if (sum == 5) {
		// 11111
		// all 5 cards have unique ranks. could be high card, straight, flush or straight flush.
		int rankLo = -1;
		for (int i=0; i < 15; i++) {
			if (histogram[i] == 1) {
				rankLo = i;
				break;
			}
		}
		
		int rankHi = -1;
		for (int i=14; i >= 0; i--) {
			if (histogram[i] == 1) {
				rankHi = i;
				break;
			}
		}
		
		if (rankHi - rankLo == 4) {
			// straight or straight flush
			madeHand.straightHi = rankHi;
			if (c0.suit == c1.suit &&
				c1.suit == c2.suit &&
				c2.suit == c3.suit &&
				c3.suit == c4.suit)
				madeHand.handType = kHandStraightFlush;
			else
				madeHand.handType = kHandStraight;
		} else {
			//madeHand.sortedCards = malloc(sizeof(int) * 5);
			
			// wheel, wheel straight flush, high card or flush
			// we need to populate madeHand.sortedHands[1][2][3] to find out.
			int count = 1;
			for (int i=rankLo + 1; i <= rankHi - 1; i++) {
				if (histogram[i] == 1)
					madeHand.sortedCards[count++] = i;
			}
			
			if (rankHi == kRankAce && madeHand.sortedCards[3] == kRankFive) {
				// wheel or wheel straight flush
				madeHand.straightHi = kRankFive;
				if (c0.suit == c1.suit &&
					c1.suit == c2.suit &&
					c2.suit == c3.suit &&
					c3.suit == c4.suit)
					madeHand.handType = kHandStraightFlush;
				else
					madeHand.handType = kHandStraight;
				
			} else {
				// high card or flush
				madeHand.sortedCards[0] = rankLo;
				madeHand.sortedCards[4] = rankHi;
				
				if (c0.suit == c1.suit &&
					c1.suit == c2.suit &&
					c2.suit == c3.suit &&
					c3.suit == c4.suit)
					madeHand.handType = kHandFlush;
				else
					madeHand.handType = kHandHighCard;				
			}
		}
		
	} else if (sum == 7) {
		// 22111
		// one pair
		madeHand.handType = kHandOnePair;
		madeHand.pairKickerHi = -1;
		madeHand.pairKickerMid = -1;
		madeHand.pairKickerLo = -1;
		for (int i=0; i<5; i++) {
			int rank = histogramRanks[i];
			if (histogramCount[i] == 2) {
				madeHand.pair = rank;
			} else { // if (histogramCount[i] == 1)
				
				if (madeHand.pairKickerHi == -1) {
					madeHand.pairKickerHi = rank;
				} else {
					if (rank > madeHand.pairKickerHi) {
						if (madeHand.pairKickerMid == -1) {
							madeHand.pairKickerMid = madeHand.pairKickerHi;
							madeHand.pairKickerHi = rank;
						} else {
							madeHand.pairKickerLo = madeHand.pairKickerMid;
							madeHand.pairKickerMid = madeHand.pairKickerHi;
							madeHand.pairKickerHi = rank;							
						}
					} else {
						if (madeHand.pairKickerMid == -1) {
							madeHand.pairKickerMid = rank;
						} else {
							if (rank > madeHand.pairKickerMid) {
								madeHand.pairKickerLo = madeHand.pairKickerMid;
								madeHand.pairKickerMid = rank;
							} else {
								madeHand.pairKickerLo = rank;
							}
						}						
					}
				}
			}
		}
		
	} else if (sum == 9) {
		// 22221
		// two pair
		madeHand.handType = kHandTwoPair;
		madeHand.twoPairHi = -1;
		madeHand.twoPairLo = -1;
		for (int i=0; i<5; i++) {
			int rank = histogramRanks[i];
			if (histogramCount[i] == 1) {
				madeHand.twoPairKicker = rank;
			} else { // if (histogramCount[i] == 2)
				
				if (madeHand.twoPairHi == -1) {
					madeHand.twoPairHi = rank;
				} else {
					if (rank > madeHand.twoPairHi) {
						madeHand.twoPairLo = madeHand.twoPairHi;
						madeHand.twoPairHi = rank;
					} else if (rank < madeHand.twoPairHi) {
						madeHand.twoPairLo = rank;
					}
				}
			}
		}
		
	} else if (sum == 11) {
		// 33311
		// trips
		madeHand.handType = kHandTrips;
		madeHand.tripKickerHi = -1;
		madeHand.tripKickerLo = -1;
		for (int i=0; i<5; i++) {
			int rank = histogramRanks[i];
			if (histogramCount[i] == 3) {
				madeHand.trip = rank;
			} else { // if (histogramCount[i] == 1)
				
				if (madeHand.tripKickerHi == -1) {
					madeHand.tripKickerHi = rank;
				} else {
					if (rank > madeHand.tripKickerHi) {
						madeHand.tripKickerLo = madeHand.tripKickerHi;
						madeHand.tripKickerHi = rank;
					} else {
						madeHand.tripKickerLo = rank;
					}
				}
			}
		}
		
	} else if (sum == 13) {
		// 33322
		// boat
		madeHand.handType = kHandBoat;
		for (int i=0; i<5; i++) {
			int rank = histogramRanks[i];
			if (histogramCount[i] == 3)
				madeHand.boatTrip = rank;
			else // if (histogramCount[i] == 2)
				madeHand.boatPair = rank;
		}
		
	} else if (sum == 17) {
		// 44441
		// quads
		madeHand.handType = kHandQuads;
		for (int i=0; i<5; i++) {
			int rank = histogramRanks[i];
			if (histogramCount[i] == 4)
				madeHand.quad = rank;
			else // if (histogramCount[i] == 1)
				madeHand.quadKicker = rank;
		}
		
	} else {
		NSLog(@"illegal sum: %d %d %d %d %d %d", sum, c0.rank, c1.rank, c2.rank, c3.rank, c4.rank);
	}
	
	//free(ranks);
	//free(histogramCount);
	//free(histogram);
}

+ (void) calcBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5
						  :(MadeHand*)madeHand {
	
	NSMutableArray* cards6 = [[NSMutableArray alloc] init];
	[cards6 addObject:c0];
	[cards6 addObject:c1];
	[cards6 addObject:c2];
	[cards6 addObject:c3];
	[cards6 addObject:c4];
	[cards6 addObject:c5];
	
	// i is card we are going to exclude from the 6 given cards to form
	// a 5-card hand.
	madeHand.handType = kHandHighCard; // lowest holdem hand
	//madeHand.sortedCards = malloc(sizeof(int) * 5);
	madeHand.sortedCards[0] = kRankTwo;
	madeHand.sortedCards[1] = kRankThree;
	madeHand.sortedCards[2] = kRankFour;
	madeHand.sortedCards[3] = kRankFive;
	madeHand.sortedCards[4] = kRankSeven;
	
	if (histogramHand == nil)
		histogramHand = [[MadeHand alloc] init];
	
	for (int i=0; i<=5; i++) {
		NSMutableArray *cards5 = [[NSMutableArray alloc] init];
		NSInteger index=-1;
		for (int k=0; k<5; k++) {
			do {
				++index;
			} while (index == i);
			
			[cards5 addObject:[cards6 objectAtIndex:index]];
		}
		
		// ideally this object should only be instantiated once.
		//MadeHand *hand = [[MadeHand alloc] init];
		[Hand calcBestHandFast:[cards5 objectAtIndex:0] 
							  :[cards5 objectAtIndex:1]
							  :[cards5 objectAtIndex:2]			 
							  :[cards5 objectAtIndex:3]
							  :[cards5 objectAtIndex:4]
							  :histogramHand];
		
		NSComparisonResult comp = [Hand compareHandsFast:madeHand :histogramHand];
		
		if (comp == NSOrderedAscending) {
			madeHand.handType = histogramHand.handType;
			
			madeHand.quad = histogramHand.quad;
			madeHand.quadKicker = histogramHand.quadKicker;
			
			madeHand.boatTrip = histogramHand.boatTrip;
			madeHand.boatPair = histogramHand.boatPair;
			
			madeHand.trip = histogramHand.trip;
			madeHand.tripKickerHi = histogramHand.tripKickerHi;
			madeHand.tripKickerLo = histogramHand.tripKickerLo;
			
			madeHand.twoPairHi = histogramHand.twoPairHi;
			madeHand.twoPairLo = histogramHand.twoPairLo;
			madeHand.twoPairKicker = histogramHand.twoPairKicker;
			
			madeHand.pair = histogramHand.pair;
			madeHand.pairKickerHi = histogramHand.pairKickerHi;
			madeHand.pairKickerMid = histogramHand.pairKickerMid;
			madeHand.pairKickerLo = histogramHand.pairKickerLo;
			
			madeHand.straightHi = histogramHand.straightHi;
			
			/*if (hand.sortedCards != nil) {
				if (madeHand.sortedCards == nil)
					madeHand.sortedCards = malloc(sizeof(int) * 5);
				
				for (int i=0; i < 5; i++)
					madeHand.sortedCards[i] = hand.sortedCards[i];
			}*/
			
			if (histogramHand.handType == kHandHighCard ||
				histogramHand.handType == kHandFlush) {
				for (int i=0; i < 5; i++)
					madeHand.sortedCards[i] = histogramHand.sortedCards[i];				
			}
		}
		
		//[hand release];
		
		[cards5 release];
	}
	
	[cards6 release];	
}

+ (void) calcBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6
						  :(NSMutableArray*)cards5 :(NSMutableArray*)cards7
						  :(MadeHand*)madeHand {
	
	//NSMutableArray* cards7 = [[NSMutableArray alloc] init];
	[cards7 removeAllObjects];
	[cards7 addObject:c0];
	[cards7 addObject:c1];
	[cards7 addObject:c2];
	[cards7 addObject:c3];
	[cards7 addObject:c4];
	[cards7 addObject:c5];
	[cards7 addObject:c6];
	
	// i and j are the two cards we are going to exclude from the 7 given cards to form
	// a 5-card hand.
	madeHand.handType = kHandHighCard; // lowest holdem hand
	//madeHand.sortedCards = malloc(sizeof(int) * 5);
	madeHand.sortedCards[0] = kRankTwo;
	madeHand.sortedCards[1] = kRankThree;
	madeHand.sortedCards[2] = kRankFour;
	madeHand.sortedCards[3] = kRankFive;
	madeHand.sortedCards[4] = kRankSeven;
	
	
	if (histogramHand == nil)
		histogramHand = [[MadeHand alloc] init];

	//NSMutableArray *cards5 = [[NSMutableArray alloc] init];
	for (int i=0; i<=5; i++) {
		for (int j=i+1; j<=6; j++) {
			//NSMutableArray *cards5 = [[NSMutableArray alloc] init];
			[cards5 removeAllObjects];
			NSInteger index=-1;
			for (int k=0; k<5; k++) {
				do {
					++index;
				} while (index == i || index == j);
				
				[cards5 addObject:[cards7 objectAtIndex:index]];
			}
			
			// ideally this object should only be instantiated once.
			//MadeHand *hand = [[MadeHand alloc] init];
			[Hand calcBestHandFast:[cards5 objectAtIndex:0] 
								  :[cards5 objectAtIndex:1]
								  :[cards5 objectAtIndex:2]			 
								  :[cards5 objectAtIndex:3]
								  :[cards5 objectAtIndex:4]
								  :histogramHand];
			
			NSComparisonResult comp = [Hand compareHandsFast:madeHand :histogramHand];
			
			if (comp == NSOrderedAscending) {
				madeHand.handType = histogramHand.handType;
				
				madeHand.quad = histogramHand.quad;
				madeHand.quadKicker = histogramHand.quadKicker;
				
				madeHand.boatTrip = histogramHand.boatTrip;
				madeHand.boatPair = histogramHand.boatPair;
				
				madeHand.trip = histogramHand.trip;
				madeHand.tripKickerHi = histogramHand.tripKickerHi;
				madeHand.tripKickerLo = histogramHand.tripKickerLo;
				
				madeHand.twoPairHi = histogramHand.twoPairHi;
				madeHand.twoPairLo = histogramHand.twoPairLo;
				madeHand.twoPairKicker = histogramHand.twoPairKicker;
				
				madeHand.pair = histogramHand.pair;
				madeHand.pairKickerHi = histogramHand.pairKickerHi;
				madeHand.pairKickerMid = histogramHand.pairKickerMid;
				madeHand.pairKickerLo = histogramHand.pairKickerLo;
				
				madeHand.straightHi = histogramHand.straightHi;
				
				/*if (hand.sortedCards != nil) {
				 if (madeHand.sortedCards == nil)
				 madeHand.sortedCards = malloc(sizeof(int) * 5);
				 
				 for (int i=0; i < 5; i++)
				 madeHand.sortedCards[i] = hand.sortedCards[i];
				 }*/
				
				if (histogramHand.handType == kHandHighCard ||
					histogramHand.handType == kHandFlush) {
					for (int i=0; i < 5; i++)
						madeHand.sortedCards[i] = histogramHand.sortedCards[i];				
				}
			}
			
			//[hand release];
			
			//[cards5 release];
 		}
	}
	
	//[cards5 release];
	
	//[cards7 release];
}

// c0-3 are hole cards c4-7 are 4 community cards
+ (void) calcOmahaBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7
						  :(MadeHand*)madeHand {
	
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 4 community cards
	NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	[communityCards addObject:c7];
	
	madeHand.handType = kHandHighCard; // lowest holdem hand
	//madeHand.sortedCards = malloc(sizeof(int) * 5);
	madeHand.sortedCards[0] = kRankTwo;
	madeHand.sortedCards[1] = kRankThree;
	madeHand.sortedCards[2] = kRankFour;
	madeHand.sortedCards[3] = kRankFive;
	madeHand.sortedCards[4] = kRankSeven;
	
	if (histogramHand == nil)
		histogramHand = [[MadeHand alloc] init];	
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			for (int communityCardIndex0=0; communityCardIndex0<=1; communityCardIndex0++) {
				for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=2; communityCardIndex1++) {
					for (int communityCardIndex2=communityCardIndex1+1; communityCardIndex2<=3; communityCardIndex2++) {
												
						// ideally this object should only be instantiated once.
						//MadeHand *hand = [[MadeHand alloc] init];
						[Hand calcBestHandFast:[holeCards objectAtIndex:holeCardIndex0]
											  :[holeCards objectAtIndex:holeCardIndex1]
											  :[communityCards objectAtIndex:communityCardIndex0]
											  :[communityCards objectAtIndex:communityCardIndex1]
											  :[communityCards objectAtIndex:communityCardIndex2]
											  :histogramHand];
						
						NSComparisonResult comp = [Hand compareHandsFast:madeHand :histogramHand];
						
						if (comp == NSOrderedAscending) {
							madeHand.handType = histogramHand.handType;
							
							madeHand.quad = histogramHand.quad;
							madeHand.quadKicker = histogramHand.quadKicker;
							
							madeHand.boatTrip = histogramHand.boatTrip;
							madeHand.boatPair = histogramHand.boatPair;
							
							madeHand.trip = histogramHand.trip;
							madeHand.tripKickerHi = histogramHand.tripKickerHi;
							madeHand.tripKickerLo = histogramHand.tripKickerLo;
							
							madeHand.twoPairHi = histogramHand.twoPairHi;
							madeHand.twoPairLo = histogramHand.twoPairLo;
							madeHand.twoPairKicker = histogramHand.twoPairKicker;
							
							madeHand.pair = histogramHand.pair;
							madeHand.pairKickerHi = histogramHand.pairKickerHi;
							madeHand.pairKickerMid = histogramHand.pairKickerMid;
							madeHand.pairKickerLo = histogramHand.pairKickerLo;
							
							madeHand.straightHi = histogramHand.straightHi;
							
							/*if (hand.sortedCards != nil) {
							 if (madeHand.sortedCards == nil)
							 madeHand.sortedCards = malloc(sizeof(int) * 5);
							 
							 for (int i=0; i < 5; i++)
							 madeHand.sortedCards[i] = hand.sortedCards[i];
							 }*/
							
							if (histogramHand.handType == kHandHighCard ||
								histogramHand.handType == kHandFlush) {
								for (int i=0; i < 5; i++)
									madeHand.sortedCards[i] = histogramHand.sortedCards[i];				
							}
						}
						
						//[hand release];
					}
				}
			}
		}
	}
	
	[holeCards release];
	[communityCards release];
}

// c0-3 are hole cards c4-8 are 5 community cards
+ (void) calcOmahaBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 :(Card*)c8
						  :(NSMutableArray*)holeCards :(NSMutableArray*)communityCards
						  :(MadeHand*)madeHand {
	
	// 4 hole cards
	//NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards removeAllObjects];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 5 community cards
	//NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards removeAllObjects];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	[communityCards addObject:c7];
	[communityCards addObject:c8];
	
	madeHand.handType = kHandHighCard; // lowest holdem hand
	//madeHand.sortedCards = malloc(sizeof(int) * 5);
	madeHand.sortedCards[0] = kRankTwo;
	madeHand.sortedCards[1] = kRankThree;
	madeHand.sortedCards[2] = kRankFour;
	madeHand.sortedCards[3] = kRankFive;
	madeHand.sortedCards[4] = kRankSeven;
		
	if (histogramHand == nil)
		histogramHand = [[MadeHand alloc] init];
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			for (int communityCardIndex0=0; communityCardIndex0<=2; communityCardIndex0++) {
				for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=3; communityCardIndex1++) {
					for (int communityCardIndex2=communityCardIndex1+1; communityCardIndex2<=4; communityCardIndex2++) {
												
						// ideally this object should only be instantiated once.
						//MadeHand *hand = [[MadeHand alloc] init];
						[Hand calcBestHandFast:[holeCards objectAtIndex:holeCardIndex0]
											  :[holeCards objectAtIndex:holeCardIndex1]
											  :[communityCards objectAtIndex:communityCardIndex0]
											  :[communityCards objectAtIndex:communityCardIndex1]
											  :[communityCards objectAtIndex:communityCardIndex2]
											  :histogramHand];
						
						NSComparisonResult comp = [Hand compareHandsFast:madeHand :histogramHand];
						
						if (comp == NSOrderedAscending) {
							madeHand.handType = histogramHand.handType;
							
							madeHand.quad = histogramHand.quad;
							madeHand.quadKicker = histogramHand.quadKicker;
							
							madeHand.boatTrip = histogramHand.boatTrip;
							madeHand.boatPair = histogramHand.boatPair;
							
							madeHand.trip = histogramHand.trip;
							madeHand.tripKickerHi = histogramHand.tripKickerHi;
							madeHand.tripKickerLo = histogramHand.tripKickerLo;
							
							madeHand.twoPairHi = histogramHand.twoPairHi;
							madeHand.twoPairLo = histogramHand.twoPairLo;
							madeHand.twoPairKicker = histogramHand.twoPairKicker;
							
							madeHand.pair = histogramHand.pair;
							madeHand.pairKickerHi = histogramHand.pairKickerHi;
							madeHand.pairKickerMid = histogramHand.pairKickerMid;
							madeHand.pairKickerLo = histogramHand.pairKickerLo;
							
							madeHand.straightHi = histogramHand.straightHi;
							
							/*if (hand.sortedCards != nil) {
							 if (madeHand.sortedCards == nil)
							 madeHand.sortedCards = malloc(sizeof(int) * 5);
							 
							 for (int i=0; i < 5; i++)
							 madeHand.sortedCards[i] = hand.sortedCards[i];
							 }*/
							
							if (histogramHand.handType == kHandHighCard ||
								histogramHand.handType == kHandFlush) {
								for (int i=0; i < 5; i++)
									madeHand.sortedCards[i] = histogramHand.sortedCards[i];				
							}
						}
						
						//[hand release];	
					}
				}
			}
 		}
	}
				
	//[holeCards release];
	//[communityCards release];
}


// best 5-card hi hand given 7 cards c0-c6 
// c0 and c1 are hole cards while c2-c6 are community cards.
+ (void) calcBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 
					  :(MadeHand*)madeHand {
	NSMutableArray* cards7 = [[NSMutableArray alloc] init];
	[cards7 addObject:c0];
	[cards7 addObject:c1];
	[cards7 addObject:c2];
	[cards7 addObject:c3];
	[cards7 addObject:c4];
	[cards7 addObject:c5];
	[cards7 addObject:c6];
	
	// i, j are the indexes for the two cards we are going to exclude.
	// a holdem hand consists of 7 - 2 = 5 cards 
	enum HandType bestHandType = kHandHighCard;
	NSMutableArray *bestHandCards = nil;
	for (int i=0; i<=5; i++) {
		for (int j=i+1; j<=6; j++) {
			NSMutableArray *cards5 = [[NSMutableArray alloc] init];
			NSInteger index=-1;
			for (int k=0; k<5; k++) {
				do {
					++index;
				} while (index == i || index == j);
				
				[cards5 addObject:[cards7 objectAtIndex:index]];
			}
			
			[cards5 sortUsingSelector:@selector(compare:)];
			
			// move ace from the 4 spot to the 0 spot if it's a wheel
			Card *card0 = (Card*)[cards5 objectAtIndex:0];
			Card *card1 = (Card*)[cards5 objectAtIndex:1];
			Card *card2 = (Card*)[cards5 objectAtIndex:2];
			Card *card3 = (Card*)[cards5 objectAtIndex:3];
			Card *card4 = (Card*)[cards5 objectAtIndex:4];
			
			if (card4.rank == kRankAce &&
				card3.rank == kRankFive &&
				card2.rank == kRankFour &&
				card1.rank == kRankThree &&
				card0.rank == kRankTwo) {
                // card4 the last object needs to be retained because it will be 
                // released when [cards5 removeLastObject]; is executed.
                [card4 retain];
				[cards5 removeLastObject];
				[cards5 insertObject:card4 atIndex:0];
                [card4 release];
			}
			
			if ([self isStraightFlush:cards5]) {
				if (bestHandType == kHandStraightFlush) {
					if ([self compareStraightFlush:cards5 :bestHandCards] == NSOrderedDescending) {
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandStraightFlush;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandQuads) && [self isQuads:cards5]) {
				if (bestHandType == kHandQuads) {
					if ([self compareQuads:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandQuads;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandBoat) && [self isBoat:cards5]) {
				if (bestHandType == kHandBoat) {
					if ([self compareBoat:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandBoat;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandFlush) && [self isFlush:cards5]) {
				if (bestHandType == kHandFlush) {
					if ([self compareFlush:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandFlush;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}	
				
			} else if ((bestHandType <= kHandStraight) && [self isStraight:cards5]) {
				if (bestHandType == kHandStraight) {
					if ([self compareStraight:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandStraight;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandTrips) && [self isTrips:cards5]) {
				if (bestHandType == kHandTrips) {
					if ([self compareTrips:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandTrips;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandTwoPair) && [self isTwoPair:cards5]) {
				if (bestHandType == kHandTwoPair) {
					if ([self compareTwoPair:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandTwoPair;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandOnePair) && [self isOnePair:cards5]) {
				if (bestHandType == kHandOnePair) {
					if ([self compareOnePair:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandOnePair;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if (bestHandType == kHandHighCard) {
				if (!bestHandCards ||
					([self compareHighCard:cards5 :bestHandCards] == NSOrderedDescending)) {							
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			}
				
			[cards5 release];
		}	
	}
		
	[bestHandCards release];
	madeHand.handType = bestHandType;
	madeHand.cards = bestHandCards;
	
	NSMutableArray *board = [[NSMutableArray alloc] init];
	[board addObject:c2];
	[board addObject:c3];
	[board addObject:c4];
	[board addObject:c5];
	[board addObject:c6];
	madeHand.type = [self calcTrueType:bestHandCards holeCard0:c0 holeCard1:c1 board:board handType:bestHandType];
	[board release];
	
	[cards7 release];
}

// best 5-card hi hand given 6 cards c0-c5 
// c0 and c1 are hole cards while c2-c5 are community cards.
+ (void) calcBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 
					  :(MadeHand*)madeHand {
	NSMutableArray* cards6 = [[NSMutableArray alloc] init];
	[cards6 addObject:c0];
	[cards6 addObject:c1];
	[cards6 addObject:c2];
	[cards6 addObject:c3];
	[cards6 addObject:c4];
	[cards6 addObject:c5];
	
	// i, j are the indexes for the two cards we are going to exclude.
	// a holdem hand consists of 6 - 1 = 5 cards 
	enum HandType bestHandType = kHandHighCard;
	NSMutableArray *bestHandCards = nil;
	for (int i=0; i<=5; i++) {
			NSMutableArray *cards5 = [[NSMutableArray alloc] init];
			NSInteger index=-1;
			for (int k=0; k<5; k++) {
				do {
					++index;
				} while (index == i);
				
				[cards5 addObject:[cards6 objectAtIndex:index]];
			}
			
			[cards5 sortUsingSelector:@selector(compare:)];
			
			// move ace from the 4 spot to the 0 spot if it's a wheel
			Card *card0 = (Card*)[cards5 objectAtIndex:0];
			Card *card1 = (Card*)[cards5 objectAtIndex:1];
			Card *card2 = (Card*)[cards5 objectAtIndex:2];
			Card *card3 = (Card*)[cards5 objectAtIndex:3];
			Card *card4 = (Card*)[cards5 objectAtIndex:4];
			
			if (card4.rank == kRankAce &&
				card3.rank == kRankFive &&
				card2.rank == kRankFour &&
				card1.rank == kRankThree &&
				card0.rank == kRankTwo) {
				// card4 the last object needs to be retained because it will be 
                // released when [cards5 removeLastObject]; is executed.
                [card4 retain];
				[cards5 removeLastObject];
				[cards5 insertObject:card4 atIndex:0];
                [card4 release];
			}
			
			if ([self isStraightFlush:cards5]) {
				if (bestHandType == kHandStraightFlush) {
					if ([self compareStraightFlush:cards5 :bestHandCards] == NSOrderedDescending) {
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandStraightFlush;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandQuads) && [self isQuads:cards5]) {
				if (bestHandType == kHandQuads) {
					if ([self compareQuads:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandQuads;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandBoat) && [self isBoat:cards5]) {
				if (bestHandType == kHandBoat) {
					if ([self compareBoat:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandBoat;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandFlush) && [self isFlush:cards5]) {
				if (bestHandType == kHandFlush) {
					if ([self compareFlush:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandFlush;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}	
				
			} else if ((bestHandType <= kHandStraight) && [self isStraight:cards5]) {
				if (bestHandType == kHandStraight) {
					if ([self compareStraight:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandStraight;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandTrips) && [self isTrips:cards5]) {
				if (bestHandType == kHandTrips) {
					if ([self compareTrips:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandTrips;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandTwoPair) && [self isTwoPair:cards5]) {
				if (bestHandType == kHandTwoPair) {
					if ([self compareTwoPair:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandTwoPair;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandOnePair) && [self isOnePair:cards5]) {
				if (bestHandType == kHandOnePair) {
					if ([self compareOnePair:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandOnePair;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if (bestHandType == kHandHighCard) {
				if (!bestHandCards ||
					([self compareHighCard:cards5 :bestHandCards] == NSOrderedDescending)) {							
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			}
			
			[cards5 release];
	}
	
	[bestHandCards release];
	madeHand.handType = bestHandType;
	madeHand.cards = bestHandCards;
	
	NSMutableArray *board = [[NSMutableArray alloc] init];
	[board addObject:c2];
	[board addObject:c3];
	[board addObject:c4];
	[board addObject:c5];
	madeHand.type = [self calcTrueType:bestHandCards holeCard0:c0 holeCard1:c1 board:board handType:bestHandType];
	[self calcDraws:madeHand holeCard0:c0 holeCard1:c1 board:board];
	[board release];
	
	[cards6 release];
}

// best 5-card hi hand given 5 cards c0-c4. the sorted hi hand will be returned in out parameter madeHand.
+ (void) calcBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(MadeHand*)madeHand {
	NSMutableArray *cards5 = [[NSMutableArray alloc] init];
	[cards5 addObject:c0]; 
	[cards5 addObject:c1]; 
	[cards5 addObject:c2]; 
	[cards5 addObject:c3]; 
	[cards5 addObject:c4]; 
	
	[cards5 sortUsingSelector:@selector(compare:)];
	
	// move ace from the 4 spot to the 0 spot if it's a wheel
	Card *card0 = (Card*)[cards5 objectAtIndex:0];
	Card *card1 = (Card*)[cards5 objectAtIndex:1];
	Card *card2 = (Card*)[cards5 objectAtIndex:2];
	Card *card3 = (Card*)[cards5 objectAtIndex:3];
	Card *card4 = (Card*)[cards5 objectAtIndex:4];
	
	if (card4.rank == kRankAce &&
		card3.rank == kRankFive &&
		card2.rank == kRankFour &&
		card1.rank == kRankThree &&
		card0.rank == kRankTwo) {
		// card4 the last object needs to be retained because it will be 
        // released when [cards5 removeLastObject]; is executed.
        [card4 retain];
        [cards5 removeLastObject];
        [cards5 insertObject:card4 atIndex:0];
        [card4 release];
	}
	
	if ([self isStraightFlush:cards5]) {
		madeHand.handType = kHandStraightFlush;
	} else if ([self isQuads:cards5]) {
		madeHand.handType = kHandQuads;
	} else if ([self isBoat:cards5]) {
		madeHand.handType = kHandBoat;
	} else if ([self isFlush:cards5]) {
		madeHand.handType = kHandFlush;
	} else if ([self isStraight:cards5]) {
		madeHand.handType = kHandStraight;
	} else if ([self isTrips:cards5]) {
		madeHand.handType = kHandTrips;
	} else if ([self isTwoPair:cards5]) {
		madeHand.handType = kHandTwoPair;
	} else if ([self isOnePair:cards5]) {
		madeHand.handType = kHandOnePair;
	} else {
		madeHand.handType = kHandHighCard;
	}
	
	//madeHand.cards = [[NSMutableArray arrayWithArray:cards5] retain];
	
	madeHand.cards = [NSMutableArray arrayWithArray:cards5];
	
	NSMutableArray *board = [[NSMutableArray alloc] init];
	[board addObject:c2];
	[board addObject:c3];
	[board addObject:c4];
	madeHand.type = [self calcTrueType:cards5 holeCard0:c0 holeCard1:c1 board:board handType:madeHand.handType];
	[self calcDraws:madeHand holeCard0:c0 holeCard1:c1 board:board];
	[board release];
	
	
	[cards5 release];
}

// 5 community cards
+ (void) calcOmahaBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 :(Card*)c8 
					  :(MadeHand*)madeHand {
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 5 community cards
	NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	[communityCards addObject:c7];
	[communityCards addObject:c8];
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	enum HandType bestHandType = kHandHighCard;
	NSMutableArray *bestHandCards = nil;
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			for (int communityCardIndex0=0; communityCardIndex0<=2; communityCardIndex0++) {
				for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=3; communityCardIndex1++) {
					for (int communityCardIndex2=communityCardIndex1+1; communityCardIndex2<=4; communityCardIndex2++) {

			NSMutableArray *cards5 = [[NSMutableArray alloc] init];
			[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
			[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
			[cards5 addObject:[communityCards objectAtIndex:communityCardIndex0]];
			[cards5 addObject:[communityCards objectAtIndex:communityCardIndex1]];
			[cards5 addObject:[communityCards objectAtIndex:communityCardIndex2]];
			
			[cards5 sortUsingSelector:@selector(compare:)];
			
			// move ace from the 4 spot to the 0 spot if it's a wheel
			Card *card0 = (Card*)[cards5 objectAtIndex:0];
			Card *card1 = (Card*)[cards5 objectAtIndex:1];
			Card *card2 = (Card*)[cards5 objectAtIndex:2];
			Card *card3 = (Card*)[cards5 objectAtIndex:3];
			Card *card4 = (Card*)[cards5 objectAtIndex:4];
			
			if (card4.rank == kRankAce &&
				card3.rank == kRankFive &&
				card2.rank == kRankFour &&
				card1.rank == kRankThree &&
				card0.rank == kRankTwo) {
				// card4 the last object needs to be retained because it will be 
                // released when [cards5 removeLastObject]; is executed.
                [card4 retain];
				[cards5 removeLastObject];
				[cards5 insertObject:card4 atIndex:0];
                [card4 release];
			}
			
			if ([self isStraightFlush:cards5]) {
				if (bestHandType == kHandStraightFlush) {
					if ([self compareStraightFlush:cards5 :bestHandCards] == NSOrderedDescending) {
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandStraightFlush;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandQuads) && [self isQuads:cards5]) {
				if (bestHandType == kHandQuads) {
					if ([self compareQuads:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandQuads;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandBoat) && [self isBoat:cards5]) {
				if (bestHandType == kHandBoat) {
					if ([self compareBoat:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandBoat;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandFlush) && [self isFlush:cards5]) {
				if (bestHandType == kHandFlush) {
					if ([self compareFlush:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandFlush;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}	
				
			} else if ((bestHandType <= kHandStraight) && [self isStraight:cards5]) {
				if (bestHandType == kHandStraight) {
					if ([self compareStraight:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandStraight;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandTrips) && [self isTrips:cards5]) {
				if (bestHandType == kHandTrips) {
					if ([self compareTrips:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandTrips;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandTwoPair) && [self isTwoPair:cards5]) {
				if (bestHandType == kHandTwoPair) {
					if ([self compareTwoPair:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandTwoPair;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if ((bestHandType <= kHandOnePair) && [self isOnePair:cards5]) {
				if (bestHandType == kHandOnePair) {
					if ([self compareOnePair:cards5 :bestHandCards] == NSOrderedDescending) {							
						[bestHandCards release];
						bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
					}
				} else {
					bestHandType = kHandOnePair;
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			} else if (bestHandType == kHandHighCard) {
				if (!bestHandCards ||
					([self compareHighCard:cards5 :bestHandCards] == NSOrderedDescending)) {							
					[bestHandCards release];
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			}
			
			[cards5 release];
					}
				}
			}
		}	
	}
	
	[bestHandCards release];
	madeHand.handType = bestHandType;
	madeHand.cards = bestHandCards;
	
	[holeCards release];
	[communityCards release];
}

// straight outs + flush outs. communityCards contains 3 or 4 cards.
+ (NSInteger) calcOmahaStraightAndFlushOuts:(NSMutableArray*)holeCards communityCards:(NSMutableArray*)communityCards {
	NSInteger outs = 0;
	
	Card *holeCard0 = (Card*)[holeCards objectAtIndex:0];
	Card *holeCard1 = (Card*)[holeCards objectAtIndex:1];
	Card *holeCard2 = (Card*)[holeCards objectAtIndex:2];
	Card *holeCard3 = (Card*)[holeCards objectAtIndex:3];
	
	int hole0 = [holeCard0 toNumber];
	int hole1 = [holeCard1 toNumber];
	int hole2 = [holeCard2 toNumber];
	int hole3 = [holeCard3 toNumber];
	
	Card *communityCard0 = (Card*)[communityCards objectAtIndex:0];
	Card *communityCard1 = (Card*)[communityCards objectAtIndex:1];
	Card *communityCard2 = (Card*)[communityCards objectAtIndex:2];
	int community0 = [communityCard0 toNumber];
	int community1 = [communityCard1 toNumber];
	int community2 = [communityCard2 toNumber];
	int community3 = -1;
	Card *communityCard3 = nil;
	if ([communityCards count] >= 4) {
		communityCard3 = (Card*)[communityCards objectAtIndex:3];
		community3 = [communityCard3 toNumber];
	}
	
	const int communityCount = [communityCards count];
	
	for (int number=0; number < 52; number++) {
		if (number == hole0 ||
			number == hole1 ||
			number == hole2 ||
			number == hole3 ||
			number == community0 ||
			number == community1 ||
			number == community2 ||
			number == community3)
			continue;
		
		Card* nextCard = [[Card alloc] initWithNumber:number];
		
		for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
			for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
				for (int communityCardIndex0=0; communityCardIndex0<=(communityCount == 3 ? 1 : 2); communityCardIndex0++) {
					for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=(communityCount == 3 ? 2 : 3); communityCardIndex1++) {
						
						NSMutableArray *cards5 = [[NSMutableArray alloc] init];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex0]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex1]];
						[cards5 addObject:nextCard];
						
						[cards5 sortUsingSelector:@selector(compare:)];
						
						// move ace from the 4 spot to the 0 spot if it's a wheel
						Card *card0 = (Card*)[cards5 objectAtIndex:0];
						Card *card1 = (Card*)[cards5 objectAtIndex:1];
						Card *card2 = (Card*)[cards5 objectAtIndex:2];
						Card *card3 = (Card*)[cards5 objectAtIndex:3];
						Card *card4 = (Card*)[cards5 objectAtIndex:4];
						
						if (card4.rank == kRankAce &&
							card3.rank == kRankFive &&
							card2.rank == kRankFour &&
							card1.rank == kRankThree &&
							card0.rank == kRankTwo) {
							// card4 the last object needs to be retained because it will be 
                            // released when [cards5 removeLastObject]; is executed.
                            [card4 retain];
                            [cards5 removeLastObject];
                            [cards5 insertObject:card4 atIndex:0];
                            [card4 release];
						}
						
						if ([Hand isStraight:cards5] ||
							[Hand isFlush:cards5]) {
							++outs;
							[cards5 release];
							goto aaa;
						}
						
						[cards5 release];
					}
				}
			}
		}
		
	aaa:[nextCard release];
	}
						
	return outs;
}

// 4 community cards
+ (void) calcOmahaBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 
						   :(MadeHand*)madeHand {
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 4 community cards
	NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	[communityCards addObject:c7];
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	enum HandType bestHandType = kHandHighCard;
	NSMutableArray *bestHandCards = nil;
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			for (int communityCardIndex0=0; communityCardIndex0<=1; communityCardIndex0++) {
				for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=2; communityCardIndex1++) {
					for (int communityCardIndex2=communityCardIndex1+1; communityCardIndex2<=3; communityCardIndex2++) {
						
						NSMutableArray *cards5 = [[NSMutableArray alloc] init];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex0]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex2]];
						
						[cards5 sortUsingSelector:@selector(compare:)];
						
						// move ace from the 4 spot to the 0 spot if it's a wheel
						Card *card0 = (Card*)[cards5 objectAtIndex:0];
						Card *card1 = (Card*)[cards5 objectAtIndex:1];
						Card *card2 = (Card*)[cards5 objectAtIndex:2];
						Card *card3 = (Card*)[cards5 objectAtIndex:3];
						Card *card4 = (Card*)[cards5 objectAtIndex:4];
						
						if (card4.rank == kRankAce &&
							card3.rank == kRankFive &&
							card2.rank == kRankFour &&
							card1.rank == kRankThree &&
							card0.rank == kRankTwo) {
							// card4 the last object needs to be retained because it will be 
                            // released when [cards5 removeLastObject]; is executed.
                            [card4 retain];
                            [cards5 removeLastObject];
                            [cards5 insertObject:card4 atIndex:0];
                            [card4 release];
						}
						
						if ([self isStraightFlush:cards5]) {
							if (bestHandType == kHandStraightFlush) {
								if ([self compareStraightFlush:cards5 :bestHandCards] == NSOrderedDescending) {
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandStraightFlush;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandQuads) && [self isQuads:cards5]) {
							if (bestHandType == kHandQuads) {
								if ([self compareQuads:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandQuads;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandBoat) && [self isBoat:cards5]) {
							if (bestHandType == kHandBoat) {
								if ([self compareBoat:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandBoat;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandFlush) && [self isFlush:cards5]) {
							if (bestHandType == kHandFlush) {
								if ([self compareFlush:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandFlush;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}	
							
						} else if ((bestHandType <= kHandStraight) && [self isStraight:cards5]) {
							if (bestHandType == kHandStraight) {
								if ([self compareStraight:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandStraight;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandTrips) && [self isTrips:cards5]) {
							if (bestHandType == kHandTrips) {
								if ([self compareTrips:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandTrips;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandTwoPair) && [self isTwoPair:cards5]) {
							if (bestHandType == kHandTwoPair) {
								if ([self compareTwoPair:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandTwoPair;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandOnePair) && [self isOnePair:cards5]) {
							if (bestHandType == kHandOnePair) {
								if ([self compareOnePair:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandOnePair;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if (bestHandType == kHandHighCard) {
							if (!bestHandCards ||
								([self compareHighCard:cards5 :bestHandCards] == NSOrderedDescending)) {							
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						}
						
						[cards5 release];
					}
				}
			}
		}	
	}
	
	[bestHandCards release];
	madeHand.handType = bestHandType;
	madeHand.cards = bestHandCards;
	
	madeHand.outs = [Hand calcOmahaStraightAndFlushOuts:holeCards communityCards:communityCards];
	NSLog(@"4 community cards: %d", madeHand.outs);
	
	[holeCards release];
	[communityCards release];
}

// 3 community cards
+ (void) calcOmahaBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 
						   :(MadeHand*)madeHand {
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 4 community cards
	NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	enum HandType bestHandType = kHandHighCard;
	NSMutableArray *bestHandCards = nil;
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			int communityCardIndex0 = 0;
			int communityCardIndex1 = 1;
			int communityCardIndex2 = 2;
						
						NSMutableArray *cards5 = [[NSMutableArray alloc] init];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex0]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex2]];
						
						[cards5 sortUsingSelector:@selector(compare:)];
						
						// move ace from the 4 spot to the 0 spot if it's a wheel
						Card *card0 = (Card*)[cards5 objectAtIndex:0];
						Card *card1 = (Card*)[cards5 objectAtIndex:1];
						Card *card2 = (Card*)[cards5 objectAtIndex:2];
						Card *card3 = (Card*)[cards5 objectAtIndex:3];
						Card *card4 = (Card*)[cards5 objectAtIndex:4];
						
						if (card4.rank == kRankAce &&
							card3.rank == kRankFive &&
							card2.rank == kRankFour &&
							card1.rank == kRankThree &&
							card0.rank == kRankTwo) {
							// card4 the last object needs to be retained because it will be 
                            // released when [cards5 removeLastObject]; is executed.
                            [card4 retain];
                            [cards5 removeLastObject];
                            [cards5 insertObject:card4 atIndex:0];
                            [card4 release];
						}
						
						if ([self isStraightFlush:cards5]) {
							if (bestHandType == kHandStraightFlush) {
								if ([self compareStraightFlush:cards5 :bestHandCards] == NSOrderedDescending) {
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandStraightFlush;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandQuads) && [self isQuads:cards5]) {
							if (bestHandType == kHandQuads) {
								if ([self compareQuads:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandQuads;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandBoat) && [self isBoat:cards5]) {
							if (bestHandType == kHandBoat) {
								if ([self compareBoat:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandBoat;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandFlush) && [self isFlush:cards5]) {
							if (bestHandType == kHandFlush) {
								if ([self compareFlush:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandFlush;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}	
							
						} else if ((bestHandType <= kHandStraight) && [self isStraight:cards5]) {
							if (bestHandType == kHandStraight) {
								if ([self compareStraight:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandStraight;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandTrips) && [self isTrips:cards5]) {
							if (bestHandType == kHandTrips) {
								if ([self compareTrips:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandTrips;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandTwoPair) && [self isTwoPair:cards5]) {
							if (bestHandType == kHandTwoPair) {
								if ([self compareTwoPair:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandTwoPair;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if ((bestHandType <= kHandOnePair) && [self isOnePair:cards5]) {
							if (bestHandType == kHandOnePair) {
								if ([self compareOnePair:cards5 :bestHandCards] == NSOrderedDescending) {							
									[bestHandCards release];
									bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
								}
							} else {
								bestHandType = kHandOnePair;
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						} else if (bestHandType == kHandHighCard) {
							if (!bestHandCards ||
								([self compareHighCard:cards5 :bestHandCards] == NSOrderedDescending)) {							
								[bestHandCards release];
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						}
						
						[cards5 release];
		}	
	}
	
	[bestHandCards release];
	madeHand.handType = bestHandType;
	madeHand.cards = bestHandCards;
	
	madeHand.outs = [Hand calcOmahaStraightAndFlushOuts:holeCards communityCards:communityCards];
	NSLog(@"3 community cards: %d", madeHand.outs);

	[holeCards release];
	[communityCards release];
}


// hand contains 2 to 4 cards and is a one-pair hand.
+ (enum Rank) calcOnePairExposed:(NSArray*)hand :(NSMutableArray*)nonPairCards {
	NSInteger count = [hand count];
	enum Rank result = kRankTwo;
	
	if (count == 2) {
		Card *card0 = (Card*)[hand objectAtIndex:0];
		result = card0.rank;

	} else if (count == 3) {
		Card *card0 = (Card*)[hand objectAtIndex:0];
		Card *card1 = (Card*)[hand objectAtIndex:1];
		Card *card2 = (Card*)[hand objectAtIndex:2];
		
		if (card0.rank == card1.rank) {
			[nonPairCards addObject:card2];
			result = card0.rank;
		} else { // if (card1.rank == card2.rank)
			[nonPairCards addObject:card0];
			result = card1.rank;
		}

	} else if (count == 4) {
		Card *card0 = (Card*)[hand objectAtIndex:0];
		Card *card1 = (Card*)[hand objectAtIndex:1];
		Card *card2 = (Card*)[hand objectAtIndex:2];
		Card *card3 = (Card*)[hand objectAtIndex:3];
		
		if (card0.rank == card1.rank) {
			[nonPairCards addObject:card2];
			[nonPairCards addObject:card3];			
			result = card0.rank;

		} else if (card1.rank == card2.rank) {
			[nonPairCards addObject:card0];
			[nonPairCards addObject:card3];			
			result = card1.rank;
				
		} else { // if (card2.rank == card3.rank)
			[nonPairCards addObject:card0];
			[nonPairCards addObject:card1];			
			result = card2.rank;
		}
		
	}
	
	return result;	
}


+ (NSComparisonResult) compareOnePairExposed:(NSArray*)hand0 :(NSArray*)hand1 {
	NSComparisonResult result = NSOrderedSame;
	
	NSMutableArray *nonPairCards0 = [[NSMutableArray alloc] init];
	NSMutableArray *nonPairCards1 = [[NSMutableArray alloc] init];
	
	enum Rank pair0 = [self calcOnePairExposed:hand0 :nonPairCards0];
	enum Rank pair1 = [self calcOnePairExposed:hand1 :nonPairCards1];
	
	if (pair0 > pair1)
		result = NSOrderedDescending;
	else if (pair0 < pair1)
		result = NSOrderedAscending;
	else { // if (pair0 == pair1)
		if ([nonPairCards0 count] == 0)
			result = NSOrderedSame;
		else
			result = [self compareHighCardTotal:[nonPairCards0 count] :nonPairCards0 :nonPairCards1];
	}	
	
	[nonPairCards0 release];
	[nonPairCards1 release];
	
	return result;
}



+ (NSComparisonResult) compareHands:(MadeHand*)hand0 :(MadeHand*)hand1 {
	if (hand0.handType > hand1.handType)
		return NSOrderedDescending;
	else if (hand0.handType < hand1.handType)
		return NSOrderedAscending;
	else { // if (hand0.handType == hand1.handType)
		if (hand0.handType == kHandStraightFlush)
			return [self compareStraightFlush:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandQuads)
			return [self compareQuads:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandBoat)
			return [self compareBoat:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandFlush)
			return [self compareFlush:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandStraight)
			return [self compareStraight:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandTrips)
			return [self compareTrips:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandTwoPair)
			return [self compareTwoPair:hand0.cards :hand1.cards];
		else if (hand0.handType == kHandOnePair)
			return [self compareOnePair:hand0.cards :hand1.cards];
		else //if (hand0.handType == kHandHighCard)
			return [self compareHighCard:hand0.cards :hand1.cards];
	}
}

// 1 to 4 exposed cards
// from no pair to quads: no pair, one pair, two pair, three of a kind, four of a kind
// no straight, no flush, A is always hi
+ (NSComparisonResult) compareStudExposedHands:(NSMutableArray*)hand0 :(NSMutableArray*)hand1 {
	enum HandType handType0, handType1;
	
	[hand0 sortUsingSelector:@selector(compare:)];
	[hand1 sortUsingSelector:@selector(compare:)];
	
	// determine hand type for the two hands
	Card *card00, *card01, *card02, *card03;
	Card *card10, *card11, *card12, *card13;
	
	card00 = [hand0 objectAtIndex:0];
	card10 = [hand1 objectAtIndex:0];
	
	const NSInteger count = [hand0 count];
	
	if (count >= 2) {
		card01 = [hand0 objectAtIndex:1];
		card11 = [hand1 objectAtIndex:1];
	}
	
	if (count >= 3) {
		card02 = [hand0 objectAtIndex:2];
		card12 = [hand1 objectAtIndex:2];
	}
	
	if (count >= 4) {
		card03 = [hand0 objectAtIndex:3];
		card13 = [hand1 objectAtIndex:3];
	}
	
	if (count == 1) {
		handType0 = kHandHighCard;
		handType1 = kHandHighCard;
	} else if (count == 2) {
		if (card00.rank == card01.rank)
			handType0 = kHandOnePair;
		else
			handType0 = kHandHighCard;
		
		if (card10.rank == card11.rank)
			handType1 = kHandOnePair;
		else
			handType1 = kHandHighCard;			
	} else if (count == 3) {
		if (card00.rank == card02.rank) {
			handType0 = kHandTrips;
		} else if ((card00.rank == card01.rank) ||
				   (card01.rank == card02.rank)) {
			handType0 = kHandOnePair;
		} else {
			handType0 = kHandHighCard;
		}
		
		if (card10.rank == card12.rank) {
			handType1 = kHandTrips;
		} else if ((card10.rank == card11.rank) ||
				   (card11.rank == card12.rank)) {
			handType1 = kHandOnePair;
		} else {
			handType1 = kHandHighCard;
		}
	} else { //if (count == 4) {
		if (card00.rank == card03.rank) {
			handType0 = kHandQuads;
		} else if ((card00.rank == card02.rank) ||
				   (card01.rank == card03.rank)) {
			handType0 = kHandTrips;
		} else if ((card00.rank == card01.rank) &&
				   (card02.rank == card03.rank)) {
			handType0 = kHandTwoPair;
		} else if ((card00.rank == card01.rank) ||
				   (card01.rank == card02.rank) ||
				   (card02.rank == card03.rank)) {
			handType0 = kHandOnePair;
		} else {
			handType0 = kHandHighCard;
		}
		
		if (card10.rank == card13.rank) {
			handType1 = kHandQuads;
		} else if ((card10.rank == card12.rank) ||
				   (card11.rank == card13.rank)) {
			handType1 = kHandTrips;
		} else if ((card10.rank == card11.rank) &&
				   (card12.rank == card13.rank)) {
			handType1 = kHandTwoPair;
		} else if ((card10.rank == card11.rank) ||
				   (card11.rank == card12.rank) ||
				   (card12.rank == card13.rank)) {
			handType1 = kHandOnePair;
		} else {
			handType1 = kHandHighCard;
		}			
	}	
	
	// compare the two hands
	NSComparisonResult result;
	
	if (handType0 > handType1) {
		result = NSOrderedDescending;
	} else if (handType0 < handType1) {
		result = NSOrderedAscending;
	} else { // if (handType0 == handType1)		
		if (handType0 == kHandQuads) {
			result = [card00 compare:card10];
		} else if (handType0 == kHandTrips && count >= 4) {
			Card *tripCard0 = (card00.rank == card01.rank) ? card00 : card03;
			Card *tripCard1 = (card10.rank == card11.rank) ? card10 : card13;
			
			result = [tripCard0 compare:tripCard1];
			
		} else if (handType0 == kHandTwoPair && count >= 4) {
			result = [card02 compare:card12];
			
			if (result == NSOrderedSame)
				result = [card00 compare:card10];
		} else if (handType0 == kHandOnePair) {
			result = [self compareOnePairExposed:hand0 :hand1];
		} else {// if (handType0 == kHandHighCard) {
			result = [self compareHighCardTotal:[hand0 count] :hand0 :hand1];
		}
	}

	return result;
}


+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
				   holeCard1: (Card*)holeCard1
				   holeCard2: (Card*)holeCard2
				   holeCard3: (Card*)holeCard3
			  communityCard0: (Card*)communityCard0
			  communityCard1: (Card*)communityCard1
			  communityCard2: (Card*)communityCard2
			  communityCard3: (Card*)communityCard3
			  communityCard4: (Card*)communityCard4 
					bestHandForFirstPlayer: (MadeHand*)hand0 
					bestHandForSecondPlayer: (MadeHand*)hand1 {
		
	[self calcBestHand:holeCard0 :holeCard1 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :communityCard4 :hand0];
	[self calcBestHand:holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :communityCard4 :hand1];
	return [self compareHands:hand0 :hand1];
}

+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3
							communityCard0: (Card*)communityCard0
							communityCard1: (Card*)communityCard1
							communityCard2: (Card*)communityCard2
							communityCard3: (Card*)communityCard3
					bestHandForFirstPlayer: (MadeHand*)hand0 
				   bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[self calcBestHand:holeCard0 :holeCard1 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :hand0];
	[self calcBestHand:holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :hand1];
	return [self compareHands:hand0 :hand1];
}

+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3
							communityCard0: (Card*)communityCard0
							communityCard1: (Card*)communityCard1
							communityCard2: (Card*)communityCard2
					bestHandForFirstPlayer: (MadeHand*)hand0 
				   bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[self calcBestHand:holeCard0 :holeCard1 :communityCard0 :communityCard1 :communityCard2 :hand0];
	[self calcBestHand:holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :hand1];
	return [self compareHands:hand0 :hand1];
}

+ (NSComparisonResult) calcOmahaWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3
								  holeCard4: (Card*)holeCard4
								  holeCard5: (Card*)holeCard5
								  holeCard6: (Card*)holeCard6
								  holeCard7: (Card*)holeCard7
								 communityCard0: (Card*)communityCard0
							communityCard1: (Card*)communityCard1
							communityCard2: (Card*)communityCard2
							communityCard3: (Card*)communityCard3
							communityCard4: (Card*)communityCard4 
					bestHandForFirstPlayer: (MadeHand*)hand0 
				   bestHandForSecondPlayer: (MadeHand*)hand1 {

	[self calcOmahaBestHand:holeCard0 :holeCard1 :holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :communityCard4 :hand0];
	[self calcOmahaBestHand:holeCard4 :holeCard5 :holeCard6 :holeCard7 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :communityCard4 :hand1];
	return [self compareHands:hand0 :hand1];	
}

+ (NSComparisonResult) calcOmahaWinnerHoleCard0: (Card*)holeCard0
									  holeCard1: (Card*)holeCard1
									  holeCard2: (Card*)holeCard2
									  holeCard3: (Card*)holeCard3
									  holeCard4: (Card*)holeCard4
									  holeCard5: (Card*)holeCard5
									  holeCard6: (Card*)holeCard6
									  holeCard7: (Card*)holeCard7
								 communityCard0: (Card*)communityCard0
								 communityCard1: (Card*)communityCard1
								 communityCard2: (Card*)communityCard2
								 communityCard3: (Card*)communityCard3
						 bestHandForFirstPlayer: (MadeHand*)hand0 
						bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[self calcOmahaBestHand:holeCard0 :holeCard1 :holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :hand0];
	[self calcOmahaBestHand:holeCard4 :holeCard5 :holeCard6 :holeCard7 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :hand1];
	return [self compareHands:hand0 :hand1];	
}

+ (NSComparisonResult) calcOmahaWinnerHoleCard0: (Card*)holeCard0
									  holeCard1: (Card*)holeCard1
									  holeCard2: (Card*)holeCard2
									  holeCard3: (Card*)holeCard3
									  holeCard4: (Card*)holeCard4
									  holeCard5: (Card*)holeCard5
									  holeCard6: (Card*)holeCard6
									  holeCard7: (Card*)holeCard7
								 communityCard0: (Card*)communityCard0
								 communityCard1: (Card*)communityCard1
								 communityCard2: (Card*)communityCard2
						 bestHandForFirstPlayer: (MadeHand*)hand0 
						bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[self calcOmahaBestHand:holeCard0 :holeCard1 :holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :hand0];
	[self calcOmahaBestHand:holeCard4 :holeCard5 :holeCard6 :holeCard7 :communityCard0 :communityCard1 :communityCard2 :hand1];
	return [self compareHands:hand0 :hand1];	
}

// best 5-card hi hand given 5 cards c0-c4. the sorted hi hand will be returned in out parameter madeHand.
+ (void) calcBestHiHandOutOfFiveCards :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(MadeHand*)madeHand {
	NSMutableArray *cards5 = [[NSMutableArray alloc] init];
	[cards5 addObject:c0]; 
	[cards5 addObject:c1]; 
	[cards5 addObject:c2]; 
	[cards5 addObject:c3]; 
	[cards5 addObject:c4]; 
	
	[cards5 sortUsingSelector:@selector(compare:)];
	
	// move ace from the 4 spot to the 0 spot if it's a wheel
	Card *card0 = (Card*)[cards5 objectAtIndex:0];
	Card *card1 = (Card*)[cards5 objectAtIndex:1];
	Card *card2 = (Card*)[cards5 objectAtIndex:2];
	Card *card3 = (Card*)[cards5 objectAtIndex:3];
	Card *card4 = (Card*)[cards5 objectAtIndex:4];
	
	if (card4.rank == kRankAce &&
		card3.rank == kRankFive &&
		card2.rank == kRankFour &&
		card1.rank == kRankThree &&
		card0.rank == kRankTwo) {
		// card4 the last object needs to be retained because it will be 
        // released when [cards5 removeLastObject]; is executed.
        [card4 retain];
        [cards5 removeLastObject];
        [cards5 insertObject:card4 atIndex:0];
        [card4 release];
	}
	
	if ([self isStraightFlush:cards5]) {
		madeHand.handType = kHandStraightFlush;
	} else if ([self isQuads:cards5]) {
		madeHand.handType = kHandQuads;
	} else if ([self isBoat:cards5]) {
		madeHand.handType = kHandBoat;
	} else if ([self isFlush:cards5]) {
		madeHand.handType = kHandFlush;
	} else if ([self isStraight:cards5]) {
		madeHand.handType = kHandStraight;
	} else if ([self isTrips:cards5]) {
		madeHand.handType = kHandTrips;
	} else if ([self isTwoPair:cards5]) {
		madeHand.handType = kHandTwoPair;
	} else if ([self isOnePair:cards5]) {
		madeHand.handType = kHandOnePair;
	} else {
		madeHand.handType = kHandHighCard;
	}
	
	madeHand.cards = [[NSMutableArray arrayWithArray:cards5] retain];
	
	[cards5 release];
}

// YES if there's no pair.
// precondition: 5-card hand. not sorted.
// postcondition: 5 cards in ascending order. ace is lo.
+ (BOOL) isLo8: (NSMutableArray*)cards5 {
	[cards5 sortUsingSelector:@selector(compare:)];
	
	Card *card0 = (Card*)[cards5 objectAtIndex:0];
	Card *card1 = (Card*)[cards5 objectAtIndex:1];
	Card *card2 = (Card*)[cards5 objectAtIndex:2];
	Card *card3 = (Card*)[cards5 objectAtIndex:3];
	Card *card4 = (Card*)[cards5 objectAtIndex:4];

	return (card4.rank <= kRankEight) &&
			(card0.rank != card1.rank) &&
			(card1.rank != card2.rank) &&
			(card2.rank != card3.rank) &&
			(card3.rank != card4.rank);
}

+ (void) calcOmahaLo8BestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 
							  :(MadeHand*)madeHand {
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 3 community cards
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	NSMutableArray *bestHandCards = nil;
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			NSMutableArray *cards5 = [[NSMutableArray alloc] init];
			[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
			[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
			[cards5 addObject:c4];
			[cards5 addObject:c5];
			[cards5 addObject:c6];
						
			if ([self isLo8:cards5]) {
				if ((bestHandCards == nil) || 
					([self compareHighCard:cards5 :bestHandCards] == NSOrderedAscending)) {
					bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
				}
			}
			
			[cards5 release];
		}	
	}
	
	if (bestHandCards == nil) {
		madeHand.loHandType = kLoHandNoLo;
	} else {
		//??
		madeHand.loHandType = kLoHandNuts;
	}
	
	madeHand.cards = bestHandCards;
	
	[holeCards release];
}

+ (void) calcOmahaLo8BestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 
							  :(MadeHand*)madeHand {
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 4 community cards
	NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	[communityCards addObject:c7];
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	NSMutableArray *bestHandCards = nil;
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			for (int communityCardIndex0=0; communityCardIndex0<=1; communityCardIndex0++) {
				for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=2; communityCardIndex1++) {
					for (int communityCardIndex2=communityCardIndex1+1; communityCardIndex2<=3; communityCardIndex2++) {
						
						NSMutableArray *cards5 = [[NSMutableArray alloc] init];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex0]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex2]];
						
						if ([self isLo8:cards5]) {
							if ((bestHandCards == nil) || 
								([self compareHighCard:cards5 :bestHandCards] == NSOrderedAscending)) {
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						}
						
						[cards5 release];
					}
				}
			}
		}	
	}
	
	if (bestHandCards == nil) {
		madeHand.loHandType = kLoHandNoLo;
	} else {
		//??
		madeHand.loHandType = kLoHandNuts;
	}

	madeHand.cards = bestHandCards;
	
	[holeCards release];
	[communityCards release];
}

+ (void) calcOmahaLo8BestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 :(Card*)c8 
						   :(MadeHand*)madeHand {
	// 4 hole cards
	NSMutableArray* holeCards = [[NSMutableArray alloc] init];
	[holeCards addObject:c0];
	[holeCards addObject:c1];
	[holeCards addObject:c2];
	[holeCards addObject:c3];
	
	// 5 community cards
	NSMutableArray* communityCards = [[NSMutableArray alloc] init];
	[communityCards addObject:c4];
	[communityCards addObject:c5];
	[communityCards addObject:c6];
	[communityCards addObject:c7];
	[communityCards addObject:c8];
	
	// we must pick two hole cards and three community cards to make an Omaha hand.
	NSMutableArray *bestHandCards = nil;
	for (int holeCardIndex0=0; holeCardIndex0<=2; holeCardIndex0++) {
		for (int holeCardIndex1=holeCardIndex0+1; holeCardIndex1<=3; holeCardIndex1++) {
			for (int communityCardIndex0=0; communityCardIndex0<=2; communityCardIndex0++) {
				for (int communityCardIndex1=communityCardIndex0+1; communityCardIndex1<=3; communityCardIndex1++) {
					for (int communityCardIndex2=communityCardIndex1+1; communityCardIndex2<=4; communityCardIndex2++) {
						
						NSMutableArray *cards5 = [[NSMutableArray alloc] init];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex0]];
						[cards5 addObject:[holeCards objectAtIndex:holeCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex0]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex1]];
						[cards5 addObject:[communityCards objectAtIndex:communityCardIndex2]];
						
						if ([self isLo8:cards5]) {
							if ((bestHandCards == nil) || 
								([self compareHighCard:cards5 :bestHandCards] == NSOrderedAscending)) {
								bestHandCards = [[NSMutableArray arrayWithArray:cards5] retain];
							}
						}
						
						[cards5 release];
					}
				}
			}
		}	
	}
	
	if (bestHandCards == nil) {
		madeHand.loHandType = kLoHandNoLo;
	} else {
		//??
		madeHand.loHandType = kLoHandNuts;
	}

	madeHand.cards = bestHandCards;
	
	[holeCards release];
	[communityCards release];
}

+ (NSComparisonResult) reverseComparison: (NSComparisonResult)result {
	if (result == NSOrderedSame)
		return NSOrderedSame;
	else if (result == NSOrderedAscending)
		return NSOrderedDescending;
	else // if (result == NSOrderedDescending)
		return NSOrderedAscending;
}

// selector exposure: Ace lo issue.
// *Razz (best 5-card lo hand out of 7 cards), 
// *Stud/Omaha Hi/Lo (8 qualifier, 5-card lo, no pair, highest card 8 or lower)
// *Draw ace to five (same as Razz. best 5-card lo out of 5 cards)
// *Draw deuce to seven (2-7 lo, Ace is hi only, straight/flush count against you) (compareHands: inverted)
// Badugi (4-card lo out of 4 cards. must be 4 different suits?)


+ (NSComparisonResult) calcOmahaLo8WinnerHoleCard0: (Card*)holeCard0
										 holeCard1: (Card*)holeCard1
										 holeCard2: (Card*)holeCard2
										 holeCard3: (Card*)holeCard3
										 holeCard4: (Card*)holeCard4
										 holeCard5: (Card*)holeCard5
										 holeCard6: (Card*)holeCard6
										 holeCard7: (Card*)holeCard7
									communityCard0: (Card*)communityCard0
									communityCard1: (Card*)communityCard1
									communityCard2: (Card*)communityCard2
									communityCard3: (Card*)communityCard3
							bestHandForFirstPlayer: (MadeHand*)hand0 
						   bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[holeCard0 goLo];
	[holeCard1 goLo];
	[holeCard2 goLo];
	[holeCard3 goLo];
	[holeCard4 goLo];
	[holeCard5 goLo];
	[holeCard6 goLo];
	[holeCard7 goLo];
	[communityCard0 goLo];
	[communityCard1 goLo];
	[communityCard2 goLo];
	[communityCard3 goLo];
	
	[self calcOmahaLo8BestHand:holeCard0 :holeCard1 :holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :hand0];
	[self calcOmahaLo8BestHand:holeCard4 :holeCard5 :holeCard6 :holeCard7 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :hand1];
	
	NSComparisonResult result = NSOrderedSame;
	
	if ((hand0.loHandType == kLoHandNoLo) && (hand1.loHandType == kLoHandNoLo)) {
		result = NSOrderedSame;
	} else if ((hand0.loHandType == kLoHandNoLo) && (hand1.loHandType != kLoHandNoLo)) {
		result = NSOrderedAscending;
	} else if ((hand0.loHandType != kLoHandNoLo) && (hand1.loHandType == kLoHandNoLo)) {
		result = NSOrderedDescending;
	} else if ((hand0.loHandType != kLoHandNoLo) && (hand1.loHandType != kLoHandNoLo)) {
		result = [self reverseComparison :[self compareHighCard:hand0.cards :hand1.cards]];
	}
	
	[holeCard0 goHi];
	[holeCard1 goHi];
	[holeCard2 goHi];
	[holeCard3 goHi];
	[holeCard4 goHi];
	[holeCard5 goHi];
	[holeCard6 goHi];
	[holeCard7 goHi];
	[communityCard0 goHi];
	[communityCard1 goHi];
	[communityCard2 goHi];
	[communityCard3 goHi];
	
	for (Card *card in hand0.cards)
		[card goHi];
	
	for (Card *card in hand1.cards)
		[card goHi];	
	
	return result;
}

+ (NSComparisonResult) calcOmahaLo8WinnerHoleCard0: (Card*)holeCard0
										 holeCard1: (Card*)holeCard1
										 holeCard2: (Card*)holeCard2
										 holeCard3: (Card*)holeCard3
										 holeCard4: (Card*)holeCard4
										 holeCard5: (Card*)holeCard5
										 holeCard6: (Card*)holeCard6
										 holeCard7: (Card*)holeCard7
									communityCard0: (Card*)communityCard0
									communityCard1: (Card*)communityCard1
									communityCard2: (Card*)communityCard2
							bestHandForFirstPlayer: (MadeHand*)hand0 
						   bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[holeCard0 goLo];
	[holeCard1 goLo];
	[holeCard2 goLo];
	[holeCard3 goLo];
	[holeCard4 goLo];
	[holeCard5 goLo];
	[holeCard6 goLo];
	[holeCard7 goLo];
	[communityCard0 goLo];
	[communityCard1 goLo];
	[communityCard2 goLo];
	
	[self calcOmahaLo8BestHand:holeCard0 :holeCard1 :holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :hand0];
	[self calcOmahaLo8BestHand:holeCard4 :holeCard5 :holeCard6 :holeCard7 :communityCard0 :communityCard1 :communityCard2 :hand1];
	
	NSComparisonResult result = NSOrderedSame;
	
	if ((hand0.loHandType == kLoHandNoLo) && (hand1.loHandType == kLoHandNoLo)) {
		result = NSOrderedSame;
	} else if ((hand0.loHandType == kLoHandNoLo) && (hand1.loHandType != kLoHandNoLo)) {
		result = NSOrderedAscending;
	} else if ((hand0.loHandType != kLoHandNoLo) && (hand1.loHandType == kLoHandNoLo)) {
		result = NSOrderedDescending;
	} else if ((hand0.loHandType != kLoHandNoLo) && (hand1.loHandType != kLoHandNoLo)) {
		result = [self reverseComparison :[self compareHighCard:hand0.cards :hand1.cards]];
	}
	
	[holeCard0 goHi];
	[holeCard1 goHi];
	[holeCard2 goHi];
	[holeCard3 goHi];
	[holeCard4 goHi];
	[holeCard5 goHi];
	[holeCard6 goHi];
	[holeCard7 goHi];
	[communityCard0 goHi];
	[communityCard1 goHi];
	[communityCard2 goHi];
	
	for (Card *card in hand0.cards)
		[card goHi];
	
	for (Card *card in hand1.cards)
		[card goHi];	
	
	return result;
}

// size of hand0 and hand1 must be checked before using the return value.
// if both are empty, then it means there's no lo regardless of return value.
// precondition: Ace cards' rank is kRankAce
// postcondition: Ace cards' rank is kRankAce including in hand0 and hand1
+ (NSComparisonResult) calcOmahaLo8WinnerHoleCard0: (Card*)holeCard0
										 holeCard1: (Card*)holeCard1
										 holeCard2: (Card*)holeCard2
										 holeCard3: (Card*)holeCard3
										 holeCard4: (Card*)holeCard4
										 holeCard5: (Card*)holeCard5
										 holeCard6: (Card*)holeCard6
										 holeCard7: (Card*)holeCard7
									communityCard0: (Card*)communityCard0
									communityCard1: (Card*)communityCard1
									communityCard2: (Card*)communityCard2
									communityCard3: (Card*)communityCard3
									communityCard4: (Card*)communityCard4 
							bestHandForFirstPlayer: (MadeHand*)hand0 
						   bestHandForSecondPlayer: (MadeHand*)hand1 {
	
	[holeCard0 goLo];
	[holeCard1 goLo];
	[holeCard2 goLo];
	[holeCard3 goLo];
	[holeCard4 goLo];
	[holeCard5 goLo];
	[holeCard6 goLo];
	[holeCard7 goLo];
	[communityCard0 goLo];
	[communityCard1 goLo];
	[communityCard2 goLo];
	[communityCard3 goLo];
	[communityCard4 goLo];
	
	[self calcOmahaLo8BestHand:holeCard0 :holeCard1 :holeCard2 :holeCard3 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :communityCard4 :hand0];
	[self calcOmahaLo8BestHand:holeCard4 :holeCard5 :holeCard6 :holeCard7 :communityCard0 :communityCard1 :communityCard2 :communityCard3 :communityCard4 :hand1];
	
	NSComparisonResult result = NSOrderedSame;
	
	if ((hand0.loHandType == kLoHandNoLo) && (hand1.loHandType == kLoHandNoLo)) {
		result = NSOrderedSame;
	} else if ((hand0.loHandType == kLoHandNoLo) && (hand1.loHandType != kLoHandNoLo)) {
		result = NSOrderedAscending;
	} else if ((hand0.loHandType != kLoHandNoLo) && (hand1.loHandType == kLoHandNoLo)) {
		result = NSOrderedDescending;
	} else if ((hand0.loHandType != kLoHandNoLo) && (hand1.loHandType != kLoHandNoLo)) {
		result = [self reverseComparison :[self compareHighCard:hand0.cards :hand1.cards]];
	}
	
	[holeCard0 goHi];
	[holeCard1 goHi];
	[holeCard2 goHi];
	[holeCard3 goHi];
	[holeCard4 goHi];
	[holeCard5 goHi];
	[holeCard6 goHi];
	[holeCard7 goHi];
	[communityCard0 goHi];
	[communityCard1 goHi];
	[communityCard2 goHi];
	[communityCard3 goHi];
	[communityCard4 goHi];
	
	for (Card *card in hand0.cards)
		[card goHi];
	
	for (Card *card in hand1.cards)
		[card goHi];	
	
	return result;
}

// compare two 5-card lo Ace to Five hands. (Razz, Draw Ace to Five)
// precondition: hand0 and hand1 are made hands with a known hand type and sorted card array (Ace is lo)
+ (NSComparisonResult) compareLoA5Hands:(MadeHand*)hand0 :(MadeHand*)hand1 {
	if (hand0.handType > hand1.handType)
		return NSOrderedAscending;
	else if (hand0.handType < hand1.handType)
		return NSOrderedDescending;
	else { // if (hand0.handType == hand1.handType)
		if (hand0.handType == kHandQuads)
			return [self reverseComparison:[self compareQuads:hand0.cards :hand1.cards]];
		else if (hand0.handType == kHandBoat)
			return [self reverseComparison:[self compareBoat:hand0.cards :hand1.cards]];
		else if (hand0.handType == kHandTrips)
			return [self reverseComparison:[self compareTrips:hand0.cards :hand1.cards]];
		else if (hand0.handType == kHandTwoPair)
			return [self reverseComparison:[self compareTwoPair:hand0.cards :hand1.cards]];
		else if (hand0.handType == kHandOnePair)
			return [self reverseComparison:[self compareOnePair:hand0.cards :hand1.cards]];
		else //if (hand0.handType == kHandHighCard)
			return [self reverseComparison:[self compareHighCard:hand0.cards :hand1.cards]];
	}
}

+ (BOOL) isFelting:(Card*)c0 :(Card*)c1 {
	return 
	(c0.rank == kRankAce && c1.rank == kRankAce) ||
	(c0.rank == kRankKing && c1.rank == kRankKing) ||
	(c0.rank == kRankQueen && c1.rank == kRankQueen) ||
	(c0.rank == kRankJack && c1.rank == kRankJack) ||
	(c0.rank == kRankAce && c1.rank == kRankKing) ||
	(c0.rank == kRankKing && c1.rank == kRankAce);
}

+ (BOOL) isPocketPair:(Card*)c0 :(Card*)c1 {
	return c0.rank == c1.rank;
}

+ (BOOL) isSuitedAce:(Card*)c0 :(Card*)c1 {
	return c0.suit == c1.suit && (c0.rank == kRankAce || c1.rank == kRankAce);
}

+ (BOOL) isTier1:(Card*)c0 :(Card*)c1 {
	return 
	[self isFelting:c0 :c1] ||
	[self isPocketPair:c0 :c1] ||
	[self isSuitedAce:c0 :c1];
}

+(BOOL) isSuitedConnector:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit == c1.suit && (
	(c0.rank == kRankFour && c1.rank == kRankFive) ||
	(c0.rank == kRankFive && c1.rank == kRankSix) ||
	(c0.rank == kRankSix && c1.rank == kRankSeven) ||
	(c0.rank == kRankSeven && c1.rank == kRankEight) ||
	(c0.rank == kRankEight && c1.rank == kRankNine) ||
	(c0.rank == kRankNine && c1.rank == kRankTen) ||
	(c0.rank == kRankTen && c1.rank == kRankJack) ||
	(c0.rank == kRankJack && c1.rank == kRankQueen) ||
	(c0.rank == kRankQueen && c1.rank == kRankKing)
	);
}

+(BOOL) isSuitedOneGapper:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit == c1.suit && (
						   (c0.rank == kRankFour && c1.rank == kRankSix) ||
						   (c0.rank == kRankFive && c1.rank == kRankSeven) ||
						   (c0.rank == kRankSix && c1.rank == kRankEight) ||
						   (c0.rank == kRankSeven && c1.rank == kRankNine) ||
						   (c0.rank == kRankEight && c1.rank == kRankTen) ||
						   (c0.rank == kRankNine && c1.rank == kRankJack) ||
						   (c0.rank == kRankTen && c1.rank == kRankQueen) ||
						   (c0.rank == kRankJack && c1.rank == kRankKing)
						   );
}

+(BOOL) isBigSuitedTwoGapper:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit == c1.suit && (
						   (c0.rank == kRankEight && c1.rank == kRankJack) ||
						   (c0.rank == kRankNine && c1.rank == kRankQueen) ||
						   (c0.rank == kRankTen && c1.rank == kRankKing)
						   );
}

+(BOOL) isAQOffSuit:(Card*)c0 :(Card*)c1 {
	return 
	(c0.suit != c1.suit &&
	 ((c0.rank == kRankAce && c1.rank == kRankQueen) ||
	  (c0.rank == kRankQueen && c1.rank == kRankAce)));
}

+ (BOOL) isTier2:(Card*)c0 :(Card*)c1 {
	return 
	[self isSuitedConnector:c0 :c1] ||
	[self isSuitedOneGapper:c0 :c1] ||
	[self isBigSuitedTwoGapper:c0 :c1] ||
	[self isAQOffSuit:c0 :c1];
}

+(BOOL) isOffSuitConnector:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit != c1.suit && (
						   (c0.rank == kRankSix && c1.rank == kRankSeven) ||
						   (c0.rank == kRankSeven && c1.rank == kRankEight) ||
						   (c0.rank == kRankEight && c1.rank == kRankNine) ||
						   (c0.rank == kRankNine && c1.rank == kRankTen) ||
						   (c0.rank == kRankTen && c1.rank == kRankJack) ||
						   (c0.rank == kRankJack && c1.rank == kRankQueen) ||
						   (c0.rank == kRankQueen && c1.rank == kRankKing)
						   );	
}

+(BOOL) isOffSuitBroadway:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit != c1.suit && (
						   (c0.rank == kRankTen && c1.rank == kRankQueen) ||
						   (c0.rank == kRankTen && c1.rank == kRankKing) ||
						   (c0.rank == kRankTen && c1.rank == kRankAce) ||
						   (c0.rank == kRankJack && c1.rank == kRankKing) ||
						   (c0.rank == kRankJack && c1.rank == kRankAce)
						   );	
}

+(BOOL) isSmallSuitedTwoGapper:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit == c1.suit && (
						   (c0.rank == kRankTwo && c1.rank == kRankFive) ||
						   (c0.rank == kRankThree && c1.rank == kRankSix) ||
						   (c0.rank == kRankFour && c1.rank == kRankSeven) ||
						   (c0.rank == kRankFive && c1.rank == kRankEight) ||
						   (c0.rank == kRankSix && c1.rank == kRankNine) ||
						   (c0.rank == kRankSeven && c1.rank == kRankTen)
						   );
}

+(BOOL) isTinySuitedConnector:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit == c1.suit && (
						   (c0.rank == kRankTwo && c1.rank == kRankThree) ||
						   (c0.rank == kRankThree && c1.rank == kRankFour) ||
						   (c0.rank == kRankTwo && c1.rank == kRankFour) ||
						   (c0.rank == kRankThree && c1.rank == kRankFive)
						   );
}

+ (BOOL) isTier3:(Card*)c0 :(Card*)c1 {
	return 
	[self isOffSuitConnector:c0 :c1] ||
	[self isOffSuitBroadway:c0 :c1] ||
	[self isSmallSuitedTwoGapper:c0 :c1] ||
	[self isTinySuitedConnector:c0 :c1];
}

+ (BOOL) isSuitedKing:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return c0.suit == c1.suit && c1.rank == kRankKing && c0.rank <= kRankNine;
}

+ (BOOL) isSuitedQueen:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return c0.suit == c1.suit && c1.rank == kRankQueen && c0.rank <= kRankEight;
}

+ (BOOL) isSuitedJack:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return c0.suit == c1.suit && c1.rank == kRankJack && c0.rank <= kRankSeven;
}

+(BOOL) isOffSuitOneGapper:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return 
	c0.suit != c1.suit && (
						   (c0.rank == kRankFour && c1.rank == kRankSix) ||
						   (c0.rank == kRankFive && c1.rank == kRankSeven) ||
						   (c0.rank == kRankSix && c1.rank == kRankEight) ||
						   (c0.rank == kRankSeven && c1.rank == kRankNine) ||
						   (c0.rank == kRankEight && c1.rank == kRankTen) ||
						   (c0.rank == kRankNine && c1.rank == kRankJack)
						   );
}

+(BOOL) isOffSuitAceRag:(Card*)card0 :(Card*)card1 {
	Card *c0, *c1;
	
	if (card0.rank < card1.rank) {
		c0 = card0;
		c1 = card1;
	} else {
		c0 = card1;
		c1 = card0;
	}
	
	return c0.suit != c1.suit && c1.rank == kRankAce && c0.rank <= kRankNine;
}

+ (BOOL) isTier4:(Card*)c0 :(Card*)c1 {
	return 
	[self isSuitedKing:c0 :c1] ||
	[self isSuitedQueen:c0 :c1] ||
	[self isSuitedJack:c0 :c1] ||
	[self isOffSuitOneGapper:c0 :c1] ||
	[self isOffSuitAceRag:c0 :c1];
}

+ (BOOL) isOmahaBigPair:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:c0];
	[cards addObject:c1];
	[cards addObject:c2];
	[cards addObject:c3];
	[cards sortUsingSelector:@selector(compare:)];
	
	Card* card0 = (Card*)[cards objectAtIndex:0];
	Card* card1 = (Card*)[cards objectAtIndex:1];
	Card* card2 = (Card*)[cards objectAtIndex:2];
	Card* card3 = (Card*)[cards objectAtIndex:3];
	
	enum Rank pairRank = kRankTwo;
	
	if (card3.rank == card2.rank)
		pairRank = card3.rank;
	else if (card2.rank == card1.rank)
		pairRank = card2.rank;
	else if (card1.rank == card0.rank)
		pairRank = card1.rank;
	
	BOOL retval = (pairRank >= kRankQueen);
	
	[cards release];
	
	return retval;
}

// omaha starting hands
+ (BOOL) isOmahaFelting:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:c0];
	[cards addObject:c1];
	[cards addObject:c2];
	[cards addObject:c3];
	[cards sortUsingSelector:@selector(compare:)];
	
	Card* topCard1 = (Card*)[cards objectAtIndex:3];
	Card* topCard2 = (Card*)[cards objectAtIndex:2];
	
	BOOL retval = (topCard1.rank == kRankAce && topCard2.rank == kRankAce);
	
	[cards release];
	
	return retval;
}

+ (BOOL) isOmahaBroadway:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:c0];
	[cards addObject:c1];
	[cards addObject:c2];
	[cards addObject:c3];
	[cards sortUsingSelector:@selector(compare:)];
	
	Card* lowestCard = (Card*)[cards objectAtIndex:0];
	
	BOOL retval = (lowestCard.rank >= kRankTen);
	
	[cards release];
	
	return retval;
}

+ (BOOL) isOmahaRundown:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:c0];
	[cards addObject:c1];
	[cards addObject:c2];
	[cards addObject:c3];
	[cards sortUsingSelector:@selector(compare:)];
	
	Card* card0 = (Card*)[cards objectAtIndex:0];
	Card* card1 = (Card*)[cards objectAtIndex:1];
	Card* card2 = (Card*)[cards objectAtIndex:2];
	Card* card3 = (Card*)[cards objectAtIndex:3];
	
	BOOL retval = (
	card0.rank != card1.rank && 
	card1.rank != card2.rank &&
	card2.rank != card3.rank &&
	card0.rank >= kRankThree &&
	card0.rank <= kRankNine &&
	(card3.rank - card0.rank) <= 5
				   );
	
	[cards release];
	
	return retval;
}

+ (BOOL) isOmahaSuitedAce:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:c0];
	[cards addObject:c1];
	[cards addObject:c2];
	[cards addObject:c3];
	[cards sortUsingSelector:@selector(compare:)];
	
	Card* card0 = (Card*)[cards objectAtIndex:0];
	Card* card1 = (Card*)[cards objectAtIndex:1];
	Card* card2 = (Card*)[cards objectAtIndex:2];
	Card* card3 = (Card*)[cards objectAtIndex:3];
	
	BOOL retval = NO;
	
	if (card3.rank == kRankAce) {
		Card* suitedCard = nil, *otherCard0 = nil, *otherCard1 = nil;
		//Card* aceCard = card3;
		enum Suit aceSuit = card3.suit;
		
		if (card2.suit == aceSuit) {
			suitedCard = card2;
			otherCard0 = card1;
			otherCard1 = card0;
		} else if (card1.suit == aceSuit) {
			suitedCard = card1;
			otherCard0 = card2;
			otherCard1 = card0;
		} else if (card0.suit == aceSuit) {
			suitedCard = card0;
			otherCard0 = card2;
			otherCard1 = card1;
		}
		
		if (suitedCard != nil) {
			// suited ace. to qualify as a premium hand, otherCard0 and otherCard1 need
			// to be coordinated with either suitedCard or the ace card.
			retval = (otherCard0.rank == otherCard1.rank ||
					  (otherCard0.rank >= kRankTen && otherCard1.rank >= kRankTen) ||
					  card2.rank - card0.rank <= 4);
		}
	} else {
		retval = NO;
	}
	
	[cards release];
	
	return retval;
}

+ (BOOL) isOmahaPairPlus:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	NSMutableArray *cards = [[NSMutableArray alloc] init];
	[cards addObject:c0];
	[cards addObject:c1];
	[cards addObject:c2];
	[cards addObject:c3];
	[cards sortUsingSelector:@selector(compare:)];
	
	Card* card0 = (Card*)[cards objectAtIndex:0];
	Card* card1 = (Card*)[cards objectAtIndex:1];
	Card* card2 = (Card*)[cards objectAtIndex:2];
	Card* card3 = (Card*)[cards objectAtIndex:3];
	
	BOOL retval = NO;
	
	//enum Rank pairRank;
	Card* otherCard0 = nil, *otherCard1 = nil;
	
	if (card3.rank == card2.rank) {
		//pairRank = card3.rank;
		otherCard0 = card1;
		otherCard1 = card0;
	} else if (card2.rank == card1.rank) {
		//pairRank = card2.rank;
		otherCard0 = card3;
		otherCard1 = card0;
	} else if (card1.rank == card0.rank) {
		//pairRank = card1.rank;
		otherCard0 = card3;
		otherCard1 = card2;
	}
	
		
	if (otherCard0 != nil) {
		retval = (otherCard0.rank == otherCard1.rank ||
				  (otherCard0.rank >= kRankTen && otherCard1.rank >= kRankTen) ||
				  card3.rank - card0.rank <= 4);
	}
	
	[cards release];
	
	return retval;
}


+ (BOOL) isOmahaPremium:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	return 
	[Hand isOmahaFelting:c0 :c1 :c2 :c3] ||
	[Hand isOmahaBroadway:c0 :c1 :c2 :c3] ||
	[Hand isOmahaRundown:c0 :c1 :c2 :c3] ||
	[Hand isOmahaSuitedAce:c0 :c1 :c2 :c3] ||
	[Hand isOmahaPairPlus:c0 :c1 :c2 :c3];
}

+ (BOOL) isOmahaSpeculative:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	return 	[Hand isOmahaRundown:c0 :c1 :c2 :c3];
}

+ (BOOL) isOmahaMarginal:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	return NO;
}

+ (BOOL) isOmahaPlayable:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	return NO;
}

+ (BOOL) isOmahaTrash:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 {
	return NO;
}

+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3 {
	
	NSComparisonResult retval = NSOrderedSame;
	
	if ([Hand isPocketPair:holeCard0 :holeCard1]) {
		// hero has pocket pair
		if ([Hand isPocketPair:holeCard2 :holeCard3]) {
			// villain also has pocket pair.
			// whoever has the bigger pocket pair wins.
			if (holeCard0.rank > holeCard2.rank)
				retval = NSOrderedDescending;
			else if (holeCard0.rank < holeCard2.rank)
				retval = NSOrderedAscending;
			else
				retval = NSOrderedSame;
		} else {
			// villain doesn't have pocket pair. hero wins.
			retval = NSOrderedDescending;
		}
	} else {
		// hero doesn't have pocket pair
		if ([Hand isPocketPair:holeCard2 :holeCard3]) {
			// villain also has pocket pair. villain wins.
			retval = NSOrderedAscending;
		} else {
			// villain doesn't have pocket pair either.
			// whoever has the high card wins.
			Card *c0, *c1, *c2, *c3;
			if (holeCard0.rank > holeCard1.rank) {
				c0 = holeCard0;
				c1 = holeCard1;
			} else {
				c0 = holeCard1;
				c1 = holeCard0;
			}
			
			if (holeCard2.rank > holeCard3.rank) {
				c2 = holeCard2;
				c3 = holeCard3;
			} else {
				c2 = holeCard3;
				c3 = holeCard2;
			}
			
			if (c0.rank > c2.rank) {
				retval = NSOrderedDescending;
			} else if (c0.rank < c2.rank) {
				retval = NSOrderedAscending;
			} else { // if (c0.rank == c2.rank)
				if (c1.rank > c3.rank) {
					retval = NSOrderedDescending;
				} else if (c1.rank < c3.rank) {
					retval = NSOrderedAscending;
				} else { // if (c1.rank == c3.rank)
					if (c0.suit == c1.suit) {
						if (c2.suit == c3.suit) {
							retval = NSOrderedSame;
						} else {
							retval = NSOrderedDescending;
						}
					} else {
						if (c2.suit == c3.suit) {
							retval = NSOrderedAscending;
						} else {
							retval = NSOrderedSame;
						}
					}
				}
			}
		}
	}
	
	return retval;
}

@end
