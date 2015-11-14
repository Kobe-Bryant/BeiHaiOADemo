//
//  DetailCellInfo.h
//  BeiHaiOA
//
//  Created by ihumor on 14-1-15.
//  Copyright (c) 2014年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DetailCellStyle) {
    DetailCellSingleType = 1,
    DetailCellDoubleType
};

@interface DetailCellInfo : NSObject

@property (nonatomic, assign) DetailCellStyle cellType;
@property (nonatomic, assign) int rowIndex;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) NSString *leftTitle;
@property (nonatomic, strong) NSString *leftKey;
@property (nonatomic, strong) NSString *leftValue;
@property (nonatomic, strong) NSString *rightTitle;
@property (nonatomic, strong) NSString *rightKey;
@property (nonatomic, strong) NSString *rightValue;
@property (nonatomic, strong) NSDictionary *rowData;
@property (nonatomic, strong) NSString *titleInfo;
@property (nonatomic, strong) NSString *keyInfo;

- (id)initCellInfoWithRow:(int)aRow
           andWithRowData:(NSDictionary *)aData
 andWithTitleInfo:(NSString *)aTitle
   andWithKeyInfo:(NSString *)aKey;

- (CGFloat)getRowHeight;

@end
