//
//  PreloadBar.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-07.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "PreloadBar.h"

@implementation PreloadBar {
    SKShapeNode *preloadBar;
    SKShapeNode *preloadBox;
    int widthOfLoader;
    int heightOfLoader;

}

-(id)init
{
    if (self = [super init]) {
        
        widthOfLoader = 400;
        heightOfLoader = 20;
        
        [self setupView];
    }
    return self;
}

-(void)setupView {

    preloadBox = [[SKShapeNode alloc] init];
    preloadBox.strokeColor = [SKColor redColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,widthOfLoader,heightOfLoader)];
    preloadBox.path = [path CGPath];
    [self addChild:preloadBox];
    
    //CGPathRelease([path CGPath]);
    
    preloadBar = [[SKShapeNode alloc] init];
    preloadBar.fillColor = [SKColor redColor];
    path = [UIBezierPath bezierPathWithRect:CGRectMake(2,2,0,heightOfLoader-4)];
    preloadBar.path = [path CGPath];
    [self addChild:preloadBar];
    
    //CGPathRelease([path CGPath]);
    
}

-(void)setPercent:(float)percent {

    float width = (float)widthOfLoader-4;
    float newWidth = width*percent;
    
    UIBezierPath *newPercent = [UIBezierPath bezierPathWithRect:CGRectMake(2,2,newWidth,heightOfLoader-4)];
    preloadBar.path = [newPercent CGPath];
    
    //CGPathRelease(_path);
}

-(void)cleanUp {
    
    [preloadBox removeFromParent];
    [preloadBar removeFromParent];
    
    CFRelease(CFBridgingRetain(preloadBar));
    CFRelease(CFBridgingRetain(preloadBox));
    
    [self removeFromParent];
    
}


@end
