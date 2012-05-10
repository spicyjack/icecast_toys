//
//  IcecastStatusParser.h
//  IcecastStatus-Apr2012
//
//  Created by Brian Manning on 4/23/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IcecastStatusParser : NSObject <NSXMLParserDelegate>

- (void) fetchAndParseIcecastStatusPage:(id)sender withURL:(NSURL *) url;


@end
