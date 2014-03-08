//
//  ItemMask.m
//  aventura
//
//  Created by IVAN MOLERA on 07/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "ItemMask.h"

@implementation ItemMask

- (id)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.identifier  = identifier;
    }
    return self;
}

- (id)initWithCoords:(NSMutableArray*)coords andFrame:(CGRect)frame andIdentifier:(NSString *)identifier andIsHidden:(bool) isHidden
{
    self = [super init];
    if (self) {
        // Initialization code
        self.identifier = identifier;
        self.m_aCoords  = coords;
        
        UIBezierPath *path = [[UIBezierPath bezierPath] init];
        
        [path moveToPoint:[[coords objectAtIndex:0] CGPointValue]];
        
        for (NSValue *coord in coords) {
            [path addLineToPoint:[coord CGPointValue]];
        }
        
        [path closePath];
        path.lineWidth = 5;
        
        [self setFrame:self.frame];
        self.path = path.CGPath;
        self.strokeColor = [UIColor blueColor].CGColor;
        self.fillColor = [UIColor clearColor].CGColor;
        [self setOpacity:1];
        [self setHidden:isHidden];
    }
    return self;
}

@end
