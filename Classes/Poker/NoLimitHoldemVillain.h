//
//  NoLimitHoldemVillain.h
//  Headsup
//
//  Created by Haolan Qin on 9/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol NoLimitHoldemVillain

-(id)initWithGameModeView:(GameModeView*)view;

- (void) heroFolded;
- (void) heroChecked:(BOOL)isHandOver;
- (void) heroCalled:(BOOL)isHandOver;
- (void) heroBet;
- (void) heroRaised;

- (void) dealNewHandAsDealer;
- (void) villainFirstToAct;

- (void) killAllActiveTimers;

@end
