//
//  Bill.h
//  BudgIt
//
//  Created by Eric Eisner on 5/20/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Bill;

@interface Bill : Event

@property (nonatomic, retain) NSDate * reminder1;
@property (nonatomic, retain) NSDate * reminder2;
@property (nonatomic, retain) NSOrderedSet *repeatBills;
@end

@interface Bill (CoreDataGeneratedAccessors)

- (void)insertObject:(Bill *)value inRepeatBillsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRepeatBillsAtIndex:(NSUInteger)idx;
- (void)insertRepeatBills:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRepeatBillsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRepeatBillsAtIndex:(NSUInteger)idx withObject:(Bill *)value;
- (void)replaceRepeatBillsAtIndexes:(NSIndexSet *)indexes withRepeatBills:(NSArray *)values;
- (void)addRepeatBillsObject:(Bill *)value;
- (void)removeRepeatBillsObject:(Bill *)value;
- (void)addRepeatBills:(NSOrderedSet *)values;
- (void)removeRepeatBills:(NSOrderedSet *)values;
@end
