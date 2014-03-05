//
//  AppDelegate.m
//  Aventura
//
//  Created by IVAN MOLERA on 11/02/14.
//  Copyright (c) 2014 owlab. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

#define AG_PATH @"PATH_SUPER_AVENTURA_GRAFICA"

+ (AppDelegate*) mainAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



+ (BOOL) createAGDirectory
{
    NSFileManager *filemgr;
    filemgr =[NSFileManager defaultManager];
    
    NSString* grahFilterDir = [self getAGPath];
    if ([filemgr createDirectoryAtPath:grahFilterDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
    {
        // Failed to create directory
        NSLog(@"Failed to create AventuraGrafica directory:%@",grahFilterDir);
        return NO;
    }
    return YES;
}



+ (NSString*) getAGPath
{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * graphFilterDir = [docsDir stringByAppendingPathComponent:AG_PATH];
    return graphFilterDir;
}



+ (BOOL) deleteAGFile:(NSString*)_name
{
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString* l_sFileName = [NSString stringWithFormat:@"%@.xml",_name];
    NSString *filePath = [[self getAGPath] stringByAppendingPathComponent:l_sFileName];
    
    if (![filemgr removeItemAtPath:filePath error:NULL])
    {
        // Failed to create directory
        NSLog(@"Failed to delete SceneXML:%@", l_sFileName);
        return NO;
    }
    return YES;
}



+ (NSArray*) getAllAGInDirectory
{
    NSError * error;
    NSArray * directoryContents = [NSArray array];
    
    directoryContents =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self getAGPath] error:&error];
    return directoryContents;
}


@end
