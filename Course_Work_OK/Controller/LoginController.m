//
//  LoginController.m
//  
//
//  Created by Роман Глюзо on 08.11.16.
//
//

#import "LoginController.h"
#import <OKSDK.h>
#import "MenuController.h"

@interface LoginController ()

@end

@implementation LoginController

#pragma mark - Action

- (IBAction)loginButtonClicked:(UIButton *)login{
    //authorization
    typeof(self) weakSelf = self;
    [OKSDK authorizeWithPermissions:@[@"VALUABLE_ACCESS", @"LONG_ACCESS_TOKEN", @"PHOTO_CONTENT", @"GROUP_CONTENT", @"VIDEO_CONTENT", @"APP_INVITE", @"GET_EMAIL"]
                            success:^(id data) {
                                
                                MenuController *menuVC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
                                    [weakSelf.navigationController pushViewController:menuVC animated:YES];
                            }
                              error:^(NSError *error) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Упс..." message:@"Произошла ошибка. Попробуйте еще раз!" preferredStyle:UIAlertControllerStyleAlert];
                                  [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                                  [weakSelf presentViewController:alert animated:YES completion:nil];
                                  });
                                  
                              }];
}

@end
