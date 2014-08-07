//
//  BillDepositProtocols.h
//  BudgIt
//
//  Created by Eric Eisner on 6/20/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ReminderPicker <NSObject>;

-(void)setReminderWithValue:(NSString*)value;

@end

@protocol FrequencyPicker <NSObject>

-(void)setFrequencyWithValue:(NSString*)value;

@end
