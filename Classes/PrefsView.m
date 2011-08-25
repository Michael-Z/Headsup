//
//  HelpHoldemView.m
//  Headsup
//
//  Created by Haolan Qin on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PrefsView.h"

#import "Constants.h"
#import "Poker3GView.h"

@implementation PrefsView

@synthesize navController;

@synthesize heroStackText;
@synthesize villainStackText;
@synthesize smallBlindText;
@synthesize bigBlindText;
@synthesize toolModeSwitch;
@synthesize fourColorDeckSwitch;
@synthesize heroHoleCardsFaceUpSwitch;
@synthesize soundSwitch;
@synthesize advancedAISwitch;
@synthesize omahaSwitch;
@synthesize updateButton;
@synthesize cancelButton;
@synthesize doneToolButton;

- (void) setUpStuff {
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardDismissed) 
												 name:UIKeyboardWillHideNotification object:nil]; 	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardDisplayed) 
												 name:UIKeyboardWillShowNotification object:nil]; 		
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

- (void)dealloc {
    [super dealloc];
}

- (void) validateUserInput {
	// small blind must be between 1 and 10,000
	NSInteger smallBlind = [[smallBlindText text] integerValue];
	if (smallBlind == 0) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		smallBlind = [defaults integerForKey:KEY_NLHOLDEM_SMALL_BLIND];
		[smallBlindText setText:[NSString stringWithFormat:@"%d", smallBlind]];
	} else if (smallBlind > 10000) {
		smallBlind = 10000;
		[smallBlindText setText:[NSString stringWithFormat:@"%d", smallBlind]];
	}
	 
	// big blind must be between 2 and 3 small blinds
	NSInteger minBigBlind = 2 * smallBlind;
	NSInteger maxBigBlind = 3 * smallBlind;
	NSInteger bigBlind = [[bigBlindText text] integerValue];
	if (bigBlind < minBigBlind)
		[bigBlindText setText:[NSString stringWithFormat:@"%d", minBigBlind]];
	else if (bigBlind > maxBigBlind)
		[bigBlindText setText:[NSString stringWithFormat:@"%d", maxBigBlind]];

	bigBlind = [[bigBlindText text] integerValue];
	
	// stack size must be between 10 and 400 big blinds and times of big blinds
	NSInteger minStack = 10 * bigBlind;
	NSInteger maxStack = 400 * bigBlind;

	NSInteger heroStack = [[heroStackText text] integerValue];
	if (heroStack < minStack)
		[heroStackText setText:[NSString stringWithFormat:@"%d", minStack]];
	else if (heroStack > maxStack)
		[heroStackText setText:[NSString stringWithFormat:@"%d", maxStack]];
	else if (heroStack % bigBlind != 0)
		[heroStackText setText:[NSString stringWithFormat:@"%d", heroStack / bigBlind * bigBlind]];

	NSInteger villainStack = [[villainStackText text] integerValue];
	if (villainStack < minStack)
		[villainStackText setText:[NSString stringWithFormat:@"%d", minStack]];
	else if (heroStack > maxStack)
		[villainStackText setText:[NSString stringWithFormat:@"%d", maxStack]];
	else if (villainStack % bigBlind != 0)
		[villainStackText setText:[NSString stringWithFormat:@"%d", villainStack / bigBlind * bigBlind]];
}

// called when keyboard is dismissed.
- (void)keyboardDismissed {
	// hide keyboard related buttons
	updateButton.hidden = YES;
	cancelButton.hidden = YES;
	[updateButton setNeedsDisplay];
	[cancelButton setNeedsDisplay];

	[doneToolButton setEnabled:YES];
	
	[toolModeSwitch setEnabled:YES];
	[fourColorDeckSwitch setEnabled:YES];	
	[heroHoleCardsFaceUpSwitch setEnabled:YES];
	[omahaSwitch setEnabled:YES];
}

- (void) keyboardDisplayed {		
	updateButton.hidden = NO;
	cancelButton.hidden = NO;
	[updateButton setNeedsDisplay];
	[cancelButton setNeedsDisplay];
	
	[doneToolButton setEnabled:NO];
	
	[toolModeSwitch setEnabled:NO];
	[fourColorDeckSwitch setEnabled:NO];
	[heroHoleCardsFaceUpSwitch setEnabled:NO];
	[omahaSwitch setEnabled:NO];
}

- (void) clearNumbers {	
	NSString *DEFAULT_STRING = @"N/A";
	[heroStackText setText:DEFAULT_STRING];
	[villainStackText setText:DEFAULT_STRING];
	[smallBlindText setText:DEFAULT_STRING];
	[bigBlindText setText:DEFAULT_STRING];
	
	[heroStackText setEnabled:NO];
	[villainStackText setEnabled:NO];
	[smallBlindText setEnabled:NO];
	[bigBlindText setEnabled:NO];
}

