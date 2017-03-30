//
//  ClassDetailsVC.m
//  OurParks
//
//  Created by Darshil Shah on 08/08/15.
//
//

#import "ClassDetailsVC.h"

@interface ClassDetailsVC ()

@end

@implementation ClassDetailsVC
@synthesize txtVwDetails,dicClassDetails,dicPrevClassDetails,row_num,arrAllClassDataPrev,strIsFromClass;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSLog(@"arrAllClassDataPrev = %@",arrAllClassDataPrev);
    NSLog(@"row_num = %d",row_num);
    NSLog(@"strIsFromClass = %@",strIsFromClass);
    
    dicClassDetailSubmit1 = [[NSMutableDictionary alloc]init];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    
    
    [self callWebserviceForClassDetails:row_num];
    
}

-(void)callWebserviceForClassDetails:(int)rowNum
{
    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    [dicClassDetailSubmit1 setObject:@"get_class" forKey:@"ac"];
    if ([strIsFromClass isEqualToString:@"MyClassVC"])
    {
        [dicClassDetailSubmit1 setObject:[[arrAllClassDataPrev objectAtIndex:rowNum]objectForKey:@"id"] forKey:@"cid"];
    }
    else
    {
        [dicClassDetailSubmit1 setObject:[[arrAllClassDataPrev objectAtIndex:rowNum]objectForKey:@"nid"] forKey:@"cid"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
        [dicClassDetailSubmit1 setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    }
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    
    //[self performSelector:@selector(getClassDetails) withObject:nil afterDelay:0.1];
    
    [self getClassDetails:(int)rowNum];
}

-(void)getClassDetails:(int)rowNum
{
    
    NSMutableDictionary *dictResultClassDetails = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassDetailSubmit1];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResultClassDetails objectForKey:@"ok"]integerValue] == 1) {
        if ([dictResultClassDetails objectForKey:@"data"]!= nil && [dictResultClassDetails objectForKey:@"data"] != NULL) {
            
            dicClassDetails = dictResultClassDetails;
            //  dicPrevClassDetails = [arrAllClassDataPrev objectAtIndex:rowNum];
            [self setAllData];
        }
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassDetails objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
}



-(void)setAllData
{
    NSLog(@"dicClassDetails = %@",dicClassDetails);
    
    lblClassStatus = (UILabel *)[self.view viewWithTag:21];
    lblClassName = (UILabel *)[self.view viewWithTag:22];
    lblClassLocation = (UILabel *)[self.view viewWithTag:23];
    lblClassDate = (UILabel *)[self.view viewWithTag:24];
    lblClassDay = (UILabel *)[self.view viewWithTag:25];
    lblClassMonth = (UILabel *)[self.view viewWithTag:26];
    lblClassStartTime = (UILabel *)[self.view viewWithTag:27];
    lblClassEndTime = (UILabel *)[self.view viewWithTag:28];
    lblClassAttendees = (UILabel *)[self.view viewWithTag:29];
    lblClassExertion = (UILabel *)[self.view viewWithTag:30];
    
    if ([dicClassDetails objectForKey:@"data"]!=nil && [dicClassDetails objectForKey:@"data"]!=NULL) {
        dicClassDetails = [dicClassDetails objectForKey:@"data"];
        
        if ([dicClassDetails objectForKey:@"user_registered"]!=nil && [dicClassDetails objectForKey:@"user_registered"]!=NULL) {
            if ([[dicClassDetails objectForKey:@"user_registered"]integerValue] == 0) {
                
                // Not Registred
                
                lblClassStatus.text = @"BOOK THIS CLASS";
            }
            else
            {
                // Already Registered
                
                lblClassStatus.text = @"CANCEL THIS CLASS";
            }
        }
        
        
        if ([dicClassDetails objectForKey:@"title"]!=nil && [dicClassDetails objectForKey:@"title"]!=NULL) {
            
            lblClassName.text = [dicClassDetails objectForKey:@"title"];
            
        }
        
        if ([dicClassDetails objectForKey:@"location"]!=nil && [dicClassDetails objectForKey:@"location"]!=NULL) {
            
            lblClassLocation.text = [dicClassDetails objectForKey:@"location"];
            
        }
        
        if ([dicClassDetails objectForKey:@"number_of_attendees"]!=nil && [dicClassDetails objectForKey:@"number_of_attendees"]!=NULL) {
            
            lblClassAttendees.text = [dicClassDetails objectForKey:@"number_of_attendees"];
            
        }
        
        //
        if ([dicClassDetails objectForKey:@"exertion"]!=nil && [dicClassDetails objectForKey:@"exertion"]!=NULL) {
            
            lblClassExertion.text = [dicClassDetails objectForKey:@"exertion"];
            
        }
        //description
        
        if ([dicClassDetails objectForKey:@"description"]!=nil && [dicClassDetails objectForKey:@"description"]!=NULL) {
            
            txtVwDetails.text = [dicClassDetails objectForKey:@"description"];
            
        }
        
        //claculationsForTheDateTime
        if ([dicClassDetails objectForKey:@"start_time"]!=nil && [dicClassDetails objectForKey:@"start_time"]!=NULL) {
            
            [self claculationsForTheDateTime];
            
        }
    }
    
}

