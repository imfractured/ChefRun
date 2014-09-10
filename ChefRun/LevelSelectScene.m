//
//  LevelSelectScene.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-06-04.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "LevelSelectScene.h"
#import "CRLevelButton.h"
#import "PlayerData.h"
#import "RoundSelectScene.h"
#import "Round.h"

@implementation LevelSelectScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        [self doLayout];
    }
    return self;
}

-(void)doLayout {
    
    SKLabelNode *cashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    cashLabel.text = @"Select a level";
    cashLabel.fontSize = 20;
    cashLabel.position = CGPointMake(110,160);
    [self addChild:cashLabel];
    
    PlayerData *pd = [PlayerData getInstance];
    NSArray *levels = pd.levels;

    
    int newX = 70;
    int newY = 100;
    
    for ( int i = 0; i < [pd.levels count]; i++ ){
        
        Level *level = [levels objectAtIndex:i];
        NSSet *rounds = level.round;
        NSArray *result = [[rounds allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"round" ascending:YES]]];
        
        int roundsCompleted = 0;
        for ( int j = 0; j < [result count]; j++ ){
            Round *round = [result objectAtIndex:j];
            if ( round.hasPlayed == YES ){
                roundsCompleted++;
            }
        }
        NSString *roundText = [[NSString alloc] initWithFormat:@"%i/%i",roundsCompleted,[result count]];
        
        CRLevelButton *backButton = [CRLevelButton buttonWithTextLabel:[[NSString alloc] initWithFormat:@"%i",i+1] withTarget:self action:@selector(buttonAction:)];
        [backButton setSubText:roundText];
        [backButton setPosition:CGPointMake(newX, newY)];
        [self addChild:backButton];
        
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
    pd.currentLevel = [btn.name intValue];
    
    RoundSelectScene *scene = [RoundSelectScene sceneWithSize:self.size];
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:.5];
    [self.view presentScene:scene transition:transition];
}


@end
