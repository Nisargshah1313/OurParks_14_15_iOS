//
//  WebServiceHelperVC.m
//  Zooffer
//
//  Created by MERCEDES on 11/29/13.
//  Copyright (c) 2013 Shashi. All rights reserved.
//

#import "WebServiceHelperVC.h"
#import "NSData+Base64.h"

static WebServiceHelperVC *wsVC;


@interface WebServiceHelperVC ()

@end

@implementation WebServiceHelperVC
@synthesize jsonString,strURL,delegate,methodType;
@synthesize responseData,strCurrentRequestMethod;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

+(WebServiceHelperVC *) wsVC{
	
	if(!wsVC){
		wsVC = [[WebServiceHelperVC alloc] init];
	}
	
	return wsVC;
	
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
#pragma mark - 

-(void)PostData{
    responseData = [NSMutableData data];    
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strURL]];
    [request setHTTPMethod:methodType];
    [request setValue:@"application/x-www-form-urlencoded;" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"utf-8" forHTTPHeaderField:@"Encoding"];

    [request setHTTPBody:body];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    

}

-(NSMutableDictionary *)PostDataWithImage:(UIImage *)image1 image2:(UIImage*)imgae2 withParameter:(NSMutableDictionary *)dictParameters withImagekey1:(NSString *)strImageKey1 withImagekey2:(NSString *)strImageKey2
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:strURL]];
    [request setHTTPMethod:@"POST"];
    
    NSString *base64EncodedImage1 = [UIImageJPEGRepresentation(image1, 0.1) base64EncodingWithLineLength:0];
    
   NSString *base64EncodedImage2= [UIImageJPEGRepresentation(imgae2, 0.1) base64EncodingWithLineLength:0];
    
    [dictParameters setObject:base64EncodedImage1 forKey:strImageKey1];
    
    [dictParameters setObject:base64EncodedImage2 forKey:strImageKey2];
    
    NSData *dicData = [self encodeDictionary:dictParameters];
    [request setValue:[NSString stringWithFormat:@"%ld",(long) dicData.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:dicData];
    
    NSError *error=nil;
    NSHTTPURLResponse *resultResponse = nil;
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resultResponse error:&error];
      NSLog(@"~~~~~ Status code: %ld", (long)[resultResponse statusCode]);
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    NSMutableDictionary *dictResult =[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
    
    return dictResult;
    
}
- (NSMutableDictionary *)sendRequestWithParameter:(NSMutableDictionary *)dictDetail
{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:strURL]];
    [request setHTTPMethod:methodType];
    
    NSLog(@"%@",strURL);
    
    NSData *body = [self encodeDictionary:dictDetail];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)body.length] forHTTPHeaderField:@"Content-Length"];
   [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    NSError *error=nil;
      NSHTTPURLResponse *resultResponse = nil;
    // Perform request and get JSON back as a NSData object
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&resultResponse error:&error];
    NSLog(@"~~~~~ Status code: %ld", (long)[resultResponse statusCode]);
//    if ([resultResponse statusCode]>=200 && [resultResponse statusCode]<300) {
    
    if (returnData!=nil && returnData!=NULL)
    {
        NSMutableDictionary *dictResult =[NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers error:nil];
        
        return dictResult;
    }
    
//    }
    else
    {
        [appDelOurParks showAlert:@"Server is not connected"];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Server is not connected" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
        return nil;
    }
    // Get JSON as a NSString from NSData response
    // NSError *jsonError = nil;
 //method = showCategory;
}


