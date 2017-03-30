//
//  MyClassVC.m
//  OurParks
//
//  Created by Darshil Shah on 21/08/15.
//
//

#import "MyClassVC.h"
#import "ClassDetailsVC.h"

@interface MyClassVC ()

@end

@implementation MyClassVC
@synthesize tblMyClassesList,customTblViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"USER_ID = %@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]);
    
    //customMyClassCellIdentifier
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    arrBookedClassList = [[NSMutableArray alloc]init];
    arrClassHistoryList = [[NSMutableArray alloc]init];
    
    dicClassDetailSubmit = [[NSMutableDictionary alloc]init];
    
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self performSelector:@selector(setUI) withObject:nil afterDelay:0.1];
    
    [self callWebserviceForBookedClass];
    
}

-(void)setUI
{
    isBookedClassSelected = YES;
    
    btnBookedClass = (UIButton *)[self.view viewWithTag:91];
    btnClassHistory = (UIButton *)[self.view viewWithTag:92];
    
    btnClassHistory.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:11.0/255.0 blue:41.0/255.0 alpha:1.0];
    
    btnClassHistory.titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    btnBookedClass.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    btnBookedClass.titleLabel.textColor = [UIColor colorWithRed:212.0/255.0 green:11.0/255.0 blue:41.0/255.0 alpha:1.0];
    
}

