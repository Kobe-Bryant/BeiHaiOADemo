//
//  FawenDetailController.m
//  GuangXiOA
//
//  Created by  on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingFawenDetailController.h"
#import "AppDelegate.h"
#import "PDJsonkit.h"
#import "SharedInformations.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "NSStringUtil.h"
#import "ServiceUrlString.h"
#import "FileUtil.h"
#import "NSString+MD5Addition.h"

@interface TingFawenDetailController ()

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString;

@end

@implementation TingFawenDetailController
@synthesize toDisplayKey,toDisplayKeyTitle,bsgwFilesAry,isHaveZSGW,jbxxDic,fwid,resTableView;
@synthesize toDisplayHeightAry;
@synthesize webHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil andFWID:(NSString*)idstr
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.fwid = idstr;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, imag etc that aren't in use.
}


- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet oldString:(NSString *)oldString {
    NSUInteger location = 0;
    NSUInteger length = [oldString length];
    unichar charBuffer[length];
    [oldString getCharacters:charBuffer];
    int i = 0;
    for (i = 0;i < length;i++) {
        location ++;
        
        if ([characterSet characterIsMember:charBuffer[i]]) {
            break;
        }
    }
    
    return [oldString substringWithRange:NSMakeRange(0,location)];
}

#pragma mark - View lifecycle
-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        self.bsgwFilesAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        self.jbxxDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        self.isHaveZSGW = [[jbxxDic objectForKey:@"ZSGWPATH"] length] > 0;
    }
    else
        bParseError = YES;
    if (bParseError) {
        [self showAlertMessage:@"获取数据出错."];
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [toDisplayKey count];i++) {
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [jbxxDic objectForKey:[toDisplayKey objectAtIndex:i]]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.toDisplayHeightAry = aryTmp;
    
    [resTableView reloadData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败."];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"发文详细信息";
    

    
    // Do any additional setup after loading the view from its nib.
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_FWCONTENT" forKey:@"service"];
    [params setObject:fwid forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    

    self.toDisplayKey = [NSArray arrayWithObjects:@"JJCD",@"BMJB",@"WH",@"GKLX",@"WJMC",@"ZTC",@"ZS",@"CB",@"CS",@"ZBDWHRGR",@"CSSG", @"HQDWYJ",@"BGSHG",@"NDYJ",nil];
    
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"紧急程度：",@"机密程度：",@"发文文号：",@"信息是否公开：",@"文件标题：",@"主  题  词：",@"主       送：",@"抄       报：",@"抄       送：",@"主办处室／单位和拟稿人：",@"主办处室／单位核稿：",@"会签处室／单位意见：",@"厅办核稿意见：",@"签  发  人：",nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if (section == 0)   headerView.text = @"  发文信息";
    else if (section == 1)  headerView.text = @"  上传报送公文";
    else   headerView.text = @"  正式打印公文";
    return headerView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)  return 12;
    else if (section == 1)
    {
        if(bsgwFilesAry == nil)
            return 0;
        else if ([bsgwFilesAry count] == 0) {
            return 1;
        }
        return [bsgwFilesAry count];
    }
    else  {//只要一条正式公文
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
	if(indexPath.section == 0){
        if(indexPath.row > 1)
            return [[toDisplayHeightAry objectAtIndex:indexPath.row+2] floatValue];
        
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if(indexPath.row == 0){//不显示机密程度
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            //NSString *title2 = [toDisplayKeyTitle objectAtIndex:1];
            int num = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:0]] intValue];
            NSString *value1 = [SharedInformations getJJCDFromInt:num];
            cell = [UITableViewCell makeSubCell:tableView
                                      withTitle:title1
                                          value:value1
                                      andHeight:60];
        }
        else if(indexPath.row == 1){
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:2]];
            int num = [[jbxxDic objectForKey:[toDisplayKey objectAtIndex:3]] intValue];
            NSString *value2 = [SharedInformations getGKLXFromInt:num];
            
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else {
            NSString *itemTitle = [jbxxDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+2]];
            if (itemTitle== nil) {
                itemTitle = @"";
            }
            if(indexPath.row == 7)
                itemTitle = [NSString stringWithFormat:@"%@ %@",itemTitle,
                             [jbxxDic objectForKey:@"BNRQ"]]; //拟文日期
            CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row+2] floatValue];
            
            cell = [UITableViewCell makeSubCell:tableView
                                      withTitle:[toDisplayKeyTitle   objectAtIndex:indexPath.row+2]
                                          value:itemTitle
                                      andHeight:nHeight];
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    else {
        static NSString *identifier = @"cellFawenDetail";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if(indexPath.section == 1){
            
            if (bsgwFilesAry ==nil||[bsgwFilesAry count] == 0) {
                cell.textLabel.text = @"没有相关附件";
            }
            else{
                NSDictionary *dicTmp = [bsgwFilesAry   objectAtIndex:indexPath.row];
                cell.textLabel.text = [dicTmp objectForKey:@"WDMC"];
                NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
                cell.imageView.image = [FileUtil imageForFileExt:pathExt];
                cell.detailTextLabel.text =  [dicTmp objectForKey:@"WDDX"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
        }
        else if(indexPath.section == 2){
            if (isHaveZSGW == NO) {
                cell.textLabel.text = @"没有相关附件";
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else{
                NSString *title = [NSString stringWithFormat:@"%@.pdf",[jbxxDic objectForKey:@"WJMC"]];
               NSString *title1 = [self stringByTrimmingRightCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] oldString:title];
                cell.textLabel.text = title1;
                cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
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
        if ([bsgwFilesAry count] <= 0) {
            return;
        }

        NSDictionary *dicTmp = [bsgwFilesAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
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
    else if(indexPath.section == 2){

        
        NSString *xh = [jbxxDic objectForKey:@"XH"];
        NSString *fileName= [NSString stringWithFormat:@"%@.pdf",[jbxxDic objectForKey:@"WH"]];
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"DOWN_OA_FWZSGW" forKey:@"service"];
        [params setObject:xh forKey:@"xh"];
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:fileName];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
