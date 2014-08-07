//
//  Year.h
//  BudgIt
//
//  Created by Eric L Eisner on 4/10/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Year : NSObject

@property(nonatomic) NSInteger number;
@property(nonatomic) BOOL isLeapYear;

-(id)init;
-(id)initWithNumber:(NSInteger)num;

@end
