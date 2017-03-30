//
//  WebServiceHelperVC.h
//  Zooffer
//
//  Created by MERCEDES on 11/29/13.
//  Copyright (c) 2013 Shashi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WebServiceDelegate <NSObject>
- (void)webserviceConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)webserviceConnectionDidFinishLoading:(NSURLConnection *)connection successFullyGotData:(NSMutableData *)data currentReqMethod:(NSString *)strCurrentReqMethod;



@end


@interface WebServiceHelperVC : UIViewController <UITextFieldDelegate>{
    
}


@property(nonatomic,retain)id <WebServiceDelegate> delegate;


@property(nonatomic,strong)NSString *jsonString;
@property(nonatomic,strong)NSString *methodType;
@property(nonatomic,strong)NSString *strURL;
@property(nonatomic,strong)NSString *strCurrentRequestMethod;


@property(nonatomic,strong)NSMutableData *responseData;

-(NSMutableDictionary *)PostDataWithImage:(UIImage *)image1 image2:(UIImage*)imgae2 withParameter:(NSMutableDictionary *)dictParameters withImagekey1:(NSString *)strImageKey1 withImagekey2:(NSString *)strImageKey2;

- (NSMutableDictionary *)sendRequestWithParameter:(NSMutableDictionary *)dictDetail;

-(void)PostData;
-(void)GetData;
-(BOOL)isValidEmail:(NSString *)strEmail;

+(WebServiceHelperVC *) wsVC;

@end
