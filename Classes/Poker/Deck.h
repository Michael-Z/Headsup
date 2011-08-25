//
//  Deck.h
//  MoveMe
//
//  Created by Haolan Qin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Deck : NSObject {
	// note that this array only contains cards that will have a chance to be dealt. 
	// e.g. if it's a headsup hold'em game, it will only contain 9 cards; if it's
	// a headsup omaha game, it will only contain 13 cards.
	// as a poker hand progresses, this mutable array will get smaller, i.e. dealt
	// cards will be removed from this array.
	NSMutableArray *cardsToBeDealt;
	
	// cards that have already been dealt. for auditing purpose only.
	NSMutableArray *cardsDealt;
	
	// cards that will never be dealt. when all cards are dealt at the beginning of
	// a hand, this array is the original deck minus cardsToBeDealt. this array remains
	// constant throughout a poker hand. for auditing purpose only.
	NSMutableArray *cardsDead;
}

+ (NSArray *)getCardsOfSuit:(enum Suit)suit;

- (id)init;

- (void)clearArrays;

// shuffle the deck and deal all cards to cardsToBeDealt
- (void)shuffleUpAndDeal:(enum HandGame)handGame;

// get the first card in cardsToBeDealt
- (Card *)dealOneCard;

// put the last dealt card back into (the top of) the deck
- (void)undealOneCard:(Card*)card;

// get number of cards in cardsToBeDealt
- (NSInteger)getNumOfCards;

// get the card at index in cardsToBeDealt
- (Card*)getCardAtIndex: (NSInteger)index;

- (void)addCard: (Card*)card;

@end