-(void)callWebserviceForBookedClass
{
    if ([appDelOurParks connecttonetwork]) {
        
        arr_ResponseData1 = [[NSMutableArray alloc]init];
        // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
        dicBookedClassSubmit = [[NSMutableDictionary alloc]init];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
            [dicBookedClassSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
        }
        
        NSString *strRole = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ROLE]];
        
        
        if ([strRole isEqualToString:@"instructors"]) {
            
            [dicBookedClassSubmit setObject:@"if" forKey:@"ac"];
            // Just For Testing Not Actual --- [dicBookedClassSubmit setObject:@"sf" forKey:@"ac"];
            
        }
        else
        {
            [dicBookedClassSubmit setObject:@"sf" forKey:@"ac"];
        }
        
        [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
        [WebServiceHelperVC wsVC].methodType = @"POST";
        [self performSelector:@selector(callWebserviceForClassBookedResult) withObject:nil afterDelay:0.1];
        
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

-(void)callWebserviceForClassHistory
{
    
    if ([appDelOurParks connecttonetwork]) {
        
        arr_ResponseData2 = [[NSMutableArray alloc]init];
        // [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
        dicClassHistorySubmit = [[NSMutableDictionary alloc]init];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
            [dicClassHistorySubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
        }
        
        NSString *strRole = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ROLE]];
        
        
        if ([strRole isEqualToString:@"instructors"]) {
            [dicClassHistorySubmit setObject:@"ih" forKey:@"ac"];
            // Just For Testing Not Actual ---  [dicClassHistorySubmit setObject:@"sh" forKey:@"ac"];
        }
        else
        {
            [dicClassHistorySubmit setObject:@"sh" forKey:@"ac"];
        }
        
        [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
        [WebServiceHelperVC wsVC].methodType = @"POST";
        [self performSelector:@selector(callWebserviceForClassHistoryResult) withObject:nil afterDelay:0.1];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isBookedClassSelected == YES) {
        return arr_ResponseData1.count;
    }
    else
    {
        return arr_ResponseData2.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customMyClassCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    UIImageView *imgCellColor = nil;
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"MyClasscell" owner:self options:nil];
        cell = customTblViewCell;
        customTblViewCell=nil;
        imgCellColor = (UIImageView *)[cell.contentView viewWithTag:191];
    }
    
    
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:20];
    
    UILabel *lblDay = (UILabel *)[cell.contentView viewWithTag:21];
    
    UILabel *lblMonth = (UILabel *)[cell.contentView viewWithTag:22];
    
    UILabel *lblTime = (UILabel *)[cell.contentView viewWithTag:23];
    
    
    //
    UILabel *lblNameOfClass = (UILabel *)[cell.contentView viewWithTag:24];
    //
    UILabel *lblLocation = (UILabel *)[cell.contentView viewWithTag:25];
    
    // if (isBookedClassSelected == YES) {
    
    
    NSLog(@"Row Number Is : %ld",(long)indexPath.row);
    
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
    
    NSString *strDateTime = @"";
    
    if (isBookedClassSelected) {
        lblNameOfClass.text = [[arr_ResponseData1 objectAtIndex:indexPath.row] objectForKey:@"class_name"];
        lblLocation.text = [[arr_ResponseData1 objectAtIndex:indexPath.row] objectForKey:@"location"];
        strDateTime = [NSString stringWithFormat:@"%@",[[arr_ResponseData1 objectAtIndex:indexPath.row] objectForKey:@"start_time"]];
        ;
    }
    else
    {
        lblNameOfClass.text = [[arr_ResponseData2 objectAtIndex:indexPath.row] objectForKey:@"class_name"];
        lblLocation.text = [[arr_ResponseData2 objectAtIndex:indexPath.row] objectForKey:@"location"];
        strDateTime = [NSString stringWithFormat:@"%@",[[arr_ResponseData2 objectAtIndex:indexPath.row] objectForKey:@"start_time"]];
        ;
    }
    
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
    
    //
    //        lblServiceID.text = [NSString stringWithFormat:@" ID - %@",[[arrMyServiceList objectAtIndex:indexPath.row]objectForKey:@"service_number"]];
    
    
    return cell;
    
    //    }
    //    else
    //    {
    //
    //
    //        if (indexPath.row % 3 == 1)
    //        {
    //            [imgCellColor setImage:[UIImage imageNamed:@"blue_bar.jpg"]];
    //        }
    //        else if (indexPath.row % 3 == 2)
    //        {
    //            [imgCellColor setImage:[UIImage imageNamed:@"red_bar.jpg"]];
    //        }
    //        else {
    //
    //            [imgCellColor setImage:[UIImage imageNamed:@"green_bar.jpg"]];
    //        }
    //
    //        lblNameOfClass.text = [NSString stringWithFormat:@"Row Number Is : %ld",(long)indexPath.row];
    //
    //        return cell;
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  [self callWebserviceForClassDetails:(int)indexPath.row];
    ClassDetailsVC *clavc = [[ClassDetailsVC alloc]initWithNibName:@"ClassDetailsVC" bundle:nil];
    //    clavc.dicClassDetails = dictResultClassDetails;
    clavc.row_num = (int)indexPath.row;
    if (isBookedClassSelected == YES) {
        clavc.arrAllClassDataPrev = arr_ResponseData1;
    }
    else
    {
        clavc.arrAllClassDataPrev = arr_ResponseData2;
    }
    
    clavc.strIsFromClass = @"MyClassVC";
    
    //    clavc.dicPrevClassDetails = [arrAllClassDataPrev objectAtIndex:rowNum];
    [self.navigationController pushViewController:clavc animated:YES];
    
    
}

//-(void)callWebserviceForClassDetails:(int)rowNum
//{
//    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
//    [dicClassDetailSubmit setObject:@"get_class" forKey:@"ac"];
//
//    if (isBookedClassSelected == YES) {
//        [dicClassDetailSubmit setObject:[[arr_ResponseData1 objectAtIndex:rowNum]objectForKey:@"id"] forKey:@"cid"];
//    }
//    else
//    {
//        [dicClassDetailSubmit setObject:[[arr_ResponseData2 objectAtIndex:rowNum]objectForKey:@"id"] forKey:@"cid"];
//
//    }
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
//        [dicClassDetailSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
//    }
//
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
//}
//
//-(void)getClassDetails:(int)rowNum
//{
//
//    NSMutableDictionary *dictResultClassDetails = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassDetailSubmit];
//
//    //device_type=android/ios&device_token
//
//    if ([[dictResultClassDetails objectForKey:@"ok"]integerValue] == 1) {
//        if ([dictResultClassDetails objectForKey:@"data"]!= nil && [dictResultClassDetails objectForKey:@"data"] != NULL) {
//
//            ClassDetailsVC *clavc = [[ClassDetailsVC alloc]initWithNibName:@"ClassDetailsVC" bundle:nil];
//            clavc.dicClassDetails = dictResultClassDetails;
//            if (isBookedClassSelected == YES) {
//                clavc.dicPrevClassDetails = [arr_ResponseData1 objectAtIndex:rowNum];
//            }
//            else
//            {
//                clavc.dicPrevClassDetails = [arr_ResponseData2 objectAtIndex:rowNum];
//            }
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


