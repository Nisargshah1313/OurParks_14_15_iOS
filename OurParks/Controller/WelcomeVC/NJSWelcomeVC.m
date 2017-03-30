//
//  NJSWelcomeVC.m
//  PropertyXP
//
//  Created by Nisarg Shah on 13/10/14.
//  Copyright (c)  2015  . All rights reserved.
//

#import "NJSWelcomeVC.h"

//static NSString * const sampleDesc1 = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tincidunt laoreet diam, id suscipit ipsum sagittis a. ";
//
//static NSString * const sampleDesc2 = @" Suspendisse et ultricies sem. Morbi libero dolor, dictum eget aliquam quis, blandit accumsan neque. Vivamus lacus justo, viverra non dolor nec, lobortis luctus risus.";
//
//static NSString * const sampleDesc3 = @"In interdum scelerisque sem a convallis. Quisque vehicula a mi eu egestas. Nam semper sagittis augue, in convallis metus";
//
//static NSString * const sampleDesc4 = @"Praesent ornare consectetur elit, in fringilla ipsum blandit sed. Nam elementum, sem sit amet convallis dictum, risus metus faucibus augue, nec consectetur tortor mauris ac purus.";
//
//static NSString * const sampleDesc5 = @"Sed rhoncus arcu nisl, in ultrices mi egestas eget. Etiam facilisis turpis eget ipsum tempus, nec ultricies dui sagittis. Quisque interdum ipsum vitae ante laoreet, id egestas ligula auctor";

@interface NJSWelcomeVC ()<GHWalkThroughViewDataSource>

@end

@implementation NJSWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _ghView = [[GHWalkThroughView alloc] initWithFrame:self.view.bounds];
    [_ghView setDataSource:self];
    [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionVertical];
    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    welcomeLabel.text = @"Welcome";
    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:40];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    self.welcomeLabel = welcomeLabel;
    
    //    self.descStrings = [NSArray arrayWithObjects:sampleDesc1,sampleDesc2, sampleDesc3, sampleDesc4, sampleDesc5, nil];
    
    self.ghView.floatingHeaderView = nil;
    [self.ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    
    [self.ghView showInView:self.view animateDuration:0.3];
}


#pragma mark - GHDataSource

-(NSInteger) numberOfPages
{
    return 4;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{
    cell.title = [NSString stringWithFormat:@""];
    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld",(long)index+1]];
    cell.desc = [self.descStrings objectAtIndex:index];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
 //   CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    NSString* imageName;
   // if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        if (screenSize.height > 480.0f) {
//            imageName =[NSString stringWithFormat:@"bg_0%ld.png",(long) index+1];
//        }
//        else
//        {
            imageName =[NSString stringWithFormat:@"Welcome_%ld.jpg", (long)index+1];
      //  }
//    }
//    else
//    {
//         imageName =[NSString stringWithFormat:@"0%ld_iPad.png", (long)index+1];
//    }
        
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
