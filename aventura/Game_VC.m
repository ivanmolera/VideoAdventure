//
//  ViewController.m
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//----Imports:-----------
#import "Game_VC.h"
#import "Escena.h"
#import "TouchMask.h"
#import "Action.h"
#import "Inventory.h"
#import "Item.h"
#import "XMLTreeNode.h"
//-----------------------

@interface Game_VC ()

@end

@implementation Game_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self loadAllXML];
    
    // Inventari
    self.inventory = [[Inventory alloc] initWithFrame:self.view.frame];
    [self.inventory setEscena:self.m_aEscenes[self.m_iCurrentEscena]];
    
    [self loadInventoryXML];
    //[self loadXML:@""];

    [self.view addSubview:self.m_aEscenes[self.m_iCurrentEscena]];

    //Botó Back:
    _btn_Back = [[UIButton alloc] initWithFrame:CGRectMake(20,25,100,50)];
    [_btn_Back setTitle:@"Back" forState:UIControlStateNormal];
    _btn_Back.titleLabel.font = [UIFont systemFontOfSize:30];
    [_btn_Back addTarget:self action:@selector(back_Pressed:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btn_Back];
    
    // Botó show/hide masks
    self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.height-80, 35, 100, 40)];
    [self.switchBtn setOn:NO];
    [self.switchBtn addTarget:self
                       action:@selector(showHideMasks)
             forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.switchBtn];

    [self.view addSubview:self.inventory];
    [self.view bringSubviewToFront:self.inventory];
}

- (void) showHideMasks {
    Escena *currentEscena = self.m_aEscenes[self.m_iCurrentEscena];

    for (id sublayer in currentEscena.layer.sublayers) {
        
        if ([sublayer isKindOfClass:[TouchMask class]]) {
            if([sublayer isHidden]) {
                [sublayer setHidden:NO];
                [sublayer setOpacity:1];
            }
            else {
                [sublayer setHidden:YES];
                [sublayer setOpacity:0];
            }
        }
    }
    [self.view setNeedsDisplay];
    [self.m_aEscenes[self.m_iCurrentEscena] removeFromSuperview];
    [self.switchBtn removeFromSuperview];
    [self.btn_Back removeFromSuperview];
    [self.view addSubview:self.m_aEscenes[self.m_iCurrentEscena]];
    [self.view addSubview:self.switchBtn];
    [self.view addSubview:_btn_Back];
    [self.view addSubview:self.inventory];
    [self.view bringSubviewToFront:self.inventory];
}

- (void) update:(int)eventType {
    
    Escena *currentEscena = self.m_aEscenes[self.m_iCurrentEscena];
    
    CGPoint firstPoint  = [[self.beginTouchPoints objectAtIndex:0] CGPointValue];
    //CGPoint secondPoint = [[self.endTouchPoints objectAtIndex:0] CGPointValue];
    
    for (id sublayer in currentEscena.layer.sublayers) {
        
        if ([sublayer isKindOfClass:[TouchMask class]]) {
            
            TouchMask *shapeLayer = sublayer;
            
            if (CGPathContainsPoint(shapeLayer.path, 0, firstPoint, YES)) {
                NSLog(@"touchInLayer %@", shapeLayer.identifier);
                
                Estat *currentEstat = currentEscena.m_aEstats[currentEscena.m_iCurrentEstat];
                
                for (Action* action in currentEstat.m_aActions) {
                    
                    bool canDoAction = [action check:shapeLayer.identifier];

                    if(canDoAction) {
                        [self.inventory ordenaItems];

                        NSLog(@"Action %@", action.identifier);
                        [action doAction];
                    }
                }
                
                break;
            }
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.beginTouchPoints = [[NSMutableArray alloc] init];

    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.view];
        [self.beginTouchPoints addObject:[NSValue valueWithCGPoint:touchLocation]];
        NSLog(@"%f,%f", touchLocation.x, touchLocation.y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.endTouchPoints = [[NSMutableArray alloc] init];
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self.view];
        [self.endTouchPoints addObject:[NSValue valueWithCGPoint:touchLocation]];
        NSLog(@"%f,%f", touchLocation.x, touchLocation.y);
    }
    
    [self update:EventTypeTouch];
}

