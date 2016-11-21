//
//  GroupsViewController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 17.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "GroupsViewController.h"
#import "GroupCell.h"
#import <OKSDK.h>
#import <UIImageView+AFNetworking.h>

@interface GroupsViewController ()<UITableViewDelegate, UITableViewDataSource>{
    __block NSMutableArray *arrayID;
    __block NSMutableArray *dataSource;

    GroupCell *cell;
}

@end

@implementation GroupsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self groupList];
    
}

- (void)groupList{
    [OKSDK invokeMethod:@"group.getUserGroupsV2" arguments:@{@"count":@"100"}
                success:^(NSDictionary* data) {
                    arrayID = [NSMutableArray array];
                    [arrayID setArray:[data objectForKey:@"groups"]];
                    
                    NSMutableArray *array = [NSMutableArray array];
                    for (__strong NSDictionary *group in arrayID) {
                        NSString *groupid = [group objectForKey:@"groupId"];
                        [array addObject:groupid];
                    }
                    NSString *groupID = [NSString stringWithFormat:@"%@", [array componentsJoinedByString:@","]];
                    ///////////
                    [OKSDK invokeMethod:@"group.getInfo" arguments:@{@"uids":groupID,@"fields":@"name, photo_id, group. PIC_AVATAR"}
                                success:^(NSArray* data) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        dataSource = [NSMutableArray array];
                                        [dataSource setArray:data];
                                        [self.tableView reloadData];
                                    });
                                }
                                  error:^(NSError *error) {
                                      
                                      [self error];
                                  }];
                    ///////////
                    
                }
                  error:^(NSError *error) {
                      [self error];
                  }];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
            return arrayID.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.groupLogo setImageWithURL:[NSURL URLWithString:[[dataSource objectAtIndex:indexPath.row] objectForKey:@"picAvatar"]]];
    cell.groupName.text = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"name"];
    
        return cell;
}

@end
