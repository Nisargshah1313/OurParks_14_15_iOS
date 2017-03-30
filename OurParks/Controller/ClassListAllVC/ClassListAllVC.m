//
//  ClassListAllVC.m
//  OurParks
//
//  Created by Darshil Shah on 05/09/15.
//
//

#import "ClassListAllVC.h"
#import "ClassDetailsVC.h"

@interface ClassListAllVC ()

@end

@implementation ClassListAllVC
@synthesize tbl_AllClassList,customTblViewCell,dicAllDetails,strSearchedUnitNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"dicAllUnitDetails AT list = %@",dicAllDetails);
    
    arrAllClasses = [[NSMutableArray alloc]init];
    
    arrAllClasses = [dicAllDetails objectForKey:@"classes"];
    
    dicClassDetailSubmit = [[NSMutableDictionary alloc]init];
    
    if (arrAllClasses.count > 0) {
        [tbl_AllClassList reloadData];
    }
    else
    {
        [appDelOurParks showAlert:@"NO CLASS FOUND."];
    }
    
    //customAllClassCellIdentifier
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrAllClasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customAllClassCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //class_name
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ClassAllcell" owner:self options:nil];
        cell = customTblViewCell;
        customTblViewCell=nil;
        UIImageView *imgCellColor = (UIImageView *)[cell.contentView viewWithTag:191];
        imgCellColor = nil;
    }
    
    
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:20];
    
    UILabel *lblDay = (UILabel *)[cell.contentView viewWithTag:21];
    
    UILabel *lblMonth = (UILabel *)[cell.contentView viewWithTag:22];
    
    UILabel *lblTime = (UILabel *)[cell.contentView viewWithTag:23];
    
    UILabel *lblNameOfClass = (UILabel *)[cell.contentView viewWithTag:24];
    lblNameOfClass.text = [[arrAllClasses objectAtIndex:indexPath.row]objectForKey:@"class_name"];
    
    UILabel *lblNameOfLocation = (UILabel *)[cell.contentView viewWithTag:25];
    lblNameOfLocation.text = [[arrAllClasses objectAtIndex:indexPath.row]objectForKey:@"location"];
    
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
    
    
    NSString *strDateTime = [NSString stringWithFormat:@"%@",[[arrAllClasses objectAtIndex:indexPath.row] objectForKey:@"start_time"]];
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
    
    
    //    NSInteger day1 = [components1 day];
    //    NSInteger month1 = [components1 month];
    //    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    //    NSString *monthName1 = [[df1 monthSymbols] objectAtIndex:(month1-1)];
    //    lblCloseDate.text = [NSString stringWithFormat:@"%ld %@",(long)day1,monthName1];
    
    // Now lets get time from Date Time
    
    //    NSDateComponents *componentsTime1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:dateNew1];
    //    NSInteger hour1 = [componentsTime1 hour];
    //    NSInteger minute1 = [componentsTime1 minute];
    //    lblClassEndTime.text = [NSString stringWithFormat:@"%ld:%ld",(long)hour1,(long)minute1];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClassDetailsVC *clavc = [[ClassDetailsVC alloc]initWithNibName:@"ClassDetailsVC" bundle:nil];
    //    clavc.dicClassDetails = dictResultClassDetails;
    clavc.row_num = (int)indexPath.row;
    clavc.arrAllClassDataPrev = arrAllClasses;
    clavc.strIsFromClass = @"";
    //    clavc.dicPrevClassDetails = [arrAllClassDataPrev objectAtIndex:rowNum];
    [self.navigationController pushViewController:clavc animated:YES];
    
    // [self callWebserviceForClassDetails:(int)indexPath.row];
    
    //arrAllClassDataPrev
    //row_num
    
}

//-(void)callWebserviceForClassDetails:(int)rowNum
//{
//    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
//    [dicClassDetailSubmit setObject:@"get_class" forKey:@"ac"];
//    [dicClassDetailSubmit setObject:[[arrAllClasses objectAtIndex:rowNum]objectForKey:@"nid"] forKey:@"cid"];
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
//        [dicClassDetailSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
//    }
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
//    //[self performSelector:@selector(getClassDetails) withObject:nil afterDelay:0.1];
//
//    [self getClassDetails:(int)rowNum];
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
//        if ([dictResultClassDetails objectForKey:@"data"]!= nil && [dictResultClassDetails objectForKey:@"data"] != NULL) {
//
//            ClassDetailsVC *clavc = [[ClassDetailsVC alloc]initWithNibName:@"ClassDetailsVC" bundle:nil];
//            clavc.dicClassDetails = dictResultClassDetails;
//            clavc.dicPrevClassDetails = [arrAllClasses objectAtIndex:rowNum];
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

-(void)claculationsForTheDateTime
{
    
}

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