- (void) loadAllXML
{
    
    NSMutableArray *escenes = [[NSMutableArray alloc] init];
    
    NSLog(@"-------Loading XML Scenes---------");
    NSArray* aXMLScenes = [[NSBundle mainBundle] pathsForResourcesOfType:@"xml" inDirectory:nil];
    for(NSString *sceneXML in aXMLScenes)
    {
        CXMLTreeNode xmlTN;
        if (!xmlTN.LoadFile([sceneXML UTF8String]))
        {
            NSLog(@"Error LoadXML:%@",sceneXML);
        }
        else
        {
            NSLog(@"%@",[sceneXML lastPathComponent]);
            
            CXMLTreeNode  escenaTN = xmlTN["Escena"];
            //<Escena id="0">
            if (escenaTN.Exists())
            {
                CGRect frame = CGRectMake(0,
                                          0,
                                          self.view.frame.size.height,
                                          self.view.frame.size.width);
                
                const char* _escenaID   = escenaTN.GetPszProperty("id");
                NSString* escenaID      = [NSString stringWithUTF8String:_escenaID];
                Escena *escena = [[Escena alloc] initWithIdentifier:escenaID andFrame:frame];
                
                CXMLTreeNode  touchMasksTN = xmlTN["TouchMasks"];
                NSMutableArray *masks = [[NSMutableArray alloc] init];
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
                            
                                // CANVIS IVAN
                                float posX = (float)(posX_precent * self.view.frame.size.height);
                                float posY = (float)(posY_precent * self.view.frame.size.height);
                                // CANVIS IVAN
                                [coords addObject:[NSValue valueWithCGPoint:CGPointMake(posX, posY)]];
                            }
                            [masks addObject:[[TouchMask alloc ] initWithCoords:coords
                                                                       andFrame:self.view.frame
                                                                  andIdentifier:touchMaskID andIsHidden:YES]];
                        }
                    }
                    
                    [escena setMasks:masks];
                    [escena setM_aTouchMasks:masks];
                
                }//END: if (touchMasksTN.Exists())
                
                CXMLTreeNode  actionsTN = xmlTN["Actions"];
                NSMutableArray *actions = [[NSMutableArray alloc] init];
                // <Actions>
                if (actionsTN.Exists())
                {
                    int count = actionsTN.GetNumChildren();
                    for (int i = 0; i < count; ++i)
                    {
                        // <Action id="1" type="jumpToState" target="0">
                        CXMLTreeNode  actionTN = actionsTN(i);
                        
                        const char* _actionID   = actionTN.GetPszProperty("id");
                        NSString* actionID      = [NSString stringWithUTF8String:_actionID];

                        Action *action = [[Action alloc] initWithIdentifier:actionID];
                        action.escena = escena;
                        
                        const char* _type   = actionTN.GetPszProperty("type");
                        NSString* type      = [NSString stringWithUTF8String:_type];
                        
                        if ([type isEqualToString:@"jumpToState"])
                        {
                            int target = 0;
                            target                  = actionTN.GetIntProperty("target");
                            action.target           = target;
                            action.m_iType          = ActionTypeJumpToState;
                            const char* _sound      = actionTN.GetPszProperty("playSound", "");
                            action.playSound        = [NSString stringWithUTF8String:_sound];
                            int _repeatMode         = actionTN.GetIntProperty("repeatMode");
                            action.repeatMode       = (_repeatMode == 1);
                            const char* _playMode   = actionTN.GetPszProperty("playMode", "");
                            NSString* playMode      = [NSString stringWithUTF8String:_playMode];
                            if ([playMode isEqualToString:@"normal"])
                            {
                                action.playMode = ActionPlayMpde_Normal;
                            }
                            else
                            {
                                action.playMode = ActionPlayMpde_Reverse;
                            }
                        }
                        else if ([type isEqualToString:@"showMessage"])
                        {
                            const char* _message    = actionTN.GetPszProperty("message");
                            NSString* message       = [NSString stringWithUTF8String:_message];
                            action.m_iType          = ActionTypeShowMessage;
                            action.message          = message;
                        }
                        else if ([type isEqualToString:@"jumpToScene"])
                        {
                            int _target         = actionTN.GetIntProperty("target");
                            action.m_iType      = ActionTypeJumpToScene;
                            action.target       = _target;
                        }
                        else if ([type isEqualToString:@"getItem"] || [type isEqualToString:@"useItem"])
                        {
                            const char* _message    = actionTN.GetPszProperty("message");
                            NSString* message       = [NSString stringWithUTF8String:_message];
                            action.message          = message;
                            int target = 0;
                            target                  = actionTN.GetIntProperty("target");
                            action.target           = target;
                            int nextState = 0;
                            nextState               = actionTN.GetIntProperty("nextState");
                            action.nextState         = nextState;
                        }
                        
                        NSMutableArray *masks_aux = [[NSMutableArray alloc] init];
                        int count2 = actionTN.GetNumChildren();
                        for (int j = 0; j < count2; ++j)
                        {
                            //<TouchMask id="3"/>
                            CXMLTreeNode  touchMaskTN = actionTN(j);
                            int _id = 1;
                            _id  = touchMaskTN.GetIntProperty("id");
                            [masks_aux addObject:masks[_id-1]];
                        }
                        [action setM_aTouchMasks:masks_aux];
                        [actions addObject:action];
                    }
                    
                    [escena setM_aActions:actions];
                    
                }//END: if (actionsTN.Exists())
                
                
                CXMLTreeNode  estatsTN = xmlTN["Estats"];
                NSMutableArray *estats = [[NSMutableArray alloc] init];
                // <Estats>
                if (estatsTN.Exists())
                {
                    int count = estatsTN.GetNumChildren();
                    for (int i = 0; i < count; ++i)
                    {
                        // <Estat id="0" videoURL="AG_0001">
                        CXMLTreeNode  estatTN = estatsTN(i);
                        
                        const char* _estatID   = estatTN.GetPszProperty("id");
                        NSString* estatID      = [NSString stringWithUTF8String:_estatID];
                        
                        Estat *estat = [[Estat alloc] initWithIdentifier:estatID];
                        
                        const char* _videoURL   = estatTN.GetPszProperty("videoURL");
                        NSString* videoURL      = [NSString stringWithUTF8String:_videoURL];
                        
                        estat.m_sVideoURL = videoURL;
                        
                        NSMutableArray *actions_aux = [[NSMutableArray alloc] init];
                        int count2 = estatTN.GetNumChildren();
                        for (int j = 0; j < count2; ++j)
                        {
                            //<Action id="1"/>
                            CXMLTreeNode  actionTN = estatTN(j);
                            int _id = 1;
                            _id  = actionTN.GetIntProperty("id");
                            [actions_aux addObject:actions[_id-1]];
                        }

                        [estat setM_aActions:actions_aux];
                        [estats addObject:estat];
                    }
                    
                    [escena setM_aEstats:estats];
                    
                    escena.m_iCurrentEstat = 0;
                    [escena setCurrentEstat:[estats objectAtIndex:escena.m_iCurrentEstat]];
                    
                    
                    [escenes addObject:escena];
                    
                    
                    
                }//END: if (estatsTN.Exists())
            
            }//END if (escenaTN.Exists())
        }
    }
    NSLog(@"----------------------------------");
    
    [self setM_aEscenes:escenes];
    self.m_iCurrentEscena = 0;
}

