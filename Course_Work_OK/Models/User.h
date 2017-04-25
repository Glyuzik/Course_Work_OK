//
//  User.h
//  
//
//  Created by Роман Глюзо on 10.11.16.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject


@property (strong, nonatomic) NSString *userName, *userFirstName, *birthday, *gender, *status, *location, *photoID, *photoDescription;
@property (strong, nonatomic) NSString *imageUrlString;
@property (strong, nonatomic) NSNumber *photoLikeCount;

-(id)initUserWithArray:(NSDictionary *)dictionary;

@end
