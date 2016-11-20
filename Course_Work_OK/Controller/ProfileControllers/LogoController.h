//
//  LogoController.h
//  Course_Work_OK
//
//  Created by Роман Глюзо on 09.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoController : UIViewController

@property (strong, nonatomic) NSString *imageURLString;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *photoDescription;
@property (weak, nonatomic) NSString *photoID;



@end
