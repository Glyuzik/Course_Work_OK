//
//  PhotoController.m
//  Course_Work_OK
//
//  Created by Роман Глюзо on 17.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import "PhotoController.h"
#import "PhotoCell.h"
#import "LogoController.h"
#import <UIImageView+AFNetworking.h>
#import <OKSDK.h>
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface PhotoController ()<UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>{
    __block NSMutableArray *dataSource;
    
    PhotoCell *cell;
}

@property (strong, nonatomic) NSString *photoID;
@property (nonatomic, strong) NSArray *cellSizes;



@end

@implementation PhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self.view addSubview:self.collectionView];
    
    [self photoList];
    
   }
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *n = @(UIInterfaceOrientationPortrait);
    [[UIDevice currentDevice] setValue:n forKey:@"orientation"];
}

/*- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.columnCount = 2;
        layout.minimumColumnSpacing = 20;
        layout.minimumInteritemSpacing = 30;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[PhotoCell class]
            forCellWithReuseIdentifier:@"photoCell"];
        
    }
    return _collectionView;
}
- (NSArray *)cellSizes {
    if (!_cellSizes) {
        _cellSizes = @[
                       [NSValue valueWithCGSize:CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height/3)],
                       [NSValue valueWithCGSize:CGSizeMake(self.view.frame.size.width/2, (self.view.frame.size.height/3)*2)],
                       [NSValue valueWithCGSize:CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.height/3)],
                       [NSValue valueWithCGSize:CGSizeMake(self.view.frame.size.width/2, (self.view.frame.size.height/3)*2)]
                       ];
    }
    return _cellSizes;
}*/

- (void)photoList{
    [OKSDK invokeMethod:@"photos.getPhotos" arguments:@{}
                success:^(NSDictionary* data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dataSource = [NSMutableArray array];
                        [dataSource setArray:[data objectForKey:@"photos"]];
                        [self.collectionView reloadData];
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

}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    [cell.photo setImageWithURL:[NSURL URLWithString:[[dataSource objectAtIndex:indexPath.item] objectForKey:@"pic640x480"]]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.photoID = [[dataSource objectAtIndex:indexPath.item] objectForKey:@"id"];
    [self performSegueWithIdentifier:@"kSegueLogo" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"kSegueLogo"]) {
        LogoController *logo = [segue destinationViewController];
        logo.photoID = self.photoID;
    }
}


#pragma Mark - CHT collection view delegate waterfall layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((self.view.frame.size.width/2)-7.5f, (self.view.frame.size.height/3)-7.5f);
}



@end
