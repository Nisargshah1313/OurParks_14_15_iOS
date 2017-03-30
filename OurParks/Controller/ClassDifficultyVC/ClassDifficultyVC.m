//
//  ClassDifficultyVC.m
//  OurParks
//
//  Created by Darshil Shah on 21/08/15.
//
//

#import "ClassDifficultyVC.h"
#import "ClassListAllVC.h"

@interface ClassDifficultyVC ()

@end

@implementation ClassDifficultyVC
@synthesize tblDifficulty,customTblViewCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dicClassByExertionSubmit = [[NSMutableDictionary alloc]init];
    
    arrDifficultyOpt = [[NSMutableArray alloc]initWithObjects:@"EASY",@"MODERATE",@"HARD", nil];
    
    arrDifficultyOptDetail = [[NSMutableArray alloc]initWithObjects:@"Gentle light workout, particularly suitable for pre and ante natal, those new to exercise.",@"Light to moderate workout. Those looking for a more intense workout will be catered for in these classes.",@"A more intense workout suitable for those to challenge themselves or who regularly attend gym.", nil];
    
    [tblDifficulty reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger finalCountOfRow = 3;
    
    return finalCountOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"customDiffCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"DifficultyVCcell" owner:self options:nil];
        cell = customTblViewCell;
        
        customTblViewCell=nil;
    }
    
    UIImageView *imgCellBg = (UIImageView *)[cell.contentView viewWithTag:20];
    
    UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:21];
    
    UILabel *lblSubTitle = (UILabel *)[cell.contentView viewWithTag:22];
    
//    lblSubTitle.textAlignment = NSTextAlignmentCenter;
//    
//    [lblSubTitle setNumberOfLines:0];
//    
//    [lblSubTitle sizeToFit];
    
    lblTitle.text = [NSString stringWithFormat:@"%@",[arrDifficultyOpt objectAtIndex:indexPath.row]];
    lblSubTitle.text = [NSString stringWithFormat:@"%@",[arrDifficultyOptDetail objectAtIndex:indexPath.row]];
    
    imgCellBg.image = [UIImage imageNamed:[NSString stringWithFormat:@"DiffOpt%ld.png",(long)indexPath.row+1]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
        
          [self callWebserviceForClassesInExertion:(int)indexPath.row];
//        BookClassesVC *bcvc = [[BookClassesVC alloc]initWithNibName:@"BookClassesVC" bundle:nil];
//        [self.navigationController pushViewController:bcvc animated:YES];
 
}

-(void)callWebserviceForClassesInExertion:(int)rowNum

{
    
    [WebServiceHelperVC wsVC].strURL = [NSString stringWithFormat:@"%@",ServerURL];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID]) {
        [dicClassByExertionSubmit setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:@"uid"];
    }

    [dicClassByExertionSubmit setObject:methodBrowseByExertion forKey:@"ac"];
    if (rowNum == 0) {
        [dicClassByExertionSubmit setObject:GreenExertion forKey:@"exertion"];
    }
    else if (rowNum == 1) {
        [dicClassByExertionSubmit setObject:BlueExertion forKey:@"exertion"];
    }
    else
    {
            [dicClassByExertionSubmit setObject:RedExertion forKey:@"exertion"];
    }
    
    //[dicClassByExertionSubmit setObject:[[arrBoroughList objectAtIndex:rowNum]objectForKey:@"nid"] forKey:@"id"];
    [WebServiceHelperVC wsVC].methodType = @"POST";
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat widthFrame = [UIScreen mainScreen].bounds.size.width;
    CGFloat heightFrame = [UIScreen mainScreen].bounds.size.height;
    
    indicator.frame =  CGRectMake(widthFrame / 2 , heightFrame / 2 , indicator.frame.size.width, indicator.frame.size.height);
    
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    [indicator startAnimating];
    [self performSelector:@selector(getClassListNow) withObject:nil afterDelay:0.1];
    
   
}

-(void)getClassListNow
{
    
    NSMutableDictionary *dictResultClassList = [[WebServiceHelperVC wsVC] sendRequestWithParameter:dicClassByExertionSubmit];
    
    
    //device_type=android/ios&device_token
    
    if ([[dictResultClassList objectForKey:@"ok"]integerValue] == 1) {
        
        if ([dictResultClassList objectForKey:@"classes"]!= nil && [dictResultClassList objectForKey:@"classes"] != NULL) {
            
            ClassListAllVC *clavc = [[ClassListAllVC alloc]initWithNibName:@"ClassListAllVC" bundle:nil];
            clavc.dicAllDetails = dictResultClassList;
            [self.navigationController pushViewController:clavc animated:YES];
        }
        //        arrBoroughList = [dictResultClassList objectForKey:@"data"];
        //
        //        [tbl_BoroughList reloadData];
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
