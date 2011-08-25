//
//  Move.m
//  Headsup
//
//  Created by Haolan Qin on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Move.h"


@implementation Move

@synthesize move;
@synthesize amount;
@synthesize raiseAmount;
		
-(id)initWithMove:(enum MoveType)aMove Amount:(NSInteger)anAmount {
	if (self = [super init]) {
		self.move = aMove;
		self.amount = anAmount;
	}
	
	return self;
}
	/*
    private float adjustFloat (float number) {
        return Math.round(number * 100) * 1.0f / 100;
    }
	
    public String toString () {
        switch (m_move) {
            case CHECK:
                return "checks";
            case CALL:
                return "calls $" + adjustFloat(m_amount);
            case BET:
                return "bets $" + adjustFloat(m_amount);
            case RAISE:
                return "raises to $" + adjustFloat(m_amount);
            case FOLD:
                return "folds";
            default:
                return "ERROR";
        }
    }*/	


@end
