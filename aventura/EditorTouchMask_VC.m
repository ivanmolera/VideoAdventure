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
#import "AppDelegate.h"
#import "XMLTreeNode.h"
#import "EditorCell.h"
#import "XMLTreeNode.h"
//-----------------------------

@interface EditorTouchMask_VC ()

@end

#define TIME_SHOW_HIDE_MENU 0.3f


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
    _moviePlayer = [[AVPlayer alloc] init];
    _movieLayer = [AVPlayerLayer layer];
    [_movieLayer setPlayer:_moviePlayer];
    [_movieLayer setFrame:self.videoView.frame];
    [_movieLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [self.videoView.layer addSublayer:_movieLayer];
    
	// Do any additional setup after loading the view.
    m_aCoords       = nil;
    m_aTouchMasks   = [[NSMutableArray alloc] init];
    
    m_TouchMask_aux = NULL;
    m_eState = NoneSate;
    m_bShowMenu = YES;
    _img_StartPoint.hidden = YES;
    
    _view_MenuGeneral.hidden        = NO;
    _view_MenuNewTouch.hidden       = YES;
    _view_MenuCreateTouch.hidden    = YES;
    _tableView.hidden               = YES;
    
    m_aXMLScenes = [[NSBundle mainBundle] pathsForResourcesOfType:@"xml" inDirectory:nil];
    m_aVideos = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp4" inDirectory:nil];
}

