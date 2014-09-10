//
//  MotherBrain.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-23.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "MotherBrain.h"
#import "CRBaseObject.h"
#import "ManagerObjectPool.h"
#import "Preloader.h"
#import "PreloadScene.h"

@implementation MotherBrain {
    ManagerObjectPool *pool;
    NSDictionary *xmlData;
    Preloader *_preloader;
    int _count;
}

@synthesize preloadDelegate;

static MotherBrain * _instance;

+ (void) initialize {
    if (self == [MotherBrain class]){
        _instance = [[MotherBrain alloc] init];
    }
}

-(id)init {
    self = [super init];
    if (self) {
        _count = 0;
        [self loadDataFromXML];
    }
    return self;
}

+(id)getInstance {
    return _instance;
}

-(void)loadDataFromXML{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"objectdata.plist" ofType:nil];
    NSDictionary * plist = [NSDictionary dictionaryWithContentsOfFile:path];
    xmlData = plist;
    pool = [[ManagerObjectPool alloc] init];
    
    _preloader = [[Preloader alloc] init];
    _preloader.delegate = self; // if i wanted to remove the reference, just set to nil
    
}

-(void)assetsAreLoaded {
    NSLog(@"assetsAreLoaded: %@",preloadDelegate);
    [self.preloadDelegate assetsLoaded];
}
-(void)assetsUpdateProgress:(float)progress {
    [self.preloadDelegate assetsUpdateProgress: progress];
}

-(void)loadAssetsFor:(int)level {
    [_preloader loadAssetsForLevel:level];
}

-(NSDictionary*)getObjectData:(NSString*)name {
    NSDictionary *dic = [xmlData objectForKey:name];
    return dic;
}

-(CRBaseObject*)createObjectNamed:(NSString*)name {
    CRBaseObject *obj = [[CRBaseObject alloc] init];
    return obj;
}

-(id)getSpriteNamed:(NSString*)name andPlaceAt:(int)pt {
    BOOL poolHasItems = [pool checkForAvailableObjectsNamed:name];
    CRBaseObject *object;
    if ( poolHasItems ){
        object = [pool getObjectFromPool:name];
        [pool removeObjectFromFreePool:object];
    } else {
        object = [self makeObjectNamed:name];
        NSString *name = [[NSString alloc] initWithFormat:@"coin_%i",_count];
        object.name = name;
        _count++;
    }
    [pool addObjectToUsedPool:object];
    
    CGPoint _pt = CGPointMake(1080, pt);
    [object resetState: _pt];
    
    return object;
}

-(id)getTextureArrayCalled:(NSString*)name {
    return [_preloader getTextureArrayCalled:name];
}

-(id)makeObjectNamed:(NSString*)name {
    
    NSDictionary *dict = [self getObjectData:name];
    CRBaseObject *object = [[CRBaseObject alloc] initWithKey:dict];
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        [object setupCollisionDetectionWithRect:CGRectMake(
           [[dict objectForKey:@"collisionXiPad"] floatValue],
           [[dict objectForKey:@"collisionYiPad"] floatValue],
           [[dict objectForKey:@"collisionWidthiPad"] floatValue],
           [[dict objectForKey:@"collisionHeightiPad"] floatValue]
        )];
    } else {
        [object setupCollisionDetectionWithRect:CGRectMake(
           [[dict objectForKey:@"collisionXiPhone"] floatValue],
           [[dict objectForKey:@"collisionYiPhone"] floatValue],
           [[dict objectForKey:@"collisionWidthiPhone"] floatValue],
           [[dict objectForKey:@"collisionHeightiPhone"] floatValue]
        )];
    }
    
    return object;
}

-(void)addObjectToFreePool:(id)obj {
    [pool addObjectToFreePool:obj];
}

-(id)getUsedPool {
    return [pool getUsedPool];
}

@end
