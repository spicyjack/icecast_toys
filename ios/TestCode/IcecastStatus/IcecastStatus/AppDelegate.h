//
//  AppDelegate.h
//  IcecastStatus
//
//  Created by Brian Manning on 2/28/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, 
    NSURLConnectionDataDelegate,
    NSXMLParserDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
