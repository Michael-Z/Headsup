//
//  HoldemHand.h
//  Headsup
//
//  Created by Haolan Qin on 1/27/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "Constants.h"

@class Card;

@interface HoldemHand : NSObject {
	BOOL isHeroDealer;
	BOOL isVillainExposed;
	NSInteger handCount;
	NSInteger smallBlind, bigBlind;
	NSInteger smallBlindPosted, bigBlindPosted;
	// stack size after posting the blind
	NSInteger heroStack, villainStack;
	Card *heroCard0, *heroCard1, *villainCard0, *villainCard1;
	Card *communityCard0, *communityCard1, *communityCard2, *communityCard3, *communityCard4;
	NSMutableArray *arrActions;
}

@property (nonatomic) BOOL isHeroDealer;
@property (nonatomic) BOOL isVillainExposed;

@property (nonatomic) NSInteger handCount;
@property (nonatomic) NSInteger smallBlind;
@property (nonatomic) NSInteger bigBlind;
@property (nonatomic) NSInteger smallBlindPosted;
@property (nonatomic) NSInteger bigBlindPosted;
@property (nonatomic) NSInteger heroStack;
@property (nonatomic) NSInteger villainStack;

@property (nonatomic, retain) Card *heroCard0;
@property (nonatomic, retain) Card *heroCard1;
@property (nonatomic, retain) Card *villainCard0;
@property (nonatomic, retain) Card *villainCard1;
@property (nonatomic, retain) Card *communityCard0;
@property (nonatomic, retain) Card *communityCard1;
@property (nonatomic, retain) Card *communityCard2;
@property (nonatomic, retain) Card *communityCard3;
@property (nonatomic, retain) Card *communityCard4;
@property (nonatomic, retain) NSMutableArray *arrActions;

@end
