# SCStickyCellHeaderCollectionView
A custom UICollectionView wrapper with stickey "cell" header effect, and it has UICollectionView-like API.


* **Important: SCStickeyCellHeaderCollectionView is not a subclass of UICollectionView, it inherits from UIView directly.**

## Preview

![Corner Collection View]()
![Primer Collection View]()
## Installation

### Manually
Drag the files from the Source folder into your project.

### Usage
1. Register cells and supplementary views in your ViewController.The custom cells could inherit from UICollectionViewCell directly, but the header or footer for a section must inherit from SCSCHCollectionViewHeaderFooter. Plus, cell header and the bottom section spacing for a section must inherit from SCSCHCollectionViewReusableView.

        - (void)viewDidLoad {
       [super viewDidLoad];
    
        // set up collectionViewContainer
         self.collectionViewContainer = [[SCStickyCellHeaderCollectionView alloc] initWithFrame:self.view.bounds];
          _collectionViewContainer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
         _collectionViewContainer.delegate = self;
         _collectionViewContainer.dataSource = self;
        [self.view addSubview:_collectionViewContainer];
       [_collectionViewContainer registerClass:[SCSectionHeader class] forSupplementaryViewOfKind:SCCollectionElementKindSectionHeader withReuseIdentifier:kSCSectionHeaderIdentifier];
       [_collectionViewContainer registerClass:[SCCellHeader class] forSupplementaryViewOfKind:SCCollectionElementKindCellHeader  withReuseIdentifier:kSCCellHeaderIdentifier];
        [_collectionViewContainer registerClass:[SCCell class] forCellWithReuseIdentifier:kSCCellIdentifier];
        [_collectionViewContainer registerClass:[SCSectionFooter class] forSupplementaryViewOfKind:SCCollectionElementKindSectionFooter withReuseIdentifier:kSCSectionFooterIdentifier];
        [_collectionViewContainer registerClass:[SCSectionSpacing class] forSupplementaryViewOfKind:SCCollectionElementKindSectionBottomSpacing  withReuseIdentifier:kSCSectionSpacingIdentifier];
        }
        
 2. Implement SCStickyCellHeaderCollectionViewDataSource and  SCStickyCellHeaderCollectionViewDelegate.
 
 3. Use - reloadData to reload data for collection view, **you should never call the method -realoadData of property 'collectionView' directly.**
 		
 		[self.collectionViewContainer reloadData];  √
 		[self.collectionViewContainer.collectionView reloadData];  ×
 		
For more infomation, please checkout file SCStickeyCellHeaderCollectionView.h .

## Requirements
(Really sorry that I haven't test on versions of iOS prior to 9.0)

- Objective c
- Xcode 7

## License
SCStickeyCellHeaderCollectionView is available under the MIT license. See the LICENSE file for more info.

## Thanks
*Thanks to [HebeTienCoder/XLPlainFlowLayout](https://github.com/HebeTienCoder/XLPlainFlowLayout)*

*Thanks to evadnelt Luminary: [Sticky Headers for UICollectionView using UICollectionViewFlowLayout](http://blog.radi.ws/post/32905838158/sticky-headers-for-uicollectionview-using#notes)*