-(void)claculationsForTheDateTime
{
    NSString *strDateTime = [NSString stringWithFormat:@"%@",[dicClassDetails objectForKey:@"start_time"]];
    ;
    NSString *strEndTime = [NSString stringWithFormat:@"%@",[dicClassDetails objectForKey:@"end_time"]];
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

- (IBAction)btnBookCancelClassClicked:(id)sender {
    
    // USE WEB-SERVICE NO : 17
    
    // Check if class is already booked - then cancel it
    
    dicBookClassSubmit = [[NSMutableDictionary alloc]init];
    
    //Now book the Class
    
    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    [dicBookClassSubmit setObject:@"sr" forKey:@"ac"];
    [dicBookClassSubmit setObject:[dicClassDetails objectForKey:@"nid"] forKey:@"cid"];
    if ([[dicClassDetails objectForKey:@"user_registered"]integerValue] == 0) {
        [dicBookClassSubmit setObject:@"1" forKey:@"user_registered_count"];
    }
    else
    {
        [dicBookClassSubmit setObject:@"0" forKey:@"user_registered_count"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
        [dicBookClassSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    }
    
    //uid
    // [dicBookClassSubmit setObject:[dicClassDetails objectForKey:@"uid"] forKey:@"sid"];
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    
    [self performSelector:@selector(regOrDeRegClassNow) withObject:nil afterDelay:0.1];
    
    
    
    
    
    // NEW WEBSERVICE IMPLEMENTATION
    
    // USE WEB-SERVICE NO : 23
    
    // Check if class is already booked - then cancel it
    
    //    dicBookClassSubmit = [[NSMutableDictionary alloc]init];
    //
    //    //Now book the Class
    //
    //    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    //    [dicBookClassSubmit setObject:@"sr" forKey:@"ac"];
    //    [dicBookClassSubmit setObject:[dicClassDetails objectForKey:@"nid"] forKey:@"cid"];
    //
    //
    //
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
    //        [dicBookClassSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    //    }
    
    //    if ([[dicClassDetails objectForKey:@"user_registered"]integerValue] == 0) {
    //        [dicBookClassSubmit setObject:@"1" forKey:@"in"];
    //    }
    //    else
    //    {
    //        [dicBookClassSubmit setObject:@"0" forKey:@"in"];
    //    }
    
    //    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
    //        [dicBookClassSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    //    }
    //
    //    //uid
    //    // [dicBookClassSubmit setObject:[dicClassDetails objectForKey:@"uid"] forKey:@"sid"];
    //    [WebServiceHelperVC wsVC].methodType = @"POST";
    //
    //
    //    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    //    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    //
    //    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    //
    //    //    [self.view addSubview:indicator];
    //    //    [indicator bringSubviewToFront:self.view];
    //    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    //    //    [indicator startAnimating];
    //    [self performSelector:@selector(regOrDeRegClassNow) withObject:nil afterDelay:0.1];
    
    
    
    // Else Book This Class for you
}

-(void)regOrDeRegClassNow
{
    
    NSMutableDictionary *dictResultClassList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicBookClassSubmit];
    
    NSLog(@"dictResultClassList = %@",dictResultClassList);
    
    //device_type=android/ios&device_token
    
    if ([[dictResultClassList objectForKey:@"ok"]integerValue] == 1) {
        
        //  [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassList objectForKey:@"msg"]]];
        
        if ([lblClassStatus.text isEqualToString:@"BOOK THIS CLASS"]) {
            lblClassStatus.text = @"CANCEL THIS CLASS";
        }
        else
        {
            lblClassStatus.text = @"BOOK THIS CLASS";
            
        }
        
        [self callWebserviceForClassDetails:row_num];
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassList objectForKey:@"msg"]]];
    }
    
    
    //  [indicator stopAnimating];
    
}

@end
