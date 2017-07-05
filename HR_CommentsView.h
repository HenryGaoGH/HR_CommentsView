//
//  HR_CommentsView.h
//  PPWrite
//
//  Created by HenryGao on 2017/7/5.
//  Copyright © 2017年 Robot. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^HR_CommentsViewNOUserBlock)(id info);         // 无用户 返回的




@protocol HR_CommentsViewDelegate <NSObject>


- (void)HR_CommentsViewDelegate:(UIButton *)aButton Content:(NSString *)aStr;    // 发送按钮 传递 评论字符

@end


@interface HR_CommentsView : UIView<UITextViewDelegate>


@property (nonatomic,copy) HR_CommentsViewNOUserBlock hr_CommentsViewNOUserBlock;       // 无用户
@property (nonatomic,assign) id<HR_CommentsViewDelegate> hr_CommentsViewDelegate;       // 代理

@property (nonatomic,assign) BOOL isLogin;      // YES 已登录 未登录







// 展示
//- (void)HR_showAction;



// 清除
//- (void)HR_hiddenAction;









@end
