//
//  FaWenBanliController.m
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingFaWenBanliController.h"

#import "SharedInformations.h"
#import "UITableViewCell+Custom.h"
#import "DisplayAttachFileController.h"
#import "PDJsonkit.h"
#import "NSStringUtil.h"
#import "TingHandleFileController.h"
#import "TingReturnBackViewControllerEx.h"
#import "ServiceUrlString.h"

@implementation TingFaWenBanliController
@synthesize aItem,infoDic,toDisplayKey,toDisplayKeyTitle;
@synthesize stepAry,attachmentAry,gwInfoAry,selInfoAry,resTableView,isHandle;
@synthesize toDisplayHeightAry,bOKFromTransfer;
@synthesize webHelper,stepHeightAry;

- (id)initWithNibName:(NSString *)nibNameOrNil andBanliItem:(BanLiItem*)item isBanli:(BOOL)isToBanLi
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.aItem = item;
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
-(void)returnBackAction:(id)sender{
    TingReturnBackViewControllerEx *controller = [[TingReturnBackViewControllerEx alloc] initWithNibName:@"TingReturnBackViewControllerEx" bundle:nil];
    // controller.selInfoAry = selInfoAry;
    controller.aItem = aItem;
    controller.delegate = self;
    [self.navigationController pushViewController:controller
                                         animated:YES];

}


-(void)banliAction:(id)sender{

   /* if([g_appDelegate isUsrTingLinDao]){
        UISendOpinionController *controller = [[UISendOpinionController alloc] initWithNibName:@"UISendOpinionController" andBanliItem:aItem];
        controller.selInfoAry = selInfoAry;
        controller.delegate = self;
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
    else*/
    {
        TingHandleFileController *controller = [[TingHandleFileController alloc] initWithNibName:@"TingHandleFileController" bundle:nil];
       // controller.selInfoAry = selInfoAry;
        controller.aItem = aItem;
        controller.delegate = self;
        [self.navigationController pushViewController:controller
                                             animated:YES];

    }

}


-(void)HandleGWResult:(BOOL)eOK{

    bOKFromTransfer = eOK;

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
        self.selInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"tldqp"];
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
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:19.0];
    
    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [toDisplayKey count];i++) {
        NSString *itemTitle =[NSString stringWithFormat:@"%@", [infoDic objectForKey:[toDisplayKey objectAtIndex:i]]];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:itemTitle byFont:font andWidth:520.0]+20;
        
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.toDisplayHeightAry = aryTmp;

    
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

-(void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    // Do any additional setup after loading the view from its nib.
    self.title =@"发文详细信息";
    if (isHandle) {
        
         UIBarButtonItem *aBarItemBL = [[UIBarButtonItem alloc] initWithTitle:@"  办理  " style:UIBarButtonItemStyleBordered target:self action:@selector(banliAction:)];
        
        
        //抄送的不能退文
        if([aItem.strprocessType isEqualToString:@"READER"] ){
            self.navigationItem.rightBarButtonItem = aBarItemBL;
        }else{
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
            
            
            UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            UIBarButtonItem *aBarItemTH = [[UIBarButtonItem alloc] initWithTitle:@"  退回  " style:UIBarButtonItemStyleBordered target:self action:@selector(returnBackAction:)];
            
        
            
            toolBar.items = [NSArray arrayWithObjects: aBarItemTH,flexItem,aBarItemBL,nil];
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
            self.navigationItem.rightBarButtonItem = rightItem;

        }
        
        
    }
    
    self.toDisplayKey = [NSArray arrayWithObjects:@"JJCD",@"BMJB",@"WH",@"GKLX",@"WJMC",@"ZTC",@"ZS",@"CB",@"CS",@"ZBDWHRGR",@"CSSG", @"HQDWYJ",@"BGSHG",@"NDYJ",nil];
    
    self.toDisplayKeyTitle = [NSArray arrayWithObjects:@"紧急程度：",@"机密程度：",@"发文文号：",@"信息是否公开：",@"文件标题：",@"主  题  词：",@"主       送：",@"抄       报：",@"抄       送：",@"主办处室／单位和拟稿人：",@"主办处室／单位核稿：",@"会签处室／单位意见：",@"厅办核稿意见：",@"签  发  人：",nil];
    
    
    NSString *strUrl = nil;
    if (isHandle) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_FWBL" forKey:@"service"];
        [params setObject:aItem.strLCBH forKey:@"LCBH"];
        [params setObject:aItem.strLCSLBH forKey:@"LCSLBH"];
        [params setObject:aItem.strBZDYBH forKey:@"BZDYBH"];
        [params setObject:aItem.strBZBH forKey:@"BZBH"];
        [params setObject:aItem.strprocesser forKey:@"processer"];
        [params setObject:aItem.strprocessType forKey:@"processType"];
        
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        
    }
    else{
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_FWBL" forKey:@"service"];
        [params setObject:aItem.strBH forKey:@"LCSLBH"];
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        
    }
    
    
     self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
    
    bOKFromTransfer = NO;
   
    
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


