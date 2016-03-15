//
//  SCFloatingCellHeaderCollectionView.m
//  pregnancy
//
//  Created by ShannonChen on 16/3/7.
//  Copyright © 2016年 babytree. All rights reserved.
//

#import "SCFloatingCellHeaderCollectionView.h"
#import "SCCollectionViewFloatingHeaderLayout.h"

NSString *const SCCollectionElementKindSectionHeader = @"SCCollectionElementKindSectionHeader";
NSString *const SCCollectionElementKindSectionFooter = @"SCCollectionElementKindSectionFooter";
NSString *const SCCollectionElementKindCellHeader = @"SCCollectionElementKindCellHeader";
NSString *const SCCollectionElementKindSectionBottomSpacing = @"SCCollectionElementKindSectionBottomSpacing";

@interface SCFloatingCellHeaderCollectionView () 

@property (nonatomic, strong) NSMutableDictionary <NSIndexPath * , NSIndexPath *>*fakeRealIndexPathMapper;
@property (nonatomic, strong) NSMutableDictionary <NSNumber * , NSIndexPath *>*fakeRealSectionHeaderMapper;
@property (nonatomic, strong) NSMutableDictionary <NSNumber * , NSIndexPath *>*fakeRealSectionFooterMapper;

@property (nonatomic, strong) NSMutableDictionary <NSIndexPath * , NSIndexPath *>*realFakeIndexPathMapper;
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath * , NSNumber *>*realFakeSectionHeaderMapper;
@property (nonatomic, strong) NSMutableDictionary <NSIndexPath * , NSNumber *>*realFakeSectionFooterMapper;

@property (nonatomic, assign) NSInteger numberOfSections;

@end

@implementation SCFloatingCellHeaderCollectionView

static NSString *const kDefaultCellIdentifier = @"kSCFCHCollectionViewCellIdentifier";
static NSString *const kDefaultSectionHeaderIdentifier = @"kSCFCHCollectionViewSectionHeaderIdentifier";
static NSString *const kDefaultSectionFooterIdentifier = @"kSCFCHCollectionViewSectionFooterIdentifier";
static CGFloat const kDefaultCellHeight = 44.0;


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _fakeRealIndexPathMapper = [NSMutableDictionary dictionary];
        _fakeRealSectionHeaderMapper = [NSMutableDictionary dictionary];
        _fakeRealSectionFooterMapper = [NSMutableDictionary dictionary];
        
        _realFakeIndexPathMapper = [NSMutableDictionary dictionary];
        _realFakeSectionHeaderMapper = [NSMutableDictionary dictionary];
        _realFakeSectionFooterMapper = [ NSMutableDictionary dictionary];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self p_layout]];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        // default
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kDefaultCellIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDefaultSectionHeaderIdentifier];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kDefaultSectionFooterIdentifier];
    }
    
    return _collectionView;
}

