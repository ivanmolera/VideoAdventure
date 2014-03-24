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


//---IBOutlets:
@property (weak, nonatomic) IBOutlet UIView*    m_ViewEscena;


//----Properties:
@property (nonatomic, strong) UIButton*         btn_Back;
@property (nonatomic, strong) UISwitch*         switchBtn;          // Show/Hide layers
@property (nonatomic, strong) NSMutableArray*   beginTouchPoints;   // Show/Hide layers
@property (nonatomic, strong) NSMutableArray*   endTouchPoints;     // Show/Hide layers
@property (nonatomic, strong) NSMutableArray*   m_aEscenes;         // Array d'escenes
@property (nonatomic, assign) int               m_iCurrentEscena;   // Escena actual
@property (nonatomic, strong) Inventory*        inventory;          // Inventari

//---IBActions:
//...

//---Functions:
//...
@end
