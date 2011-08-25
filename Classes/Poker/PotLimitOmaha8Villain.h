//
//  PotLimitOmaha8Villain.h
//  Headsup
//
//  Created by Haolan Qin on 11/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "OmahaGameModeView.h"
#import "PotLimitOmahaVillain.h"

@interface PotLimitOmaha8Villain : NSObject <PotLimitOmahaVillain> {
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
