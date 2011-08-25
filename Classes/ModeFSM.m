//
//  HandFSM.m
//  Headsup
//
//  Created by Haolan Qin on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ModeFSM.h"

@implementation ModeFSM

@synthesize state;

- (id) init {
	if (self = [super init]) {
		self.state = kModeStateReady;
	}
	
	return self;
}

-(void) input: (enum ModeEvent) event {
	if (state == kModeStateReady) {
		if (event == kModeEventSendToolMode)
			state = kModeStateToolModeSent;
		else if (event == kModeEventReceiveToolMode)
			state = kModeStateToolModeReceived;
		else if (event == kModeEventSendGameMode)
			state = kModeStateGameModeSent;
		else if (event == kModeEventReceiveGameMode)
			state = kModeStateGameModeReceived;
	} else if (state == kModeStateCancelled) {
		if (event == kModeEventGetReady)
			state = kModeStateReady;
	} else if (state == kModeStateToolModeSent) {
		if (event == kModeEventReceiveToolMode)
			state = kModeStateToolModeStarted;
		else if (event == kModeEventReceiveGameMode)
			state = kModeStateCancelled;
	} else if (state == kModeStateToolModeReceived) {
		if (event == kModeEventSendToolMode)
			state = kModeStateToolModeStarted;
		else if (event == kModeEventSendGameMode)
			state = kModeStateCancelled;
	} else if (state == kModeStateGameModeSent) {
		if (event == kModeEventReceiveGameMode)
			state = kModeStateGameModeStarted;
		else if (event == kModeEventReceiveToolMode)
			state = kModeStateCancelled;
	} else if (state == kModeStateGameModeReceived) {
		if (event == kModeEventSendGameMode)
			state = kModeStateGameModeStarted;
		else if (event == kModeEventSendToolMode)
			state = kModeStateCancelled;
	}
}

@end
