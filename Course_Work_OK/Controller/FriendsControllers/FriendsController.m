//
//  FriendsController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 18.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "FriendsController.h"
#import "FriendCell.h"
#import <UIImageView+AFNetworking.h>
#import <OKSDK.h>
#import <SVProgressHUD.h>
#import "ProfileController.h"

@interface FriendsController ()<UITableViewDataSource, UITableViewDelegate>{
    __block NSArray *dataSource;
    __block NSMutableArray *friendsID;
    __block NSMutableArray *friendsID2;
    
     NSString *userID;
    
    FriendCell *cell;
    
}

@end

@implementation FriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self friendsList];
    
    }

- (void)friendsList{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [OKSDK invokeMethod:@"friends.get" arguments:@{}
                success:^(NSArray* data) {
                    friendsID = [NSMutableArray array];
                    if (data.count < 100) {
                        [friendsID setArray:data];
                    }else{
                        [friendsID setArray:[data subarrayWithRange:NSMakeRange(0, 99)]];
                    }
                    
                    NSString *stringID = [NSString stringWithFormat:@"%@", [friendsID componentsJoinedByString:@","]];
                    
                    [OKSDK invokeMethod:@"users.getInfo" arguments:@{@"fields":@"name, pic1024x768", @"uids":stringID}
                                success:^(NSArray* data) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        friendsID2 = [NSMutableArray array];
                                        for (NSDictionary *dict in data) {
                                            NSString *string = [dict objectForKey:@"uid"];
                                            [friendsID2 addObject:string];
                                        }
                                        dataSource = data;
                                        [self.tableView reloadData];
                                    });
                                }
                                  error:^(NSError *error) {
                                      [self error];
                                  }];
                }
                  error:^(NSError *error) {
                      [self error];
                  }
     ];
    [SVProgressHUD dismiss];

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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"kSegueProfile"]) {
        ProfileController *profile = [segue destinationViewController];
        profile.userID = userID;
        profile.invite.alpha = 0;
        profile.suggest.alpha = 0;
        profile.post.alpha = 0;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.logo.layer.cornerRadius = cell.logo.frame.size.height / 2;
    cell.logo.layer.masksToBounds = YES;
    
    
    cell.name.text = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell.logo setImageWithURL:[NSURL URLWithString:[[dataSource objectAtIndex:indexPath.row] objectForKey:@"pic1024x768"]] placeholderImage:[UIImage imageNamed:@"hidden"]];


    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    userID = [friendsID2 objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"kSegueProfile" sender:nil];
}



@end
