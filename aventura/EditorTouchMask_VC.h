//
//  EditorTouchMask_VC.h
//  aventura
//
//  Created by DonKikochan on 03/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//---Imports:------------
#import <UIKit/UIKit.h>
#import "TouchMask.h"
#import <MessageUI/MessageUI.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
//-----------------------


//------Define New Types:----
typedef enum {
    State_StartNewMask,
    State_WaitNextPoint,
    State_FinishMask,
    NoneSate
    
} AGEditorState;

typedef enum {
    TV_Videos,
    TV_XMLFiles,
    NoneTableView
    
} AGTypeTableViewEditor;
//---------------------------



@interface EditorTouchMask_VC : UIViewController <MFMailComposeViewControllerDelegate>
{
    AGEditorState           m_eState;
    NSMutableArray*         m_aCoords;
    NSMutableArray*         m_aTouchMasks;
    BOOL                    m_bShowMenu;
    BOOL                    m_bRectangleMode;
    CGPoint                 m_TapPoint;
    TouchMask*              m_TouchMask_aux;
    AGTypeTableViewEditor   m_eTypeTV_Editor;
    NSArray*                m_aXMLScenes;
    NSArray*                m_aVideos;
}



//---IBoutlets:------------------------------
@property (strong, nonatomic) IBOutlet UIView*      view_Menu;
@property (strong, nonatomic) IBOutlet UIImageView* img_StartPoint;
@property (strong, nonatomic) IBOutlet UILabel*     lbl_OptionsMenu;
@property (strong, nonatomic) IBOutlet UIView*      videoView;

//---General Menu
@property (strong, nonatomic) IBOutlet UIView*      view_MenuGeneral;
@property (strong, nonatomic) IBOutlet UIButton*    btn_Back;
@property (strong, nonatomic) IBOutlet UIButton*    btn_NewMask;
@property (strong, nonatomic) IBOutlet UIButton*    btn_EditMask;
@property (strong, nonatomic) IBOutlet UIButton*    btn_SendXML;
@property (strong, nonatomic) IBOutlet UIButton*    btn_LoadAvi;
@property (strong, nonatomic) IBOutlet UIButton*    btn_LoadXML;
@property (strong, nonatomic) IBOutlet UITableView* tableView;


//---New Touch Menu
@property (strong, nonatomic) IBOutlet UIView*      view_MenuNewTouch;
@property (strong, nonatomic) IBOutlet UIButton*    btn_MultiPoints;
@property (strong, nonatomic) IBOutlet UIButton*    btn_Rectangle;
@property (strong, nonatomic) IBOutlet UITextField* txtF_TouchID;
@property (strong, nonatomic) IBOutlet UIButton*    btn_Finish; //back


//---Create Touch Menu
@property (strong, nonatomic) IBOutlet UIView*      view_MenuCreateTouch;
@property (strong, nonatomic) IBOutlet UILabel*     lbl_TypeTouchMask;
@property (strong, nonatomic) IBOutlet UIButton*    btn_Undo;


// Player
@property (nonatomic, strong) AVPlayer*             moviePlayer;
@property (nonatomic, strong) AVPlayerLayer*        movieLayer;
//---------------------------------------------

//---IBActions:
- (IBAction)newMask_Pressed:(id)sender;
- (IBAction)editMask_Pressed:(id)sender;
- (IBAction)sendXML_Pressed:(id)sender;
- (IBAction)backFromMainMenu_Pressed:(id)sender;
- (IBAction)rectangle_Pressed:(id)sender;
- (IBAction)swipe_ShowMenu:(id)sender;
- (IBAction)swipe_HideMenu:(id)sender;
- (IBAction)newPoint_TapGesture:(id)sender;
- (IBAction)LastPoint_TapGesture:(id)sender;
- (IBAction)multiPoints_Pressed:(id)sender;
- (IBAction)backFromMenuNewTouch_Pressed:(id)sender;
- (IBAction)done_TouchID:(id)sender;
- (IBAction)undo_Pressed:(id)sender;
- (IBAction)backFromMenuCreateTouch_Pressed:(id)sender;
- (IBAction)loadAvi_Pressed:(id)sender;
- (IBAction)loadXML_Pressed:(id)sender;
- (IBAction)backFromTableView_Pressed:(id)sender;

//---Functions:
- (void) namePressed:(int) _index;

//---Functions:
//...

@end
