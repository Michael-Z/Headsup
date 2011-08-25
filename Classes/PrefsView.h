//
//  HelpHoldemView.h
//  Headsup
//
//  Created by Haolan Qin on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppController.h"


@interface PrefsView : UIView {
	UINavigationController *navController;
	
	IBOutlet UITextField *heroStackText, *villainStackText, *smallBlindText, *bigBlindText;
	IBOutlet UISwitch *toolModeSwitch;
	IBOutlet UISwitch *fourColorDeckSwitch;
	IBOutlet UISwitch *heroHoleCardsFaceUpSwitch;
	IBOutlet UISwitch *soundSwitch;
	IBOutlet UISwitch *advancedAISwitch;	
	IBOutlet UISwitch *omahaSwitch;
	IBOutlet UIButton *updateButton, *cancelButton;
	IBOutlet UIBarButtonItem *doneToolButton;
}

@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) IBOutlet UITextField *heroStackText;
@property (nonatomic, retain) IBOutlet UITextField *villainStackText;
@property (nonatomic, retain) IBOutlet UITextField *smallBlindText;
@property (nonatomic, retain) IBOutlet UITextField *bigBlindText;
@property (nonatomic, retain) IBOutlet UISwitch *toolModeSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *fourColorDeckSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *heroHoleCardsFaceUpSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *advancedAISwitch;
@property (nonatomic, retain) IBOutlet UISwitch *omahaSwitch;
@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneToolButton;

- (IBAction) doneToolButtonPressed:(id)sender;

- (IBAction) updateButtonPressed:(id)sender;
- (IBAction) cancelButtonPressed:(id)sender;

- (IBAction) toolModeSwitchValueChanged:(id)sender;
- (IBAction) fourColorDeckSwitchValueChanged:(id)sender;
- (IBAction) heroHoleCardsFaceUpSwitchValueChanged:(id)sender;
- (IBAction) soundSwitchValueChanged:(id)sender;
- (IBAction) advancedAISwitchValueChanged:(id)sender;
- (IBAction) omahaSwitchValueChanged:(id)sender;

- (void) willDisplay;

@end
