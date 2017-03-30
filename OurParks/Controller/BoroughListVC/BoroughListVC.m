//
//  BoroughListVC.m
//  OurParks
//
//  Created by Darshil Shah on 02/09/15.
//
//

#import "BoroughListVC.h"
#import "ClassListAllVC.h"

@interface BoroughListVC ()

@end

@implementation BoroughListVC
@synthesize tbl_BoroughList,customTblViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    
    //self.title = @"";
    
    //    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"] style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    //self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    arrBoroughList = [[NSMutableArray alloc]init];
    dicClassByBoroughSubmit = [[NSMutableDictionary alloc]init];
    
    if ([appDelOurParks connecttonetwork]) {
        
        dicBoroughSubmit = [[NSMutableDictionary alloc]init];
        
        [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
        [dicBoroughSubmit setObject:@"list_borough" forKey:@"ac"];
        [WebServiceHelperVC wsVC].methodType = @"POST";
        [self performSelector:@selector(callWebServiceForBoroughList) withObject:nil afterDelay:0.1];
    }
    else
    {
        [appDelOurParks showAlert:@"No Network Connection available"];
    }
    //methodInstantPoll
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger finalCountOfRow = arrBoroughList.count;
    
    return finalCountOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customBoroughCellIdentimfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"BoroughListcell" owner:self options:nil];
        cell = customTblViewCell;
        
        customTblViewCell=nil;
    }
    
    
    UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:21];
    
    UILabel *lblSubTitle = (UILabel *)[cell.contentView viewWithTag:22];
    
    lblTitle.text = [NSString stringWithFormat:@"%@",[[arrBoroughList objectAtIndex:indexPath.row]objectForKey:@"title"]];
    
    NSString *strNumberOfParks = [[arrBoroughList objectAtIndex:indexPath.row]objectForKey:@"parks"];
    
    if (strNumberOfParks.length>1) {
        lblSubTitle.text = [NSString stringWithFormat:@"%@",[[arrBoroughList objectAtIndex:indexPath.row]objectForKey:@"parks"]];
    }
    else
    {
        lblSubTitle.text = [NSString stringWithFormat:@"0%@",[[arrBoroughList objectAtIndex:indexPath.row]objectForKey:@"parks"]];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self callWebserviceForClassesInBorough:(int)indexPath.row];
    
    
    //    if (indexPath.row == 0) {
    //
    //        BookClassesVC *bcvc = [[BookClassesVC alloc]initWithNibName:@"BookClassesVC" bundle:nil];
    //        [self.navigationController pushViewController:bcvc animated:YES];
    //    }
    //    else if (indexPath.row == 2)
    //    {
    //
    //    }
}

-(void)callWebserviceForClassesInBorough:(int)rowNum
{
    //ac : browse_by_borough and id : borough_id

    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    [dicClassByBoroughSubmit setObject:@"browse_by_borough" forKey:@"ac"];
    [dicClassByBoroughSubmit setObject:[[arrBoroughList objectAtIndex:rowNum]objectForKey:@"nid"] forKey:@"id"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
        [dicClassByBoroughSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    }
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    [self performSelector:@selector(getClassList) withObject:nil afterDelay:0.1];
    
}

-(void)getClassList
{
   
    NSMutableDictionary *dictResultClassList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassByBoroughSubmit];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResultClassList objectForKey:@"ok"]integerValue] == 1) {
        if ([dictResultClassList objectForKey:@"classes"]!= nil && [dictResultClassList objectForKey:@"classes"] != NULL) {
            
            ClassListAllVC *clavc = [[ClassListAllVC alloc]initWithNibName:@"ClassListAllVC" bundle:nil];
            clavc.dicAllDetails = dictResultClassList;
            [self.navigationController pushViewController:clavc animated:YES];
        }
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassList objectForKey:@"msg"]]];
    }

    [indicator stopAnimating];
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


-(void)callWebServiceForBoroughList
{
    NSMutableDictionary *dictResultBoroughList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicBoroughSubmit];
    
    if (arr_ResponseData.count>0) {
        [arr_ResponseData removeAllObjects];
        arr_ResponseData=[[NSMutableArray alloc]init];
    }
    
    //device_type=android/ios&device_token
    
    if ([[dictResultBoroughList objectForKey:@"ok"]integerValue] == 1) {
        
        arrBoroughList = [dictResultBoroughList objectForKey:@"data"];
        
        [tbl_BoroughList reloadData];
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultBoroughList objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
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
