//
//  AppDelegate.m
//  IcecastStatus-Apr2012
//
//  Created by Brian Manning on 4/18/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

// local classes
#import "IcecastServer.h"
#import "IcecastStatusParser.h"


@implementation AppDelegate
{
    // implementation variables
    UITextView *myTextView;
    IcecastServer *server;
    NSMutableArray *icecastStreams;
    IcecastStatusParser *parser;
}

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self runXMLParser];
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

// DISPATCH METHODS
// these will be used by the parser thread

// update the GUI; display the videos by calling the 'description' message
-(void) displayErrorMsg:(id) sender
{
    NSLog(@"displayErrorMsg: error from parser: %@", [sender description]);
    myTextView.text = [sender description];
}

// update the GUI; display the videos by calling the 'description' message
-(void) updateGUI:(id) sender
{
//    myTextView.text = [icecastStreams description];
    NSLog(@"updateGUI; string from parser: %@", [sender description]);
//    myTextView.text = @"Icecast streams";
}

// update the GUI; display the videos by calling the 'description' message
-(void) enableNetworkBusyIcon:(id) sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

// update the GUI; display the videos by calling the 'description' message
-(void) disableNetworkBusyIcon:(id) sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

// the XML parser, started in it's own thread
-(void)runXMLParser
{

    // FIXME figure out a way to refactor the selector into a different class
    /* FIXME move this into the status parser class, add a callback that the
     status parser can use to let this class know what the status of parsing is
     [parser parse withCaller:self];
     */
    NSLog(@"Creating IcecastStatusParser...");
    parser = [[IcecastStatusParser alloc] init];
    NSLog(@"Calling parser");
    [parser doParsing:self];
}

@end
