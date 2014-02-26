//
//  Action.h
//  Aventura
//
//  Created by IVAN MOLERA on 13/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Escena.h"

typedef enum {
    ActionTypeJumpToScene,
    ActionTypeJumpToState,
    ActionTypeShowMessage,
    ActionTypeGetItem,
    ActionTypeUseItem
} AGActionType;

@interface Action : NSObject

// Identificador de l'acció
@property (nonatomic, strong) NSString          *identifier;

// Tipus d'acció
@property (nonatomic, assign) NSInteger         m_iType;

// Array de màscares
@property (nonatomic, strong) NSMutableArray    *m_aTouchMasks;

// Properties de la action
@property (nonatomic, assign) int               target;
@property (nonatomic, strong) NSString          *message;

@property (nonatomic, strong) Escena            *escena;


- (id) initWithIdentifier:(NSString *)identifier;
- (bool) check:(NSString*)maskId;
- (void) doAction;

@end
