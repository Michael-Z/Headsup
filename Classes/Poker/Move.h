//
//  Move.h
//  Headsup
//
//  Created by Haolan Qin on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"

@interface Move : NSObject {
    /** one of the above constant values */
    enum MoveType move;
	
    /** dollar amount associated w/ the move. only applies to
     *  CALL, BET and RAISE. in case of BET, it's the amount bet by the player.
     *  in case of RAISE, it's the amount raised TO by the player. Notice
     *  that in case of CALL we may still need the amount because when a player
     *  is short stacked he is allowed to call w/ all of his remaining chips
     *  (all-in).
     */
    //NSNumber* amount;
	NSInteger amount;
	
    /**
     * only applies to RAISE. while m_amount stores the "raise to" amount,
     * m_raiseAmount stores the raise amount. e.g. current bet $10, this move
     * raises to $40. Then m_amount = 40f and m_raiseAmount = 30f
     */
    //NSNumber* raiseAmount;
	NSInteger raiseAmount;
}

@property (nonatomic) enum MoveType move;
//@property (nonatomic, retain) NSNumber* amount;
//@property (nonatomic, retain) NSNumber* raiseAmount;
@property (nonatomic) NSInteger amount;
@property (nonatomic) NSInteger raiseAmount;

//-(id)initWithMove:(enum MoveType)aMove Amount:(NSNumber*)aNumber;
-(id)initWithMove:(enum MoveType)aMove Amount:(NSInteger)anAmount;


@end
