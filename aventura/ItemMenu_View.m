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
        [self.lbl_Pregunta setFont:fontComic_20];
        
        //UIFont *fontComic_24 = [UIFont fontWithName: @"Laffayette Comic Pro" size: 24.0f];
        //self.btn_No.titleLabel.font = fontComic_24;
        //self.btn_Si.titleLabel.font = fontComic_24;
        [self.btn_No setTitle:NSLocalizedString(@"NO",nil) forState:UIControlStateNormal];
        [self.btn_Si setTitle:NSLocalizedString(@"YES",nil) forState:UIControlStateNormal];
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

- (void) setIdentifier:(NSString *)_identifier
{
    UIImage *imatge = [UIImage imageNamed:[NSString stringWithFormat:@"item%@.png", _identifier]];
    self.img_Item.image = imatge;
    
    NSString *txt = [NSString stringWithFormat:@"txt_getItem_item%@", _identifier];
    self.lbl_Pregunta.text = NSLocalizedString(txt, nil);
}

- (void) setPosition:(CGPoint) _pos;
{
    CGRect frame = self.frame;
    frame.origin.x = _pos.x - (frame.size.width*0.5);
    frame.origin.y = _pos.y - (frame.size.height*0.5);
    self.frame = frame;
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
