//
//  CRBackgroundManager.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-07.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "BackgroundTiler.h"
#import "MotherBrain.h"
#import "CRConfig.h"

@implementation BackgroundTiler {
    SKSpriteNode *bg1;
    SKSpriteNode *bg2;
    SKSpriteNode *bg3;
}

@synthesize endRound;
@synthesize delegate;

-(id)init {
    if (self = [super init]) {
        endRound = NO;
        [self createBackgrounds];
    }
    return self;
}

-(void)createBackgrounds {
    NSString *textureName = @"Assets/BackgroundImages/background_level_1_customer.png";
    
    bg1 = [[SKSpriteNode alloc] initWithImageNamed:textureName];
    bg1.anchorPoint = CGPointMake(0, 0);
    bg1.position = CGPointMake(0, 0);
    [self addChild:bg1];
    
    bg2 = [[SKSpriteNode alloc] initWithImageNamed:textureName];
    bg2.anchorPoint = CGPointMake(0, 0);
    bg2.position = CGPointMake(bg1.size.width-1, 0);
    [self addChild:bg2];
    
    textureName = @"Assets/BackgroundImages/background_level_1_customer.png";
    
    bg3 = [[SKSpriteNode alloc] initWithImageNamed:textureName];
    bg3.anchorPoint = CGPointMake(0, 0);
    bg3.position = CGPointMake(bg1.size.width-1, 0);
    [self addChild:bg3];

}

-(void)transitionToCustomer {
    if ( bg2.position.x < bg1.position.x ){
        bg3.position = CGPointMake(bg1.size.width+bg1.position.x-1, 0);
    } else {
        bg3.position = CGPointMake(bg2.size.width+bg2.position.x-1, 0);
    }
    
    endRound = YES;
    [delegate endRound];
}

-(void)moveBy:(float)amount {
    if (bg1.position.x < -bg1.size.width){
        bg1.position = CGPointMake(bg2.position.x + bg2.size.width, bg1.position.y);
    }
    
    if (bg2.position.x < -bg2.size.width) {
        bg2.position = CGPointMake(bg1.position.x + bg1.size.width, bg2.position.y);
    }
    
    if (bg3.position.x < 1) {
        //bg2.position = CGPointMake(bg1.position.x + bg1.size.width, bg2.position.y);
        //STOP MOVING
        [delegate stopMoving];
    }
    
    if ( endRound == NO ){
        bg1.position = CGPointMake(bg1.position.x - amount, bg1.position.y);
        bg2.position = CGPointMake(bg2.position.x - amount, bg2.position.y);
    } else {
        bg1.position = CGPointMake(bg1.position.x - amount, bg1.position.y);
        bg2.position = CGPointMake(bg2.position.x - amount, bg2.position.y);
        bg3.position = CGPointMake(bg3.position.x - amount, bg3.position.y);
    }
    
}

@end