- (void) loadNumbersFromUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	BOOL isOmaha = [omahaSwitch isOn];

	[heroStackText setText:[NSString stringWithFormat:@"%d", [defaults integerForKey:(isOmaha ? KEY_PLOMAHA_HERO_STACK : KEY_NLHOLDEM_HERO_STACK)]]];
	[villainStackText setText:[NSString stringWithFormat:@"%d", [defaults integerForKey:isOmaha ? KEY_PLOMAHA_VILLAIN_STACK : KEY_NLHOLDEM_VILLAIN_STACK]]];
	[smallBlindText setText:[NSString stringWithFormat:@"%d", [defaults integerForKey:isOmaha ? KEY_PLOMAHA_SMALL_BLIND : KEY_NLHOLDEM_SMALL_BLIND]]];
	[bigBlindText setText:[NSString stringWithFormat:@"%d", [defaults integerForKey:isOmaha ? KEY_PLOMAHA_BIG_BLIND : KEY_NLHOLDEM_BIG_BLIND]]];
	
	[heroStackText setEnabled:YES];
	[villainStackText setEnabled:YES];
	[smallBlindText setEnabled:YES];
	[bigBlindText setEnabled:YES];	
}

- (void) saveNumbersToUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	BOOL isOmaha = [omahaSwitch isOn];

	[defaults setInteger:[[heroStackText text] integerValue] forKey:(isOmaha ? KEY_PLOMAHA_HERO_STACK : KEY_NLHOLDEM_HERO_STACK)];
	[defaults setInteger:[[villainStackText text] integerValue] forKey:isOmaha ? KEY_PLOMAHA_VILLAIN_STACK : KEY_NLHOLDEM_VILLAIN_STACK];
	[defaults setInteger:[[smallBlindText text] integerValue] forKey:isOmaha ? KEY_PLOMAHA_SMALL_BLIND : KEY_NLHOLDEM_SMALL_BLIND];
	[defaults setInteger:[[bigBlindText text] integerValue] forKey:isOmaha ? KEY_PLOMAHA_BIG_BLIND : KEY_NLHOLDEM_BIG_BLIND];	
}

- (void) setNumbersBasedOnModeSwitchState {
	if ([toolModeSwitch isOn])
		[self clearNumbers];
	else
		[self loadNumbersFromUserDefaults];
}

- (void) dismissKeyboard {
	[heroStackText resignFirstResponder];
	[villainStackText resignFirstResponder];
	[smallBlindText resignFirstResponder];
	[bigBlindText resignFirstResponder];
}

- (IBAction) updateButtonPressed:(id)sender {
	// validate the four numbers and correct them if necessary
	[self validateUserInput];
	
	// set defaults
	[self saveNumbersToUserDefaults];
	
	// dismiss the keyboard
	[self dismissKeyboard];	
}

- (IBAction) cancelButtonPressed:(id)sender {
	// load defaults
	[self loadNumbersFromUserDefaults];
	
	// dismiss the keyboard
	[self dismissKeyboard];
}

- (IBAction) doneToolButtonPressed:(id)sender {	
#ifdef HU_3G
	Poker3GView *view = (Poker3GView*)[[[self superview] subviews] objectAtIndex:0];
	[view willDisplay];
#endif
	
	[navController popViewControllerAnimated:YES];
}

- (IBAction) toolModeSwitchValueChanged:(id)sender {
	[self setNumbersBasedOnModeSwitchState];		
	
	[[NSUserDefaults standardUserDefaults] setBool:[toolModeSwitch isOn] forKey:KEY_TOOL_MODE];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) fourColorDeckSwitchValueChanged:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[fourColorDeckSwitch isOn] forKey:KEY_FOUR_COLOR_DECK];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) heroHoleCardsFaceUpSwitchValueChanged:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[heroHoleCardsFaceUpSwitch isOn] forKey:KEY_HERO_HOLE_CARDS_FACE_UP];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) soundSwitchValueChanged:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[soundSwitch isOn] forKey:KEY_SOUND];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) advancedAISwitchValueChanged:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:[advancedAISwitch isOn] forKey:KEY_ADVANCED_AI];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction) omahaSwitchValueChanged:(id)sender {
	[self loadNumbersFromUserDefaults];

	[[NSUserDefaults standardUserDefaults] setInteger:([omahaSwitch isOn] ? kGameOmahaHi : kGameHoldem) forKey:KEY_GAME_NAME];	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) willDisplay {		
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[toolModeSwitch setOn:[defaults boolForKey:KEY_TOOL_MODE]];	
	[fourColorDeckSwitch setOn:[defaults boolForKey:KEY_FOUR_COLOR_DECK]];
	[heroHoleCardsFaceUpSwitch setOn:[defaults boolForKey:KEY_HERO_HOLE_CARDS_FACE_UP]];
	[soundSwitch setOn:[defaults boolForKey:KEY_SOUND]];
	[advancedAISwitch setOn:[defaults boolForKey:KEY_ADVANCED_AI]];
	[omahaSwitch setOn:([defaults integerForKey:KEY_GAME_NAME] == kGameOmahaHi) ];
	
	[self setNumbersBasedOnModeSwitchState];
}

@end
