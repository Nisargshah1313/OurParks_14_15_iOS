//
//  ClassDifficultyVC.h
//  OurParks
//
//  Created by Darshil Shah on 21/08/15.
//
//

#import <UIKit/UIKit.h>

@interface ClassDifficultyVC : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrDifficultyOpt;
     NSMutableArray *arrDifficultyOptDetail;
    
    NSMutableDictionary *dicClassByExertionSubmit;
    UIActivityIndicatorView *indicator;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@property (weak, nonatomic) IBOutlet UITableView *tblDifficulty;

@end
