//
//  Video.m
//  D72ThreadedXmlParser
//
//  Created by Brian Manning on 3/1/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import "Video.h"

@implementation Video

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