- (void) showMenu
{
    if (m_bShowMenu) return;
    [UIView animateWithDuration:TIME_SHOW_HIDE_MENU
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
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
                        options:UIViewAnimationOptionCurveEaseOut
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


- (void) updateStateMachine
{
    switch (m_eState)
    {
        case State_StartNewMask:
        {
            m_aCoords = [[NSMutableArray alloc] init];
            m_eState = State_WaitNextPoint;
        }
            break;
        case State_WaitNextPoint:
        {
            if (m_aCoords.count ==1 && m_bRectangleMode)
            {
                [self autoCompleteRectangle];
                return;
            }
            
            if (m_aCoords.count > 0 && !m_bRectangleMode)
            {
                _btn_Undo.enabled = YES;
            }
            
            [m_aCoords addObject:[NSValue valueWithCGPoint:m_TapPoint]];
            if (m_aCoords.count > 1)
            {
                if (m_TouchMask_aux != NULL)
                {
                   [m_TouchMask_aux removeFromSuperlayer];
                    
                }
                m_TouchMask_aux = [[TouchMask alloc ] initWithCoords:m_aCoords
                                                            andFrame:self.view.frame
                                                       andIdentifier:@"kaka"
                                                         andIsHidden:NO];
                [self.view.layer addSublayer:m_TouchMask_aux];
            }
            else if (m_aCoords.count == 1)
            {
                _img_StartPoint.hidden = NO;
                CGRect frame = _img_StartPoint.frame;
                frame.origin = m_TapPoint;
                frame.origin.x -= frame.size.width*0.5f;
                frame.origin.y -= frame.size.height*0.5f;
                _img_StartPoint.frame = frame;
            }
        }
            break;
            
        case State_FinishMask:
        {
            _img_StartPoint.hidden = YES;
            
            [m_TouchMask_aux removeFromSuperlayer];
            [m_aCoords addObject:[NSValue valueWithCGPoint:m_TapPoint]];
            TouchMask* touch = [[TouchMask alloc ] initWithCoords:m_aCoords
                                                         andFrame:self.view.frame
                                                    andIdentifier:_txtF_TouchID.text
                                                      andIsHidden:NO];
            [m_aTouchMasks addObject:touch];
            [self.view.layer addSublayer:touch];
            
            _view_MenuGeneral.hidden        = YES;
            _view_MenuNewTouch.hidden       = NO;
            _view_MenuCreateTouch.hidden    = YES;

            _txtF_TouchID.text = @"";
            m_TouchMask_aux = NULL;
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


- (void) autoCompleteRectangle
{
    float x = [m_aCoords[0] CGPointValue].x;
    float y = [m_aCoords[0] CGPointValue].y;
    [m_aCoords addObject:[NSValue valueWithCGPoint:CGPointMake(m_TapPoint.x,y)]];
    [m_aCoords addObject:[NSValue valueWithCGPoint:m_TapPoint]];
    [m_aCoords addObject:[NSValue valueWithCGPoint:CGPointMake(x,m_TapPoint.y)]];
    
    _img_StartPoint.hidden = YES;
    
    [m_TouchMask_aux removeFromSuperlayer];
    TouchMask* touch = [[TouchMask alloc ] initWithCoords:m_aCoords
                                                 andFrame:self.view.frame
                                            andIdentifier:_txtF_TouchID.text
                                              andIsHidden:NO];
    [m_aTouchMasks addObject:touch];
    [self.view.layer addSublayer:touch];
    
    _view_MenuGeneral.hidden        = YES;
    _view_MenuNewTouch.hidden       = NO;
    _view_MenuCreateTouch.hidden    = YES;
    
    _txtF_TouchID.text = @"";
    m_TouchMask_aux = NULL;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)swipe_ShowMenu:(id)sender {
    [self showMenu];
}

- (IBAction)swipe_HideMenu:(id)sender {
    [self hideMenu];
}


//-----1. Functions of Main Menu----------------
- (IBAction)newMask_Pressed:(id)sender
{
    _view_MenuGeneral.hidden        = YES;
    _view_MenuNewTouch.hidden       = NO;
    _view_MenuCreateTouch.hidden    = YES;
    _txtF_TouchID.text = @"";
}

- (IBAction)loadAvi_Pressed:(id)sender
{
    _tableView.hidden = NO;
    m_eTypeTV_Editor = TV_Videos;
    [_tableView reloadData];
}

- (IBAction)loadXML_Pressed:(id)sender
{
    _tableView.hidden = NO;
    m_eTypeTV_Editor = TV_XMLFiles;
    [_tableView reloadData];
}

- (IBAction)backFromTableView_Pressed:(id)sender
{
    _tableView.hidden = YES;
}

- (IBAction)editMask_Pressed:(id)sender
{
    
}

- (IBAction)sendXML_Pressed:(id)sender
{
    NSString *fileName = @"Scene.xml";
    [self createXMLFromTouchMasks:fileName];
    // Email Subject
    NSString *emailTitle = @"Scene.xml";
    // Email Content
    NSString *messageBody = @"scene with touchmasks";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObjects:
                            @"ivan.molera@gmail.com",nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Get the resource path and read the file using NSData
    NSString* graphFilterPath = [AppDelegate getAGPath];
    NSString *filePath = [graphFilterPath stringByAppendingPathComponent:fileName];
    
    
    
    // Add attachment
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    [mc addAttachmentData:fileData mimeType:@"application/xml" fileName:@"Scene.xml"];
    
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)backFromMainMenu_Pressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//--------------------------------------------



//-----2. Functions of New Touch----------------
- (IBAction)backFromMenuNewTouch_Pressed:(id)sender {
    _view_MenuGeneral.hidden        = NO;
    _view_MenuNewTouch.hidden       = YES;
    _view_MenuCreateTouch.hidden    = YES;
}

- (IBAction)rectangle_Pressed:(id)sender
{
    [_txtF_TouchID resignFirstResponder];
    if ([_txtF_TouchID.text isEqual:@""])
    {
        NSString* title = @"Error creando touchmask";
        NSString* msg   = @"el campo touchID es obligatorio";
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:title
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles: nil];
        
        [alert show];
    }
    else
    {
        _view_MenuGeneral.hidden        = YES;
        _view_MenuNewTouch.hidden       = YES;
        _view_MenuCreateTouch.hidden    = NO;
        
        m_bRectangleMode = true;
        _lbl_TypeTouchMask.text = @"(Rectangle mode)";
        
        m_eState = State_StartNewMask;
        [self updateStateMachine];
        _btn_Undo.enabled = NO;
    }
}

- (IBAction)multiPoints_Pressed:(id)sender
{
    [_txtF_TouchID resignFirstResponder];
    
    if ([_txtF_TouchID.text isEqual:@""])
    {
        NSString* title = @"Error creando touchmask";
        NSString* msg   = @"el campo touchID es obligatorio";
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:title
                                                      message:msg
                                                     delegate:self
                                            cancelButtonTitle:@"Ok"
                                            otherButtonTitles: nil];
        
        [alert show];
    }
    else
    {
        _view_MenuGeneral.hidden        = YES;
        _view_MenuNewTouch.hidden       = YES;
        _view_MenuCreateTouch.hidden    = NO;
        
        m_bRectangleMode = false;
        _lbl_TypeTouchMask.text = @"(Multitouch mode)";
        
        m_eState = State_StartNewMask;
        [self updateStateMachine];
        _btn_Undo.enabled = NO;
    }
}

- (IBAction)done_TouchID:(id)sender {
    [sender resignFirstResponder];
}
//--------------------------------------------



//-----3. Functions of Create Touch----------------
- (IBAction)backFromMenuCreateTouch_Pressed:(id)sender {
    _view_MenuGeneral.hidden        = YES;
    _view_MenuNewTouch.hidden       = NO;
    _view_MenuCreateTouch.hidden    = YES;
    
    _img_StartPoint.hidden = YES;
    if (m_TouchMask_aux != NULL)
    {
        [m_TouchMask_aux removeFromSuperlayer];
        m_TouchMask_aux = NULL;
    }
    _txtF_TouchID.text = @"";
}



- (IBAction)undo_Pressed:(id)sender
{
    if (m_bRectangleMode == true)
    {
        //Nothing todo: no implemento per ara el undo per la versió rectangle
    }
    else
    {
        if (m_aCoords.count < 2) return;
        [m_aCoords removeObjectAtIndex:m_aCoords.count-1];
        if (m_aCoords.count == 1) _btn_Undo.enabled = NO;
        if (m_TouchMask_aux != NULL)
        {
            [m_TouchMask_aux removeFromSuperlayer];
        }
        m_TouchMask_aux = [[TouchMask alloc ] initWithCoords:m_aCoords
                                                    andFrame:self.view.frame
                                               andIdentifier:@"kaka"
                                                 andIsHidden:NO];
        [self.view.layer addSublayer:m_TouchMask_aux];
    }
}
//--------------------------------------------


- (IBAction)newPoint_TapGesture:(id)sender
{
    m_TapPoint= [sender locationInView:self.view];
    int tapX = (int) m_TapPoint.x;
    int tapY = (int) m_TapPoint.y;
    NSLog(@"SINGLE TAPPED X:%d Y:%d", tapX, tapY);
    
    if (m_eState== State_WaitNextPoint)
    {
        [self updateStateMachine];
    }
}

- (IBAction)LastPoint_TapGesture:(id)sender
{
    m_TapPoint = [sender locationInView:self.view];
    int tapX = (int) m_TapPoint.x;
    int tapY = (int) m_TapPoint.y;
    NSLog(@"DOUBLE TAPPED X:%d Y:%d", tapX, tapY);
    
    if (m_eState == State_WaitNextPoint)
    {
        if (m_aCoords.count > 1)
        {
            m_eState = State_FinishMask;
            [self updateStateMachine];
        }
        else
        {
            NSString* title = @"Error editando touchmask";
            NSString* msg   = @"una touch mask ha de contener como mínimo 3 puntos";
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                         delegate:self
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles: nil];
            
            [alert show];
        }
        
    }
}



- (void) createXMLFromTouchMasks:(NSString*) filename
{
    if (![AppDelegate createAGDirectory])
    {
        NSLog(@"ERROR creant el xml: %@", filename);
        return;
    }
    
    NSString* graphFilterPath = [AppDelegate getAGPath];
    NSString *filePath = [graphFilterPath stringByAppendingPathComponent:filename];
    
    
    NSLog(@"Saving Scene XML: %@",filename);
    
    CXMLTreeNode NewXML;
    
    const char *cString = [filePath UTF8String];
    if (NewXML.StartNewFile(cString))
    {
        // We fill the Scene here:
        NewXML.StartElement("Escena");
        
        NewXML.WritePszProperty("id", "0");
        NewXML.StartElement("TouchMasks");
        
        for (TouchMask* mask in m_aTouchMasks)
        {
            NewXML.StartElement("TouchMask");
            NewXML.WritePszProperty("id", [mask.identifier UTF8String]);
            
            NewXML.StartElement("Coords");
            int step = 0;
            for (NSValue *coord in mask.m_aCoords)
            {
                
                //<Coord step="0"     posX="567"  posY="514"/>
                NewXML.StartElement("Coord");
                NewXML.WriteIntProperty("step",step);
                //Convert pixels-->%
                int x = [coord CGPointValue].x;
                int y = [coord CGPointValue].y;
                float xPercent = x / self.view.frame.size.width;
                float yPercent = y / self.view.frame.size.height;
                NewXML.WriteFloatProperty("posX", xPercent);
                NewXML.WriteFloatProperty("posY", yPercent);
                NewXML.EndElement(); //Coords
                step++;
            }
            NewXML.EndElement(); //Coords
            
            
            NewXML.EndElement(); //TouchMask
        }
        
        
        NewXML.EndElement(); //TouchMasks
        NewXML.EndElement(); //Escena
        NewXML.EndNewFile();
    }
}



- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void) namePressed:(int) _index
{
    _tableView.hidden = YES;
    
    switch (m_eTypeTV_Editor) {
        case TV_Videos:
        {
            NSString* nameVideo = m_aVideos[_index];
            nameVideo = [nameVideo lastPathComponent];
            nameVideo = [nameVideo stringByDeletingPathExtension];
            NSBundle *bundle    = [NSBundle mainBundle];
            NSString *path      = [bundle pathForResource:nameVideo ofType:@"mp4"];
            NSURL *movieUrl     = [NSURL fileURLWithPath:path];
            
            AVURLAsset *movieOneItemAsset = [AVURLAsset URLAssetWithURL:movieUrl options:nil];
            AVPlayerItem *movieItem = [AVPlayerItem playerItemWithAsset:movieOneItemAsset];
            
            [_moviePlayer replaceCurrentItemWithPlayerItem:movieItem];
            [_movieLayer setPlayer:_moviePlayer];
        }
            break;
        case TV_XMLFiles:
        {
            [m_aCoords removeAllObjects];
            for(TouchMask* touchmask in m_aTouchMasks)
            {
                [touchmask removeFromSuperlayer];
            }
            [m_aTouchMasks removeAllObjects];
            
            NSString* namefile = m_aXMLScenes[_index];
            CXMLTreeNode xmlTN;
            if (!xmlTN.LoadFile([namefile UTF8String]))
            {
                NSLog(@"Error LoadXML:%@",namefile);
            }
            else
            {
                NSLog(@"Parsing file: %@",[namefile lastPathComponent]);
                
                CXMLTreeNode  escenaTN = xmlTN["Escena"];
                //<Escena id="0">
                if (escenaTN.Exists())
                {
                    CXMLTreeNode  touchMasksTN = xmlTN["TouchMasks"];
                    // <TouchMasks>
                    if (touchMasksTN.Exists())
                    {
                        int count = touchMasksTN.GetNumChildren();
                        for (int i = 0; i < count; ++i)
                        {
                            // <TouchMask id="1">
                            CXMLTreeNode  touchMaskTN = touchMasksTN(i);
                            
                            const char* _touchMaskID   = touchMaskTN.GetPszProperty("id");
                            NSString* touchMaskID      = [NSString stringWithUTF8String:_touchMaskID];
                            //<Coords>
                            CXMLTreeNode  coordsTN = touchMaskTN["Coords"];
                            if (coordsTN.Exists())
                            {
                                NSMutableArray *coords = [[NSMutableArray alloc] init];
                                int count2 = coordsTN.GetNumChildren();
                                for (int j = 0; j < count2; ++j)
                                {
                                    //<Coord step="0">522,602</Coord>
                                    CXMLTreeNode  coordTN = coordsTN(j);
                                    float posX_precent = 0;
                                    float posY_precent = 0;
                                    posX_precent = coordTN.GetFloatProperty("posX");
                                    posY_precent = coordTN.GetFloatProperty("posY");
                                    int w = self.view.frame.size.width;
                                    int h = self.view.frame.size.height;
                                    int posX = (int)(posX_precent * self.view.frame.size.width);
                                    int posY = (int)(posY_precent * self.view.frame.size.height);
                                    [coords addObject:[NSValue valueWithCGPoint:CGPointMake(posX, posY)]];
                                }
                                TouchMask* newTouchMask = [[TouchMask alloc ] initWithCoords:coords
                                                                                    andFrame:self.view.frame
                                                                               andIdentifier:touchMaskID andIsHidden:NO];
                                [self.view.layer addSublayer:newTouchMask];
                                [m_aTouchMasks addObject:newTouchMask];
                            }
                        }
                        
                    }//END: if (touchMasksTN.Exists())

                }//END:if (escenaTN.Exists())
            }
        }
        default:
            break;
    }
}

#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (m_eTypeTV_Editor) {
        case TV_Videos:
        {
            return m_aVideos.count;
        }
            break;
        case TV_XMLFiles:
        {
            return m_aXMLScenes.count;
        }
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditorCell";
    EditorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[EditorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    [cell setIndex:(int)indexPath.row andController:self];
    
    switch (m_eTypeTV_Editor) {
        case TV_Videos:
        {
            NSString *xmlFullPath = m_aVideos[indexPath.row];
            [cell.btn_Name setTitle:[xmlFullPath lastPathComponent] forState:UIControlStateNormal];
        }
            break;
        case TV_XMLFiles:
        {
            NSString *xmlFullPath = m_aXMLScenes[indexPath.row];
            [cell.btn_Name setTitle:[xmlFullPath lastPathComponent] forState:UIControlStateNormal];
        }
        default:
            break;
    }
    
    return cell;
}




@end
