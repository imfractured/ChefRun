//
//  ManagerObjectPool.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-22.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "CRBaseObject.h"

@interface ManagerObjectPool : NSObject {
    
}

-(NSArray*)getUsedPool;
-(void)addObjectToFreePool:(id)object;
-(void)addObjectToUsedPool:(id)object;
-(void)removeObjectFromFreePool:(CRBaseObject*)object;
-(id)getObjectFromPool:(NSString*)name;
-(BOOL)checkForAvailableObjectsNamed:(NSString*)name;

@end
