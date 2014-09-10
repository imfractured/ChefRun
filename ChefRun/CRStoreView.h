//
//  CRStoreView.h
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-15.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRStoreView : UIView <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
}
-(void)showScreen;
+(id)getInstance;
-(void)setupStore;
@end
