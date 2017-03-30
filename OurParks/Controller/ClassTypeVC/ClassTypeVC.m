//
//  ClassTypeVC.m
//  OurParks
//
//  Created by Darshil Shah on 08/10/15.
//
//

#import "ClassTypeVC.h"
#import "ClassListAllVC.h"

@interface ClassTypeVC ()

@end

@implementation ClassTypeVC
@synthesize tbl_ClassTypeList,customTblViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dicClassByTypeSubmit = [[NSMutableDictionary alloc]init];
    
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
    
    arrClassTypeList = [[NSMutableArray alloc]init];
    if ([appDelOurParks connecttonetwork]) {
        
        dicTypeSubmit = [[NSMutableDictionary alloc]init];
        
        [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
        [dicTypeSubmit setObject:methodClassType forKey:@"ac"];
        [WebServiceHelperVC wsVC].methodType = @"POST";
        [self performSelector:@selector(callWebServiceForClassTypeList) withObject:nil afterDelay:0.1];
    }
    else
    {
        [appDelOurParks showAlert:@"No Network Connection available"];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger finalCountOfRow = arrClassTypeList.count;
    
    return finalCountOfRow;
    //return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customClassTypeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ClassTypecell" owner:self options:nil];
        cell = customTblViewCell;
        
        customTblViewCell=nil;
    }
    
    
    UILabel *lblClassType = (UILabel *)[cell.contentView viewWithTag:22];
    
   UIImageView *imgType = (UIImageView *)[cell.contentView viewWithTag:21];
    
    lblClassType.text = [NSString stringWithFormat:@"%@",[[arrClassTypeList objectAtIndex:indexPath.row]objectForKey:@"title"]];
    
    [imgType setImageWithURL:[NSURL URLWithString:[[arrClassTypeList objectAtIndex:indexPath.row]objectForKey:@"logo"]] placeholderImage:Nil];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self callWebserviceForClassesInType:(int)indexPath.row];
}

-(void)callWebserviceForClassesInType:(int)rowNum
{
    
    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    [dicClassByTypeSubmit setObject:methodBrowseByType forKey:@"ac"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
        [dicClassByTypeSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    }
    
    [dicClassByTypeSubmit setObject:[[arrClassTypeList objectAtIndex:rowNum] objectForKey:@"tid"] forKey:@"tid"];
    //uid
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    [self performSelector:@selector(getClassListClassType) withObject:nil afterDelay:0.1];
    
}

-(void)getClassListClassType
{
    NSMutableDictionary *dictResultClassList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassByTypeSubmit];
    
    
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

-(void)callWebServiceForClassTypeList
{
    NSMutableDictionary *dictResultClassTypeList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicTypeSubmit];
    
    if (arr_ResponseData.count>0) {
        [arr_ResponseData removeAllObjects];
        arr_ResponseData=[[NSMutableArray alloc]init];
    }
    
    //device_type=android/ios&device_token
    
    if ([[dictResultClassTypeList objectForKey:@"ok"]integerValue] == 1) {
        
        arrClassTypeList = [dictResultClassTypeList objectForKey:@"data"];
        
        [tbl_ClassTypeList reloadData];
    }
    else
    {
        [appDelOurParks showAlert:[NSString stringWithFormat:@"%@",[dictResultClassTypeList objectForKey:@"msg"]]];
    }
    
    [indicator stopAnimating];
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
