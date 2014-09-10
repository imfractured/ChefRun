//
//  WaitTimer.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-25.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "WaitTimer.h"
#import "GameScene.h"

@implementation WaitTimer {
    UIImageView *img;
    NSTimer *timer;
    int count;
    int total;
    GameScene *game;
    NSString *type;
}

static WaitTimer * _instance;

+ (void) initialize {
    if (self == [WaitTimer class]){
        _instance = [[WaitTimer alloc] init];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        img = [[UIImageView alloc] init];
        [self addSubview:img];
    }
    return self;
}

+(id)getInstance {
    return _instance;
}

-(void)getReady:(GameScene*)delegate {
    type = @"getReady";
    game = delegate;
    [self showImage:@"waitTimer_getReady.png" forFlashes:5];
}

-(void)resume {
    type = @"resume";
    [self showImage:@"waitTimer_ready.png" forFlashes:2];
}

-(void)showImage:(NSString*)imageName forFlashes:(int)flashes {
    
    count = 0;
    total = flashes;
    
    self.hidden = NO;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:Nil inDirectory:@"Assets/InterfaceImages"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    CGRect rect = CGRectMake( (self.frame.size.width-image.size.width)*.5, (self.frame.size.height-image.size.height)*.5, image.size.width, image.size.height );
    
    img.alpha = 1;
    img.frame = rect;
    img.image = image;
    
    [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(flashImage) userInfo:Nil repeats:NO];
    
}

-(void)flashImage {
    [timer invalidate];
    timer = nil;
    
    BOOL canFade = NO;
    
    if ( count < total ){
        
        timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(flashImage) userInfo:Nil repeats:NO];
        count++;
        
    } else {
        if ( img.alpha == 0 ){
            
            timer = [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(flashImage) userInfo:Nil repeats:NO];
            count++;
            
        } else {
            
            canFade = YES;
            
        }
    }
    
    if ( img.alpha == 0 ){
        img.alpha = 1;
    } else {
        if ( canFade == YES ){
            [UIView animateWithDuration: 0.3
                                  delay: 0.0
                                options: UIViewAnimationOptionCurveLinear
                             animations:^{
                                 img.alpha = 0.0;
                             }
                             completion:^ (BOOL finished)
                                {
                                     if (finished) {
                                         [self completeFade];
                                     }
                                }];
        } else {
            img.alpha = 0;
        }
    }
}

-(void)completeFade {
    [timer invalidate];
    timer = nil;
    if ( [type  isEqual: @"getReady"] ){
        [game startLevel];
    } else if ( [type  isEqual: @"resume"] ){
        [game unpause];
    }
    self.hidden = YES;
}

@end
