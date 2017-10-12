//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "AppConstanst.h"
#import "Utils.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "RKDropdownAlert.h"
#import "HexColors.h"
#import "LoadingTableViewCell.h"
#import "TicketDetailViewController.h"
#import "ClientListViewController.h"
#import "ClientDetailViewController.h"
#import "RMessage.h"
#import "RMessageView.h"
@import FirebaseInstanceID;
@import FirebaseMessaging;


@interface NotificationViewController ()<RMessageProtocol>
{
    Utils *utils;
    UIRefreshControl *refresh;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;    
}

@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) NSArray *indexPaths;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalTickets;
@property (nonatomic, strong) NSString *nextPageUrl;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Naa-Inbox");
    
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"refreshed token  %@",refreshedToken);
    
    [self setTitle:NSLocalizedString(@"Notifications",nil)];
    [self addUIRefresh];
    NSLog(@"string %@",NSLocalizedString(@"Inbox",nil));
    _mutableArray=[[NSMutableArray alloc]init];
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    NSLog(@"device_token %@",[userDefaults objectForKey:@"deviceToken"]);
    
    [[AppDelegate sharedAppdelegate] showProgressViewWithText:NSLocalizedString(@"Getting Data",nil)];
    [self reload];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)reload
{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [refresh endRefreshing];
        //connection unavailable
        [[AppDelegate sharedAppdelegate] hideProgressView];
        //[utils showAlertWithMessage:NO_INTERNET sendViewController:self];
      //  [RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];
        
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
        
        
        
        NSString *url= [NSString stringWithFormat:@"%@helpdesk/notifications?api_key=%@&user_id=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,[userDefaults objectForKey:@"user_id"],[userDefaults objectForKey:@"token"]];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            
            
            if (error || [msg containsString:@"Error"]) {
                [refresh endRefreshing];
                [[AppDelegate sharedAppdelegate] hideProgressView];
                if (msg) {
                    
                    [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                    
                }else if(error)  {
                    [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-NO4-getNotificationViewController-Refresh-error == %@",error.localizedDescription);
                }
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self reload];
                NSLog(@"Thread--NO4-call-getNotificationViewController");
                return;
            }
            
            if (json) {
                //NSError *error;
                NSLog(@"Thread-NO4--getInboxAPI--%@",json);
                _mutableArray = [json objectForKey:@"data"];
                _nextPageUrl =[json objectForKey:@"next_page_url"];
                _currentPage=[[json objectForKey:@"current_page"] integerValue];
                _totalTickets=[[json objectForKey:@"total"] integerValue];
                _totalPages=[[json objectForKey:@"last_page"] integerValue];
                NSLog(@"Thread-NO4.1getInbox-dic--%@", _mutableArray);
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[AppDelegate sharedAppdelegate] hideProgressView];
                        [refresh endRefreshing];
                        [self.tableView reloadData];
                    });
                });
                
            }
            NSLog(@"Thread-NO5-getNotificationViewController-closed");
            
        }];
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if ([_mutableArray count]==0)
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.text             =  NSLocalizedString(@"Empty!!!",nil);
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = noDataLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                = 1;
        tableView.backgroundView = nil;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentPage == self.totalPages
        || self.totalTickets == _mutableArray.count) {
        return _mutableArray.count;
    }
    
    
    return _mutableArray.count + 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_mutableArray count] - 1 ) {
        NSLog(@"nextURL  %@",_nextPageUrl);
        if (( ![_nextPageUrl isEqual:[NSNull null]] ) && ( [_nextPageUrl length] != 0 )) {
           
            [self loadMore];

        }
        else{
           // [RKDropdownAlert title:@"" message:@"All Caught Up...!" backgroundColor:[UIColor hx_colorWithHexRGBAString:ALERT_COLOR] textColor:[UIColor whiteColor]];
            
            [RMessage showNotificationInViewController:self
                                                 title:nil
                                              subtitle:NSLocalizedString(@"All Caught Up...!)", nil)
                                             iconImage:nil
                                                  type:RMessageTypeSuccess
                                        customTypeName:nil
                                              duration:RMessageDurationAutomatic
                                              callback:nil
                                           buttonTitle:nil
                                        buttonCallback:nil
                                            atPosition:RMessagePositionBottom
                                  canBeDismissedByUser:YES];
            
        }
    }
}

