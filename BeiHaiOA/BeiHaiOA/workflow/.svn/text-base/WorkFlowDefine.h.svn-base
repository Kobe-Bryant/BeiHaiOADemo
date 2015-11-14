//
//  WorkFlowDefine.h
//  BeiHaiOA
//
//  Created by 曾静 on 14-2-27.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#ifndef BeiHaiOA_WorkFlowDefine_h
#define BeiHaiOA_WorkFlowDefine_h

#import <Foundation/Foundation.h>
#import "TaskActionBaseViewController.h"

//动作展示方式
typedef NS_ENUM(NSInteger, WorkflowShowStyle) {
    WorkflowShowStyleDefault = 0, //1.默认在导航栏显示
    WorkflowShowStylePopover = 1 //2.以Popover的方式显示
};

//流程步骤类型
typedef NS_ENUM(NSInteger, WorkflowStepType) {
    WorkflowStepTypeFinish = 0,//1.结束流程 canFinish
    WorkflowStepTypeSingleFinish = 1,//2.结束步骤 canSingleFinish
    WorkflowStepTypeTransition = 2,//3.手工流转 canTransition
    WorkflowStepTypeSendBack = 3 ,//4.退回 canSendback
    WorkflowStepTypeCounterSign = 4,//5.发起会签 canCountersign
    WorkflowStepTypeFeedBack = 5,//6.反馈 isCanFeedback
    WorkflowStepTypeEndorse = 6,//7.加签 isCanEndorse
    WorkflowStepTypeJointProcess = 7,//8.发起会办  isCanJointProcess
    WorkflowStepTypeJointProcessFeedBack = 8,//9.会办返回 isCanJointProcessFeedback
    WorkflowStepTypeJointProcessTransition = 9,//10.会办流转 isCanJointProcessTransition
    WorkflowStepTypeReader = 10,//11.已阅 READER
    WorkflowStepTypeCopy = 11//12.抄送 COPY
};

#endif
