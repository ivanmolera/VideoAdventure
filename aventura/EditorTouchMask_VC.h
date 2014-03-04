//
//  EditorTouchMask_VC.h
//  aventura
//
//  Created by DonKikochan on 03/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//---Imports:------------
#import <UIKit/UIKit.h>
//-----------------------


//------Define New Types:----
typedef enum {
    State_StartNewMask,
    State_WaitNextPoint,
    State_FinishMask,
    NoneSate
    
} AGEditorState;
//---------------------------



@interface EditorTouchMask_VC : UIViewController
{
    AGEditorState       m_eState;
    NSMutableArray*     beginTouchPoints;
    NSMutableArray*     endTouchPoints;
    NSMutableArray*     coords;
    int                 m_iCurrentMask;
    NSMutableArray*     m_aTouchMasks;
    BOOL                m_bShowMenu;
}

//---IBoutlets:
@property (strong, nonatomic) IBOutlet UIView *view_Menu;
@property (strong, nonatomic) IBOutlet UILabel *lbl_OptionsMenu;
@property (strong, nonatomic) IBOutlet UIButton *btn_Back;
@property (strong, nonatomic) IBOutlet UIButton *btn_NewMask;
@property (strong, nonatomic) IBOutlet UIButton *btn_EditMask;
@property (strong, nonatomic) IBOutlet UIButton *btn_SendXML;

//---IBActions:
- (IBAction)back_Pressed:(id)sender;
- (IBAction)newMask_Pressed:(id)sender;
- (IBAction)editMask_Pressed:(id)sender;
- (IBAction)sendXML_Pressed:(id)sender;
- (IBAction)swipe_ShowMenu:(id)sender;
- (IBAction)swipe_HideMenu:(id)sender;


//---Functions:
//...

@end