#pragma mark - **************************** Private Methods *************************** -
- (UICollectionViewLayout *)p_layout {
    SCCollectionViewFloatingHeaderLayout *layout = [SCCollectionViewFloatingHeaderLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return layout;
}

- (void)p_fakeToRealIndexPathConversion {
    
    /* 算出所提供的indexPath 对应collectionView的哪个item(section)
     
            SCFloatingCellHeaderCollectionView                  UICollectionView
                     │===============│                           |===============|
        section      │ sectionHeader │     ------------>         | item(section) |    indexPath.section
                     │===============│                           |———————————————|
                     │  cellHeader   │     ------------>         | sectionHeader |
      section-row    │— — — — — — — —│                           |— — — — — — — —|    indexPath.section
                     │     row       │     ------------>         | item(section) |
                     │———————————————│                           |———————————————|
                     │  cellHeader   │     ------------>         | sectionHeader |
      section-row    │— — — — — — — —│                           |— — — — — — — —|    indexPath.section
                     │     row       │     ------------>         | item(section) |
                     │———————————————│                           |———————————————|
                     │  cellHeader   │     ------------>         | sectionHeader |
      section-row    │— — — — — — — —│                           |— — — — — — — —|    indexPath.section
                     │     row       │     ------------>         | item(section) |
                     │===============│                           |———————————————|
                     │ sectionFooter │     ------------>         | item(section) |
        section      │— — — — — — — —│                           |— — — — — — — —|    indexPath.section
                     │section spacing│     ------------>         | sectionFooter |
                     │===============│                           |===============|
     
     section spacing 也有可能连在row下面
     */
    
    [self.fakeRealIndexPathMapper removeAllObjects];
    [self.fakeRealSectionHeaderMapper removeAllObjects];
    [self.fakeRealSectionFooterMapper removeAllObjects];
    
    [self.realFakeIndexPathMapper removeAllObjects];
    [self.realFakeSectionHeaderMapper removeAllObjects];
    [self.realFakeSectionFooterMapper removeAllObjects];
    
    NSIndexPath *fakeIndexPath;
    NSIndexPath *realIndexPath;
    
    // 1.拿到所有section的数量
    NSInteger numberOfFakeSections = 1;
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        numberOfFakeSections = [_dataSource numberOfSectionsInCollectionView:self];
    }
    NSInteger currentSection = -1; // 一边快速枚举，一边统计当前item的位置
    for (NSInteger section = 0; section < numberOfFakeSections; section++) {
        // 1.1 如果有sectionHeader的话，currentSection加1
        if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionHeaderInSection:)]) {
            if ([_dataSource collectionView:self hasSectionHeaderInSection:section]) { // sectionHeader实际上也是个item
                currentSection++;
                realIndexPath = [NSIndexPath indexPathForItem:0 inSection:currentSection];
                self.fakeRealSectionHeaderMapper[@(section)] = realIndexPath;
                self.realFakeSectionHeaderMapper[realIndexPath] = @(section);
            }
        }
        // 1.2 拿到所有row的数量
        NSInteger numberOfRowsInSection = 0;
        if ([_dataSource respondsToSelector:@selector(collectionView:numberOfRowsInSection:)]) {
            numberOfRowsInSection = [_dataSource collectionView:self numberOfRowsInSection:section];
        }
        for (NSInteger row = 0; row < numberOfRowsInSection; row++) {
            currentSection++;
            fakeIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
            realIndexPath = [NSIndexPath indexPathForItem:0 inSection:currentSection];
            self.fakeRealIndexPathMapper[fakeIndexPath] = realIndexPath;
            self.realFakeIndexPathMapper[realIndexPath] = fakeIndexPath;
        }
        // 1.3 如果有sectionFooter的话，currentSection加1
        if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionFooterInSection:)] && [_dataSource collectionView:self hasSectionFooterInSection:section]) {
            currentSection++;
            realIndexPath = [NSIndexPath indexPathForItem:0 inSection:currentSection];
            self.fakeRealSectionFooterMapper[@(section)] = realIndexPath;
            self.realFakeSectionFooterMapper[realIndexPath] = @(section);
        }
    }
    
    self.numberOfSections = currentSection + 1;
}

#pragma mark - **************************** Public Methods ***************************
#pragma mark - Methods for register reusable views
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)viewClass forSupplementaryViewOfKind:(nonnull NSString *)elementKind withReuseIdentifier:(nonnull NSString *)identifier {
    if (elementKind == SCCollectionElementKindSectionHeader || elementKind == SCCollectionElementKindSectionFooter) {
        [self.collectionView registerClass:viewClass forCellWithReuseIdentifier:identifier];
        
    } else if (elementKind == SCCollectionElementKindCellHeader) {
        [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
        
    } else if (elementKind == SCCollectionElementKindSectionBottomSpacing) {
        [self.collectionView registerClass:viewClass forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier];
    }
    
}

#pragma mark - Methods for dequeue reusable views
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {

    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:self.fakeRealIndexPathMapper[indexPath]];
}

// Either the header or footer for a section
- (SCFCHCollectionViewHeaderFooter *)dequeueReusableSectionHeaderFooterOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier inSection:(NSInteger)section {
    if (elementKind == SCCollectionElementKindSectionHeader) {

        return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:self.fakeRealSectionHeaderMapper[@(section)]];
        
    } else if (elementKind == SCCollectionElementKindSectionFooter) {

        return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:self.fakeRealSectionFooterMapper[@(section)]];
        
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid element kind" userInfo:nil];
    }
}

//  Cell header
- (SCFCHCollectionViewReusableView *)dequeueReusableCellSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {

    if (elementKind == SCCollectionElementKindCellHeader) {
        return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:self.fakeRealIndexPathMapper[indexPath]];
        
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid element kind" userInfo:nil];
    }
}

