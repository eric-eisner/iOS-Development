//
//  Month.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/10/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    NONE = 0,
    JANUARY,
    FEBRUARY,
    MARCH,
    APRIL,
    MAY,
    JUNE,
    JULY,
    AUGUST,
    SEPTEMBER,
    OCTOBER,
    NOVEMBER,
    DECEMBER,
} Name;

@interface Month : NSObject

@property(nonatomic) Name name;
@property(nonatomic) NSInteger numberOfDays;

-(id)init;
-(id)initWithName:(NSString*)name;
-(id)initWithNumber:(NSInteger)num;
-(NSString*)getStringName;

@end
