//
//  ToDoActionsDataModel.m
//  BoandaProject
//
//  Created by 曾静 on 14-2-14.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ToDoActionsDataModel.h"
#import "PDJsonkit.h"
#import "NSURLConnHelper.h"
#import "ServiceUrlString.h"
#import "AutoTranslateViewController.h"
#import "CopyActionViewController.h"
#import "FinishActionController.h"
#import "TransitionActionControllerNew.h"
#import "CounterSignActionController.h"
#import "FeedbackActionController.h"
#import "EndorseActionController.h"
#import "ReturnBackViewController.h"
#import "JointProcessFeedbackViewController.h"
#import "JointProcessTransitionViewController.h"
#import "LaunchJointProcessViewController.h"
#import "EndorseForSeriesActionController.h"
#import "TaskActionEntity.h"
#import "TaskActionViewController.h"

#define kServiceType_XF 1
#define kServiceType_GW 2

#define kWORKFLOW_FINISH_ACTION 0
#define kWORKFLOW_SINGLEFINISH_ACTION 1

@interface ToDoActionsDataModel()
@property (nonatomic,retain) NSURLConnHelper *webHelper;
@property (nonatomic,retain) UIView *parentView;
@property (nonatomic,retain) TaskActionBaseViewController* target;
@property (nonatomic,copy) NSString *resultHtml;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSString *typeStr;
@property (nonatomic,strong) NSArray *aryAttachFiles;//附件
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,copy) NSDictionary *params;
@property (nonatomic,strong) NSDictionary *dicActionInfo;
@property (nonatomic, assign) WorkflowShowStyle showStyle;
@property (nonatomic, strong) NSArray *actionListAry;
@end

@implementation ToDoActionsDataModel
@synthesize webHelper,parentView,target,resultHtml,title,typeStr,aryAttachFiles,params,dicActionInfo,isLoading;

/**
 *  生成ToDoActionsDataModel实例
 *
 *  @param atarget 目标ViewController
 *  @param inView  展示指示器的View
 *
 *  @return ToDoActionsDataModel对象
 */
- (id)initWithTarget:(TaskActionBaseViewController*)atarget andParentView:(UIView*)inView
{
    return [self initWithTarget:atarget andParentView:inView andShowStyle:WorkflowShowStyleDefault];
}

/**
 *  生成ToDoActionsDataModel实例
 *
 *  @param aTarget 目标ViewController
 *  @param inView  展示指示器的View
 *  @param aStyle  流程动作展示样式 @see 'WorkflowShowStyle', 默认是WorkflowShowStyleDefault在导航栏显示
 *
 *  @return ToDoActionsDataModel对象
 */
- (id)initWithTarget:(TaskActionBaseViewController*)aTarget andParentView:(UIView*)inView andShowStyle:(WorkflowShowStyle)aStyle
{
    if(self = [super init])
    {
        self.parentView = inView;
        self.target = aTarget;
        self.showStyle = aStyle;
    }
    return self;
}

/**
 *  结束流程
 *
 *  @param sender 按钮
 */
