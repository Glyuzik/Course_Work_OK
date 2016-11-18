//
//  PhotoController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 17.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "PhotoController.h"
#import "PhotoCell.h"
#import "PhotoDetailController.h"
#import <UIImageView+AFNetworking.h>
#import <OKSDK.h>

@interface PhotoController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    __block NSMutableArray *dataSource;
}

@property (strong, nonatomic) NSString *photoID;

@end

@implementation PhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [OKSDK invokeMethod:@"photos.getPhotos" arguments:@{}
                success:^(NSDictionary* data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dataSource = [NSMutableArray array];
                        [dataSource setArray:[data objectForKey:@"photos"]];
                        [self.collectionView reloadData];
                    });
                }
                  error:^(NSError *error) {
                  
                  }
     ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *n = @(UIInterfaceOrientationPortrait);
    [[UIDevice currentDevice] setValue:n forKey:@"orientation"];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    [cell.photo setImageWithURL:[NSURL URLWithString:[[dataSource objectAtIndex:indexPath.item] objectForKey:@"pic640x480"]]];
    
    return cell;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.photoID = [[dataSource objectAtIndex:indexPath.item] objectForKey:@"id"];
    [self performSegueWithIdentifier:@"kSegueDetail" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"kSegueDetail"]) {
        PhotoDetailController *detail = [segue destinationViewController];
        detail.photoID = self.photoID;
    }
    
}



@end
