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
    [self addSubview:button];
    [self bringSubviewToFront:button];
}

@end
