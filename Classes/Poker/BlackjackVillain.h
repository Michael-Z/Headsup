//
//  BlackjackVillain.h
//  Headsup
//
//  Created by Haolan Qin on 11/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BlackjackHeadsupModeView.h"

@interface BlackjackVillain : NSObject {
	NSTimer *timer;
	BlackjackHeadsupModeView *headsupModeView;
	NSMutableArray *strategyCard;	
}

-(id)initWithGameModeView:(BlackjackHeadsupModeView*)view;

- (void) firstToBet;
- (void) secondToBet;
- (void) firstToAct;
- (void) secondToAct;

- (void) killAllActiveTimers;

@end
