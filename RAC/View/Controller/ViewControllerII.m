//
//  ViewControllerII.m
//  RAC
//
//  Created by Macmafia on 2019/1/16.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "ViewControllerII.h"
#import "UIControl+RACSignalSupport.h"
#import "RACEXTScope.h"
#import "RACDisposable.h"
#import "NSObject+RACSelectorSignal.h"
#import "NSObject+RACPropertySubscribing.h"
#import "RACTuple.h"
#import "RACViewModel.h"

@interface ViewControllerII ()
<UITableViewDataSource,
UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mIndicator;

@property (nonatomic, weak) id <RACSubscriber> subscriber;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) RACViewModel *mViewModel;

@end

@implementation ViewControllerII

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUps];
    [self bindViewModel];
}

- (void)dealloc{
    NSLog(@"++++%@ dealloced~",[self class]);
}

- (RACViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel = [[RACViewModel alloc] init];
    }
    return _mViewModel;
}

#pragma mark -Tableview Data&Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mViewModel.cellNums;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *label = [cell viewWithTag:1];
    label.text = [self.mViewModel convertedTextAtIndexPath:indexPath];
    //[NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -Actions

- (IBAction)onAcion1:(id)sender {
    //触发信号，相当于调用代理
    if (self.rac_delegate) {
        [self.rac_delegate sendNext:@"Dismiss"];
    }
}


#pragma mark -BUsiness

- (void)setUps{
    
    _mIndicator.hidden = YES;
    
    //RAC监听按钮点击事件
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    @weakify(self);
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        //调用dismiss
        if (self.rac_delegate) {
            [self.rac_delegate sendNext:@"dismiss"];
        }
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"reload" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        //执行ViewModel中的RACCommand
        self.mIndicator.hidden = NO;
        [self.mViewModel.fetchCommand execute:nil];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    self.mTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //监听对象的方法或代理是否被调用
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)
                    fromProtocol:@protocol(UITableViewDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         NSIndexPath *indexPath = tuple.last;
         NSLog(@"+++调用了row:%ld",(long)indexPath.row);
    }];
}

- (void)bindViewModel{
    
    @weakify(self)
    [RACObserve(self.mViewModel, reloadData) subscribeNext:^(id x) {
        @strongify(self);
        [self.mTableview reloadData];
        self.mIndicator.hidden = YES;
    }];
    
    [RACObserve(self.mIndicator, hidden) subscribeNext:^(NSNumber *hiddenNum) {
        @strongify(self);
        BOOL hidden = hiddenNum.boolValue;
        if (hidden) {
            [self.mIndicator stopAnimating];
        }else{
            [self.mIndicator startAnimating];
        }
    }];
}
@end
