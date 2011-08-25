//
//  Card.m
//  MoveMe
//
//  Created by Haolan Qin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Card.h"
#import "Constants.h"


@implementation Card

@synthesize suit;
@synthesize rank;

- (id)initWithSuit:(enum Suit)aSuit Rank:(enum Rank)aRank {
	if (self = [super init]) {
		[self setSuit:aSuit Rank:aRank];
	}
	
	return self;
}

- (id)initWithCode:(NSString*)code {
	enum Suit aSuit;
	enum Rank aRank;
	
	NSInteger rankCode = [code characterAtIndex:0];
	if (rankCode == 65)
		aRank = kRankAce;
	else if (rankCode == 75)
		aRank = kRankKing;
	else if (rankCode == 81)
		aRank = kRankQueen;
	else if (rankCode == 74)
		aRank = kRankJack;
	else if (rankCode == 84)
		aRank = kRankTen;
	else if (rankCode == 57)
		aRank = kRankNine;
	else if (rankCode == 56)
		aRank = kRankEight;
	else if (rankCode == 55)
		aRank = kRankSeven;
	else if (rankCode == 54)
		aRank = kRankSix;
	else if (rankCode == 53)
		aRank = kRankFive;
	else if (rankCode == 52)
		aRank = kRankFour;
	else if (rankCode == 51)
		aRank = kRankThree;
	else //if (rankCode == 50)
		aRank = kRankTwo;		
	
	NSInteger suitCode = [code characterAtIndex:1];
	if (suitCode == 115)
		aSuit = kSuitSpade;
	else if (suitCode == 104)
		aSuit = kSuitHeart;
	else if (suitCode == 100)
		aSuit = kSuitDiamond;
	else //if (suitCode == 99)
		aSuit = kSuitClub;		
	
	return [self initWithSuit:aSuit Rank:aRank];
}

-(id)initWithNumber:(NSInteger)number {
	enum Suit aSuit = number / 13;
	enum Rank aRank = number % 13 + kRankTwo;
	
	return [self initWithSuit:aSuit Rank:aRank];
}

- (void)setSuit:(enum Suit)aSuit Rank:(enum Rank)aRank {
	suit = aSuit;
	rank = aRank;
}

-(NSComparisonResult)compare:(Card*)aCard {
	if (rank == aCard.rank)
		return NSOrderedSame;
	else if (rank < aCard.rank)
		return NSOrderedAscending;
	else
		return NSOrderedDescending;
}

-(void) goLo {
	if (rank == kRankAce)
		rank = kRankAceLo;
}

-(void) goHi {
	if (rank == kRankAceLo)
		rank = kRankAce;
}

+ (NSString *)getSuitString: (enum Suit)aSuit {
	NSString *suitString = nil;
	
	switch (aSuit) {
		case kSuitSpade:
			suitString = @"s";
			break;
		case kSuitHeart:
			suitString = @"h";
			break;
		case kSuitDiamond:
			suitString = @"d";
			break;
		case kSuitClub:
			suitString = @"c";
			break;
		default:
			suitString = nil;
			break;
	}
	
	return suitString;
}

+ (NSString *)getFourColorDeckSuitString: (enum Suit)aSuit {
	NSString *suitString = nil;
	
	switch (aSuit) {
		case kSuitSpade:
			suitString = @"s";
			break;
		case kSuitHeart:
			suitString = @"h";
			break;
		case kSuitDiamond:
			suitString = @"db";
			break;
		case kSuitClub:
			suitString = @"cg";
			break;
		default:
			suitString = nil;
			break;
	}
	
	return suitString;
}


+ (NSString *)getRankString: (enum Rank)aRank {
	NSString *rankString = nil;
	
	switch (aRank) {
		case kRankAce:
			rankString = @"A";
			break;			
		case kRankKing:
			rankString = @"K";
			break;
		case kRankQueen:
			rankString = @"Q";
			break;
		case kRankJack:
			rankString = @"J";
			break;
		case kRankTen:
			rankString = @"T";
			break;
		case kRankNine:
			rankString = @"9";
			break;
		case kRankEight:
			rankString = @"8";
			break;
		case kRankSeven:
			rankString = @"7";
			break;
		case kRankSix:
			rankString = @"6";
			break;
		case kRankFive:
			rankString = @"5";
			break;
		case kRankFour:
			rankString = @"4";
			break;
		case kRankThree:
			rankString = @"3";
			break;
		case kRankTwo:
			rankString = @"2";
			break;
		default:
			rankString = nil;
			break;
	}
	
	return rankString;
}

