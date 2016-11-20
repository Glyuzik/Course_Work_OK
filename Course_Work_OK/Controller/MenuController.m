//
//  MenuController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 08.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "MenuController.h"
#import <OKSDK.h>
#import "ProfileController.h"


@interface MenuController (){
    __block NSString *userID;
}

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self currentUser];
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
- (void)currentUser{
    [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{}
                success:^(NSDictionary* data) {
                    userID = [data objectForKey:@"uid"];
                }
                  error:^(NSError *error) {}
     ];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"kSegueProfile"]) {
        ProfileController *profile = [segue destinationViewController];
        profile.userID = userID;
        
    }
}

- (IBAction)myProfileButtonClicked:(UIButton *)sender{
    [self performSegueWithIdentifier:@"kSegueProfile" sender:nil];
}



@end
