//
//  TitleScene.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-30.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "TitleScene.h"
#import "LevelSelectScene.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        [self doLayout];
    }
    return self;
}

-(void)doLayout {
    NSString *textureName = @"Assets/BackgroundImages/titlescreen_background";
    
    SKSpriteNode *bg = [[SKSpriteNode alloc] initWithImageNamed:textureName];
    bg.anchorPoint = CGPointMake(0, 0);
    bg.position = CGPointMake(0, 0);
    bg.name = @"background";
    [self addChild:bg];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"background"]) {
        LevelSelectScene *scene = [LevelSelectScene sceneWithSize:self.size];
        SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:.5];
//        transition.pausesIncomingScene = YES;e
        [self.view presentScene:scene transition:transition];
    }
}


@end
