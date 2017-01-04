//
//  InboxViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 19/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "InboxViewController.h"
#import "TicketTableViewCell.h"
#import "CreateTicketViewController.h"
#import "TicketDetailViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "GlobalVariables.h"
#import "LoadingTableViewCell.h"
#import "RKDropdownAlert.h"
#import "HexColors.h"

@interface InboxViewController (){
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

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Inbox"];
    [self addUIRefresh];
    _mutableArray=[[NSMutableArray alloc]init];

//    UINib *nib = [UINib nibWithNibName:@"TicketTableViewCell" bundle:nil];
//    [[self tableView] registerNib:nib forCellReuseIdentifier:@"TableViewCellID"];
//    [[self tableView] registerNib:nib  forCellReuseIdentifier:@"LoadingCellID"];
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnPressed)]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self getDependencies];
    });
    [[AppDelegate sharedAppdelegate] showProgressViewWithText:@"Getting Data"];
    [self reload];
    // Do any additional setup after loading the view.
}

-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [refresh endRefreshing];
        //connection unavailable
        [[AppDelegate sharedAppdelegate] hideProgressView];
        //[utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        [RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];

    }else{
        
        //        [[AppDelegate sharedAppdelegate] showProgressView];
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/inbox?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            if (error || [msg containsString:@"Error"]) {
                [refresh endRefreshing];
                [[AppDelegate sharedAppdelegate] hideProgressView];
                if (msg) {
                    
                    [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",msg] sendViewController:self];
                    
                }else if(error)  {
                    [utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                    NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                }
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self reload];
                NSLog(@"Thread--NO4-call-getInbox");
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
            NSLog(@"Thread-NO5-getInbox-closed");
            
        }];
    }
}

-(void)getDependencies{
    
    NSLog(@"Thread-NO1-getDependencies()-start");
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        
        //[utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/dependency?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
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
                //                   NSArray *deptArray=[resultDic objectForKey:@"departments"];
                //                   NSArray *helpTopicArray=[resultDic objectForKey:@"helptopics"];
                //                   NSArray *prioritiesArray=[resultDic objectForKey:@"priorities"];
                //                   NSArray *slaArray=[resultDic objectForKey:@"sla"];
                //                   NSArray *sourcesArray=[resultDic objectForKey:@"sources"];
                //                   NSArray *staffsArray=[resultDic objectForKey:@"staffs"];
                //                   NSArray *statusArray=[resultDic objectForKey:@"status"];
                //                   NSArray *teamArray=[resultDic objectForKey:@"teams"];
                //                   NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",deptArray,helpTopicArray,prioritiesArray,slaArray,sourcesArray,staffsArray,statusArray,teamArray);
                
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
    }
    NSLog(@"Thread-NO2-getDependencies()-closed");
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
    }
}

