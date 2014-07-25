//
//  Comet.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "Comet.h"

@implementation Comet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat alpha = random() % 11;
    alpha = MAX(alpha, 5) / 10.;
    [[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:alpha] setFill];
    
    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-4, CGRectGetMidY(rect) - 2);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-4, CGRectGetMidY(rect) + 2);
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGContextAddArc(context, CGRectGetMaxX(rect)-4, CGRectGetMidY(rect), CGRectGetHeight(rect)/3, 0, 2*M_PI, YES);
    
    CGContextFillPath(context);
}

@end
