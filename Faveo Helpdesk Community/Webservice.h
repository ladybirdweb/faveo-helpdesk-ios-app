//
//  Webservice.h
//  Share Coupon
//
//  Created by Anilkumar on 20/06/15.
//  Copyright (c) 2015 Anilkumar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Customblock)(NSString *result);

@interface Webservice : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *responsedata;
    NSURLConnection *connection;
    Customblock callbackproperty; 
}
@property (nonatomic,strong) NSMutableData *responsedata;
@property (readwrite,copy) Customblock callbackproperty;
@property (nonatomic,strong) NSURLConnection *connection;

//methods
//Login API
-(void)loginusername:(NSString*)userNameString password:(NSString*)passwordString usingcallback:(void (^) (NSString *result))afterresponse;
//Register API
-(void)registerName:(NSString*)userNameString email:(NSString*)emailString password:(NSString*)passwordString phone:(NSString*)phoneString address1:(NSString*)address1String address2:(NSString*)address2String zipcode:(NSString*)zipcodeString city:(NSString*)cityString location:(NSString*)locationString usingcallback:(void (^) (NSString *result))afterresponse;
//List Coupon API
-(void)fetchCouponsUserId:(NSString*)userIdString usingcallback:(void(^)(NSString*result))afterresponse;

//List All Coupons API
-(void)fetchCouponsUsingcallback:(void (^) (NSString *result))afterresponse;
//Coupon Details API
-(void)fetchCouponDetailsCouponId:(NSString*)couponIdString usingcallback:(void(^)(NSString*result))afterresponse;
//Add Coupon API
-(void)addCouponName:(NSString*)nameString amount:(NSString*)amountString validity:(NSString*)validityString storeName:(NSString*)storeNameString userId:(NSString*)userIdString description:(NSString*)descriptionString coins:(NSString*)coinsString category:(NSString*)categoryString location:(NSString*)locationString usingcallback:(void (^)(NSString *result))afterresponse;

//Buy Coupon API
-(void)buyCouponCouponId:(NSString*)couponIdString userId:(NSString*)userIdString usingcallback:(void (^)(NSString *result))afterresponse;

//History of Bought Coupons By a User - API
-(void)boughtCouponHistoryUserId:(NSString*)userIdString usingcallback:(void (^)(NSString*result))afterresponse;

//View Profile - API
-(void)fetchProfileDetailsuserId:(NSString*)userIdString usingcallback:(void (^) (NSString *result))afterresponse;

//Update Profile - API
-(void)updateUserProfileuserId:(NSString*)userIdString name:(NSString*)nameString email:(NSString*)emailIdString password:(NSString*)passwordString phone:(NSString*)phoneNumberString address1:(NSString*)address1String address2:(NSString*)address2String zipcode:(NSString*)zipcodeString city:(NSString*)cityString location:(NSString*)locationString defaultPoints:(NSString*)defaultPointsString active:(NSString*)activeString usingcallback:(void (^) (NSString *result))afterresponse;

//fetch points
-(void)fetchPointsuserId:(NSString*)userIdString usingcallback:(void (^) (NSString *result))afterresponse;


@end