-(void)loadMore{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        //[utils showAlertWithMessage:NO_INTERNET sendViewController:self];
       // [RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];
        
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
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices getNextPageURL:_nextPageUrl callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            if (error || [msg containsString:@"Error"]) {
                
                if (msg) {
                    
                    [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                    
                }else if(error)  {
                    [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                }
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self loadMore];
                //NSLog(@"Thread--NO4-call-getInbox");
                return;
            }
            
            if (json) {
                NSLog(@"Thread-NO4--getNotifictionAPI--%@",json);
                //_indexPaths=[[NSArray alloc]init];
                //_indexPaths = [json objectForKey:@"data"];
                _nextPageUrl =[json objectForKey:@"next_page_url"];
                _currentPage=[[json objectForKey:@"current_page"] integerValue];
                _totalTickets=[[json objectForKey:@"total"] integerValue];
                _totalPages=[[json objectForKey:@"last_page"] integerValue];
                
                
                _mutableArray= [_mutableArray mutableCopy];
                
                [_mutableArray addObjectsFromArray:[json objectForKey:@"data"]];
                
            
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                                            });
                });
                
            }
            NSLog(@"Thread-NO5-getNotifictionViewController-closed");
            
        }];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == [_mutableArray count]) {
        
        LoadingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LoadingCellID"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LoadingTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:1];
        [activityIndicator startAnimating];
        return cell;
    }else{
        
        NotificationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"NotificationCellID"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            
        }
        
        NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];

       // cell.msglbl.text=[finaldic objectForKey:@"message"];
        
        if ( ( ![[finaldic objectForKey:@"message"] isEqual:[NSNull null]] ) && ( [[finaldic objectForKey:@"message"] length] != 0 ) )
        {
            cell.msglbl.text=[finaldic objectForKey:@"message"];
        }
        else
        {
            cell.msglbl.text= NSLocalizedString(@"Not Available",nil);
        }
       

       // cell.timelbl.text=[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_utc"]];
        
        if ( ( ![[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_utc"]] isEqual:[NSNull null]] ) && ( [[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_utc"]] length] != 0 ) )
        {
            cell.timelbl.text=[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_utc"]];
        }
        else
        {
            cell.timelbl.text= NSLocalizedString(@"Not Available",nil);
        }
      
        
        NSDictionary *profileDict= [finaldic objectForKey:@"requester"];
        
        
        if(( ![[finaldic objectForKey:@"requester"] isEqual:[NSNull null]] ) )
        {
            [cell setUserProfileimage:[profileDict objectForKey:@"profile_pic"]];
           
            
            NSString *fname= [profileDict objectForKey:@"changed_by_first_name"];
            NSString *lname= [profileDict objectForKey:@"changed_by_last_name"];
            
            [Utils isEmpty:fname];
            [Utils isEmpty:lname];
            
            if (![Utils isEmpty:fname] || ![Utils isEmpty:lname])
            {
                  if(![Utils isEmpty:fname] && ![Utils isEmpty:lname])
                  {
                      cell.name.text= [NSString stringWithFormat:@"%@ %@",fname,lname];
                  }
                else if ((![Utils isEmpty:fname] && [Utils isEmpty:lname]) || ([Utils isEmpty:fname] && ![Utils isEmpty:lname]))
                {
                    cell.name.text= [NSString stringWithFormat:@"%@ %@",fname,lname];
                }
            }
            else
            {
               // cell.name.text=@"Not Availabel";
                cell.name.text= NSLocalizedString(@"Not Available",nil);
            }
                
         //   cell.name.text=[NSString stringWithFormat:@"%@ %@",[profileDict objectForKey:@"changed_by_first_name"],[profileDict objectForKey:@"changed_by_last_name"]];
        }
        else{
            
            [cell setUserProfileimage:@"default_pic.png"];
        }
     
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];

    ClientDetailViewController *clientDetail=[self.storyboard instantiateViewControllerWithIdentifier:@"ClientDetailVCID"];
    
      NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
    
    NSString *sen=[finaldic objectForKey:@"senario"];
    NSLog(@"Senario is : %@",sen);
    
    if([sen isEqualToString:@"tickets"])
    {
        [self.navigationController pushViewController:td animated:YES];
    }
    else if ([sen isEqualToString:@"users"]){
        [self.navigationController pushViewController:clientDetail animated:YES];
    }
  
    NSDictionary *dict1= [finaldic objectForKey:@"requester"];
    
     globalVariables.iD=[dict1 objectForKey:@"id"];
   // globalVariables.ticket_number=[finaldic objectForKey:@"ticket_number"];
    globalVariables.title=[finaldic objectForKey:@"title"];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
  //  [[self navigationController] setNavigationBarHidden:NO];
    
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
    [_tableView insertSubview:refresh atIndex:0];
    
}

-(void)reloadd{
    [self reload];
    //    [refresh endRefreshing];
}



@end
