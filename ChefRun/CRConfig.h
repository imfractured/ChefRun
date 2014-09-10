//
//  CRConfig.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-27.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"

@interface CRConfig : NSObject {
    
}

@property GameScene *game;
@property int score;

+(id)getInstance;
-(id)getLevelConfig:(int)level;
-(id)getLevelData:(int)level;
-(void)addItem:(NSString*)item;
-(id)getCollectedItems;
-(void)reset;
@end
