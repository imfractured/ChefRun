//
//  PreloadBar.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-07.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PreloadBar : SKSpriteNode


-(void)setPercent:(float)percent;
-(void)cleanUp;
@end
