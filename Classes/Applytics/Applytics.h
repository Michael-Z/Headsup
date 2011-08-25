//
//  Applytics.h
//  Copyright 2008 Applytics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Applytics : NSObject {
	NSString *appKey;
	BOOL hasStarted;
}

+ (id) sharedService;
- (void) setAppKey:(NSString*)appkey;
- (void) startService;
- (void) stopService;
- (void) log:(NSString*)actionName;

@end
