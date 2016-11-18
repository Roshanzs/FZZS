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
#import "MBProgressHUD+MJ.h"
#import <Speech/Speech.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *txtArr;
@property(nonatomic,strong)UIButton *selectBtn;

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
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 123.0 / 736.0 * ScreenH)];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW - 60, 64 , 60, 30)];
    self.selectBtn = btn;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(listenAudio) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"听书" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    [headView addSubview:btn];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
    [MBProgressHUD showMessage:@"正在打开书本"];
    self.selectBtn.selected = YES;
    LSYReadPageViewController *controller = [[LSYReadPageViewController alloc]init];
    NSString *basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [basePath stringByAppendingPathComponent:row];
    NSURL *url = [NSURL fileURLWithPath:path];
    controller.resourceURL = url;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        controller.model = [LSYReadModel getLocalModelWithURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            self.selectBtn.selected = NO;
            [self presentViewController:controller animated:YES completion:nil];
            
        });
    });
}

//听书
-(void)listenAudio{
    [MBProgressHUD showMessage:@"正在加载"];
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"mdjyml" ofType:@"txt"];
    NSStringEncoding *encoding = nil;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *body = [NSString stringWithContentsOfFile:txtPath usedEncoding:encoding error:nil];
        //    NSString *content = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
        if (!body) {
            body = [NSString stringWithContentsOfFile:txtPath encoding:0x80000632 error:nil];
        }
        //还是识别不到，按GB18030编码再解码一次.
        if (!body) {
            body = [NSString stringWithContentsOfFile:txtPath encoding:0x80000631 error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (body) {
                NSLog(@"2222%@",body);
            }
            [MBProgressHUD hideHUD];
            AVSpeechSynthesizer *speech = [[AVSpeechSynthesizer alloc]init];
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:body];
//            utterance.rate = AVSpeechUtteranceMaximumSpeechRate / 10.0f;
            utterance.rate =  0.4f;

            utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh_CN"];
            [speech speakUtterance:utterance];
        });
    });
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
