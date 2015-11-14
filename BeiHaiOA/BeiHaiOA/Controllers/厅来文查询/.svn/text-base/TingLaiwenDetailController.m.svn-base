//
//  LaiwenDetailController.m
//  GuangXiOA
//
//  Created by  on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingLaiwenDetailController.h"
#import "AppDelegate.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"
#import "UITableViewCell+Custom.h"
#import "SystemConfigContext.h"
#import "SharedInformations.h"
#import "NSStringUtil.h"
#import "ServiceUrlString.h"
#import "FileUtil.h"

@implementation TingLaiwenDetailController

@synthesize jbxxDic,wjxxAry,lwid,toDisplayKey,toDisplayKeyTitle,resTableView; 
@synthesize toDisplayHeightAry;
@synthesize webHelper;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil andLWID:(NSString*)idstr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self)
    {
        self.lwid = idstr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"来文详细信息";
    // Do any additional setup after loading the view from its nib.
    self.toDisplayKey = [NSArray arrayWithObjects:@"LWRQ",@"XSBJRQ",@"LWDW",@"LWLX",@"LWWH",@"JJCD",@"LWBT",
                         @"TNBYJ",@"CSYJ",@"TLDPS",@"WJLX",@"BZ",@"DJR",@"DJSJ",@"XGR",@"XGSJ",nil];
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"来文日期：",@"限时办结日期：",@"来文单位：",@"来文类型：",@"来文文号：",@"紧急程度：",@"文件名称：",@"拟办意见：",@"处室意见：",@"厅领导批示：",@"文件流向：",@"备       注：",@"登  记  人：",@"登记时间：",@"修  改  人：",@"修改时间：",nil];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_LWCONTENT" forKey:@"service"];
    [params setObject:self.lwid forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        self.wjxxAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.jbxxDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
    }
    else
        bParseError = YES;
    if (bParseError)
    {
        [self showAlertMessage:@"获取数据出错."];
    }
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [toDisplayKey count];i++)
    {
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [jbxxDic objectForKey:[toDisplayKey objectAtIndex:i]]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
    }
    self.toDisplayHeightAry = aryTmp;
    [resTableView reloadData];
}

-(void)processError:(NSError *)error
{
    [self showAlertMessage:@"请求数据失败."];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)  headerView.text = @"  来文信息";
    else  headerView.text = @"  来文附件";
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)  return 11;
    else {
        if(wjxxAry == nil)
            return 0;
        else if ([wjxxAry count] == 0) {
            return 1;
        }
    }return [wjxxAry count];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	CGFloat nHeight = 60.0f;
    if(indexPath.section == 0){
        if(indexPath.row == 0 ||  indexPath.row == 2 ||
           indexPath.row == 9  || indexPath.row == 10 )
            return 60.0;
        else if(indexPath.row == 1  )//来文有可能很长
            return 70.0;
        return [[toDisplayHeightAry objectAtIndex:indexPath.row+3] floatValue];
        
    }
    
    return nHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:1];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:0]];
            if([value1 length]>10)value1 = [value1 substringToIndex:10];
            NSString *value2 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:1]];
            if([value2 length]>10)value2 = [value1 substringToIndex:10];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if( indexPath.row == 1){//LWLX
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:2]];
            NSString *lwType = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:3]];
            NSString *value2 = [SharedInformations getLWLXFromStr:lwType];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:70];
            
        }
        else if( indexPath.row == 2)
        {
            ////JJCD
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:4];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:5];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:4]];
            int num = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:5]] intValue];
            NSString *value2 = [SharedInformations getJJCDFromInt:num];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if( indexPath.row == 9 || indexPath.row == 10)
        {
            int div = 3;
            if(indexPath.row == 10)div = 4;
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:indexPath.row+div];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:indexPath.row+div+1];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+div]];
            NSString *value2 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+div+1]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else
        {
            NSString *itemValue = nil;
            itemValue = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+3]];
            if (itemValue== nil)
            {
                itemValue = @"";
            }
            CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row+3] floatValue];
            cell = [UITableViewCell makeSubCell:tableView withTitle:[toDisplayKeyTitle   objectAtIndex:indexPath.row+3] value:itemValue andHeight:nHeight];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        static NSString *identifier = @"cellLaiwenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (wjxxAry ==nil||[wjxxAry count] == 0)
        {
            cell.textLabel.text = @"没有相关附件";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            NSDictionary *dicTmp = [wjxxAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ",[dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [dicTmp objectForKey:@"WDDX"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if ([wjxxAry count] <= 0)
        {
            return;
        }
        NSDictionary *dicTmp = [wjxxAry objectAtIndex:indexPath.row];
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil)
        {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:idStr forKey:@"id"];
        [params setObject:appidStr forKey:@"appid"];
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end

