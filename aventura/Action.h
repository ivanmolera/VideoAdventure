//
//  Action.h
//  Aventura
//
//  Created by IVAN MOLERA on 13/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//-------Imports:--------------------
#import <Foundation/Foundation.h>
#import "Escena.h"
//-----------------------------------



//---Define new types:----------
typedef enum {
    ActionTypeJumpToScene,
    ActionTypeJumpToState,
    ActionTypeShowMessage,
    ActionTypeGetItem,
    ActionTypeUseItem
} AGActionType;

typedef enum {
    ActionPlayMpde_Normal,
    ActionPlayMpde_Reverse
} AGActionPlayMode;
//------------------------------


@interface Action : NSObject
{
    //Nothing...
}


//---------------Properties-----------------------------------
// Identificador de l'acció
@property (nonatomic, strong) NSString          *identifier;

// Tipus d'acció
@property (nonatomic, assign) NSInteger         m_iType;

// Array de màscares
@property (nonatomic, strong) NSMutableArray    *m_aTouchMasks;

// Properties de la action
@property (nonatomic, assign) int               target;
@property (nonatomic, assign) int               nextState;
@property (nonatomic, assign) BOOL              repeatMode;
@property (nonatomic, assign) AGActionPlayMode  playMode;
@property (nonatomic, strong) NSString          *message;
@property (nonatomic, strong) NSString          *playSound;
@property (nonatomic, strong) Escena            *escena;
//-------------------------------------------------------------


//---Functions:-------
- (id) initWithIdentifier:(NSString *)identifier;
- (bool) check:(NSString*)maskId;
- (void) doAction;

@end
