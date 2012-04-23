//
//  AppDelegate.h
//  IcecastStatus-Apr2012
//
//  Created by Brian Manning on 4/18/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
