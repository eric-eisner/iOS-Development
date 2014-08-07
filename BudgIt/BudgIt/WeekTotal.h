//
//  WeekTotal.h
//  BudgIt
//
//  Created by Eric L Eisner on 5/14/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeekTotal : NSManagedObject

@property (nonatomic, retain) NSDate * begin;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSNumber * endBalance;
@property (nonatomic, retain) NSNumber * beginBalance;
@property (nonatomic, retain) NSNumber * netChanges;

@end
