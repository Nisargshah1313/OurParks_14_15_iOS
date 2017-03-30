//
//  AppDelegate.h
//  OurParks
//
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "CoachHomeVC.h"
#import "SWRevealViewController.h"

@class ViewController;
@class CoachHomeVC;
@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate,SWRevealViewControllerDelegate>
{
    UINavigationController* pNav;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *pNav;

@property (strong, nonatomic) SWRevealViewController *viewController;


- (void)userLoggedIn; // Publically declared method , Will be called once user is loggedin.

-(void)removeWelcomeVCandShowRootVC; // Publically declared method , To Remove Welcome Screens from the display and show perticular view.

-(void)showAlert:(NSString *)strMessage; // Publically declared method , Will be called to Show Alert View.

-(BOOL)connecttonetwork; // Publically declared method , Will be called to check the internet connectivity.

-(BOOL)checkForValidEmailId:(NSString *)strEmailIdText;
@end

