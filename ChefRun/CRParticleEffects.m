//
//  CRParticleEffects.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-23.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRParticleEffects.h"

@implementation CRParticleEffects {
    
}

-(CRParticleEffects*)initWithEffect:(NSString*)effectName
{
    if (self = [super init]) {

        NSString *burstPath = [[NSBundle mainBundle] pathForResource:effectName ofType:@"sks"];
        
        // create reference to this class before we set self
        Class oldClass = [NSKeyedUnarchiver classForClassName:@"SKEmitterNode"];
        [NSKeyedUnarchiver setClass:[self class] forClassName:@"SKEmitterNode"];
        
        self = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
        
        // replace current class cast with the old one, so we can access our kill method
        [NSKeyedUnarchiver setClass:oldClass forClassName:@"SKEmitterNode"];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // IPAD
        } else {
            CGFloat percent = .25;
            CGSize size = [self particleSize];
            size.width = size.width*percent;
            size.height = size.height*percent;
            self.particleSize = size;
            self.particleSpeed= self.particleSpeed*percent;
            self.particleSpeedRange = self.particleSpeedRange*percent;
            self.particleScale = self.particleScale*percent;
            self.particleScaleRange = self.particleScaleRange*percent;
            self.particleScaleSpeed = self.particleScaleSpeed*percent;
            self.xAcceleration = self.xAcceleration*percent;
            self.yAcceleration = self.yAcceleration*percent;
        }

        
        [NSTimer scheduledTimerWithTimeInterval:3
                                         target:self
                                       selector:@selector(kill)
                                       userInfo:nil
                                        repeats:NO];
    }
    return self;
}

-(void)kill
{
    [self removeFromParent];
}

@end
