//
//  SearchNoticeViewController.h
//  GuangXiOA
//
//  Created by sz apple on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "NSURLConnHelper.h"

@interface TingSearchNoticeViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,NSURLConnHelperDelegate,WordsDelegate>

@property (nonatomic,strong) IBOutlet UITextField *bt;//通知标题
@property (nonatomic,strong) IBOutlet UITextField *lx;//通知类型
@property (nonatomic,strong) IBOutlet UISegmentedControl *sfyd;//是否已读
@property (nonatomic,strong) IBOutlet UITextField *fbdw;//发布单位
@property (nonatomic,strong) IBOutlet UISegmentedControl *yxj;//优先级

@property (nonatomic,strong) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) IBOutlet UIButton *searchButton;

@property (nonatomic,unsafe_unretained) NSInteger pageCount;//总数据条数
@property (nonatomic,unsafe_unretained) NSInteger currentPage;//当前页
@property (nonatomic,unsafe_unretained) NSInteger pages;//页总数
@property (nonatomic,unsafe_unretained) BOOL isLoading;
@property (nonatomic,unsafe_unretained) NSInteger currentTag;

@property (nonatomic,strong) NSMutableArray *resultAry;
@property (nonatomic,strong) NSString *departmentDM;
@property (nonatomic,strong) NSString *typeDM;
@property (nonatomic,strong) NSString *refreshUrl;
@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;
@property(nonatomic,assign) BOOL showTingData;
- (IBAction)searchButtonPressed:(id)sender;
@end
