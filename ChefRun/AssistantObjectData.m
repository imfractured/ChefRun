//
//  AssistantObjectData.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-03-26.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "AssistantObjectData.h"
#import "MotherBrain.h"
#import "NSArray+Ints.h"
#import "CRConfig.h"

@implementation AssistantObjectData {
    NSString *_id;        // this is the name of the object we want to create based on the key from plist
    int _location;        // this is the pre-determined location of where the object will be drawn vertically
}


-(id)init {
    self = [super init];
    if (self) {
        _id = @"none";
        _location = 0;
    }
    return self;
}

-(void)setLocation:(int)location
{
    _location = location;
}
-(int)getLocation
{
    switch ( _location ){
        case 0:
            return ITEM_POSITION_1;
            break;
            
        case 1:
            return ITEM_POSITION_2;
            break;
            
        case 2:
            return ITEM_POSITION_3;
            break;
            
        default:
            return 0;
            break;
    }
}

-(void)setID:(NSString*)id
{
    _id = id;
}

-(NSString*)getID
{
    return _id;
}

@end
