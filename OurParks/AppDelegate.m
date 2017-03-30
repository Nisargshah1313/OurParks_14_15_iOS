//
//  AppDelegate.m
//  OurParks
//
//  Created by Nisarg Shah on 30/07/15.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginVC.h"
#import "NJSWelcomeVC.h"
#import "RearViewController.h"

static bool isInternet;

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize pNav;
@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    
    [self showGUIPresence];
    
    // Check for first time app launching or not
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"isSecondTime"]) {
        
        
        NJSWelcomeVC *welcomeVC = [[NJSWelcomeVC alloc]init];
        
        self.window.rootViewController = welcomeVC;
        
    }
    else
    {
        // Check if the user is already loggedIn or not
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isloggedIn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isloggedIn"] == YES) {
            [self userLoggedIn];
        }
        else{
            LoginVC * loginVC = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
            
            pNav=[[UINavigationController alloc]initWithRootViewController:loginVC];
            
            self.window.rootViewController = pNav;
            
            [self.window makeKeyAndVisible];
        }
    }
    
    
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

-(void)showGUIPresence{
    
    // [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"top-bar"] forBarMetrics:UIBarMetricsDefault];//logo@2x.png//logo.png//top-bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:207.0/255.0 green:10.0/255.0 blue:37.0/255.0 alpha:1.0]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    //    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GothamRounded-Medium" size:16.0],NSFontAttributeName, nil];
    //
    //    [[UINavigationBar appearance] setTitleTextAttributes:size];
    //
    //    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:130.0/255.0 green:184.0/255.0 blue:66.0/255.0 alpha:1.0],NSForegroundColorAttributeName, nil];
    //
    //    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Oswald-Medium" size:16.0f],
                                                            
                                                            }];
    
    
}

-(void)removeWelcomeVCandShowRootVC
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isloggedIn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isloggedIn"] == YES) {
        [self userLoggedIn];
    }
    else{
        LoginVC * loginVC = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
        
        pNav=[[UINavigationController alloc]initWithRootViewController:loginVC];
        
        self.window.rootViewController = pNav;
        
        [self.window makeKeyAndVisible];
    }
    
    [self.window makeKeyAndVisible];
    
    [self showGUIPresence];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark --- User Is LoggedIn ---

- (void)userLoggedIn
{
    
    NSUserDefaults *defaultsEnabled = [NSUserDefaults standardUserDefaults];
    [defaultsEnabled setBool:YES forKey:@"isloggedIn"];
    [defaultsEnabled synchronize];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"isSecondTime"];
    [defaults synchronize];
    
    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"navbarImg.jpg"] forBarMetrics:UIBarMetricsDefault];
    
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    NSString *strRole = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ROLE]];
    
    
    if ([strRole isEqualToString:@"instructors"]) {
        
        // REAL :
        
        CoachHomeVC *frontViewController;
        frontViewController = [[CoachHomeVC alloc] initWithNibName:@"CoachHomeVC" bundle:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
        
        revealController.delegate = self;
        
        self.viewController = revealController;
        
        //        ViewController *frontViewController;
        //        frontViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        //
        //        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        //
        //        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
        //
        //        revealController.delegate = self;
        //
        //        self.viewController = revealController;
        
    }
    else
    {
        ViewController *frontViewController;
        frontViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        
        SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:navigationController];
        
        revealController.delegate = self;
        
        self.viewController = revealController;
    }
    
    // if (IS_IPHONE_5) {
    
    //        frontViewController = [[DisplayViewController alloc] initWithNibName:@"DisplayViewController" bundle:nil];
    //    }
    //    else{
    //    }
    
    
    
    
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    
}




#pragma mark --- Check For Internet Connectivity ---

-(BOOL)connecttonetwork
{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    if(remoteHostStatus == NotReachable)
    {
        isInternet =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        isInternet = TRUE;
        
    }
    
    return isInternet;
}

#pragma mark --- Show Alert View ---

-(void)showAlert:(NSString *)strMessage{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:strMessage delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    alertView = nil;
    
}

#pragma MARK --- Check for Valid Email Address ---

-(BOOL)checkForValidEmailId:(NSString *)strEmailIdText
{
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:strEmailIdText]) {
        aRange = [strEmailIdText rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [strEmailIdText length])];
        int indexOfDot = aRange.location;
        //NSLog(@"aRange.location:%d - %d",aRange.location, indexOfDot);
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [strEmailIdText substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            //NSLog(@"topleveldomains:%@",topLevelDomain);
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }
    [appDelOurParks showAlert:@"Please enter a valid email address."];
    
    return NO;
}

@end
