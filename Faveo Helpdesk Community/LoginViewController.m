//
//  LoginViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 18/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "InboxViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "AppConstanst.h"
#import "MyWebservices.h"
#import "Utils.h"
#import "HexColors.h"

@interface LoginViewController (){
    Utils *utils;
    NSUserDefaults *userdefaults;
    NSString *errorMsg;
}

@property (nonatomic, strong) MBProgressHUD *progressView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginButton.backgroundColor=[UIColor hx_colorWithHexString:@"#00aeef"];
    utils=[[Utils alloc]init];
    userdefaults=[NSUserDefaults standardUserDefaults];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    
    [utils viewSlideInFromRightToLeft:self.companyURLview];
    
    [self.loginView setHidden:YES];
    [self.companyURLview setHidden:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)urlButton:(id)sender {
    [self.urlTextfield resignFirstResponder];
    if (self.urlTextfield.text.length==0)
        [utils showAlertWithMessage:@"Please Enter the URL" sendViewController:self];
    else{
        if ([Utils validateUrl:self.urlTextfield.text]) {
            
                        NSString *baseURL=[[NSString alloc] init];
            
                        if ([self.urlTextfield.text hasSuffix:@"/"]) {
                            baseURL=self.urlTextfield.text;
                        }else{
                            baseURL=[self.urlTextfield.text stringByAppendingString:@"/"];
                        }
            
                        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
                        {
                            //connection unavailable
                            [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
            
                        }else{
                             //connection available
            
                        [[AppDelegate sharedAppdelegate] showProgressViewWithText:@"Verifying URL"];
            
                        NSString *url=[NSString stringWithFormat:@"%@api/v1/helpdesk/url?url=%@&api_key=%@",baseURL,[baseURL substringToIndex:[baseURL length]-1],API_KEY];
            
                         NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
                        [request setURL:[NSURL URLWithString:url]];  // add your url
                        [request setHTTPMethod:@"GET"];  // specify the JSON type to GET
            
                        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
                        // intialiaze NSURLSession
            
                        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            // Add your parameters in blocks
            
                            // handle basic connectivity issues here
            
                            if ([[error domain] isEqualToString:NSURLErrorDomain]) {
                                switch ([error code]) {
                                    case NSURLErrorCannotFindHost:
                                        errorMsg = NSLocalizedString(@"Cannot find specified host. Retype URL.", nil);
                                        break;
                                    case NSURLErrorCannotConnectToHost:
                                        errorMsg = NSLocalizedString(@"Cannot connect to specified host. Server may be down.", nil);
                                        break;
                                    case NSURLErrorNotConnectedToInternet:
                                        errorMsg = NSLocalizedString(@"Cannot connect to the internet. Service may not be available.", nil);
                                        break;
                                    default:
                                        errorMsg = [error localizedDescription];
                                        break;
                                }
                                NSLog(@"dataTaskWithRequest error: %@", errorMsg);
                                return;
                            }else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            
                                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            
                                if (statusCode != 200) {
                                    if (statusCode == 404) {
                                        NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                        [[AppDelegate sharedAppdelegate] hideProgressView];
                                        [utils showAlertWithMessage:@"Invalid URL!" sendViewController:self];
                                        return;
                                    }else{
                                        NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                                        [[AppDelegate sharedAppdelegate] hideProgressView];
                                        [utils showAlertWithMessage:@"Unknown Error!" sendViewController:self];
                                        return;
                                    }
                                }
                            }
            
            
                            NSString *replyStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
                                NSLog(@"Get your response == %@", replyStr);
            
                                if ([replyStr containsString:@"success"]) {
                                    NSLog(@"Success");
            
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[AppDelegate sharedAppdelegate] hideProgressView];
                                        [self.companyURLview setHidden:YES];
                                        [self.loginView setHidden:NO];
                                        [utils viewSlideInFromRightToLeft:self.loginView];
            
                                    });
            
                                   // NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
                                    [userdefaults setObject:[baseURL stringByAppendingString:@"api/v1/"] forKey:@"companyURL"];
                                    [userdefaults synchronize];
            
                                }else{
            
                                    [[AppDelegate sharedAppdelegate] hideProgressView];
                                    [utils showAlertWithMessage:@"Error verifying URL" sendViewController:self];
            
                                }

                            NSLog(@"Got response %@ with error %@.\n", response, error);
            
                        }]resume];
             }
            
        }else
            [utils showAlertWithMessage:@"Please Enter a valid URL" sendViewController:self];
        
    }
    
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)btnLogin:(id)sender {
    
    if (self.userNameTextField.text.length==0)
        [utils showAlertWithMessage:@"Please Enter Username" sendViewController:self];
    else if(self.passcodeTextField.text.length==0)
        [utils showAlertWithMessage:@"Please Enter Password" sendViewController:self];
    else
    {
        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
        {
            //connection unavailable
            [utils showAlertWithMessage:NO_INTERNET sendViewController:self];
            
        }else{
            
            [[AppDelegate sharedAppdelegate] showProgressView];
            
            NSString *url=[NSString stringWithFormat:@"%@authenticate",[[NSUserDefaults standardUserDefaults] objectForKey:@"companyURL"]];
           // NSString *params=[NSString string];
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.userNameTextField.text,@"username",self.passcodeTextField.text,@"password",API_KEY,@"api_key",IP,@"ip",nil];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:url]];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setTimeoutInterval:60];
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:0 error:nil]];
            [request setHTTPMethod:@"POST"];
            
             NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
            
            [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (error) {
                    NSLog(@"dataTaskWithRequest error: %@", error);
                    return;
                }else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                    
                    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                    
                    if (statusCode != 200) {
                        if (statusCode == 401) {
                            NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                            [[AppDelegate sharedAppdelegate] hideProgressView];
                            [utils showAlertWithMessage:@"Wrong Credentials!" sendViewController:self];
                            return;
                        }else{
                            NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                            [[AppDelegate sharedAppdelegate] hideProgressView];
                            [utils showAlertWithMessage:@"Unknown Error!" sendViewController:self];
                            return;
                        }
                    }
                    
                }
                
                NSString *replyStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"Get your response == %@", replyStr);
                
                if ([replyStr containsString:@"token"]) {
                    
                    @try{
                        
                    NSDictionary *jsonData=[NSJSONSerialization JSONObjectWithData:data options:nil error:&error];
                  
                    [userdefaults setObject:[jsonData objectForKey:@"token"] forKey:@"token"];
                    [userdefaults setObject:[jsonData objectForKey:@"user_id"] forKey:@"user_id"];
                    [userdefaults setObject:self.userNameTextField.text forKey:@"username"];
                    [userdefaults setObject:self.passcodeTextField.text forKey:@"password"];
                    [userdefaults setBool:YES forKey:@"loginSuccess"];
                    [userdefaults synchronize];

                    NSLog(@"token--%@",[jsonData objectForKey:@"token"]);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[AppDelegate sharedAppdelegate] hideProgressView];
                            
                            InboxViewController *inboxVC=[self.storyboard instantiateViewControllerWithIdentifier:@"InboxID"];
                            [self.navigationController pushViewController:inboxVC animated:YES];
                            //[self.navigationController popViewControllerAnimated:YES];
                            [[self navigationController] setNavigationBarHidden:NO];
                        });
                    }
                    @catch(NSException *ne) {
                        NSLog(@"exception %@",ne);
                    }
                   
                }else {
                     [[AppDelegate sharedAppdelegate] hideProgressView];
                    
                    if ([replyStr containsString:@"invalid_credentials"]) {
                       
                        [utils showAlertWithMessage:@"Wrong Credentials" sendViewController:self];
                    }else{
                       
                        [utils showAlertWithMessage:@"Error" sendViewController:self];
                    }
                }
               
                //yuoyu
                
             NSLog(@"Got response %@ with error %@.\n", response, error);
            }] resume];
            
        }
        
        
    }
    
    
    
    
    //  [self dismissViewControllerAnimated:NO completion:Nil];
    
    //[self.navigationController popViewControllerAnimated:YES];
   // [[self navigationController] setNavigationBarHidden:NO];
    
}


//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//     [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
