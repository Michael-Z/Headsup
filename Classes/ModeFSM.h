//
//  HandFSM.h
//  Headsup
//
//  Created by Haolan Qin on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"


@interface ModeFSM : NSObject {
	enum ModeState state;
}

@property (nonatomic) enum ModeState state;

- (id)init;

-(void) input: (enum ModeEvent)sevent;

@end
