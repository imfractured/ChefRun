//
//  MyScene.h
//  ChefRun
//

//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate> {

}

@property (assign) CFTimeInterval lastUpdateTimeInterval;
-(void)stopMoving;
-(void)unpause;
-(void)endRound;
-(void)startLevel;
@end
