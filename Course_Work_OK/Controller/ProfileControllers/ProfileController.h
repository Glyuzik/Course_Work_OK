//
//  ProfileController.h
//  Course_Work_OK
//
//  Created by Роман Глюзо on 09.11.16.
//  Copyright © 2016 Роман Глюзо. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileController : UIViewController

@property (strong, nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UIButton *suggest, *invite, *post;

@end
