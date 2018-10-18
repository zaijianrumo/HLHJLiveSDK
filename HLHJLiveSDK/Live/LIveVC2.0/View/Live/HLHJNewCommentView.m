//
//  HLHJNewCommentView.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewCommentView.h"
#import "UIColor+HLHJHex.h"

@interface HLHJNewCommentView()

@end

@implementation HLHJNewCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        UITextField *commentFiled = [[UITextField alloc]init];
        commentFiled.placeholder = @"说点什么吧!";
        commentFiled.textColor = [UIColor colorWithHexString:@"333333"];
        commentFiled.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        commentFiled.layer.cornerRadius = 18;
        commentFiled.clipsToBounds = YES;
        commentFiled.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        [self addSubview:commentFiled];

        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 10)];
        commentFiled.leftView = leftView;
        commentFiled.leftViewMode = UITextFieldViewModeAlways;
        self.commentFiled = commentFiled;
        self.commentFiled.returnKeyType = UIReturnKeySend;


        UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        [self addSubview:sendBtn];
        self.sendBtn = sendBtn;

        [commentFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(15);
            make.top.equalTo(self).mas_offset(7);
            make.bottom.equalTo(self).mas_offset(-7);
            make.right.equalTo(sendBtn.mas_left).mas_offset(-15);
        }];

        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(commentFiled);
            make.right.equalTo(self).mas_offset(-15);
        }];

    }
    return self;
}

@end
