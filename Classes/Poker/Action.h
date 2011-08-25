//
//  Action.h
//  Headsup
//
//  Created by Haolan Qin on 1/27/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface Action : NSObject {
    enum ActionType action;
	
	// call amount, bet amount, raise to amount
	NSInteger amount;
	
	// call more amount, bet amount, raise more amount
	NSInteger additionalAmount;
	
	BOOL isHero;
	
	// always YES if action == kActionFold
	// could be YES if action == kActionCheck/Call/River
	// always NO for any other actions
	BOOL isHandOver;
	 
	
	// 
	BOOL isAllIn;
}

@property (nonatomic) enum ActionType action;
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSInteger additionalAmount;
@property (nonatomic) BOOL isHero;
@property (nonatomic) BOOL isHandOver;
@property (nonatomic) BOOL isAllIn;

@end
