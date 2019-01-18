//
//  ViewController.m
//  RAC
//
//  Created by Macmafia on 2018/6/5.
//  Copyright © 2018年 Macmafia. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerII.h"
#import "RACSignal.h"
#import "RACDisposable.h"
#import "RACSubscriber.h"
#import "RACCommand.h"
#import "UIButton+RACCommandSupport.h"
#import "NSObject+RACKVOWrapper.h"
#import "NSObject+RACPropertySubscribing.h"
#import "NSNotificationCenter+RACSupport.h"
#import "UIControl+RACSignalSupport.h"
#import "UITextView+RACSignalSupport.h"
#import "NSObject+RACSelectorSignal.h"
#import "RACSubscriptingAssignmentTrampoline.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *mBt1;
@property (weak, nonatomic) IBOutlet UIButton *mBtn2;
@property (weak, nonatomic) IBOutlet UITextView *mTextView;
@property (weak, nonatomic) IBOutlet UILabel *mLabel;
@property (weak, nonatomic) IBOutlet UIButton *mBtn3;
@property (nonatomic, copy) NSString *mTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mTitle = self.title = @"VII";
    
    //1.属性监听
    [RACObserve(self, mLabel.text) subscribeNext:^(id x) {
        NSLog(@"+++textView Text:%@",x);
    }];
    
    //2.点击事件
    weakSelf()
    self.mBt1.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"+++点击了Btn1~");
        strongSelf()
        strongSelf.mTitle = @"Title2";
        
        return [RACSignal empty];
    }];;
    
    //3.监听输入事件
    [[self.mTextView rac_textSignal] subscribeNext:^(id x) {
        strongSelf()
        strongSelf.mLabel.text = x;
        NSLog(@"+++输入值：%@",x);
    }];
    
    //4.监听对象的方法是否被调用
    [[self rac_signalForSelector:@selector(testRAC)] subscribeNext:^(id x) {
        NSLog(@"++调用了[self testRAC];");
    }];
    [self testRAC];
    
    //5.代理
    [[self.mBtn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"+++点击了Btn2~");
        strongSelf()
        //创建新的界面
        ViewControllerII *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerII"];
        //设置信号，相当于设置代理
        controller.rac_delegate = [RACSubject subject];
        //订阅信号 等待新的回调
        [controller.rac_delegate subscribeNext:^(id x) {
            //回调中处理的业务
            [strongSelf dismissViewControllerAnimated:YES completion:NULL];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Name" object:nil];
        }];
        //模态弹出新页面
        [strongSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    
    //6.KVO
    [self rac_observeKeyPath:@"mTitle"
                     options:NSKeyValueObservingOptionNew
                    observer:self
                       block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
                           NSLog(@"++value:%@, change:%@",value,change);
    }];
    
    
    //7.KVC
    [[self rac_valuesForKeyPath:@"title" observer:self] subscribeNext:^(id x) {
        NSLog(@"+++~new Title:%@~~",x);
    }];
    
    //8.通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"Name" object:nil] subscribeNext:^(id x) {
        NSLog(@"++收到通知~");
    }];
}

- (void)dealloc{
    NSLog(@"++++%@ dealloced~",[self class]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ViewControllerII *controller = segue.destinationViewController;
    //设置信号，相当于设置代理
    controller.rac_delegate = [RACSubject subject];
    //订阅信号 等待新的回调
    __weak typeof(self) wSelf = self;
    [controller.rac_delegate subscribeNext:^(id x) {
        //回调中处理的业务
        __strong typeof(wSelf) sSelf = wSelf;
        if (sSelf.navigationController) {
            [sSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [sSelf dismissViewControllerAnimated:YES completion:NULL];
        }
    }];
}

#pragma mark -Actions

- (IBAction)onAction1:(id)sender {
}

#pragma mark -Business
- (void)testRAC{
    //创建信号
    RACSignal *s1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //发送信号
        [subscriber sendNext:@"Hello~"];
        //回收资源
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"++信号发送完成");
        }];
    }];
    //订阅信号
    [s1 subscribeNext:^(id x) {
        NSLog(@"++subscribeNext:收到新值:%@",x);
    }];
    [s1 subscribeNext:^(id x) {
        NSLog(@"++subscribeNext:error:completed:收到新值:%@",x);
    } error:^(NSError *error) {
        
    } completed:^{
        NSLog(@"++信号完成");
    }];
    
    //属性绑定信号
    RAC(self,title) = s1;
    
    //过滤
    RACSignal *s2 = [s1 map:^id(NSString *title) {
        if (0 == title.length) {
            return @"title1";
        }else{
            return title;
        }
    }];
    RACSignal *s3 = [s2 filter:^BOOL(NSString *title) {
        return title.length > 0;//返回长度是大于0的title
    }];
    [s2 subscribeNext:^(id x) {
        NSLog(@"++map:%@",x);
    }];
    [s3 subscribeNext:^(id x) {
        NSLog(@"++filter:%@",x);
    }];
}

@end
