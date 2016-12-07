//
//  Data.h
//  SideMEnuDemo
//
//  Created by Narendra on 29/11/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (strong, nonatomic) NSNumber *iD;
@property (strong, nonatomic) NSString *ticket_number;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *first_name;
@property (strong, nonatomic) NSString *last_name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *profile_pic;
@property (strong, nonatomic) NSString *created_at;

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
