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
    __block NSMutableArray *dataSource;

}

@end

@implementation GroupsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    dataSource = [NSMutableArray array];

    [OKSDK invokeMethod:@"group.getUserGroupsV2" arguments:@{}
                success:^(NSDictionary* data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [dataSource setArray:[data objectForKey:@"groups"]];
                        [self.tableView reloadData];
                        
                        // NSLog(@"brak");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
            return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [OKSDK invokeMethod:@"group.getUserGroupsV2" arguments:@{}
                success:^(NSDictionary* data) {
                    NSString *groupID = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"groupId"];
                    ///////////
                    [OKSDK invokeMethod:@"group.getInfo" arguments:@{@"uids":groupID,@"fields":@"name, photo_id"}
                                success:^(NSArray* data) {
                                    NSString *photoID = [[data objectAtIndex:0] objectForKey:@"photo_id"];
                                    ///
                                    [OKSDK invokeMethod:@"photos.getPhotoInfo" arguments:@{@"photo_id":photoID}
                                                success:^(NSDictionary* data) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [cell.groupLogo setImageWithURL:[NSURL URLWithString:[data valueForKeyPath:@"photo.pic50x50"]]];
                                                    });
                                                }
                                                  error:^(NSError *error) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                      cell.groupLogo.image = [UIImage imageNamed:@"hidden"];
                                                      [self.tableView reloadData];
                                                          });
                                                  }];
                                    ///
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        cell.groupName.text = [[data objectAtIndex:0] objectForKey:@"name"];
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
    return cell;
}

@end
