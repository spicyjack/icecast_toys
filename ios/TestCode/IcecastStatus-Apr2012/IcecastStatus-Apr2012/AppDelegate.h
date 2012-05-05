//
//  AppDelegate.h
//  IcecastStatus-Apr2012
//
//  Created by Brian Manning on 4/18/12.
//  Copyright (c) 2012 Example Company Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

-(void)runXMLParser;
-(void) enableNetworkBusyIcon:(id) sender;
-(void) disableNetworkBusyIcon:(id) sender;
-(void) displayErrorMsg:(NSString *) errorMsg;
-(void) updateGUI:(NSString *) msg;

@end
