//
//  LoginVC.h
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SignUpVC.h"

@interface LoginVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate>
{
    NSMutableDictionary *dicLoginSubmit;
    NSMutableArray *arr_ResponseData;
    UIActivityIndicatorView *indicator;
}

- (IBAction)action_login:(id)sender;
- (IBAction)action_signup:(id)sender;

-(BOOL)isValidInput;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (IBAction)btnForgotPassClicked:(id)sender;
@end
