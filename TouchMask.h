//
//  Touch.h
//  Aventura
//
//  Created by IVAN MOLERA on 13/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouchMask : CAShapeLayer

// Identificador de la màscara
@property (nonatomic, strong) NSString          *identifier;

// Array de coordenades
@property (nonatomic, strong) NSMutableArray    *m_aCoords;


- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithCoords:(NSMutableArray*)coords andFrame:(CGRect)frame andIdentifier:(NSString *)identifier;

@end
