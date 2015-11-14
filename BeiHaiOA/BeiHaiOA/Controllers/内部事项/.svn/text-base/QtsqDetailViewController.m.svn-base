//
//  QtsqDetailViewController.m
//  BeiHaiOA
//
//  Created by ihumor on 14-1-14.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "QtsqDetailViewController.h"

@interface QtsqDetailViewController ()

@end

@implementation QtsqDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSArray *tmpYZSQTitleAry = [[NSArray alloc] initWithObjects:@"申请时间：",@"申请类别：",@"紧急程度：",@"承办部门：",@"承办人：",@"标题：", @"内容：", @"承办部门领导签字：", @"会签意见：", @"办公室意见：", @"局领导批示：", @"文件流向：", @"备注：", @"登记人：", @"登记时间：", @"修改人：", @"修改时间", nil];
        NSArray *tmpYZSQKeyAry = [[NSArray alloc] initWithObjects:@"SQSJ",@"NBSXSPBH",@"JJCD",@"承办部门：",@"CBR",@"BT", @"NR", @"承办部门领导签字：", @"会签意见：", @"办公室意见：", @"局领导批示：", @"文件流向：", @"备注：", @"CJR", @"CJSJ", @"修改人：", @"修改时间", nil];
        self.baseKeyAry = tmpYZSQKeyAry;
        self.infoTitleAry = tmpYZSQTitleAry;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 13;
    }
    else if (section == 1)
    {
        return (self.hqfjAry && [self.hqfjAry count] > 0) ? self.hqfjAry.count : 1;
    }
    else if (section == 2)
    {
        return (self.attachmentInfoAry && [self.attachmentInfoAry count] > 0) ? self.attachmentInfoAry.count : 1;
    }
    else
    {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if(section == 0)
    {
        headerView.text = @"  基本信息";
    }
    else if(section == 1)
    {
        headerView.text = @"  会签信息";
    }
    else if(section == 2)
    {
        headerView.text = @"  附件信息";
    }
    
    return headerView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(self.toDisplayHeightAry && self.toDisplayHeightAry.count > 0)
        {
            if(indexPath.row == 1)
            {
                return [[self.toDisplayHeightAry objectAtIndex:2] floatValue];
            }
            else if(indexPath.row >=4 && indexPath.row <=7)
            {
                return [[self.toDisplayHeightAry objectAtIndex:indexPath.row+3] floatValue];
            }
            else if(indexPath.row == 0)
            {
                return 70;
            }
            else
            {
                return 60;
            }
        }
        else{
            return 60;
        }
    }
    else if (indexPath.section == 1)
    {
        return 80;
    }
    else if ( indexPath.section == 2)
    {
        if(self.stepHeightAry && self.stepHeightAry.count > 0)
        {
            return [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
        }
    }
	return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //申请时间
            NSString *title = [self.infoTitleAry objectAtIndex:0];
            NSString *value = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:0]];
            if(value == nil)
            {
                value = @"";
            }
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:0] floatValue];
            if(height < 60)
            {
                height = 60;
            }
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        else if(indexPath.row == 1)
        {
            //申请类别 紧急程度
            NSString *title1 = [self.infoTitleAry objectAtIndex:1];
            NSString *title2 = [self.infoTitleAry objectAtIndex:2];
            NSString *value1 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:1]];
            if(value1 == nil ) value1 = @"";
            NSString *sqlbStr = [SharedInformations getNBSXNameFromInt:[value1 intValue]];
            NSString *value2 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:2]];
            if(value2 == nil) value2 = @"";
            NSString *jjcdStr = [SharedInformations getJJCDFromInt:[value2 intValue]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:sqlbStr value4:jjcdStr height:60];
        }
        else if(indexPath.row == 2)
        {
            //承办部门 承办人
            NSString *title1 = [self.infoTitleAry objectAtIndex:3];
            NSString *title2 = [self.infoTitleAry objectAtIndex:4];
            NSString *value1 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:3]];
            if(value1 == nil ) value1 = @"";
            NSString *value2 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:4]];
            if(value2 == nil) value2 = @"";
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if(indexPath.row >= 3 && indexPath.row <= 10)
        {
            //标题
            NSString *title = [self.infoTitleAry objectAtIndex:indexPath.row + 2];
            NSString *value = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:indexPath.row + 2]];
            if(value == nil)
            {
                value = @"";
            }
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row + 2] floatValue];
            if(height < 60)
            {
                height = 60;
            }
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        else if(indexPath.row == 11)
        {
            NSString *title1 = [self.infoTitleAry objectAtIndex:13];
            NSString *title2 = [self.infoTitleAry objectAtIndex:14];
            NSString *value1 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:13]];
            if(value1 == nil ) value1 = @"";
            NSString *value2 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:14]];
            if(value2 == nil) value2 = @"";
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else
        {
            NSString *title1 = [self.infoTitleAry objectAtIndex:15];
            NSString *title2 = [self.infoTitleAry objectAtIndex:16];
            NSString *value1 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:15]];
            if(value1 == nil ) value1 = @"";
            NSString *value2 = [self.baseInfoDic objectForKey:[self.baseKeyAry objectAtIndex:16]];
            if(value2 == nil) value2 = @"";
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        
    }
    else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"caseinsidecell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"caseinsidecell"];
        }
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        if(self.hqfjAry == nil || self.hqfjAry.count == 0)
        {
            cell.textLabel.text = @"暂无会签附件信息";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.textLabel.numberOfLines = 2;
            NSDictionary *aItem = [self.hqfjAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [aItem objectForKey:@"WDMC"];
            NSString *pathExt = [[aItem objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.detailTextLabel.text = [aItem objectForKey:@"WDDX"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"caseinsidecell"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"caseinsidecell"];
        }
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        if(self.attachmentInfoAry == nil || self.attachmentInfoAry.count == 0)
        {
            cell.textLabel.text = @"暂无附件信息";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.textLabel.numberOfLines = 2;
            NSDictionary *aItem = [self.attachmentInfoAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [aItem objectForKey:@"WDMC"];
            NSString *pathExt = [[aItem objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.detailTextLabel.text = [aItem objectForKey:@"WDDX"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section >= 1)
    {
        if (self.hqfjAry.count <= 0 && indexPath.section == 1)
        {
            return;
        }
        else if(self.attachmentInfoAry.count <= 0 && indexPath.section == 2)
        {
            return;
        }
        NSDictionary *dicTmp = [self.attachmentInfoAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil)
        {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
