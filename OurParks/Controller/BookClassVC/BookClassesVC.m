//
//  BookClassesVC.m
//  OurParks
//
//  Created by Darshil Shah on 07/08/15.
//
//

#import "BookClassesVC.h"
#import "ClassListAllVC.h"

@interface BookClassesVC ()

@end
@implementation BookClassesVC
@synthesize txtSearchbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)btnSearchClassesClicked:(id)sender {
    
    [txtSearchbox resignFirstResponder];
    
    if (txtSearchbox.text.length > 0) {
        
        // ac : search
        
        
        if ([appDelOurParks connecttonetwork]) {
            
            indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
            CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
            
            indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
            
            [self.view addSubview:indicator];
            [indicator bringSubviewToFront:self.view];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
            [indicator startAnimating];
            
            dicBookClassSubmit = [[NSMutableDictionary alloc]init];
            
            [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
            [dicBookClassSubmit setObject:@"search" forKey:@"ac"];
            [dicBookClassSubmit setObject:txtSearchbox.text forKey:@"keyword"];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
                [dicBookClassSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
            }
            
            [WebServiceHelperVC wsVC].methodType = @"POST";
            [self performSelector:@selector(callWebServiceForSearchClassList) withObject:nil afterDelay:0.1];
        }
        else
        {
            [appDelOurParks showAlert:@"No Network Connection available"];
        }
        
        
    }
    
    else
    {
        [appDelOurParks showAlert:@"Please enter Borough Name and then click on search button."];
    }
}

-(void)callWebServiceForSearchClassList
{
    NSMutableDictionary *dictResultSearchList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicBookClassSubmit];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResultSearchList objectForKey:@"ok"]integerValue] == 1) {
        
        if ([dictResultSearchList objectForKey:@"classes"]!= nil && [dictResultSearchList objectForKey:@"classes"] != NULL) {
            
            ClassListAllVC *clavc = [[ClassListAllVC alloc]initWithNibName:@"ClassListAllVC" bundle:nil];
            clavc.dicAllDetails = dictResultSearchList;
            [self.navigationController pushViewController:clavc animated:YES];
            
        }
        else
        {
            [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultSearchList objectForKey:@"msg"]]];
        }
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultSearchList objectForKey:@"msg"]]];
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
    [txtSearchbox resignFirstResponder];
    return YES; // We do not want UITextField to insert line-breaks.
}

@end
