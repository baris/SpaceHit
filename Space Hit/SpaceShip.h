//
//  SpaceShip.h
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpaceShip : UIView
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat speed;
@property (nonatomic) BOOL isEnemy;
@property (nonatomic) BOOL isDestroyed;
@property (nonatomic) BOOL isMissed;

+ (SpaceShip*)allyShipAtPoint:(CGPoint)point inView:(UIView*)view;
+ (SpaceShip*)enemyShipAtPoint:(CGPoint)point inView:(UIView*)view;

- (void)moveWithDuration:(CGFloat)duration;
- (BOOL)collidesWith:(SpaceShip*)ship;
- (CGRect)unionRectWith:(SpaceShip*)ship;
- (void)explode;
@end
