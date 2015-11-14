//
//  BanLiDetailController.h
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
// 来文办理

#import <UIKit/UIKit.h>
#import "BanLiItem.h"
#import "NSURLConnHelper.h"
#import "HandleGWProtocol.h"
#import "BaseViewController.h"
@interface TingBanLiDetailController : BaseViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,HandleGWDelegate>

@property (nonatomic,strong) BanLiItem *aItem;
@property (nonatomic,strong) NSDictionary *infoDic; //来文信息
@property (nonatomic,strong) NSArray *toDisplayKey;//来文信息所要显示的key
@property (nonatomic,strong) NSArray *toDisplayKeyTitle;//来文信息所要显示的key对应的标题
@property(nonatomic,strong) NSMutableArray *toDisplayHeightAry;

@property (nonatomic,strong) NSArray *stepAry;      //来文步骤
@property (nonatomic,strong) NSArray *stepHeightAry;      //来文步骤的高度

@property (nonatomic,strong) NSArray *attachmentAry; //来文附件
@property (nonatomic,strong) NSArray *chushiOpinionAry; //处室意见信息
@property (nonatomic,strong) NSArray *selInfoAry; //领导快捷键信息
@property (nonatomic,assign) BOOL isHandle; 
@property (nonatomic,assign)BOOL bOKFromTransfer;//办理返回ok
@property (nonatomic,strong) IBOutlet UITableView *resTableView;
@property(nonatomic,strong)NSURLConnHelper *webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andBanliItem:(BanLiItem*)item isBanli:(BOOL)isToBanLi;
@end
