//
//  CasesInsideDetailsViewController.m
//  GuangXiOA
//
//  Created by sz apple on 11-12-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingCasesInsideDetailsViewController.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"
#import "ServiceUrlString.h"
#import "NSStringUtil.h"
#import "FileUtil.h"
#import "UITableViewCell+Custom.h"
#import "SharedInformations.h"

@implementation TingCasesInsideDetailsViewController

@synthesize caseID,myTableView,baseKeyAry,infoTitleAry;
@synthesize baseInfoDic,attachmentInfoAry;
@synthesize webHelper,toDisplayHeightAry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.baseKeyAry = [[NSArray alloc] initWithObjects:@"SQSJ",@"JJCD",@"SQLBNR",@"BMMC",@"CBR",@"BT",@"NR", @"CBDWLDQZ",@"HQDWYJ",@"TBYJ",@"TLDPS",nil];
        self.infoTitleAry = [[NSArray alloc] initWithObjects:@"时       间：",@"紧急程度：",
                              @"事项类别/编号：",@"承办单位：",@"承  办  人：",@"标       题：",@"事项主要内容：",@"承办处室／单位领导审核：",@"会签意见：",@"厅办意见：",@"厅领导批示：",nil];
        
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - Private method and delegate

- (UITableViewCell*) getCell:(NSString*) CellIdentifier forTablieView:(UITableView*) tableView
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	return cell;
}


-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        self.baseInfoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"jbxx"] lastObject];
        if (!baseInfoDic) 
            bParseError = YES;
        
        self.attachmentInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"wjxx"];
        
        if (attachmentInfoAry == nil) {
            bParseError = YES;
        }
    }
    else
        bParseError = YES;
    if (bParseError) {
        [self showAlertMessage:@"获取数据出错."];
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [baseKeyAry count];i++) {
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [baseInfoDic objectForKey:[baseKeyAry objectAtIndex:i]]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.toDisplayHeightAry = aryTmp;

    
    [myTableView reloadData];
}

-(void)processError:(NSError *)error{
    [self showAlertMessage:@"请求数据失败."];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"QUERY_NBSXCONTENT" forKey:@"service"];
    [params setObject:caseID forKey:@"id"];
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
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

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 9;
    else
        return [attachmentInfoAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    if(section == 0){
        headerView.text = @"  事项基本信息";
        
    }
    else if(section == 1) {
        headerView.text = @"  文件附件";
        
    }
    
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ){
        if(indexPath.row == 0  || indexPath.row == 2)
            return 60.0f;
        else if(indexPath.row == 1)
            return 70.0f;
        else
            return  [[toDisplayHeightAry objectAtIndex:indexPath.row+2] floatValue];
    }
    else
        return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
    NSString *key;
    NSString *title;
    if (indexPath.section == 0) {
        
        
        if(indexPath.row == 1){
            
            NSString *title1 = [infoTitleAry objectAtIndex:1];
            NSString *title2 = [infoTitleAry objectAtIndex:2];
            int num = [[baseInfoDic objectForKey:[baseKeyAry objectAtIndex:indexPath.row]] intValue];
            NSString *value1  = [SharedInformations getJJCDFromInt:num];
            
            NSString *value2 = [NSString stringWithFormat:@"%@_%d",
                                [baseInfoDic objectForKey:@"SQLBNR"],
                                [[baseInfoDic objectForKey:@"WJXH"] intValue]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:70];
            
        }
        else if(indexPath.row == 2){
            NSString *title1 = [infoTitleAry objectAtIndex:3];
            NSString *title2 = [infoTitleAry objectAtIndex:4];
            NSString *value1 = [baseInfoDic objectForKey:[baseKeyAry objectAtIndex:3]];
            NSString *value2 = [baseInfoDic objectForKey:[baseKeyAry objectAtIndex:4]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else {
            CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row+2] floatValue];
            int div = 2;
            if(indexPath.row == 0){
                div = 0;
                nHeight = 60;
            }
            key = [baseKeyAry objectAtIndex:indexPath.row+div];
            title = [infoTitleAry objectAtIndex:indexPath.row+div];
            NSString *value = [baseInfoDic objectForKey:key];
            
            cell = [UITableViewCell makeSubCell:tableView
                                      withTitle:title
                                          value:value
                                      andHeight:nHeight];
  
        }
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"caseinsidecell"];
        if (cell == nil) 
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"caseinsidecell"];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.numberOfLines = 2;
        NSDictionary *aItem = [attachmentInfoAry objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [aItem objectForKey:@"WDMC"];
        NSString *pathExt = [[aItem objectForKey:@"WDMC"] pathExtension];
        cell.imageView.image = [FileUtil imageForFileExt:pathExt];
        cell.detailTextLabel.text = [aItem objectForKey:@"WDDX"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {//打开附件

        if ([attachmentInfoAry count] <= 0) {
            return;
        }
        NSDictionary *dicTmp = [attachmentInfoAry objectAtIndex:indexPath.row];
        
        NSString *idStr = [dicTmp objectForKey:@"WDBH"];
        NSString *appidStr = [dicTmp objectForKey:@"APPBH"];
        if (idStr == nil ) {
            return;
        }
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"DOWN_OA_FILES_NEW" forKey:@"service"];
        [params setObject:appidStr forKey:@"appid"];
        [params setObject:idStr forKey:@"id"];
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
