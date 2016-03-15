//
//  SCMainViewController.m
//  SCFloatingCellHeaderCollectionView
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 babytree. All rights reserved.
//

#import "SCMainViewController.h"
#import "SCFloatingCellHeaderCollectionView.h"

@interface SCMainViewController ()<SCFloatingCellHeaderCollectionViewDataSource, SCFloatingCellHeaderCollectionViewDelegate>

@property (nonatomic, strong) SCFloatingCellHeaderCollectionView *collectionViewContainer;

@property (nonatomic, strong) NSMutableArray <NSArray <NSString *>*>*models;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionHeaderTitles;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionFooterTitles;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *>*cellIDsAndClassNames;


@end

@implementation SCMainViewController


// default
static NSString *kDefaultSectionHeaderIdentifier = @"DefaultSectionHeaderIdentifier";
static NSString *kDefaultCellHeaderID = @"DefaultCellHeaderID";
static NSString *kDefaultCellIdentifier = @"DefaultCellIdentifier";
static NSString *kDefaultSectionFooterIdentifier = @"DefaultSectionFooterIdentifier";
static NSString *kDefaultSectionSpacingID = @"DefaultSectionSpacingID";


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.models = @[].mutableCopy;
        self.sectionHeaderTitles = @[].mutableCopy;
        self.sectionFooterTitles = @[].mutableCopy;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set up collectionViewContainer
    self.collectionViewContainer = [[SCFloatingCellHeaderCollectionView alloc] initWithFrame:self.view.bounds];
    _collectionViewContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _collectionViewContainer.delegate = self;
    _collectionViewContainer.dataSource = self;
    [self.view addSubview:_collectionViewContainer];
    
    // default
    [self registerDefalutCellsAndSupplemetaryViews];
    // custom
    [self registerCustomCellsAndSupplemetaryViews];
    
    [self handleResponseObj];
}

// default
- (void)registerDefalutCellsAndSupplemetaryViews {
    [_collectionViewContainer registerClass:[SCFCHCollectionViewHeaderFooter class] forSupplementaryViewOfKind:SCCollectionElementKindSectionHeader withReuseIdentifier:kDefaultSectionHeaderIdentifier];
    [_collectionViewContainer registerClass:[SCFCHCollectionViewReusableView class] forSupplementaryViewOfKind:SCCollectionElementKindCellHeader  withReuseIdentifier:kDefaultCellHeaderID];
    [_collectionViewContainer registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultCellIdentifier];
    [_collectionViewContainer registerClass:[SCFCHCollectionViewHeaderFooter class] forSupplementaryViewOfKind:SCCollectionElementKindSectionFooter withReuseIdentifier:kDefaultSectionFooterIdentifier];
    [_collectionViewContainer registerClass:[SCFCHCollectionViewReusableView class] forSupplementaryViewOfKind:SCCollectionElementKindSectionBottomSpacing  withReuseIdentifier:kDefaultSectionSpacingID];
}

// custom
- (void)registerCustomCellsAndSupplemetaryViews {
    
}

- (void)handleResponseObj {
    self.models = @[@[@""], @[@""], @[@""], @[@""], @[@""], @[@"", @"", @""], @[@"", @"", @"",@"", @"", @""], @[@""], @[@"", @"", @""], @[@""], @[@"", @"", @""]].mutableCopy;
    self.sectionHeaderTitles = @[@"", @"", @"", @"", @"", @"11", @"11", @"11", @"11", @"11", @"11"].mutableCopy;
    
    self.sectionFooterTitles = @[@"", @"", @"", @"", @"", @"22", @"22", @"22", @"22", @"", @""].mutableCopy;
    
    [self.collectionViewContainer reloadData];
}

#pragma mark - <SCFloatingCellHeaderCollectionViewDataSource, SCFloatingCellHeaderCollectionViewDelegate>
// 共多少个section
- (NSInteger)numberOfSectionsInCollectionView:(SCFloatingCellHeaderCollectionView *)collectionView {
    return _models.count;
}

// 各section有多少个row
- (NSInteger)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView numberOfRowsInSection:(NSInteger)section {
    return _models[section].count;
}

// 是否有sectionHeader
- (BOOL)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView hasSectionHeaderInSection:(NSInteger)section {
    if (_sectionHeaderTitles[section].length) {
        return YES;
    }
    return NO;
}

// 是否有sectionFooter
- (BOOL)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView hasSectionFooterInSection:(NSInteger)section {
    if (_sectionFooterTitles[section].length) {
        return YES;
    }
    return NO;
}

// cell长什么样，显示什么内容
- (UICollectionViewCell *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

// cellHeader长什么样
- (SCFCHCollectionViewReusableView *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForCellHeaderAtIndexPath:(NSIndexPath *)indexPath {

    SCFCHCollectionViewReusableView *cellHeader = [collectionView dequeueReusableCellSupplementaryViewOfKind:SCCollectionElementKindCellHeader withReuseIdentifier:kDefaultCellHeaderID forIndexPath:indexPath];
    cellHeader.backgroundColor = [UIColor greenColor];
    return cellHeader;
}

// sectionHeader长什么样
- (SCFCHCollectionViewHeaderFooter *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForHeaderInSection:(NSInteger)section {

    return [collectionView dequeueReusableSectionHeaderFooterOfKind:SCCollectionElementKindSectionHeader withReuseIdentifier:kDefaultSectionHeaderIdentifier inSection:section];
}

// sectionFooter长什么样
- (SCFCHCollectionViewHeaderFooter *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForFooterInSection:(NSInteger)section {

    return [collectionView dequeueReusableSectionHeaderFooterOfKind:SCCollectionElementKindSectionFooter withReuseIdentifier:kDefaultSectionFooterIdentifier inSection:section];
}

// SectionBottomSpacing
- (SCFCHCollectionViewReusableView *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForSectionBottomSpacingInSection:(NSInteger)section {
    
    return [collectionView dequeueReusableSectionSupplementaryViewOfKind:SCCollectionElementKindSectionBottomSpacing withReuseIdentifier:kDefaultSectionSpacingID inSection:section];
}

// cell高度
- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

// cellHeader高度
- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForCellHeaderAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

// sectionHeader的高度
- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

// sectionFooter的高度
- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForFooterInSection:(NSInteger)section {
    return 36;
}

// SectionBottomSpacing高度
- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForSectionBottomSpacingInSection:(NSInteger)section {

    return 8;

}

- (void)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     NSLog(@"%g", scrollView.contentOffset.y);
}



@end
