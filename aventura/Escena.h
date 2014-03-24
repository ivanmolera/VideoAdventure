//
//  CustomView.h
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//---Imports:-------
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "Estat.h"
#import "ItemMenu_View.h"
//------------------

@class Item;

@interface Escena : UIView
{
    ItemMenu_View*  m_ItemMenu;
}

//---Properties:
@property (nonatomic, strong) NSString*         identifier;         // Identificador de l'escena
@property (nonatomic, strong) NSMutableArray*   m_aTouchMasks;      // Array de màscares
@property (nonatomic, strong) NSMutableArray*   m_aActions;         // Array d'accions
@property (nonatomic, strong) NSMutableArray*   m_aEstats;          // Array d'estats
@property (nonatomic, strong) AVPlayer*         moviePlayer;        // Player
@property (nonatomic, strong) AVPlayerLayer*    movieLayer;         // Player
@property (nonatomic, assign) int               m_iCurrentEstat;    // Estat actual
@property (nonatomic, strong) Item*             m_ItemSelected;

//---Functions:
- (id)  initWithIdentifier:(NSString *)identifier andFrame:(CGRect)frame;
- (void) setCurrentEstat:(Estat*)estat;
- (void) setMasks:(NSMutableArray *)bezierPaths;
- (void) removeLabelsFromEscena;
- (void) showMessage:(NSString*)localizedString;
- (void) showItem:(Item*)_item;

@end
