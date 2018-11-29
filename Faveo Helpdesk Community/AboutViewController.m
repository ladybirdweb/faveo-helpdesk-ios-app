

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

//This method is called after the view controller has loaded its view hierarchy into memory. This method is called regardless of whether the view hierarchy was loaded from a nib file or created programmatically in the loadView method. You usually override this method to perform additional initialization on views that were loaded from nib files.
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
