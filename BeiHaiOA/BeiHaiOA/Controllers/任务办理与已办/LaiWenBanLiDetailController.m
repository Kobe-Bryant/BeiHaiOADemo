//
//  BanLiDetaiController.m
//  GuangXiOA
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "LaiWenBanLiDetailController.h"
#import "ServiceUrlString.h"
#import "NSStringUtil.h"
#import "UITableViewCell+Custom.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"
#import "FileUtil.h"
#import "SharedInformations.h"

@implementation LaiWenBanLiDetailController
@synthesize infoDic,stepAry,attachmentAry,toDisplayKeyTitle;
@synthesize resTableView,selInfoAry,toDisplayKey,isHandle;
@synthesize toDisplayHeightAry,stepHeightAry;
@synthesize webHelper,actionsModel,itemParams;

- (id)initWithNibName:(NSString *)nibNameOrNil andParams:(NSDictionary*)item isBanli:(BOOL)isToBanLi
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.itemParams = item;
        isHandle = isToBanLi;
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}





#pragma mark - View lifecycle
-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"lwInfo"] lastObject];
        NSString *djsj = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"DJSJ"]];
        if([djsj length] >=16){
            NSString *subSj = [djsj substringWithRange:NSMakeRange(11, 5)];
            if([subSj isEqualToString:@"00:00"]){
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:infoDic];
                [dic setObject:[djsj substringToIndex:11] forKey:@"DJSJ"];
                self.infoDic = dic;
            }
                
        }
        
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwbz"];
        
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwfj"];
        

        self.selInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"lwtldqp"];
    }
    else
        bParseError = YES;
    
    if (bParseError) {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"获取数据出错。" 
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UIFont *font1 = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:11];
    for (int i=0; i< 8;i++)
    {
        CGFloat cellHeight = 60.0f;
        
        if(i>=3 )
        {
            NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i+3]]];
            cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        }else{
            cellHeight = 70.0f;
        }
        
        if(cellHeight < 60) cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp;


    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [stepAry count];i++) {
        NSDictionary *dicTmp = [stepAry   objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@",
                           [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700]+30;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp2 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.stepHeightAry = aryTmp2;

    [resTableView reloadData];
}

-(void)processError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败." 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    return;
}

-(void)goBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"来文详细信息";
    
    if (isHandle)
    {
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_LWBL" forKey:@"service"];
    [params setObject:[itemParams objectForKey:@"LCSLBH"] forKey:@"LCSLBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];

    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"来文日期：",@"限时办结日期：",@"来文单位：",@"来文类型：",@"来文文号：",@"紧急程度：",@"来文标题：",@"拟办意见：",@"部门意见：",@"局领导审批意见：",@"备注：",nil];
    self.toDisplayKey = [NSArray arrayWithObjects:@"LWRQ",@"XSBJRQ",@"LWDW",@"LWLX",@"LWWH",@"JJCD",@"LWBT",@"NBYJ",@"BLYJ",@"TLDPS",@"BZ", nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:11];
    for (int i=0; i< 11;i++)
    {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
    self.bOKFromTransfer = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper) {
        [webHelper cancel];
    }
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableView Delegate & DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text= @"  来文信息";
    else if (section == 1)  headerView.text= @"  来文附件";
    else  headerView.text= @"  处理步骤";
   
    return headerView ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0)
    {
        return 8;
    }
    else if (section == 1)
    {
        return [attachmentAry count] == 0 ? 1 : self.attachmentAry.count;
    }
    else 
    {
        return [stepAry count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return [[toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    else if (indexPath.section == 1 )
    {
        return 80;
    }
    else if(indexPath.section == 2)
    {
        return [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            //来文日期   限时办结日期
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:1];
            
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:0]];
            if([value1 length]>10) value1 = [value1 substringToIndex:10];
            
            NSString *value2 = [infoDic objectForKey:[toDisplayKey objectAtIndex:1]];
            if([value2 length]>10) value2 = [value2 substringToIndex:10];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if(indexPath.row == 1)
        {
            //来文单位 来文类型
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:2]];
            NSString *lwType = [infoDic objectForKey:[toDisplayKey objectAtIndex:3]];
            NSString *value2 = [SharedInformations getLWLXFromStr:lwType];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else if(indexPath.row == 2)
        {
            //来文文号 紧急程度
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:4]];
            int num = [[infoDic objectForKey:[toDisplayKey objectAtIndex:5]] intValue];
            NSString *value2 = [SharedInformations getJJCDFromInt:num];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:height];
        }
        else 
        {
            int div = 3;
            NSString *title = [toDisplayKeyTitle objectAtIndex:indexPath.row+div];
            NSString *value = [infoDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+div]];
            CGFloat height = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:height];
        }
        
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"fujiancell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (attachmentAry == nil||[ attachmentAry count] == 0)
        {
            cell.textLabel.text = @"没有相关附件";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [attachmentAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else if (indexPath.section == 2)
    {
        NSDictionary *dicTmp = [stepAry objectAtIndex:indexPath.row];
        NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
        NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
        NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
        NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
        CGFloat height  = [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
        cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if ([attachmentAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
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