- (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"\"%@\":\"%@\"", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionaryOld = [parts componentsJoinedByString:@","];
    NSString *encodedDictionary = [NSString stringWithFormat:@"{%@}",encodedDictionaryOld];
    
    encodedDictionary = [encodedDictionary stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    NSLog(@"parameter:%@",encodedDictionary);
    
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}
-(void)GetData{
    
}

-(BOOL)isValidEmail:(NSString *)strEmail{
    NSString *emailRegex = @"[A-Z0-9a-z][A-Z0-9a-z._%+-]*@[A-Za-z0-9][A-Za-z0-9.-]*\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSRange aRange;
    if([emailTest evaluateWithObject:strEmail]) {
        aRange = [strEmail rangeOfString:@"." options:NSBackwardsSearch range:NSMakeRange(0, [strEmail length])];
        int indexOfDot = (int)aRange.location;
       
        if(aRange.location != NSNotFound) {
            NSString *topLevelDomain = [strEmail substringFromIndex:indexOfDot];
            topLevelDomain = [topLevelDomain lowercaseString];
            
            NSSet *TLD;
            TLD = [NSSet setWithObjects:@".aero", @".asia", @".biz", @".cat", @".com", @".coop", @".edu", @".gov", @".info", @".int", @".jobs", @".mil", @".mobi", @".museum", @".name", @".net", @".org", @".pro", @".tel", @".travel", @".ac", @".ad", @".ae", @".af", @".ag", @".ai", @".al", @".am", @".an", @".ao", @".aq", @".ar", @".as", @".at", @".au", @".aw", @".ax", @".az", @".ba", @".bb", @".bd", @".be", @".bf", @".bg", @".bh", @".bi", @".bj", @".bm", @".bn", @".bo", @".br", @".bs", @".bt", @".bv", @".bw", @".by", @".bz", @".ca", @".cc", @".cd", @".cf", @".cg", @".ch", @".ci", @".ck", @".cl", @".cm", @".cn", @".co", @".cr", @".cu", @".cv", @".cx", @".cy", @".cz", @".de", @".dj", @".dk", @".dm", @".do", @".dz", @".ec", @".ee", @".eg", @".er", @".es", @".et", @".eu", @".fi", @".fj", @".fk", @".fm", @".fo", @".fr", @".ga", @".gb", @".gd", @".ge", @".gf", @".gg", @".gh", @".gi", @".gl", @".gm", @".gn", @".gp", @".gq", @".gr", @".gs", @".gt", @".gu", @".gw", @".gy", @".hk", @".hm", @".hn", @".hr", @".ht", @".hu", @".id", @".ie", @" No", @".il", @".im", @".in", @".io", @".iq", @".ir", @".is", @".it", @".je", @".jm", @".jo", @".jp", @".ke", @".kg", @".kh", @".ki", @".km", @".kn", @".kp", @".kr", @".kw", @".ky", @".kz", @".la", @".lb", @".lc", @".li", @".lk", @".lr", @".ls", @".lt", @".lu", @".lv", @".ly", @".ma", @".mc", @".md", @".me", @".mg", @".mh", @".mk", @".ml", @".mm", @".mn", @".mo", @".mp", @".mq", @".mr", @".ms", @".mt", @".mu", @".mv", @".mw", @".mx", @".my", @".mz", @".na", @".nc", @".ne", @".nf", @".ng", @".ni", @".nl", @".no", @".np", @".nr", @".nu", @".nz", @".om", @".pa", @".pe", @".pf", @".pg", @".ph", @".pk", @".pl", @".pm", @".pn", @".pr", @".ps", @".pt", @".pw", @".py", @".qa", @".re", @".ro", @".rs", @".ru", @".rw", @".sa", @".sb", @".sc", @".sd", @".se", @".sg", @".sh", @".si", @".sj", @".sk", @".sl", @".sm", @".sn", @".so", @".sr", @".st", @".su", @".sv", @".sy", @".sz", @".tc", @".td", @".tf", @".tg", @".th", @".tj", @".tk", @".tl", @".tm", @".tn", @".to", @".tp", @".tr", @".tt", @".tv", @".tw", @".tz", @".ua", @".ug", @".uk", @".us", @".uy", @".uz", @".va", @".vc", @".ve", @".vg", @".vi", @".vn", @".vu", @".wf", @".ws", @".ye", @".yt", @".za", @".zm", @".zw", nil];
            if(topLevelDomain != nil && ([TLD containsObject:topLevelDomain])) {
                //NSLog(@"TLD contains topLevelDomain:%@",topLevelDomain);
                return TRUE;
            }
            /*else {
             NSLog(@"TLD DOEST NOT contains topLevelDomain:%@",topLevelDomain);
             }*/
            
        }
    }

    return FALSE;
    
}


#pragma mark -
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if ([delegate respondsToSelector:@selector(webserviceConnection:didFailWithError:)]) {
        [delegate webserviceConnection:connection didFailWithError:error];
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if ([delegate respondsToSelector:@selector(webserviceConnectionDidFinishLoading:successFullyGotData:currentReqMethod:)]) {
        [delegate webserviceConnectionDidFinishLoading:connection successFullyGotData:responseData currentReqMethod:strCurrentRequestMethod];
    }
}


#pragma mark -
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [self setResponseData:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
