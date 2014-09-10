//
//  ManagerObjectPool.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-22.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "ManagerObjectPool.h"
#import "MotherBrain.h"

@implementation ManagerObjectPool {
    NSMutableDictionary *freePool;
    NSMutableArray *usedPool;
}

-(id)init {
    self = [super init];
    if (self) {
        [self createPool];
    }
    return self;
}

-(void)createPool {
    freePool = [[NSMutableDictionary alloc] init];
    usedPool = [[NSMutableArray alloc] init];
}

-(id)getObjectFromPool:(NSString*)name
{
    return [[freePool objectForKey:name] objectAtIndex: 0];
}

-(BOOL)checkDictionaryForArrayNamed:(NSString*)name {
    if ([freePool objectForKey:name]) {
        return YES;
    } else {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [freePool setObject:array forKey:name];
        return NO;
    }
}

-(BOOL)checkForAvailableObjectsNamed:(NSString*)name
{
    if ( [self checkDictionaryForArrayNamed:name] == YES &&  [[freePool objectForKey:name] count] > 0 ){
        return YES;
    }else {
        return NO;
    }
}

-(NSArray*)getUsedPool
{
    return usedPool;
}

-(void)addObjectToFreePool:(CRBaseObject*)object
{
    [usedPool removeObject:object];
    NSMutableArray *freedArray = [freePool objectForKey:[object getName]];
    [freedArray addObject:object];
}

-(void)removeObjectFromFreePool:(CRBaseObject*)object {
    NSMutableArray *freedArray = [freePool objectForKey:[object getName]];
    [freedArray removeObject:object];
}

-(void)addObjectToUsedPool:(CRBaseObject*)object
{
    [usedPool addObject:object];
}



@end

