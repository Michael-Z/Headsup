//
//  CardView.h
//  MoveMe
//
//  Created by Haolan Qin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Card;

@interface CardView : UIView {
	Card *card;
	
	UIImage *image;
		
	BOOL faceUp;
	
	BOOL dull;	
}

@property (nonatomic, retain) Card *card;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) BOOL dull;


- (id)init;

- (void) dullize;
- (void) toggleDull;

@end
