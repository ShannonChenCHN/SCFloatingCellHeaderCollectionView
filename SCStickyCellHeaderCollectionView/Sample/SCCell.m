//
//  SCCell.m
//  SCStickyCellHeaderCollectionView
//
//  Created by ShannonChen on 16/3/19.
//  Copyright © 2016年 meitun. All rights reserved.
//

#import "SCCell.h"

@interface SCCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SCCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubviews];
        
        [self sc_addBottomSeparator];
    }
    return self;
}

- (void)addSubviews {
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.font = [UIFont systemFontOfSize:25];
    _titleLabel.textColor = [UIColor greenColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
