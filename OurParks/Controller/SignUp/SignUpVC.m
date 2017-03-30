//
//  SignUpVC.m
//  OurParks
//
//  Created by Nisarg Shah on 30/07/15.
//
//

#import "SignUpVC.h"

@interface SignUpVC ()

@end

@implementation SignUpVC
@synthesize webVw,strDirectWebVwUrl,strFromSignUpClick;
@synthesize strViewTitle;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // --------- Allocate and Initialization of Activity Indficator -----------
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];

    
    if (strDirectWebVwUrl.length > 0) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strDirectWebVwUrl]];
        NSLog(@"WEB URL request = %@",request);
        [webVw loadRequest:request];
    }
    
    NSLog(@"%@ strFromSignUpClick = ",strFromSignUpClick);
    if ([strFromSignUpClick isEqualToString:@"IsFromSignUpButton"]) {
         [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    else
    {
         [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    }
   

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
   
    [indicator stopAnimating];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [indicator stopAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
