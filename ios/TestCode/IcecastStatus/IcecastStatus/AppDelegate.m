//
//  AppDelegate.m
//  IcecastStatus
//
//  Created by Brian Manning on 2/28/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
// implementation variables
{
    NSMutableString *ms;
    UITextView *textView;
    NSMutableData *rawXmlData;
}

-(void) connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)data
{
    [rawXmlData appendData:data];
}
-(void) connection:(NSURLConnection *)connection 
  didFailWithError:(NSError *)error
{
    [ms appendFormat:@"%@\n", [error localizedDescription]];
    textView.text = ms;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *xml = [[NSString alloc] 
                     initWithData:rawXmlData encoding:NSUTF8StringEncoding];
    [ms appendFormat:@"%@\n", xml];
    textView.text = ms;
    NSXMLParser *parser = 
    [[NSXMLParser alloc] initWithData:rawXmlData];
    [parser setDelegate:self];
    //WARNING! The parsing is synchronous!
    [parser parse];
}
-(void) parserDidStartDocument:(NSXMLParser *)parser
{
    [ms appendString:@"Start XML Parsing!\n"];
}
-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [ms appendFormat:@"%@\n", elementName];
}
-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    [ms appendString:@"End XML Parsing!\n"];
    textView.text = ms;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
