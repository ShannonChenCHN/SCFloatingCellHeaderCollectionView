//
//  SCMainViewController.m
//  SCStickyCellHeaderCollectionView
//
//  Created by ShannonChen on 16/3/15.
//  Copyright © 2016年 babytree. All rights reserved.
//

#import "SCMainViewController.h"
#import "SCStickyCellHeaderCollectionView.h"

#import "SCCell.h"
#import "SCCellHeader.h"
#import "SCSectionHeader.h"
#import "SCSectionFooter.h"
#import "SCSectionSpacing.h"

@interface SCMainViewController ()<SCStickyCellHeaderCollectionViewDataSource, SCStickyCellHeaderCollectionViewDelegate>

@property (nonatomic, strong) SCStickyCellHeaderCollectionView *collectionViewContainer;

@property (nonatomic, strong) NSMutableArray <NSArray <NSString *>*>*models;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionHeaderTitles;
@property (nonatomic, strong) NSMutableArray <NSString *>*sectionFooterTitles;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSString *>*cellIDsAndClassNames;


@end

@implementation SCMainViewController


// default
static NSString *kDefaultSectionHeaderIdentifier = @"DefaultSectionHeaderIdentifier";
static NSString *kDefaultCellHeaderIdentifier = @"DefaultCellHeaderIdentifier";
static NSString *kDefaultCellIdentifier = @"DefaultCellIdentifier";
static NSString *kDefaultSectionFooterIdentifier = @"DefaultSectionFooterIdentifier";
static NSString *kDefaultSectionSpacingIdentifier = @"DefaultSectionSpacingIdentifier";

// custom
static NSString *kSCSectionHeaderIdentifier = @"SCSectionHeaderIdentifier";
static NSString *kSCCellHeaderIdentifier = @"SCCellHeaderIdentifier";
static NSString *kSCCellIdentifier = @"SCCellIdentifier";
static NSString *kSCSectionFooterIdentifier = @"SCSectionFooterIdentifier";
static NSString *kSCSectionSpacingIdentifier = @"SCSectionSpacingIdentifier";


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
    self.collectionViewContainer = [[SCStickyCellHeaderCollectionView alloc] initWithFrame:self.view.bounds];
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

// default, must implement.
- (void)registerDefalutCellsAndSupplemetaryViews {
    [_collectionViewContainer registerClass:[SCSCHCollectionViewHeaderFooter class] forSupplementaryViewOfKind:SCCollectionElementKindSectionHeader withReuseIdentifier:kDefaultSectionHeaderIdentifier];
    [_collectionViewContainer registerClass:[SCSCHCollectionViewReusableView class] forSupplementaryViewOfKind:SCCollectionElementKindCellHeader  withReuseIdentifier:kDefaultCellHeaderIdentifier];
    [_collectionViewContainer registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultCellIdentifier];
    [_collectionViewContainer registerClass:[SCSCHCollectionViewHeaderFooter class] forSupplementaryViewOfKind:SCCollectionElementKindSectionFooter withReuseIdentifier:kDefaultSectionFooterIdentifier];
    [_collectionViewContainer registerClass:[SCSCHCollectionViewReusableView class] forSupplementaryViewOfKind:SCCollectionElementKindSectionBottomSpacing  withReuseIdentifier:kDefaultSectionSpacingIdentifier];
}

// custom
- (void)registerCustomCellsAndSupplemetaryViews {
    [_collectionViewContainer registerClass:[SCSectionHeader class] forSupplementaryViewOfKind:SCCollectionElementKindSectionHeader withReuseIdentifier:kSCSectionHeaderIdentifier];
    [_collectionViewContainer registerClass:[SCCellHeader class] forSupplementaryViewOfKind:SCCollectionElementKindCellHeader  withReuseIdentifier:kSCCellHeaderIdentifier];
    [_collectionViewContainer registerClass:[SCCell class] forCellWithReuseIdentifier:kSCCellIdentifier];
    [_collectionViewContainer registerClass:[SCSectionFooter class] forSupplementaryViewOfKind:SCCollectionElementKindSectionFooter withReuseIdentifier:kSCSectionFooterIdentifier];
    [_collectionViewContainer registerClass:[SCSectionSpacing class] forSupplementaryViewOfKind:SCCollectionElementKindSectionBottomSpacing  withReuseIdentifier:kSCSectionSpacingIdentifier];
}

- (void)handleResponseObj {
    self.models = @[@[@""], @[@""], @[@""], @[@""], @[@""], @[@"", @"", @""], @[@"", @"", @"",@"", @"", @""], @[@""], @[@"", @"", @""], @[@""], @[@"", @"", @""]].mutableCopy;
    self.sectionHeaderTitles = @[@"11", @"", @"22", @"", @"", @"11", @"11", @"11", @"11", @"11", @"11"].mutableCopy;
    
    self.sectionFooterTitles = @[@"", @"", @"", @"", @"", @"22", @"22", @"22", @"22", @"", @""].mutableCopy;
    
    [self.collectionViewContainer reloadData]; // never call the method -realoadData of property 'collectionView' directly.
}

