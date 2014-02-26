//
//  CustomView.m
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "Escena.h"
#import "TouchMask.h"
#import "Action.h"
#import "Estat.h"

@implementation Escena

- (id) initWithIdentifier:(NSString *)identifier andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.identifier = identifier;

        _moviePlayer =  [[MPMoviePlayerController alloc] init];

        _moviePlayer.controlStyle   = MPMovieControlStyleNone;
        _moviePlayer.scalingMode    = MPMovieScalingModeAspectFit;
        _moviePlayer.shouldAutoplay = NO;
        _moviePlayer.repeatMode     = MPMovieRepeatModeNone;
        _moviePlayer.view.frame     = frame;
        //_moviePlayer.view.backgroundColor = [UIColor blackColor];

        [self addSubview:_moviePlayer.view];

        _moviePlayer.fullscreen = YES;
    }
    return self;
}

- (void) setMasks:(NSMutableArray *)masks {
    for (TouchMask *mask in masks)
    {
        self.layer.mask = mask;
        [self.layer addSublayer:mask];
    }
}

- (void) setCurrentEstat:(Estat*)estat {

    self.m_iCurrentEstat = [estat.identifier intValue];

    NSLog(@"CurrEstat %@", estat.identifier);

    NSBundle *bundle    = [NSBundle mainBundle];
    NSString *path      = [bundle pathForResource:estat.m_sVideoURL ofType:@"mp4"];
    NSURL *movieUrl     = [NSURL fileURLWithPath:path];

    [_moviePlayer setContentURL:movieUrl];

    // MPMovieRepeatModeNone, MPMovieRepeatModeOne
    _moviePlayer.repeatMode = MPMovieRepeatModeNone;

    [_moviePlayer prepareToPlay];
    [_moviePlayer play];
}

@end
