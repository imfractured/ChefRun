//
//  Round.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-06-02.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Round : NSManagedObject

@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic) BOOL hasPlayed;
@property (nonatomic, retain) NSManagedObject *level;

@end
