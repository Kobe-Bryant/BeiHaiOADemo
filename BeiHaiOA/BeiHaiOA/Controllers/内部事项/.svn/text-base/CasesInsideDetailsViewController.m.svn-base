//
//  CasesInsideDetailsViewController.m
//  GuangXiOA
//
//  Created by sz apple on 11-12-28.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "CasesInsideDetailsViewController.h"
#import "PDJsonkit.h"
#import "FileUtil.h"
#import "NSStringUtil.h"
#import "DetailCellInfo.h"

@interface CasesInsideDetailsViewController ()
@property (nonatomic, strong) NSArray *tmpYCWXTitleAry;
@property (nonatomic, strong) NSArray *tmpTitleAry;
@property (nonatomic, strong) NSArray *tmpKeyAry;
@property (nonatomic, strong) NSArray *tmpYCWXKeyAry;
@property (nonatomic, strong) NSArray *toDisplayWJLXAry;//文件流向
@property (nonatomic, strong) NSMutableArray *basicRowInfoAry;

@end

@implementation CasesInsideDetailsViewController
@synthesize caseID,myTableView,baseKeyAry,infoTitleAry;
@synthesize baseInfoDic,attachmentInfoAry,itemParams;
@synthesize webHelper,toDisplayHeightAry,stepHeightAry,stepAry;
@synthesize isHandle,actionsModel;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.itemParams = item;
        self.isHandle = isToBanLi;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //用车维修
    self.tmpYCWXTitleAry = [[NSArray alloc] initWithObjects:@"申请时间#故障时间", @"申请类别#紧急程度",@"承办部门#承办人",@"原因", @"情形初步判断描述", @"维修项目", @"维修费用", @"用车司机#车牌号", @"承办部门领导签字", @"会签意见", @"办公室意见", @"局领导批示", @"文件流向", @"备注", @"登记人#登记时间", @"修改人#修改时间", nil];
    self.tmpYCWXKeyAry = [[NSArray alloc] initWithObjects:@"SQSJ#GZSJ",@"SQLB#JJCD",@"BMMC#CBR",@"BT",@"NR",@"BZ",@"FY",@"YCSJ#CPH",@"CBBMLDQZ",@"HQBMYJ",@"BGSYJ",@"LDPSYJ",@"WJLX",@"BZ",@"CJR#CJSJ",@"XGR#XGSJ", nil];
    
    //其他内部事项
    self.tmpTitleAry = [[NSArray alloc] initWithObjects:@"申请时间",@"申请类别#紧急程度",@"承办部门#承办人",@"标题", @"内容", @"承办部门领导签字", @"会签意见", @"办公室意见", @"局领导批示", @"文件流向", @"备注", @"登记人#登记时间", @"修改人#修改时间", nil];
    self.tmpKeyAry = [[NSArray alloc] initWithObjects:@"SQSJ",@"SQLB#JJCD",@"BMMC#CBR",@"BT", @"NR", @"CBBMLDQZ", @"HQBMYJ", @"BGSYJ", @"LDPSYJ", @"WJLX", @"BZ", @"CJR#CJSJ", @"XGR#XGSJ", nil];
    
    //如果是待办的任务支持流程步骤选择
    if(isHandle)
    {
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view  andShowStyle:WorkflowShowStylePopover];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_NBSXCONTENT" forKey:@"service"];
    [params setObject:self.caseID forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Private method and delegate

- (void)processWebData:(NSData*)webData
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
        if (!baseInfoDic)
        {
            bParseError = YES;
        }
        self.attachmentInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.hqfjAry = [[tmpParsedJsonAry lastObject] objectForKey:@"yjFj"];
        self.stepAry= [[tmpParsedJsonAry lastObject] objectForKey:@"nbsxbz"];
        self.toDisplayWJLXAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjlxInfo"];
        
        //用车维修显示的字段不同
        if ([[self.baseInfoDic objectForKey:@"SQLB"] isEqualToString:@"4"])
        {
            self.baseKeyAry = self.tmpYCWXKeyAry;
            self.infoTitleAry = self.tmpYCWXTitleAry;
        }
        else
        {
            self.baseKeyAry = self.tmpKeyAry;
            self.infoTitleAry = self.tmpTitleAry;
        }
        
        NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i=0; i< self.baseKeyAry.count; i++)
        {
            NSString *t = [self.infoTitleAry objectAtIndex:i];
            NSString *k = [self.baseKeyAry objectAtIndex:i];
            DetailCellInfo *info = [[DetailCellInfo alloc] initCellInfoWithRow:i andWithRowData:self.baseInfoDic andWithTitleInfo:t andWithKeyInfo:k];
            [aryTmp addObject:info];
            [aryTmp1 addObject:[NSNumber numberWithFloat:60]];
        }
        self.basicRowInfoAry = aryTmp;
        self.toDisplayHeightAry = aryTmp1;
    }
    else
    {
        bParseError = YES;
    }
    
    if(bParseError)
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
    for (int i=0; i< self.baseKeyAry.count; i++)
    {
        NSString *t = [self.infoTitleAry objectAtIndex:i];
        NSString *k = [self.baseKeyAry objectAtIndex:i];
        DetailCellInfo *info = [[DetailCellInfo alloc] initCellInfoWithRow:i andWithRowData:self.baseInfoDic andWithTitleInfo:t andWithKeyInfo:k];
        [aryTmp addObject:info];
        
        //计算Cell高度
        CGFloat h = [info getRowHeight];
        if([k isEqualToString:@"WJLX"])
        {
            NSString *wjlx = [self getWJLXStr];
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
            CGFloat cellHeight = [NSStringUtil calculateTextHeight:wjlx byFont:font andWidth:520.0];
            cellHeight += 20.0;
            if(cellHeight < 60)
            {
                cellHeight = 60;
            }
            h = cellHeight;
        }
        
        [aryHeightTmp addObject:[NSNumber numberWithFloat:h]];
    }
    self.basicRowInfoAry = aryTmp;
    self.toDisplayHeightAry = aryHeightTmp;
    
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for(int i=0; i< [stepAry count];i++)
    {
        NSDictionary *dicTmp = [stepAry objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.stepHeightAry = aryTmp2;
    
    [myTableView reloadData];
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
        return 4;
    }
    else
    {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.baseKeyAry.count;
    }
    else if (section == 1)
    {
        return (self.hqfjAry && [self.hqfjAry count] > 0) ? self.hqfjAry.count : 1;
    }
    else if (section == 2)
    {
        return (self.attachmentInfoAry && [self.attachmentInfoAry count] > 0) ? self.attachmentInfoAry.count : 1;
    }
    else if (section == 3)
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
        headerView.text = @"  会签信息";
    }
    else if(section == 2)
    {
        headerView.text = @"  附件信息";
    }
    else if(section == 3)
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
    else if (indexPath.section == 1 || indexPath.section == 2)
    {
        return 80;
    }
    else if ( indexPath.section == 3)
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
            if([info.leftKey isEqualToString:@"SQSJ"])
            {
                value1 = [self getShortDateStr:value1];
            }
            else if([info.leftKey isEqualToString:@"JJCD"])
            {
                value1 = [SharedInformations getJJCDFromInt:[value1 intValue]];
            }
            else if ([info.leftKey isEqualToString:@"SQLB"])
            {
                value1 = [SharedInformations getNBSXNameFromInt:[value1 intValue]];
            }
            else if([info.leftKey isEqualToString:@"YCSJ"])
            {
                //用车司机
                if(value1.length <= 0)
                {
                    value1 = @"";
                }
                else
                {
                    UsersHelper *uh = [[UsersHelper alloc] init];
                    value1 = [uh queryUserNameByID:value1];
                }
            }
            if(value1 == nil ) value1 = @"";
            
            NSString *value2 = [self.baseInfoDic objectForKey:info.rightKey];
            if([info.rightKey isEqualToString:@"JJCD"])
            {
                value2 = [SharedInformations getJJCDFromInt:[value2 intValue]];
            }
            else if ([info.rightKey isEqualToString:@"SQLB"])
            {
                value2 = [SharedInformations getNBSXNameFromInt:[value2 intValue]];
            }
            if(value2 == nil ) value2 = @"";
            
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"%@：", info.leftTitle];
            NSString *value = [self.baseInfoDic objectForKey:info.leftKey];
            if([info.leftKey isEqualToString:@"WJLX"])
            {
                value = [self getWJLXStr];
            }
            else if([info.leftKey isEqualToString:@"SQSJ"])
            {
                value = [self getShortDateStr:value];
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
        if(self.hqfjAry == nil || self.hqfjAry.count == 0)
        {
            cell.textLabel.text = @"暂无会签附件信息";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        else
        {
            cell.textLabel.numberOfLines = 2;
            NSDictionary *aItem = [self.hqfjAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [aItem objectForKey:@"FJM"];
            NSString *pathExt = [[aItem objectForKey:@"FJLJ"] pathExtension];
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
    else if (indexPath.section == 3)
    {
        if(self.stepAry && self.stepAry.count > 0)
        {
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
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
        //会签附件下载
        if (self.hqfjAry.count <= 0 && indexPath.section == 1)
        {
            return;
        }
        NSDictionary *dicTmp = [self.hqfjAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"BH"];
        if (idStr == nil)
        {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"DOWN_WORKFLOW_STEP_FILE" forKey:@"service"];
        [params setObject:@"ee5a638d-c789-4649-992b-e9a5b6c61505" forKey:@"BH"];
        NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"FJM"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section == 2)
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

//文件流向
- (NSString *)getWJLXStr
{
    NSMutableString *str = [[NSMutableString alloc] init];
    //文件流向
    if(self.toDisplayWJLXAry && self.toDisplayWJLXAry.count > 0)
    {
        for (int i = 0; i < self.toDisplayWJLXAry.count; i++)
        {
            NSDictionary *tmpWjlx = [self.toDisplayWJLXAry objectAtIndex:i];
            NSString *zzjc = [tmpWjlx objectForKey:@"ZZJC"];
            NSString *yhm = [tmpWjlx objectForKey:@"YHM"];
            NSString *cjsj =  [self getShortDateStr:[tmpWjlx objectForKey:@"CJSJ"]];
            [str appendFormat:@"%@ [%@ %@]。\n", zzjc, yhm, cjsj];
        }
    }
    return str;
}

@end
