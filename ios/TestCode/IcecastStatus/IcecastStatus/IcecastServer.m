//
//  Video.m
//  D72ThreadedXmlParser
//
//  Created by Brian Manning on 3/1/12.
//  Copyright (c) 2012 Brian Manning. All rights reserved.
//

#import "IcecastServer.h"

@implementation IcecastServer

@synthesize title;
@synthesize desc;

// methods
-(NSString *) description
{
    NSString *s = [NSString stringWithFormat:@"%@ %@\n",
                   [super description],
                   self.title,
                   self.desc];
    return s;
}

@end
