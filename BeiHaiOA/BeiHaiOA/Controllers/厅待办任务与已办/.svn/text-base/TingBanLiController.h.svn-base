//
//  BanLiController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//  来文办理

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

#import "BaseViewController.h"
@interface TingBanLiController : BaseViewController
  <UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,
   UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *itemAry;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger pageSum;
@property (nonatomic,assign) BOOL isLoading;

@property(nonatomic,strong)  NSURLConnHelper *webHelper;

@property (nonatomic,strong) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSArray* segmentControlTitles;
@end
