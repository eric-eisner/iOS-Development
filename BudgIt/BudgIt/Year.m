//
//  Year.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/10/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "Year.h"

@implementation Year

-(id)init
{
    return [self initWithNumber:0];
}

-(id)initWithNumber:(NSInteger)num
{
    self = [super init];
    if(self) {
        if(num < 1977) {
            NSLog(@"Initalized with an invalid year.");
            abort();
        }
        self.number = num;
        [self setLeapYear];
    }
    return self;
}

-(void)setLeapYear
{
    if(self.number%4 == 0) {
        if(self.number%100 == 0) {
            if(self.number%400 == 0) {
                self.isLeapYear = YES;
                return;
            }
            self.isLeapYear = NO;
            return;
        }
        self.isLeapYear = YES;
        return;
    }
    self.isLeapYear = NO;
}

@end
