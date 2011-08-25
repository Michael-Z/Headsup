//
//  Hand.h
//  MoveMe
//
//  Created by Haolan Qin on 3/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class Card;
@class MadeHand;

@interface Hand : NSObject {
	enum Street street;
	enum HandGame type;

	// only applied to stud. 5th, 6th, 7th are big bet streets.
	// for stud hi, 4th could become a big bet street.
	BOOL isBigBetStreet;
	
	NSInteger moveCount;
	
	NSInteger raiseCount;	
}

@property (nonatomic) enum Street street; 
@property (nonatomic) NSInteger moveCount;
@property (nonatomic) NSInteger raiseCount;
@property (nonatomic) BOOL isBigBetStreet;


+ (NSInteger)calcTotalCardsToBeDealt: (enum HandGame)handGame;

- (void)newHand;
- (void)newHandWithType:(enum HandGame)handGame;
- (void)nextStreet;
- (void)addMove;

// optimized poker hand methods to meet higher speed requirements.
+ (void) calcBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4
					  :(MadeHand*)madeHand;

+ (void) calcBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5
						  :(MadeHand*)madeHand;

+ (void) calcBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6
						  :(NSMutableArray*)cards5 :(NSMutableArray*)cards7
						  :(MadeHand*)madeHand;

+ (void) calcOmahaBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7
						  :(MadeHand*)madeHand;

+ (void) calcOmahaBestHandFast :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 :(Card*)c8
						  :(NSMutableArray*)holeCards :(NSMutableArray*)communityCards
						  :(MadeHand*)madeHand;


// old poker hand methods that have been proved to work.
+ (void) calcBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4
					  :(MadeHand*)madeHand;

+ (void) calcBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5
					  :(MadeHand*)madeHand;

+ (void) calcBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 
					  :(MadeHand*)madeHand;

+ (void) calcOmahaBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6
					  :(MadeHand*)madeHand;

+ (void) calcOmahaBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7
					  :(MadeHand*)madeHand;

+ (void) calcOmahaBestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 :(Card*)c8
					  :(MadeHand*)madeHand;

+ (void) calcOmahaLo8BestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6
						   :(MadeHand*)madeHand;

+ (void) calcOmahaLo8BestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7
						   :(MadeHand*)madeHand;

+ (void) calcOmahaLo8BestHand :(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3 :(Card*)c4 :(Card*)c5 :(Card*)c6 :(Card*)c7 :(Card*)c8
						   :(MadeHand*)madeHand;

+ (NSComparisonResult) compareHandsFast:(MadeHand*)hand0 :(MadeHand*)hand1;

+ (NSComparisonResult) compareHands:(MadeHand*)hand0 :(MadeHand*)hand1;

+ (NSComparisonResult) compareStudExposedHands:(NSMutableArray*)hand0 :(NSMutableArray*)hand1;


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
				   bestHandForSecondPlayer: (MadeHand*)hand1;

+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3
							communityCard0: (Card*)communityCard0
							communityCard1: (Card*)communityCard1
							communityCard2: (Card*)communityCard2
							communityCard3: (Card*)communityCard3
					bestHandForFirstPlayer: (MadeHand*)hand0 
				   bestHandForSecondPlayer: (MadeHand*)hand1;

+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3
							communityCard0: (Card*)communityCard0
							communityCard1: (Card*)communityCard1
							communityCard2: (Card*)communityCard2
					bestHandForFirstPlayer: (MadeHand*)hand0 
				   bestHandForSecondPlayer: (MadeHand*)hand1;


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
				   bestHandForSecondPlayer: (MadeHand*)hand1;

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
						bestHandForSecondPlayer: (MadeHand*)hand1;

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
						bestHandForSecondPlayer: (MadeHand*)hand1;

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
						bestHandForSecondPlayer: (MadeHand*)hand1;

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
						bestHandForSecondPlayer: (MadeHand*)hand1;

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
						bestHandForSecondPlayer: (MadeHand*)hand1;

+ (NSComparisonResult) calcWinnerHoleCard0: (Card*)holeCard0
								 holeCard1: (Card*)holeCard1
								 holeCard2: (Card*)holeCard2
								 holeCard3: (Card*)holeCard3;



+ (NSComparisonResult) compareStraightFlush:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareQuads:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareBoat:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareFlush:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareStraight:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareTrips:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareTwoPair:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareOnePair:(NSArray*)hand0 :(NSArray*)hand1;
+ (NSComparisonResult) compareHighCard:(NSArray*)hand0 :(NSArray*)hand1;

+ (BOOL) isStraightFlush:(NSArray*)hand;
+ (BOOL) isQuads:(NSArray*)hand;
+ (BOOL) isBoat:(NSArray*)hand;
+ (BOOL) isFlush:(NSArray*)hand;
+ (BOOL) isStraight:(NSArray*)hand;
+ (BOOL) isTrips:(NSArray*)hand;
+ (BOOL) isTwoPair:(NSArray*)hand;
+ (BOOL) isOnePair:(NSArray*)hand;


+ (BOOL) isFelting:(Card*)c0 :(Card*)c1;
+ (BOOL) isPocketPair:(Card*)c0 :(Card*)c1;
+ (BOOL) isSuitedAce:(Card*)c0 :(Card*)c1;
+ (BOOL) isTier1:(Card*)c0 :(Card*)c1;
+ (BOOL) isSuitedConnector:(Card*)card0 :(Card*)card1;
+ (BOOL) isSuitedOneGapper:(Card*)card0 :(Card*)card1;
+ (BOOL) isBigSuitedTwoGapper:(Card*)card0 :(Card*)card1;
+ (BOOL) isAQOffSuit:(Card*)c0 :(Card*)c1;
+ (BOOL) isTier2:(Card*)c0 :(Card*)c1;
+ (BOOL) isOffSuitConnector:(Card*)card0 :(Card*)card1;
+ (BOOL) isOffSuitBroadway:(Card*)card0 :(Card*)card1;
+ (BOOL) isSmallSuitedTwoGapper:(Card*)card0 :(Card*)card1;
+ (BOOL) isTinySuitedConnector:(Card*)card0 :(Card*)card1;
+ (BOOL) isTier3:(Card*)c0 :(Card*)c1;
+ (BOOL) isSuitedKing:(Card*)card0 :(Card*)card1;
+ (BOOL) isSuitedQueen:(Card*)card0 :(Card*)card1;
+ (BOOL) isSuitedJack:(Card*)card0 :(Card*)card1;
+ (BOOL) isOffSuitOneGapper:(Card*)card0 :(Card*)card1;
+ (BOOL) isTier4:(Card*)c0 :(Card*)c1;

+ (BOOL) isOmahaBigPair:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaFelting:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaPremium:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaRundown:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaSpeculative:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaMarginal:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaPlayable:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;
+ (BOOL) isOmahaTrash:(Card*)c0 :(Card*)c1 :(Card*)c2 :(Card*)c3;

@end
