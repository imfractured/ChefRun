//
//  PreloadScene.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-06.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "PreloadScene.h"
#import "MotherBrain.h"
#import "GameScene.h"
#import "PreloadBar.h"
#import "CRConfig.h"
#import "PlayerData.h"

@implementation PreloadScene {
    NSDictionary *textureDictionary;
    NSMutableArray *texturesToLoad;
    MotherBrain *mb;
    PreloadBar *bar;
}

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size]) {
        
        
        NSString *textureName = @"Assets/BackgroundImages/preload_background.png";
        
        SKSpriteNode *bg = [[SKSpriteNode alloc] initWithImageNamed:textureName];
        bg.anchorPoint = CGPointMake(0, 0);
        bg.position = CGPointMake(0, 0);
        [self addChild:bg];

        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        myLabel.text = @"preloading";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(200,
                                       100);
        [self addChild:myLabel];

        mb = [MotherBrain getInstance];
        mb.preloadDelegate = self;
    
        // starts the party
        SKAction *wait = [SKAction waitForDuration:2];
        SKAction *performSelector = [SKAction performSelector:@selector(preloadAssets) onTarget:self];
        SKAction *sequence = [SKAction sequence:@[wait,performSelector]];
        [self runAction:sequence];
        
        bar = [[PreloadBar alloc] init];
        bar.position = CGPointMake(50,50);
        [self addChild:bar];
        
    }
    return self;
}

-(void)preloadAssets {
    PlayerData *data = [PlayerData getInstance];
    [mb loadAssetsFor:data.currentLevel];
}

-(void)assetsLoaded {

    mb.preloadDelegate = nil;
    [bar cleanUp];
    bar = nil;

    GameScene *scene = [GameScene sceneWithSize:self.size];
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:.5];
    transition.pausesIncomingScene = YES;
    [self.view presentScene:scene transition:transition];
    
}
-(void)assetsUpdateProgress:(float)progress {
    [bar setPercent:progress];
}
@end
