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

@interface FriendsController ()<UITableViewDataSource, UITableViewDelegate>{
    __block NSMutableArray *dataSource;
}

@end

@implementation FriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [OKSDK invokeMethod:@"friends.get" arguments:@{}
                success:^(NSArray* data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dataSource = [NSMutableArray array];
                        [dataSource setArray:[data subarrayWithRange:NSMakeRange(0, 99)]];
                        [self.tableView reloadData];
                    });
                }
                  error:^(NSError *error) {
                      [self error];
                  }
     ];
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSString *stringID = [NSString stringWithFormat:@"%@", [dataSource componentsJoinedByString:@","]];
    
    [OKSDK invokeMethod:@"users.getInfo" arguments:@{@"fields":@"name, pic1024x768", @"uids":stringID}
                success:^(NSArray* data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.name.text = [[data objectAtIndex:indexPath.row] objectForKey:@"name"];
                        [cell.logo setImageWithURL:[NSURL URLWithString:[[data objectAtIndex:indexPath.row] objectForKey:@"pic1024x768"]]];
                    });
                }
                  error:^(NSError *error) {
                      [self error];
                  }
     ];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 77;
}


@end
