//
//  SCFloatingCellHeaderCollectionView.h
//  pregnancy
//
//  Created by ShannonChen on 16/3/7.
//  Copyright © 2016年 babytree. All rights reserved.



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const SCCollectionElementKindSectionHeader NS_AVAILABLE_IOS(6_0);
UIKIT_EXTERN NSString *const SCCollectionElementKindSectionFooter NS_AVAILABLE_IOS(6_0);
UIKIT_EXTERN NSString *const SCCollectionElementKindCellHeader NS_AVAILABLE_IOS(6_0);
UIKIT_EXTERN NSString *const SCCollectionElementKindSectionBottomSpacing NS_AVAILABLE_IOS(6_0);

@class SCFloatingCellHeaderCollectionView;
@class SCFCHCollectionViewHeaderFooter;
@class SCFCHCollectionViewReusableView;

//_______________________________________________________________________________________________________________
// this represents the display and behaviour of the cells.

@protocol SCFloatingCellHeaderCollectionViewDelegate <UIScrollViewDelegate>

@optional
// Variable height support

- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;  // cell height, default is 44

- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForCellHeaderAtIndexPath:(NSIndexPath *)indexPath; // floating cell header height, default is 0

- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForHeaderInSection:(NSInteger)section; // section header height, default is 0

- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForFooterInSection:(NSInteger)section; // section footer height default is 0

- (CGFloat)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView heightForSectionBottomSpacingInSection:(NSInteger)section; // section bottom spacing height, default is 0


// cell selection

- (void)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; // called when a cell was selected

@end



//_______________________________________________________________________________________________________________
// this protocol represents the data model object. as such, it supplies no information about appearance (including the cells)
@protocol SCFloatingCellHeaderCollectionViewDataSource <NSObject>

@required

- (NSInteger)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView numberOfRowsInSection:(NSInteger)section; // tells the data source to return the number of rows in a given section of a collection view.

// A configured cell object. You must not return nil from this method.
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInCollectionView:(SCFloatingCellHeaderCollectionView *)collectionView; // default is 1 if not implemented

- (BOOL)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView hasSectionHeaderInSection:(NSInteger)section; // asks the data source whether a section has section header or not, default value is NO

- (BOOL)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView hasSectionFooterInSection:(NSInteger)section; // asks the data source whether a section has section footer or not, default value is NO

// A configured section header object. You must not return nil from this method.
// The section header that is returned must be retrieved from a call to
// -dequeueReusableSectionHeaderFooterOfKind:withReuseIdentifier:inSection:
- (SCFCHCollectionViewHeaderFooter *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForHeaderInSection:(NSInteger)section;

// A configured section footer object. You must not return nil from this method.
// The section footer that is returned must be retrieved from a call to
// -dequeueReusableSectionHeaderFooterOfKind:withReuseIdentifier:inSection:
- (SCFCHCollectionViewHeaderFooter *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForFooterInSection:(NSInteger)section;


// Section bottom spacing and floating cell header information.

// Custom view for floating cell header. will be adjusted to default or specified cell header height.
// You must not return nil from this method.
- (SCFCHCollectionViewReusableView *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForCellHeaderAtIndexPath:(NSIndexPath *)indexPath;

// custom view for section bottom spacing. will be adjusted to default or specified section bottom spacing height.
// You must not return nil from this method.
- (SCFCHCollectionViewReusableView *)collectionView:(SCFloatingCellHeaderCollectionView *)collectionView viewForSectionBottomSpacingInSection:(NSInteger)section;

@end


//_______________________________________________________________________________________________________________

// A custom UICollectionView wrapper with floating cell header effect, and it has UICollectionView-like API.
// Important: SCFloatingCellHeaderCollectionView is not a subclass of UICollectionView, it inherits from UIView directly.

/**
             SCFloatingCellHeaderCollectionView
                    │===============│
                    │ sectionHeader │  ——————>  section
                    │===============│
                    │  cellHeader   │
                    │- — — — — — — —│  ——————>   row
                    │     row       │
                    │———————————————│
                    │  cellHeader   │
                    │— — — — — — — —│  ——————>   row
                    │     row       │
                    │———————————————│
                    │  cellHeader   │
                    │— — — — — — — —│  ——————>   row
                    │     row       │
                    │===============│
                    │ sectionFooter │
                    │— — — — — — — —│  ——————>  section
                    │section spacing│
                    │===============│
 
 */
NS_CLASS_AVAILABLE_IOS(6_0) @interface SCFloatingCellHeaderCollectionView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak, nullable) id<SCFloatingCellHeaderCollectionViewDelegate> delegate;
@property (nonatomic, weak, nullable) id<SCFloatingCellHeaderCollectionViewDataSource> dataSource;

@property (nonatomic, strong, nullable) __kindof UICollectionView *collectionView;


// Register

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(nullable Class)cellClass forSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier;

// Dequeue

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath; // Cell
- (__kindof SCFCHCollectionViewHeaderFooter *)dequeueReusableSectionHeaderFooterOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier inSection:(NSInteger)section; // Either the header or footer for a section
- (__kindof SCFCHCollectionViewReusableView *)dequeueReusableCellSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath; //  Cell header
- (__kindof SCFCHCollectionViewReusableView *)dequeueReusableSectionSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier inSection:(NSInteger)section; // The bottom spacing for a section


// Reload data for collection view.
// Important: you should never call the method -realoadData of property 'collectionView' directly.
- (void)reloadData;

@end



//_______________________________________________________________________________________________________________

NS_CLASS_AVAILABLE_IOS(6_0) @interface SCFCHCollectionViewCell : UICollectionViewCell
@end

// Either the header or footer for a section
NS_CLASS_AVAILABLE_IOS(6_0) @interface SCFCHCollectionViewHeaderFooter : UICollectionViewCell
@end

// Cell header or the bottom spacing for a section
NS_CLASS_AVAILABLE_IOS(6_0) @interface SCFCHCollectionViewReusableView : UICollectionReusableView
@end



//_______________________________________________________________________________________________________________
// Add separator for cells and supplementary views
@interface UIView (SCSeparator)
- (void)sc_addTopSeparator;
- (void)sc_addBottomSeparator;
@end

NS_ASSUME_NONNULL_END