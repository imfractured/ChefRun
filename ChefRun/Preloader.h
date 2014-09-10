//
//  Preloader.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-06.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class MotherBrain;

@interface Preloader : NSObject

@property (assign)MotherBrain *delegate; // just declares the property name

-(void)loadAssetsForLevel:(int)level;
-(id)getTextureArrayCalled:(NSString*)name;
@end
