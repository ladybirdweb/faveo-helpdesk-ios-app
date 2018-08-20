

#import <Foundation/Foundation.h>

/*!
 @class Data
 
 @brief This class contains common variable declaration
 
 @discussion It contains variable declaration that are commonly used throughout the app so that accessing and calling is very easy.
 
 @superclass NSObject
 
 */

@interface Data : NSObject

/*!
 @property iD
 
 @brief It is used for defining is id of a ticket.
 */
@property (strong, nonatomic) NSNumber *iD;

/*!
 @property ticket_number
 
 @brief It used for definig ticket number.
 */
@property (strong, nonatomic) NSString *ticket_number;

/*!
 @property title
 
 @brief It is used for defining title.
 */
@property (strong, nonatomic) NSString *title;

/*!
 @property first_name
 
 @brief It is used for defining first namer of user.
 */
@property (strong, nonatomic) NSString *first_name;

/*!
 @property last_name
 
 @brief It is used for defining last name of user.
 */
@property (strong, nonatomic) NSString *last_name;

/*!
 @property email
 
 @brief It is used for defining email id of user.
 */
@property (strong, nonatomic) NSString *email;

/*!
 @property profile_pic
 
 @brief It is used for defining a profile picture of user.
 */
@property (strong, nonatomic) NSString *profile_pic;

/*!
 @property created_at
 
 @brief It is used for defining date, at which time ticket was created.
 */
@property (strong, nonatomic) NSString *created_at;

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@end
