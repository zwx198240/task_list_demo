//
//  SettingsPasswdViewController.m
//  demo_all
//
//  Created by 庄云智 on 2017/3/8.
//  Copyright © 2017年 庄云智. All rights reserved.
//

#import "SettingsPasswdViewController.h"

@interface SettingsPasswdViewController ()
@property (retain, nonatomic) IBOutlet UITextField *mTFUserName;
@property (retain, nonatomic) IBOutlet UITextField *mTFOldPassWord;
@property (retain, nonatomic) IBOutlet UITextField *mTFNewPassWord;
@property (retain, nonatomic) IBOutlet UITextField *mTFNewVerifyPassWord;

@end

@implementation SettingsPasswdViewController
{
    FMDatabase * _mDB;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePopViewController:)];
    //设置轻扫的方向
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionRight; //向右
    [self.view addGestureRecognizer:swipeGestureLeft];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)mBTChangePassWord:(UIButton *)sender {
    NSString *uName = _mTFUserName.text;
    NSString *uPass = _mTFNewPassWord.text;
    NSString * strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/RegisterUser.db"];
    
    //创建并且打开数据库
    //如果路径下面没有数据库，创建指定的数据库
    //如果路径下已经存在数据库，加载数据库到内存
    _mDB = [FMDatabase databaseWithPath:strPath];
    //创建查找SQL语句
    NSString *strQuery =@"select * from stu";
    NSLog(@"执行的SQL语句：strQuery = %@",strQuery);
    
    BOOL isOpen = [_mDB open];
    
    if (isOpen)
    {
        //执行查找SQL语句
        //将查找成功的结果用ResultSet返回
        FMResultSet * result = [_mDB executeQuery:strQuery];
        
        while ([result next])
        {
            //NSLog(@"stu  name = %@, password = %@",[result stringForColumn:@"name"],[result stringForColumn:@"password"]);
            //获取名字字段内容，根据字段名字来获取
            if ([_mTFUserName.text isEqualToString:[result stringForColumn:@"name"]] && [_mTFOldPassWord.text isEqualToString:[result stringForColumn:@"password"]]){
                if ([uPass length] >= 6){
                if ([_mTFNewPassWord.text isEqualToString:_mTFNewVerifyPassWord.text])
                {
                    
                    NSString *strDelete =[NSString stringWithFormat:@"delete from stu where name = '%@'",_mTFUserName.text];
                    
                    [_mDB executeUpdate:strDelete];
                    NSString *strInsert = [NSString stringWithFormat:@"insert into stu values('%@','%@');",uName,uPass];
                    
                    BOOL isOK = [_mDB executeUpdate:strInsert];
                    if (isOK == YES)
                    {
                        __weak typeof(self) weakSelf = self;//转为weak弱类型
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改成功！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                            
                            //将当前的视图控制器弹出，返回到上一级界面
                            [weakSelf.navigationController popViewControllerAnimated:YES];

                        }];
                    
                        [alert addAction:actionYes];
                        [self presentViewController:alert animated:YES completion:nil];
                        NSLog(@"修改的账号%@，密码%@",_mTFUserName.text,_mTFNewPassWord.text);
                        BOOL isClose = [_mDB close];
                        if (isClose)
                        {
                            NSLog(@"关闭数据库成功");
                        }
                        return;
                    }
                }else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改失败" message:@"请确认新密码两次输入是否一致！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
     
                    self.mTFNewPassWord.text = @"";
                    self.mTFNewVerifyPassWord.text = @"";
                    [alert addAction:actionYes];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                }else {
                    //当密码未超过6位，报错
                    __weak typeof(self) weakSelf = self;//转为weak弱类型
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改失败" message:@"密码位数不能低于6位数！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        weakSelf.mTFNewPassWord.text = @"";
                        weakSelf.mTFNewVerifyPassWord.text = @"";
                    }];
                    [alert addAction:actionYes];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
            }
            
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改失败" message:@"请确认输入的账号或密码是否正确！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        self.mTFUserName.text = @"";
        self.mTFOldPassWord.text = @"";
        self.mTFNewPassWord.text = @"";
        self.mTFNewVerifyPassWord.text = @"";
        [alert addAction:actionYes];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

//点击屏幕空白处，回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_mTFUserName resignFirstResponder];
    [_mTFOldPassWord resignFirstResponder];
    [_mTFNewPassWord resignFirstResponder];
    [_mTFNewVerifyPassWord resignFirstResponder];
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
//    [_mTFUserName release];
//    [_mTFOldPassWord release];
//    [_mTFNewPassWord release];
//    [_mTFNewVerifyPassWord release];
//    [super dealloc];
//}
@end
