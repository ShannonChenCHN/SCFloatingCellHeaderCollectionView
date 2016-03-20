//
//  SCSectionHeader.m
//  SCStickyCellHeaderCollectionView
//
//  Created by ShannonChen on 16/3/19.
//  Copyright © 2016年 meitun. All rights reserved.
//

#import "SCSectionHeader.h"

@interface SCSectionHeader ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SCSectionHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
        
        [self sc_addTopSeparator];
        
    }
    return self;
}

- (void)addSubviews {
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
