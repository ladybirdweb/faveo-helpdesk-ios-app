
#import "LeftMenuViewController.h"
#import "RKDropdownAlert.h"
#import "HexColors.h"
#import "AppConstanst.h"
#import "GlobalVariables.h"
#import "MyWebservices.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RMessage.h"
#import "RMessageView.h"
#import "Reachability.h"
#import "Utils.h"
#import "AppDelegate.h"


@import Firebase;
@interface LeftMenuViewController ()<RMessageProtocol>{
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;
    Utils *utils;
    UIRefreshControl *refresh;
}




@end

@implementation LeftMenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Naaa-LeftMENU");
    
    [self addUIRefresh];

    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"device_token %@",[userDefaults objectForKey:@"deviceToken"]);
    
    [self update];
    [self getDependencies];
    
    [self.tableView reloadData];
    
    [[AppDelegate sharedAppdelegate] showProgressViewWithText:NSLocalizedString(@"Getting Data",nil)];
    

}



-(void)viewWillAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    //[self.tableView reloadData];
    
}

-(void)update{
    
    [[AppDelegate sharedAppdelegate] hideProgressView];
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    NSLog(@"Role : %@",[userDefaults objectForKey:@"role"]);
    _user_role.text=[[userDefaults objectForKey:@"role"] uppercaseString];
    
    _user_nameLabel.text=[userDefaults objectForKey:@"profile_name"];
    _url_label.text=[userDefaults objectForKey:@"baseURL"];
    
    [_user_profileImage sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"profile_pic"]]
                          placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
    _user_profileImage.layer.borderColor=[[UIColor hx_colorWithHexRGBAString:@"#0288D1"] CGColor];
    
    _user_profileImage.layer.cornerRadius = _user_profileImage.frame.size.height /2;
    _user_profileImage.layer.masksToBounds = YES;
    _user_profileImage.layer.borderWidth = 0;
    
    
    _view1.alpha=0.5;
    _view1.layer.cornerRadius = 20;
    _view1.backgroundColor = [UIColor purpleColor];
    
    _view2.alpha=0.5;
    _view2.layer.cornerRadius = 20;
    _view2.backgroundColor = [UIColor purpleColor];
    
    
    _view3.alpha=0.5;
    _view3.layer.cornerRadius = 20;
    _view3.backgroundColor = [UIColor purpleColor];
    
    
    _view4.alpha=0.5;
    _view4.layer.cornerRadius = 20;
    _view4.backgroundColor = [UIColor purpleColor];
    
    _view5.alpha=0.5;
    _view5.layer.cornerRadius = 20;
    _view5.backgroundColor = [UIColor purpleColor];
    
    
    NSInteger open =  [globalVariables.OpenCount integerValue];
    NSInteger closed = [globalVariables.ClosedCount integerValue];
    NSInteger trash = [globalVariables.DeletedCount integerValue];
    NSInteger unasigned = [globalVariables.UnassignedCount integerValue];
    NSInteger my_tickets = [globalVariables.MyticketsCount integerValue];
    
    if(open>99){
        _c1.text=@"99+";
    }else
        _c1.text=@(open).stringValue;
    if(closed>99){
        _c4.text=@"99+";
    }else
        _c4.text=@(closed).stringValue;
    if(trash>99){
        _c5.text=@"99+";
    }else
        _c5.text=@(trash).stringValue;
    if(unasigned>99){
        _c3.text=@"99+";
    }else
        _c3.text=@(unasigned).stringValue;
    if(my_tickets>99){
        _c2.text=@"99+";
    }else
        _c2.text=@(my_tickets).stringValue;
    
    [self.tableView reloadData];
    
}
-(void)getDependencies{
    
    NSLog(@"Thread-NO1-getDependencies()-start");
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        if (self.navigationController.navigationBarHidden) {
            [self.navigationController setNavigationBarHidden:NO];
        }
        
        [RMessage showNotificationInViewController:self.navigationController
                                             title:NSLocalizedString(@"Error..!", nil)
                                          subtitle:NSLocalizedString(@"There is no Internet Connection...!", nil)
                                         iconImage:nil
                                              type:RMessageTypeError
                                    customTypeName:nil
                                          duration:RMessageDurationAutomatic
                                          callback:nil
                                       buttonTitle:nil
                                    buttonCallback:nil
                                        atPosition:RMessagePositionNavBarOverlay
                              canBeDismissedByUser:YES];
        
        
        
    }else{
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/dependency?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
                NSLog(@"Thread-NO3-getDependencies-start-error-%@-json-%@-msg-%@",error,json,msg);
                if (error || [msg containsString:@"Error"]) {
                    
                    NSLog(@"Thread-NO4-postCreateTicket-Refresh-error == %@",error.localizedDescription);
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    //               dispatch_async(dispatch_get_main_queue(), ^{
                    //                  [self getDependencies];
                    //               });
                    
                    [self getDependencies];
                    
                    NSLog(@"Thread--NO4-call-getDependecies");
                    return;
                }
                
                if (json) {
                    
                    NSLog(@"Thread-NO4-getDependencies-dependencyAPI--%@",json);
                    NSDictionary *resultDic = [json objectForKey:@"result"];
                    NSArray *ticketCountArray=[resultDic objectForKey:@"tickets_count"];
                    
                    
                    
                    for (int i = 0; i < ticketCountArray.count; i++) {
                        NSString *name = [[ticketCountArray objectAtIndex:i]objectForKey:@"name"];
                        NSString *count = [[ticketCountArray objectAtIndex:i]objectForKey:@"count"];
                        if ([name isEqualToString:@"Open"]) {
                            globalVariables.OpenCount=count;
                        }else if ([name isEqualToString:@"Closed"]) {
                            globalVariables.ClosedCount=count;
                        }else if ([name isEqualToString:@"Deleted"]) {
                            globalVariables.DeletedCount=count;
                        }else if ([name isEqualToString:@"unassigned"]) {
                            globalVariables.UnassignedCount=count;
                        }else if ([name isEqualToString:@"mytickets"]) {
                            globalVariables.MyticketsCount=count;
                        }
                    }
                    
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[AppDelegate sharedAppdelegate] hideProgressView];
                            [refresh endRefreshing];
                            [self.tableView reloadData];
                        });
                    });
                    
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                    
                    // get documents path
                    NSString *documentsPath = [paths objectAtIndex:0];
                    
                    // get the path to our Data/plist file
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
                    NSError *writeError = nil;
                    
                    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:resultDic format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&writeError];
                    
                    if(plistData)
                    {
                        [plistData writeToFile:plistPath atomically:YES];
                        NSLog(@"Data saved sucessfully");
                    }
                    else
                    {
                        NSLog(@"Error in saveData: %@", writeError.localizedDescription);               }
                    
                }
                NSLog(@"Thread-NO5-getDependencies-closed");
            }
             ];
        }@catch (NSException *exception)
        {
            // Print exception information
            NSLog( @"NSException caught in getDependencies method in Inbox ViewController" );
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return;
        }
        @finally
        {
            // Cleanup, in both success and fail cases
            NSLog( @"In finally block");
            
        }
    }
    NSLog(@"Thread-NO2-getDependencies()-closed");
    [[AppDelegate sharedAppdelegate] hideProgressView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
//}
//
//// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
//// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return ;
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIViewController *vc ;
    
    @try{
        switch (indexPath.row)
        {
            case 1:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"CreateTicket"];
                break;
                
            case 2:
                [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                break;
            case 3:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InboxID"];
                break;
            case 4:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"MyTicketsID"];
                break;
            case 5:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"UnassignedTicketsID"];
                break;
            case 6:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ClosedTicketsID"];
                break;
                
            case 7:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"TrashTicketsID"];
                break;
                
            case 8:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"ClientListID"];
                break;
                
            case 10:
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AboutVCID"];
                break;
                
                
            case 11:
                
                [self wipeDataInLogout];
                //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                //[[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:NO];
                
                // [RKDropdownAlert title:@"Faveo Helpdesk" message:@"You've logged out, successfully." backgroundColor:[UIColor hx_colorWithHexRGBAString:SUCCESS_COLOR] textColor:[UIColor whiteColor]];
                
                if (self.navigationController.navigationBarHidden) {
                    [self.navigationController setNavigationBarHidden:NO];
                }
                
                [RMessage showNotificationInViewController:self.navigationController
                                                     title:NSLocalizedString(@" Faveo Helpdesk ", nil)
                                                  subtitle:NSLocalizedString(@"You've logged out, successfully...!", nil)
                                                 iconImage:nil
                                                      type:RMessageTypeSuccess
                                            customTypeName:nil
                                                  duration:RMessageDurationAutomatic
                                                  callback:nil
                                               buttonTitle:nil
                                            buttonCallback:nil
                                                atPosition:RMessagePositionNavBarOverlay
                                      canBeDismissedByUser:YES];
                
                
                /*[RMessage showNotificationWithTitle:NSLocalizedString(@"Faveo Helpdesk", nil)
                 subtitle:NSLocalizedString(@"You've logged out, successfully...!", nil)
                 type:RMessageTypeSuccess
                 customTypeName:nil
                 callback:nil]; */
                vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"Login"];
                // (vc.view.window!.rootViewController?).dismissViewControllerAnimated(false, completion: nil);
                break;
                
                //        case 3:
                //            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
                //            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
                //            return;
                //            break;
                
            default:
                break;
        }
    }@catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught in LeftMenu View Controller" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
    }
    
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 9) {
        return 0;
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
}

