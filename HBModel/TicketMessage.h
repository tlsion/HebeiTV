//
//  TicketMessage.h
//  HebeiTV
//
//  Created by Pro on 6/5/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TicketMessage : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSNumber * is_read;

@end
