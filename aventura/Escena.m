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
#import "Item.h"

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
        
        //---Menu Item:
        CGRect rect = CGRectMake(80, 100, 350, 250);
        m_ItemMenu = [[ItemMenu_View alloc] initWithFrame:rect];
        [self addSubview:m_ItemMenu];
        [m_ItemMenu hideMenu];
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
    
    // REPEAT MODE
    if(estat.repeatMode) {
        _moviePlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(repeat:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:movieItem];
    }
    
    /* REVERSE MODE: no va
     
     [movieItem reversePlaybackEndTime];
     
     CMTime durTime = movieItem.asset.duration;
     //float durationTime = CMTimeGetSeconds(durTime);
     
     if (CMTIME_IS_VALID(durTime)) {
     [_moviePlayer seekToTime:durTime];
     [_moviePlayer setRate:_moviePlayer.rate*(-1)];
     }
     else
     NSLog(@"Invalid time");
     */
    
    [_moviePlayer replaceCurrentItemWithPlayerItem:movieItem];
    [_movieLayer setPlayer:_moviePlayer];
    [_moviePlayer play];
}

- (void)repeat:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

- (void) removeLabelsFromEscena {
    // Esborro les etiquetes i imatges
    for (UIView *i in self.subviews) {
        if ([i isKindOfClass:[UILabel class]] || [i isKindOfClass:[UIImageView class]]) {
            [i removeFromSuperview];
        }
        else if ([i isKindOfClass:[UIButton class]] || [i isKindOfClass:[Item class]]) {
            //NSLog(@"button:%f,%f",i.center.x, i.center.y);
            [i removeFromSuperview];
        }
    }
}

- (void) showMessage:(NSString*)localizedString {
    CGRect myImageRect = CGRectMake(500, 20, 400, 60);
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:myImageRect];
    
    [messageLabel setTextColor:[UIColor whiteColor]];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setFont:[UIFont fontWithName: @"Laffayette Comic Pro" size: 14.0f]];
    [messageLabel setText:NSLocalizedString(localizedString, nil)];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [messageLabel setNumberOfLines:0];
    
    [self addSubview:messageLabel];
}

- (void) showItem:(UIButton*)button {
    [self bringSubviewToFront:m_ItemMenu];
    [m_ItemMenu showMenu];
    
    //[self addSubview:button];
    //[self bringSubviewToFront:button];
}

@end