-(void)wipeDataInLogout{
    
    [self sendDeviceToken];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
    NSError *error;
    @try{
        if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
        {
            NSLog(@"Error while removing the plist %@", error.localizedDescription);
            //TODO: Handle/Log error
        }
    }@catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught in Logout Process in LeftMenu ViewController" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
    }
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    
}

-(void)sendDeviceToken{
    
    // NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:@"%@fcmtoken?user_id=%@&fcm_token=%s&os=%@",[userDefaults objectForKey:@"companyURL"],[userDefaults objectForKey:@"user_id"],"0",@"ios"];
    @try{
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponsePOST:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg){
            if (error || [msg containsString:@"Error"]) {
                if (msg) {
                    
                    // [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                    NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
                }else if(error)  {
                    //                [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-postAPNS-toserver-error == %@",error.localizedDescription);
                }
                return ;
            }
            if (json) {
                
                NSLog(@"Thread-sendAPNS-token-json-%@",json);
            }
            
        }];
    }@catch (NSException *exception)
    {
        // Print exception information
        NSLog( @"NSException caught In sendDeviceToken method in LeftMenu ViewController" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return;
    }
    @finally
    {
        // Cleanup, in both success and fail cases
        NSLog( @"In finally block");
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
    // if ( indexPath.section == 0 ) return nil;
    
    
    
    // first 3 rows in any section should not be selectable
    if ( (indexPath.row ==0) || (indexPath.row==2) ) return nil;
    
    // By default, allow row to be selected
    return indexPath;
}


-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    refresh=[[UIRefreshControl alloc] init];
    refresh.tintColor=[UIColor whiteColor];
    refresh.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    refresh.attributedTitle =refreshing;
    [refresh addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refresh atIndex:0];
    
}

-(void)reloadd{
    //[self getDependencies];
    [self update];
    [self.tableView reloadData];
    
    [refresh endRefreshing];
}


@end