#pragma mark - <SCStickyCellHeaderCollectionViewDataSource, SCStickyCellHeaderCollectionViewDelegate>
// 共多少个section
- (NSInteger)numberOfSectionsInCollectionView:(SCStickyCellHeaderCollectionView *)collectionView {
    return _models.count;
}

// 各section有多少个row
- (NSInteger)collectionView:(SCStickyCellHeaderCollectionView *)collectionView numberOfRowsInSection:(NSInteger)section {
    return _models[section].count;
}

// 是否有sectionHeader
- (BOOL)collectionView:(SCStickyCellHeaderCollectionView *)collectionView hasSectionHeaderInSection:(NSInteger)section {
    if (_sectionHeaderTitles[section].length) {
        return YES;
    }
    return NO;
}

// 是否有sectionFooter
- (BOOL)collectionView:(SCStickyCellHeaderCollectionView *)collectionView hasSectionFooterInSection:(NSInteger)section {
    if (_sectionFooterTitles[section].length) {
        return YES;
    }
    return NO;
}

// cell长什么样，显示什么内容
- (UICollectionViewCell *)collectionView:(SCStickyCellHeaderCollectionView *)collectionView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSCCellIdentifier forIndexPath:indexPath];
    [cell setTitle:[NSString stringWithFormat:@"Cell: Section%li - Row%li", indexPath.section, indexPath.row]];
    return cell;
}

// cellHeader长什么样
- (SCSCHCollectionViewReusableView *)collectionView:(SCStickyCellHeaderCollectionView *)collectionView viewForCellHeaderAtIndexPath:(NSIndexPath *)indexPath {

    if (_models[indexPath.section].count > 1) {
        SCCellHeader *cellHeader = [collectionView dequeueReusableCellSupplementaryViewOfKind:SCCollectionElementKindCellHeader withReuseIdentifier:kSCCellHeaderIdentifier forIndexPath:indexPath];

        [cellHeader setTitle:[NSString stringWithFormat:@"Sticky Cell Header: Section%li - Row%li", indexPath.section, indexPath.row]];
        return cellHeader;
    } else {
        return [collectionView dequeueReusableCellSupplementaryViewOfKind:SCCollectionElementKindCellHeader withReuseIdentifier:kDefaultCellHeaderIdentifier forIndexPath:indexPath];
    }
}

// sectionHeader长什么样
- (SCSCHCollectionViewHeaderFooter *)collectionView:(SCStickyCellHeaderCollectionView *)collectionView viewForHeaderInSection:(NSInteger)section {

    SCSectionHeader *sectionHeader = [collectionView dequeueReusableSectionHeaderFooterOfKind:SCCollectionElementKindSectionHeader withReuseIdentifier:kSCSectionHeaderIdentifier inSection:section];
    [sectionHeader setTitle:[NSString stringWithFormat:@"Section Header : %li", section]];
    return sectionHeader;
}

// sectionFooter长什么样
- (SCSCHCollectionViewHeaderFooter *)collectionView:(SCStickyCellHeaderCollectionView *)collectionView viewForFooterInSection:(NSInteger)section {

    SCSectionFooter *sectionFooter = [collectionView dequeueReusableSectionHeaderFooterOfKind:SCCollectionElementKindSectionFooter withReuseIdentifier:kSCSectionFooterIdentifier inSection:section];
    return sectionFooter;
}

// SectionBottomSpacing
- (SCSCHCollectionViewReusableView *)collectionView:(SCStickyCellHeaderCollectionView *)collectionView viewForSectionBottomSpacingInSection:(NSInteger)section {
    
    SCSectionSpacing *spacing = [collectionView dequeueReusableSectionSupplementaryViewOfKind:SCCollectionElementKindSectionBottomSpacing withReuseIdentifier:kSCSectionSpacingIdentifier inSection:section];
    return spacing;
}

// cell高度
- (CGFloat)collectionView:(SCStickyCellHeaderCollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

// cellHeader高度
- (CGFloat)collectionView:(SCStickyCellHeaderCollectionView *)collectionView heightForCellHeaderAtIndexPath:(NSIndexPath *)indexPath {
    if (_models[indexPath.section].count > 1) {
        return 40;
    }
    return 0;
}

// sectionHeader的高度
- (CGFloat)collectionView:(SCStickyCellHeaderCollectionView *)collectionView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

// sectionFooter的高度
- (CGFloat)collectionView:(SCStickyCellHeaderCollectionView *)collectionView heightForFooterInSection:(NSInteger)section {
    return 36;
}

// SectionBottomSpacing高度
- (CGFloat)collectionView:(SCStickyCellHeaderCollectionView *)collectionView heightForSectionBottomSpacingInSection:(NSInteger)section {

    return 8;

}

- (void)collectionView:(SCStickyCellHeaderCollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
     NSLog(@"%g", scrollView.contentOffset.y);
}



@end
