//
//  ViewController.m
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "ViewController.h"
#import "Escena.h"
#import "TouchMask.h"
#import "Action.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [self loadXML:@""];

    [self.view addSubview:self.m_aEscenes[self.m_iCurrentEscena]];

    // Botó show/hide masks
    self.switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(20, 35, 200, 40)];
    [self.switchBtn setOn:YES];
    [self.switchBtn addTarget:self
               action:@selector(showHideMasks)
     forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.switchBtn];
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
    [self.view addSubview:self.m_aEscenes[self.m_iCurrentEscena]];
    [self.view addSubview:self.switchBtn];
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

- (void) loadXML:(NSString *)pathXML {

    CGRect frame = CGRectMake(0,
                              0,
                              self.view.frame.size.height,
                              self.view.frame.size.width);

    Escena *escena = [[Escena alloc] initWithIdentifier:@"1" andFrame:frame];
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask1]];
    [masks addObject:[self myMask2]];
    [masks addObject:[self myMask3]];
    [masks addObject:[self myMask4]];
    
    [escena setMasks:masks];
    [escena setM_aTouchMasks:masks];
    
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    [actions addObject:[self myAction1:escena]];
    [actions addObject:[self myAction2:escena]];
    [actions addObject:[self myAction3:escena]];
    [actions addObject:[self myAction4:escena]];
    [actions addObject:[self myAction5:escena]];
    [actions addObject:[self myAction6:escena]];
    [actions addObject:[self myAction7:escena]];
    [actions addObject:[self myAction8:escena]];
    [actions addObject:[self myAction9:escena]];
    [actions addObject:[self myAction10:escena]];
    
    [escena setM_aActions:actions];

    NSMutableArray *estats = [[NSMutableArray alloc] init];
    [estats addObject:[self myEstat0:escena]];
    [estats addObject:[self myEstat1:escena]];
    [estats addObject:[self myEstat2:escena]];
    [estats addObject:[self myEstat3:escena]];
    [estats addObject:[self myEstat4:escena]];
    [estats addObject:[self myEstat5:escena]];
    [estats addObject:[self myEstat6:escena]];
    [estats addObject:[self myEstat7:escena]];

    [escena setM_aEstats:estats];
    
    escena.m_iCurrentEstat = 0;
    [escena setCurrentEstat:[estats objectAtIndex:escena.m_iCurrentEstat]];

    NSMutableArray *escenes = [[NSMutableArray alloc] init];
    [escenes addObject:escena];
    
    [self setM_aEscenes:escenes];
    self.m_iCurrentEscena = 0;
}

/////////////////// INICIALITZACIÓ ///////////////////

- (Estat *)myEstat0:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"0"];
    
    estat.m_sVideoURL = @"AG_0001";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction1:escena],
                          [self myAction2:escena],
                          [self myAction9:escena], nil ]];

    return estat;
}

- (Action *)myAction1:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"1"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 0;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask1]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Action *)myAction2:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"2"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 1;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask3]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Estat *)myEstat1:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"1"];
    
    estat.m_sVideoURL = @"AG_0002";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction3:escena],
                          [self myAction4:escena], nil ]];

    return estat;
}

- (Action *)myAction3:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"3"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 2;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask3]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Action *)myAction4:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"4"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 3;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask2]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Estat *)myEstat2:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"2"];
    
    estat.m_sVideoURL = @"AG_0003";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction1:escena],
                          [self myAction2:escena],
                          [self myAction9:escena], nil ]];
    
    return estat;
}

- (Estat *)myEstat3:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"3"];
    
    estat.m_sVideoURL = @"AG_0004";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction5:escena],
                          [self myAction6:escena], nil ]];

    return estat;
}

- (Action *)myAction5:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"5"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 4;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask2]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Action *)myAction6:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"6"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 5;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask3]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Estat *)myEstat4:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"4"];
    
    estat.m_sVideoURL = @"AG_0005";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction3:escena],
                          [self myAction4:escena], nil ]];
    
    return estat;
}

- (Estat *)myEstat5:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"5"];
    
    estat.m_sVideoURL = @"AG_0006";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction7:escena],
                          [self myAction8:escena],
                          [self myAction10:escena], nil ]];
    
    return estat;
}

- (Action *)myAction7:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"7"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 6;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask2]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Action *)myAction8:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"8"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeJumpToState;
    action.target       = 7;
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask3]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Estat *)myEstat6:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"6"];
    
    estat.m_sVideoURL = @"AG_0007";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction7:escena],
                          [self myAction8:escena], nil ]];
    
    return estat;
}

- (Estat *)myEstat7:(Escena*)escena {
    Estat *estat = [[Estat alloc] initWithIdentifier:@"7"];
    
    estat.m_sVideoURL = @"AG_0008";
    [estat setM_aActions:[[NSMutableArray alloc] initWithObjects:
                          [self myAction1:escena],
                          [self myAction2:escena],
                          [self myAction9:escena], nil ]];
    
    return estat;
}

