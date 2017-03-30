//
//  Created by Nisarg Shah.
//  Copyright (c) 2015 Nisarg Shah. All rights reserved.
//

#ifndef appNotifier_GlobalWebService_h
#define appNotifier_GlobalWebService_h




#define ServerURL @"http://ourparks-dev.tranquildigital.com/json-feed/api2"

#define methodLogin @"me"

#define methodHome @"home_screen"

#define methodClassList @"class_list"

#define methodClassType @"list_class_type"

#define methodBrowseByType @"browse_by_type"

#define methodBoroughList @"list_borough"

#define methodBrowseByExertion @"browse_by_exertion"



#define GreenExertion @"Green = light gentle exercise"
#define BlueExertion @"Blue = moderate exercise"
#define RedExertion @"Black = high heart rate exercise"


//(1) For the class history list use the following one.
//
//For instructor:
//
//URL: http://www.ourpars.org.uk/json-feed/api2
//
//POST Data Parameter: {“ac”: “ih”,”uid”:user id}
//
//For student:
//
//URL: http://www.ourpars.org.uk/json-feed/api2
//
//POST Data Parameter: {“ac”: “sh”,”uid”:user id}



#define image1value .2
#define image2value .8

#endif
