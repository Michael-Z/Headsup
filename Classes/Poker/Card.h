//
//  Card.h
//  MoveMe
//
//  Created by Haolan Qin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Card : NSObject {
	enum Suit suit;
	enum Rank rank;
}

@property (nonatomic) enum Suit suit;
@property (nonatomic) enum Rank rank;

-(id)initWithSuit:(enum Suit)aSuit Rank:(enum Rank)aRank;
-(id)initWithCode:(NSString*)code;
-(id)initWithNumber:(NSInteger)number;
-(void)setSuit:(enum Suit)aSuit Rank:(enum Rank)aRank;
-(NSComparisonResult)compare:(Card*)aCard;
-(void) goLo;
-(void) goHi;

-(NSInteger)toNumber;
-(NSString*)toString;
-(NSString*)toFourColorDeckString;

-(NSString*)toRankString;
-(NSString*)toRankStringPlural;

-(NSInteger)getBlackjackValue;

-(NSString*)getImageName;

// translate rank to a character
+ (NSString *)getRankString: (enum Rank)aRank;

@end
