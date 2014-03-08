//
//  ViewController.h
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//---Imports:----------------
#import <UIKit/UIKit.h>
#import "Inventory.h"
//---------------------------


//------Define New Types:----
typedef enum {
    EventTypeTouch,
    EventTypeMultiTouch,
    EventTypeDrag
} AGEventType;
//---------------------------


@interface Game_VC : UIViewController <UIGestureRecognizerDelegate>
{
    
}

//----Properties:

@property (nonatomic, strong) UIButton          *btn_Back;

// Show/Hide layers
@property (nonatomic, strong) UISwitch          *switchBtn;

// Touch points
@property (nonatomic, strong) NSMutableArray    *beginTouchPoints;
@property (nonatomic, strong) NSMutableArray    *endTouchPoints;

// Array d'escenes
@property (nonatomic, strong) NSMutableArray    *m_aEscenes;

// Escena actual
@property (nonatomic, assign) int               m_iCurrentEscena;

// Inventari
@property (nonatomic, strong) Inventory         *inventory;




@end
