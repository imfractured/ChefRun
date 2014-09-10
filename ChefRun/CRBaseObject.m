//
//  CRBaseObject.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-22.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRBaseObject.h"
#import "MotherBrain.h"

const uint32_t heroCategory    =  0x1 << 0; // const means that it can be accessed from child classes, if you add static, it becomes protected
const uint32_t enemyCategory   =  0x1 << 1;

@implementation CRBaseObject {
    
}


-(id)initWithKey:(NSDictionary*)key
{
    if (self = [super init]) {
        data = key;
        [self createObject];
    }
    return self;
}

-(NSString*)getName
{
    return _objectName;
}

-(NSString*)getType
{
    return [data objectForKey:@"type"];
}

-(void)createObject
{
    
    NSArray *animList = [data objectForKey:@"animations"];
    
    _animations = [[NSMutableDictionary alloc] init];
    
    // loop through array of animations, create them and dump them into our animations dictionary
    for ( int j = 0; j < [animList count]; j++ ){
        if ( j == 0 ){
            _objectName = [[animList objectAtIndex:j] objectForKey:@"prefix"];
        }
        NSArray *textureArray = [[MotherBrain getInstance] getTextureArrayCalled:[[animList objectAtIndex:j] objectForKey:@"prefix"]];
        [_animations setObject:textureArray forKey: [[animList objectAtIndex:j] objectForKey:@"prefix"]];
     
    }
    
    // get the first item in the dictionary
    id val = nil;
    NSArray *values = [_animations allValues];
    if ([values count] != 0){
        val = [values objectAtIndex:0];
    }
    
    // assign it as a texture so we can have a starting image
    SKTexture *temp = (SKTexture*)val[0];
    (void)[self initWithTexture:temp];
    
    // animate the sprite with the first animation
    [self animateWithArray:(NSArray*)val];
    
}

-(void)resetState:(CGPoint)pt
{
    // *************** lets change this to be a grid instead of a random number and follow some sort of pattern that matches the jump arc
    self.position = pt;
    
}

-(void)animateWithArray:(NSArray*)textures
{
    [self runAction:[SKAction repeatActionForever:
                     [SKAction animateWithTextures:textures
                                      timePerFrame:SPRITE_ANIMATION_SPEED
                                            resize:NO
                                           restore:YES]]
     ];
    return;
}

-(void)setupCollisionDetectionWithRect:(CGRect)rect
{
    CGSize box = CGSizeMake(rect.size.width,rect.size.height);
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box center:CGPointMake(rect.origin.x,rect.origin.y)];
    self.physicsBody.dynamic = YES;
    self.physicsBody.categoryBitMask = enemyCategory;
    self.physicsBody.contactTestBitMask = heroCategory;
    self.physicsBody.collisionBitMask = 0;
}

-(CGPoint)getPosition
{
    CGPoint pt = CGPointMake(self.position.x, self.position.y);
    return pt;
}

-(void)kill
{
    [self removeFromParent];
    [[MotherBrain getInstance] addObjectToFreePool:self];
}

-(void)stopActions
{
    [self removeAllActions];
}

- (BOOL)moveFromArray:(NSMutableArray *)arrayA toArray:(NSMutableArray *)arrayB
{
    if ([arrayA containsObject:self]) {
        [arrayA removeObject:self];
        [arrayB addObject:self];
        
        return YES;
    } else {
        return NO;
    }
}

@end