-(void)loadMore{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
       [RKDropdownAlert title:APP_NAME message:NO_INTERNET backgroundColor:[UIColor hx_colorWithHexRGBAString:FAILURE_COLOR] textColor:[UIColor whiteColor]];
        
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
                NSLog(@"Thread-NO4--getInboxAPI--%@",json);
                //_indexPaths=[[NSArray alloc]init];
                //_indexPaths = [json objectForKey:@"data"];
                _nextPageUrl =[json objectForKey:@"next_page_url"];
                _currentPage=[[json objectForKey:@"current_page"] integerValue];
                _totalTickets=[[json objectForKey:@"total"] integerValue];
                _totalPages=[[json objectForKey:@"last_page"] integerValue];

//                for (int i = [_mutableArray count]; i < theTotalNumberOfAdditionalCellsToInsert + theFirstIndexWhereYouWantToInsertYourAdditionalCells; i++) {
//                    [self.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//                }
                
               _mutableArray= [_mutableArray mutableCopy];
              
                [_mutableArray addObjectsFromArray:[json objectForKey:@"data"]];
                
              //                NSLog(@"Thread-NO4.1getInbox-dic--%@", _mutableArray);
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
//                        [self.tableView beginUpdates];
//                        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[_mutableArray count]-[_indexPaths count] inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
//                        [self.tableView endUpdates];
                    });
                });
            
            }
            NSLog(@"Thread-NO5-getInbox-closed");
            
        }];
    }
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
      
        TicketTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"TableViewCellID"];
        
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TicketTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
            NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
            
            cell.ticketIdLabel.text=[finaldic objectForKey:@"ticket_number"];
            cell.mailIdLabel.text=[finaldic objectForKey:@"email"];
            cell.timeStampLabel.text=[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_at"]];
            cell.ticketSubLabel.text=[finaldic objectForKey:@"title"];
            [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
            
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
    NSDictionary *finaldic=[_mutableArray objectAtIndex:indexPath.row];
    
    globalVariables.iD=[finaldic objectForKey:@"id"];
    globalVariables.ticket_number=[finaldic objectForKey:@"ticket_number"];
    globalVariables.title=[finaldic objectForKey:@"title"];
    //    globalVariables.first_name=[finaldic objectForKey:@"first_name"];
    //    globalVariables.last_name=[finaldic objectForKey:@"last_name"];
    //    globalVariables.email=[finaldic objectForKey:@"email"];
    //    globalVariables.created_at=[finaldic objectForKey:@"created_at"];
    //    globalVariables.updated_at=[finaldic objectForKey:@"updated_at"];
    //
    //    globalVariables.help_topic_name=[finaldic objectForKey:@"help_topic_name"];
    //    globalVariables.sla_plan_name=[finaldic objectForKey:@"sla_plan_name"];
    //    globalVariables.priotity_name=[finaldic objectForKey:@"priotity_name"];
    //    globalVariables.department_name=[finaldic objectForKey:@"department_name"];
    
    [self.navigationController pushViewController:td animated:YES];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

-(void)addBtnPressed{
    
    CreateTicketViewController *createTicket=[self.storyboard instantiateViewControllerWithIdentifier:@"CreateTicket"];
    
    [self.navigationController pushViewController:createTicket animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[self navigationController] setNavigationBarHidden:NO];
    
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

//-(void)getDependencies{
//     NSLog(@"getDependencies");
//
//    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
//    {
//        //connection unavailable
//        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
//
//    }else{
//
//        NSString *url=[NSString stringWithFormat:@"%@helpdesk/dependency?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//        [request setURL:[NSURL URLWithString:url]];  // add your url
//        [request setHTTPMethod:@"GET"];  // specify the JSON type to GET
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
//         [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//             if (error) {
//                 NSLog(@"dataTaskWithRequest error: %@", error);
//                 return;
//             }
//             if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//
//                 NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
//
//                 if (statusCode != 200) {
//                     NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
//
//                     [utils showAlertWithMessage:@"Unknown Error!" sendViewController:self];
//                     return;
//                 }
//
//                 NSString *replyStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//                 NSLog(@"Get your response == %@", replyStr);
//
//                 if ([replyStr containsString:@"Token has expired"]) {
//
//                      NSLog(@"Refresh the token!");
//                     MyWebservices *webservices=[MyWebservices sharedInstance];
//                     [webservices refreshToken];
//                     [self getDependencies];
//
//                      NSLog(@"Refreshed the token!");
//                 }else if([replyStr containsString:@"result"]){
//                     NSError *error;
//                      NSLog(@"dependencyAPI--%@",replyStr);
//                     NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
//                     NSLog(@"error--%@",[error localizedDescription]);
//                  NSDictionary *dic = [jsonData objectForKey:@"result"];
//                     NSLog(@"dic--%@",dic);
//
//
//                 }
//
//             }
//
//             NSLog(@"Got response %@ with error %@.\n", response, error);
//
//         }]
//          resume];
//
//    }
//}

//-(void)reload{
//    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
//    {
//        //connection unavailable
//        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
//
//    }else{
//
//        [[AppDelegate sharedAppdelegate] showProgressView];
//        NSString *url=[NSString stringWithFormat:@"%@helpdesk/inbox?api_key=%@&ip=%@&token=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//        [request setURL:[NSURL URLWithString:url]];  // add your url
//        [request setHTTPMethod:@"GET"];  // specify the JSON type to GET
//
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
//        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            if (error) {
//                NSLog(@"dataTaskWithRequest error: %@", error);
//                return;
//            }else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//
//                NSError *error=nil;
//                id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//                if (error) {
//                    NSLog(@"response : %@", error.localizedDescription);
//                    NSLog(@"json : %@", json);
//
//                }
//
//                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
//
//                if (statusCode != 200) {
//                    NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
//                    [[AppDelegate sharedAppdelegate] hideProgressView];
//                    [utils showAlertWithMessage:@"Loading failed!" sendViewController:self];
//                    return;
//                }
//
//                NSString *replyStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//                NSLog(@"Get your response == %@", replyStr);
//
//                if ([replyStr containsString:@"Token has expired"]) {
//
//                    NSLog(@"Refresh the token!");
//                    MyWebservices *webservices=[MyWebservices sharedInstance];
//                    [webservices refreshToken];
//                    [self reload];
//                    NSLog(@"Refreshed the token!");
//                }else if([replyStr containsString:@"total"]){
//                    NSError *error=nil;
//                    [[AppDelegate sharedAppdelegate] hideProgressView];
//                    NSLog(@"inboxAPI--%@",replyStr);
//                    NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
//                    NSLog(@"response : %@", error.localizedDescription);
//                    NSDictionary *dic = [jsonData objectForKey:@"total"];
//
//                }
//
//            }
//
//            NSLog(@"Got response %@ with error %@.\n", response, error);
//
//        }]
//         resume];
//    }
//    [refresh endRefreshing];
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
