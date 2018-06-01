//
//  ClientListViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 01/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "ClientListViewController.h"
#import "ClientListTableViewCell.h"
#import "ClientDetailViewController.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "AppDelegate.h"
#import "LoadingTableViewCell.h"
#import "GlobalVariables.h"

@interface ClientListViewController (){

    Utils *utils;
    UIRefreshControl *refresh;
    NSUserDefaults *userDefaults;
    GlobalVariables *globalVariables;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalTickets;
@property (nonatomic, strong) NSString *nextPageUrl;
@end

@implementation ClientListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Client List"];
    
    [self addUIRefresh];
    utils=[[Utils alloc]init];
    
    globalVariables=[GlobalVariables sharedInstance];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    [[AppDelegate sharedAppdelegate] showProgressViewWithText:@"Getting Data"];
    [self reload];

    // Do any additional setup after loading the view.
}


-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [[AppDelegate sharedAppdelegate] hideProgressView];
        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
        
        //        [[AppDelegate sharedAppdelegate] showProgressView];
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/customers-custom?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            if (error || [msg containsString:@"Error"]) {
 [refresh endRefreshing];
                [[AppDelegate sharedAppdelegate] hideProgressView];
                [utils showAlertWithMessage:@"Error" sendViewController:self];
                NSLog(@"Thread-NO4-getClients-Refresh-error == %@",error.localizedDescription);
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self reload];
                NSLog(@"Thread--NO4-call-getClients");
                return;
            }
            
            if (json) {
                //NSError *error;
                _mutableArray=[[NSMutableArray alloc]initWithCapacity:11];
                NSLog(@"Thread-NO4--getClientsAPI--%@",json);
                _mutableArray = [json objectForKey:@"data"];
                _nextPageUrl =[json objectForKey:@"next_page_url"];
                _currentPage=[[json objectForKey:@"current_page"] integerValue];
                _totalTickets=[[json objectForKey:@"total"] integerValue];
                _totalPages=[[json objectForKey:@"last_page"] integerValue];
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[AppDelegate sharedAppdelegate] hideProgressView];
                        [refresh endRefreshing];
                        [self.tableView reloadData];
                    });
                });
               
            }
            NSLog(@"Thread-NO5-getClients-closed");
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_mutableArray count] - 1 ) {
        NSLog(@"nextURL  %@",_nextPageUrl);
        if (( ![_nextPageUrl isEqual:[NSNull null]] ) && ( [_nextPageUrl length] != 0 )) {
            [self loadMore];
        }
    }
}

-(void)loadMore{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices getNextPageURL:_nextPageUrl callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            if (error || [msg containsString:@"Error"]) {
                LoadingTableViewCell *lc=[[LoadingTableViewCell alloc]init];
                lc.loadingLbl.text=@"Failed!";
                [lc.indicator setHidden:YES];
                [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self loadMore];
                //NSLog(@"Thread--NO4-call-getInbox");
                return;
            }
            
            if (json) {
                NSLog(@"Thread-NO4--getInboxAPI--%@",json);
                
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
            NSLog(@"Thread-NO5-getInbox-closed");
            
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.currentPage == self.totalPages
        || self.totalTickets == _mutableArray.count) {
        return _mutableArray.count;
    }
    return _mutableArray.count + 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if ([_mutableArray count]==0)
    {
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        noDataLabel.text             = @"Empty!!!";
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

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

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

    
    ClientListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ClientListCellID"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ClientListTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];

    NSString *email=[finaldic objectForKey:@"email"];
    NSString *phone=[finaldic objectForKey:@"phone_number"];
    NSString *clientName=[finaldic objectForKey:@"first_name"];
    if ([email isEqualToString:@""]) {
        email=@"Not Available";
    }
    if ([phone isEqualToString:@""]) {
        phone=@"Not Available";
    }
    if ([clientName isEqualToString:@""]) {
        clientName=@"Not Available";
    }
    cell.emailIdLabel.text=email;
    cell.phoneNumberLabel.text=phone;
    cell.clientNameLabel.text=[NSString stringWithFormat:@"%@ %@",clientName,[finaldic objectForKey:@"last_name"]];
    [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
    
    NSString *fName=[finaldic objectForKey:@"first_name"];
    NSString *lName=[finaldic objectForKey:@"last_name"];
    NSString *userName=[finaldic objectForKey:@"user_name"];
    NSString *email=[finaldic objectForKey:@"email"];
   
    NSString *userId=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"id"]];
    NSString *userState=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"active"]];
    NSString *userMobile=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"mobile"]];
    NSString *userPhone=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"phone_number"]];
    
    NSString *userProfile=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"profile_pic"]];
    
    [Utils isEmpty:fName];
    [Utils isEmpty:lName];
    [Utils isEmpty:userName];
    [Utils isEmpty:email];
    
    [Utils isEmpty:userId];
    [Utils isEmpty:userState];
    [Utils isEmpty:userMobile];
    [Utils isEmpty:userProfile];
    [Utils isEmpty:userPhone];
    
    if([Utils isEmpty:fName] && [Utils isEmpty:lName])
    {
        if(![Utils isEmpty:userName])
        {
            globalVariables.firstNameFromUserList=userName;
        }
    }else{
        
        globalVariables.firstNameFromUserList=[NSString stringWithFormat:@"%@ %@",fName,lName];
    }
    
    if(![Utils isEmpty:email])
    {
        globalVariables.emailFromUserList=email;
    }else
    {
        globalVariables.emailFromUserList=@"Not Available";
    }
    
    if(![Utils isEmpty:userState])
    {
        if([userState isEqualToString:@"1"])
        {
            globalVariables.userStateFromUserList=@"ACTIVE";
        }else{
            globalVariables.userStateFromUserList=@"INACTIVE";
        }
    }
    
    if(![Utils isEmpty:userMobile])
    {
        globalVariables.mobileFromUserList=userMobile;
    }
    else  if(![Utils isEmpty:userPhone])
    {
        globalVariables.mobileFromUserList=userPhone;
    }
    else{
        globalVariables.mobileFromUserList=@"Not Available";
    }
   
    
    if(![Utils isEmpty:userProfile])
    {
        globalVariables.profilePicFromUserList=userProfile;
    }
    else{
        
    }
    
    globalVariables.userIdFromUserList=userId;
    
    ClientDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"ClientDetailVCID"];
    [self.navigationController pushViewController:td animated:YES];

}

-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:@"Refreshing" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
