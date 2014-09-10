//
//  CRStatusBar.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-16.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRStatusBar.h"
#import "CRBaseObject.h"
#import "MotherBrain.h"
#import "CRConfig.h"

@implementation CRStatusBar {
    SKLabelNode *scoreLabel;
    SKSpriteNode *ingredients;
}

-(id)init
{
    if (self = [super init]) {
        [self setupInterface];
    }
    return self;
}

-(void)setupInterface {
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    self.zPosition = 1000;
    
    NSString *textureName = @"Assets/InterfaceImages/header";
    
    SKSpriteNode *header = [[SKSpriteNode alloc] initWithImageNamed:textureName];
    header.anchorPoint = CGPointMake(0, 1);

    header.position = CGPointMake(0, rect.size.width);
    [self addChild:header];
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"$0";
    scoreLabel.fontSize = 30;
    scoreLabel.position = CGPointMake(5,rect.size.width-(header.size.height*.4));
    [scoreLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [self addChild:scoreLabel];
    
    ingredients = [[SKSpriteNode alloc] init];
    ingredients.position = CGPointMake(0,rect.size.width-header.size.height);
    [self addChild:ingredients];
    
}

-(void)updateScore:(int)score {
    scoreLabel.text = [[NSString alloc] initWithFormat:@"$%i",score];
}

-(void)pickUpItem:(CRBaseObject*)object {
    
    MotherBrain *mb = [MotherBrain getInstance];
    NSArray *anims = [mb getTextureArrayCalled:[object getName]];
    SKTexture *temp = (SKTexture*)anims[0];
    SKSpriteNode *item = [[SKSpriteNode alloc] initWithTexture:temp];
    [ingredients addChild:item];
    NSArray *numberOfChildren = ingredients.children;
    item.position = CGPointMake([numberOfChildren count] * 60,0);
    
    CRConfig *config = [CRConfig getInstance];
    
    [config addItem:[object getName]];
    
}

-(void)setRequiredIngredients:(NSArray*)ingredients {
    
}

@end
