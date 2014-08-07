//
//  Deposit.h
//  BudgIt
//
//  Created by Eric Eisner on 5/20/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Deposit;

@interface Deposit : Event

@property (nonatomic, retain) NSOrderedSet *repeatDeposits;
@end

@interface Deposit (CoreDataGeneratedAccessors)

- (void)insertObject:(Deposit *)value inRepeatDepositsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRepeatDepositsAtIndex:(NSUInteger)idx;
- (void)insertRepeatDeposits:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRepeatDepositsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRepeatDepositsAtIndex:(NSUInteger)idx withObject:(Deposit *)value;
- (void)replaceRepeatDepositsAtIndexes:(NSIndexSet *)indexes withRepeatDeposits:(NSArray *)values;
- (void)addRepeatDepositsObject:(Deposit *)value;
- (void)removeRepeatDepositsObject:(Deposit *)value;
- (void)addRepeatDeposits:(NSOrderedSet *)values;
- (void)removeRepeatDeposits:(NSOrderedSet *)values;
@end
