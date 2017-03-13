//
//  DetailViewController.m
//  demo_all
//
//  Created by 庄云智 on 2017/3/12.
//  Copyright © 2017年 庄云智. All rights reserved.
//

#import "DetailViewController.h"
#import "Tasks+CoreDataClass.h"
@interface DetailViewController ()
{
    NSManagedObjectContext *context_detail;//coredata上下文
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _taskshead.text = self.detailtaskhead;
    _taskshead.textAlignment = NSTextAlignmentCenter;

    NSManagedObjectModel *model_tasks = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc_tasks = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model_tasks];
    
    NSString *docs_tasks = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url_tasks = [NSURL fileURLWithPath:[docs_tasks stringByAppendingPathComponent:@"Tasks.sqlite"]];//设置数据库的路径和文件名称和类型
    NSLog(@"tasks数据库的路径 %@",url_tasks);
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc_tasks addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url_tasks options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    context_detail = [[NSManagedObjectContext alloc] init];
    context_detail.persistentStoreCoordinator = psc_tasks;
    
    NSLog(@"%@",NSHomeDirectory());//数据库会存在沙盒目录的Documents文件夹下
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    
    request.entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:context_detail];//找到我们的Person
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskname = %@", [self detailtaskhead]];//创建谓词语句，条件是uid等于001
    request.predicate = predicate; //赋值给请求的谓词语句
    
    NSError *error1 = nil;
    NSArray *objs = [context_detail executeFetchRequest:request error:&error1];//执行我们的请求
    if (error1) {
        [NSException raise:@"查询错误" format:@"%@", [error1 localizedDescription]];//抛出异常
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        if ([[obj valueForKey:@"tasklist"] isEqualToString:[self taskListID]]){
        _tasksbody.text = [obj valueForKey:@"taskdescription"];
        NSLog(@"taskname = %@ taskdescription = %@ tasklist= %@",[obj valueForKey:@"taskname"],[obj valueForKey:@"taskdescription"],[obj valueForKey:@"tasklist"]);
        }
    }
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePopViewController:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionRight; //向左
    [self.view addGestureRecognizer:swipeGestureLeft];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    
    request.entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:context_detail];//找到我们的Person
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskname = %@", [self detailtaskhead]];//创建谓词语句，条件是uid等于001
    request.predicate = predicate; //赋值给请求的谓词语句
    
    NSError *error1 = nil;
    NSArray *objs = [context_detail executeFetchRequest:request error:&error1];//执行我们的请求
    if (error1) {
        [NSException raise:@"查询错误" format:@"%@", [error1 localizedDescription]];//抛出异常
    }
    
    //更新任务描述前判断其是否为空，为空直接返回不写入数据库
    if ([_tasksbody.text isEqualToString:@""])
    {
        return;
    }
    
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        //增加判断语句，判断当前taskList，防止不同taskList的相同taskname的影响
        if ([[obj valueForKey:@"tasklist"] isEqualToString:[self taskListID]]){
            [obj setValue:_tasksbody.text forKey:@"taskdescription"];
            NSLog(@"tasklist = %@  ", [obj valueForKey:@"taskname"]); //打印符合条件的数据
        }
    }
    NSError *error = nil;
    BOOL success = [context_detail save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        NSLog(@"插入成功");
    }
    [super viewWillDisappear:animated];
}

//返回首页button函数
- (IBAction)returnToRootViewController:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//向左滑手势
- (IBAction)swipePopViewController:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"触发向左滑动");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)dealloc {
//    [_taskshead release];
//    [_tasksbody release];
//    [_detailtaskhead release];
//    [super dealloc];
//}
@end
