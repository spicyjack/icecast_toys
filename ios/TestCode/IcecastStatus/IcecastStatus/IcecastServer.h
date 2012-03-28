//
//  Video.h
//  D72ThreadedXmlParser
//
//  Created by Brian Manning on 3/1/12.
//  Copyright (c) 2012 Brian Manning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IcecastServer : NSObject

// attributes
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

// methods
-(NSString *) description;

@end
