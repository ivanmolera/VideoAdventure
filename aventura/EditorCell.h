//
//  EditorCell.h
//  aventura
//
//  Created by DonKikochan on 06/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditorTouchMask_VC;

@interface EditorCell : UITableViewCell
{
    int                 m_iIndex;
    EditorTouchMask_VC* m_Controller;
}

@property (strong, nonatomic) IBOutlet UIButton *btn_Name;

- (IBAction)name_Pressed:(id)sender;
- (void) setIndex:(int) _index andController:(EditorTouchMask_VC*)_controller;
@end
