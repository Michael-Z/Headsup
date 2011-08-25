//
//  MadeHand.h
//  Headsup
//
//  Created by Haolan Qin on 3/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface MadeHand : NSObject {
	enum LoHandType loHandType;
	enum HandType handType;
	enum TrueHandType type;
	BOOL fd, oesd, dgsd, gssd, tocd;
	NSInteger outs;
	NSMutableArray *cards;
	
	// optimized hand calculation and comparison
	enum Rank quad, quadKicker;
	enum Rank boatTrip, boatPair;
	enum Rank trip, tripKickerHi, tripKickerLo;
	enum Rank twoPairHi, twoPairLo, twoPairKicker;
	enum Rank pair, pairKickerHi, pairKickerMid, pairKickerLo;
	enum Rank straightHi; // shared by straight and straight flush
	int *sortedCards; // shared by flush and high card. 5 elements sorted in ascending order.
}

@property (nonatomic) enum LoHandType loHandType;
@property (nonatomic) enum HandType handType;
@property (nonatomic) enum TrueHandType type;
@property (nonatomic) BOOL fd;
@property (nonatomic) BOOL oesd;
@property (nonatomic) BOOL dgsd;
@property (nonatomic) BOOL gssd;
@property (nonatomic) BOOL tocd;
@property (nonatomic) NSInteger outs;
@property (nonatomic, retain) NSMutableArray *cards;

@property (nonatomic) enum Rank quad;
@property (nonatomic) enum Rank quadKicker;
@property (nonatomic) enum Rank boatTrip;
@property (nonatomic) enum Rank boatPair;
@property (nonatomic) enum Rank trip;
@property (nonatomic) enum Rank tripKickerHi;
@property (nonatomic) enum Rank tripKickerLo;
@property (nonatomic) enum Rank twoPairHi;
@property (nonatomic) enum Rank twoPairLo;
@property (nonatomic) enum Rank twoPairKicker;
@property (nonatomic) enum Rank pair;
@property (nonatomic) enum Rank pairKickerHi;
@property (nonatomic) enum Rank pairKickerMid;
@property (nonatomic) enum Rank pairKickerLo;
@property (nonatomic) enum Rank straightHi;
@property (nonatomic) int *sortedCards;


- (NSString*) handDescription;
- (NSString*) detailedHandDescription;

@end
