//
//  Level.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-06-02.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round;

@interface Level : NSManagedObject

@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * isLocked;
@property (nonatomic, retain) NSManagedObject *player;
@property (nonatomic, retain) NSSet *round;
@end

@interface Level (CoreDataGeneratedAccessors)

- (void)addRoundObject:(Round *)value;
- (void)removeRoundObject:(Round *)value;
- (void)addRound:(NSSet *)values;
- (void)removeRound:(NSSet *)values;

@end
