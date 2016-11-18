//
//  MenuController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 08.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "MenuController.h"
#import <OKSDK.h>


@interface MenuController ()

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)logoutButtonClicked:(UIBarButtonItem *)logout{
    // create alert for logout
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Подтверждение" message:@"Вы уверены что хотите выйти?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //logout
        [OKSDK clearAuth];
        // pop to login VC
        [self.navigationController setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"]] animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}




@end
