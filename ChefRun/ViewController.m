//
//  ViewController.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-20.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "ViewController.h"
#import "GameScene.h"
#import "TitleScene.h"
#import "CRConfig.h"


#import "CRStoreView.h"
#import "WaitTimer.h"
#import "PlayerData.h"

@implementation ViewController {
    
}

- (void)viewWillLayoutSubviews
{
    
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if(skView.scene == nil){
        
        CGRect newFrame = CGRectMake(0,0,self.view.frame.size.height, self.view.frame.size.width);
        
        WaitTimer *timer = [WaitTimer getInstance];
        [self.view addSubview:timer];
        timer.frame = newFrame;

        CRStoreView *store = [CRStoreView getInstance];
        [self.view addSubview:store];
        
        store.frame = newFrame;
        [store setupStore];
        
        
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = YES;
        
        // Create and configure the scene.
        SKScene * scene = [TitleScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
                
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
