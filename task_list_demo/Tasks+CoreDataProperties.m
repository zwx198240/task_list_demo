//
//  Tasks+CoreDataProperties.m
//  demo_all
//
//  Created by 庄云智 on 2017/3/6.
//  Copyright © 2017年 庄云智. All rights reserved.
//

#import "Tasks+CoreDataProperties.h"

@implementation Tasks (CoreDataProperties)

+ (NSFetchRequest<Tasks *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Tasks"];
}

@dynamic taskname;
@dynamic taskdescription;
@dynamic tasklist;

@end
