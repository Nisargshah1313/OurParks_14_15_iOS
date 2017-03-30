//
//  AddParkerVC.m
//  OurParks
//
//  Created by Darshil Shah on 03/11/15.
//
//

#import "AddParkerVC.h"

@interface AddParkerVC ()

@end

@implementation AddParkerVC
@synthesize txtEmailAdd,dicPrevScreenDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"dicPrevScreenDetails = %@",dicPrevScreenDetails);
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

- (IBAction)btnAddParkerClicked:(id)sender {
    
    // USER WEB-SERVICE NO : 22
    
    // “ac”:”se”, “e”: “useremail”, “cid”:1 }
    
    if ([appDelOurParks connecttonetwork]) {
        if ([self isValidInput] == YES) {
            
            indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
            CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
            
            indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
            
            [self.view addSubview:indicator];
            [indicator bringSubviewToFront:self.view];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            [indicator startAnimating];
            
            dicAddParkerSubmit = [[NSMutableDictionary alloc]init];
            
            //{“ac”:”se”,*“e”:*“useremail”,*“cid”:1*}
            [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
            [dicAddParkerSubmit setObject:@"se" forKey:@"ac"];
            [dicAddParkerSubmit setObject:txtEmailAdd.text forKey:@"e"];
            [dicAddParkerSubmit setObject:[dicPrevScreenDetails objectForKey:@"id"] forKey:@"cid"];
            
            //                if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
            //                    [dicAddParkerSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
            //                }
            
            [WebServiceHelperVC wsVC].methodType = @"POST";
            [self performSelector:@selector(callWebServiceForAddParker) withObject:nil afterDelay:0.1];
        }
        
    }
    else
    {
        [appDelOurParks showAlert:@"No Network Connection available"];
    }
}

-(void)callWebServiceForAddParker
{
    NSMutableDictionary *dictResults = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicAddParkerSubmit];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResults objectForKey:@"ok"]integerValue] == 1) {
        
       
            [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResults objectForKey:@"msg"]]];
    
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResults objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    //    NSInteger nextTag = textField.tag + 1;
    //    // Try to find next responder
    //    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    //
    //    if (nextResponder) {
    //        // Found next responder, so set it.
    //        [nextResponder becomeFirstResponder];
    //    } else {
    //        // Not found, so remove keyboard.
    //        [textField resignFirstResponder];
    //    }
    [txtEmailAdd resignFirstResponder];
    return YES; // We do not want UITextField to insert line-breaks.
}

#pragma mark - Click Events and methods

-(BOOL)isValidInput{
    
    if (txtEmailAdd.text.length == 0) {
        return NO;
    }
    
    else if ([appDelOurParks checkForValidEmailId:txtEmailAdd.text] == NO) {
        return NO;
    }
    
    return YES;
}

@end
