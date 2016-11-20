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
    __block NSDictionary *dataSourcePhoto;
    __block NSMutableArray *dataSourceName;

    GroupCell *cell;
}

@end

@implementation GroupsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [OKSDK invokeMethod:@"group.getUserGroupsV2" arguments:@{}
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
                    [OKSDK invokeMethod:@"group.getInfo" arguments:@{@"uids":groupID,@"fields":@"name, photo_id"}
                                success:^(NSArray* data) {
                                    NSMutableArray *array = [NSMutableArray array];
                                    for (__strong NSDictionary *photoId in data) {
                                        NSString *photo_id = [photoId objectForKey:@"photo_id"];
                                        [array addObject:photo_id];
                                    }
                                    NSString *photoID = [NSString stringWithFormat:@"%@", [array componentsJoinedByString:@","]];
                                    ///
                                    [OKSDK invokeMethod:@"photos.getInfo" arguments:@{@"photo_ids":photoID}
                                                success:^(NSArray* data) {

                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        dataSourcePhoto = [NSDictionary new];
                                                        dataSourcePhoto = data;
                                                    });
                                                }
                                                  error:^(NSError *error) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          cell.groupLogo.image = [UIImage imageNamed:@"hidden"];
                                                      });
                                                  }];
                                    ///
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
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
    
   // [cell.groupLogo setImageWithURL:[NSURL URLWithString:[data valueForKeyPath:@"photo.pic50x50"]]];
    //cell.groupName.text = [[data objectAtIndex:0] objectForKey:@"name"];
    
        return cell;
}

@end
