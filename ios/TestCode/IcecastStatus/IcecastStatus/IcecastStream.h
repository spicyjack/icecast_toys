//
//  IcecastStream.h
//  \brief IcecastStream, an individual stream running on an IcecastServer
//
//  \author Brian Manning 
//  \date Created on 3/27/12.
//  \copyright Copyright (c) 2012 Brian Manning. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface IcecastStream : NSObject

// attributes
@property (nonatomic, strong) NSString *mountPoint;
@property (nonatomic, strong) NSString *streamName;
@property (nonatomic, strong) NSDate *streamStart;
@property (nonatomic) int currentListeners;
@property (nonatomic, strong) NSString *streamDescription;
@property (nonatomic, strong) NSString *currentlyPlayingSong;
@property (nonatomic, strong) NSURL *streamURL;

// methods
-(NSString *) description;

@end
