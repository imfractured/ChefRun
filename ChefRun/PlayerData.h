//
//  PlayerData.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-30.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Player.h"
#import "Level.h"
#import "Round.h"

@interface PlayerData : NSObject {
    NSString *persistentStorePath;
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) Player *currentPlayer;
@property (nonatomic) int currentLevel;
@property (nonatomic) int currentRound;
@property (nonatomic) NSMutableArray *levels;
@property (nonatomic) NSMutableArray *rounds;

-(void)addToBank:(int)cash;
-(void)setRoundStatus:(int)score;

+(id)getInstance;

@end
