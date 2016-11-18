//
//  ProfileController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 09.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "ProfileController.h"
#import <OKSDK.h>
#import <UIImageView+AFNetworking.h>
#import "LogoController.h"
#import "User.h"

@interface ProfileController ()

@property (weak, nonatomic) IBOutlet UIImageView *userLogo;
@property (weak, nonatomic) IBOutlet UILabel *userName, *birthday, *gender, *status, *location;
@property (weak, nonatomic) NSString *imageUrlString;
@property (weak, nonatomic) IBOutlet UIButton *suggest, *invite, *post;

@end

@implementation ProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLogo.userInteractionEnabled = YES;
    self.status.userInteractionEnabled = YES;
    
    [self elitVC];
    [self currentUser];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *n = @(UIInterfaceOrientationPortrait);
    [[UIDevice currentDevice] setValue:n forKey:@"orientation"];
}

- (void)error{
    typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Упс..." message:@"Произошла ошибка. Попробуйте еще раз!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    });

}

-(void)elitVC{
    self.userName.text = nil;
    self.birthday.text = nil;
    self.gender.text = nil;
    self.status.text = nil;
    self.location.text = nil;
    self.post.hidden = YES;
    self.suggest.hidden = YES;
    self.invite.hidden = YES;

}

- (void)currentUser{
    typeof(self) weakSelf = self;
    [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{@"fields": @"pic1024x768, name, birthday, age, gender, current_status, location"}
                success:^(NSDictionary* data) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    User *user = [[User alloc] initUserWithDictionary:data];
                        
                    weakSelf.imageUrlString = user.imageUrlString;
                    [weakSelf.userLogo setImageWithURL:[NSURL URLWithString:self.imageUrlString]];
                        
                    weakSelf.userName.text = user.userName;
                    weakSelf.gender.text = user.gender;
                    weakSelf.birthday.text = user.birthday;
                    weakSelf.status.text = user.status;
                    weakSelf.location.text = user.location;
                        
                        weakSelf.post.hidden = NO;
                        weakSelf.suggest.hidden = NO;
                        weakSelf.invite.hidden = NO;
                    });
                    
                }
                  error:^(NSError *error) {
                      [self error];
                  }];
}


#pragma mark - Action

- (IBAction)pushLogoController:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"kSegueLogo" sender:nil];
}
- (IBAction)showStatus:(UITapGestureRecognizer *)sender{
    typeof(self) weakSelf = self;
    [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{@"fields": @"current_status"}
                success:^(NSDictionary* data) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        User *user = [[User alloc] initUserWithDictionary:data];
                        weakSelf.status.text = user.status;
                         UIAlertController *alert = [UIAlertController alertControllerWithTitle:weakSelf.status.text message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    });
                    
                }
                  error:^(NSError *error) {
                      
                      [self error];
                  }];
}

- (IBAction)postWidget:(UIButton *)sender{
    [OKSDK showWidget:@"WidgetMediatopicPost" arguments:@{@"st.attachment":@"{\"media\":[{\"text\":\"\u0417\u0430 IOS \u0438 \u0434\u0432\u043e\u0440 - \u0441\u0442\u0440\u0435\u043b\u044f\u044e \u0432 \u0443\u043f\u043e\u0440!\",\"type\":\"text\"},{\"text\":\" \",\"images\":[{\"title\":\"\u041E\u0431\u0440\u0435\u0442\u0438 \u0441\u043B\u0430\u0432\u0443 \u0432 \u0441\u0430\u043C\u043E\u0439 \u044D\u043F\u0438\u0447\u0435\u0441\u043A\u043E\u0439 \u0438\u0433\u0440\u0435 \u0432\u0441\u0435\u0445 \u0432\u0440\u0435\u043C\u0435\u043D!\",\"mark\":\"crush_the_castle\",\"url\":\"http://mariupol.itstep.org/wp-content/uploads/2014/09/kartinka_macbook.jpg\"}],\"type\":\"app\"}]}"} options:@{@"st.utext":@"on"}
              success:^(NSDictionary *data) {
                  //NSLog(@"%@", data);
              }
                error:^(NSError *error) {}
     ];
}

- (IBAction)inviteFriends:(UIButton *)sender{
    [OKSDK showWidget:@"WidgetInvite" arguments:@{} options:@{} success:^(NSDictionary *data) {
        NSLog(@"%@",data);
    }
                error:nil];
}

- (IBAction)suggestWidget:(UIButton *)sender{
    [OKSDK showWidget:@"WidgetSuggest" arguments:@{} options:@{}
              success:^(NSDictionary *data) {
                  NSLog(@"%@",data);
              }
                error:^(NSError *error) {}
     ];
}

@end
