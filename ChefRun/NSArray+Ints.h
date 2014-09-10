//
//  NSArray+Ints.h
//  Alcon KAM eDetail
//
//  Created by Jeremy Jurksztowicz on 2014-03-26.
//  Copyright (c) 2014 INVIVO Communications Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CR_ENDINTS 0xffffffff
#define CR_SENTINEL(n) n!= CR_ENDINTS

@interface NSArray (IntList)
+(NSArray*)arrayWithInts:(int)arg1, ...;
-(int)intAtIndex:(int)index;
@end
