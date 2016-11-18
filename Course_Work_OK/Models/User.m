//
//  User.m
//  
//
//  Created by Роман Глюзо on 10.11.16.
//
//

#import "User.h"

@implementation User

- (instancetype)initUserWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.imageUrlString = [dictionary objectForKey:@"pic1024x768"];
        
        self.userName = [dictionary objectForKey:@"name"];
        
        NSString *gender = [[dictionary objectForKey:@"gender"] isEqualToString:@"male"]? @"Мужской":@"Женский";
        self.gender = [NSString stringWithFormat:@"Пол:%@", gender];
        
        self.birthday = [NSString stringWithFormat:@"День рождения:%@ (%@ лет)", [dictionary objectForKey:@"birthday"], [dictionary objectForKey:@"age"]];
        
        self.status = [dictionary objectForKey:@"current_status"];
        
        self.location = [NSString stringWithFormat:@"%@, %@",[dictionary valueForKeyPath:@"location.countryName"], [dictionary valueForKeyPath:@"location.city"]];
        
        self.photoID = [dictionary objectForKey:@"photo_id"];
        
        self.photoDescription = [dictionary valueForKeyPath:@"photo.text"];
        
        self.photoLikeCount = [dictionary valueForKeyPath:@"photo.like_count"];
    }
    return self;
}

@end