- (Action *)myAction9:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"9"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeShowMessage;
    action.message      = @"txt_msg_0001";
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask4]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (Action *)myAction10:(Escena*)escena {
    Action *action = [[Action alloc] initWithIdentifier:@"10"];
    
    action.escena       = escena;
    action.m_iType      = ActionTypeShowMessage;
    action.message      = @"txt_msg_0002";
    
    NSMutableArray *masks = [[NSMutableArray alloc] init];
    [masks addObject:[self myMask2]];
    
    [action setM_aTouchMasks:masks];
    
    return action;
}

- (TouchMask *)myMask1 {
    static TouchMask *mask = nil;
    if(!mask) {
        
        NSMutableArray *coords = [[NSMutableArray alloc] initWithObjects:
                                  [NSValue valueWithCGPoint:CGPointMake(522, 602)],
                                  [NSValue valueWithCGPoint:CGPointMake(517, 607)],
                                  [NSValue valueWithCGPoint:CGPointMake(496, 638)],
                                  [NSValue valueWithCGPoint:CGPointMake(549, 656)],
                                  [NSValue valueWithCGPoint:CGPointMake(585, 647)],
                                  [NSValue valueWithCGPoint:CGPointMake(605, 637)],
                                  [NSValue valueWithCGPoint:CGPointMake(603, 605)],
                                  [NSValue valueWithCGPoint:CGPointMake(572, 593)],
                                  nil];
        
        mask = [[TouchMask alloc ] initWithCoords:coords andFrame:self.view.frame andIdentifier:@"1"];
    }
    return mask;
}

- (TouchMask *)myMask2 {
    static TouchMask *mask = nil;
    if(!mask) {
        
        NSMutableArray *coords = [[NSMutableArray alloc] initWithObjects:
                                  [NSValue valueWithCGPoint:CGPointMake(567,514)],
                                  [NSValue valueWithCGPoint:CGPointMake(597,509)],
                                  [NSValue valueWithCGPoint:CGPointMake(625, 514)],
                                  [NSValue valueWithCGPoint:CGPointMake(630, 564)],
                                  [NSValue valueWithCGPoint:CGPointMake(604, 602)],
                                  [NSValue valueWithCGPoint:CGPointMake(623, 665)],
                                  [NSValue valueWithCGPoint:CGPointMake(596, 674)],
                                  [NSValue valueWithCGPoint:CGPointMake(564, 662)],
                                  [NSValue valueWithCGPoint:CGPointMake(592, 601)],
                                  [NSValue valueWithCGPoint:CGPointMake(570, 586)],
                                  [NSValue valueWithCGPoint:CGPointMake(560, 553)],
                                  nil];
        
        mask = [[TouchMask alloc ] initWithCoords:coords andFrame:self.view.frame andIdentifier:@"2"];
    }
    return mask;
}

- (TouchMask *)myMask3 {
    static TouchMask *mask = nil;
    if(!mask) {
        
        NSMutableArray *coords = [[NSMutableArray alloc] initWithObjects:
                                  [NSValue valueWithCGPoint:CGPointMake(809,603)],
                                  [NSValue valueWithCGPoint:CGPointMake(838,616)],
                                  [NSValue valueWithCGPoint:CGPointMake(809,603)],
                                  [NSValue valueWithCGPoint:CGPointMake(838,616)],
                                  [NSValue valueWithCGPoint:CGPointMake(858,635)],
                                  [NSValue valueWithCGPoint:CGPointMake(880,616)],
                                  [NSValue valueWithCGPoint:CGPointMake(884,501)],
                                  [NSValue valueWithCGPoint:CGPointMake(902,479)],
                                  [NSValue valueWithCGPoint:CGPointMake(906,409)],
                                  [NSValue valueWithCGPoint:CGPointMake(929,407)],
                                  [NSValue valueWithCGPoint:CGPointMake(930,476)],
                                  [NSValue valueWithCGPoint:CGPointMake(947,499)],
                                  [NSValue valueWithCGPoint:CGPointMake(939,651)],
                                  [NSValue valueWithCGPoint:CGPointMake(934,667)],
                                  [NSValue valueWithCGPoint:CGPointMake(914,673)],
                                  [NSValue valueWithCGPoint:CGPointMake(883,667)],
                                  [NSValue valueWithCGPoint:CGPointMake(847,670)],
                                  [NSValue valueWithCGPoint:CGPointMake(805,675)],
                                  [NSValue valueWithCGPoint:CGPointMake(774,659)],
                                  [NSValue valueWithCGPoint:CGPointMake(769,645)],
                                  nil];
        
        mask = [[TouchMask alloc ] initWithCoords:coords andFrame:self.view.frame andIdentifier:@"3"];
    }
    return mask;
}

- (TouchMask *)myMask4 {
    static TouchMask *mask = nil;
    if(!mask) {
        
        NSMutableArray *coords = [[NSMutableArray alloc] initWithObjects:
                                  [NSValue valueWithCGPoint:CGPointMake(650, 180)],
                                  [NSValue valueWithCGPoint:CGPointMake(800, 180)],
                                  [NSValue valueWithCGPoint:CGPointMake(800, 350)],
                                  [NSValue valueWithCGPoint:CGPointMake(650, 350)],
                                  nil];
        
        mask = [[TouchMask alloc ] initWithCoords:coords andFrame:self.view.frame andIdentifier:@"4"];
    }
    return mask;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
