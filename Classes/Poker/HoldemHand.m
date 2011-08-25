//
//  HoldemHand.m
//  Headsup
//
//  Created by Haolan Qin on 1/27/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HoldemHand.h"


@implementation HoldemHand
		
@synthesize isHeroDealer;
@synthesize isVillainExposed;
@synthesize handCount;
@synthesize smallBlind;
@synthesize bigBlind;
@synthesize smallBlindPosted;
@synthesize bigBlindPosted;
@synthesize heroStack;
@synthesize villainStack;
@synthesize heroCard0;
@synthesize heroCard1;
@synthesize villainCard0;
@synthesize villainCard1;
@synthesize communityCard0;
@synthesize communityCard1;
@synthesize communityCard2;
@synthesize communityCard3;
@synthesize communityCard4;
@synthesize arrActions;

-(id)init {
	if (self = [super init]) {
		arrActions = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	[arrActions release];
	
	[super dealloc];
}

@end
