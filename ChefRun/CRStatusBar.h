//
//  CRStatusBar.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-16.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "CRBaseObject.h"

@interface CRStatusBar : SKSpriteNode

-(void)updateScore:(int)score;
-(void)pickUpItem:(CRBaseObject*)object;

@end
