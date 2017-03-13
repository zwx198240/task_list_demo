//
//  TaskList+CoreDataProperties.m
//  demo_all
//
//  Created by 庄云智 on 2017/3/6.
//  Copyright © 2017年 庄云智. All rights reserved.
//

#import "TaskList+CoreDataProperties.h"

@implementation TaskList (CoreDataProperties)

+ (NSFetchRequest<TaskList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TaskList"];
}

@dynamic tasklist;

@end
