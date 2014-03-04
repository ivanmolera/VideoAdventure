//
//  Inventory.h
//  aventura
//
//  Created by IVAN MOLERA on 04/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Inventory : UIView

@property (nonatomic, assign) bool              isShown;
@property (nonatomic, assign) CGRect            initFrame;
@property (nonatomic, strong) UIButton          *btn_showHide;

@end
