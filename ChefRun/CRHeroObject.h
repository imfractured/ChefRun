//
//  CRHeroObject.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-25.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRBaseObject.h"

@interface CRHeroObject : CRBaseObject

-(void)jump;
-(void)standInPlace;
-(void)allowJump:(BOOL)allow;
-(void)walkToTable;

@end
