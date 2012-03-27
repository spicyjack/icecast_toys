//
//  Video.h
//  D72ThreadedXmlParser
//
//  Created by Brian Manning on 3/1/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

// attributes
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;

// methods
-(NSString *) description;

@end
