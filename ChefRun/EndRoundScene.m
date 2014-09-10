//
//  EndRoundScene.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-16.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "EndRoundScene.h"
#import "RoundSelectScene.h"
#import "CRConfig.h"
#import "MotherBrain.h"
#import "PlayerData.h"

@implementation EndRoundScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        [self doLayout];
    }
    return self;
}

-(void)doLayout {
    NSString *textureName = @"Assets/BackgroundImages/preload_background.png";
    
    SKSpriteNode *bg = [[SKSpriteNode alloc] initWithImageNamed:textureName];
    bg.anchorPoint = CGPointMake(0, 0);
    bg.position = CGPointMake(0, 0);
    bg.name = @"background";
    [self addChild:bg];
    
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    myLabel.text = @"round complete";
    myLabel.fontSize = 30;
    myLabel.position = CGPointMake(200,
                                   100);
    [self addChild:myLabel];
    
    [self calculateScore];
}

-(void)calculateScore {
    PlayerData *pd = [PlayerData getInstance];
    // the items the player actually picked up
    CRConfig *config = [CRConfig getInstance];
    NSArray *items = [config getCollectedItems];
    MotherBrain *mb = [MotherBrain getInstance];
    int gradeDivider = (int)[[[config getLevelConfig:pd.currentLevel] objectForKey:@"gradeSpan"] integerValue];
    
    // the items that the player was supposed to pick up
    NSDictionary *level_data = [config getLevelConfig:pd.currentLevel];
    NSArray *requiredItems = [level_data objectForKey:@"required_ingredients"];
    
    int positiveScoreForCollectedItems = 0;
    int negativeScoreForCollectedItems = 0;
    int totalScoreForLevel = 0;
    
    for ( int d = 0; d < [requiredItems count]; d++ ){
        totalScoreForLevel += [[[mb getObjectData:[requiredItems objectAtIndex:d]] objectForKey:@"rankWeight"] integerValue];
    }
    
    for ( int i = 0; i < [items count]; i++ ){
        BOOL hasFoundItem = NO;
        
        NSDictionary *itemData = [mb getObjectData:[items objectAtIndex:i]];
        
        for ( int j = 0; j < [requiredItems count]; j++ ){
            if ( [[items objectAtIndex:i] isEqualToString:[requiredItems objectAtIndex:j]] ){
                // we have a match, so lets add the score and break for next item
                hasFoundItem = YES;
                positiveScoreForCollectedItems += [[itemData objectForKey:@"rankWeight"] integerValue];
                break;
            }
        }
        if ( hasFoundItem == NO ){
            // this means its a BAD item
            negativeScoreForCollectedItems += [[itemData objectForKey:@"rankWeight"] integerValue];

        }
    }
    float calculatedScore = (positiveScoreForCollectedItems - negativeScoreForCollectedItems);
    float percentage = (calculatedScore / (float)totalScoreForLevel)*100;
    
    NSString *theGrade = [self calculateGrade:gradeDivider withScore:percentage];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = theGrade;
    scoreLabel.fontSize = 20;
    scoreLabel.position = CGPointMake(500,300);
    [self addChild:scoreLabel];
    
    
    [pd addToBank:config.score];
    
    SKLabelNode *cashLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    cashLabel.text = [[NSString alloc]initWithFormat:@"bank: $%@",pd.currentPlayer.cash];
    cashLabel.fontSize = 20;
    cashLabel.position = CGPointMake(500,350);
    [self addChild:cashLabel];
    
    [pd setRoundStatus:percentage];

}

-(NSString*)calculateGrade:(int)gradeDivider withScore:(float)score {
    NSString *playerGrade = @"A";
    
    NSMutableArray *grades = [[NSMutableArray alloc] initWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F"]];
    NSMutableArray *gradeValues = [[NSMutableArray alloc] init];
    int totalValue = 100 - gradeDivider;
    for ( int i = 0; i < [grades count]; i++ ){
        int val = totalValue - (gradeDivider * i);
        NSNumber *num = [[NSNumber alloc] initWithInt:val];
        [gradeValues addObject:num];
    }
    
    grades=[[[grades reverseObjectEnumerator] allObjects] mutableCopy];
    gradeValues=[[[gradeValues reverseObjectEnumerator] allObjects] mutableCopy];
    
    // now loop through array and find the value
    for ( int j = 0; j < [gradeValues count]; j++ ){
        if ( score > [[gradeValues objectAtIndex:j] floatValue] ){
            playerGrade = [grades objectAtIndex:j];
        } else {
            break;
        }
    }
    
    return playerGrade;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"background"]) {
        RoundSelectScene *scene = [RoundSelectScene sceneWithSize:self.size];
        SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:.5];
        transition.pausesIncomingScene = YES;
        [self.view presentScene:scene transition:transition];
    }
}

@end
