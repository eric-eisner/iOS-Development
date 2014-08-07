//
//  Day.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/17/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "Day.h"

@implementation Day

-(id)initWithNumber:(NSInteger)num
{
    self = [super init];
    if(self) {
        if(num < 1 || num > 31) {
            NSLog(@"Initalized with an invalid year.");
            abort();
        }
        self.number = num;
    }
    return self;
}

@end
