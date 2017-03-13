//
//  DetailViewController.h
//  demo_all
//
//  Created by 庄云智 on 2017/3/12.
//  Copyright © 2017年 庄云智. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *taskshead;
@property (retain, nonatomic) IBOutlet UITextView *tasksbody;
@property(strong,nonatomic)NSString *detailtaskhead;//接收来自TaskTable  controller传来的值
@property(strong,nonatomic)NSString *taskListID;//接收来自TaskTable  controller传来的值
@end