- (void) loadInventoryXML
{
    NSLog(@"-------Loading XML Inventory---------");
    NSArray* aXMLScenes = [[NSBundle mainBundle] pathsForResourcesOfType:@"xml" inDirectory:nil];
    for(NSString *sceneXML in aXMLScenes)
    {
        CXMLTreeNode xmlTN;
        if (!xmlTN.LoadFile([sceneXML UTF8String]))
        {
            NSLog(@"Error LoadXML:%@",sceneXML);
        }
        else
        {
            NSLog(@"%@",[sceneXML lastPathComponent]);
            
            CXMLTreeNode  inventoryTN = xmlTN["Inventory"];
            //<Inventory>
            if (inventoryTN.Exists())
            {
                int count = inventoryTN.GetNumChildren();
                for (int i = 0; i < count; ++i)
                {
                    // <Item id="item0001"/>
                        
                    CXMLTreeNode  itemTN = inventoryTN(i);
                    const char* _itemID   = itemTN.GetPszProperty("id");
                    NSString* itemID      = [NSString stringWithUTF8String:_itemID];
                        
                    Item *newItem = [[Item alloc] initWithIdentifier:itemID];
                    [self.inventory addItem:newItem];
                }
            }
        }
    }
    NSLog(@"----------------------------------");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) back_Pressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
