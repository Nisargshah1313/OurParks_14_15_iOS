//
//  ClassListAllVC.h
//  OurParks
//
//  Created by Darshil Shah on 05/09/15.
//
//

#import <UIKit/UIKit.h>

@interface ClassListAllVC : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrAllClasses;
    
    NSMutableDictionary *dicClassDetailSubmit;
    
    UIActivityIndicatorView *indicator;
}

@property (weak, nonatomic) IBOutlet UITableView *tbl_AllClassList;
@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@property (nonatomic,retain) NSMutableDictionary *dicAllDetails;
//@property (nonatomic,retain) NSMutableArray *arrAllMembersDetails;

@property (nonatomic,retain) NSString *strSearchedUnitNumber;

@end