- (void)finishAction:(id)sender
{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_FINISH_ACTION;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  结束步骤，不同于结束流程，适用于会办、会签时结束当前办理的步骤，不等于结束整个流程
 *
 *  @param sender 按钮
 */
- (void)singleFinishAction:(id)sender
{
    FinishActionController *controller = [[FinishActionController alloc] initWithNibName:@"FinishActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.serviceType = kWORKFLOW_SINGLEFINISH_ACTION;
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  手工流转 将视图控制器跳转到TransitionActionControllerNew中执行流转业务
 *
 *  @param sender 按钮
 */
- (void)transitionAction:(id)sender
{
    TransitionActionControllerNew *controller = [[TransitionActionControllerNew alloc] initWithNibName:@"TransitionActionControllerNew" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    
    BOOL isCanJointProcess = [[dicActionInfo objectForKey:@"isCanJointProcess"] isEqualToString:@"true"];
    if(isCanJointProcess)
    {
        //保存会办步骤编号
        NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
        for(NSDictionary *item in aryNextSteps)
        {
            if([[item objectForKey:@"isJointProcessStep"] isEqualToString:@"true"])
            {
                controller.hbbzbh = [item objectForKey:@"stepId"];
            }
        }
    }
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  发起会签
 *
 *  @param sender 按钮
 */
-(void)countersignAction:(id)sender
{
    CounterSignActionController *controller = [[CounterSignActionController alloc] initWithNibName:@"CounterSignActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
    for(NSDictionary *item in aryNextSteps)
    {
        if([[item objectForKey:@"isCountersignStep"] isEqualToString:@"true"])
        {
            controller.nextStepId = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  退回
 *
 *  @param sender 按钮
 */
- (void)sendBackAction:(id)sender
{
    ReturnBackViewController *controller = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  反馈
 *
 *  @param sender 按钮
 */
- (void)feedbackAction:(id)sender
{
    FeedbackActionController *controller = [[FeedbackActionController alloc] initWithNibName:@"FeedbackActionController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  加签
 *
 *  @param sender 按钮
 */
- (void)endorseAction:(id)sender
{
    //"countersignType":"SERIAL"
    NSString *countersignType = [dicActionInfo objectForKey:@"countersignType"];
    if([countersignType isEqualToString:@"SERIAL"])
    {
        //串行
        EndorseForSeriesActionController *controller = [[EndorseForSeriesActionController alloc] initWithNibName:@"EndorseForSeriesActionController" bundle:nil];
        controller.bzbh = [params objectForKey:@"BZBH"];
        //controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = self.target;
        [target.navigationController pushViewController:controller animated:YES];
    }
    else
    {
        EndorseActionController *controller = [[EndorseActionController alloc] initWithNibName:@"EndorseActionController" bundle:nil];
        controller.bzbh = [params objectForKey:@"BZBH"];
        controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
        controller.delegate = self.target;
        [target.navigationController pushViewController:controller animated:YES];
    }
}

/**
 *  会办返回
 *
 *  @param sender 按钮
 */
- (void)jointProcessFeedbackAction:(id)sender
{
    JointProcessFeedbackViewController *controller = [[JointProcessFeedbackViewController alloc] initWithNibName:@"JointProcessFeedbackViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    controller.delegate = self.target;
}

/**
 *  会办流转
 *
 *  @param sender 按钮
 */
- (void)jointProcessTransitionAction:(id)sender
{
    JointProcessTransitionViewController *controller = [[JointProcessTransitionViewController alloc] initWithNibName:@"JointProcessTransitionViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    [target.navigationController pushViewController:controller animated:YES];
    controller.delegate = self.target;
}

/**
 *  抄送，将某一公文抄送给其他人进行阅读
 *
 *  @param sender 按钮
 */
- (void)copyAction:(id)sender
{
    CopyActionViewController *controller = [[CopyActionViewController alloc] initWithNibName:@"CopyActionViewController" bundle:nil];
    controller.LCLXBH = [params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [params objectForKey:@"BZDYBH"];
    controller.BZBH = [params objectForKey:@"BZBH"];
    controller.LCSLBH = [params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  已阅，对于某些公文当前用户只有阅读权限，如抄送过来的
 *
 *  @param sender 按钮
 */
- (void)autotranslateAction:(id)sender
{
    AutoTranslateViewController *controller = [[AutoTranslateViewController alloc] initWithNibName:@"AutoTranslateViewController" bundle:nil];
    controller.LCLXBH = [params objectForKey:@"LCLXBH"];
    controller.BZDYBH = [params objectForKey:@"BZDYBH"];
    controller.BZBH = [params objectForKey:@"BZBH"];
    controller.LCSLBH = [params objectForKey:@"LCSLBH"];
    controller.processType = [self.dicActionInfo objectForKey:@"processType"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

/**
 *  发起会办
 *
 *  @param sender 按钮
 */
- (void)jointProcessAction:(id)sender
{
    LaunchJointProcessViewController *controller = [[LaunchJointProcessViewController alloc] initWithNibName:@"LaunchJointProcessViewController" bundle:nil];
    controller.bzbh = [params objectForKey:@"BZBH"];
    BOOL isCanJointProcess = [[dicActionInfo objectForKey:@"isCanJointProcess"] isEqualToString:@"true"];
    if(isCanJointProcess)
    {
        //保存会办步骤编号
        NSArray *aryNextSteps = [dicActionInfo objectForKey:@"nextSteps"];
        for(NSDictionary *item in aryNextSteps){
            if([[item objectForKey:@"isJointProcessStep"] isEqualToString:@"true"])
                controller.hbbzbh = [item objectForKey:@"stepId"];
        }
    }
    controller.canSignature = [[dicActionInfo objectForKey:@"canSignature"] isEqualToString:@"true"];
    controller.delegate = self.target;
    [target.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Network Handler Method

- (void)processWebData:(NSData*)webData
{
    isLoading = NO;
    if([webData length] <=0 )
        return;
    
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    self.dicActionInfo = [resultJSON objectFromJSONString];
    BOOL resultFailed = NO;
    if (dicActionInfo == nil) {
        
        resultFailed = YES;
    }
    else{
        NSString *tmp = [dicActionInfo objectForKey:@"result"];
        if(![tmp isEqualToString:@"success"])
            resultFailed = YES;
    }
    if(resultFailed){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"获取数据出错。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    [self createWorkflowActionData:self.showStyle];
}

- (void)processError:(NSError *)error
{
    isLoading = NO;
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败."
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    
    return;
}

/**
 *  请求公文的流程状态，即获取可支持流转的步骤列表
 *
 *  @param params 任务的信息
 */
- (void)requestActionDatasByParams:(NSDictionary *)info
{
    self.params = info;
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setObject:@"QUERY_TASK_STATE" forKey:@"service"];
    [dicParams setObject:[params objectForKey:@"BZBH"] forKey:@"BZBH"];
    NSString *strUrl = [ServiceUrlString generateUrlByParameters:dicParams];
    isLoading = YES;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:parentView delegate:self];
}

/**
 *  根据显示的样式创建工作流步骤选择数据
 *
 *  @param aStyle 样式 @see WorkflowShowStyle
 */
- (void)createWorkflowActionData:(WorkflowShowStyle)aStyle
{
    if(aStyle == WorkflowShowStyleDefault)
    {
        NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
        //UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //[aryBarItems addObject:flexItem];
        
        NSString *isFirstStep = [dicActionInfo objectForKey:@"isFirstStep"];
        NSString *canFinish = [dicActionInfo objectForKey:@"canFinish"];
        //结束流程
        if([canFinish isEqualToString:@"true"]){
            if(![isFirstStep isEqualToString:@"true"]){
                UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"结束流程" style:UIBarButtonItemStyleBordered target:self action:@selector(finishAction:)];
                [aryBarItems addObject:aBarItem];
            }
        }
        
        //结束步骤
        NSString *canSingleFinish = [dicActionInfo objectForKey:@"canSingleFinish"];
        if([canSingleFinish isEqualToString:@"true"]){
            if(![isFirstStep isEqualToString:@"true"]){
                UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   结  束   " style:UIBarButtonItemStyleBordered target:self action:@selector(singleFinishAction:)];
                [aryBarItems addObject:aBarItem];
            }
        }
        
        NSString *canTransition = [dicActionInfo objectForKey:@"canTransition"];
        if([canTransition isEqualToString:@"true"]){
            
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"手工流转" style:UIBarButtonItemStyleBordered target:self action:@selector(transitionAction:)];
            [aryBarItems addObject:aBarItem];
            
        }
        
        NSString *canSendback = [dicActionInfo objectForKey:@"canSendback"];
        if([canSendback isEqualToString:@"true"]){
            if(![isFirstStep isEqualToString:@"true"])
            {
                UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   退  回   " style:UIBarButtonItemStyleBordered target:self action:@selector(sendBackAction:)];
                [aryBarItems addObject:aBarItem];
            }
        }
        
        NSString *canCountersign = [dicActionInfo objectForKey:@"canCountersign"];
        if([canCountersign isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"发起会签" style:UIBarButtonItemStyleBordered target:self action:@selector(countersignAction:)];
            [aryBarItems addObject:aBarItem];
            
        }
        
        NSString *isCanFeedback = [dicActionInfo objectForKey:@"isCanFeedback"];
        if([isCanFeedback isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   反  馈   " style:UIBarButtonItemStyleBordered target:self action:@selector(feedbackAction:)];
            [aryBarItems addObject:aBarItem];
            
        }
        
        NSString *isCanEndorse = [dicActionInfo objectForKey:@"isCanEndorse"];
        if([isCanEndorse isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"   加  签   " style:UIBarButtonItemStyleBordered target:self action:@selector(endorseAction:)];
            [aryBarItems addObject:aBarItem];
            
        }
        
        //"isCanJointProcess":"false",//是否能发起会办
        NSString *isCanJointProcess = [dicActionInfo objectForKey:@"isCanJointProcess"];
        if([isCanJointProcess isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"发起会办" style:UIBarButtonItemStyleBordered target:self action:@selector(jointProcessAction:)];
            [aryBarItems addObject:aBarItem];
        }
        
        //"isCanJointProcessFeedback":"false",//是否可以会办步骤返回
        NSString *isCanJointProcessFeedback = [dicActionInfo objectForKey:@"isCanJointProcessFeedback"];
        if([isCanJointProcessFeedback isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"会办返回" style:UIBarButtonItemStyleBordered target:self action:@selector(jointProcessFeedbackAction:)];
            [aryBarItems addObject:aBarItem];
        }
        
        //"isCanJointProcessTransition":"false",//是否可以会办步骤流转
        NSString *isCanJointProcessTransition = [dicActionInfo objectForKey:@"isCanJointProcessTransition"];
        if([isCanJointProcessTransition isEqualToString:@"true"]){
            UIBarButtonItem *aBarItem = [[UIBarButtonItem  alloc] initWithTitle:@"会办流转" style:UIBarButtonItemStyleBordered target:self action:@selector(jointProcessTransitionAction:)];
            [aryBarItems addObject:aBarItem];
        }
        
        NSString *processType = [dicActionInfo objectForKey:@"processType"];
        if([processType isEqualToString:@"READER"]){
            UIBarButtonItem *aBarItemRead = [[UIBarButtonItem  alloc] initWithTitle:@"已阅" style:UIBarButtonItemStyleBordered target:self action:@selector(autotranslateAction:)];
            [aryBarItems addObject:aBarItemRead];
        }
        
        UIBarButtonItem *aBarItemCopy = [[UIBarButtonItem  alloc] initWithTitle:@"抄送" style:UIBarButtonItemStyleBordered target:self action:@selector(copyAction:)];
        [aryBarItems addObject:aBarItemCopy];
        
        //[self.view addSubview:toolBar];
        target.navigationItem.rightBarButtonItems =aryBarItems;
    }
    else if (aStyle == WorkflowShowStylePopover)
    {
        NSMutableArray *aryBarItems = [NSMutableArray arrayWithCapacity:5];
        
        NSString *isFirstStep = [dicActionInfo objectForKey:@"isFirstStep"];
        
        //结束流程
        NSString *canFinish = [dicActionInfo objectForKey:@"canFinish"];
        if([canFinish isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                TaskActionEntity *finishAction = [[TaskActionEntity alloc] init];
                finishAction.actionIcon = @"icon_结束流程.png";
                finishAction.actionName = @"finishAction";
                finishAction.actionTitle = @"结束流程";
                [aryBarItems addObject:finishAction];
            }
        }
        
        //结束步骤
        NSString *canSingleFinish = [dicActionInfo objectForKey:@"canSingleFinish"];
        if([canSingleFinish isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                TaskActionEntity *singleFinishAction = [[TaskActionEntity alloc] init];
                singleFinishAction.actionIcon = @"icon_结束步骤.png";
                singleFinishAction.actionName = @"singleFinishAction";
                singleFinishAction.actionTitle = @"结束";
                [aryBarItems addObject:singleFinishAction];
            }
        }
        
        //手工流转
        NSString *canTransition = [dicActionInfo objectForKey:@"canTransition"];
        if([canTransition isEqualToString:@"true"])
        {
            TaskActionEntity *transitionAction = [[TaskActionEntity alloc] init];
            transitionAction.actionIcon = @"icon_手工流转.png";
            transitionAction.actionName = @"transitionAction";
            transitionAction.actionTitle = @"手工流转";
            [aryBarItems addObject:transitionAction];
        }
        
        //退回
        NSString *canSendback = [dicActionInfo objectForKey:@"canSendback"];
        if([canSendback isEqualToString:@"true"])
        {
            if(![isFirstStep isEqualToString:@"true"])
            {
                TaskActionEntity *sendBackAction = [[TaskActionEntity alloc] init];
                sendBackAction.actionIcon = @"icon_退回.png";
                sendBackAction.actionName = @"sendBackAction";
                sendBackAction.actionTitle = @"退回";
                [aryBarItems addObject:sendBackAction];
            }
        }
        
        //发起会签
        NSString *canCountersign = [dicActionInfo objectForKey:@"canCountersign"];
        if([canCountersign isEqualToString:@"true"])
        {
            TaskActionEntity *countersignAction = [[TaskActionEntity alloc] init];
            countersignAction.actionIcon = @"icon_发起会签.png";
            countersignAction.actionName = @"countersignAction";
            countersignAction.actionTitle = @"发起会签";
            [aryBarItems addObject:countersignAction];
        }
        
        //反馈   
        NSString *isCanFeedback = [dicActionInfo objectForKey:@"isCanFeedback"];
        if([isCanFeedback isEqualToString:@"true"])
        {
            TaskActionEntity *feedbackAction = [[TaskActionEntity alloc] init];
            feedbackAction.actionIcon = @"icon_反馈.png";
            feedbackAction.actionName = @"feedbackAction";
            feedbackAction.actionTitle = @"反馈";
            [aryBarItems addObject:feedbackAction];
        }
        
        //加签
        NSString *isCanEndorse = [dicActionInfo objectForKey:@"isCanEndorse"];
        if([isCanEndorse isEqualToString:@"true"])
        {
            TaskActionEntity *endorseAction = [[TaskActionEntity alloc] init];
            endorseAction.actionIcon = @"icon_加签.png";
            endorseAction.actionName = @"endorseAction";
            endorseAction.actionTitle = @"加签";
            [aryBarItems addObject:endorseAction];
        }
        
        //发起会办
        NSString *isCanJointProcess = [dicActionInfo objectForKey:@"isCanJointProcess"];
        if([isCanJointProcess isEqualToString:@"true"])
        {
            TaskActionEntity *jointProcessAction = [[TaskActionEntity alloc] init];
            jointProcessAction.actionIcon = @"icon_会办.png";
            jointProcessAction.actionName = @"jointProcessAction";
            jointProcessAction.actionTitle = @"发起会办";
            [aryBarItems addObject:jointProcessAction];
        }
        
        //会办步骤返回
        NSString *isCanJointProcessFeedback = [dicActionInfo objectForKey:@"isCanJointProcessFeedback"];
        if([isCanJointProcessFeedback isEqualToString:@"true"])
        {
            TaskActionEntity *jointProcessFeedbackAction = [[TaskActionEntity alloc] init];
            jointProcessFeedbackAction.actionIcon = @"icon_会办返回.png";
            jointProcessFeedbackAction.actionName = @"jointProcessFeedbackAction";
            jointProcessFeedbackAction.actionTitle = @"会办返回";
            [aryBarItems addObject:jointProcessFeedbackAction];
        }
        
        //是否可以会办步骤流转
        NSString *isCanJointProcessTransition = [dicActionInfo objectForKey:@"isCanJointProcessTransition"];
        if([isCanJointProcessTransition isEqualToString:@"true"])
        {
            TaskActionEntity *jointProcessTransitionAction = [[TaskActionEntity alloc] init];
            jointProcessTransitionAction.actionIcon = @"icon_会办流转.png";
            jointProcessTransitionAction.actionName = @"jointProcessTransitionAction";
            jointProcessTransitionAction.actionTitle = @"会办流转";
            [aryBarItems addObject:jointProcessTransitionAction];
        }
        
        //抄送
        TaskActionEntity *copyAction = [[TaskActionEntity alloc] init];
        copyAction.actionIcon = @"icon_抄送.png";
        copyAction.actionName = @"copyAction";
        copyAction.actionTitle = @"抄送";
        [aryBarItems addObject:copyAction];
        
        //已阅
        NSString *processType = [dicActionInfo objectForKey:@"processType"];
        if([processType isEqualToString:@"READER"])
        {
            TaskActionEntity *autotranslateAction = [[TaskActionEntity alloc] init];
            autotranslateAction.actionName = @"autotranslateAction";
            autotranslateAction.actionTitle = @"已阅";
            autotranslateAction.actionIcon = @"icon_已阅.png";
            [aryBarItems addObject:autotranslateAction];
        }
        
        self.actionListAry = aryBarItems;
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem  alloc] initWithTitle:@"  办  理  " style:UIBarButtonItemStyleBordered target:self action:@selector(onRightBarClick:)];
        self.target.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

/**
 *  取消请求
 */
- (void)cancelRequest
{
    [webHelper cancel];
}

/**
 *  办理按钮点击处理事件
 *
 *  @param sender 按钮
 */
- (void)onRightBarClick:(UIBarButtonItem *)sender
{
    //2014-03-05 19:25 曾静 修复多次点击办理按钮造成系统报错的问题
    if([self.actionPopover isPopoverVisible])
    {
        [self.actionPopover dismissPopoverAnimated:YES];
    }
    else
    {
        TaskActionViewController *task = [[TaskActionViewController alloc] init];
        task.actionList = self.actionListAry;
        task.params = self.params;
        task.dicActionInfo = self.dicActionInfo;
        task.target = self.target;
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:task];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navi];
        self.actionPopover = popover;
        task.currentPopover = self.actionPopover;
        self.actionPopover.popoverContentSize = CGSizeMake(366, 456);
        [self.actionPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end
