//
//  Month.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/10/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "Month.h"

@interface Month ()

@end

@implementation Month

-(id)init
{
    return [self initWithName:@""];
}

-(id)initWithName:(NSString *)name
{
    self = [super init];
    if(self) {
        if([self getName:name] == NONE) {
            NSLog(@"Month initialized without a valid name.");
            abort();
        }
        self.name = [self getName:name];
    }
    return self;
}

-(id)initWithNumber:(NSInteger)num
{
    NSString* name = [self getMonth:num];
    return [self initWithName:name];
}

-(NSString*)getMonth:(NSInteger)num {
    if(num == 1) {
        return @"January";
    } else if(num == 2) {
        return @"February";
    } else if(num == 3) {
        return @"March";
    } else if(num == 4) {
        return @"April";
    } else if(num == 5) {
        return @"May";
    } else if(num == 6) {
        return @"June";
    } else if(num == 7) {
        return @"July";
    } else if(num == 8) {
        return @"August";
    } else if(num == 9) {
        return @"September";
    } else if(num == 10) {
        return @"October";
    } else if(num == 11) {
        return @"November";
    } else if(num == 12) {
        return @"December";
    } else {
        return @"None";
    }
}

-(NSString*)getStringName
{
    if(self.name == 1) {
        return @"Jan";
    } else if(self.name == 2) {
        return @"Feb";
    } else if(self.name == 3) {
        return @"Mar";
    } else if(self.name == 4) {
        return @"Apr";
    } else if(self.name == 5) {
        return @"May";
    } else if(self.name == 6) {
        return @"Jun";
    } else if(self.name == 7) {
        return @"Jul";
    } else if(self.name == 8) {
        return @"Aug";
    } else if(self.name == 9) {
        return @"Sep";
    } else if(self.name == 10) {
        return @"Oct";
    } else if(self.name == 11) {
        return @"Nov";
    } else if(self.name == 12) {
        return @"Dec";
    } else {
        return @"None";
    }
}

-(Name)getName:(NSString*)name
{
    if([name isEqualToString:@"January"]) {
        return JANUARY;
    } else if([name isEqualToString:@"February"]) {
        return FEBRUARY;
    } else if([name isEqualToString:@"March"]) {
        return MARCH;
    } else if([name isEqualToString:@"April"]) {
        return APRIL;
    } else if([name isEqualToString:@"May"]) {
        return MAY;
    } else if([name isEqualToString:@"June"]) {
        return JUNE;
    } else if([name isEqualToString:@"July"]) {
        return JULY;
    } else if([name isEqualToString:@"August"]) {
        return AUGUST;
    } else if([name isEqualToString:@"September"]) {
        return SEPTEMBER;
    } else if([name isEqualToString:@"October"]) {
        return OCTOBER;
    } else if([name isEqualToString:@"November"]) {
        return NOVEMBER;
    } else if([name isEqualToString:@"December"]) {
        return DECEMBER;
    } else {
        return NONE;
    }
}

@end
