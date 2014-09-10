//
//  MyScene.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-20.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "GameScene.h"
#import "CRHeroObject.h"
#import "MotherBrain.h"
#import "CRBaseObject.h"
#import "CRParticleEffects.h"
#import "ManagerStageBuilder.h"
#import "AssistantObjectData.h"
#import "CRConfig.h"
#import "BackgroundTiler.h"
#import "CRStoreView.h"
#import "CRStatusBar.h"
#import "WaitTimer.h"
#import "PlayerData.h"

@implementation GameScene {
    CRHeroObject *hero;
    NSTimer *timer;
    ManagerStageBuilder *builder;
    BOOL moveObjects;
    BackgroundTiler *bg;
    CRStatusBar *status;
    BOOL allowTouchInput;
    uint32_t heroCategory;
    uint32_t enemyCategory;
    BOOL firstRun;
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
      
        firstRun = YES;
        
        heroCategory    =  0x1 << 0;
        enemyCategory   =  0x1 << 1;
        
        CRConfig *config = [CRConfig getInstance];
        config.game = self;
        config.score = 0;
        NSLog(@"GAME SCENE 0");
        builder = [[ManagerStageBuilder alloc] init];
        
        moveObjects = YES;
        allowTouchInput = YES;
        NSLog(@"GAME SCENE 1");
        [builder buildStage];
        NSLog(@"GAME SCENE 2");
        [self setupScene];
        NSLog(@"GAME SCENE 3");
 
    }
    return self;
}

// MAIN UPDATE LOOP
-(void)update:(CFTimeInterval)currentTime {
    
    if ( firstRun == YES ){
        firstRun = NO;
        self.paused = YES;
        WaitTimer *_timer = [WaitTimer getInstance];
        [_timer getReady:self];
    }
    
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) {
        timeSinceLast = 1.0 / 60.0;
    }
    
    if ( moveObjects == YES ){
        
      //[bg moveBy:BACKGROUND_SPEED * timeSinceLast];
        [bg moveBy:BACKGROUND_SPEED];
          
        NSArray *onScreenItems = [[MotherBrain getInstance] getUsedPool];
        
        for ( int i = 0; i < [onScreenItems count]; i++ ){
            CRBaseObject *obj = [onScreenItems objectAtIndex:i];
            
          //obj.position = CGPointMake(obj.position.x - (BACKGROUND_SPEED * timeSinceLast), obj.position.y);
            obj.position = CGPointMake(obj.position.x - BACKGROUND_SPEED, obj.position.y);
            
            
            if ( obj.position.x < 0 ){
                [obj kill];
            }
        }
    }
}

-(void)endRound {
    allowTouchInput = NO;
}

-(void)stopMoving {
    moveObjects = NO;
    [hero walkToTable];
}

// DISPATCH NEXT OBJECT IN LIST
-(void)nextObjectInList {
    AssistantObjectData *obj = [builder getNextObject];
    if ( obj == nil ){
        NSArray *usedPool = [[MotherBrain getInstance] getUsedPool];
        if ( [usedPool count] == 0 ){
            [bg transitionToCustomer];
            [self stopTimer]; // this will stop the objects from continuing to spawn
        }
    } else {
        if ( ![[obj getID]  isEqual: @"none"] ){
            CRBaseObject *_obj = [[MotherBrain getInstance] getSpriteNamed:[obj getID] andPlaceAt:[obj getLocation]];
            [self addChild:_obj];
        }
    }
}


// MANAGE TOUCH EVENT
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ( allowTouchInput ){
        [hero jump];
    }
}


// ADD BACKGROUNDS, HERO, SCORE AND TIMER
-(void)setupScene {
    
    self.physicsWorld.gravity = CGVectorMake(0,0);
    self.physicsWorld.contactDelegate = self;
    
    bg = [[BackgroundTiler alloc] init];
    bg.delegate = self;
    [self addChild:bg];
    
    MotherBrain *mb = [MotherBrain getInstance];
    hero = [[CRHeroObject alloc] initWithKey:[mb getObjectData:@"hero"]];
    [self addChild:hero];
    
    status = [[CRStatusBar alloc] init];
    [self addChild:status];
    
    CRConfig *config = [CRConfig getInstance];
    [config reset];
    
    
}

-(void)startLevel {
    self.view.paused = NO;
    SKAction *wait = [SKAction waitForDuration:SPAWN_TIME];
    SKAction *performSelector = [SKAction performSelector:@selector(nextObjectInList) onTarget:self];
    SKAction *sequence = [SKAction sequence:@[wait, performSelector]];
    SKAction *repeat   = [SKAction repeatActionForever:sequence];
    [self runAction:repeat withKey:@"nextObjectInList"];
}

// STOP DISPATCHING NEW OBJECTS TO THE SCREEN
-(void)stopTimer {
    [self removeActionForKey:@"nextObjectInList"];
}

// THIS IS THE COLLISION DETECTION
- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if ((firstBody.categoryBitMask & heroCategory) != 0 && (secondBody.categoryBitMask & enemyCategory) != 0) {
        [self projectile:(SKSpriteNode *) firstBody.node didCollideWithMonster:(CRBaseObject *) secondBody.node];
    }
}


// THIS IS THE COLLISION EVENT
- (void)projectile:(SKSpriteNode *)_hero didCollideWithMonster:(CRBaseObject *)object {
    
    CRParticleEffects *bang;
    CRConfig *config = [CRConfig getInstance];
    
    float blend = .5;
    
    CGPoint pointBetweenObjects = CGPointMake(
        _hero.position.x + blend * (object.position.x - _hero.position.x),
        _hero.position.y + blend * (object.position.y - _hero.position.y)
    );
    
    // MONEY
    if ( [[object getType]  isEqual: @"money"]){
        bang = [[CRParticleEffects alloc] initWithEffect:@"PickUpItem"];
        [self addChild:bang];
        bang.position = pointBetweenObjects;
        config.score = config.score + 10;
        
        
        
    // ENEMY
    } else if ( [[object getType]  isEqual: @"enemy"] ){
        bang = [[CRParticleEffects alloc] initWithEffect:@"GotHit"];
        [self addChild:bang];
        bang.position = pointBetweenObjects;
        
        
        
    // ITEM
    } else if ( [[object getType]  isEqual: @"item"] ){
        bang = [[CRParticleEffects alloc] initWithEffect:@"GotItem"];
        [self addChild:bang];
        CGPoint pt = pointBetweenObjects;
        pt.x = pt.x + 30;
        bang.position = pt;
        [status pickUpItem:object];
    
        
        
    // STORE
    } else if ( [[object getType] isEqual: @"store"] ){
        [self showStore];
    }
    

    
    [status updateScore:config.score];
    [object kill];
}

-(void)showStore {
    self.view.paused = YES;
    CRStoreView *store = [CRStoreView getInstance];
    [store showScreen];
}

-(void)unpause {
    self.view.paused = NO;
}
@end
