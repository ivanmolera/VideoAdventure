//
//  CustomView.h
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Estat.h"

@interface Escena : UIView

// Identificador de l'escena
@property (nonatomic, strong) NSString                  *identifier;

// Array de màscares
@property (nonatomic, strong) NSMutableArray            *m_aTouchMasks;

// Array d'accions
@property (nonatomic, strong) NSMutableArray            *m_aActions;

// Array d'estats
@property (nonatomic, strong) NSMutableArray            *m_aEstats;

// Player
@property (nonatomic, strong) MPMoviePlayerController   *moviePlayer;

// Estat actual
@property (nonatomic, assign) int                       m_iCurrentEstat;

- (id) initWithIdentifier:(NSString *)identifier andFrame:(CGRect)frame;
- (void) setCurrentEstat:(Estat*)estat;
- (void) setMasks:(NSMutableArray *)bezierPaths;

@end
