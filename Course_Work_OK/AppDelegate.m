//
//  AppDelegate.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 08.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "AppDelegate.h"
#import <OKSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    OKSDKInitSettings *settings = [OKSDKInitSettings new];
    settings.appKey = @"CBAMEPGLEBABABABA";
    settings.appId = @"1248742144";
    settings.controllerHandler = ^{
        return self.window.rootViewController;
    };
    [OKSDK initWithSettings: settings];
    return YES;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [OKSDK openUrl:url];
    return YES;
}

@end
