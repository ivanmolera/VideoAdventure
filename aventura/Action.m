//
//  Action.m
//  Aventura
//
//  Created by IVAN MOLERA on 13/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "Action.h"
#import "TouchMask.h"
#import "Item.h"

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
        {
            // Espero que acabi un video per reproduir-ne un altre?
            //if(self.escena.moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
                [self.escena setCurrentEstat:[self.escena.m_aEstats objectAtIndex:self.target]];
        }
            break;
            
        case ActionTypeJumpToScene:
        {
            NSNumber *num = [NSNumber numberWithInt:self.target];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeEscena" object:num];
        }
            
            break;
        
        case ActionTypeShowMessage:
            [self.escena showMessage:self.message];
            break;
            
        case ActionTypeGetItem:
        {
            [self.escena showMessage:self.message];
            
            Item *newItem = [[Item alloc] initWithIdentifier:[NSString stringWithFormat:@"%d", self.target]];
            [newItem setEscena:self.escena];
            
            // En una action getItem només tindré una màscara
            TouchMask *touchMask = [self.m_aTouchMasks objectAtIndex:0];
            
            [newItem.button setFrame:CGRectMake(0, 0, 140, 85)];
            
            CGPathRef maskPath = touchMask.path;
            
            float dataArray[3] = { 0, 0, 0 };
            CGPathApply( (CGPathRef) maskPath, dataArray, pathApplierSumCoordinatesOfAllPoints);
            
            float averageX = dataArray[0] / dataArray[2];
            float averageY = dataArray[1]  / dataArray[2];
            CGPoint centerOfPath = CGPointMake(averageX, averageY);
            
            newItem.button.center = centerOfPath;
            
            [self.escena showItem:newItem.button];
        }
            break;
            
        case ActionTypeUseItem:
        {
            // TODO:
        }
            break;
            
        default:
            break;
    }
}

static void pathApplierSumCoordinatesOfAllPoints(void* info, const CGPathElement* element)
{
    float* dataArray = (float*) info;
    float xTotal = dataArray[0];
    float yTotal = dataArray[1];
    float numPoints = dataArray[2];
    
    
    switch (element->type)
    {
        case kCGPathElementMoveToPoint:
        {
            /** for a move to, add the single target point only */
            
            CGPoint p = element->points[0];
            xTotal += p.x;
            yTotal += p.y;
            numPoints += 1.0;
            
        }
            break;
        case kCGPathElementAddLineToPoint:
        {
            /** for a line to, add the single target point only */
            
            CGPoint p = element->points[0];
            xTotal += p.x;
            yTotal += p.y;
            numPoints += 1.0;
            
        }
            break;
        case kCGPathElementAddQuadCurveToPoint:
            for( int i=0; i<2; i++ ) // note: quad has TWO not FOUR
            {
                /** for a curve, we add all ppints, including the control poitns */
                CGPoint p = element->points[i];
                xTotal += p.x;
                yTotal += p.y;
                numPoints += 1.0;
            }
            break;
        case kCGPathElementAddCurveToPoint:
            for( int i=0; i<4; i++ ) // note: cubic has FOUR not TWO
            {
                /** for a curve, we add all ppints, including the control poitns */
                CGPoint p = element->points[i];
                xTotal += p.x;
                yTotal += p.y;
                numPoints += 1.0;
            }
            break;
        case kCGPathElementCloseSubpath:
            /** for a close path, do nothing */
            break;
    }
    
    //NSLog(@"new x=%2.2f, new y=%2.2f, new num=%2.2f", xTotal, yTotal, numPoints);
    dataArray[0] = xTotal;
    dataArray[1] = yTotal;
    dataArray[2] = numPoints;
}


@end
