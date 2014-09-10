//
//  NSArray+Ints.m
//  Alcon KAM eDetail
//
//  Created by Jeremy Jurksztowicz on 2014-03-26.
//  Copyright (c) 2014 INVIVO Communications Inc. All rights reserved.
//

#import "NSArray+Ints.h"
#include <stdarg.h>

@implementation NSArray (IntList)
+(NSArray*)arrayWithInts:(int)arg1, ...
{
    va_list ap;
    int i;

    NSMutableArray * array = [NSMutableArray array];

    va_start(ap, arg1); 
    for (i = arg1; CR_SENTINEL(i); i = va_arg(ap, int))
        [array addObject:[NSNumber numberWithInt:i]];
    va_end(ap);
    
    return array;
}

-(int)intAtIndex:(int)index
{
    NSNumber *num = [self objectAtIndex:index];
    return [num intValue];
}
@end