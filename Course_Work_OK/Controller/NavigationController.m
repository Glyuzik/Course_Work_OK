//
//  NavigationController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 08.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "NavigationController.h"
#import <OKSDK.h>

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setRootViewController];
    self.navigationController.navigationBar.translucent = YES;

    
}
- (void)setRootViewController{
    if ([OKSDK currentAccessToken] != nil) {
       // NSLog(@"access - %@", [OKSDK currentAccessToken]);
        [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"]] animated:NO];
    }else{
        [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"]] animated:NO];
    }

}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if ([[self.topViewController restorationIdentifier] isEqualToString:@"logoVC"] || [[self.topViewController restorationIdentifier] isEqualToString:@"detailVC"]) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
