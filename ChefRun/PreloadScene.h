//
//  PreloadScene.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-06.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PreloadScene : SKScene
-(void)assetsLoaded;
-(void)assetsUpdateProgress:(float)progress;
@end
