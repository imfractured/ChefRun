//
//  CRStoreView.m
//  ChefRun
//
//  Created by Nick Gorman on 2014-04-15.
//  Copyright (c) 2014 Nick Gorman. All rights reserved.
//

#import "CRStoreView.h"
#import "CRConfig.h"
#import "CRStoreViewCell.h"
#import "MotherBrain.h"
#import "WaitTimer.h"
#import "PlayerData.h"

@implementation CRStoreView {
    NSMutableArray *dataSource;
    NSMutableArray *storeItems;
    UILabel *availableFunds;
}

static CRStoreView * _instance;

+ (void) initialize {
    if (self == [CRStoreView class]){
        _instance = [[CRStoreView alloc] init];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

+(id)getInstance {
    return _instance;
}

-(void)setupStore {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"store_bg.png" ofType:Nil inDirectory:@"Assets/BackgroundImages"];
    UIImage *bg_image = [UIImage imageWithContentsOfFile:path];
    UIImageView *bg = [[UIImageView alloc] initWithImage:bg_image];
    
    CGRect rect = CGRectMake(
                             (self.frame.size.width-bg_image.size.width)*.5,
                             (self.frame.size.height-bg_image.size.height)*.5,
                             bg_image.size.width,
                             bg_image.size.height
               );
    
    bg.frame = rect;
    
    [self addSubview:bg];
    
    [self setupDataSource];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(bg.frame.origin.x + 10,bg.frame.origin.y + 102,bg.frame.size.width-10,136) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[CRStoreViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor redColor]];
    _collectionView.allowsSelection = YES;
    [self addSubview:_collectionView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18.0f];
    button.frame = CGRectMake(bg.frame.origin.x + bg.frame.size.width - 70, bg.frame.origin.y + 50, 100.0, 20.0);
    [self addSubview:button];
    
    availableFunds = [[UILabel alloc] initWithFrame:CGRectMake(bg.frame.origin.x, bg.frame.origin.y, 200, 20)];
    availableFunds.text = [[NSString alloc] initWithFormat:@"Available Funds $%i",0];
    [self addSubview:availableFunds];

}
-(void) buttonClicked:(id)sender {
    [self hideScreen];
}

-(void)setupDataSource {
    storeItems = [[NSMutableArray alloc] init];
    dataSource = [[NSMutableArray alloc] init];
    CRConfig *config = [CRConfig getInstance];
    PlayerData *data = [PlayerData getInstance];
    NSDictionary *level_data = [config getLevelConfig:data.currentLevel];
    NSArray *tempList = [level_data objectForKey:@"required_ingredients"];
    
    for ( int i = 0; i < [tempList count]; i++ ){
        NSDictionary *dic = [[MotherBrain getInstance] getObjectData:[tempList objectAtIndex:i]];
        int showInStore = [[dic objectForKey:@"showInStore"] boolValue];
        if ( showInStore == 1 ) {
           [storeItems addObject:[tempList objectAtIndex:i]];
        }
    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [storeItems count];
}

- (CRStoreViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CRStoreViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    MotherBrain *mb = [MotherBrain getInstance];

    NSDictionary *def = [mb getObjectData: [storeItems objectAtIndex:indexPath.row]];
    NSArray *animations = [def objectForKey:@"animations"];
    NSDictionary *firstAnimation = [animations objectAtIndex:0];
    
    NSString *prefix = [firstAnimation objectForKey:@"prefix"];
    NSString *atlas = [def objectForKey:@"atlas"];
    
    NSString *filename = [[NSString alloc] initWithFormat:@"%@-1.png",prefix];
    NSString *folder = [[NSString alloc] initWithFormat:@"Assets/%@.atlas",atlas];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:folder];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    [cell setThumb:image andSetLabel:[storeItems objectAtIndex:indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"TOUCHED %@",[storeItems objectAtIndex:indexPath.row]);
}


-(void)showScreen {
    CRConfig *config = [CRConfig getInstance];
    availableFunds.text = [[NSString alloc] initWithFormat:@"Available Funds $%i",config.score];
    self.hidden = NO;
}

-(void)hideScreen {
    WaitTimer *timer = [WaitTimer getInstance];
    [timer resume];
    self.hidden = YES;
}

@end
