//
//  Tasks+CoreDataProperties.h
//  demo_all
//
//  Created by 庄云智 on 2017/3/6.
//  Copyright © 2017年 庄云智. All rights reserved.
//

#import "Tasks+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tasks (CoreDataProperties)

+ (NSFetchRequest<Tasks *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *taskname;
@property (nullable, nonatomic, copy) NSString *taskdescription;
@property (nullable, nonatomic, copy) NSString *tasklist;

@end

NS_ASSUME_NONNULL_END
