//
//  FaWenBanliController.m
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "FaWenBanliController.h"

#import "SharedInformations.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"

#import "ServiceUrlString.h"
#import "FileUtil.h"

@implementation FaWenBanliController
@synthesize infoDic,toDisplayKey,toDisplayKeyTitle;
@synthesize stepAry,attachmentAry,gwInfoAry,resTableView,isHandle;
@synthesize toDisplayHeightAry;
@synthesize webHelper,stepHeightAry,actionsModel,itemParams;

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
        
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"fwInfo"] lastObject];
        
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"fwbz"];
        
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"fwfj"];
        
        self.gwInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"zsgw"];

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
    NSMutableArray *aryTmp1 = [[NSMutableArray alloc] initWithCapacity:13];
    for (int i=0; i< 13;i++)
    {
        CGFloat cellHeight = 60.0f;
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i]]];
        cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font1 andWidth:520.0]+20;
        if(cellHeight < 60) cellHeight = 60.0f;
        [aryTmp1 addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp1;

    
    UIFont *font2 = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    NSMutableArray *aryTmp2 = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [stepAry count];i++) {
        NSDictionary *dicTmp = [stepAry   objectAtIndex:i];
        NSString *value =[NSString stringWithFormat:@"批示记录：%@",
                          [dicTmp objectForKey:@"CLRYJ"]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:value byFont:font2 andWidth:700] + 30.0;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    // Do any additional setup after loading the view from its nib.
    self.title =@"发文详细信息";
    
   
    self.toDisplayKey = [NSArray arrayWithObjects:@"LDSHYJ",@"XBBMBLYJ",@"BMSHYJ",@"BGSFZRSHYJ",@"GKLX",@"NWDWNGR",@"NGSJ",@"XDR",@"ZS",@"CB",@"CS",@"WHMC",@"BT",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"签发人：",@"会签部门意见：",@"部门核稿：",@"办公室核稿意见：",@"信息是否公开：",@"拟办部门和拟稿人：",@"拟稿时间：",@"校对人：",@"主送：",@"抄报：",@"抄送：",@"文号：",@"文件标题：",nil];
    NSMutableArray *tempDisplayHeightAry = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i=0; i< 15;i++)
    {
        [tempDisplayHeightAry addObject:[NSNumber numberWithFloat:60.0f]];
    }
    self.toDisplayHeightAry = tempDisplayHeightAry;
    
    NSString *strUrl = nil;
    if (isHandle) {
        
                
        self.actionsModel = [[ToDoActionsDataModel alloc] initWithTarget:self andParentView:self.view andShowStyle:WorkflowShowStylePopover];
        [actionsModel requestActionDatasByParams:itemParams];
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"QUERY_FWBL" forKey:@"service"];
    [params setObject:[itemParams objectForKey:@"LCSLBH"] forKey:@"LCSLBH"];
    strUrl = [ServiceUrlString generateUrlByParameters:params];
    
    
     self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
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
    if (self.webHelper) {
        [self.webHelper cancel];
    }
    if(self.actionsModel.actionPopover)
    {
        [self.actionsModel.actionPopover dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text= @"  发文信息";
    else if (section == 1)  headerView.text= @"  发文附件";
    else if (section == 2)  headerView.text= @"  处理步骤";
    else   headerView.text= @"  正式公文信息";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 )
    {
        return [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    else if (indexPath.section == 1 )
    {
        return 80;
    }
    else if(indexPath.section == 0)
    {
        return [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0 )
    {
        return 13;
    }
    else if (section == 1)
    {
       return (self.attachmentAry.count > 0 && self.attachmentAry) ? self.attachmentAry.count : 1;
    }
    else if (section == 2)
    {
        if(self.stepAry ==nil)
            return 0;
        else if ( [self.stepAry count] == 0) {
            return 1;
        }
        else
            return [self.stepAry count];
    }
    else {
        if(self.gwInfoAry ==nil)
            return 0;
        else if ([self.gwInfoAry count] == 0) {
            return 1;
        }
        else
            return [self.gwInfoAry count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
        {
            //信息是否公开  
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:4];

            int gklx = [[infoDic objectForKey:[self.toDisplayKey objectAtIndex:4]] intValue];

            NSString *value = [SharedInformations getGKLXFromInt:gklx];
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
        }
        else if (indexPath.row == 6)
        {
            //信息是否公开
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:6];
            
            NSString *ngsj = [infoDic objectForKey:[self.toDisplayKey objectAtIndex:6]];
            if([ngsj length] > 10)
                ngsj = [ngsj substringToIndex:10];
            
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:ngsj andHeight:nHeight];
        }
        else if (indexPath.row == 11)
        {

            NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row];
            NSString *WHMC =  [self.infoDic objectForKey:@"WHMC"];
            if(WHMC == nil)
                WHMC = @"";
            NSString *WHNF =  [self.infoDic objectForKey:@"WHNF"];
            if(WHNF == nil)
                WHNF = @"";
            NSNumber *WHSZ =  [self.infoDic objectForKey:@"WHSZ"];
            NSString *value = [NSString stringWithFormat:@"%@[%@]%@号",WHMC,WHNF,WHSZ];
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
        }
        else
        {
            NSString *title = [self.toDisplayKeyTitle objectAtIndex:indexPath.row];
            NSString *value = @"";
            if([self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row]] != nil)
            {
                value = [NSString stringWithFormat:@"%@", [self.infoDic objectForKey:[self.toDisplayKey objectAtIndex:indexPath.row]]];
            }
            CGFloat nHeight = [[self.toDisplayHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value andHeight:nHeight];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        if (self.attachmentAry ==nil||[self.attachmentAry count] == 0)
        {
            cell.textLabel.text = @"没有相关附件";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [self.attachmentAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [dicTmp objectForKey:@"WDDX"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 2)
    {
        if (self.stepAry ==nil||[self.stepAry count] == 0)
        {
            static NSString *identifier = @"fujiancell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
                cell.textLabel.numberOfLines = 0;
            }
            cell.textLabel.text = @"没有相关处理步骤";
        }
        else
        {
            NSDictionary *dicTmp = [self.stepAry objectAtIndex:indexPath.row];
            NSString *title =[NSString stringWithFormat:@"%d %@", indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
            NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
            NSString *value1 =[NSString stringWithFormat:@"批示记录：%@", [dicTmp objectForKey:@"CLRYJ"] ];
            NSString *value3 =[NSString stringWithFormat:@"处理时间：%@", [dicTmp objectForKey:@"JSSJ"]];
            CGFloat height  = [[self.stepHeightAry objectAtIndex:indexPath.row] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title SubValue1:value1  SubValue2:value2 SubValue3:value3 andHeight:height];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 3)
    {
        static NSString *identifier = @"CellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            cell.textLabel.numberOfLines = 0;
        }
        if (self.gwInfoAry ==nil||[self.gwInfoAry count] == 0)
        {
            cell.textLabel.text = @"没有相关数据";
        }
        else
        {
            NSDictionary *dicTmp = [self.gwInfoAry objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ", [dicTmp objectForKey:@"WDMC"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            cell.imageView.image = [FileUtil imageForFileExt:pathExt];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
    }
    	
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;

	return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 1){

        if ([attachmentAry count] <= 0) {
            return;
        }
        NSDictionary *dicTmp = [attachmentAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
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
    else  if(indexPath.section == 3){

        if ([gwInfoAry count] <= 0) {
            return;
        }
        NSDictionary *dicTmp = [gwInfoAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
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

