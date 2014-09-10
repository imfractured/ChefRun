//
//  Player.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-06-02.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Level;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * cash;
@property (nonatomic, retain) NSNumber * playerNumber;
@property (nonatomic, retain) NSSet *level;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addLevelObject:(Level *)value;
- (void)removeLevelObject:(Level *)value;
- (void)addLevel:(NSSet *)values;
- (void)removeLevel:(NSSet *)values;

@end
