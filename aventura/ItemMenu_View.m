//
//  ItemMenu_View.m
//  aventura
//
//  Created by DonKikochan on 21/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "ItemMenu_View.h"

@implementation ItemMenu_View


- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ItemMenu" owner:self options:nil] objectAtIndex:0];
    if (self)
    {
        // Initialization code
        self.frame = frame;
        
        [self.layer setCornerRadius:10.0f];
        [self.layer setMasksToBounds:YES];
        
        [self.img_Item.layer setCornerRadius:10.0f];
        [self.img_Item.layer setMasksToBounds:YES];
        
        UIFont *fontComic_20 = [UIFont fontWithName: @"Laffayette Comic Pro" size: 20.0f];
        UIFont *fontComic_24 = [UIFont fontWithName: @"Laffayette Comic Pro" size: 24.0f];
        [self.lbl_Pregunta setFont:fontComic_20];
        self.btn_No.titleLabel.font = fontComic_24;
        self.btn_Si.titleLabel.font = fontComic_24;
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)si_Pressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ITEM_MENU_YES_PRESSED"
                                                        object:nil];
    [self hideMenu];
}

- (IBAction)no_Pressed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ITEM_MENU_NO_PRESSED"
                                                        object:nil];
     [self hideMenu];
}


- (void) showMenu
{
    self.hidden = NO;
}

- (void) hideMenu
{
    self.hidden = YES;
}

@end
