//
//  MyStoreObserver.h
//  Headsup
//
//  Created by Haolan Qin on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "AppController.h"

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver> {
	AppController *appController;
}

@property (nonatomic, assign) AppController *appController;

@end
