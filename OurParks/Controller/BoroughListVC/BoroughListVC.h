//
//  BoroughListVC.h
//  OurParks
//
//  Created by Darshil Shah on 02/09/15.
//
//

#import <UIKit/UIKit.h>

@interface BoroughListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIActivityIndicatorView *indicator;
    
    NSMutableDictionary *dicBoroughSubmit;
    NSMutableArray *arr_ResponseData;
    
    NSMutableDictionary *dicAllResponseData;
    NSMutableArray *arrBoroughList;
    
    NSMutableDictionary *dicClassByBoroughSubmit;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tbl_BoroughList;
@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;
@end
