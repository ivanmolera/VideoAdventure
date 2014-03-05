//
//  Action.m
//  Aventura
//
//  Created by IVAN MOLERA on 13/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "Action.h"
#import "TouchMask.h"

@implementation Action

- (id) initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.identifier  = identifier;
    }
    return self;
}

- (bool) check:(NSString*)maskId {
    bool canDoAction = false;
    
    for (int i=0; i<self.m_aTouchMasks.count; i++) {
        TouchMask *touchMask = [self.m_aTouchMasks objectAtIndex:i];

        // Miro si les màscares que han apretat disparen alguna acció de l'escena actual
        if ([maskId isEqualToString:touchMask.identifier]) {
            canDoAction = true;
        }

        break;
    }

    return canDoAction;
}

- (void) doAction {

    [self.escena removeLabelsFromEscena];

    switch (self.m_iType) {
        case ActionTypeJumpToState:
            // Espero que acabi un video per reproduir-ne un altre?
            //if(self.escena.moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
                [self.escena setCurrentEstat:[self.escena.m_aEstats objectAtIndex:self.target]];
            break;
            
        case ActionTypeJumpToScene:
            
            break;
        
        case ActionTypeShowMessage:
        {
            /*
            CGRect myImageRect = CGRectMake(520, 150, 104, 32);
            
            UIImageView *boxImage = [[UIImageView alloc] initWithFrame:myImageRect];
            [boxImage setImage:[UIImage imageNamed:@"box.png"]];
            boxImage.opaque = YES;

            [self.escena addSubview:boxImage];
            */
            
            [self.escena showMessage:self.message];
        }
            break;
            
        case ActionTypeGetItem:
            
            break;
            
        case ActionTypeUseItem:
            
            break;
            
        default:
            break;
    }
}


@end