// The bottom spacing for a section
- (SCFCHCollectionViewReusableView *)dequeueReusableSectionSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier inSection:(NSInteger)section {
    
    NSInteger lastRowIdx = 0;
    NSIndexPath *realIndexPath = nil;
    
    // 先判断是否有sectionFooter
    if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionFooterInSection:)]) {
        realIndexPath = self.fakeRealSectionFooterMapper[@(section)];
    }
    
    // 该section有多少row
    if (!realIndexPath && [_dataSource respondsToSelector:@selector(collectionView:numberOfRowsInSection:)]) {
        lastRowIdx = [_dataSource collectionView:self numberOfRowsInSection:section] - 1;
        NSIndexPath *fakeIndexPath = [NSIndexPath indexPathForRow:lastRowIdx inSection:section];
        
        realIndexPath = self.fakeRealIndexPathMapper[fakeIndexPath];
    }

    if (elementKind == SCCollectionElementKindSectionBottomSpacing) {
        return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:realIndexPath];
        
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid element kind" userInfo:nil];
    }
}

#pragma mark - reload data
- (void)reloadData {
    // 转换indexPath
    [self p_fakeToRealIndexPathConversion];
    
    [self.collectionView reloadData];
}

#pragma mark - **************************** Delegate Methods ***************************
#pragma mark - <UICollectionViewDataSource>
// 每个section只有一个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

// 这里的一个section其实就是一个item
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    /* 算出与sectionHeader、row和sectionFooter对应的，共有多少个item
     
         SCFloatingCellHeaderCollectionView                  UICollectionView
              _______________                             _______________
             | sectionHeader |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             |     row       |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             |     row       |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             | sectionHeader |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             |     row       |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             |     row       |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             | sectionFooter |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
     */


    return self.numberOfSections;
}

// A configured cell object. You must not return nil from this method.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    /* 算出当前indexPath.item 对应哪个section的哪个row
     
        SCFloatingCellHeaderCollectionView                  UICollectionView
                 _______________                             _______________
                | sectionHeader |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
                |     row       |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
                |     row       |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
                | sectionHeader |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
                |     row       |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
                |     row       |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
                | sectionFooter |     ------------>         | item(section) |
                |———————————————|                           |———————————————|
     */
    if (self.realFakeSectionHeaderMapper[indexPath]) {
        NSInteger fakeSection = self.realFakeSectionHeaderMapper[indexPath].integerValue;
        if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionHeaderInSection:)] &&
            [_dataSource collectionView:self hasSectionHeaderInSection:fakeSection] &&
            [_dataSource respondsToSelector:@selector(collectionView:viewForHeaderInSection:)]) {
            UICollectionViewCell *sectionHeader = [_dataSource collectionView:self viewForHeaderInSection:fakeSection];
            if (sectionHeader) {
                return sectionHeader;
            }
            NSLog(@"Error: returned section feader is nil");
        }
    } else if (self.realFakeSectionFooterMapper[indexPath]) {
        NSInteger fakeSection = self.realFakeSectionFooterMapper[indexPath].integerValue;
        if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionFooterInSection:)] &&
            [_dataSource collectionView:self hasSectionFooterInSection:fakeSection] &&
            [_dataSource respondsToSelector:@selector(collectionView:viewForFooterInSection:)]) {
            UICollectionViewCell *sectionFooter = [_dataSource collectionView:self viewForFooterInSection:fakeSection];
            if (sectionFooter) {
                return sectionFooter;
            }
            NSLog(@"Error: returned section footer is nil");
        }
    } else if (self.realFakeIndexPathMapper[indexPath]) {
        NSIndexPath *fakeIndexPath = self.realFakeIndexPathMapper[indexPath];
        if ([_dataSource respondsToSelector:@selector(collectionView:cellForRowAtIndexPath:)]) {
            UICollectionViewCell *cell = [_dataSource collectionView:self cellForRowAtIndexPath:fakeIndexPath];
            if (cell) {
                return cell;
            }
            NSLog(@"Error: returned cell is nil");
        }
    }
    
    // default empty cell
    return [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier forIndexPath:indexPath];
}

