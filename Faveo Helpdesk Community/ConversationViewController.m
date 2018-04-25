//
//  ConversationViewController.m


#import "ConversationViewController.h"
#import "ConversationTableViewCell.h"
#import "CNPPopupController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "Reachability.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "HexColors.h"
#import "GlobalVariables.h"
#import "RKDropdownAlert.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "UIImageView+Letters.h"


@interface ConversationViewController ()<CNPPopupControllerDelegate,UIWebViewDelegate,RMessageProtocol>{
    
    Utils *utils;
    NSUserDefaults *userDefaults;
    NSMutableArray *mutableArray;
    GlobalVariables *globalVariable;
    int selectedIndex;
    NSMutableArray *attachmentArray;
    
    NSString *fName;
    NSString *lName;
    NSString *userName;

}
@property(nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    selectedIndex = -1;
    
    _activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorObject.center =CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height/2)-100);
    _activityIndicatorObject.color=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    
    //[self.view addSubview:_activityIndicatorObject];
    [self addUIRefresh];
    utils=[[Utils alloc]init];
    globalVariable=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    
    
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadd) name:@"reload_data" object:nil];
    
 
        [self reload];
        [[AppDelegate sharedAppdelegate] showProgressViewWithText:NSLocalizedString(@"Getting Conversations",nil)];
    
    
}

