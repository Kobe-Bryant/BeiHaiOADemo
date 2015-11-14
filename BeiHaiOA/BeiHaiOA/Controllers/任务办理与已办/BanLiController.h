//
//  BanLiController.h
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//  待办任务列表

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "TodoListViewController.h"

@interface BanLiController : TodoListViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,
   UIScrollViewDelegate>

@end
