//
//  HandFSM.m
//  Headsup
//
//  Created by Haolan Qin on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HandFSM.h"

@implementation HandFSM

@synthesize state;

- (id) init {
	if (self = [super init]) {
		self.state = kStateReady;
	}
	
	return self;
}

-(void) input: (enum Event) event {
	if (state == kStateCancelled) {
		if (event == kEventGetReady)
			state = kStateReady;
	} else if (state == kStateNewReqSent) {
		if (event == kEventReceiveNewReq)
			state = kStateNewStarted;
		else if (event == kEventReceiveNextReq ||
				 event == kEventReceiveAllInReq)
			state = kStateCancelled;
	} else if (state == kStateNewReqReceived) {
		if (event == kEventSendNewReq)
			state = kStateNewStarted;
		else if (event == kEventSendNextReq ||
				 event == kEventSendAllInReq)
			state = kStateCancelled;
	} else if (state == kStateNewStarted) {
		if (event == kEventSendCards)
			state = kStateNewHandReadyToBeDealt;
		else if (event == kEventReceiveCards)
			state = kStateNewHandReadyToBeDealt;
	} else if (state == kStateReady) {
		if (event == kEventSendNewReq)
			state = kStateNewReqSent;
		else if (event == kEventReceiveNewReq)
			state = kStateNewReqReceived;
		else if (event == kEventSendNextReq)
			state = kStateNextReqSent;
		else if (event == kEventReceiveNextReq)
			state = kStateNextReqReceived;
		else if (event == kEventSendAllInReq)
			state = kStateAllInReqSent;
		else if (event == kEventReceiveAllInReq)
			state = kStateAllInReqReceived;
	}  else if (state == kStateNextReqSent) {
		if (event == kEventReceiveNextReq)
			state = kStateNextStreetReadyToBeDealt;
		else if (event == kEventReceiveNewReq ||
				 event == kEventReceiveAllInReq)
			state = kStateCancelled;
	} else if (state == kStateNextReqReceived) {
		if (event == kEventSendNextReq)
			state = kStateNextStreetReadyToBeDealt;
		else if (event == kEventSendNewReq ||
				 event == kEventSendAllInReq)
			state = kStateCancelled;
	}  else if (state == kStateAllInReqSent) {
		if (event == kEventReceiveAllInReq)
			state = kStateAllInReadyToBeDealt;
		else if (event == kEventReceiveNewReq ||
				 event == kEventReceiveNextReq)
			state = kStateCancelled;
	} else if (state == kStateAllInReqReceived) {
		if (event == kEventSendAllInReq)
			state = kStateAllInReadyToBeDealt;
		else if (event == kEventSendNewReq ||
				 event == kEventSendNextReq)
			state = kStateCancelled;
	} else if (state == kStateNewHandReadyToBeDealt) {
		if (event == kEventDealt)
			state = kStateReady;
	} else if (state == kStateNextStreetReadyToBeDealt) {
		if (event == kEventDealt)
			state = kStateReady;
	} else if (state == kStateAllInReadyToBeDealt) {
		if (event == kEventDealt)
			state = kStateReady;
	}
}

@end
