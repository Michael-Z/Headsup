//
//  MyStoreObserver.m
//  Headsup
//
//  Created by Haolan Qin on 10/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyStoreObserver.h"

#import "Constants.h"

@implementation MyStoreObserver

@synthesize appController;

// saves a record of the transaction by storing the receipt to disk
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    if ([transaction.payment.productIdentifier isEqualToString:kHeadsupProVersionProductID])
    {
        // save the transaction receipt to disk
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:kHeadsupProVersionTransactionReceipt];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

// enable pro features
- (void)provideContent:(NSString *)productId
{
    if ([productId isEqualToString:kHeadsupProVersionProductID])
    {
        // enable the pro features
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHeadsupProVersionPurchasedKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
		
		// enable the pro features now.
		[appController enableProUpgrade];
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction { 
	[self recordTransaction: transaction];
	
	[self provideContent: transaction.payment.productIdentifier]; 
	
	// Remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction {
	if (transaction.error.code != SKErrorPaymentCancelled) {
		UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: @"Warning" 
														message: @"Transaction failed. Please try again later." 
													   delegate: NULL 
											  cancelButtonTitle: @"OK" 
											  otherButtonTitles: NULL] autorelease];
		[alert show];
	}
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction {
	[self recordTransaction: transaction];
	
	[self provideContent: transaction.originalTransaction.payment.productIdentifier];
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions) {
		switch (transaction.transactionState) {
			case SKPaymentTransactionStatePurchased: 
				[self completeTransaction:transaction]; 
				break;
			case SKPaymentTransactionStateFailed: 
				[self failedTransaction:transaction]; 
				break;
			case SKPaymentTransactionStateRestored: 
				[self restoreTransaction:transaction];
			default: 
				break;
		}
	}
}

@end
