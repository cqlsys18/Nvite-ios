//
//  CustomLB.m
//  GuestBox
//
//  Created by AJ on 2/7/17.
//  Copyright © 2017 Team. All rights reserved.
//

#import "CustomLB.h"

@implementation CustomLB

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
    
    UIEdgeInsets insets = {5, 5, 5, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize) intrinsicContentSize {
    
    CGSize intrinsicSuperViewContentSize = [super intrinsicContentSize] ;
    intrinsicSuperViewContentSize.height += 5 + 5 ;
    intrinsicSuperViewContentSize.width += 5 + 5 ;
    return intrinsicSuperViewContentSize ;
}

@end
