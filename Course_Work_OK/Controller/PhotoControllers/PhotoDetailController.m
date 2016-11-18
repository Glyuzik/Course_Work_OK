//
//  PhotoDetailController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 18.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "PhotoDetailController.h"
#import <OKSDK.h>
#import <UIImageView+AFNetworking.h>

@interface PhotoDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation PhotoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OKSDK invokeMethod:@"photos.getInfo" arguments:@{@"photo_ids":self.photoID}
                success:^(NSDictionary* data) {
                    NSLog(@"%@",data);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.photo setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"photos"] objectAtIndex:0] objectForKey:@"pic640x480"]]];
                    });
                }
                  error:^(NSError *error) {
                      typeof(self) weakSelf = self;
                      dispatch_async(dispatch_get_main_queue(), ^{
                          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Упс..." message:@"Произошла ошибка. Попробуйте еще раз!" preferredStyle:UIAlertControllerStyleAlert];
                          [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                              [weakSelf.navigationController popViewControllerAnimated:YES];
                          }]];
                          [weakSelf presentViewController:alert animated:YES completion:nil];
                      });

                  }
     ];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *n = @(UIInterfaceOrientationLandscapeLeft);
    [[UIDevice currentDevice] setValue:n forKey:@"orientation"];
}

- (IBAction)hideAndShowNavigationBar:(UITapGestureRecognizer *)sender{
    if (self.navigationController.navigationBar.hidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

}

@end
