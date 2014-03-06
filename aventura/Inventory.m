//
//  Inventory.m
//  aventura
//
//  Created by IVAN MOLERA on 04/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "Inventory.h"
#import "Item.h"

@implementation Inventory

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        [self setHidden:NO];

        _initFrame = frame;

        [self setFrame:CGRectMake(0, _initFrame.size.width-95, 50, 95)];

        _btn_showHide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 95)];
        [_btn_showHide setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
        [_btn_showHide addTarget:self action:@selector(toggleShowHide:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_btn_showHide];

        [self bringSubviewToFront:_btn_showHide];

        _isShown = NO;
        
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addItem:(Item*)item {
    [item.button setFrame:CGRectMake(([self.items count]*150)+([self.items count]*5), 0, 150, 95)];
    [item.button setHidden:!_isShown];
    [item setEscena:self.escena];

    [self.items addObject:item];

    [self addSubview:item.button];
    [self bringSubviewToFront:item.button];
}

- (CGRect) getItemFrame:(Item*)item {
    int index = [self.items indexOfObject:item];
    int x = (index == 0) ? 5 : (index*145)+(index*5)+5;
    return CGRectMake(x, 5, 140, 85);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self];
        
        NSLog(@"%f,%f", touchLocation.x, touchLocation.y);
    }
}

- (void) toggleShowHide:(id)sender {
    if (!_isShown) {
        [self showInventory];
    }
    else {
        [self hideInventory];
    }
}

- (void) showInventory {
    self.frame =  CGRectMake(0, _initFrame.size.width-95, 50, 95);
    [UIView animateWithDuration:0.25 animations:^{
        self.frame =  CGRectMake(0, _initFrame.size.width-95, _initFrame.size.height, 95);
        [_btn_showHide setFrame:CGRectMake(_initFrame.size.height-50, 0, 50, 95)];
        
        for (Item *item in self.items) {
            [item.button setFrame:[self getItemFrame:item]];
            [item.button setHidden:NO];
        }
    }];
    
    [_btn_showHide setImage:[UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
    
    _isShown = YES;
}

- (void) hideInventory {
    [UIView animateWithDuration:0.25 animations:^{
        self.frame =  CGRectMake(0, _initFrame.size.width-95, 50, 95);
        [_btn_showHide setFrame:CGRectMake(0, 0, 50, 95)];
        
        for (Item *item in self.items) {
            [item.button setFrame:[self getItemFrame:item]];
            [item.button setHidden:YES];
        }
    }];
    
    [_btn_showHide setImage:[UIImage imageNamed:@"arrow_right.png"] forState:UIControlStateNormal];
    
    _isShown = NO;
}

- (void) ordenaItems {
    [UIView animateWithDuration:0.25 animations:^{
        for (Item *item in self.items) {
            [item.button setFrame:[self getItemFrame:item]];
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
