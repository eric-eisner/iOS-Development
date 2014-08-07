//
//  DeleteEvents.h
//  BudgIt
//
//  Created by Eric Eisner on 6/19/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event;
@class WeekTotal;

@protocol AddEvents <NSObject>

-(void)eventAdded:(BOOL)isBill WithNullEvent:(BOOL)null WithEvent:(Event *)event WithWeekTotal:(WeekTotal *)weekTotal;

@end

@protocol EditEvents <NSObject>

-(void)eventEditted:(BOOL)isBill WithEvent:(Event *)event WithNetChange:(NSNumber *)change;

@end

@protocol DeleteEvents <NSObject>

-(void)eventDeleted:(BOOL)isBill WithEvent:(Event *)event;

@end

@protocol CheckInput <NSObject>

-(BOOL)validAmount;
-(BOOL)validDate;
-(BOOL)validName;

@end