//
//  CRBaseObject.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-22.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

const uint32_t heroCategory;
const uint32_t enemyCategory;

@interface CRBaseObject : SKSpriteNode {
    NSMutableDictionary *_animations;
    NSDictionary *data;

}

@property (strong, nonatomic) NSArray *_animationFrames;
@property (strong, nonatomic) NSString *objectName;

-(CRBaseObject*)initWithKey:(NSDictionary*)key;
-(void)setupCollisionDetectionWithRect:(CGRect)rect;
-(void)createObject;
-(void)kill;
-(void)resetState:(CGPoint)pt;
- (BOOL)moveFromArray:(NSMutableArray *)arrayA toArray:(NSMutableArray *)arrayB;
-(CGPoint)getPosition;
-(NSString*)getName;
-(NSString*)getType;


@end
