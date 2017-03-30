//
//  SignUpVC.h
//  OurParks
//
//  Created by Nisarg Shah on 30/07/15.
//
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController<UIWebViewDelegate,UINavigationControllerDelegate>
{
    UIActivityIndicatorView *indicator;
}

@property (nonatomic,retain) NSString *strDirectWebVwUrl;
@property (nonatomic,retain) NSString *strViewTitle;
@property (nonatomic,retain) NSString *strFromSignUpClick;

@property (weak, nonatomic) IBOutlet UIWebView *webVw;
@end
