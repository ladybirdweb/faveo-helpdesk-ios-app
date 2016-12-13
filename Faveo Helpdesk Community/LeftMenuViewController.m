//
//  LeftMenuViewController.m
//  SideMEnuDemo
//
//  Created by Narendra on 17/08/16.
//  Copyright © 2016 Ladybird websolutions pvt ltd. All rights reserved.
//

#import "LeftMenuViewController.h"


@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.slideOutAnimationEnabled = YES;
    
    return [super initWithCoder:aDecoder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
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
    
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"faveoData.plist"];
     NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:plistPath error:&error])
    {
        NSLog(@"Error while removing the plist %@", error.localizedDescription);
        //TODO: Handle/Log error
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // rows in section 0 should not be selectable
   // if ( indexPath.section == 0 ) return nil;
    
    // first 3 rows in any section should not be selectable
    if ( (indexPath.row ==0) || (indexPath.row==2) ) return nil;
    
    // By default, allow row to be selected
    return indexPath;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setUserInteractionEnabled:NO];
//    
//    if (indexPath.section == 1 && indexPath.row == 2)
//    {
//        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
//        [cell setUserInteractionEnabled:YES];
//    }
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
