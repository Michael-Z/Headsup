//
//  BlackjackVillain.m
//  Headsup
//
//  Created by Haolan Qin on 11/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BlackjackVillain.h"
#import "CardView.h"
#import "Card.h"

@implementation BlackjackVillain

-(id)initWithGameModeView:(BlackjackHeadsupModeView*)view {
	if (self = [super init]) {
		headsupModeView = view;
		
		strategyCard = [[NSArray arrayWithObjects:
						 HIT, HIT, HIT, HIT, HIT, HIT, HIT, HIT, HIT, HIT,
						 HIT, HIT, HIT, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
						 DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
						 DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT,
						 DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE,
						 HIT, HIT, STAND, STAND, STAND, HIT, HIT, HIT, HIT, HIT,
						 STAND, STAND, STAND, STAND, STAND, HIT, HIT, HIT, HIT, HIT,
						 STAND, STAND, STAND, STAND, STAND, HIT, HIT, HIT, HIT, HIT,
						 STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND,
						 STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND,
						 STAND, STAND, STAND, STAND, DOUBLE, STAND, STAND, STAND, STAND, STAND,
						 STAND, DOUBLE, DOUBLE, DOUBLE, DOUBLE, STAND, STAND, HIT, HIT, STAND,
						 DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
						 HIT, HIT, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
						 HIT, HIT, DOUBLE, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
						 SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, 
						 STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND, STAND,
						 SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, STAND, SPLIT, SPLIT, SPLIT, SPLIT, 
						 SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, 
						 SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, STAND, HIT, 
						 SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, HIT, HIT, HIT, 
						 DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, DOUBLE, HIT, HIT,
						 HIT, HIT, HIT, DOUBLE, DOUBLE, HIT, HIT, HIT, HIT, HIT,
						 HIT, HIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, HIT, HIT, 
						 HIT, SPLIT, SPLIT, SPLIT, SPLIT, SPLIT, HIT, HIT, HIT, HIT,
						 nil
						 ] retain];		
	}
	
	return self;
}

- (void) dealloc {
	[strategyCard release];
	
	[super dealloc];
}

- (NSInteger) delay {
	// reseed RNG
	//srandomdev();
	
	// 3 5
	//return (2 + random() % 4);
	return 2;
}

- (void) villainFirstToBetTimerMethod {
	timer = nil;
	
	[headsupModeView villainStopWaiting];
	
	NSInteger heroStack = [headsupModeView heroStack];
	NSInteger villainStack = [headsupModeView villainStack];
	
	NSInteger minBet = [headsupModeView getMinBet];
	NSInteger villainMaxBet = villainStack / minBet * minBet;
	if ((heroStack - villainStack) <= minBet) {
		NSInteger cap = villainStack / minBet / 10;
		srandomdev();
		NSInteger randNum = random() % cap;
		
		[headsupModeView villainBet:(randNum+1)*minBet];
	} else {
		NSInteger idealBet = heroStack - villainStack;
		NSInteger villainBet = idealBet / minBet * minBet;
		
		if (villainBet > villainMaxBet)
			villainBet = villainMaxBet;
		
		[headsupModeView villainBet:villainBet];
	}
}

- (void) firstToBet {
	[headsupModeView villainStartWaiting];
	timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(villainFirstToBetTimerMethod) userInfo:nil repeats:NO];
}

- (void) villainSecondToBetTimerMethod {
	timer = nil;
	
	[headsupModeView villainStopWaiting];
	
	NSInteger heroBet = [headsupModeView getCurrentHeroBet];
	NSInteger heroStack = [headsupModeView heroStack];
	NSInteger villainStack = [headsupModeView villainStack];
	
	NSInteger minBet = [headsupModeView getMinBet];
	NSInteger villainMaxBet = villainStack / minBet * minBet;
	if ((heroStack + heroBet - villainStack) <= minBet) {
		NSInteger idealBet = heroStack + heroBet*2 + minBet - villainStack;
		NSInteger villainBet = idealBet / minBet * minBet;
		
		if (villainBet < minBet)
			villainBet = minBet;
		
		if (villainBet > villainMaxBet)
			villainBet = villainMaxBet;

		[headsupModeView villainBet:villainBet];
	} else {
		NSInteger idealBet = heroStack + heroBet*2 + minBet - villainStack;
		NSInteger villainBet = idealBet / minBet * minBet;
		
		if (villainBet > villainMaxBet)
			villainBet = villainMaxBet;
		
		[headsupModeView villainBet:villainBet];
	}
}

- (void) secondToBet {
	[headsupModeView villainStartWaiting];
	timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(villainSecondToBetTimerMethod) userInfo:nil repeats:NO];
}

