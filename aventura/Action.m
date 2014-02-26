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
    
    switch (self.m_iType) {
        case ActionTypeJumpToState:
            if(self.escena.moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
            {
                [self.escena setCurrentEstat:[self.escena.m_aEstats objectAtIndex:self.target]];
            }
            break;
            
        case ActionTypeJumpToScene:
            
            break;
        
        case ActionTypeShowMessage:
        {
            CGRect myImageRect = CGRectMake(520, 150, 104, 32);
            
            UIImageView *boxImage = [[UIImageView alloc] initWithFrame:myImageRect];
            [boxImage setImage:[UIImage imageNamed:@"box.png"]];
            boxImage.opaque = YES;

            [self.escena addSubview:boxImage];

            UILabel *messageLabel = [[UILabel alloc] initWithFrame:myImageRect];

            [messageLabel setTextColor:[UIColor blackColor]];
            [messageLabel setBackgroundColor:[UIColor clearColor]];
            [messageLabel setFont:[UIFont fontWithName: @"Laffayette Comic Pro" size: 13.0f]];
            [messageLabel setText:NSLocalizedString(self.message, nil)];
            [messageLabel setTextAlignment:NSTextAlignmentCenter];

            [self.escena addSubview:messageLabel];
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
