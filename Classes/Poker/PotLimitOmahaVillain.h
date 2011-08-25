//
//  PotLimitOmahaVillain.h
//  Headsup
//
//  Created by Haolan Qin on 11/01/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol PotLimitOmahaVillain

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
