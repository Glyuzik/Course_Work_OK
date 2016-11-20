//
//  User.m
//  
//
//  Created by Роман Глюзо on 10.11.16.
//
//

#import "User.h"

@implementation User

- (instancetype)initUserWithDictionary:(NSArray *)array;
{
    self = [super init];
    if (self) {
        self.imageUrlString = [[array objectAtIndex:0] objectForKey:@"pic640x480"];
        
        self.userName = [[array objectAtIndex:0] objectForKey:@"name"];
        
        NSString *gender = [[[array objectAtIndex:0] objectForKey:@"gender"] isEqualToString:@"male"]? @"Мужской":@"Женский";
        self.gender = [NSString stringWithFormat:@"Пол:%@", gender];
        
        if ([[array objectAtIndex:0] objectForKey:@"age"] != nil) {
             self.birthday = [NSString stringWithFormat:@"День рождения:%@ (%@ лет)", [[array objectAtIndex:0] objectForKey:@"birthday"], [[array objectAtIndex:0] objectForKey:@"age"]];
        }else{
        self.birthday = [NSString stringWithFormat:@"День рождения:%@", [[array objectAtIndex:0] objectForKey:@"birthday"]];
        }
        
        self.status = [[array objectAtIndex:0] objectForKey:@"current_status"];
        
        self.location = [NSString stringWithFormat:@"%@, %@",[[array objectAtIndex:0] valueForKeyPath:@"location.countryName"], [[array objectAtIndex:0] valueForKeyPath:@"location.city"]];
        
        self.photoID = [[array objectAtIndex:0]objectForKey:@"photo_id"];
        
    }
    return self;
}

@end
