//
//  IcecastStatusParser.m
//  IcecastStatus-Apr2012
//
//  Created by Brian Manning on 4/23/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import "IcecastStatusParser.h"

// enumerated type
enum ParserState { xmlParse, xmlSkip };

@implementation IcecastStatusParser
{
    // implementation variables
    enum ParserState parserState;
    NSString *parsedText;
    //NSXMLParser *parser;
}


- (id)initWithContentsOfURL:(NSURL *)url
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    return parser;
}

// parsing error occured; notify the GUI running in the main thread
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
    [self performSelectorOnMainThread:@selector(disableNetworkBusyIcon:) 
                           withObject:nil
                        waitUntilDone:NO];
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
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    // FIXME pass back the text in the <pre> tags
    [self performSelectorOnMainThread:@selector(updateGUI:) 
                           withObject:parsedText 
                        waitUntilDone:NO];
}

@end
