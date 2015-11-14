//
//  BanLiController.m
//  GuangXiOA
//
//  Created by  on 11-12-21.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "BanLiController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "LaiWenBanLiDetailController.h"
#import "BanLiItem.h"
#import "FaWenBanliController.h"
#import "NoticeDetailsViewController.h"
#import "SystemConfigContext.h"
#import "NoticeTaskDetailVC.h"
#import "UITableViewCell+Custom.h"
#import "CasesInsideDetailsViewController.h"
#import "CarApplicationDetailViewController.h"

@implementation BanLiController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *itemTitle = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"DWMC"];
    if (itemTitle== nil) {
        itemTitle = @"";
    }
    NSDictionary *dic  = [self.aryItems objectAtIndex:indexPath.row];
    //cell.textLabel.text = itemTitle;
    NSString *qixian = [dic objectForKey:@"LCQX"]; //办文期限
    if([qixian length]>10)
        qixian = [qixian substringToIndex:10];
    
    NSString *fbr = [NSString stringWithFormat:@"交办人：%@",[dic objectForKey:@"BZCJR"]];
    
    NSString *fbsj = [NSString stringWithFormat:@"发布时间：%@",[dic objectForKey:@"BZKSSJ"]];
    
    NSString *bljd = [NSString stringWithFormat:@"办理阶段：%@",[dic objectForKey:@"BZMC"]];
    
    NSString *strLCBH = [dic objectForKey:@"LCLXBH"];
    
    
    UIImage *cellImg = nil;
    
    if ([strLCBH isEqualToString:kFWDJ_Type_Tag])
    {
        //发文
        itemTitle = [[self.aryItems objectAtIndex:indexPath.row] objectForKey:@"DWDZ"];
        if (itemTitle== nil)
        {
            itemTitle = @"";
        }
        itemTitle = [NSString stringWithFormat:@"%@【发文】",itemTitle];
        cellImg = [UIImage imageNamed:@"fw.png"];
    }
    else if ( [strLCBH isEqualToString:kNBSX_Type_Tag] )
    {
        //内部事项
        itemTitle = [NSString stringWithFormat:@"%@【内部事项】",itemTitle];
        cellImg = [UIImage imageNamed:@"nbsx.png"];
    }
    else if ([strLCBH isEqualToString:kLWDJ_Type_Tag])
    {
        //来文
        itemTitle = [NSString stringWithFormat:@"%@【来文】",itemTitle];
        cellImg = [UIImage imageNamed:@"lw.png"];
    }
    else if([strLCBH isEqualToString:kTZGG_Type_Tag])
    {
        //通知公告
        itemTitle = [NSString stringWithFormat:@"%@【通知公告】",itemTitle];
        cellImg = [UIImage imageNamed:@"tzgg.png"];
    }
    else if([strLCBH isEqualToString:kYCSQ_Type_Tag])
    {
        //用车申请
        itemTitle = [NSString stringWithFormat:@"%@【用车申请】",itemTitle];
        cellImg = [UIImage imageNamed:@"ycsq.png"];
    }
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:itemTitle andSubvalue1:fbr andSubvalue2:fbsj andSubvalue3:bljd andSubvalue4:[NSString stringWithFormat:@"办文期限：%@",qixian]];
    cell.imageView.image = cellImg;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.aryItems ==nil || [self.aryItems count] <= indexPath.row)
    {
        NSLog(@"parsedItemAry error in BanliCOntroller");
    }
    NSDictionary *tmpDic = [self.aryItems objectAtIndex:indexPath.row];
    NSString *lclxbh = [tmpDic objectForKey:@"LCLXBH"];    
    if ([lclxbh isEqualToString:kFWDJ_Type_Tag])
    {
        //发文
        FaWenBanliController *controller = [[FaWenBanliController alloc] initWithNibName:@"FaWenBanliController" andParams:tmpDic isBanli:YES];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([lclxbh isEqualToString:kNBSX_Type_Tag])
    {
        //内部事项
        CasesInsideDetailsViewController *childView = [[CasesInsideDetailsViewController alloc] initWithNibName:@"CasesInsideDetailsViewController" bundle:nil];
        childView.itemParams = tmpDic;
        childView.isHandle = YES;
        childView.caseID = [tmpDic objectForKey:@"YWBH"];
        childView.title = @"内部事项详细信息";
        [self.navigationController pushViewController:childView animated:YES];
    }
    else if ([lclxbh isEqualToString:kLWDJ_Type_Tag])
    {
        //来文
        LaiWenBanLiDetailController *controller = [[LaiWenBanLiDetailController alloc] initWithNibName:@"LaiWenBanLiDetailController" andParams:tmpDic isBanli:YES];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if ([lclxbh isEqualToString:kTZGG_Type_Tag])
    {
        //通知公告
        NoticeTaskDetailVC *controller = [[NoticeTaskDetailVC alloc] initWithNibName:@"NoticeTaskDetailVC" andParams:tmpDic isBanli:YES];
        [self.navigationController pushViewController:controller animated:YES ];
    }
    else if([lclxbh isEqualToString:kYCSQ_Type_Tag])
    {
        //用车申请
        CarApplicationDetailViewController *controller = [[CarApplicationDetailViewController alloc] initWithNibName:@"CarApplicationDetailViewController" andParams:tmpDic isBanli:YES];
        controller.caseID = [tmpDic objectForKey:@"YWBH"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
