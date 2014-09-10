//
//  CRStoreViewCell.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-16.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRStoreViewCell.h"

@implementation CRStoreViewCell {
    UIImageView *thumb;
    UILabel *lbl;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        thumb = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,80,80)];
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,80,20)];
        [self addSubview:thumb];
        [self addSubview:lbl];
    }
    return self;
}

-(void)setThumb:(UIImage*)image andSetLabel:(NSString*)string {
    thumb.image = image;
    lbl.text = string;
}

@end
