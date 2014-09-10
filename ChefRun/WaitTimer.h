//
//  WaitTimer.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-25.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScene.h"

@interface WaitTimer : UIView

+(id)getInstance;
-(void)getReady:(GameScene*)delegate;
-(void)resume;
@end
