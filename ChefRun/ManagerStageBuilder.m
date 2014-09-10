//
//  ManagerStageBuilder.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-25.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "ManagerStageBuilder.h"
#import "AssistantObjectData.h"
#import "CRConfig.h"
#import "NSArray+Ints.h"
#import "PlayerData.h"

@implementation ManagerStageBuilder {
    NSMutableArray *backgrounds;
    NSMutableArray *objects;
    int objectCounter;
    NSArray *_locations;
    NSMutableArray *patterns;
}

-(id)init {
    self = [super init];
    if (self) {
        objectCounter = 0;
        patterns = [[NSMutableArray alloc]init];
        [patterns addObject:[NSArray arrayWithInts:0,0,0,0,CR_ENDINTS]];
        [patterns addObject:[NSArray arrayWithInts:1,2,2,1,CR_ENDINTS]];
        [patterns addObject:[NSArray arrayWithInts:2,2,1,0,CR_ENDINTS]];
        [patterns addObject:[NSArray arrayWithInts:0,1,2,2,CR_ENDINTS]];
        [patterns addObject:[NSArray arrayWithInts:1,2,1,2,CR_ENDINTS]];
    }
    return self;
}

-(id)getNextObject
{
    if ( objectCounter < [objects count]){
        AssistantObjectData *num = [objects objectAtIndex:objectCounter];
        objectCounter++;
        return num;
    } else {
        return nil;
    }
}

-(void)buildStage
{

    PlayerData *data = [PlayerData getInstance];
    NSDictionary *setup = [[CRConfig getInstance] getLevelConfig:data.currentLevel];

    int amountOfSpaces = [[setup objectForKey:@"level_time"] intValue] / SPAWN_TIME;      // amount of spaces to drop items
    
    objects = [[NSMutableArray alloc] init];                // object array to hold spaces / items / drop list

    for ( int i = 0; i < amountOfSpaces; i++ ){
        AssistantObjectData *data = [[AssistantObjectData alloc] init];
        [objects addObject:data];
    }

    float totalSpacesToUse = amountOfSpaces * [[setup objectForKey:@"item_ratio"] floatValue];        // this will determine how many items to add to the level

    [self add:(int)totalSpacesToUse ofType:@"coin" andOverwrite:NO];

    NSArray *random_ingredients = [setup objectForKey:@"required_ingredients"];
    for ( int i = 0; i < [random_ingredients count]; i++ ){
        [self add:1 ofType:[random_ingredients objectAtIndex:i] andOverwrite:NO];
    }

    NSMutableArray *tempPatternBlock = [[NSMutableArray alloc]init];
    float numberOfPatternsToBuild = ceil(amountOfSpaces/4);
    for ( int i = 0; i <= numberOfPatternsToBuild; i++ ){
        NSArray *rand = [patterns objectAtIndex:[self getRandomNumberBetween:0 maxNumber:[patterns count]-1]];
        for ( int t = 0; t < [rand count]; t++){
            [tempPatternBlock addObject: [rand objectAtIndex:t]];
        }
    }

    for ( int j = 0; j < [objects count]; j++ ){
        AssistantObjectData *assistant = [objects objectAtIndex:j];
        [assistant setLocation: [tempPatternBlock intAtIndex:j]];
    }

}

-(void)add:(int)numberOfObjects ofType:(NSString*)type andOverwrite:(BOOL)overwrite
{
    PlayerData *pd = [PlayerData getInstance];
    NSDictionary *config = [[CRConfig getInstance] getLevelConfig:pd.currentLevel];

    int amountOfSpaces = [[config objectForKey:@"level_time"] intValue] / SPAWN_TIME;      // amount of spaces to drop items
    int counter = 0;

    do
    {
        NSInteger myRandomNumber = [self getRandomNumberBetween:0 maxNumber:amountOfSpaces-1];
        AssistantObjectData *data = [objects objectAtIndex:myRandomNumber];
        if ( overwrite == YES ){
            [data setID:type];
            counter++;
        } else {
            if ( [type  isEqual: @"coin"] ){
                if ( [[data getID]  isEqual: @"none"] ){
                    [data setID:type];
                    counter++;
                }
            } else {
                if ( [[data getID]  isEqual: @"none"] || [[data getID]  isEqual: @"coin"] ){
                    [data setID:type];
                    counter++;
                }
            }
        }
        
    } while ( counter < numberOfObjects );

}

// take the width of the backgrounds ( they should all be equal sizes ) and divide that by the amount of seconds on the round.
-(NSNumber*)determineAmountOfBackgroundsRequiredBasedOnTime:(int)seconds
{
    NSNumber *number = [[NSNumber alloc] init];
    return number;
}

-(NSArray*)getArrayForStageItems
{
    NSArray *ary = [[NSArray alloc] init];
    return ary;
}

- (NSInteger)getRandomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    NSInteger num = min + arc4random() % (max - min + 1);
    
    return num;
}

@end
