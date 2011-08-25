//
//  Deck.m
//  MoveMe
//
//  Created by Haolan Qin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <stdlib.h>

#import "Deck.h"
#import "Constants.h"
#import "Card.h"
#import "Hand.h"

@implementation Deck

NSArray *kCardsSpades = nil;
NSArray *kCardsHearts = nil;
NSArray *kCardsDiamonds = nil;
NSArray *kCardsClubs = nil;


+ (NSArray *)generateCardsOfSuit:(enum Suit)suit {
	
	Card *cardAce = [[Card alloc] initWithSuit:suit Rank:kRankAce];
	Card *cardKing = [[Card alloc] initWithSuit:suit Rank:kRankKing];
	Card *cardQueen = [[Card alloc] initWithSuit:suit Rank:kRankQueen];
	Card *cardJack = [[Card alloc] initWithSuit:suit Rank:kRankJack];
	Card *cardTen = [[Card alloc] initWithSuit:suit Rank:kRankTen];
	Card *cardNine = [[Card alloc] initWithSuit:suit Rank:kRankNine];
	Card *cardEight = [[Card alloc] initWithSuit:suit Rank:kRankEight];
	Card *cardSeven = [[Card alloc] initWithSuit:suit Rank:kRankSeven];
	Card *cardSix = [[Card alloc] initWithSuit:suit Rank:kRankSix];
	Card *cardFive = [[Card alloc] initWithSuit:suit Rank:kRankFive];
	Card *cardFour = [[Card alloc] initWithSuit:suit Rank:kRankFour];
	Card *cardThree = [[Card alloc] initWithSuit:suit Rank:kRankThree];
	Card *cardTwo = [[Card alloc] initWithSuit:suit Rank:kRankTwo];
	
	NSArray *retval = [[[NSArray alloc] initWithObjects:
						cardAce,
						cardKing,
						cardQueen,
						cardJack,
						cardTen,
						cardNine,
						cardEight,
						cardSeven,
						cardSix,
						cardFive,
						cardFour,
						cardThree,
						cardTwo,
						nil] autorelease];
	
	[cardAce release];
	[cardKing release];
	[cardQueen release];
	[cardJack release];
	[cardTen release];
	[cardNine release];
	[cardEight release];
	[cardSeven release];
	[cardSix release];
	[cardFive release];
	[cardFour release];
	[cardThree release];
	[cardTwo release];
	
	return retval;
}

+ (NSArray *)getCardsOfSuit: (enum Suit)suit {
	NSArray *cards = nil;
	
	switch (suit) {
		case kSuitSpade:
			if (!kCardsSpades) {
				kCardsSpades = [[Deck generateCardsOfSuit:kSuitSpade] retain];
			}
			cards = kCardsSpades;
			break;
		case kSuitHeart:
			if (!kCardsHearts) {
				kCardsHearts = [[Deck generateCardsOfSuit:kSuitHeart] retain];
			}
			cards = kCardsHearts;
			break;			
		case kSuitDiamond:
			if (!kCardsDiamonds) {
				kCardsDiamonds = [[Deck generateCardsOfSuit:kSuitDiamond] retain];
			}
			cards = kCardsDiamonds;
			break;			
		case kSuitClub:
			if (!kCardsClubs) {
				kCardsClubs = [[Deck generateCardsOfSuit:kSuitClub] retain];
			}
			cards = kCardsClubs;
			break;						
		default:
			cards = nil;
			break;
	}
	
	return cards;
}



- (id)init {
	if (self = [super init]) {
		cardsToBeDealt = [[NSMutableArray alloc] init];
		cardsDealt = [[NSMutableArray alloc] init];
		cardsDead = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[cardsToBeDealt release];
	[cardsDealt release];
	[cardsDead release];
    [super dealloc];
}

- (void)clearArrays {
	[cardsToBeDealt removeAllObjects];
	[cardsDealt removeAllObjects];
	[cardsDead removeAllObjects];
}

- (void)shuffleUpAndDeal: (enum HandGame)handGame {
	// clear out all three mutable arrays
	[cardsToBeDealt removeAllObjects];
	[cardsDealt removeAllObjects];
	[cardsDead removeAllObjects];
	
	// cardsDead <- full 52-card deck
	[cardsDead addObjectsFromArray:[Deck getCardsOfSuit:kSuitSpade]];
	[cardsDead addObjectsFromArray:[Deck getCardsOfSuit:kSuitHeart]];
	[cardsDead addObjectsFromArray:[Deck getCardsOfSuit:kSuitDiamond]];
	[cardsDead addObjectsFromArray:[Deck getCardsOfSuit:kSuitClub]];
	
	// reseed RNG
	srandomdev();
	
	// deal all cards
	NSInteger totalCardsToBeDealt = [Hand calcTotalCardsToBeDealt:handGame]; 	
	do {
		int cardsDeadCount = [cardsDead count];
		int nextCardIndex = random() % cardsDeadCount;
		Card *nextCard = [cardsDead objectAtIndex:nextCardIndex];
		
		if (![cardsToBeDealt containsObject:nextCard]) {
			[cardsToBeDealt addObject:nextCard];
			[cardsDead removeObjectAtIndex:nextCardIndex];
		}
	} while ([cardsToBeDealt count] < totalCardsToBeDealt);	
	
	/*[cardsToBeDealt removeAllObjects];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"As"] retain] atIndex:0];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"2s"] retain] atIndex:1];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"Ah"] retain] atIndex:2];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"2h"] retain] atIndex:3];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"2d"] retain] atIndex:4];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"2c"] retain] atIndex:5];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"3s"] retain] atIndex:6];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"3h"] retain] atIndex:7];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"3d"] retain] atIndex:8];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"3c"] retain] atIndex:9];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"4s"] retain] atIndex:10];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"4h"] retain] atIndex:11];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"4d"] retain] atIndex:12];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"4c"] retain] atIndex:13];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"5s"] retain] atIndex:14];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"5h"] retain] atIndex:15];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"5d"] retain] atIndex:16];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"5c"] retain] atIndex:17];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"6s"] retain] atIndex:18];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"6h"] retain] atIndex:19];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"6d"] retain] atIndex:20];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"Ad"] retain] atIndex:21];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"Ac"] retain] atIndex:22];*/

	
	
	/*[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"5s"] retain] atIndex:5];
	[cardsToBeDealt insertObject:[[[Card alloc] initWithCode:@"5d"] retain] atIndex:7];
	[cardsToBeDealt removeLastObject];
	[cardsToBeDealt removeLastObject];*/
}

- (Card *)dealOneCard {
	Card *nextCard = nil;
	
	if ([cardsToBeDealt count] > 0) {
		nextCard = [cardsToBeDealt objectAtIndex:0];
		[cardsDealt insertObject:nextCard atIndex:0];
		[cardsToBeDealt removeObjectAtIndex:0];
	}
	
	//NSLog(@"card dealt: %@", [nextCard toString]);
	
	return nextCard;
}

- (void)undealOneCard:(Card*)card {
	[cardsToBeDealt insertObject:card atIndex:0];
	[cardsDealt removeObjectAtIndex:0];
}


- (NSInteger)getNumOfCards {
	return [cardsToBeDealt count];
}

- (Card*)getCardAtIndex: (NSInteger)index {
	return [cardsToBeDealt objectAtIndex:index];
}		

- (void)addCard: (Card*)card {
	[cardsToBeDealt addObject:card];
}


@end
