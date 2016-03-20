//
//  SCCellHeader.m
//  SCStickyCellHeaderCollectionView
//
//  Created by ShannonChen on 16/3/19.
//  Copyright © 2016年 meitun. All rights reserved.
//

#import "SCCellHeader.h"

@interface SCCellHeader ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SCCellHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self addSubviews];
        
        [self sc_addTopSeparator];
        [self sc_addBottomSeparator];
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)addSubviews {
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor lightGrayColor];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
