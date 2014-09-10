//
//  MotherBrain.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-23.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PreloadScene;

@interface MotherBrain : NSObject {
    
}

@property (assign)PreloadScene *preloadDelegate;

+(id)getInstance;
-(NSDictionary*)getObjectData:(NSString*)name;
-(id)makeObjectNamed:(NSString*)name;
-(id)getSpriteNamed:(NSString*)name andPlaceAt:(int)pt;
-(void)addObjectToFreePool:(id)obj;
-(id)getUsedPool;
-(void)assetsAreLoaded;
-(void)loadAssetsFor:(int)level;
-(void)assetsUpdateProgress:(float)progress;
-(id)getTextureArrayCalled:(NSString*)name;
@end
