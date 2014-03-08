//
//  ItemMask.h
//  aventura
//
//  Created by IVAN MOLERA on 07/03/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface ItemMask : CAShapeLayer

// Identificador de la màscara
@property (nonatomic, strong) NSString          *identifier;

// Array de coordenades
@property (nonatomic, strong) NSMutableArray    *m_aCoords;


- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithCoords:(NSMutableArray*)coords andFrame:(CGRect)frame andIdentifier:(NSString *)identifier andIsHidden:(bool) isHidden;

@end
