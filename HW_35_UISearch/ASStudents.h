//
//  ASStudents.h
//  HW_35_UISearch
//
//  Created by MD on 29.06.15.
//  Copyright (c) 2015 hh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASStudents : NSObject

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* nameImage;

@property (strong,nonatomic) NSString* famaly;
@property (strong,nonatomic) NSDate*   date;
@property (strong,nonatomic) NSDateComponents *components;

-(id)initWithName:(NSString*)name andFamaly:(NSString*)famaly andImage:(NSString*) nameImage;
@end
