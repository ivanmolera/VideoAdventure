//
//  Estat.h
//  aventura
//
//  Created by IVAN MOLERA on 23/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Estat : NSObject

// Identificador de l'estat
@property (nonatomic, strong) NSString                  *identifier;

// Vídeo URL
@property (nonatomic, strong) NSString                  *m_sVideoURL;

// Array d'accions
@property (nonatomic, strong) NSMutableArray            *m_aActions;

@property (nonatomic, assign) BOOL                      repeatMode;


- (id) initWithIdentifier:(NSString *)identifier;

@end
