//
//  Preloader.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-06.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "Preloader.h"
#import "CRConfig.h"
#import "MotherBrain.h"

@implementation Preloader {
    NSMutableDictionary *textures;
    int count;
    NSArray *toLoad;

}

@synthesize delegate; // synthesize creates default getter and setter for the property

-(id)init {
    self = [super init];
    if (self) {
        //
    }
    return self;
}

-(void)loadAssetsForLevel:(int)level {
    
    count = 0;
    
    textures = [[NSMutableDictionary alloc] init];
    
    NSDictionary *level_config = [[CRConfig getInstance] getLevelConfig:level];
    
    NSArray *ingredient_list = [level_config objectForKey:@"ingredients"];
    NSArray *required_ingredient_list = [level_config objectForKey:@"required_ingredients"];
    
    // loop through required ingredients
    for ( int i = 0; i < [ingredient_list count]; i++ ){
        
        NSDictionary *object = [[MotherBrain getInstance] getObjectData:[ingredient_list objectAtIndex:i]];
        NSArray *animations = [object objectForKey:@"animations"];
        NSString *atlasName =[object objectForKey:@"atlas"];
        SKTextureAtlas *objectAnimatedAtlas = [SKTextureAtlas atlasNamed:atlasName];
        
        // loop through animation array for each ingredient
        for ( int j = 0; j < [animations count]; j++ ){
            NSDictionary *dic = [animations objectAtIndex:j];
            NSMutableArray *storedTexturesForAnimation = [[NSMutableArray alloc] init];
            // loop through numberOfFrames for each ingredient animation
            for ( int x = 1; x <= [[dic objectForKey:@"numberOfFrames"] integerValue]; x++ ){
                NSString *str = [[NSString alloc] initWithFormat:@"%@-%i.png",[dic objectForKey:@"prefix"],x];
                SKTexture *temp = [objectAnimatedAtlas textureNamed:str];
                [storedTexturesForAnimation addObject:temp];
            }
            [textures setObject:storedTexturesForAnimation forKey:[dic objectForKey:@"prefix"]];
        }
    }
    
    // loop through required ingredients
    for ( int i = 0; i < [required_ingredient_list count]; i++ ){
        
        NSDictionary *object = [[MotherBrain getInstance] getObjectData:[required_ingredient_list objectAtIndex:i]];
        NSArray *animations = [object objectForKey:@"animations"];
        NSString *atlasName =[object objectForKey:@"atlas"];
        SKTextureAtlas *objectAnimatedAtlas = [SKTextureAtlas atlasNamed:atlasName];
        
        // loop through animation array for each ingredient
        for ( int j = 0; j < [animations count]; j++ ){
            NSDictionary *dic = [animations objectAtIndex:j];
            NSMutableArray *storedTexturesForAnimation = [[NSMutableArray alloc] init];
            // loop through numberOfFrames for each ingredient animation
            for ( int x = 1; x <= [[dic objectForKey:@"numberOfFrames"] integerValue]; x++ ){
                NSString *str = [[NSString alloc] initWithFormat:@"%@-%i.png",[dic objectForKey:@"prefix"],x];
                SKTexture *temp = [objectAnimatedAtlas textureNamed:str];
                [storedTexturesForAnimation addObject:temp];
            }
            [textures setObject:storedTexturesForAnimation forKey:[dic objectForKey:@"prefix"]];
        }
    }
    
    NSDictionary *backgrounds = [level_config objectForKey:@"backgrounds"];
    
    // add background
    NSString *customerBackground = [[NSString alloc] initWithFormat:@"Assets/BackgroundImages/%@.png",[backgrounds objectForKey:@"customer"]];
    NSString *mainBackground = [[NSString alloc] initWithFormat:@"Assets/BackgroundImages/%@.png",[backgrounds objectForKey:@"main"]];
    
    SKTexture *customer = [SKTexture textureWithImageNamed:customerBackground];
    SKTexture *main = [SKTexture textureWithImageNamed:mainBackground];
    
    [textures setObject:[[NSArray alloc] initWithObjects:customer, nil] forKey:[backgrounds objectForKey:@"customer"]];
    [textures setObject:[[NSArray alloc] initWithObjects:main, nil] forKey:[backgrounds objectForKey:@"main"]];
    
    toLoad = [textures allValues];
    
    [self startLoading];
    
}

-(id)getTextureArrayCalled:(NSString*)name {
    return [textures objectForKey:name];
}

-(void)startLoading {
    NSLog(@"Preloader -> start loading");
    float percent = (float)count/(float)[toLoad count];

    if ( delegate ){
        [self.delegate assetsUpdateProgress:percent];
    }

    if ( count < [toLoad count] ){
        NSArray *frames = [toLoad objectAtIndex:count];
        [SKTexture preloadTextures:frames withCompletionHandler:^{
            count++;
            NSLog(@"LOAD NEXT ASSET %i",count);
            [self startLoading];
            
        }];
    } else {
        NSLog(@"ALL ASSETS ARE LOADED?");
        if ( delegate ){

            [self.delegate assetsAreLoaded];
            delegate = nil;
        }
    }
    
}


@end
