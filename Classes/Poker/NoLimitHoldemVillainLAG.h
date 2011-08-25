//
//  NoLimitHoldemVillainLAG.h
//  Headsup
//
//  Created by Haolan Qin on 3/07/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "GameModeView.h"
#import "NoLimitHoldemVillain.h"

@interface NoLimitHoldemVillainLAG : NSObject <NoLimitHoldemVillain> {
	GameModeView *gameModeView;
	
	Deck *deck;
	
	NSInteger antiBluffHand;
	enum Street antiBluffStreet;
		
	NSTimer *timer;
}

@end
