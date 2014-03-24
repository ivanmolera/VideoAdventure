//
//  ItemMenu_View.h
//  aventura
//
//  Created by DonKikochan on 21/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemMenu_View.h"

@interface ItemMenu_View : UIView
{
    
}

//---IBOutlets:
@property (strong, nonatomic) IBOutlet UILabel *lbl_Pregunta;
@property (strong, nonatomic) IBOutlet UIButton *btn_Si;
@property (strong, nonatomic) IBOutlet UIButton *btn_No;
@property (strong, nonatomic) IBOutlet UIImageView *img_Item;

//---IBActions:
- (IBAction)si_Pressed:(id)sender;
- (IBAction)no_Pressed:(id)sender;

//---Functions:
- (void) hideMenu;
- (void) showMenu;
@end
