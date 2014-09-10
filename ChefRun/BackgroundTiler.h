//
//  CRBackgroundManager.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-07.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

@interface BackgroundTiler : SKSpriteNode
@property (assign)GameScene *delegate;
@property (assign)BOOL endRound;
-(void)moveBy:(float)amount;
-(void)transitionToCustomer;
@end
