//
//  FinishFileViewController
//  GuangXiOA
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TingFinishFileViewController.h"
#import "ServiceUrlString.h"
#import "PDJsonkit.h"
#import "DisplayAttachFileController.h"


@implementation TingFinishFileViewController
@synthesize txtView,aItem,resultLabel,delegate;
@synthesize webHelper;


- (id)initWithNibName:(NSString *)nibNameOrNil andBanliItem:(BanLiItem*)item
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.aItem = item;
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

-(IBAction)btnSendOpinion:(id)sender{
    // UIButton *btn = (UIButton*)sender;
    
    NSString *opinion = @"";
    
    if ([txtView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"请填写审批意见."
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    opinion = [NSString stringWithFormat:@"%@",txtView.text];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    [params setObject:@"WORKFLOW_SINGLEFINISH_ACTION" forKey:@"service"];
    [params setObject:aItem.strLCSLBH forKey:@"workflowId"];
    [params setObject:aItem.strLCBH forKey:@"workflowDefineId"];
    [params setObject:aItem.strBZDYBH forKey:@"stepDefineId"];
    [params setObject:aItem.strBZBH forKey:@"stepId"];
    [params setObject:aItem.strprocesser forKey:@"processer"];
    [params setObject:aItem.strprocessType forKey:@"processType"];
    [params setObject:opinion forKey:@"opinion"];
    
    NSString *strUrl = [ServiceUrlString generateTingUrlByParameters:params];
 
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    
}

-(void)processWebData:(NSData*)webData{
    if([webData length] <=0 )
        return;
    BOOL bParseError = NO;
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSDictionary *dicTmp = [resultJSON objectFromJSONString];
    
    if (dicTmp){
        if ([[dicTmp objectForKey:@"result"] isEqualToString:@"true"]) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:@"办理成功"
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
 
            
        }
        else{
            NSString *message = [dicTmp objectForKey:@"message"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"错误"
                                  message:message
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
            
        }
        return;
    }
    else{
        bParseError = YES;
    }
    if (bParseError) {
        resultLabel.textColor = [UIColor redColor];
        resultLabel.text = @"结束流程失败";
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ([alertView.message isEqualToString:@"办理成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [delegate HandleGWResult:TRUE];
    }
}

-(void)processError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];

    return;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
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
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


@end
