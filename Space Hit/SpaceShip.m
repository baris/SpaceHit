//
//  SpaceShip.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "SpaceShip.h"

@implementation SpaceShip
@synthesize position = _position;
@synthesize speed;

#define MAX_SHIP_SIZE 20

+ (SpaceShip *)allyShipAtPoint:(CGPoint)point inView:(UIView *)view
{
    return [self shipAtPoint:point inView:view isEnemy:NO];
}

+ (SpaceShip *)enemyShipAtPoint:(CGPoint)point inView:(UIView *)view
{
    return [self shipAtPoint:point inView:view isEnemy:YES];
}

+ (SpaceShip *)shipAtPoint:(CGPoint)point inView:(UIView *)view isEnemy:(BOOL)enemy
{
    SpaceShip* ship = [SpaceShip shipAtPoint:point];
    ship.isEnemy = enemy;
    ship.isDestroyed = NO;
    ship.isMissed = NO;
    [view addSubview:ship];
    [ship animateMove];
    return ship;
}

+ (SpaceShip*)shipAtPoint:(CGPoint)point
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat shipSize = MAX(applicationFrame.size.width, applicationFrame.size.height) / 30;
    shipSize = MAX(shipSize, MAX_SHIP_SIZE);
    CGRect frame = CGRectMake(0, 0, shipSize, shipSize);
    SpaceShip *ship = [[SpaceShip alloc] initWithFrame:frame];
    ship.position = point;
    ship.opaque = YES;
    return ship;
}

- (BOOL)collidesWith:(SpaceShip*)ship
{
    CGRect this = [[self.layer presentationLayer] frame];
    CGRect other = [[ship.layer presentationLayer] frame];
    return CGRectIntersectsRect(this, other);
}

- (CGRect)unionRectWith:(SpaceShip*)ship
{
    CGRect this = [[self.layer presentationLayer] frame];
    CGRect other = [[ship.layer presentationLayer] frame];
    return CGRectUnion(this, other);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setPosition:(CGPoint)position
{
    _position = position;
    self.center = position;
}

- (void)moveWithDuration:(CGFloat)duration
{
    duration = duration - (duration * self.speed);
    if (self.isEnemy) {
        [UIView animateWithDuration:duration animations:^{
            self.position = CGPointMake(self.position.x, CGRectGetMaxY(self.superview.frame));
        } completion:^(BOOL finished) {
            if (self.position.y == CGRectGetMaxY(self.superview.frame) && self.alpha == 1.0) {
                self.alpha = 0.0;
                self.isMissed = YES;
            }
        }];

    } else {
        [UIView animateWithDuration:duration animations:^{
            self.position = CGPointMake(self.position.x, 0.0);
        } completion:^(BOOL finished) {
            self.alpha = 0.0;
            self.isMissed = YES;
        }];
    }
}

- (void)explode
{
    CGFloat rotationAngle = 360.0;
    if ([self isEnemy]) rotationAngle = -360.0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(.5, .5), CGAffineTransformMakeRotation(rotationAngle));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0.0;
            self.transform = CGAffineTransformInvert(self.transform);
        }];
    }];
}

- (void)animateMove
{
    if (self.isEnemy) {
        [self animateEnemyMove];
    } else {
        [self animateAllyMove];
    }
}

- (void)animateAllyMove
{
    CGFloat deformedX=.8, deformedY=1;
    CGAffineTransform t = CGAffineTransformIdentity;
    [self animateDeformationWithX:deformedX andY:deformedY andTransform:t];
}

- (void)animateEnemyMove
{
    CGFloat deformedX=1, deformedY=.8;
    CGAffineTransform t = CGAffineTransformMakeRotation(M_PI);
    [self animateDeformationWithX:deformedX andY:deformedY andTransform:t];
}

- (void)animateDeformationWithX:(CGFloat)deformedX andY:(CGFloat)deformedY andTransform:(CGAffineTransform)t
{
    [UIView animateWithDuration:.6 animations:^{
        self.transform = CGAffineTransformConcat(t, CGAffineTransformMakeScale(deformedX, deformedY));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.6 animations:^{
            self.transform = CGAffineTransformConcat(t, CGAffineTransformMakeScale(1, 1));
        } completion:^(BOOL finished) {
            [self animateDeformationWithX:deformedX andY:deformedY andTransform:t];
        }];
    }];
}

- (void)drawRect:(CGRect)rect
{
    if (self.isEnemy) {
        self.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (self.isEnemy) {
        [[UIColor colorWithRed:.2 green:1.0 blue:1.0 alpha:1.0] setFill];
    } else {
        [[UIColor colorWithRed:.6 green:.6 blue:1.0 alpha:1.0] setFill];
    }
    // Top circle
    CGPathAddArc(path, NULL, midX, minY+3, 2, 0, 2*M_PI, YES);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
    
    // Middle circle
    path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, midX, midY, 2, 0, 2*M_PI, YES);
    CGContextAddPath(context, path);
    CGPathRelease(path);
    
    // Body
    path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(midX/3, minY+3, (maxX-2*midX/3), maxY-5));
    CGContextAddPath(context, path);
    if (self.isEnemy) {
        [[UIColor colorWithRed:1.0 green:.2 blue:0.2 alpha:1.0] setFill];
    } else {
        [[UIColor colorWithRed:.2 green:.9 blue:0.4 alpha:1.0] setFill];
    }
    CGContextFillPath(context);
    CGPathRelease(path);
    
    // left wing
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, midX/3, midY);
    CGPathAddCurveToPoint(path, NULL,
                          minX+1, midY+(midY/2),
                          minX+4, midY+midY/5,
                          minX+1, midY+midY/2);
    CGPathAddLineToPoint(path, NULL, midX/2, midY+midY/2);
    CGContextAddPath(context, path);
    if (self.isEnemy) {
        [[UIColor colorWithRed:.2 green:1.0 blue:1.0 alpha:1.0] setFill];
    } else {
        [[UIColor colorWithRed:.6 green:.6 blue:1.0 alpha:1.0] setFill];
    }
    CGContextFillPath(context);
    CGPathRelease(path);
    
    // right wing
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, maxX-midX/3, midY);
    CGPathAddCurveToPoint(path, NULL,
                          maxX-1, midY+(midY/2),
                          maxX-4, midY+midY/5,
                          maxX-1, midY+midY/2);
    CGPathAddLineToPoint(path, NULL, maxX-midX/2, midY+midY/2);
    CGContextAddPath(context, path);
    if (self.isEnemy) {
        [[UIColor colorWithRed:.2 green:1.0 blue:1.0 alpha:1.0] setFill];
    } else {
        [[UIColor colorWithRed:.6 green:.6 blue:1.0 alpha:1.0] setFill];
    }
    CGContextFillPath(context);
    CGPathRelease(path);

    // draw the ship
    CGContextStrokePath(context);
    CGContextFillPath(context);
}


@end
