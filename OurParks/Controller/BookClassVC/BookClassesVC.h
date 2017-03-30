//
//  BookClassesVC.h
//  OurParks
//
//  Created by Darshil Shah on 07/08/15.
//
//

#import <UIKit/UIKit.h>

@interface BookClassesVC : UIViewController
{
    UIActivityIndicatorView *indicator;
    
    NSMutableDictionary *dicBookClassSubmit;
    
}
- (IBAction)btnSearchClassesClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchbox;

@end
