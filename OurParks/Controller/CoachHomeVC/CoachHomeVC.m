//
//  CoachHomeVC.m
//  OurParks
//
//  Created by Nisarg Shah on 31/07/15.
//
//

#import "CoachHomeVC.h"
#import "ClassDetailsVC.h"
#import "AddParkerVC.h"
#import "CoachStudentListVC.h"
#import "LoginVC.h"

@interface CoachHomeVC ()

@end

@implementation CoachHomeVC
@synthesize tblCoachClassesList,customTblViewCell;
@synthesize profileImgVw;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LOGOUT.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(btnLogoutClicked:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    arrCoachHomeClassList = [[NSMutableArray alloc]init];
    
    UIImage *mask =nil;
    
    UIImage *image = [UIImage imageNamed:@"personIcon.jpg"];
    
    profileImgVw.image = image;
    
    image = [self imageWithImage:image scaledToSize:CGSizeMake(80, 80)];
    mask = [UIImage imageNamed:@"Round.png"];
    UIImage *maskedImage = [self maskImage:image withMask:mask imgview:profileImgVw];
    profileImgVw.image=maskedImage;
    profileImgVw.layer.masksToBounds = YES;
    
    UILabel *lblName = (UILabel *)[self.view viewWithTag:121];
    NSString *strName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_NAME]];
    lblName.text = strName;
    
    [self performSelector:@selector(downloadManagerImage) withObject:nil afterDelay:0.1];
    
    //customCoachHomeCellIdentifier
    if ([appDelOurParks connecttonetwork]) {
        
        
        arr_ResponseData = [[NSMutableArray alloc]init];
        // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
        dicCoachHomeSubmit = [[NSMutableDictionary alloc]init];
        dicClassDetailSubmit = [[NSMutableDictionary alloc]init];
        
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
            [dicCoachHomeSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
        }
        
        //        NSString *strRole = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ROLE]];
        //
        //
        //        if ([strRole isEqualToString:@"instructors"]) {
        
        [dicCoachHomeSubmit setObject:@"ih" forKey:@"ac"];
        
        //   }
        //        else
        //        {
        //            [dicBookedClassSubmit setObject:@"sf" forKey:@"ac"];
        //        }
        
        [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
        [WebServiceHelperVC wsVC].methodType = @"POST";
        [self performSelector:@selector(callWebserviceForCoachHomeResult) withObject:nil afterDelay:0.1];
        
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
        CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
        
        indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
        
        [self.view addSubview:indicator];
        [indicator bringSubviewToFront:self.view];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
        [indicator startAnimating];
    }
    else
    {
        [appDelOurParks showAlert:@"No Network Connection available"];
    }
    
    
}
-(void)downloadManagerImage
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_PIC]) {
        
        UIImage *mask =nil;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_PIC]]];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        //        [profileImgVw setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:PHOTO]] placeholderImage:Nil];
        
        img = [self imageWithImage:img scaledToSize:CGSizeMake(80, 80)];
        
        
        mask = [UIImage imageNamed:@"Round.png"];
        
        UIImage *maskedImage = [self maskImage:img withMask:mask imgview:profileImgVw];
        
        profileImgVw.image=maskedImage;
        profileImgVw.layer.masksToBounds = YES;
        
        
        //manager_image
    }
    
    // [indicator stopAnimating];
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *) maskImage:(UIImage *)image withMask:(UIImage *)maskImage imgview:(UIImageView *)imgView
{
    
    // UIImageView *imgView = (UIImageView *)[self.view viewWithTag:20];
    imgView.image = image;
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[maskImage CGImage];
    mask.frame = CGRectMake(0, 0, imgView.image.size.width, imgView.image.size.height);
    imgView.layer.mask = mask;
    imgView.layer.masksToBounds = YES;
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask11 = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                          CGImageGetHeight(maskRef),
                                          CGImageGetBitsPerComponent(maskRef),
                                          CGImageGetBitsPerPixel(maskRef),
                                          CGImageGetBytesPerRow(maskRef),
                                          CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask11);
    
    
    
    return [UIImage imageWithCGImage:masked];
    //iv.image= [UIImage imageWithCGImage:masked];
    // iv.layer.masksToBounds = YES;
    
}


