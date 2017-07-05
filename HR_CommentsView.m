//
//  HR_CommentsView.m
//  PPWrite
//
//  Created by HenryGao on 2017/7/5.
//  Copyright © 2017年 Robot. All rights reserved.
//

#define THISHEIGHT self.frame.size.height
#define  THISWIDTH self.frame.size.width
#define ThemeColor [UIColor colorWithRed:54/255.0 green:189/255.0 blue:164/255.0 alpha:1] //产品色


#import "Header.h"


#import "HR_CommentsView.h"

@implementation HR_CommentsView{
    UITextView *hr_textView;
    int tempx;                // 记录行数
    UIButton *hr_NoLogin;     // 需要登陆
    
    
    float nowOrgin;           // 当前位置
    CGRect oldRect;           // 当前原始Frame
    float keyBoradHeight;     // 记录键盘高度

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, 54.0 / 255.0, 189.0 / 255.0, 164.0 / 255.0, 1.0);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 10, THISHEIGHT - 10);
    CGContextAddLineToPoint(context,THISWIDTH - 44, THISHEIGHT - 10);
    
    CGContextStrokePath(context);
    
    
}




- (instancetype)init{
    self = [super init];
    if (self) {
        [self HR_createView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        oldRect = frame;
        [self HR_createView];
    }
    return self;
}




- (void)HR_createView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.5,0.5);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 1;
    
    [self HR_Addction];
    
    nowOrgin = gScreenHeight - THISHEIGHT;
    
    // 输入框
    hr_textView = [UITextView new];
    hr_textView.frame = CGRectMake(10, 10, THISWIDTH - 54, THISHEIGHT - 20);
    hr_textView.delegate = self;
    hr_textView.backgroundColor = [UIColor clearColor];
    hr_textView.text = NSLocalizedString(@"Function_MicroClass_Play_Comments", "");
    hr_textView.textColor = [UIColor grayColor];
    hr_textView.showsHorizontalScrollIndicator = NO;
    [self addSubview:hr_textView];
    
    
    // 提交按钮
    UIButton *buttn = [UIButton new];
    buttn.frame = CGRectMake(hr_textView.frame.size.width + 10, self.frame.size.height - 44, 44, 44);
    [buttn setImage:[UIImage imageNamed:@"Function_MicroClass_Play_SendComment"] forState:UIControlStateNormal];
    [buttn addTarget:self action:@selector(buttonction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:buttn];
    
}





// SET
- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (hidden) {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }else{
        [self HR_Addction];
    }
}
- (void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
    if (_isLogin) { //判断 是不是 有 遮罩
        if (hr_NoLogin){
            hr_NoLogin.hidden = YES;
        }
    }else{ // 未登录
        if(hr_NoLogin){
            hr_NoLogin.hidden = NO;
            hr_NoLogin.frame = CGRectMake(0, 0, THISWIDTH, THISHEIGHT);
        }else{
            hr_NoLogin = [UIButton new];
            hr_NoLogin.frame = CGRectMake(0, 0, THISWIDTH, THISHEIGHT);
            [hr_NoLogin setTitle:NSLocalizedString(@"Function_MicroClass_Play_Login", "") forState:UIControlStateNormal];
            [hr_NoLogin setTitleColor:ThemeColor forState:UIControlStateNormal];
            hr_NoLogin.backgroundColor = [UIColor blackColor];
            hr_NoLogin.alpha = 0.5f;
            [hr_NoLogin addTarget:self action:@selector(hr_Buttonction:) forControlEvents:UIControlEventTouchUpInside];
            [self bringSubviewToFront:hr_NoLogin];
            [self addSubview:hr_NoLogin];
        }
    }
    
    
    
}










// 未登录 按钮
- (void)hr_Buttonction:(UIButton *)aButton{
    self.hr_CommentsViewNOUserBlock(aButton);
}

// 发送按钮
- (void)buttonction:(UIButton *)aButton{
    
    [self HR_ReastStatus];
    if (_hr_CommentsViewDelegate && [_hr_CommentsViewDelegate respondsToSelector:@selector(HR_CommentsViewDelegate:Content:)]) {
        [self.hr_CommentsViewDelegate HR_CommentsViewDelegate:aButton Content:hr_textView.text];
    }
    
}



- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:NSLocalizedString(@"Function_MicroClass_Play_Comments", "")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    // 占位文字
    if(textView.text.length == 0){
        textView.text = NSLocalizedString(@"Function_MicroClass_Play_Comments", "");
        textView.textColor = [UIColor grayColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView{

    float rows = (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font.lineHeight;
    if (rows > 3 || (int)rows == 1) return;
    
    if (tempx == (int)rows) return;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame = CGRectMake(0, nowOrgin - textView.font.lineHeight, THISWIDTH, THISHEIGHT + textView.font.lineHeight);
        textView.frame = CGRectMake(10, 10, textView.bounds.size.width, textView.bounds.size.height + textView.font.lineHeight);
        nowOrgin = nowOrgin - textView.font.lineHeight;
    }];
    [self setNeedsDisplay];
    
    tempx = (int)rows;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@" "]) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        return NO;
    }
    
    
    if ([text isEqualToString:@"\r\r"]) {
        textView.text = [textView.text stringByAppendingString:@" "];
        
        return NO;
    }

    
    return YES;
}






#pragma 重置状态
- (void)HR_ReastStatus{
    [self endEditing:YES];
    self.frame = oldRect;
    nowOrgin = gScreenHeight - oldRect.size.height;
    hr_textView.text = @"";
    [self textViewDidEndEditing:hr_textView];
}







#pragma mark 键盘事件
- (void)HR_Addction{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyBoradHeight = keyboardRect.size.height;
    
    
    self.frame = CGRectMake(0, nowOrgin - keyBoradHeight, gScreenWidth, THISHEIGHT);
    nowOrgin = nowOrgin - keyBoradHeight;
    
}
- (void)keyboardWillhide:(NSNotification *)aNotification{
    self.frame = CGRectMake(0, nowOrgin + keyBoradHeight, gScreenWidth, THISHEIGHT);
    nowOrgin = nowOrgin + keyBoradHeight;
}






- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}







@end
