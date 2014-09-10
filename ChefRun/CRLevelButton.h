//
//  CRLevelButton.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-09-09.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKButton.h"

@interface CRLevelButton : SKButton

@property (nonatomic, readonly, strong) SKLabelNode *subtitle;

-(void)setSubText:(NSString*)string;

@end
