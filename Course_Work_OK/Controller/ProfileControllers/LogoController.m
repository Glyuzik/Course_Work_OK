//
//  LogoController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 09.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "LogoController.h"
#import <UIImageView+AFNetworking.h>
#import <OKSDK.h>
#import "User.h"
#import <SVProgressHUD.h>



@interface LogoController ()<UITextFieldDelegate>{
   
}

@property (weak, nonatomic) NSString *photoID;
@property (weak, nonatomic) IBOutlet UIView *descView, *bgView;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *like;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UIButton *done;

@end

@implementation LogoController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self userLogo];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *n = @(UIInterfaceOrientationLandscapeLeft);
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


- (void)userLogo{
    typeof(self) weakSelf = self;
    [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{@"fields": @"pic1024x768, photo_id"}
                success:^(NSDictionary* data) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        User *user = [[User alloc] initUserWithDictionary:data];
                        weakSelf.imageURLString = user.imageUrlString;
                        [weakSelf.logo setImageWithURL:[NSURL URLWithString:weakSelf.imageURLString]];
                                            });
                    
                    NSString *photoID = [data objectForKey:@"photo_id"];
                    
                    [OKSDK invokeMethod:@"photos.getPhotoInfo" arguments:@{@"photo_id":photoID}
                                success:^(NSDictionary* data) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        User *user = [[User alloc] initUserWithDictionary:data];
                                        weakSelf.photoDescription.text = user.photoDescription;
                                        weakSelf.likeCount.text = [NSString stringWithFormat:@"%@", user.photoLikeCount];
                                        weakSelf.descriptionTextField.text = user.photoDescription;
                                    });
                                    
                                }
                     
                                  error:^(NSError *error) {
                                      
                                      [self error];
                                      
                                  }];
                }
                  error:^(NSError *error) {
                      [self error];
                  }];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Action

- (IBAction)hideNavigationBar:(UITapGestureRecognizer *)sender{
    if (self.navigationController.navigationBar.hidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.likeCount.alpha = 0;
            self.photoDescription.alpha = 0;
            self.like.alpha = 0;
        }];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.3 animations:^{
            self.likeCount.alpha = 1;
            self.photoDescription.alpha = 1;
            self.like.alpha = 1;
        }];
    }
}

- (IBAction)editPhotoDescription:(UIBarButtonItem *)sender{
     [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.9;
        self.descView.alpha = 1;
        self.likeCount.alpha = 0;
        self.photoDescription.alpha = 0;
        self.like.alpha = 0;
    }];
}
- (IBAction)doneButtonPressed:(UIButton *)sender{
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0;
        self.descView.alpha = 0;
        self.likeCount.alpha = 1;
        self.photoDescription.alpha = 1;
        self.like.alpha = 1;
    }];

    typeof(self) weakSelf = self;
    [OKSDK invokeMethod:@"users.getCurrentUser" arguments:@{@"fields":@"photo_id"}
                success:^(NSDictionary* data) {
                    
                    NSString *photoID = [data objectForKey:@"photo_id"];
                    [OKSDK invokeMethod:@"photos.editPhoto" arguments:@{@"photo_id":photoID, @"description":self.descriptionTextField.text}
                                success:^(NSDictionary* data) {
                                    [OKSDK invokeMethod:@"photos.getPhotoInfo" arguments:@{@"photo_id":photoID}
                                                success:^(NSDictionary* data) {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        User *user = [[User alloc] initUserWithDictionary:data];
                                                        weakSelf.photoDescription.text = user.photoDescription;
                                                    });
                                                }
                                                  error:^(NSError *error) {
                                                      [weakSelf error];
                                                  }];
                                }
                                  error:^(NSError *error) {
                                      [weakSelf error];
                                  }];
                }
                  error:^(NSError *error) {
                      [weakSelf error];
                  }];
}


@end
