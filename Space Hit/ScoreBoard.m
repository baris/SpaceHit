//
//  ScoreBoard.m
//  Space Hit
//
//  Created by Baris Metin on 7/25/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "ScoreBoard.h"

@interface ScoreBoard()
// @property (nonatomic) BOOL updateInProgress;
@end

@implementation ScoreBoard
@synthesize countDestroyed = _countDestroyed;
@synthesize countMissed = _countMissed;
@synthesize lives = _lives;
@synthesize score = _score;

+ (ScoreBoard*) scoreBoardInView:(UIView*)view
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat frameHeight = CGRectGetHeight(applicationFrame) / 50.0;
    CGFloat frameWidth = CGRectGetWidth(applicationFrame);
    ScoreBoard* board = [[ScoreBoard alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frameHeight + 10)];
    [view addSubview:board];
    return board;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) reset
{
    self.countDestroyed = 0;
    self.countMissed = 0;
    self.lives = 0;
}

- (void)setCountDestroyed:(long)count
{
    _countDestroyed = count;
    _score += 1;
    [self updateWithAnimation];
}

- (void)setCountMissed:(long)count
{
    _countMissed = count;
    _score = MAX(0, _score - 1);
    [self update];
}

- (void)setLives:(long)count
{
    _lives = count;
    [self update];
}

- (void) updateWithAnimation
{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 1.0;
        }];
    }];
}

- (void)update
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, self.bounds);
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    CGFloat fontSize = MAX(9, applicationFrame.size.height / 80.0);

    NSString* text = [NSString stringWithFormat:@"☢ Destroyed:%4ld | ∅ Missed:%4ld | ♥ Ships Ready:%3ld | ⚑ Score:%4ld",
                      self.countDestroyed, self.countMissed, self.lives, self.score];
    [text drawAtPoint:CGPointMake(5, 0)
       withAttributes:@{
                        NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:fontSize],
                        NSForegroundColorAttributeName:[UIColor whiteColor]
                        }];
}

@end