// A configured supplementary view object. You must not return nil from this method.
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    /* 算出当前indexPath 对应哪个section的哪个row
     SCFloatingCellHeaderCollectionView                  UICollectionView
             |===============|                           |===============|
             | sectionHeader |     ------------>         | item(section) |    indexPath.section
             |===============|                           |———————————————|
             |  cellHeader   |     ------------>         | sectionHeader |
             |— — — — — — — —|                           |— — — — — — — —|    indexPath.section
             |     row       |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             |  cellHeader   |     ------------>         | sectionHeader |
             |— — — — — — — —|                           |— — — — — — — —|    indexPath.section
             |     row       |     ------------>         | item(section) |
             |———————————————|                           |———————————————|
             |  cellHeader   |     ------------>         | sectionHeader |
             |— — — — — — — —|                           |— — — — — — — —|    indexPath.section
             |     row       |     ------------>         | item(section) |
             |===============|                           |———————————————|
             | sectionFooter |     ------------>         | item(section) |
             |===============|                           |— — — — — — — —|    indexPath.section
             |section spacing|     ------------>         | sectionFooter |
             |===============|                           |===============|
     */
    
    NSIndexPath *fakeIndexPath = self.realFakeIndexPathMapper[indexPath];   // 如果没有SectionFooter
    NSNumber *fakeSectionNum = self.realFakeSectionFooterMapper[indexPath]; // 如果有SectionFooter
    NSInteger fakeSection = 0;

    if (fakeSectionNum) {                // 先计算有SectionFooter的情况
        fakeSection = fakeSectionNum.integerValue;
    } else if (fakeIndexPath) {        // 如果没有SectionFooter，再考虑row
        fakeSection = fakeIndexPath.section;
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        if (fakeIndexPath && [_dataSource respondsToSelector:@selector(collectionView:viewForCellHeaderAtIndexPath:)]) {
                UICollectionReusableView *cellHeader = [_dataSource collectionView:self viewForCellHeaderAtIndexPath:fakeIndexPath];
            if (cellHeader) return cellHeader;
            NSLog(@"Error: returned Cell Header is nil");
        }

        // default empty UICollectionReusableView
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kDefaultSectionHeaderIdentifier forIndexPath:indexPath];
        
    } else if (kind == UICollectionElementKindSectionFooter) {
        if ((fakeIndexPath || fakeSectionNum) &&
            [_dataSource respondsToSelector:@selector(collectionView:viewForSectionBottomSpacingInSection:)]) {
            UICollectionReusableView *sectionSpacing =  [_dataSource collectionView:self viewForSectionBottomSpacingInSection:fakeSection];
            if (sectionSpacing) return sectionSpacing;
            NSLog(@"Error: returned Section Bottom Spacing View is nil");
        }
        // default empty UICollectionReusableView
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kDefaultSectionFooterIdentifier forIndexPath:indexPath];
        
    } else {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unknown kind of supplementary view" userInfo:nil];
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.realFakeIndexPathMapper[indexPath]) { // 选中的是fakeCell而不是fakeSectionHeader或fakeSectionFooter
        NSIndexPath *fakeIndexPath = self.realFakeIndexPathMapper[indexPath];
        if ([_delegate respondsToSelector:@selector(collectionView:didSelectRowAtIndexPath:)]) {
            [_delegate collectionView:self didSelectRowAtIndexPath:fakeIndexPath];
        }
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
// The width and height of the specified item. Both values must be greater than 0.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    CGFloat cellHeight = kDefaultCellHeight;  // 44
    if (self.realFakeSectionHeaderMapper[indexPath]) {
        NSInteger fakeSection = self.realFakeSectionHeaderMapper[indexPath].integerValue;
        if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionHeaderInSection:)] &&
            [_dataSource collectionView:self hasSectionHeaderInSection:fakeSection]) {
            if ([_delegate respondsToSelector:@selector(collectionView:heightForHeaderInSection:)]) {
                cellHeight = [_delegate collectionView:self heightForHeaderInSection:fakeSection];
            }
        }
    } else if (self.realFakeSectionFooterMapper[indexPath]) {
        NSInteger fakeSection = self.realFakeSectionFooterMapper[indexPath].integerValue;
        if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionFooterInSection:)] &&
            [_dataSource collectionView:self hasSectionFooterInSection:fakeSection]) {
            if ([_delegate respondsToSelector:@selector(collectionView:heightForFooterInSection:)]) {
                cellHeight = [_delegate collectionView:self heightForFooterInSection:fakeSection];
            }
        }
    } else if (self.realFakeIndexPathMapper[indexPath]) {
        NSIndexPath *fakeIndexPath = self.realFakeIndexPathMapper[indexPath];
        if ([_delegate respondsToSelector:@selector(collectionView:heightForRowAtIndexPath:)]) {
            cellHeight = [_delegate collectionView:self heightForRowAtIndexPath:fakeIndexPath];
        }
    }
    
    return CGSizeMake(collectionView.bounds.size.width, cellHeight);
}

