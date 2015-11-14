//
//  CarApplicationDetailViewController.h
//  BeiHaiOA
//
//  Created by 曾静 on 14-2-20.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "TaskActionBaseViewController.h"
#import "ToDoActionsDataModel.h"

@interface CarApplicationDetailViewController : TaskActionBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *detailTableView;

@property (nonatomic, strong) NSDictionary *itemParams;
@property (nonatomic, assign) BOOL isHandle;
@property (nonatomic, strong) NSString *caseID;

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi;

@end