-(void)viewDidAppear:(BOOL)animated{
    if (bOKFromTransfer) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {	
    if (indexPath.section == 2 ) {
        return [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
    }
    else if (indexPath.section == 1 ) {
        return 80;
    }
    else if(indexPath.section == 0){
        if(indexPath.row > 1)//前面2行是4列所以此处＋2
            return [[toDisplayHeightAry objectAtIndex:indexPath.row+2] floatValue];
    }
	return 60.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0 )
    {
        if (infoDic) {
            return 12;
        }
        return 0;
    }
    else if (section == 1){
        if(attachmentAry ==nil)
            return 0;
        else if ([attachmentAry count] == 0) {
            return 1;
        }
        else
            return [attachmentAry count];
    }
    else if (section == 2)  {
        if(stepAry ==nil)
            return 0;
        else if ( [stepAry count] == 0) {
            return 1;
        }
        else
            return [stepAry count];
    }
    else {
        if(gwInfoAry ==nil)
            return 0;
        else if ([gwInfoAry count] == 0) {
            return 1;
        }
        else
            return [gwInfoAry count];
    }
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	

	UITableViewCell *cell = nil;

    
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:0];
            int num = [[infoDic objectForKey:[toDisplayKey objectAtIndex:0]] intValue];
            NSString *value1 = [SharedInformations getJJCDFromInt:num];
            cell = [UITableViewCell makeSubCell:tableView
                                      withTitle:title1
                                          value:value1
                                      andHeight:60];
        }
        else if(indexPath.row == 1){
            NSString *title1 = [toDisplayKeyTitle objectAtIndex:2];
            NSString *title2 = [toDisplayKeyTitle objectAtIndex:3];
            NSString *value1 = [infoDic objectForKey:[toDisplayKey objectAtIndex:2]];
            int num = [[infoDic objectForKey:[toDisplayKey objectAtIndex:3]] intValue];
            NSString *value2 = [SharedInformations getGKLXFromInt:num];
            
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else {
            
            NSString *itemTitle = [infoDic objectForKey:[toDisplayKey objectAtIndex:indexPath.row+2]];
            if (itemTitle== nil) {
                itemTitle = @"";
            }
            if(indexPath.row == 7)
                itemTitle = [NSString stringWithFormat:@"%@ %@",itemTitle,
                             [infoDic objectForKey:@"BNRQ"]];
            CGFloat nHeight = [[toDisplayHeightAry objectAtIndex:indexPath.row+2] floatValue];
            
            cell = [UITableViewCell makeSubCell:tableView
                                      withTitle:[toDisplayKeyTitle   objectAtIndex:indexPath.row+2]
                                          value:itemTitle
                                      andHeight:nHeight];
        }
       
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 1){
        static NSString *identifier = @"fujiancell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            cell.textLabel.numberOfLines = 2;
        }
        if (attachmentAry ==nil||[attachmentAry count] == 0) {
            
            cell.textLabel.text = @"没有相关附件";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else{
            NSDictionary *dicTmp = [attachmentAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ",
                                   [dicTmp objectForKey:@"WDMC"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",
                                         [dicTmp objectForKey:@"WDDX"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
            else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"doc_file.png"];
            else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"rar_file.png"];
            else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"xls_file.png"];
            else
                cell.imageView.image = [UIImage imageNamed:@"default_file.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if (indexPath.section == 2)  {
        if (stepAry ==nil||[stepAry count] == 0) {
            static NSString *identifier = @"fujiancell";
            cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
                cell.textLabel.numberOfLines = 0;
            }

            cell.textLabel.text = @"没有相关处理步骤";
        }
        else{
        NSDictionary *dicTmp = [stepAry   objectAtIndex:indexPath.row];
        NSString *title =[NSString stringWithFormat:@"%d %@",
                          indexPath.row+1,[dicTmp objectForKey:@"BZMC"] ];
        NSString *value2 =[NSString stringWithFormat:@"处理人：%@",[dicTmp objectForKey:@"YHM"] ];
        NSString *value1 =[NSString stringWithFormat:@"批示记录：%@",
                           [dicTmp objectForKey:@"CLRYJ"] ];
        NSString *value3 =[NSString stringWithFormat:@"处理时间：%@",
                           [dicTmp objectForKey:@"JSSJ"]];
        CGFloat height  = [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
        cell = [UITableViewCell makeSubCell:tableView
                                  withTitle:title
                                  SubValue1:value1 
                                  SubValue2:value2
                                  SubValue3:value3
                andHeight:height];
                                 
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.section == 3){
        static NSString *identifier = @"CellIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            cell.textLabel.numberOfLines = 0;
        }
        
        if (gwInfoAry ==nil||[gwInfoAry count] == 0) {
            cell.textLabel.text = @"没有相关数据";
        }
        else{
            NSDictionary *dicTmp = [gwInfoAry   objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ ",
                                   [dicTmp objectForKey:@"WDMC"]];
            NSString *pathExt = [[dicTmp objectForKey:@"WDMC"] pathExtension];
            if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
                cell.imageView.image = [UIImage imageNamed:@"pdf_file.png"];
            else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"doc_file.png"];
            else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"xls_file.png"];
            else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
                cell.imageView.image = [UIImage imageNamed:@"rar_file.png"];
            else
                cell.imageView.image = [UIImage imageNamed:@"default_file.png"];
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
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        
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
        NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];

        
        DisplayAttachFileController *controller = [[DisplayAttachFileController alloc] initWithNibName:@"DisplayAttachFileController"  fileURL:strUrl andFileName:[dicTmp objectForKey:@"WDMC"]];
        
        
        [self.navigationController pushViewController:controller animated:YES];

    }
}

@end

