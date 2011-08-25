//
//  SelectModeView.h
//  Headsup
//
//  Created by Haolan Qin on 3/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModeFSM;


@interface SelectModeView : UIView {
	IBOutlet UIButton *toolModeButton, *gameModeButton;
	IBOutlet UIActivityIndicatorView *waitIndicator;
	
	ModeFSM *modeFSM;
	
	//BOOL dealer;
}

@property (nonatomic, retain) IBOutlet UIButton *toolModeButton;
@property (nonatomic, retain) IBOutlet UIButton *gameModeButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *waitIndicator;

@property (nonatomic, retain) ModeFSM *modeFSM;

//@property (nonatomic) BOOL dealer;

- (IBAction) toolModeButtonPressed:(id)sender;
- (IBAction) gameModeButtonPressed:(id)sender;

- (void) receiveMessage:(uint8_t)message;

- (void) willDisplay;

@end
