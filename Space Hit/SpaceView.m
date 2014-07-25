//
//  SpaceView.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "SpaceView.h"
#import "Star.h"
#import "Comet.h"

#define NUM_STARS     150
#define MAX_STAR_SIZE 6


@implementation SpaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    NSLog(@"SpaceView initialized!!!");
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // Spaceview always wins the hit test. (big performance improvement)
    return self;
}

- (void)drawCometAtPoint:(CGPoint)point
{
    long cometLength = MAX(15, random() % 50);
    long cometHeight = MAX(5, random() % 10);
    long cometFlightLength = MAX(100, random() % 500);
    
    __block Comet* comet = [[Comet alloc] initWithFrame:CGRectMake(point.x, point.y, cometLength, cometHeight)];
    [self addSubview:comet];

    [UIView animateWithDuration:cometFlightLength/100.0 animations:^{
        comet.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(3, 1), CGAffineTransformMakeTranslation(cometFlightLength, 3));
        comet.alpha = 0.0;
    } completion:^(BOOL finished) {
        comet = nil;
    }];
}

- (void)drawStarInRect:(CGRect)rect
{
    Star* star = [[Star alloc] initWithFrame:rect];
    [self addSubview:star];
}

- (CGRect)randomSubRectFromRect:(CGRect)rect withLength:(CGFloat)length
{
    long x = random() % (long)(CGRectGetMaxX(rect) - length);
    long y = random() % (long)(CGRectGetMaxY(rect) - length);
    return CGRectMake(x, y, length, length);
}

- (void)drawRect:(CGRect)rect
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    long maxStarSize = MAX(applicationFrame.size.width, applicationFrame.size.height) / NUM_STARS;
    maxStarSize = MAX(maxStarSize, MAX_STAR_SIZE);
    for (int i = 0; i < NUM_STARS; ++i) {
        [self drawStarInRect:[self randomSubRectFromRect:rect withLength:random() % maxStarSize]];
    }
}

@end
