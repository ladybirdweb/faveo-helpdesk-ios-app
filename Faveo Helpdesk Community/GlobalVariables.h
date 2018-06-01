//
//  GlobalVariables.h
//  SideMEnuDemo
//
//  Created by Narendra on 30/11/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalVariables : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) NSNumber *iD;
@property (strong, nonatomic) NSString *ticket_number;
@property (strong, nonatomic) NSString *title;


@property (strong, nonatomic) NSString *firstNameFromUserList;
@property (strong, nonatomic) NSString *lastNameFromUserList;
@property (strong, nonatomic) NSString *userIdFromUserList;
@property (strong, nonatomic) NSString *phoneFromUserList;
@property (strong, nonatomic) NSString *mobileFromUserList;
@property (strong, nonatomic) NSString *userNameFromUserList;
@property (strong, nonatomic) NSString *profilePicFromUserList;
@property (strong, nonatomic) NSString *emailFromUserList;
@property (strong, nonatomic) NSString *userStateFromUserList;





@end
