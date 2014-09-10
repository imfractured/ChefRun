//
//  CRConfig.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-27.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRConfig.h"

@implementation CRConfig {
    NSArray *level_data;
    NSArray *level_config;
    NSMutableArray *collectedItems;
}

@synthesize game;
@synthesize score;

static CRConfig * _instance;

+ (void) initialize {
    if (self == [CRConfig class]){
        _instance = [[CRConfig alloc] init];
    }
}

-(id)init {
    self = [super init];
    if (self) {
        [self reset];
        [self loadLevelData];
        [self loadLevelConfig];
    }
    return self;
}

+(id)getInstance {
    return _instance;
}

-(void)reset {
    collectedItems = [[NSMutableArray alloc] init];
    score = 0;
}

-(void)addItem:(NSString*)item {
    [collectedItems addObject:item];
}
-(id)getCollectedItems {
    return collectedItems;
}


-(void)loadLevelData {
    NSString *device = [[UIDevice currentDevice] model];
    NSString *file = @"iphone";
    if ([device rangeOfString:@"iPad"].location != NSNotFound ) {
        file = @"ipad";
    }
    NSString *filename = [[NSString alloc] initWithFormat:@"level_data_%@.plist",file];
    NSString * path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    level_data = [NSArray arrayWithContentsOfFile:path];
}

-(void)loadLevelConfig {
    NSString *filename = [[NSString alloc] initWithFormat:@"level_config.plist"];
    NSString * path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    level_config = [NSArray arrayWithContentsOfFile:path];
}

-(id)getLevelData:(int)level {
    return [level_data objectAtIndex:level];
}

-(id)getLevelConfig:(int)level {
    return [[level_config objectAtIndex:level] objectAtIndex:0];
}





@end
