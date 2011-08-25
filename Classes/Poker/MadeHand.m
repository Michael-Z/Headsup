//
//  MadeHand.m
//  Headsup
//
//  Created by Haolan Qin on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MadeHand.h"

#import "Card.h"


@implementation MadeHand

@synthesize loHandType;
@synthesize handType;
@synthesize type;
@synthesize fd;
@synthesize oesd;
@synthesize dgsd;
@synthesize gssd;
@synthesize tocd;
@synthesize outs;
@synthesize cards;

@synthesize quad;
@synthesize quadKicker;
@synthesize boatTrip;
@synthesize boatPair;
@synthesize trip;
@synthesize tripKickerHi;
@synthesize tripKickerLo;
@synthesize twoPairHi;
@synthesize twoPairLo;
@synthesize twoPairKicker;
@synthesize pair;
@synthesize pairKickerHi;
@synthesize pairKickerMid;
@synthesize pairKickerLo;
@synthesize straightHi;
@synthesize sortedCards;


- (id)init {
	if (self = [super init]) {
		//sortedCards = nil;
		sortedCards = malloc(sizeof(int) * 5);
	}
	
	return self;
}

- (void)dealloc {
	//if (sortedCards != nil)
		free(sortedCards);
	
	[cards release];
    [super dealloc];
}

- (NSString*) handDescription {
	NSString *hand;
	
	if (handType == kHandStraightFlush)
		hand = @"straight flush";
	else if (handType == kHandQuads)
		hand = @"four of a kind";
	else if (handType == kHandBoat)
		hand = @"full house";
	else if (handType == kHandFlush)
		hand = @"flush";
	else if (handType == kHandStraight)
		hand = @"straight";
	else if (handType == kHandTrips)
		hand = @"three of a kind";
	else if (handType == kHandTwoPair)
		hand = @"two pair";
	else if (handType == kHandOnePair)
		hand = @"one pair";
	else
		hand = @"no pair";
	
	return hand;
}	

- (NSString*) detailedHandDescription {
	NSString *hand;
	
	Card *card0 = [cards objectAtIndex:0];
	Card *card1 = [cards objectAtIndex:1];
	Card *card2 = [cards objectAtIndex:2];
	Card *card3 = [cards objectAtIndex:3];
	Card *card4 = [cards objectAtIndex:4];
	
	Card *pluralCard0, *pluralCard1;
	
	if (handType == kHandStraightFlush)
		hand = [NSString stringWithFormat:@"Straight flush: %@ through %@", [card0 toRankString], [card4 toRankString]];
	else if (handType == kHandQuads)
		hand = [NSString stringWithFormat:@"Four of a kind: quad %@", [card4 toRankStringPlural]];
	else if (handType == kHandBoat) {
		if (card0.rank == card2.rank) {
			pluralCard0 = card0;
			pluralCard1 = card4;
		} else {
			pluralCard0 = card4;
			pluralCard1 = card0;
		}
		
		hand = [NSString stringWithFormat:@"Full house: %@ full of %@", [pluralCard0 toRankStringPlural], [pluralCard1 toRankStringPlural]];
	} else if (handType == kHandFlush)
		hand = [NSString stringWithFormat:@"Flush: %@ high", [card4 toRankString]];
	else if (handType == kHandStraight)
		hand = [NSString stringWithFormat:@"Straight: %@ through %@", [card0 toRankString], [card4 toRankString]];
	else if (handType == kHandTrips) {
		if (card0.rank == card1.rank)
			pluralCard0 = card0;
		else if (card1.rank == card2.rank)
			pluralCard0 = card1;
		else //if (card2.rank == card3.rank)
			pluralCard0 = card2;
		
		hand = [NSString stringWithFormat:@"Three of a kind: trip %@", [pluralCard0 toRankStringPlural]];
	} else if (handType == kHandTwoPair) {
		if (card0.rank == card1.rank && card2.rank == card3.rank) {
			pluralCard0 = card0;
			pluralCard1 = card2;
		} else if (card0.rank == card1.rank && card3.rank == card4.rank) {
			pluralCard0 = card0;
			pluralCard1 = card3;
		} else { //if (card1.rank == card2.rank && card3.rank == card4.rank) {
			pluralCard0 = card1;
			pluralCard1 = card3;
		}
		
		hand = [NSString stringWithFormat:@"Two pair: %@ and %@", [pluralCard1 toRankStringPlural], [pluralCard0 toRankStringPlural]];
	} else if (handType == kHandOnePair) {
		if (card0.rank == card1.rank)
			pluralCard0 = card0;
		else if (card1.rank == card2.rank)
			pluralCard0 = card1;
		else if (card2.rank == card3.rank)
			pluralCard0 = card2;
		else //if (card3.rank == card4.rank)
			pluralCard0 = card3;
		
		hand = [NSString stringWithFormat:@"One pair: %@", [pluralCard0 toRankStringPlural]];
	} else
		hand = [NSString stringWithFormat:@"No pair: %@ high", [card4 toRankString]];
	
	return hand;
}	

@end
