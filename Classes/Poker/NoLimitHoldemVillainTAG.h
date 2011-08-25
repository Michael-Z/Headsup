//
//  NoLimitHoldemVillainTAG.h
//  Headsup
//
//  Created by Haolan Qin on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "GameModeView.h"
#import "NoLimitHoldemVillain.h"

@interface NoLimitHoldemVillainTAG : NSObject <NoLimitHoldemVillain> {
	GameModeView *gameModeView;
	
	Deck *deck;
	
	NSInteger antiBluffHand;
	enum Street antiBluffStreet;
		
	NSTimer *timer;
}

@end
