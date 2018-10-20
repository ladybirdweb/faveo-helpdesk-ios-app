

#import "AboutViewController.h"
#import "HexColors.h"
#import "RKDropdownAlert.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _textview.editable = NO;
    [self setTitle:NSLocalizedString(@"About",nil)];
    _websiteButton.backgroundColor=[UIColor hx_colorWithHexRGBAString:@"#00aeef"];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnClicked:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"http://www.faveohelpdesk.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else {
        
    }
}
@end
