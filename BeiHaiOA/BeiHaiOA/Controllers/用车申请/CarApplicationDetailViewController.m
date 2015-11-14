//
//  CarApplicationsViewController.m
//  BeiHaiOA
//
//  Created by 曾静 on 14-2-20.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CarApplicationDetailViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "DetailCellInfo.h"
#import "NSStringUtil.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "FileUtil.h"
#import "UsersHelper.h"

@interface CarApplicationDetailViewController ()

//基本信息
@property (nonatomic, strong) NSDictionary *baseInfoDic;
@property (nonatomic, strong) NSArray *toDisplayTitleAry;
@property (nonatomic, strong) NSArray *toDisplayKeyAry;
@property (nonatomic, strong) NSArray *toDisplayHeightAry;

//附件信息
@property (nonatomic, strong) NSArray *attachmentInfoAry;

//步骤信息
@property (nonatomic, strong) NSArray *stepAry;
@property (nonatomic, strong) NSArray *stepHeightAry;

@property (nonatomic, strong) ToDoActionsDataModel *actionsModel;

@property (nonatomic, strong) NSMutableArray *basicRowInfoAry;

@property (nonatomic, strong) UsersHelper *userHelper;

@end

@implementation CarApplicationDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.itemParams = item;
        self.isHandle = isToBanLi;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"用车申请详细信息";
    
    self.toDisplayTitleAry = [[NSArray alloc] initWithObjects:@"申请时间",@"用车单位#申请人",@"用车开始时间#用车结束时间",@"目的地#车牌号", @"随车人员", @"派车事由", @"备注", nil];
    self.toDisplayKeyAry = [[NSArray alloc] initWithObjects:@"SQSJ",@"YCDWMC#YCRMC",@"YCKSSJ#YCJSSJ",@"MDD#CPH", @"SCRY", @"PCSY", @"BZ", nil];
    
    if(self.isHandle)
    {
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view  andShowStyle:WorkflowShowStylePopover];
        [self.actionsModel requestActionDatasByParams:self.itemParams];
    }
    
    self.userHelper = [[UsersHelper alloc] init];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *aryHeightTmp = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i< self.toDisplayTitleAry.count; i++)
    {
        NSString *t = [self.toDisplayTitleAry objectAtIndex:i];
        NSString *k = [self.toDisplayKeyAry objectAtIndex:i];
        DetailCellInfo *info = [[DetailCellInfo alloc] initCellInfoWithRow:i andWithRowData:self.baseInfoDic andWithTitleInfo:t andWithKeyInfo:k];
        [aryTmp addObject:info];
        CGFloat h = [info getRowHeight];
        [aryHeightTmp addObject:[NSNumber numberWithFloat:h]];
    }
    self.basicRowInfoAry = aryTmp;
    self.toDisplayHeightAry = aryHeightTmp;
    [self.detailTableView reloadData];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_YCSQCONTENT" forKey:@"service"];
    [params setObject:self.caseID forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - Private method and delegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
        return;
    NSMutableString *resultJSON = [[NSMutableString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    [resultJSON replaceOccurrencesOfString:@"null" withString:@"\"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultJSON.length)];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0)
    {
        self.baseInfoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        if (!self.baseInfoDic)
        {
            bParseError = YES;
        }
        self.attachmentInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        //self.hqfjAry = [[tmpParsedJsonAry lastObject] objectForKey:@"hqfj"];
        self.stepAry= [[tmpParsedJsonAry lastObject] objectForKey:@"nbsxbz"];
    }
    else
    {
        bParseError = YES;
    }
    
    if (bParseError)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *aryHeightTmp = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i< self.toDisplayTitleAry.count; i++)
    {
        NSString *t = [self.toDisplayTitleAry objectAtIndex:i];
        NSString *k = [self.toDisplayKeyAry objectAtIndex:i];
        DetailCellInfo *info = [[DetailCellInfo alloc] initCellInfoWithRow:i andWithRowData:self.baseInfoDic andWithTitleInfo:t andWithKeyInfo:k];
        [aryTmp addObject:info];
        CGFloat h = [info getRowHeight];
        [aryHeightTmp addObject:[NSNumber numberWithFloat:h]];
    }
    self.basicRowInfoAry = aryTmp;
    self.toDisplayHeightAry = aryHeightTmp;
    
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [self.stepAry count];i++)
    {
        NSDictionary *dicTmp = [self.stepAry objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.stepHeightAry = aryTmp2;
    
    [self.detailTableView reloadData];
}

-(void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    return;
}


#pragma mark - TableView DataSource Methods

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isHandle)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.toDisplayTitleAry.count;
    }
    else if (section == 1)
    {
        return (self.attachmentInfoAry && [self.attachmentInfoAry count] > 0) ? self.attachmentInfoAry.count : 1;
    }
    else if (section == 2)
    {
        return (self.stepAry && [self.stepAry count] > 0) ? self.stepAry.count : 1;
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
        headerView.text = @"  附件信息";
    }
    else if(section == 2)
    {
        headerView.text = @"  处理步骤";
    }
    return headerView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(self.toDisplayHeightAry && self.toDisplayHeightAry.count > 0)
        {
            return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
        }
        else
        {
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
        DetailCellInfo *info = [self.basicRowInfoAry objectAtIndex:indexPath.row];
        if(info.cellType == DetailCellDoubleType)
        {
            NSString *title1 = [NSString stringWithFormat:@"%@：", info.leftTitle];
            NSString *title2 = [NSString stringWithFormat:@"%@：", info.rightTitle];
            
            NSString *value1 = [self.baseInfoDic objectForKey:info.leftKey];
            if(value1 == nil ) value1 = @"";
            if([info.leftKey isEqualToString:@"SQSJ"])
            {
                value1 = [self getShortDateStr:value1];
            }
            NSString *value2 = [self.baseInfoDic objectForKey:info.rightKey];
            if(value2 == nil ) value2 = @"";
            
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%@：", info.leftTitle];
            NSString *value = [self.baseInfoDic objectForKey:info.leftKey];
            if([info.leftKey isEqualToString:@"SCRY"] && value.length > 0)
            {
                if([value hasSuffix:@"&"])
                {
                    value = [value substringToIndex:value.length-1];
                }
                NSMutableString *userNameStr = [[NSMutableString alloc] init];
                NSArray *tmpAry = [value componentsSeparatedByString:@"&"];
                for(int i = 0; i < tmpAry.count; i++)
                {
                    NSString *tmpStr = [tmpAry objectAtIndex:i];
                    if(i != tmpAry.count-1)
                    {
                        [userNameStr appendFormat:@"%@、", [self.userHelper queryUserNameByID:tmpStr]];
                    }
                    else
                    {
                        [userNameStr appendFormat:@"%@", [self.userHelper queryUserNameByID:tmpStr]];
                    }
                }
                value = userNameStr;
            }
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
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
    else if (indexPath.section == 2)
    {
        if(self.stepAry && self.stepAry.count > 0)
        {
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"stepCell"];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"stepCell"];
            }
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.text = @"暂无处理步骤信息";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if(self.attachmentInfoAry.count <= 0 && indexPath.section == 2)
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

#pragma mark - Private Method

- (NSString *)getShortDateStr:(NSString *)str
{
    if(str.length > 10)
    {
        return [str substringToIndex:10];
    }
    else
    {
        return str;
    }
}

@end
