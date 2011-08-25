//
//  NoLimitHoldemVillainCS.h
//  Headsup
//
//  Created by Haolan Qin on 9/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "GameModeView.h"
#import "NoLimitHoldemVillain.h"

@interface NoLimitHoldemVillainCS : NSObject <NoLimitHoldemVillain> {
	GameModeView *gameModeView;
	
	Deck *deck;
	
	NSInteger antiBluffHand;
	enum Street antiBluffStreet;
		
	NSTimer *timer;
}

@end