// The size of the header. If you return a value of size (0, 0), no header is added.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    NSIndexPath *realIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    NSIndexPath *fakeIndexPath = self.realFakeIndexPathMapper[realIndexPath];
    
    if (fakeIndexPath && [_delegate respondsToSelector:@selector(collectionView:heightForCellHeaderAtIndexPath:)]
        && [_delegate collectionView:self heightForCellHeaderAtIndexPath:fakeIndexPath]) {
        CGFloat cellHeaderheight = [_delegate collectionView:self heightForCellHeaderAtIndexPath:fakeIndexPath];
        return CGSizeMake(collectionView.bounds.size.width, cellHeaderheight);
    }
    
    return CGSizeZero;
}

// The size of the footer. If you return a value of size (0, 0), no footer is added.
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    NSIndexPath *realIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    NSIndexPath *fakeIndexPath = self.realFakeIndexPathMapper[realIndexPath];   // 如果没有SectionFooter
    NSNumber *fakeSectionNum = self.realFakeSectionFooterMapper[realIndexPath]; // 如果有SectionFooter
    
    // 当前section(item)属于哪个fakeSection
    NSInteger fakeSection = 0;
    if (fakeSectionNum) {                // 先计算有SectionFooter的情况
        fakeSection = fakeSectionNum.integerValue;
    } else if (fakeIndexPath) {        // 如果没有SectionFooter，再考虑row
        fakeSection = fakeIndexPath.section;
    } else {
        return CGSizeZero;
    }
    
    // 找出fakeSection的最后一个row或者sectionFooter
    NSInteger targetSection = NSIntegerMax;
    if ([_dataSource respondsToSelector:@selector(collectionView:hasSectionFooterInSection:)] && [_dataSource collectionView:self hasSectionFooterInSection:fakeSection]) {
        targetSection = self.fakeRealSectionFooterMapper[@(fakeSection)].section;
    }
    
    NSInteger numberOfRows = 0;
    if ([_dataSource respondsToSelector:@selector(collectionView:numberOfRowsInSection:)]) { // 该fakeSection有多少row
        numberOfRows = [_dataSource collectionView:self numberOfRowsInSection:fakeSection];
    }
    if (numberOfRows && targetSection == NSIntegerMax) { // 如果没有SectionFooter，再考虑row
        NSIndexPath *IndexPathOfLastRow = [NSIndexPath indexPathForRow:(numberOfRows - 1) inSection:fakeSection];
        targetSection = self.fakeRealIndexPathMapper[IndexPathOfLastRow].section;
    }
    
    // 只有fakeSection的最后一个row或者sectionFooter才需要显示
    if (targetSection == section &&
        [_delegate respondsToSelector:@selector(collectionView:heightForSectionBottomSpacingInSection:)] &&
        [_delegate collectionView:self heightForSectionBottomSpacingInSection:fakeSection]) {
        
        CGFloat sectionSpacingHeight = [_delegate collectionView:self heightForSectionBottomSpacingInSection:fakeSection];
        return CGSizeMake(collectionView.bounds.size.width, sectionSpacingHeight);
    }
    
    return CGSizeZero;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

@end



#pragma mark - @implementation SCFCHCollectionViewCell -
//_______________________________________________________________________________________________________________

@implementation SCFCHCollectionViewCell
@end
#pragma mark - @implementation SCFCHCollectionViewHeaderFooter -
@implementation SCFCHCollectionViewHeaderFooter
@end
#pragma mark - @implementation SCFCHCollectionViewReusableView -
@implementation SCFCHCollectionViewReusableView
@end



#pragma mark - @implementation UIView (SCSeparator) -
//_______________________________________________________________________________________________________________

@implementation UIView (SCSeparator)

- (void)sc_addTopSeparator {
    [self p_addSpeparatorWithOriginY:0];
}

- (void)sc_addBottomSeparator  {
    [self p_addSpeparatorWithOriginY:self.height - POINTS_FROM_PIXELS(0.5)];
}

- (void)p_addSpeparatorWithOriginY:(CGFloat)originY {
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.width, POINTS_FROM_PIXELS(0.5))];
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin |
                                  UIViewAutoresizingFlexibleBottomMargin;
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self addSubview:bottomLine];
}

@end
