//
//  HandFSM.h
//  Headsup
//
//  Created by Haolan Qin on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"


@interface HandFSM : NSObject {
	enum State state;
}

@property (nonatomic) enum State state;

- (id)init;

-(void) input: (enum Event)sevent;

@end