//-(void)callWebServiceForMyServiceList
//{
//
//    NSMutableDictionary *dictResultDirectory = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicMyServiceSubmit];
//
//    if (arr_ResponseServiceData.count>0) {
//        [arr_ResponseServiceData removeAllObjects];
//        arr_ResponseServiceData=[[NSMutableArray alloc]init];
//    }
//
//    if ([[dictResultDirectory objectForKey:@"status"] isEqualToString:@"success"]) {
//
//        arrMyServiceList = [[[dictResultDirectory objectForKey:@"data"] objectForKey:@"unitDetails"]objectForKey:@"unit_service_records"];
//
//        [tbl_MyServiceList reloadData];
//    }
//    else
//    {
//        [appDelSilverGardenia showAlert:[NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"message"]]];
//    }
//
//    [indicator stopAnimating];
//
//}
//
-(void)callWebserviceForClassHistoryResult
{
    
    NSMutableDictionary *dictResultDirectory = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassHistorySubmit];
    
    if (arr_ResponseData2.count>0) {
        [arr_ResponseData2 removeAllObjects];
        arr_ResponseData2=[[NSMutableArray alloc]init];
    }
    
    NSString *strSucessValue = [NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"ok"]];
    
    if ([strSucessValue isEqualToString:@"1"]) {
        
        arr_ResponseData2 = [dictResultDirectory objectForKey:@"classes"];
        
        [tblMyClassesList reloadData];
        
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
}

-(void)callWebserviceForClassBookedResult
{
    
    NSMutableDictionary *dictResultDirectory = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicBookedClassSubmit];
    
    if (arr_ResponseData1.count>0) {
        [arr_ResponseData1 removeAllObjects];
        arr_ResponseData1=[[NSMutableArray alloc]init];
    }
    
    NSString *strSucessValue = [NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"ok"]];
    
    if ([strSucessValue isEqualToString:@"1"]) {
        
        arr_ResponseData1 = [dictResultDirectory objectForKey:@"classes"];
        
        [tblMyClassesList reloadData];
        
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultDirectory objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
}

-(NSDate *)convertStringToDate :(NSString *)strNewDate
{
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    NSDate *dateFinal = [dateFormat dateFromString:strNewDate];
    return dateFinal;
    
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

- (IBAction)btnBookedClassClicked:(id)sender {
    
    isBookedClassSelected = YES;
    
    btnClassHistory.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:11.0/255.0 blue:41.0/255.0 alpha:1.0];
    
    btnClassHistory.titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    btnBookedClass.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    btnBookedClass.titleLabel.textColor = [UIColor colorWithRed:212.0/255.0 green:11.0/255.0 blue:41.0/255.0 alpha:1.0];
    
    [self callWebserviceForBookedClass];
}

- (IBAction)btnClassHistoryClicked:(id)sender {
    
    isBookedClassSelected = NO;
    
    btnBookedClass.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:11.0/255.0 blue:41.0/255.0 alpha:1.0];
    btnBookedClass.titleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    btnClassHistory.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    btnClassHistory.titleLabel.textColor = [UIColor redColor];
    
    [self callWebserviceForClassHistory];
}
@end
