//
//  ClientDetailViewController.h
//  SideMEnuDemo
//
//  Created by Narendra on 08/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *testingLAbel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@property (strong,nonatomic) NSString *imageURL;
-(void)setUserProfileimage:(NSString*)imageUrl;

@property(nonatomic,strong) NSString * isClientActive;
@property(nonatomic,strong) NSString * emailID;
@property(nonatomic,strong) NSString * phone;
@property(nonatomic,strong) NSString * clientName;
@property(nonatomic,strong) NSString * clientId;

@end
