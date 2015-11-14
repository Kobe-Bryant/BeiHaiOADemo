//
//  FaWenSearchController.h
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "DepartmentInfoItem.h"
#import "NSURLConnHelper.h"
#import "BaseViewController.h"
#import "PopupDateViewController.h"

@interface TingHaveDoneSearchController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PopupDateDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UITextField *titleField;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *fromDateField;
@property (nonatomic, strong) IBOutlet UILabel *fromDateLabel;
@property (nonatomic, strong) IBOutlet UITextField *endDateField;
@property (nonatomic, strong) IBOutlet UILabel *endDateLabel;
@property (nonatomic, strong) NSURLConnHelper *webHelper;

@property (nonatomic, strong) IBOutlet UIButton *searchBtn;

@property (nonatomic, strong) NSMutableArray *laiWenItemAry;
@property (nonatomic, strong) NSMutableArray *faWenItemAry;
@property (nonatomic, strong) NSMutableArray *neiBuShiXiangItemAry;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger pageSum;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL bHaveShowed;
@property (nonatomic, assign) BOOL currentTag;
@property (nonatomic, assign) NSInteger gwType;
@property (nonatomic, strong) NSString *urlString; //不含p_CURRENT的url
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;
@property (nonatomic, strong) UIBarButtonItem *rightButtonBar;
@property (nonatomic, strong) NSArray* segmentControlTitles;

-(void)showSearchBar:(id)sender;
-(IBAction)btnSearchPressed:(id)sender;
-(IBAction)touchFromDate:(id)sender;

@end
