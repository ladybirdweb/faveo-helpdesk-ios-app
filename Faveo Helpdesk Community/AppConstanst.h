//
//  AppConstanst.h
//  SideMEnuDemo


#ifndef AppConstanst_h
#define AppConstanst_h

#define APP_NAME    @"Faveo Helpdesk"
#define ALERT_COLOR    @"#FFCC00"
#define SUCCESS_COLOR    @"#4CD964"
#define FAILURE_COLOR    @"#d50000"
#define URL @"http://jamboreebliss.com/sarfraz/public/api/v1/helpdesk/url"
#define DEMO_URL @"http://www.faveohelpdesk.com/api/v1/"
#define API_KEY @"9p41T2XFZ34YRZJUNQAdmM7iV0Rr1CjN"
#define NO_INTERNET @"There is no Internet Connection"
#define IP @""
#define APP_VERSION @"1.0"

#define BILLING_API @"https://www.faveohelpdesk.com/billing/public/api/check-url"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)



#endif /* AppConstanst_h */
