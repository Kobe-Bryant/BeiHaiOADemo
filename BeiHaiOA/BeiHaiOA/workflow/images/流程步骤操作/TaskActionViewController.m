//
//  TaskActionViewController.m
//  BoandaProject
//
//  Created by 曾静 on 14-2-14.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "TaskActionViewController.h"
#import "TaskActionControl.h"
#import "TaskActionEntity.h"
#import "JointProcessFeedbackViewController.h"
#import "JointProcessTransitionViewController.h"
#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"
#import "CopyActionViewController.h"
#import "AutoTranslateViewController.h"
#import "EndorseForSeriesActionController.h"
#import "LaunchJointProcessViewController.h"

#define kWORKFLOW_FINISH_ACTION 0 //结束流程
#define kWORKFLOW_SINGLEFINISH_ACTION 1 //结束步骤

@interface TaskActionViewController ()

@end

@implementation TaskActionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"办理";
    
    UIScrollView *actionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 366, 456)];
    int rows = (self.actionList.count % 3) ? self.actionList.count/3 : self.actionList.count/3 + 1;
    CGFloat bgHeight = (rows+1)*30 + rows*112;
    actionScrollView.contentSize = CGSizeMake(366, bgHeight);
    [self.view addSubview:actionScrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    int listCount = self.actionList.count;
    int span = 30;
    int w = 82;
    int h = 112;
    int n = 3;
    for (int i = 0; i < listCount; i++)
    {
        TaskActionEntity *item = [self.actionList objectAtIndex:i];
        CGRect frame = CGRectMake(span+(span+w)*(i%n), (span+h)*(i/n)+35, w, h);
        TaskActionControl *ac = [[TaskActionControl alloc] initWithFrame:frame andMenuInfo:item];
        NSString *selectorName = [NSString stringWithFormat:@"%@:", item.actionName];
        SEL selector = NSSelectorFromString(selectorName);
        [ac addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        [actionScrollView addSubview:ac];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Event Handler Methods

-(void)finishAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_FINISH_ACTION;
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

-(void)singleFinishAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_SINGLEFINISH_ACTION;
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}


-(void)transitionAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    
    BOOL isCanJointProcess = [[self.dicActionInfo objectForKey:@"isCanJointProcess"] isEqualToString:@"true"];
    if(isCanJointProcess){
        //保存会办步骤编号
        NSArray *aryNextSteps = [self.dicActionInfo objectForKey:@"nextSteps"];
        for(NSDictionary *item in aryNextSteps){
            if([[item objectForKey:@"isJointProcessStep"] isEqualToString:@"true"])
                controller.hbbzbh = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
    
}

//发起会签
-(void)countersignAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    NSArray *aryNextSteps = [self.dicActionInfo objectForKey:@"nextSteps"];
    for(NSDictionary *item in aryNextSteps)
    {
        if([[item objectForKey:@"isCountersignStep"] isEqualToString:@"true"])
        {
            controller.nextStepId = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

-(void)sendBackAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

-(void)feedbackAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//加签
-(void)endorseAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    //"countersignType":"SERIAL"
    NSString *countersignType = [self.dicActionInfo objectForKey:@"countersignType"];
    if([countersignType isEqualToString:@"SERIAL"])
    {
        //串行
        EndorseForSeriesActionController *controller = [[EndorseForSeriesActionController alloc] initWithNibName:@"EndorseForSeriesActionController" bundle:nil];
        controller.bzbh = [self.params objectForKey:@"BZBH"];
        //controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = self.target;
        [self.target.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
        controller.bzbh = [self.params objectForKey:@"BZBH"];
        controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = self.target;
        [self.target.navigationController pushViewController:controller animated:YES];
    }
}

//会办返回
-(void)jointProcessFeedbackAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    JointProcessFeedbackViewController *controller = [[JointProcessFeedbackViewController alloc] initWithNibName:@"JointProcessFeedbackViewController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.target.navigationController pushViewController:controller animated:YES];
    controller.delegate = self.target;
}

//会办流转
-(void)jointProcessTransitionAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    JointProcessTransitionViewController *controller = [[JointProcessTransitionViewController alloc] initWithNibName:@"JointProcessTransitionViewController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [self.target.navigationController pushViewController:controller animated:YES];
    controller.delegate = self.target;
}

//抄送
-(void)copyAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    CopyActionViewController *controller = [[CopyActionViewController alloc] initWithNibName:@"CopyActionViewController" bundle:nil];
    controller.LCLXBH = [self.params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [self.params objectForKey:@"BZDYBH"];
    controller.BZBH = [self.params objectForKey:@"BZBH"];
    controller.LCSLBH = [self.params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//已阅
-(void)autotranslateAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    AutoTranslateViewController *controller = [[AutoTranslateViewController alloc] initWithNibName:@"AutoTranslateViewController" bundle:nil];
    controller.LCLXBH = [self.params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [self.params objectForKey:@"BZDYBH"];
    controller.BZBH = [self.params objectForKey:@"BZBH"];
    controller.LCSLBH = [self.params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

//发起会签
-(void)jointProcessAction:(id)sender
{
    [self.currentPopover dismissPopoverAnimated:YES];
    LaunchJointProcessViewController *controller = [[LaunchJointProcessViewController alloc] initWithNibName:@"LaunchJointProcessViewController" bundle:nil];
    controller.bzbh = [self.params objectForKey:@"BZBH"];
    BOOL isCanJointProcess = [[self.dicActionInfo objectForKey:@"isCanJointProcess"] isEqualToString:@"true"];
    if(isCanJointProcess)
    {
        //保存会办步骤编号
        NSArray *aryNextSteps = [self.dicActionInfo objectForKey:@"nextSteps"];
        for(NSDictionary *item in aryNextSteps){
            if([[item objectForKey:@"isJointProcessStep"] isEqualToString:@"true"])
                controller.hbbzbh = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[self.dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [self.target.navigationController pushViewController:controller animated:YES];
}

@end
