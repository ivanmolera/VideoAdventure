//
//  Estat.m
//  aventura
//
//  Created by IVAN MOLERA on 23/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "Estat.h"

@implementation Estat

- (id) initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.identifier  = identifier;
    }
    return self;
}

@end