-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self.refreshControl endRefreshing];
        //[_activityIndicatorObject stopAnimating];
        [[AppDelegate sharedAppdelegate] hideProgressView];

        
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
        
        NSString *url=[NSString stringWithFormat:@"%@helpdesk/ticket-thread?api_key=%@&ip=%@&token=%@&id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariable.iD];
        
        @try{
            MyWebservices *webservices=[MyWebservices sharedInstance];
            [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
                
                if (error || [msg containsString:@"Error"]) {
                    [self.refreshControl endRefreshing];
                    //[_activityIndicatorObject stopAnimating];
                    [[AppDelegate sharedAppdelegate] hideProgressView];
                    if (msg) {
                        
                        if([msg isEqualToString:@"Error-401"])
                        {
                            NSLog(@"Message is : %@",msg);
                            [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Access Denied.  Your credentials has been changed. Contact to Admin and try to login again."] sendViewController:self];
                        }
                        else
                            
                            if([msg isEqualToString:@"Error-402"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"API is disabled in web, please enable it from Admin panel."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-422"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Unprocessable Entity. Please try again later."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-404"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The requested URL was not found on this server."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-405"] ||[msg isEqualToString:@"405"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The requested URL was not found on this server."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-500"] ||[msg isEqualToString:@"500"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Internal Server Error.Something has gone wrong on the website's server."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-400"] ||[msg isEqualToString:@"400"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:[NSString stringWithFormat:@"The request could not be understood by the server due to malformed syntax."] sendViewController:self];
                            }
                            else if([msg isEqualToString:@"Error-403"] || [msg isEqualToString:@"403"])
                            {
                                NSLog(@"Message is : %@",msg);
                                [self->utils showAlertWithMessage:@"Access Denied. Either your credentials has been changed or You are not an Agent/Admin." sendViewController:self];
                            }
                            else{
                                
                                [self->utils showAlertWithMessage:msg sendViewController:self];
                            }
                        
                        
                    }else if(error)  {
                        [self->utils showAlertWithMessage:[NSString stringWithFormat:@"Error-%@",error.localizedDescription] sendViewController:self];
                        NSLog(@"Thread-NO4-getInbox-Refresh-error == %@",error.localizedDescription);
                    }
                    
                    return ;
                }
                
                if ([msg isEqualToString:@"tokenRefreshed"]) {
                    
                    [self reload];
                    NSLog(@"Thread--NO4-call-getConversation");
                    return;
                }
                
                
                if (json) {
                    
                    
                    //NSError *error;
                    mutableArray=[[NSMutableArray alloc]initWithCapacity:10];
                    NSLog(@"Thread-NO4--getConversationAPI--%@",json);
                    mutableArray=[json copy];
                    NSLog(@"Thread-NO4.1getConversation-dic--%@", mutableArray);
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                            [self.refreshControl endRefreshing];
                            [[AppDelegate sharedAppdelegate] hideProgressView];
                            //[_activityIndicatorObject stopAnimating];
                            
                        });
                    });
                }

                [[AppDelegate sharedAppdelegate] hideProgressView];
                NSLog(@"Thread-NO5-getConversation-closed");
                
            }];
        }@catch (NSException *exception)
        {
            [utils showAlertWithMessage:exception.name sendViewController:self];
            NSLog( @"Name: %@", exception.name);
            NSLog( @"Reason: %@", exception.reason );
            return;
        }
        @finally
        {
            NSLog( @" I am in reload method in Conversation ViewController" );
            
        }
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    
    if ([mutableArray count]==0)
    {
        self.noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
        //self.noDataLabel.text             = NSLocalizedString(@"Empty!!!",nil);
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
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [mutableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConversationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ConvTableViewCell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConversationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    NSLog(@"Ticket Thread Dict is : %@",finaldic);

    //create at label
    cell.timeStampLabel.text=[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_at"]];
    
    //internal note label
    NSInteger i=[[finaldic objectForKey:@"is_internal"] intValue];
    if (i==0) {
        [cell.internalNoteLabel setHidden:YES];
    }
    if(i==1){
        [cell.internalNoteLabel setHidden:NO];
    }
    

    
    
    
    //         NSURL *url = [NSURL URLWithString:@"http://www.amazon.com"];
    //        [cell.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    // NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    //    [self showWebview:@"" body:[finaldic objectForKey:@"body"] popupStyle:CNPPopupStyleActionSheet];/
    
    
    NSString *body= [finaldic objectForKey:@"body"];  //@"Mallikarjun";
    NSRange range = [body rangeOfString:@"<body"];
    
    if(range.location != NSNotFound) {
        // Adjust style for mobile
        float inset = 40;
        NSString *style = [NSString stringWithFormat:@"<style>div {max-width: %fpx;}</style>", self.view.bounds.size.width - inset];
        body = [NSString stringWithFormat:@"%@%@%@", [body substringToIndex:range.location], style, [body substringFromIndex:range.location]];
    }
    cell.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [cell.webView loadHTMLString:body baseURL:nil];
    
    
    
    //NSString *system= @"System";
    NSString *fName=[finaldic objectForKey:@"first_name"];
    NSString *lName=[finaldic objectForKey:@"last_name"];
    
    NSString *userName=[finaldic objectForKey:@"user_name"];
    
    [Utils isEmpty:fName];
    [Utils isEmpty:lName];
    [Utils isEmpty:userName];
    
    
    
    if  ([Utils isEmpty:fName] && [Utils isEmpty:lName]){
        if(![Utils isEmpty:userName]){
            userName=[NSString stringWithFormat:@"%@",[finaldic objectForKey:@"user_name"]];
            cell.clientNameLabel.text=userName;
        }else cell.clientNameLabel.text=@"System";
    }
    else if ((![Utils isEmpty:fName] || ![Utils isEmpty:lName]) || (![Utils isEmpty:fName] && ![Utils isEmpty:lName]))
    {
        fName=[NSString stringWithFormat:@"%@ %@",fName,lName];
        
        cell.clientNameLabel.text=fName;
        
    }

    
    
    if([[finaldic objectForKey:@"profile_pic"] hasSuffix:@"system.png"] || [[finaldic objectForKey:@"profile_pic"] hasSuffix:@".jpg"] || [[finaldic objectForKey:@"profile_pic"] hasSuffix:@".jpeg"] || [[finaldic objectForKey:@"profile_pic"] hasSuffix:@".png"] )
    {
        [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
    }
    else if(![Utils isEmpty:[finaldic objectForKey:@"first_name"]])
    {
        [cell.profilePicView setImageWithString:[finaldic objectForKey:@"first_name"] color:nil ];
    }
    else if(![Utils isEmpty:userName])
    {
        [cell.profilePicView setImageWithString:[finaldic objectForKey:@"user_name"] color:nil ];
        
    }
    else
    {
        cell.clientNameLabel.text=@"System";
        [cell.profilePicView setImageWithString:@"System" color:nil ];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(selectedIndex == indexPath.row)
    {
        // return  200;
        
        UITableViewCell   *cell = [self tableView: tableView cellForRowAtIndexPath: indexPath];
        return cell.bounds.size.height;
    }
    else
    {
        return  90;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    //    [self showWebview:@"" body:[finaldic objectForKey:@"body"] popupStyle:CNPPopupStyleActionSheet];
    
    
    //user taps expnmade view
    
    if(selectedIndex == indexPath.row)
    {
        
        selectedIndex =-1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade ];
        return;
    }
    
    //user taps diff row
    if(selectedIndex != -1)
    {
        
        NSIndexPath *prevPath= [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex=(int)indexPath.row;
        
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:prevPath, nil]  withRowAnimation:UITableViewRowAnimationFade ];
    }
    
    
    //uiser taps new row with none expanded
    selectedIndex =(int)indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationFade ];
    
}



-(void)showWebview:(NSString*)tittle body:(NSString*)body popupStyle:(CNPPopupStyle)popupStyle{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:tittle attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14], NSParagraphStyleAttributeName : paragraphStyle}];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    //    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    //    customView.backgroundColor = [UIColor hx_colorWithHexString:@"#00aeef"];
    //     [customView addSubview:titleLabel];
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height/2)];
    // webview.scalesPageToFit = YES;
    webview.autoresizesSubviews = YES;
    //webview.delegate=self;
    webview.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSRange range = [body rangeOfString:@"<body"];
    
    if(range.location != NSNotFound) {
        // Adjust style for mobile
        float inset = 40;
        NSString *style = [NSString stringWithFormat:@"<style>div {max-width: %fpx;}</style>", self.view.bounds.size.width - inset];
        body = [NSString stringWithFormat:@"%@%@%@", [body substringToIndex:range.location], style, [body substringFromIndex:range.location]];
    }
    [webview loadHTMLString:body baseURL:nil];
    
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[titleLabel,webview]];
    self.popupController.theme = [CNPPopupTheme defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}


-(void)addUIRefresh{
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Refreshing",nil) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor=[UIColor whiteColor];
    //  self.refreshControl.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    self.refreshControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#BDBDBD"];
    
    self.refreshControl.attributedTitle =refreshing;
    [self.refreshControl addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    
}

-(void)reloadd{
    [self reload];
    // [refreshControl endRefreshing];
}



@end
