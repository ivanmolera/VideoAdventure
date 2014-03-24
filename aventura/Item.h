//
//  Item.h
//  aventura
//
//  Created by IVAN MOLERA on 05/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Escena.h"

@class Inventory;

@interface Item : NSObject
{}

//---Properties:
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) Escena*   escena;

//---Funtions:
- (id) initWithIdentifier:(NSString *)identifier;
- (void)withInventory:(Inventory *)inventari;

@end
