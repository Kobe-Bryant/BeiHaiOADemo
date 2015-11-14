//
//  CasesinsideSearchViewController.h
//  GuangXiOA
//
//  Created by sz apple on 12-1-5.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
#import "PopupDateViewController.h"

@interface CasesinsideSearchViewController : BaseViewController<UITableViewDelegate,NSURLConnHelperDelegate,UITableViewDataSource,WordsDelegate,UITextFieldDelegate,PopupDateDelegate>

@property (strong, nonatomic) IBOutlet UILabel *btLabel;//标题
@property (strong, nonatomic) IBOutlet UITextField *btField;
@property (strong, nonatomic) IBOutlet UILabel *cbbmLabel;//承办部门
@property (strong, nonatomic) IBOutlet UITextField *cbbmField;
@property (strong, nonatomic) IBOutlet UILabel *kssjLabel;//开始时间
@property (strong, nonatomic) IBOutlet UITextField *kssjField;
@property (strong, nonatomic) IBOutlet UITextField *jssjField;//结束时间
@property (strong, nonatomic) IBOutlet UILabel *jssjLabel;
@property (strong, nonatomic) IBOutlet UITextField *sqlbField;//申请类别
@property (strong, nonatomic) IBOutlet UILabel *sqlbLabel;
@property (strong, nonatomic) IBOutlet UILabel *jjcdLabel;//紧急程度
@property (strong, nonatomic) IBOutlet UISegmentedControl *jjcdSegment;

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;


@property (nonatomic, assign) BOOL bHaveShowed;

@property (nonatomic,strong)NSURLConnHelper *webHelper;
@property (nonatomic,assign) NSInteger pageCount;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isLoading;

@property (nonatomic,assign) NSInteger currentTag;

@property (nonatomic,strong) NSMutableArray *resultAry;
@property (nonatomic,strong) NSString *departmentDM;
@property (nonatomic,assign) NSInteger typeDM;
@property (nonatomic,strong) NSString *refreshUrl;

@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;
@property (nonatomic, retain) PopupDateViewController *dateController;

- (IBAction)searchButtonPressed:(id)sender;

- (IBAction)touchForDept:(id)sender;

- (IBAction)touchForDate:(id)sender;

- (IBAction)touchForType:(id)sender;

- (IBAction)onSegmentClicked:(id)sender;

@end
