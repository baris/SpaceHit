//
//  ScoreBoard.h
//  Space Hit
//
//  Created by Baris Metin on 7/25/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoard : UIView
@property (nonatomic) long countDestroyed;
@property (nonatomic) long countMissed;
@property (nonatomic) long score;
@property (nonatomic) long lives;

+ (ScoreBoard*) scoreBoardInView:(UIView*)view;
- (void) reset;
@end
