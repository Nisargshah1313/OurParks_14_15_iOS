//
//  AddParkerVC.h
//  OurParks
//
//  Created by Darshil Shah on 03/11/15.
//
//

#import <UIKit/UIKit.h>

@interface AddParkerVC : UIViewController
{
    UIActivityIndicatorView *indicator;
    NSMutableDictionary *dicAddParkerSubmit;
}
- (IBAction)btnAddParkerClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEmailAdd;

@property (nonatomic,retain) NSMutableDictionary *dicPrevScreenDetails;


@end
