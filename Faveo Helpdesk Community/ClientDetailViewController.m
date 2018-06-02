//
//  ClientDetailViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 08/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "ClientDetailViewController.h"
#import "HexColors.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "TicketDetailViewController.h"
#import "OpenCloseTableViewCell.h"
#import "GlobalVariables.h"
#import "FTProgressIndicator.h"


@interface ClientDetailViewController ()
{
    Utils *utils;
    NSUserDefaults *userDefaults;
    NSMutableArray *mutableArray;
    UIRefreshControl *refresh;
    GlobalVariables *globalVariables;
    
    NSMutableDictionary * clientDict;

}

@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorObject;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic,strong) UILabel *noDataLabel;

@end

@implementation ClientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageView.layer.cornerRadius =25;
    self.profileImageView.clipsToBounds = YES;
    

    
    [self addUIRefresh];
    
    utils=[[Utils alloc]init];
    globalVariables=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];

    clientDict=[[NSMutableDictionary alloc]init];
    
    self.testingLAbel.text=globalVariables.userStateFromUserList;
    self.emailLabel.text=globalVariables.emailFromUserList;
    self.clientNameLabel.text=globalVariables.firstNameFromUserList;
    self.phoneLabel.text=globalVariables.mobileFromUserList;
    
    [self setUserProfileimage:globalVariables.profilePicFromUserList];

    [FTProgressIndicator showProgressWithMessage:@"Please wait" userInteractionEnable:NO];
    
    [self reload];
    // Do any additional setup after loading the view.
}

-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
        //[_activityIndicatorObject stopAnimating];
        [FTProgressIndicator dismiss];
        [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/my-tickets-user?api_key=%@&ip=%@&token=%@&user_id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariables.userIdFromUserList];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            if (error || [msg containsString:@"Error"]) { [refresh endRefreshing];
                
                [FTProgressIndicator dismiss];
                [utils showAlertWithMessage:@"Error" sendViewController:self];
                NSLog(@"Thread-NO4-getClientTickets-Refresh-error == %@",error.localizedDescription);
                return ;
            }
            
            if ([msg isEqualToString:@"tokenRefreshed"]) {
                
                [self reload];
                NSLog(@"Thread--NO4-call-getClientTickets");
                return;
            }
            
            if (json) {
               // NSError *error;
                mutableArray=[[NSMutableArray alloc]initWithCapacity:10];
                NSLog(@"Thread-NO4--getClientTickets--%@",json);
                clientDict = [json copy];
                mutableArray = [clientDict objectForKey:@"tickets"];
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [self.tableView reloadData];
                        [refresh endRefreshing];
                        
                        [FTProgressIndicator dismiss];
                        
                    });
                });
            }
            
            [FTProgressIndicator dismiss];
            NSLog(@"Thread-NO5-getClientTickets-closed");
            
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([mutableArray count]==0)
    {
        self.noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        self.noDataLabel.text             = @"";
        self.noDataLabel.textColor        = [UIColor blackColor];
        self.noDataLabel.textAlignment    = NSTextAlignmentCenter;
        tableView.backgroundView = self.noDataLabel;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [mutableArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OpenCloseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"OpenCloseTableViewID"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OpenCloseTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    
    
    NSDictionary *ticketDict=[mutableArray objectAtIndex:indexPath.row];

    NSLog(@"Dict 111 is : %@",ticketDict);
    
    cell.ticketNumberLbl.text=[ticketDict objectForKey:@"ticket_number"];
    cell.ticketSubLbl.text=[ticketDict objectForKey:@"title"];

    if ([[ticketDict objectForKey:@"ticket_status_name"] isEqualToString:@"Open"]) {
        cell.indicationView.layer.backgroundColor=[[UIColor greenColor] CGColor];
    }else{
        cell.indicationView.layer.backgroundColor=[[UIColor redColor] CGColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSDictionary *ticketDict=[mutableArray objectAtIndex:indexPath.row];
    
    NSLog(@"Dict 111 is : %@",ticketDict);
    
    globalVariables.iD= [ticketDict objectForKey:@"id"];
    globalVariables.ticket_number=[ticketDict objectForKey:@"ticket_number"];
    globalVariables.title=[ticketDict objectForKey:@"title"];
    
    
    TicketDetailViewController *td=[self.storyboard instantiateViewControllerWithIdentifier:@"TicketDetailVCID"];
    
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
    //[refresh endRefreshing];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: Calculate cell height
    return 65.0f;
}

-(void)setUserProfileimage:(NSString*)imageUrl
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.profileImageView.image = image;
            });
        }
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
