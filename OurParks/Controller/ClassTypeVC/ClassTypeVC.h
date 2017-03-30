//
//  ClassTypeVC.h
//  OurParks
//
//  Created by Darshil Shah on 08/10/15.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface ClassTypeVC : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIActivityIndicatorView *indicator;
    
    NSMutableDictionary *dicTypeSubmit;
    NSMutableArray *arr_ResponseData;
    
    NSMutableDictionary *dicAllResponseData;
    NSMutableArray *arrClassTypeList;
    
    NSMutableDictionary *dicClassByTypeSubmit;
}
@property (weak, nonatomic) IBOutlet UITableView *tbl_ClassTypeList;
@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@end
