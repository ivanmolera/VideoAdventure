//
//  EditorTouchMask_VC.m
//  aventura
//
//  Created by DonKikochan on 03/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//-----Imports:----------------
#import "EditorTouchMask_VC.h"
#import "TouchMask.h"
//

@interface EditorTouchMask_VC ()

@end

#define TIME_SHOW_HIDE_MENU 0.5f


@implementation EditorTouchMask_VC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    beginTouchPoints    = [[NSMutableArray alloc] init];
    endTouchPoints      = [[NSMutableArray alloc] init];
    coords              = [[NSMutableArray alloc] init];
    m_aTouchMasks       = [[NSMutableArray alloc] init];
    
    m_iCurrentMask = 0;
    m_eState = NoneSate;
    m_bShowMenu = YES;
}

- (void) showMenu
{
    if (m_bShowMenu) return;
    [UIView animateWithDuration:TIME_SHOW_HIDE_MENU
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect l_frame = _view_Menu.frame;
                         l_frame.origin.x += l_frame.size.width;
                         _view_Menu.frame = l_frame;
                     }
                     completion:^(BOOL finished){
                         m_bShowMenu = true;
                     }
     ];
}

- (void) hideMenu
{
    if (!m_bShowMenu) return;
    [UIView animateWithDuration:TIME_SHOW_HIDE_MENU
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect l_frame = _view_Menu.frame;
                         l_frame.origin.x -= l_frame.size.width;
                         _view_Menu.frame = l_frame;
                     }
                     completion:^(BOOL finished){
                         m_bShowMenu = false;
                     }
     ];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [beginTouchPoints removeAllObjects];
    
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:self.view];
        [beginTouchPoints addObject:[NSValue valueWithCGPoint:touchLocation]];
        NSLog(@"%f,%f", touchLocation.x, touchLocation.y);
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [endTouchPoints removeAllObjects];
    
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInView:self.view];
        [endTouchPoints addObject:[NSValue valueWithCGPoint:touchLocation]];
        NSLog(@"%f,%f", touchLocation.x, touchLocation.y);
    }
    
    [self updateStateMachine];
}


- (void) updateStateMachine
{
    switch (m_eState)
    {
        case State_StartNewMask:
        {
            [coords removeAllObjects];
            m_eState = State_WaitNextPoint;
        }
            break;
        case State_WaitNextPoint:
        {
            CGPoint firstPoint  = [[beginTouchPoints objectAtIndex:0] CGPointValue];
            [coords addObject:[NSValue valueWithCGPoint:firstPoint]];
        }
            break;
            
        case State_FinishMask:
        {
            CGPoint firstPoint  = [[beginTouchPoints objectAtIndex:0] CGPointValue];
            [coords addObject:[NSValue valueWithCGPoint:firstPoint]];
            NSString *idMask = [NSString stringWithFormat:@"%d",m_iCurrentMask];
            TouchMask* touch = [[TouchMask alloc ] initWithCoords:coords andFrame:self.view.frame andIdentifier:idMask];
            [m_aTouchMasks addObject:touch];
        }
            break;
        case NoneSate:
        {
            //Nothing Todo.
        }
            
            break;
            
        default:
        {
            NSLog(@"EditorTouchMask_VC: Error update amb estat default");
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back_Pressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newMask_Pressed:(id)sender
{
    m_eState = State_StartNewMask;
    [self updateStateMachine];
}

- (IBAction)editMask_Pressed:(id)sender
{
    
}

- (IBAction)sendXML_Pressed:(id)sender
{
    
}

- (IBAction)swipe_ShowMenu:(id)sender {
    [self showMenu];
}

- (IBAction)swipe_HideMenu:(id)sender {
    [self hideMenu];
}
@end
