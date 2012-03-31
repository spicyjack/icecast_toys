//
//  Video.m
//  D72ThreadedXmlParser
//
//  Created by Brian Manning on 3/1/12.
//  Copyright (c) 2012 Brian Manning. All rights reserved.
//

#import "IcecastServer.h"

@implementation IcecastServer

@synthesize serverStart;
@synthesize serverURL;
@synthesize currentConnections;
@synthesize currentSources;
@synthesize totalConnections;
@synthesize totalClientConnections;
@synthesize totalSourceConnections;

// methods
-(NSString *) description
{
    NSString *s = [NSString stringWithFormat:@"%@ %@\n",
                   [super description],
                   self.serverStart,
                   self.serverURL];
    return s;
}

@end
