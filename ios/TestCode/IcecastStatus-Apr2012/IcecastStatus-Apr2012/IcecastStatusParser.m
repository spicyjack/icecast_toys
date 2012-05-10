//
//  IcecastStatusParser.m
//  IcecastStatus-Apr2012
//
//  Created by Brian Manning on 4/23/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import "IcecastStatusParser.h"
#import "ViewController.h"

// enumerated type
enum ParserState { xmlParse, xmlSkip };

@implementation IcecastStatusParser
{
    // implementation variables
    enum ParserState parserState;
    NSString *parsedText;
    NSXMLParser *xmlParser;
    id appDelegate;
}

/*
 ==============
 PUBLIC METHODS
 ==============
 methods meant to be used directly by the AppDelegate 
*/

// launch the status page downloader/HTML parser in it's own thread
- (void) fetchAndParseIcecastStatusPage:(id)sender withURL:(NSURL *) url
{
    NSLog(@"parseIcecastServerStatus, saving appDelegate object...");
    appDelegate = sender;
    [self triggerEnableNetworkBusyIcon:self];
    [self performSelectorInBackground:@selector(doXMLParsing:)
                           withObject:url];
    // FIXME create a parser class with the XML parser and the status parser in one object
    // then instantiate the XML parser in the below invocation operation
    //NSInvocationOperation * genOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(generateKeyPairOperation) object:nil];
}

// the threaded status page downloader/HTML parser
-(void) doXMLParsing:(NSURL *)url
{
    // create a parser that reads from the URL object; this can block, which 
    // is why it's in it's own thread
    NSLog(@"doXMLParsing");
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    // set the delegate class to this (self) class
    [xmlParser setDelegate:self];
    // blocking call
    [xmlParser parse];
}

/*

 Icecast status page is formatted as follows:
 - First line format: Field name: field value
 - Subseqent lines are formatted as: value|value|value|etc.; (semicolon ends that mount)
 
*/

- (NSMutableArray *) doIcecastStatusParse:(NSString *)icecastStatus
{
    NSMutableArray *mountPoints = [[NSMutableArray alloc] init];
    
    return mountPoints;
}

/*
 ===============
 TRIGGER METHODS
 ===============
 - Methods used to trigger an action in the AppDelegate object
*/

-(void)triggerDisableNetworkBusyIcon:(id)object
{
    NSLog(@"triggerDisableNetworkBusyIcon");
    [appDelegate disableNetworkBusyIcon:self];
}

-(void)triggerEnableNetworkBusyIcon:(id)object
{
    NSLog(@"triggerEnableNetworkBusyIcon");
    [appDelegate enableNetworkBusyIcon:self];
}

-(void)triggerDisplayErrorMsg:(NSString *) errorMsg
{
    NSLog(@"triggerDisplayErrorMsg: %@", errorMsg);
    [appDelegate displayErrorMsg:errorMsg];
}

-(void)triggerUpdateGUI:(NSString *) msg
{
    //NSLog(@"triggerUpdateGUI: %@", msg);
    [appDelegate updateGUI:msg];
}

/*
 ================
 INTERNAL METHODS
 ================
 methods only meant to be called by different copies of this object
 running in different threads
*/
 
// parsing error occured; notify the GUI running in the main thread
-(void)parser:(NSXMLParser *)aParser parseErrorOccurred:(NSError *)parseError
{
    [self performSelectorOnMainThread:@selector(triggerDisplayErrorMsg:) 
     // localize the error description
                           withObject:[parseError localizedDescription]
                        waitUntilDone:NO];
}

// notify when the parser started
-(void)parserDidStartDocument:(NSXMLParser *)aParser
{
    [self performSelectorOnMainThread:@selector(triggerDisableNetworkBusyIcon:) 
                           withObject:nil
                        waitUntilDone:NO];
}

// we're starting to parse an <element>
-(void)parser:(NSXMLParser *)aParser didStartElement:(NSString *)elementName 
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
-(void)parser:(NSXMLParser *)aParser foundCharacters:(NSString *)string
{
    // use the current state to decide what to do
    switch (parserState) {
        case xmlParse:
            // if the parse flag is set...
            NSLog(@"Found text in between the <pre> tags...\n");
            parsedText = string;
            // send a message to the main thread at the end of parsing
            // with the contents of the <pre> tags
            parserState = xmlSkip;
            //break;
            return;
        default:
            //break;
            return;
    }
}

// notify when the document is finished parsing
-(void)parserDidEndDocument:(NSXMLParser *)aParser
{
    // FIXME pass back the text in the <pre> tags
    [self performSelectorOnMainThread:@selector(triggerUpdateGUI:) 
                           withObject:parsedText 
                        waitUntilDone:NO];
}

@end
