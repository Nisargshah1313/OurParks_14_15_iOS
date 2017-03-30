//
//  CoachStudentListVC.h
//  OurParks
//
//  Created by Darshil Shah on 29/10/15.
//
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface CoachStudentListVC : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIActivityIndicatorView *indicator;
    NSMutableDictionary *dicStudentListSubmit;
    
    NSMutableArray *arrStudentList;
    
    UILabel *lblClassStatus;
    UILabel *lblClassName;
    UILabel *lblClassLocation;
    
    UILabel *lblClassDate;
    UILabel *lblClassDay;
    UILabel *lblClassMonth;
    
    UILabel *lblClassStartTime;
    UILabel *lblClassEndTime;
    
    UILabel *lblClassAttendees; //ATTENDEES
    UILabel *lblClassExertion; //EXERTION
    
    NSMutableDictionary *dicForStudentSubmit;
}

- (IBAction)btnAddNewAttendeeClicked:(id)sender;

- (IBAction)btnAddParkerClicked:(id)sender;

@property (nonatomic,retain) NSMutableDictionary *dicOldDetails;

@property (nonatomic,retain) NSMutableDictionary *dicAllDetails;
@property (weak, nonatomic) IBOutlet UITableView *tblVwStudentList;
@property (strong, nonatomic) IBOutlet UITableViewCell *customTblViewCell;

@end
