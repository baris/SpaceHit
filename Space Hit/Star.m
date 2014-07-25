//
//  Star.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "Star.h"

@implementation Star

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
    CGContextSetShadow(context, CGSizeMake(0, 0), 15);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 2);
    
    CGFloat alpha = random() % 80 / 100;
    alpha = MAX(alpha, 7) / 10.;
    
    // draw a circle
    [[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:alpha] setFill];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, CGRectGetMidX(rect), CGRectGetMidY(rect), CGRectGetWidth(rect) / 3, 0, 2 * M_PI, YES);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
    
    // draw a +
    [[UIColor colorWithRed:.7 green:.7 blue:.7 alpha:alpha - 0.2] setStroke];
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMidY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMidY(rect));
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddLineToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextAddPath(context, path);
    CGPathRelease(path);
    CGContextStrokePath(context);
}

@end
