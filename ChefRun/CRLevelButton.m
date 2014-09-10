//
//  CRLevelButton.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-09-09.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRLevelButton.h"

@implementation CRLevelButton

@synthesize subtitle;

+ (instancetype)buttonWithTextLabel:(NSString *)label withTarget:(id)target action:(SEL)action {
    return [[CRLevelButton alloc] initWithtextLabel:label withTarget:target action:action];
}

-(void)setSubText:(NSString*)string {
    if ( !subtitle ){
        subtitle = [[SKLabelNode alloc] initWithFontNamed:@"Chalkduster"];
        subtitle.position = CGPointMake(0,-50);
        [self addChild:subtitle];
    }
    
    subtitle.text = string;
}

@end