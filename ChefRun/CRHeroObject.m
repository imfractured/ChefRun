//
//  CRHeroObject.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-25.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRHeroObject.h"
#import "CRConfig.h"
#import "EndRoundScene.h"

@implementation CRHeroObject {
    int canJump;
}

-(id)initWithKey:(NSDictionary*)key
{
    if (self = [super initWithKey:key]) {
        self.position = CGPointMake(CHARACTER_START_X, CHARACTER_START_Y);
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [self setupCollisionDetectionWithRect:CGRectMake(
                           [[key objectForKey:@"collisionXiPad"] floatValue],
                           [[key objectForKey:@"collisionYiPad"] floatValue],
                           [[key objectForKey:@"collisionWidthiPad"] floatValue],
                           [[key objectForKey:@"collisionHeightiPad"] floatValue]
                           )];
        } else {
            [self setupCollisionDetectionWithRect:CGRectMake(
                           [[key objectForKey:@"collisionXiPhone"] floatValue],
                           [[key objectForKey:@"collisionYiPhone"] floatValue],
                           [[key objectForKey:@"collisionWidthiPhone"] floatValue],
                           [[key objectForKey:@"collisionHeightiPhone"] floatValue]
                           )];
        }
        
    }
    return self;
}

-(void)allowJump:(BOOL)allow {
    if ( allow == YES ){
        canJump = 0;
    } else {
        canJump = 1;
    }
}

-(void)jump {
    if ( canJump == 0 ){
        canJump = 1;
        // frames for jump animation
        SKAction *animation = [SKAction animateWithTextures:[_animations objectForKey:@"jump"] timePerFrame:.13];
        // jump start action
        SKAction *moveUp = [SKAction moveTo:CGPointMake(CHARACTER_START_X,
                                                        CHARACTER_START_Y +
                                                        CHARACTER_JUMP_HEIGHT
                                                        )
                                   duration:CHARACTER_JUMP_UP_TIME];
        moveUp.timingMode = SKActionTimingEaseOut;
        // jump end action
        SKAction *moveDown = [SKAction moveTo:CGPointMake(CHARACTER_START_X, CHARACTER_START_Y) duration:CHARACTER_JUMP_DOWN_TIME];
        moveDown.timingMode = SKActionTimingEaseIn;
        // jump sequence of start and end
        SKAction *jump = [SKAction sequence:@[moveUp,moveDown]];
        [self runAction:animation];
        [self runAction:jump completion:^{
            canJump = 0;
        }];
    }
}

-(void)standInPlace {
    [self removeAllActions];
    SKAction* changeFace = [SKAction setTexture:[[_animations objectForKey:@"stand"] objectAtIndex:0]];
    [self runAction:changeFace];
    SKAction *wait = [SKAction waitForDuration:3];
    SKAction *endScene = [SKAction performSelector:@selector(transitionToEndOfRound) onTarget:self];
    SKAction *action = [SKAction sequence:@[wait,endScene]];
    [self runAction:action];
}

-(void)transitionToEndOfRound {
    CRConfig *config = [CRConfig getInstance];
    EndRoundScene *_scene = [EndRoundScene sceneWithSize:config.game.size];
    [config.game.view presentScene:_scene transition:[SKTransition pushWithDirection:SKTransitionDirectionLeft duration:1]];
}

-(void)walkToTable {
    
    [self allowJump:NO];
    self.position = CGPointMake(CHARACTER_START_X,CHARACTER_START_Y);
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:[_animations objectForKey:@"run"]
                                      timePerFrame:CHARACTER_ANIMATION_TIME
                                            resize:NO
                                           restore:YES]]];
    
    SKAction *walkToTable = [SKAction moveTo:CGPointMake(CHARACTER_START_X + 200,
                                                         CHARACTER_START_Y)
                                    duration:1];
    
    [self runAction:walkToTable completion:^{
        [self standInPlace];
    }];
     
}

-(void)setupCollisionDetectionWithRect:(CGRect)rect
{
    CGSize box = CGSizeMake(rect.size.width,rect.size.height);
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box center:CGPointMake(rect.origin.x,rect.origin.y)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = heroCategory;
    self.physicsBody.contactTestBitMask = enemyCategory;
    self.physicsBody.collisionBitMask = 0;
}

@end
