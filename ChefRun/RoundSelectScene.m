//
//  RoundSelectScene.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-06-04.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "RoundSelectScene.h"
#import "PreloadScene.h"
#import "PlayerData.h"
#import "CRLevelButton.h"
#import "Level.h"
#import "Round.h"

@implementation RoundSelectScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        [self doLayout];
    }
    return self;
}

-(void)doLayout {
    
    SKLabelNode *cashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    cashLabel.text = @"Select a round";
    cashLabel.fontSize = 20;
    cashLabel.position = CGPointMake(110,160);
    [self addChild:cashLabel];
    
    PlayerData *pd = [PlayerData getInstance];
    
    
//    SKTexture *txtUp = [SKTexture textureWithImageNamed:@"buttonLevel"];
    
    int newX = 70;
    int newY = 100;
    
    NSArray *levels = pd.levels;
    Level *level = [levels objectAtIndex:pd.currentLevel];
    NSSet *rounds = level.round;
    NSArray *result = [[rounds allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]]];

    for ( int i = 0; i < [result count]; i++ ){
        
        Round *rnd = [result objectAtIndex:i];
        
        CRLevelButton *backButton = [CRLevelButton buttonWithTextLabel:[[NSString alloc] initWithFormat:@"%i",i+1] withTarget:self action:@selector(buttonAction:)];
        [backButton setPosition:CGPointMake(newX, newY)];
        [self addChild:backButton];
        [backButton setSubText:[rnd.score stringValue]];
        
        newX = newX + 100;

/*
        if ( i == 4 ){
            newX = 70;
            newY = newY - 100;
        }
*/
    }
}

-(void)buttonAction:(SKButton*)btn {
    PlayerData *pd = [PlayerData getInstance];
    pd.currentRound = [btn.name intValue];
    
    PreloadScene *scene = [PreloadScene sceneWithSize:self.size];
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:.5];
    [self.view presentScene:scene transition:transition];
}

@end
