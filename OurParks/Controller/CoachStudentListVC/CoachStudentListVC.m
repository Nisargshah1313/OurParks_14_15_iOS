//
//  CoachStudentListVC.m
//  OurParks
//
//  Created by Darshil Shah on 29/10/15.
//
//

#import "CoachStudentListVC.h"
#import "SignUpVC.h"
#import "AddParkerVC.h"


@interface CoachStudentListVC ()

@end

@implementation CoachStudentListVC
@synthesize dicAllDetails,tblVwStudentList,customTblViewCell,dicOldDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    dicStudentListSubmit = [[NSMutableDictionary alloc]init];
    
    dicForStudentSubmit = [[NSMutableDictionary alloc]init];
    
    arrStudentList = [[NSMutableArray alloc]init];
    
    [self callWebserviceForStudentList];
    
    lblClassDate = (UILabel *)[self.view viewWithTag:20];
    
    lblClassDay = (UILabel *)[self.view viewWithTag:21];
    
    lblClassMonth = (UILabel *)[self.view viewWithTag:22];
    
    lblClassStartTime = (UILabel *)[self.view viewWithTag:23];
    //
    lblClassName = (UILabel *)[self.view viewWithTag:24];
    
    lblClassLocation = (UILabel *)[self.view viewWithTag:25];
    
   // lblClassEndTime = (UILabel *)[self.view viewWithTag:28];
  //  lblClassAttendees = (UILabel *)[self.view viewWithTag:29];
 //   lblClassExertion = (UILabel *)[self.view viewWithTag:30];
    
    if ([dicOldDetails objectForKey:@"number_of_attendees"]!=nil && [dicOldDetails objectForKey:@"number_of_attendees"]!=NULL) {
        
        lblClassAttendees.text = [dicOldDetails objectForKey:@"number_of_attendees"];
        
    }
    
    //
    if ([dicOldDetails objectForKey:@"exertion"]!=nil && [dicOldDetails objectForKey:@"exertion"]!=NULL) {
        
        lblClassExertion.text = [dicOldDetails objectForKey:@"exertion"];
        
    }
    
    if ([dicOldDetails objectForKey:@"class_name"]!=nil && [dicOldDetails objectForKey:@"class_name"]!=NULL) {
        
        lblClassName.text = [dicOldDetails objectForKey:@"class_name"];
        
    }
    
    if ([dicOldDetails objectForKey:@"location"]!=nil && [dicOldDetails objectForKey:@"location"]!=NULL) {
        
        lblClassLocation.text = [dicOldDetails objectForKey:@"location"];
        
    }
    //description
    
    
    
    //claculationsForTheDateTime
    if ([dicOldDetails objectForKey:@"start_time"]!=nil && [dicOldDetails objectForKey:@"start_time"]!=NULL) {
        
        [self claculationsForTheDateTime];
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger finalCountOfRow = arrStudentList.count;
    
    return finalCountOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customStudentCellIdentimfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"StudentListcell" owner:self options:nil];
        cell = customTblViewCell;
        
        customTblViewCell=nil;
    }
    
    UIImageView *imgVwProfile = (UIImageView *)[cell.contentView viewWithTag:21];
    
    UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:22];
    
    UILabel *lblStatus = (UILabel *)[cell.contentView viewWithTag:23];
    
    lblTitle.text = [NSString stringWithFormat:@"%@ %@",[[arrStudentList objectAtIndex:indexPath.row]objectForKey:@"first_name"],[[arrStudentList objectAtIndex:indexPath.row]objectForKey:@"last_name"]];
    
    [imgVwProfile setImageWithURL:[NSURL URLWithString:[[arrStudentList objectAtIndex:indexPath.row]objectForKey:@"picture"]] placeholderImage:Nil];
    
    if ([[[arrStudentList objectAtIndex:indexPath.row]objectForKey:@"status"]integerValue] == 0) {
        lblStatus.text = @"Register";
        
    }
    else
    {
        lblStatus.text = @"UnRegister";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self callWebserviceForRegUserInClass:(int)indexPath.row];
}

-(void)callWebserviceForRegUserInClass:(int)rowNum
{
    //{“ac”:”si”,*“sid”:*“unique*id”,*“cid”:123,”in”:1*}*
    
    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    [dicStudentListSubmit setObject:@"si" forKey:@"ac"];
    [dicStudentListSubmit setObject:[[arrStudentList objectAtIndex:rowNum]objectForKey:@"id"] forKey:@"sid"];
    [dicStudentListSubmit setObject:[dicOldDetails objectForKey:@"id"] forKey:@"cid"];
    if ([[[arrStudentList objectAtIndex:rowNum]objectForKey:@"status"]integerValue] == 0) {
        [dicStudentListSubmit setObject:@"1" forKey:@"in"];
    }
    else
    {
        [dicStudentListSubmit setObject:@"0" forKey:@"in"];
    }
    
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
    //        [dicStudentListSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    //    }
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
//    [self.view addSubview:indicator];
//    [indicator bringSubviewToFront:self.view];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
//    [indicator startAnimating];
    [self performSelector:@selector(regOrDeRegClassNow) withObject:nil afterDelay:0.1];
    
}

