//
//  Inventory.h
//  aventura
//
//  Created by IVAN MOLERA on 04/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Escena.h"
#import "Item.h"

@interface Inventory : UIScrollView

@property (nonatomic, assign) CGRect            initFrame;
@property (nonatomic, strong) NSMutableArray    *items;

@property (nonatomic, strong) Escena            *escena;


- (void) addItem:(Item*)item;
- (void) ordenaItems;

@end
