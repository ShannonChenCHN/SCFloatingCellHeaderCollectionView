//
//  SCSectionFooter.m
//  SCStickyCellHeaderCollectionView
//
//  Created by ShannonChen on 16/3/19.
//  Copyright © 2016年 meitun. All rights reserved.
//

#import "SCSectionFooter.h"

@interface SCSectionFooter ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation SCSectionFooter

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
    _titleLabel.font = [UIFont systemFontOfSize:13];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"View more...";
    [self addSubview:_titleLabel];
}

@end
