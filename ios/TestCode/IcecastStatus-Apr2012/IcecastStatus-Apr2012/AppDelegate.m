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
    // declare the parser pointer; the parser will be created in a separate thread
//    IcecastStatusParser *parser;
}

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // FIXME figure out a way to refactor the selector into a different class
    [self performSelectorInBackground:@selector(doXMLParsing:)
                           withObject:nil];
    // FIXME create a parser class with the XML parser and the status parser in one object
    // then instantiate the XML parser in the below invocation operation
    //NSInvocationOperation * genOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(generateKeyPairOperation) object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
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
    myTextView.text = [sender description];
}

// update the GUI; display the videos by calling the 'description' message
-(void) updateGUI:(id) sender
{
//    myTextView.text = [icecastStreams description];
    NSLog(@"Got string from parser: %@", sender);
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
//-(void)doXMLParsing:(id)sender
//{
//    NSLog(@"entering doXMLParsing...");
//    [self performSelectorOnMainThread:@selector(enableNetworkBusyIcon:) 
//                           withObject:nil
//                        waitUntilDone:NO];
//    
//    NSString *urlString = @"http://stream.xaoc.org:7767/simple.xsl";
//    
//    // create a URL object
//    NSURL *url = [NSURL URLWithString:urlString];
//    // create a parser that reads from the URL object; this blocks, which 
//    // is why it's in it's own thread
//    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
//    // set the delegate class to this (self) class
//    [parser setDelegate:self];
//    // blocking call
//    [parser parse];
//}

@end
