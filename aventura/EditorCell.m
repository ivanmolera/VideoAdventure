//
//  EditorCell.m
//  aventura
//
//  Created by DonKikochan on 06/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

//---Imports:------------
#import "EditorCell.h"
#import "EditorTouchMask_VC.h"
//-----------------------

@implementation EditorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIndex:(int) _index andController:(EditorTouchMask_VC*)_controller
{
    m_iIndex = _index;
    m_Controller = _controller;
}
- (IBAction)name_Pressed:(id)sender
{
    [m_Controller namePressed:m_iIndex];
}
@end
