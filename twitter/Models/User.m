//
//  User.m
//  twitter
//
//  Created by Diego de Jesus Ramirez on 29/06/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profile_image_url_https = [NSURL URLWithString: dictionary[@"profile_image_url_https"]];
    }
    return self;
}
    
@end
