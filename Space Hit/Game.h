//
//  Game.h
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SpaceView;
@class ScoreBoard;

@interface Game : NSObject
@property (nonatomic) SpaceView* spaceView;
@property (nonatomic) ScoreBoard* scoreBoard;

- (void) reset;
- (void) addAllyShipAtPoint:(CGPoint)point;
@end
