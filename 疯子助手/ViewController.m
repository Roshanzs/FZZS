//
//  ViewController.m
//  疯子助手
//
//  Created by 紫贝壳 on 2016/11/15.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "ViewController.h"
#import "LSYReadPageViewController.h"
#import "LSYReadModel.h"
#import "BookTableViewCell.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *txtArr;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取所有电子书文件地址
    NSFileManager *manger = [[NSFileManager alloc]init];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *txtp = [path stringByAppendingPathComponent:@"民调局异闻录.txt"];
    [manger createFileAtPath:txtp contents:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mdjyml.txt" ofType:nil]] attributes:nil];
    self.txtArr = [manger contentsOfDirectoryAtPath:path error:nil];
    //显示所有电子书
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[BookTableViewCell class] forCellReuseIdentifier:@"cell"];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 123.0 / 736.0 * ScreenH)];
    UILabel *lab = [[UILabel alloc]initWithFrame:headView.bounds];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"书本目录";
    lab.font = [UIFont systemFontOfSize:32];
    [headView addSubview:lab];
    tableView.tableHeaderView = headView;
    tableView.rowHeight = 80.0 / 736.0 * ScreenH;
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg"]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.txtArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.txtArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:28];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self touchTxtWithRow:self.txtArr[indexPath.row]];
}

//获取选中的电子书并加载显示出来
-(void)touchTxtWithRow:(NSString *)row{
    LSYReadPageViewController *controller = [[LSYReadPageViewController alloc]init];
    NSString *basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [basePath stringByAppendingPathComponent:row];
    NSURL *url = [NSURL fileURLWithPath:path];
    controller.resourceURL = url;
    controller.model = [LSYReadModel getLocalModelWithURL:url];
    [self presentViewController:controller animated:YES completion:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
