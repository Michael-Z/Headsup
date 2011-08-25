//
//  HelpHoldemView.h
//  Headsup
//
//  Created by Haolan Qin on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppController.h"


@interface HelpHoldemView : UIView {
	UINavigationController *navController;
	IBOutlet UIWebView *helpTextView;
}

@property (nonatomic, retain) UINavigationController *navController;

@property (nonatomic, retain) IBOutlet UIWebView *helpTextView;

- (IBAction) doneButtonPressed:(id)sender;

@end