-(NSInteger)toNumber {
	return (rank - kRankTwo) + suit * 13;
}

- (NSString *)toString {
	NSString *suitString = [Card getSuitString:suit];
	NSString *rankString = [Card getRankString:rank];
	
	NSString *cardString = [rankString stringByAppendingString:suitString];
	
	//[suitString release];
	//[rankString release];
	
	return cardString;
}

-(NSString*)toFourColorDeckString  {
	NSString *suitString = [Card getFourColorDeckSuitString:suit];
	NSString *rankString = [Card getRankString:rank];
	
	NSString *cardString = [rankString stringByAppendingString:suitString];
	
	//[suitString release];
	//[rankString release];
	
	return cardString;
}

-(NSString*)toRankString {
	NSString *rankString = nil;
	
	switch (rank) {
		case kRankAce:
			rankString = @"Ace";
			break;			
		case kRankKing:
			rankString = @"King";
			break;
		case kRankQueen:
			rankString = @"Queen";
			break;
		case kRankJack:
			rankString = @"Jack";
			break;
		case kRankTen:
			rankString = @"Ten";
			break;
		case kRankNine:
			rankString = @"Nine";
			break;
		case kRankEight:
			rankString = @"Eight";
			break;
		case kRankSeven:
			rankString = @"Seven";
			break;
		case kRankSix:
			rankString = @"Six";
			break;
		case kRankFive:
			rankString = @"Five";
			break;
		case kRankFour:
			rankString = @"Four";
			break;
		case kRankThree:
			rankString = @"Trey";
			break;
		case kRankTwo:
			rankString = @"Deuce";
			break;
		default:
			rankString = nil;
			break;
	}
	
	return rankString;	
}

-(NSString*)toRankStringPlural {
	NSString *rankString = nil;
	
	switch (rank) {
		case kRankAce:
		case kRankKing:
		case kRankQueen:
		case kRankJack:
		case kRankTen:
		case kRankNine:
		case kRankEight:
		case kRankSeven:
		case kRankFive:
		case kRankFour:
		case kRankThree:
		case kRankTwo:
			rankString = [NSString stringWithFormat:@"%@s", [self toRankString]];
			break;
		case kRankSix:
			rankString = @"Sixes";
			break;
			
		default:
			rankString = nil;
			break;			
	}			
	
	return rankString;	
}

- (NSInteger) getBlackjackValue {
	NSInteger retval = 0;
	
	switch (rank) {
		case kRankAce:
			retval = 1;
			break;
		case kRankKing:
		case kRankQueen:
		case kRankJack:
		case kRankTen:
			retval = 10;
			break;
		case kRankNine:
			retval = 9;
			break;
		case kRankEight:
			retval = 8;
			break;
		case kRankSeven:
			retval = 7;
			break;
		case kRankSix:
			retval = 6;
			break;			
		case kRankFive:
			retval = 5;
			break;
		case kRankFour:
			retval = 4;
			break;
		case kRankThree:
			retval = 3;
			break;
		case kRankTwo:
			retval = 2;
			break;			
	}			
		
	return retval;
}

- (NSString *) getImageName {
	NSString *suitString = [Card getFourColorDeckSuitString:suit];
	NSString *rankString = [Card getRankString:rank];
	
	NSString *imageName = [[rankString stringByAppendingString:suitString] stringByAppendingString:@".bmp"];
	
	//[suitString release];
	//[rankString release];
	
	return imageName;
}

- (NSUInteger)hash {
	return rank + suit * 100;
}

- (BOOL)isEqual:(id)anObject {
	BOOL retval;
	
	if ([anObject isKindOfClass:[Card class]]) {
		Card *anotherCard = anObject;
		
		retval = (anotherCard.suit == suit && anotherCard.rank == rank);
	} else {
		retval = NO;
	}
	
	return retval;
}

@end
