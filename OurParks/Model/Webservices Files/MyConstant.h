//
//  Created by Shashi Chunara on 08/08/13.
//  Copyright (c) 2013 Shashi Chunara. All rights reserved.
//

#ifndef appNotifier_MyConstant_h
#define appNotifier_MyConstant_h




#define FBAppIDkey @""




#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)









#pragma mark -  User Constants

#define UserLoggedIn @"UserLoggedIn"

#define LoginType @"LoginType"
#define ProfileID @"ProfileID"
#define ProfileName @"ProfileName"
#define ProfileUserName @"ProfileUserName"

#define ProfileScreenName @"ProfileScreenName"
#define ProfilePassword @"ProfilePassword"
#define ProfileEmail @"ProfileEmail"
#define ProfileGenderType @"ProfileGenderType"

#define ProfileFacebookID @"ProfileFacebookID"
#define ProfilePicture @"ProfilePicture"

#define ProfileTwitterID @"ProfileTwitterID"

#define ProfilePhone @"ProfilePhone"

#define ProfileNLike @"ProfileNLike"
#define ProfileNPhoto @"ProfileNPhoto"


#define ProfileBirthDate @"ProfileBirthDate"







#pragma mark -  CellIdentifier

#define RearCellIdentifier @"RearCellIdentifier"



#pragma mark -  IBOutlets Tags



#define ScrollViewTag 9
#define TableViewTag 10








#endif