-(void)callWebserviceForCoachHomeResult
{
    
    dictResultDirectory = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicCoachHomeSubmit];
    
    NSLog(@"dictResultDirectory == %@",dictResultDirectory);
    
    if (arr_ResponseData.count>0) {
        [arr_ResponseData removeAllObjects];
        arr_ResponseData=[[NSMutableArray alloc]init];
    }
    
    NSString *strSucessValue = [NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"ok"]];
    
    if ([strSucessValue isEqualToString:@"1"]) {
        
        arrCoachHomeClassList = [dictResultDirectory objectForKey:@"classes"];
        
        [tblCoachClassesList reloadData];
        
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrCoachHomeClassList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customCoachHomeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //class_name
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"CoachHomecell" owner:self options:nil];
        cell = customTblViewCell;
        customTblViewCell=nil;
        UIImageView *imgCellColor = (UIImageView *)[cell.contentView viewWithTag:191];
        imgCellColor = nil;
    }
    
    
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:20];
    
    UILabel *lblDay = (UILabel *)[cell.contentView viewWithTag:21];
    
    UILabel *lblMonth = (UILabel *)[cell.contentView viewWithTag:22];
    
    UILabel *lblTime = (UILabel *)[cell.contentView viewWithTag:23];
    //
    UILabel *lblNameOfClass = (UILabel *)[cell.contentView viewWithTag:24];
    lblNameOfClass.text = [[arrCoachHomeClassList objectAtIndex:indexPath.row]objectForKey:@"class_name"];
    
    UILabel *lblNameOfLocation = (UILabel *)[cell.contentView viewWithTag:25];
    
    if ([[arrCoachHomeClassList objectAtIndex:indexPath.row]objectForKey:@"location"] != nil && [[arrCoachHomeClassList objectAtIndex:indexPath.row]objectForKey:@"location"] != NULL && ![[[arrCoachHomeClassList objectAtIndex:indexPath.row]objectForKey:@"location"] isEqual:[NSNull null]]) {
        
        lblNameOfLocation.text = [[arrCoachHomeClassList objectAtIndex:indexPath.row]objectForKey:@"location"];
    }
    
    //    UILabel *lblNameOfLocation = (UILabel *)[cell.contentView viewWithTag:25];
    //    lblNameOfLocation.text = [[arrAllClasses objectAtIndex:indexPath.row]objectForKey:@"location"];
    
    NSLog(@"Row Number Is : %ld",(long)indexPath.row);
    
    UIImageView *imgCellColor = (UIImageView *)[cell.contentView viewWithTag:191];
    
    if (indexPath.row % 3 == 1)
    {
        [imgCellColor setImage:[UIImage imageNamed:@"red_bar.jpg"]];
    }
    else if (indexPath.row % 3 == 2)
    {
        [imgCellColor setImage:[UIImage imageNamed:@"green_bar.jpg"]];
    }
    else {
        
        [imgCellColor setImage:[UIImage imageNamed:@"blue_bar.jpg"]];//blue_bar.jpg
    }
    
    NSString *strDateTime = [NSString stringWithFormat:@"%@",[[arrCoachHomeClassList objectAtIndex:indexPath.row] objectForKey:@"start_time"]];
    ;
    //    NSString *strEndTime = [NSString stringWithFormat:@"%@",[[arrAllClasses objectAtIndex:indexPath.row] objectForKey:@"end_time"]];
    //    ;
    
    NSDate *dateNew = [self convertStringToDate:strDateTime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateNew];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    lblDate.text = [NSString stringWithFormat:@"%ld",(long)day];
    lblMonth.text = [[monthName substringToIndex:3]uppercaseString];
    
    // Now lets get time from Date Time
    
    NSDateComponents *componentsTime = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateNew];
    NSInteger hour = [componentsTime hour];
    NSInteger minute = [componentsTime minute];
    lblTime.text = [NSString stringWithFormat:@"%ld:%ld",(long)hour,(long)minute];
    
    
    // NSDate *dateNew1 = [self convertStringToDate:strEndTime];
    //    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateNew1];
    
    NSDateFormatter *dfNew = [[NSDateFormatter alloc] init];
    [dfNew setDateFormat:@"EEEE"];
    NSString *dayName = [dfNew stringFromDate:dateNew];
    lblDay.text =  [[dayName substringToIndex:3]uppercaseString];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [self callWebserviceForClassDetails:(int)indexPath.row];
    CoachStudentListVC *clavc = [[CoachStudentListVC alloc]initWithNibName:@"CoachStudentListVC" bundle:nil];
    clavc.dicOldDetails = [arrCoachHomeClassList objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:clavc animated:YES];
}
//
//-(void)callWebserviceForClassDetails:(int)rowNum
//{
//    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
//    [dicClassDetailSubmit setObject:@"cs" forKey:@"ac"];
//    [dicClassDetailSubmit setObject:[[arrCoachHomeClassList objectAtIndex:rowNum]objectForKey:@"id"] forKey:@"cid"];
//    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
//    //        [dicClassDetailSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
//    //    }
//    [WebServiceHelperVC wsVC].methodType = @"POST";
//
//
//    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
//    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
//
//    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
//
//    [self.view addSubview:indicator];
//    [indicator bringSubviewToFront:self.view];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
//    [indicator startAnimating];
//
//    [self getClassDetails:(int)rowNum];
//
//
//}
//
//-(void)getClassDetails:(int)rowNum
//{
//
//    NSMutableDictionary *dictResultClassDetails = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassDetailSubmit];
//
//
//    //device_type=android/ios&device_token
//
//    if ([[dictResultClassDetails objectForKey:@"ok"]integerValue] == 1) {
//        if ([dictResultClassDetails objectForKey:@"students"]!= nil && [dictResultClassDetails objectForKey:@"students"] != NULL) {
//
//            CoachStudentListVC *clavc = [[CoachStudentListVC alloc]initWithNibName:@"CoachStudentListVC" bundle:nil];
//            clavc.dicAllDetails = dictResultClassDetails;
//            clavc.dicOldDetails = [arrCoachHomeClassList objectAtIndex:rowNum];
//            [self.navigationController pushViewController:clavc animated:YES];
//        }
//    }
//    else
//    {
//        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassDetails objectForKey:@"msg"]]];
//    }
//
//    [indicator stopAnimating];
//}

-(NSDate *)convertStringToDate :(NSString *)strNewDate
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    NSDate *dateFinal = [dateFormat dateFromString:strNewDate];
    return dateFinal;
    
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
}


- (void)btnLogoutClicked:(id)sender
{
    
    UIAlertView *alertLogin = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Are you sure want to Logout from the Application?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    
    [alertLogin show];
    alertLogin = nil;
  
}


- (IBAction)action_logout:(id)sender {
    
    SWRevealViewController *revealController = self.revealViewController;
    
    NSUserDefaults *defaultsEnabled = [NSUserDefaults standardUserDefaults];
    [defaultsEnabled setBool:NO forKey:@"isloggedIn"];
    [defaultsEnabled synchronize];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    LoginVC *lvc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lvc];
    [revealController pushFrontViewController:navigationController animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self action_logout:nil];
    }
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
