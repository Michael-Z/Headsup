//
//  CardView.m
//  MoveMe
//
//  Created by Haolan Qin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CardView.h"
#import "Card.h"

@implementation CardView

@synthesize faceUp;
@synthesize dull;

- (id)init {
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void) setCard:(Card*)aCard {
	card = aCard;
	
	if (card)
		self.hidden = NO;
	else
		self.hidden = YES;
		
	[self setBackgroundColor:[UIColor clearColor]];
	
	dull = NO;
	
	[self setNeedsDisplay];
}

- (Card*) card {
	return card;
}

+ (UIImage*) getCardImage: (enum Suit)aSuit {
	
	/*UIImage* cardImage = nil;
	
	switch (aSuit) {
		case kSuitSpade:
			cardImage = [UIImage imageNamed:@"Placard.png"];
			break;
		case kSuitHeart:
			cardImage = [UIImage imageNamed:@"Placard.png"];
			break;
		case kSuitDiamond:
			cardImage = [UIImage imageNamed:@"whiteButton.png"];
			break;
		case kSuitClub:
			cardImage = [UIImage imageNamed:@"blueButton.png"];
			break;
		default:
			NSLog(@"wrong suit. no image picked: %@", aSuit);
			break;
	}
	
	return cardImage;*/
	
	return [UIImage imageNamed:@"2c.png"];
}	


+ (UIColor*) getCardColor: (enum Suit)aSuit {
	UIColor* cardColor = nil;
	
	switch (aSuit) {
		case kSuitSpade:
			cardColor = [UIColor blackColor];
			break;
		case kSuitHeart:
			cardColor = [UIColor redColor];
			break;
		case kSuitDiamond:
			cardColor = [UIColor blueColor];
			break;
		case kSuitClub:
			cardColor = [UIColor cyanColor];
			break;
		default:
			NSLog(@"wrong suit. no color picked: %u", aSuit);
			break;
	}
	
	return cardColor;
}	

#define STRING_INDENT 15

- (void)dullize {
	dull = YES;
	[self setNeedsDisplay];
}

- (void) toggleDull {
	dull = !dull;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	if (card) {
		if (faceUp) {
			NSString *cardImageName = 
			[[[NSUserDefaults standardUserDefaults] boolForKey:KEY_FOUR_COLOR_DECK] ? 
			 [card toFourColorDeckString] : [card toString] 
			 stringByAppendingString:@".png"];
			
			UIImage *cardImage = [UIImage imageNamed:cardImageName];
			
			if (dull)
				[cardImage drawAtPoint:(CGPointMake(0.0, 0.0)) blendMode:kCGBlendModeNormal alpha:0.25];
			else
				[cardImage drawAtPoint:(CGPointMake(0.0, 0.0))];

			
			// four color deck has this weird "blank card" problem!!!!
			//[[UIImage imageNamed:[card getImageName]] drawAtPoint:(CGPointMake(0.0, 0.0))];
		
		/*
		CGFloat fontSize = 32;
		UIFont *font = [UIFont systemFontOfSize:fontSize];
		NSString *currentDisplayString = [card toString];
		CGSize textSize = [currentDisplayString sizeWithFont:font minFontSize:9.0 actualFontSize:&fontSize forWidth:(self.bounds.size.width-STRING_INDENT) lineBreakMode:UILineBreakModeMiddleTruncation];

		
		CGFloat x = self.bounds.size.width/2 - textSize.width/2;
		CGFloat y = self.bounds.size.height/2 - textSize.height/2;
		CGPoint point;
		
		// Get the font of the appropriate size
		//UIFont *font = [UIFont systemFontOfSize:fontSize];
		
			[[CardView getCardColor:card.suit] set];	
						
		point = CGPointMake(x, y + 0.5);
		[currentDisplayString drawAtPoint:point forWidth:(self.bounds.size.width-STRING_INDENT) withFont:font fontSize:fontSize lineBreakMode:UILineBreakModeMiddleTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		 */
		} else {
			if (dull)
				[[UIImage imageNamed:@"back.png"] drawAtPoint:(CGPointMake(0.0, 0.0)) blendMode:kCGBlendModeNormal alpha:0.25];
			else
				[[UIImage imageNamed:@"back.png"] drawAtPoint:(CGPointMake(0.0, 0.0))];
		}
	}
}


- (void)dealloc {
	[card dealloc];
	[image dealloc];
    [super dealloc];
}

@end
