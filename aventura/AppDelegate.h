//
//  AppDelegate.h
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

//---Properties:
@property (strong, nonatomic) UIWindow *window;


//---Functions:
+ (AppDelegate*) mainAppDelegate;
+ (BOOL) createAGDirectory;
+ (NSString*) getAGPath;
+ (BOOL) deleteAGFile:(NSString*)_name;
+ (NSArray*) getAllAGInDirectory;
@end