-(void)regOrDeRegClassNow
{
    
    NSMutableDictionary *dictResultClassList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicStudentListSubmit];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResultClassList objectForKey:@"ok"]integerValue] == 1) {
       
        [self callWebserviceForStudentList];
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassList objectForKey:@"msg"]]];
    }
    
  
   //  [indicator stopAnimating];
   
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

-(void)claculationsForTheDateTime
{
    NSString *strDateTime = [NSString stringWithFormat:@"%@",[dicOldDetails objectForKey:@"start_time"]];
    ;
    NSString *strEndTime = [NSString stringWithFormat:@"%@",[dicOldDetails objectForKey:@"end_time"]];
    ;
    
    NSDate *dateNew = [self convertStringToDate:strDateTime];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateNew];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(month-1)];
    lblClassDate.text = [NSString stringWithFormat:@"%ld",(long)day];
    lblClassMonth.text = [[monthName substringToIndex:3]uppercaseString];
    
    // Now lets get time from Date Time
    
    NSDateComponents *componentsTime = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateNew];
    NSInteger hour = [componentsTime hour];
    NSInteger minute = [componentsTime minute];
    lblClassStartTime.text = [NSString stringWithFormat:@"%ld:%ld",(long)hour,(long)minute];
    
    
    NSDate *dateNew1 = [self convertStringToDate:strEndTime];
    //    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateNew1];
    
    NSDateFormatter *dfNew = [[NSDateFormatter alloc] init];
    [dfNew setDateFormat:@"EEEE"];
    NSString *dayName = [dfNew stringFromDate:dateNew];
    lblClassDay.text =  [[dayName substringToIndex:3]uppercaseString];
    
    
    //    NSInteger day1 = [components1 day];
    //    NSInteger month1 = [components1 month];
    //    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    //    NSString *monthName1 = [[df1 monthSymbols] objectAtIndex:(month1-1)];
    //    lblCloseDate.text = [NSString stringWithFormat:@"%ld %@",(long)day1,monthName1];
    
    // Now lets get time from Date Time
    
    NSDateComponents *componentsTime1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateNew1];
    NSInteger hour1 = [componentsTime1 hour];
    NSInteger minute1 = [componentsTime1 minute];
    lblClassEndTime.text = [NSString stringWithFormat:@"%ld:%ld",(long)hour1,(long)minute1];
}

-(NSDate *)convertStringToDate :(NSString *)strNewDate
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    NSDate *dateFinal = [dateFormat dateFromString:strNewDate];
    return dateFinal;
    
}

// Student List

-(void)callWebserviceForStudentList
{
    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    [dicForStudentSubmit setObject:@"cs" forKey:@"ac"];
    [dicForStudentSubmit setObject:[dicOldDetails objectForKey:@"id"] forKey:@"cid"];
   
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
//    [self.view addSubview:indicator];
//    [indicator bringSubviewToFront:self.view];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
//    [indicator startAnimating];
    
    [self getStudentList];
    
}

-(void)getStudentList
{
    
    NSMutableDictionary *dictResultList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicForStudentSubmit];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResultList objectForKey:@"ok"]integerValue] == 1) {
        if ([dictResultList objectForKey:@"students"]!= nil && [dictResultList objectForKey:@"students"] != NULL) {
            
            dicAllDetails = dictResultList;
            
            arrStudentList = [dicAllDetails objectForKey:@"students"];
            
            [tblVwStudentList reloadData];
            
        }
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultList objectForKey:@"msg"]]];
    }
    
   // [indicator stopAnimating];
}



- (IBAction)btnAddNewAttendeeClicked:(id)sender {
    
    SignUpVC *svc = [[SignUpVC alloc] initWithNibName:@"SignUpVC" bundle:nil];
    NSString *strSignupUrl = @"http://www.ourparks.org.uk/user/register";
    //http://www.ourparks.org.uk/user/register
    svc.strFromSignUpClick = @"";
    svc.strDirectWebVwUrl = strSignupUrl;
    [self.navigationController pushViewController:svc animated:YES];
    
}

- (IBAction)btnAddParkerClicked:(id)sender {
    
    AddParkerVC *apvc = [[AddParkerVC alloc] initWithNibName:@"AddParkerVC" bundle:nil];
    apvc.dicPrevScreenDetails = dicOldDetails;
    [self.navigationController pushViewController:apvc animated:YES];
}
@end
