//
//  MyClassVC.h
//  OurParks
//
//  Created by Darshil Shah on 21/08/15.
//
//

#import <UIKit/UIKit.h>

@interface MyClassVC : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIActivityIndicatorView *indicator;
    
    NSMutableDictionary *dicBookedClassSubmit;
    NSMutableArray *arr_ResponseData1;
    
    NSMutableDictionary *dicAllResponseData1;
    NSMutableArray *arrBookedClassList;
    
    NSMutableDictionary *dicClassHistorySubmit;
    NSMutableArray *arr_ResponseData2;
    
    NSMutableDictionary *dicAllResponseData2;
    NSMutableArray *arrClassHistoryList;
    
    UIButton *btnBookedClass;
    UIButton *btnClassHistory;
    
    BOOL isBookedClassSelected;
    
    NSMutableDictionary *dicClassDetailSubmit;
    
}

- (IBAction)btnBookedClassClicked:(id)sender;

- (IBAction)btnClassHistoryClicked:(id)sender;


@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@property (weak, nonatomic) IBOutlet UITableView *tblMyClassesList;

@end
