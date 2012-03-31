//
//  IcecastServer.h
//  \brief IcecastServer, an object that encapsulates info about an IcecastServer
//
//  \author Brian Manning 
//  \date Created on 3/1/12.
//  \copyright Copyright (c) 2012 Brian Manning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IcecastServer : NSObject

// attributes
@property (nonatomic, strong) NSDate *serverStart;
@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic) int currentConnections;
@property (nonatomic) int currentSources;
@property (nonatomic) unsigned int totalConnections;
@property (nonatomic) unsigned int totalClientConnections;
@property (nonatomic) unsigned int totalSourceConnections;
// current list of streams parsed from the status message
@property (nonatomic, strong) NSMutableArray *currentStreams;

// methods
-(NSString *) description;

// parse the contents of the icecast status message, and return
// an Icecast Server object
+(IcecastServer *) parseIcecastStatus;

@end