- (void) villainToActTimerMethod {
	timer = nil;
	
	[headsupModeView villainStopWaiting];
	
	if ([headsupModeView calcVillainHandSoftValue] == 21) {
		[headsupModeView villainPressStand];
		return;
	}
	
	// dealer index (column index) 0-9 on the strategy card
	NSInteger dealerIndex = 0;	
	if (headsupModeView.dealerCard0View.card.rank == kRankAce)
		dealerIndex = 9;
	else
		dealerIndex = [headsupModeView.dealerCard0View.card getBlackjackValue] - 2;
	
	// villain index (row index) 0-24 on the strategy card
	NSInteger villainIndex = 0;
	
	NSInteger villainCardsNum = [headsupModeView getVillainCardsNum];
	NSInteger villainHandValue = [headsupModeView getVillainHandValue];
	if (villainCardsNum == 2 && 
		[headsupModeView.villainCard0View.card getBlackjackValue] == 
		[headsupModeView.villainCard1View.card getBlackjackValue]) {
		// splitting hands
		if (villainHandValue == 2) // AA
			villainIndex = 15;
		else
			villainIndex = 26 - villainHandValue / 2;
	} else if ([headsupModeView calcVillainHandSoftValue] - villainHandValue == 10) {
		// soft hands
		if (villainHandValue == 10)
			villainIndex = 9;
		else if (villainHandValue == 9)
			villainIndex = 10;
		else if (villainHandValue == 8)
			villainIndex = 11;
		else if (villainHandValue == 7)
			villainIndex = 12;
		else if (villainHandValue == 6 || villainHandValue == 5)
			villainIndex = 13;
		else // 4 || 3
			villainIndex = 14;
	} else {
		// hard non-splitting hands
		if (villainHandValue <= 7)
			villainIndex = 0;
		else if (villainHandValue == 8)
			villainIndex = 1;
		else if (villainHandValue == 9)
			villainIndex = 2;
		else if (villainHandValue == 10)
			villainIndex = 3;
		else if (villainHandValue == 11)
			villainIndex = 4;
		else if (villainHandValue == 12)
			villainIndex = 5;
		else if (villainHandValue == 13 || villainHandValue == 14 || villainHandValue == 15)
			villainIndex = 6;
		else if (villainHandValue == 16)
			villainIndex = 7;
		else // >= 17
			villainIndex = 8;
	}
	
	// look up hint on the strategy card based on dealer index and villain index
	NSString* bestMove = (NSString*)[strategyCard objectAtIndex:villainIndex * 10 + dealerIndex];
	
	// villain is only allowed to double down with a 2-card hand.
	if ([bestMove isEqualToString:DOUBLE] && (villainCardsNum != 2)) {
		bestMove = HIT;
	}
	
	// villain is only allowed to split once.
	if ([bestMove isEqualToString:SPLIT] && [headsupModeView hasVillainAlreadySplit]) {
		bestMove = STAND;
	}	
	
	// can't double or split if not enough chips are left
	if (([bestMove isEqualToString:SPLIT] || [bestMove isEqualToString:DOUBLE]) &&
		([headsupModeView getCurrentVillainBet] > [headsupModeView villainStack])
		) {
		bestMove = STAND;
	}
	
	if ([bestMove isEqualToString:SPLIT]) {
		if ([headsupModeView getCurrentVillainBet] <= [headsupModeView villainStack]) {
			[headsupModeView villainPressSplit];
		} else {
			[headsupModeView villainPressStand];
		}
	} else if ([bestMove isEqualToString:DOUBLE]) {
		if ([headsupModeView getCurrentVillainBet] <= [headsupModeView villainStack]) {
			[headsupModeView villainPressDouble];
		} else {
			[headsupModeView villainPressStand];
		}		
	} else if ([bestMove isEqualToString:HIT]) {
		[headsupModeView villainPressHit];
	} else if ([bestMove isEqualToString:STAND]) {
		[headsupModeView villainPressStand];
	} else {
		NSLog(@"unknown move:%@", bestMove);
	}
}

- (void) firstToAct {
	[headsupModeView villainStartWaiting];
	timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(villainToActTimerMethod) userInfo:nil repeats:NO];
}

- (void) secondToAct {
	[headsupModeView villainStartWaiting];
	[headsupModeView setSecondBasesTurnToTrue];
	timer = [NSTimer scheduledTimerWithTimeInterval:[self delay] target:self selector:@selector(villainToActTimerMethod) userInfo:nil repeats:NO];
}

- (void) killAllActiveTimers {
	[headsupModeView villainStopWaiting];
	[timer invalidate];
	timer = nil;
}

@end
