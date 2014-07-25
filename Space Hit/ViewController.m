//
//  ViewController.m
//  Space Hit
//
//  Created by Baris Metin on 7/24/14.
//  Copyright (c) 2014 TBM. All rights reserved.
//

#import "ViewController.h"
#import "Game.h"
#import "ScoreBoard.h"

@interface ViewController ()
@property (nonatomic, strong) Game* game;
@end


@implementation ViewController
@synthesize game = m_game;

- (Game*)game
{
    if (!m_game) {
        m_game = [[Game alloc] init];
        m_game.scoreBoard = [ScoreBoard scoreBoardInView:self.view];
        m_game.spaceView = (SpaceView*)self.view;
    }
    return m_game;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Seed random at the start
    srandom((unsigned int)time(NULL));
    [self.game reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.view setNeedsDisplay];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [event allTouches]) {
        CGPoint location = [touch locationInView:self.view];
        [m_game addAllyShipAtPoint:location];
    }
}

@end

