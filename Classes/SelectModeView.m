//
//  SelectModeView.m
//  Headsup
//
//  Created by Haolan Qin on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SelectModeView.h"
#import "AppController.h"
#import "ModeFSM.h"

#define HOLDEM_BUY_IN 150
#define OMAHA_BUY_IN 200



@implementation SelectModeView

@synthesize toolModeButton;
@synthesize gameModeButton;
@synthesize waitIndicator;
@synthesize modeFSM;
//@synthesize dealer;

- (void) setUpStuff {
	modeFSM = [[ModeFSM alloc] init];
}

- (id)initWithCoder:(NSCoder *)coder {	
	if (self = [super initWithCoder:coder]) {
		[self setUpStuff];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpStuff];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	[modeFSM release];
    [super dealloc];
}

- (void) startWaiting {
	waitIndicator.hidden = NO;
	[waitIndicator startAnimating];
	
	[toolModeButton setEnabled:NO];
	[gameModeButton setEnabled:NO];	
}

- (void) stopWaiting {
	waitIndicator.hidden = YES;
	[waitIndicator stopAnimating];
	
	[toolModeButton setEnabled:YES];
	[gameModeButton setEnabled:YES];
}

- (void) stateChanged {
	[self stopWaiting];
	
	if (modeFSM.state == kModeStateToolModeStarted) {		
		[self removeFromSuperview];
		
		if (BUILD == HU_HOLDEM)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentToolModeViewAtHand:0];
		else if (BUILD == HU_OMAHA)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentOmahaToolModeViewAtHand:0];
		else if (BUILD == HU_STUD)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentStudToolModeView];			
		else if (BUILD == HU_DRAW)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentDrawToolModeView];
		else if (BUILD == HU_MIXED)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentToolModeViewAtHand:0];
		
	} else if (modeFSM.state == kModeStateGameModeStarted) {
		[self removeFromSuperview];
		
		if (BUILD == HU_HOLDEM)
			[(AppController*)[[UIApplication sharedApplication] delegate] 
			 presentHoldemGameModeViewAtHand:0 
			 heroStack:HOLDEM_BUY_IN 
			 villainStack:HOLDEM_BUY_IN 
			 smallBlind:1
			 bigBlind:2
			 heroApplicationData:nil 
			 villainApplicationData:nil
			 gameMode:kDualPhoneMode];		
		else if (BUILD == HU_OMAHA)
			; 
			//[(AppController*)[[UIApplication sharedApplication] delegate] presentOmahaGameModeViewAtHand:0 heroStack:OMAHA_BUY_IN villainStack:OMAHA_BUY_IN];
		else if (BUILD == HU_STUD)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentStudGameModeView];
		else if (BUILD == HU_DRAW)
			[(AppController*)[[UIApplication sharedApplication] delegate] presentDrawGameModeView];
		else if (BUILD == HU_MIXED)
			[(AppController*)[[UIApplication sharedApplication] delegate] 
			 presentHoldemGameModeViewAtHand:0 
			 heroStack:HOLDEM_BUY_IN 
			 villainStack:HOLDEM_BUY_IN 
			 smallBlind:1
			 bigBlind:2
			 heroApplicationData:nil 
			 villainApplicationData:nil
			 gameMode:kDualPhoneMode];

	} else if (modeFSM.state == kModeStateCancelled) {
		modeFSM.state = kModeStateReady;
	}
}

- (IBAction) toolModeButtonPressed:(id)sender {
	[self startWaiting];
	
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kModeEventSendToolMode];
	[modeFSM input:kModeEventSendToolMode];
	
	if (modeFSM.state == kModeStateToolModeStarted ||
		modeFSM.state == kModeStateGameModeStarted ||
		modeFSM.state == kModeStateCancelled) {
		[self stateChanged];
	}		
}

- (IBAction) gameModeButtonPressed:(id)sender {
	[self startWaiting];
	
	[(AppController*)[[UIApplication sharedApplication] delegate] send:kModeEventSendGameMode];
	[modeFSM input:kModeEventSendGameMode];
	
	if (modeFSM.state == kModeStateToolModeStarted ||
		modeFSM.state == kModeStateGameModeStarted ||
		modeFSM.state == kModeStateCancelled) {
		[self stateChanged];
	}			
}

- (void) receiveMessage:(uint8_t)message {
	if (message == kModeEventSendToolMode)
		[modeFSM input:kModeEventReceiveToolMode];
	else if (message == kModeEventSendGameMode)
		[modeFSM input:kModeEventReceiveGameMode];
	
	if (modeFSM.state == kModeStateToolModeStarted ||
		modeFSM.state == kModeStateGameModeStarted ||
		modeFSM.state == kModeStateCancelled) {
		[self stateChanged];
	}				
}

- (void) willDisplay {
	modeFSM.state = kModeStateReady;
}

@end
