//
//  UndealCaseDetailsViewController.m
//  GuangXiOA
//
//  Created by sz apple on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TingUndealCaseDetailsViewController.h"
#import "PDJsonkit.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "DisplayAttachFileController.h"
#import "NSStringUtil.h"
#import "TingHandleFileController.h"
#import "SharedInformations.h"
#import "TingReturnBackViewControllerEx.h"


@implementation TingUndealCaseDetailsViewController
@synthesize myItem,infoDic,stepAry,attachmentAry,selInfoAry;
@synthesize baseKeyArray,baseTitleArray,opinionKeyArray,opinionTitleArray;
@synthesize myTableView,isHandle,SQLBType,cellNRHeight,opinionCellHeightArray,bOKFromTransfer;
@synthesize webHelper,stepHeightAry;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.baseKeyArray = [[NSArray alloc] initWithObjects:@"SQSJ",@"JJCD",@"SQLBNR",@"BMMC",@"CBR",@"BT",@"NR", nil];
        self.baseTitleArray = [[NSArray alloc] initWithObjects:@"时       间：",@"紧急程度：",@"事项类别/编号：",@"承办单位：",@"承  办  人：",@"标       题：",@"事项主要内容：",nil];
        self.opinionKeyArray = [[NSArray alloc] initWithObjects:@"CBDWLDQZ",@"HQDWYJ",@"TBYJ",@"TLDPS", nil];
        self.opinionTitleArray = [[NSArray alloc] initWithObjects:@"承办处室／单位领导审核：",@"会签意见：",@"厅办意见：",@"厅领导批示：", nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - Private methods and delegates

-(void)HandleGWResult:(BOOL)eOK{
    bOKFromTransfer = eOK;
}

-(void)returnBackAction:(id)sender{
    TingReturnBackViewControllerEx *controller = [[TingReturnBackViewControllerEx alloc] initWithNibName:@"TingReturnBackViewControllerEx" bundle:nil];
    // controller.selInfoAry = selInfoAry;
    controller.aItem = myItem;
    controller.delegate = self;
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

-(void)banliAction:(id)sender{
   /* if([g_appDelegate isUsrTingLinDao]){
        UISendOpinionController *controller = [[UISendOpinionController alloc] initWithNibName:@"UISendOpinionController" andBanliItem:myItem];
        controller.selInfoAry = selInfoAry;
        controller.delegate = self;
        [self.navigationController pushViewController:controller
                                             animated:YES];
        [controller release];
    }
    else*/
    {
        TingHandleFileController *controller = [[TingHandleFileController alloc] initWithNibName:@"TingHandleFileController" bundle:nil];
      //  controller.selInfoAry = selInfoAry;
        controller.aItem = myItem;
        controller.delegate = self;
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
	
}

#pragma mark - View lifecycle
-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *tmpParsedJsonAry = [resultJSON objectFromJSONString];
    BOOL bParseError = NO;
    if (tmpParsedJsonAry && [tmpParsedJsonAry count] > 0) {
        
        self.infoDic = [[[tmpParsedJsonAry lastObject] objectForKey:@"nbsxInfo"] lastObject];
        
        self.stepAry = [[tmpParsedJsonAry lastObject] objectForKey:@"nbsxbz"];
        
        self.attachmentAry = [[tmpParsedJsonAry lastObject] objectForKey:@"nbsxfj"];
        
        self.selInfoAry = [[tmpParsedJsonAry lastObject] objectForKey:@"tldqp"];
        SQLBType = [[infoDic objectForKey:@"SQLB"] intValue];
        if (SQLBType == 3) {
            self.opinionKeyArray = [[NSArray alloc] initWithObjects:@"CBDWLDQZ",@"HQDWYJ",@"GCCYJ",@"TBYJ",@"TLDPS", nil];
            self.opinionTitleArray = [[NSArray alloc] initWithObjects:@"承办处室/单位领导审核：",@"会签意见：",@"规财处意见：",@"厅办意见：",@"厅领导批示：", nil];
        }
        
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
    NSString *itemTitle4 = [infoDic objectForKey:[baseKeyArray objectAtIndex:6]];

    cellNRHeight = [NSStringUtil calculateTextHeight:itemTitle4 byFont:font andWidth:520.0]+20;
    if(cellNRHeight < 60)cellNRHeight = 60.0f;

    NSMutableArray *aryTmp = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i=0; i< [opinionKeyArray count];i++) {
        NSString *key = [opinionKeyArray objectAtIndex:i];
        NSString *text = [infoDic objectForKey:key];
        CGFloat cellHeight = [NSStringUtil calculateTextHeight:text byFont:font andWidth:520.0]+20;
        if(cellHeight < 60)cellHeight = 60.0f;
        [aryTmp addObject:[NSNumber numberWithFloat:cellHeight]];
        
    }
    self.opinionCellHeightArray = aryTmp;
   
    
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
  
    
    [myTableView reloadData];
    
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
    bOKFromTransfer = NO;
   
    
    // Do any additional setup after loading the view from its nib.
    if (isHandle) {
        UIBarButtonItem *aBarItemBL = [[UIBarButtonItem alloc] initWithTitle:@"  办理  " style:UIBarButtonItemStyleBordered target:self action:@selector(banliAction:)];
        
        
        //抄送的不能退文
        if([myItem.strprocessType isEqualToString:@"READER"]){
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
    
    
    NSString *strUrl = nil;
    
    if (isHandle) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_NBSXBL" forKey:@"service"];
        [params setObject:myItem.strLCBH forKey:@"LCBH"];
        [params setObject:myItem.strLCSLBH forKey:@"LCSLBH"];
        [params setObject:myItem.strBZDYBH forKey:@"BZDYBH"];
        [params setObject:myItem.strBZBH forKey:@"BZBH"];
        [params setObject:myItem.strprocesser forKey:@"processer"];
        [params setObject:myItem.strprocessType forKey:@"processType"];
        
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        
    }
    else{
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
        [params setObject:@"QUERY_NBSXBL" forKey:@"service"];
        [params setObject:myItem.strBH forKey:@"LCSLBH"];
        strUrl = [ServiceUrlString generateTingUrlByParameters:params];
        
    }
    
  
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
   
    
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

-(void)viewDidAppear:(BOOL)animated{
    if (bOKFromTransfer) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 5;
    else if (section == 1)
        return [opinionKeyArray count];
    else if (section == 2) {
        if(attachmentAry == nil)
            return 0;
        else if ([attachmentAry count]>0)
            return [attachmentAry count];
        else return 1;
    }
    else
        return [stepAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    
    if (section == 0)
        headerView.text = @"  事项基本信息";
    else if (section == 1)
        headerView.text = @"  相关意见";
    else if (section == 2)
        headerView.text = @"  文件附件";
    else
        headerView.text = @"  步骤信息";
    
    return headerView ;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        if(indexPath.row == 1)
            return 70.0;
        else if(indexPath.row == 4)
             return cellNRHeight;
        else
            return 55;
    }        
    else if (indexPath.section == 1)
        return [[opinionCellHeightArray objectAtIndex:indexPath.row] floatValue];
    else if (indexPath.section == 2 ) {
        return 80;
    }
    else if (indexPath.section == 3)
        return [[stepHeightAry objectAtIndex:indexPath.row] floatValue];
    else 
        return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell;
    NSString *key;
    NSString *title;
    if (indexPath.section == 0) {
        if(indexPath.row == 1){

            NSString *title1 = [baseTitleArray objectAtIndex:1];
            NSString *title2 = [baseTitleArray objectAtIndex:2];
            int num = [[infoDic objectForKey:[baseKeyArray objectAtIndex:indexPath.row]] intValue];
            NSString *value1  = [SharedInformations getJJCDFromInt:num];
            
            NSString *value2 = [NSString stringWithFormat:@"%@_%d",
                                [infoDic objectForKey:@"SQLBNR"],
                                [[infoDic objectForKey:@"WJXH"] intValue]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:70];
            
        }
        else if(indexPath.row == 2){
            NSString *title1 = [baseTitleArray objectAtIndex:3];
            NSString *title2 = [baseTitleArray objectAtIndex:4];
            NSString *value1 = [infoDic objectForKey:[baseKeyArray objectAtIndex:3]];
            NSString *value2 = [infoDic objectForKey:[baseKeyArray objectAtIndex:4]];
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else {
            int div = 2;
            if(indexPath.row == 0)div = 0;
            key = [baseKeyArray objectAtIndex:indexPath.row+div];
            title = [baseTitleArray objectAtIndex:indexPath.row+div];
            NSString *value = [infoDic objectForKey:key];
            
            if (indexPath.row == 4){
                cell = [UITableViewCell makeSubCell:tableView
                                          withTitle:title
                                              value:value
                                          andHeight:cellNRHeight];
                
            }
            else    
                cell = [UITableViewCell makeSubCell:tableView
                                          withTitle:title
                                              value:value
                                          andHeight:60.0f];
        }
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1) {
        key = [opinionKeyArray objectAtIndex:indexPath.row];
        title = [opinionTitleArray objectAtIndex:indexPath.row];

        cell = [UITableViewCell makeSubCell:tableView
                                          withTitle:title
                                              value:[infoDic objectForKey:key]
                                          andHeight:[[opinionCellHeightArray objectAtIndex:indexPath.row] floatValue]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    } else if (indexPath.section == 2) {
        static NSString *CellIdentifier = @"Cell_Attachment";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) 
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        cell.textLabel.numberOfLines = 2;
        if ([attachmentAry count]>0){
            NSDictionary *aItem = [attachmentAry objectAtIndex:indexPath.row];
        
            cell.textLabel.text = [aItem objectForKey:@"WDMC"];
            NSString *pathExt = [[aItem objectForKey:@"WDMC"] pathExtension];
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
            cell.detailTextLabel.text = [aItem objectForKey:@"WDDX"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.textLabel.text = @"没有相关附件";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
    } else {
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
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *bgview = [[UIView alloc] initWithFrame:cell.contentView.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:94.0/255 blue:107.0/255 alpha:1.0];
    cell.selectedBackgroundView = bgview;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {//打开附件
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
}

@end
