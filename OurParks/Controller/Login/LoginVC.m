//
//  LoginVC.m
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC
@synthesize txtEmail,txtPassword;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:207.0/255.0 green:10.0/255.0 blue:37.0/255.0 alpha:1.0]];
    
    //    [self.txtEmail setValue:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    //
    //    [self.txtPassword setValue:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

    self.title = @"LOGIN";
    //self.navigationController.navigationBar.hidden = YES;
}


-(void)callWebServiceForLogin
{
    
    NSMutableDictionary *dictResultLogin = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicLoginSubmit];
    
    if (arr_ResponseData.count>0) {
        [arr_ResponseData removeAllObjects];
        arr_ResponseData=[[NSMutableArray alloc]init];
    }
    
    //device_type=android/ios&device_token
    
    if ([[dictResultLogin objectForKey:@"ok"]integerValue] == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[dictResultLogin objectForKey:@"uid"] forKey:USER_ID];
        
        [[NSUserDefaults standardUserDefaults] setObject:[dictResultLogin objectForKey:@"name"] forKey:USER_NAME];
        
        if ([dictResultLogin objectForKey:@"role"] != nil && [dictResultLogin objectForKey:@"role"] != NULL && ![[dictResultLogin objectForKey:@"role"] isEqual:[NSNull null]]) {
            [[NSUserDefaults standardUserDefaults] setObject:[dictResultLogin objectForKey:@"role"] forKey:USER_ROLE];
        }
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[dictResultLogin objectForKey:@"picture"] forKey:USER_PIC];
        
        [[NSUserDefaults standardUserDefaults] setObject:[dictResultLogin objectForKey:@"point"] forKey:USER_POINTS];

        
        [[NSUserDefaults standardUserDefaults] setObject:[dictResultLogin objectForKey:@"qrcodeimage"] forKey:USER_QRIMAGE];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self navigateUserToHomeScreen];
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultLogin objectForKey:@"msg"]]];
    }
    
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

- (IBAction)action_login:(id)sender {
    
    if ([appDelOurParks connecttonetwork]) {
        //[[NSUserDefaults standardUserDefaults]setObject:tokenString forKey:@"DeviceTokenFinal"];
        // [[NSUserDefaults standardUserDefaults]synchronize];
        
        //        NSString *strDeviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"DeviceTokenFinal"];
        
        if ([self isValidInput] == YES) {
            
            
            arr_ResponseData = [[NSMutableArray alloc]init];
            // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
            dicLoginSubmit = [[NSMutableDictionary alloc]init];
            [dicLoginSubmit setObject:methodLogin forKey:@"ac"];
            [dicLoginSubmit setObject:txtEmail.text forKey:@"un"];
            [dicLoginSubmit setObject:txtPassword.text forKey:@"pw"];
            
            //        if (strDeviceToken.length>0) {
            //            [dicLoginSubmit setObject:strDeviceToken forKey:@"device_token"];
            //        }
            [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
            [WebServiceHelperVC wsVC].methodType = @"POST";
            
            indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
            CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
            
            indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
            
            [self.view addSubview:indicator];
            [indicator bringSubviewToFront:self.view];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            [indicator startAnimating];
            
            
            [self performSelector:@selector(callWebServiceForLogin) withObject:nil afterDelay:0.1];
        }
        else
        {
            [appDelOurParks showAlert:@"User Name or Password can not be empty. Please enter your login details."];
        }
    }
    
    else
    {
        [appDelOurParks showAlert:@"No Network Connection available"];
    }
    
    
}

- (IBAction)action_signup:(id)sender {
    
    SignUpVC *svc = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
    NSString *strSignupUrl = @"http://www.ourparks.org.uk/user/register";
    svc.strFromSignUpClick = @"IsFromSignUpButton";
    
    //http://www.ourparks.org.uk/user/register
    svc.strDirectWebVwUrl = strSignupUrl;
     self.title = @"";
    [self.navigationController pushViewController:svc animated:YES];
    
}


-(void)navigateUserToHomeScreen
{
    //    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelOurParks userLoggedIn];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
    
    
//    NSInteger nextTag = textField.tag + 1;
//    // Try to find next responder
//    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//    
//    if (nextResponder) {
//        // Found next responder, so set it.
//        [nextResponder becomeFirstResponder];
//        return NO;
//    } else {
//        // Not found, so remove keyboard.
//        [textField resignFirstResponder];
//    }
//    
//    return YES;
}

#pragma mark - Click Events and methods

-(BOOL)isValidInput{
    
    if (txtEmail.text.length == 0 || txtPassword.text.length == 0) {
        return NO;
    }
    
//    else if ([appDelOurParks checkForValidEmailId:txtEmail.text] == NO) {
//        return NO;
//    }
    
    
    return YES;
}

- (IBAction)btnForgotPassClicked:(id)sender {
    
    
}

@end
