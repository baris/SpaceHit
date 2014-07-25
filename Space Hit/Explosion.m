//
//  Explosion.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "Explosion.h"

@implementation Explosion

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
    [[UIColor colorWithRed:1.0  green:.2 blue:.0 alpha:.7] setFill];
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), CGRectGetMaxX(rect)/2, 0, 2*M_PI, YES);
    CGContextFillPath(context);
}


+ (void)explosionInRect:(CGRect)rect inView:(UIView*)view
{
    const int numberOfParticles = MAX(15, (int)random() % 20);
    NSMutableArray *particles = [[NSMutableArray alloc] initWithCapacity:numberOfParticles];
    for (int i = 0; i < numberOfParticles; ++i) {
        long x = random() % (long)(CGRectGetWidth(rect) - 5);
        long y = random() % (long)(CGRectGetHeight(rect) - 5);
        x += CGRectGetMinX(rect);
        y += CGRectGetMinY(rect);
        CGRect subrect = CGRectMake(x, y, 5, 5);
        
        Explosion *e = [[Explosion alloc] initWithFrame:subrect];
        [particles addObject:e];
        [view addSubview:e];
    }
    
    for (Explosion *e in particles) {
        [UIView animateWithDuration:.7 animations:^{
            e.transform = CGAffineTransformMakeScale(MAX(2, random() % 6), MAX(3, random() % 7));
            e.alpha = 0.0;
        }];
    }
    
    [particles removeAllObjects];
    particles = nil;
}

@end
