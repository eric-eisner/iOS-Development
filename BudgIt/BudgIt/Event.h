//
//  Event.h
//  BudgIt
//
//  Created by Eric Eisner on 5/18/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * frequency;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * repeat;
@property (nonatomic, retain) NSNumber * amount;

@end
