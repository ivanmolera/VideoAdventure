//
//  Item.m
//  aventura
//
//  Created by IVAN MOLERA on 05/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "Item.h"
#import "Inventory.h"
#import "TouchMask.h"

@implementation Item
{
    Inventory* _inventari;
}

- (void)withInventory:(Inventory *)inventari
{
    _inventari = inventari;
}

- (id) initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.identifier     = identifier;
        self.description    = NSLocalizedString(identifier, nil);

        UIImage *imatge     = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", identifier]];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setBackgroundImage:imatge forState:UIControlStateNormal];
        
        [self.button.layer setCornerRadius:10.0f];
        [self.button.layer setMasksToBounds:YES];
        
        // add drag listener
        [self.button addTarget:self action:@selector(wasDragged:withEvent:)
         forControlEvents:UIControlEventTouchDragInside];
        
        [self.button addTarget:self action:@selector(onDragEnd:withEvent:)
              forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    [self.escena removeLabelsFromEscena];

	// get the touch
	UITouch *touch = [[event touchesForView:button] anyObject];

	// get delta
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;
    
    button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);
}

- (void) onDragEnd:(UIButton *)button withEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event touchesForView:button] anyObject];
    
	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
    
    NSLog(@"%f = %f, %f = %f", previousLocation.x, location.x, previousLocation.y, location.y);
    
    NSLog(@"x = %f",self.button.center.y);
    
    if (self.button.center.y > 0) {
        [_inventari ordenaItems];
    }

    // touch mostro descripció
    if(abs(round(previousLocation.x - location.x)) <= 8 && abs(round(previousLocation.y - location.y)) <= 8) {
        [self showDescription];
    }
    else {
        [self.escena removeLabelsFromEscena];

        // get location
        CGPoint butonCenter = button.center;
    
        NSLog(@"%f,%f", butonCenter.x, butonCenter.y);

        for (id sublayer in self.escena.layer.sublayers) {
        
            if ([sublayer isKindOfClass:[TouchMask class]]) {
            
                TouchMask *shapeLayer = sublayer;
            
                if (CGPathContainsPoint(shapeLayer.path, 0, butonCenter, YES)) {
                    NSLog(@"touchInLayer %@", shapeLayer.identifier);
                }
            }
        }
    }
}

- (void)showDescription {
    NSLog(@"%@", self.description);
    [self.escena removeLabelsFromEscena];
    [self.escena showMessage:self.description];
}

@end
