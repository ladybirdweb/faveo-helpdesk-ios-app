//
//  ConversationViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 16/09/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

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


@interface ConversationViewController ()<CNPPopupControllerDelegate,UIWebViewDelegate>{
    Utils *utils;
    NSUserDefaults *userDefaults;
    NSMutableArray *mutableArray;
    GlobalVariables *globalVariable;
}
@property(nonatomic,strong) UILabel *noDataLabel;
@property (nonatomic, strong) CNPPopupController *popupController;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ConversationVC");
    _activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorObject.center =CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height/2)-100);
    _activityIndicatorObject.color=[UIColor hx_colorWithHexString:@"#00aeef"];
    [self.view addSubview:_activityIndicatorObject];
    [self addUIRefresh];
    utils=[[Utils alloc]init];
    globalVariable=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    [_activityIndicatorObject startAnimating];
    [self reload];
    // Do any additional setup after loading the view.
}

-(void)reload{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        //connection unavailable
          [_activityIndicatorObject stopAnimating];
          [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
        
    }else{
       
          NSString *url=[NSString stringWithFormat:@"%@helpdesk/ticket-thread?api_key=%@&ip=%@&token=%@&id=%@",[userDefaults objectForKey:@"companyURL"],API_KEY,IP,[userDefaults objectForKey:@"token"],globalVariable.iD];
        
        MyWebservices *webservices=[MyWebservices sharedInstance];
        [webservices httpResponseGET:url parameter:@"" callbackHandler:^(NSError *error,id json,NSString* msg) {
            
            if (error || [msg containsString:@"Error"]) {
                 [self.refreshControl endRefreshing];
                  [_activityIndicatorObject stopAnimating];
                [[AppDelegate sharedAppdelegate] hideProgressView];
                [utils showAlertWithMessage:@"Error" sendViewController:self];
                NSLog(@"Thread-NO4-getConversation-Refresh-error == %@",error.localizedDescription);
                self.noDataLabel.text=@"Error";
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
                        
                        [self.refreshControl endRefreshing];
                        [_activityIndicatorObject stopAnimating];
                        [self.tableView reloadData];
                    });
                });
            }
            
            NSLog(@"Thread-NO5-getConversation-closed");
            
        }];
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
        self.noDataLabel.text             = @"Empty!";
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
    
      cell.timeStampLabel.text=[utils getLocalDateTimeFromUTC:[finaldic objectForKey:@"created_at"]];
    NSInteger i=[[finaldic objectForKey:@"is_internal"] intValue];
    if (i==0) {
        [cell.internalNoteLabel setHidden:YES];
    }
    if(i==1){
        [cell.internalNoteLabel setHidden:NO]; 
    }
   
     cell.clientNameLabel.text=[NSString stringWithFormat:@"%@ %@",[finaldic objectForKey:@"first_name"],[finaldic objectForKey:@"last_name"]];
     [cell setUserProfileimage:[finaldic objectForKey:@"profile_pic"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *finaldic=[mutableArray objectAtIndex:indexPath.row];
    [self showWebview:[finaldic objectForKey:@"title"] body:[finaldic objectForKey:@"body"] popupStyle:CNPPopupStyleActionSheet];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)webViewDidFinishLoad:(UIWebView *)theWebView
//{
//    CGSize contentSize = theWebView.scrollView.contentSize;
//    CGSize viewSize = theWebView.bounds.size;
//    
//    float rw = viewSize.width / contentSize.width;
//    
//    theWebView.scrollView.minimumZoomScale = rw;
//    theWebView.scrollView.maximumZoomScale = rw;
//    theWebView.scrollView.zoomScale = rw;
//    
//}

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
    
    NSAttributedString *refreshing = [[NSAttributedString alloc] initWithString:@"Refreshing" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle,NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor=[UIColor whiteColor];
    self.refreshControl.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
    self.refreshControl.attributedTitle =refreshing;
    [self.refreshControl addTarget:self action:@selector(reloadd) forControlEvents:UIControlEventValueChanged];
    
}

-(void)reloadd{
    [self reload];
   // [refreshControl endRefreshing];
}
@end
