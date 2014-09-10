//
//  PlayerData.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-30.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "PlayerData.h"
#import "Player.h"
#import "Level.h"
#import "Round.h"
#import "CRConfig.h"

@implementation PlayerData

@synthesize managedObjectContext;
@synthesize levels;
@synthesize rounds;

@synthesize currentPlayer;
@synthesize currentLevel;
@synthesize currentRound;


static PlayerData * _instance;

+ (void) initialize {
    if (self == [PlayerData class]){
        _instance = [[PlayerData alloc] init];
    }
}

-(id)init {
    self = [super init];
    if (self) {
        [self addRecord];
    }
    return self;
}

+(id)getInstance {
    return _instance;
}

-(void)addRecord {
//    [self wipeAllPlayers];
    
    NSArray *records = [self queryDBForEntity:@"Player" predicate:nil sortByField:nil];
    
    if ( [records count] == 0 ){
  
        Player *player = [NSEntityDescription insertNewObjectForEntityForName:@"Player" inManagedObjectContext:[self managedObjectContext]];
        player.cash = [NSNumber numberWithInt:0];
        player.playerNumber = [NSNumber numberWithInt:0];
 
        for ( int j = 0; j < 5; j++ ){  // 5 levels
            
            Level *level = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:[self managedObjectContext]];
            level.level = [NSNumber numberWithInt:j+1];
            level.player = player;
            level.isLocked = (BOOL)NO;
            
            for ( int i = 0; i < 10; i++ ){  // 10 rounds per level
                
                Round *round = [NSEntityDescription insertNewObjectForEntityForName:@"Round" inManagedObjectContext:[self managedObjectContext]];
                round.level = level;
                round.score = [NSNumber numberWithInt:0];
                round.round = [NSNumber numberWithInt:i+1];
                round.hasPlayed = NO;

            }
        }
        
        NSError *error;
        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        records = [self queryDBForEntity:@"Player" predicate:nil sortByField:nil];
    }
    
    // sets current player
    currentPlayer = [records firstObject];
    
    NSArray *_levels = [currentPlayer.level allObjects];
    levels = [_levels mutableCopy];
    [levels sortUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:YES], nil]];
    
}

-(void)setRoundStatus:(int)score {
    
    Level *level = [levels objectAtIndex:currentLevel];
    NSSet *_rounds = level.round;
    NSArray *result = [[_rounds allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]]];

    Round *round = [result objectAtIndex:currentRound];
    round.score = [NSNumber numberWithInt:score];
    round.hasPlayed = YES;
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } 
}

-(void)addToBank:(int)_cash {
    
    float newTotal = [currentPlayer.cash floatValue] + [[NSNumber numberWithInt:_cash] floatValue];
    currentPlayer.cash = [NSNumber numberWithFloat:newTotal];
    
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
}

-(void)wipeAllPlayers {
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"Player" inManagedObjectContext:[self managedObjectContext]]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * cars = [[self managedObjectContext] executeFetchRequest:allCars error:&error];
    for (NSManagedObject * car in cars) {
        [[self managedObjectContext] deleteObject:car];
    }
    NSError *saveError = nil;
    [[self managedObjectContext] save:&saveError];
    [self wipeAlLevels];
}
-(void)wipeAlLevels {
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"Level" inManagedObjectContext:[self managedObjectContext]]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * cars = [[self managedObjectContext] executeFetchRequest:allCars error:&error];
    for (NSManagedObject * car in cars) {
        [[self managedObjectContext] deleteObject:car];
    }
    NSError *saveError = nil;
    [[self managedObjectContext] save:&saveError];
    [self wipeAlRounds];
}
-(void)wipeAlRounds {
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"Round" inManagedObjectContext:[self managedObjectContext]]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError * error = nil;
    NSArray * cars = [[self managedObjectContext] executeFetchRequest:allCars error:&error];
    for (NSManagedObject * car in cars) {
        [[self managedObjectContext] deleteObject:car];
    }
    NSError *saveError = nil;
    [[self managedObjectContext] save:&saveError];
}




/*
 * A generic function that can query that given entity with the given condition and return sorted results.
 */
-(NSArray *)queryDBForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate sortByField:(NSString *)sortField
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    if(sortField != nil)
    {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortField ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
    }
    
    if(predicate != nil)
        [request setPredicate:predicate];
    
    NSError *error;
    //    NSMutableArray *mutableFetchResults = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    NSArray *fetchResults = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if (fetchResults == nil) {
        NSLog(@"Error fetching result %@", [error description]);
    }
    return fetchResults;
}


















/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
		NSLog(@"managedOC - != nil");
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
		NSLog(@"coordinator - != nil");
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"ChefRun" ofType:@"momd"];
	NSLog(@"in managedObjectModel - ModelPath: %@", modelPath);
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
	NSLog(@"in persistentStoreCoordinator");
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Event.sqlite"]];
	NSLog(@"in persistentStoreCoordinator - After Store URL: %@", storeURL);
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation ...
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator_;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
