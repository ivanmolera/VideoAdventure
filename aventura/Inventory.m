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
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:NO];

        _initFrame = frame;

        [self setFrame:CGRectMake(0, _initFrame.size.width-95, _initFrame.size.height, 95)];

        self.scrollEnabled = YES;
        self.clipsToBounds = NO;
        [self setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
        
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addItem:(Item*)item {
    [item.button setFrame:CGRectMake(([self.items count]*145)+([self.items count]*5)+5, 5, 140, 85)];
    [item setEscena:self.escena];
    [item withInventory:self];

    [self.items addObject:item];

    [self addSubview:item.button];
    [self bringSubviewToFront:item.button];

    [self setContentSize:CGSizeMake(([self.items count]*140)+([self.items count]*5)+5,[self bounds].size.height)];
}

- (CGRect) getItemFrame:(Item*)item {
    NSUInteger index = [self.items indexOfObject:item];
    NSUInteger x = (index == 0) ? 5 : (index*145)+(index*5)+5;
    return CGRectMake(x, 5, 140, 85);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInView:self];
        
        NSLog(@"%f,%f", touchLocation.x, touchLocation.y);
    }
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
