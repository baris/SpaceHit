//
//  Game.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "Game.h"
#import "ScoreBoard.h"
#import "SpaceView.h"
#import "SpaceShip.h"
#import "Explosion.h"

@interface Game()
@property CADisplayLink* displayLink;
@property (nonatomic) NSMutableSet* allyShips;
@property (nonatomic) NSMutableSet* enemyShips;
@property long countEnemyShipsDestoyed;
@property long countEnemyShipsMissed;
@end


@implementation Game
@synthesize spaceView;
@synthesize scoreBoard;
@synthesize displayLink;
@synthesize allyShips = _allyShips;
@synthesize enemyShips = _enemyShips;

- (id)init
{
    self = [super init];
    if (self) {
        [self reset];
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop:)];
        self.displayLink.frameInterval = 2;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)reset
{
    self.countEnemyShipsDestoyed = 0;
    self.countEnemyShipsMissed = 0;
    [self.allyShips removeAllObjects];
    [self.enemyShips removeAllObjects];
    [self.scoreBoard reset];
}

- (NSMutableSet*)allyShips
{
    if (!_allyShips) {
        _allyShips = [[NSMutableSet alloc] init];
    }
    return _allyShips;
}

- (NSMutableSet*)enemyShips
{
    if (!_enemyShips) {
        _enemyShips = [[NSMutableSet alloc] init];
    }
    return _enemyShips;
}

- (void)gameLoop:(CADisplayLink *)sender
{
    // update background
    long randomNumber = random();
    if ((randomNumber % 97) == 0) {
        long x = random() % (long)(CGRectGetMaxX(self.spaceView.frame));
        long y = random() % (long)(CGRectGetMaxY(self.spaceView.frame));
        [self.spaceView drawCometAtPoint:CGPointMake(x, y)];
    }
    
    // draw enemy ships increasingly with the scoreboard
    long score = self.scoreBoard.score;
    long numEnemiesToAdd = MAX(1, score ) - [self.enemyShips count];
    //numEnemiesToAdd %= MAX(2, (self.scoreBoard.countDestroyed - self.scoreBoard.countMissed));
    static BOOL drawShips = YES;
    if (drawShips) {
        for (int i = 0; i < numEnemiesToAdd ; i++) {
            [self addEnemyShip];
        }
        drawShips = NO;
    } else {
        [self processCollusions];
        [self executeGameLogic];
        drawShips = YES;
    }
    
}

- (void)processCollusions
{
    for (SpaceShip* allyShip in self.allyShips) {
        for (SpaceShip* enemyShip in self.enemyShips) {
            if ([allyShip collidesWith:enemyShip] == YES) {
                allyShip.isDestroyed = YES;
                enemyShip.isDestroyed = YES;
                
                [allyShip explode];
                [enemyShip explode];
                
                [Explosion explosionInRect:[allyShip unionRectWith:enemyShip] inView:self.spaceView];
            }
        }
    }
}

- (void)executeGameLogic
{
    NSMutableArray* destroyedAllies = [[NSMutableArray alloc] init];
    NSMutableArray* destroyedEnemies = [[NSMutableArray alloc] init];
    NSMutableArray* missedAllies = [[NSMutableArray alloc] init];
    NSMutableArray* missedEnemies = [[NSMutableArray alloc] init];
    
    for (SpaceShip* ship in self.allyShips) {
        if (ship.isDestroyed) {
            [destroyedAllies addObject:ship];
        } else if (ship.isMissed) {
            [missedAllies addObject:ship];
        }
    }
    
    for (SpaceShip* ship in self.enemyShips) {
        if (ship.isDestroyed) {
            [destroyedEnemies addObject:ship];
        } else if (ship.isMissed) {
            [missedEnemies addObject:ship];
        }
    }
    
    [self processAlliesDestroyed:destroyedAllies andMissed:missedAllies];
    [self processEnemiesDestroyed:destroyedEnemies andMissed:missedEnemies];
    
    self.scoreBoard.lives = [self.enemyShips count] - [self.allyShips count];
}

- (void)processAlliesDestroyed:(NSMutableArray*)destroyed andMissed:(NSMutableArray*)missed
{
    for (SpaceShip* ship in destroyed) {
        [self.allyShips removeObject:ship];
    }
    for (SpaceShip* ship in missed) {
        [self.allyShips removeObject:ship];
    }
}

- (void)processEnemiesDestroyed:(NSMutableArray*)destroyed andMissed:(NSMutableArray*)missed
{
    for (SpaceShip* ship in destroyed) {
        self.countEnemyShipsDestoyed += 1;
        self.scoreBoard.countDestroyed += 1;
        [self.enemyShips removeObject:ship];
    }
    for (SpaceShip* ship in missed) {
        self.countEnemyShipsMissed += 1;
        self.scoreBoard.countMissed += 1;
        [self.enemyShips removeObject:ship];
    }
}

- (void)addEnemyShip
{
    long maxX = self.spaceView.bounds.size.width;
    long minY = self.scoreBoard.bounds.size.height;
    SpaceShip *ship = [SpaceShip enemyShipAtPoint:CGPointMake(random() % maxX, minY) inView:spaceView];
    [self.enemyShips addObject:ship];
    [ship moveWithDuration:10];
}

- (BOOL)canAddAllyShip
{
    if ([self.allyShips count] < [self.enemyShips count]) {
        return YES;
    }
    return NO;
}


- (void)addAllyShipAtPoint:(CGPoint)point
{
    if (![self canAddAllyShip]) {
        // TODO: message user that she can not add more ally ships.
        return;
    }
    long maxY= self.spaceView.bounds.size.height;
    SpaceShip* ship = [SpaceShip allyShipAtPoint:CGPointMake(point.x, maxY - 5) inView:spaceView];
    [self.allyShips addObject:ship];
    [ship moveWithDuration:10];
}

@end
