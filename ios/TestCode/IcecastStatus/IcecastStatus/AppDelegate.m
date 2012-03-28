//
//  AppDelegate.m
//  IcecastStatus
//
//  Created by Brian Manning on 3/1/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "IcecastServer.h"

// enumerated type
enum ParserState { xmlParse, xmlSkip };

@implementation AppDelegate
{
    // implementation variables
    NSMutableArray *icecastStreams;
    UITextView *myTextView;
    IcecastServer *server;
    enum ParserState parserState;
}

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
    // get the application frame and add a textView to it
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    myTextView = [[UITextView alloc] initWithFrame:rect];
    myTextView.editable = NO;
    myTextView.text = @"Loading...";
    [self.window addSubview:myTextView];
    
    [self performSelectorInBackground:@selector(doXMLParsing:) 
                           withObject:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

// the XML parser, started in it's own thread
-(void)doXMLParsing:(id)sender
{
    NSString *urlString = @"http://stream.xaoc.org:7767/simple.xsl";

    // create a URL object
    NSURL *url = [NSURL URLWithString:urlString];
    // create a parser that reads from the URL object; this blocks, which 
    // is why it's in it's own thread
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    // set the delegate class to this (self) class
    [parser setDelegate:self];
    // blocking call
    [parser parse];
}

// parsing error occured; notified the GUI running in the main thread
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self performSelectorOnMainThread:@selector(displayErrorMsg:) 
                            // localize the error description
                           withObject:[parseError localizedDescription]
                        waitUntilDone:NO];
}

// notify when the parser started
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    icecastStreams = [[NSMutableArray alloc] init];
}

// we're starting to parse an <element>
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName 
   attributes:(NSDictionary *)attributeDict
{
    // we're only looking for the <pre> element
    if ( [elementName isEqualToString:@"pre"] ) {
        parserState = xmlParse;
        return;
    }
}

// we're starting to parse characters in an <element>
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // use the current state to decide what to do
    switch (parserState) {
        case xmlParse:
            // if the parse flag is set...
            NSLog(@"string in the <pre> tags is:\n%@", string);
            parserState = xmlSkip;
            //break;
            return;
        default:
            //break;
            return;
    }
}
                    
// notify when the document is finished parsing
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self performSelectorOnMainThread:@selector(updateGUI:) 
                           withObject:nil 
                        waitUntilDone:NO];
}

// update the GUI; display the videos by calling the 'description' message
-(void) displayErrorMsg:(id)object
{
    myTextView.text = [object description];
}

// update the GUI; display the videos by calling the 'description' message
-(void) updateGUI:(id)sender
{
    myTextView.text = [icecastStreams description];
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
