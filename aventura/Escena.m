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
        
        _moviePlayer = [[AVPlayer alloc] init];
        _movieLayer = [AVPlayerLayer layer];
        
        [_movieLayer setPlayer:_moviePlayer];
        [_movieLayer setFrame:frame];
        [_movieLayer setBackgroundColor:[UIColor blackColor].CGColor];
        
        [self.layer addSublayer:_movieLayer];
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

    AVURLAsset *movieOneItemAsset = [AVURLAsset URLAssetWithURL:movieUrl options:nil];
    AVPlayerItem *movieItem = [AVPlayerItem playerItemWithAsset:movieOneItemAsset];
    
    [_moviePlayer replaceCurrentItemWithPlayerItem:movieItem];
    
    [_movieLayer setPlayer:_moviePlayer];
    [_moviePlayer play];
}

@end
