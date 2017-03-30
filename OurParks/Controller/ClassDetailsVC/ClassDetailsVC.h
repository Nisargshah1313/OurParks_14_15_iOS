//
//  ClassDetailsVC.h
//  OurParks
//
//  Created by Darshil Shah on 08/08/15.
//
//

#import <UIKit/UIKit.h>

@interface ClassDetailsVC : UIViewController
{
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
    
    UIActivityIndicatorView *indicator;
    NSMutableDictionary *dicBookClassSubmit;
    
    NSMutableDictionary *dicClassDetailSubmit1;
        
}

- (IBAction)btnBookCancelClassClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *txtVwDetails;

@property (nonatomic,retain) NSMutableDictionary *dicClassDetails;

@property (nonatomic,retain) NSMutableDictionary *dicPrevClassDetails;

@property (nonatomic, assign) int row_num;

@property (nonatomic,retain) NSMutableArray *arrAllClassDataPrev;

@property (nonatomic,retain) NSString *strIsFromClass;

@end
