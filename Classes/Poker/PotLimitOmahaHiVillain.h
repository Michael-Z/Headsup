//
//  Move.h
//  Headsup
//
//  Created by Haolan Qin on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "OmahaGameModeView.h"

@interface PotLimitOmahaHiVillain : NSObject {
	OmahaGameModeView *gameModeView;
	
	Deck *deck;
	
	NSInteger antiBluffHand;
	enum Street antiBluffStreet;
		
	NSTimer *timer;
}

-(id)initWithGameModeView:(OmahaGameModeView*)view;

- (void) heroFolded;
- (void) heroChecked:(BOOL)isHandOver;
- (void) heroCalled:(BOOL)isHandOver;
- (void) heroBet;
- (void) heroRaised;

- (void) dealNewHandAsDealer;
- (void) villainFirstToAct;

- (void) killAllActiveTimers;

@end
