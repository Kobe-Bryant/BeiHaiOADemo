//
//  LaiWenSearchController.h
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"
#import "BaseViewController.h"

@interface TingLaiWenSearchController : BaseViewController<PopupDateDelegate>

@property (nonatomic, strong) IBOutlet UITableView *resultTableView;
@property (nonatomic, strong) IBOutlet UITextField *titleField; //来文标题field
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;     //来文标题label
@property (nonatomic, strong) IBOutlet UITextField *danweiField; //单位field
@property (nonatomic, strong) IBOutlet UILabel *danweiLabel;     // 单位label
@property (nonatomic, strong) IBOutlet UILabel *wenHaoLabel;    //文号label
@property (nonatomic, strong) IBOutlet UITextField *wenHaoField;
@property (nonatomic, strong) IBOutlet UILabel *xuhaoLabel;    //序号label
@property (nonatomic, strong) IBOutlet UITextField *xuhaoField;
@property (nonatomic, strong) IBOutlet UITextField *fromDateField;
@property (nonatomic, strong) IBOutlet UILabel *fromDateLabel;
@property (nonatomic, strong) IBOutlet UITextField *endDateField;
@property (nonatomic, strong) IBOutlet UILabel *endDateLabel;
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;
@property (nonatomic, assign) NSInteger currentTag;
@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL bHaveShowed;
@property (nonatomic, strong) NSMutableArray *resultAry;
@property (nonatomic, strong) NSMutableArray *resultHeightAry;
@property (nonatomic, strong) NSString *lxtype;//类型
@property (nonatomic, strong) NSString *urlString; //不含p_CURRENT的url
-(void)showSearchBar:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)touchFromDate:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil andType:(NSString*)typeStr;
@end
