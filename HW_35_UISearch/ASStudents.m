//
//  ASStudents.m
//  HW_35_UISearch
//
//  Created by MD on 29.06.15.
//  Copyright (c) 2015 hh. All rights reserved.
//

#import "ASStudents.h"
#import "ASNameFamalyAndImage.h"


@implementation ASStudents

-(id) initWithName:(NSString*)name andFamaly:(NSString*)famaly andImage:(NSString*) nameImage
{
    self = [super init];
    
    if (self) {

        NSString         *string;
        NSDate           *now       = [NSDate date];
        NSCalendar       *calendar  = [NSCalendar currentCalendar];
        NSDateComponents *comps     = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        [comps setYear:[comps year]-((arc4random()%(60-18))+18)];
        [comps setMonth:arc4random()%12];
        [comps setDay:arc4random()%31];
        
        
        
        NSDate *date = [calendar dateFromComponents:comps];
        NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
        
        [comps setDay:arc4random()%days.length];
        string = [dateFormatter stringFromDate:date];
        
        
        NSDateComponents* components  = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:date];
        
        self.components = components;
        self.name      = name;
        self.famaly    = famaly;
        self.nameImage = nameImage;
        self.date = date;
        
        NSLog(@"\tName = %@     \tFamaly = %@   \tImage = %@      \tDate = %@  |",_name,  _famaly,   _nameImage, string);
    }
    return self;
}


@end
