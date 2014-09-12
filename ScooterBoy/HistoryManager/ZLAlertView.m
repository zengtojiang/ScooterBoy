//
//  ZLAlertView.m
//  THE VOW
//
//  Created by libs on 14-4-14.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAlertView.h"

@implementation ZLAlertView

- (id)initWithMessage:(NSString *)message delegate:(id /*<ZLAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitles:(NSString *)otherButtonTitles
{
    return [self initWithTitle:nil message:message delegate:delegate cancelButtonTitle:cancelButtonTitle confirmButtonTitles:otherButtonTitles];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<ZLAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitles:(NSString *)otherButtonTitles
{
    self=[super init];
    if (self) {
        self.delegate=delegate;
        CGRect screenBounds=[UIScreen mainScreen].bounds;
        float leftMargin=50;
        float viewWidth=screenBounds.size.width-leftMargin*2;
        float viewHeight=55;//120;
        imvAlertView=[[HSStretchableImageView alloc] initWithFrame:CGRectMake(leftMargin, (screenBounds.size.height-viewHeight)/2, viewWidth, viewHeight)];
        imvAlertView.image=[UIImage imageNamed:@"cellbgyellow.png"];//[UIImage imageNamed:@"cell_bg_sel.png"];//
        [imvAlertView stretchImage];
        imvAlertView.userInteractionEnabled=YES;
        [self addSubview:imvAlertView];
        
        float topMargin=10;
        if (title&&[title length]) {
            lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(5, 8, viewWidth-10, ZL_BIG_FONT_SIZE+2)];
            lblTitle.backgroundColor=[UIColor clearColor];
            lblTitle.textAlignment=NSTextAlignmentCenter;
            lblTitle.numberOfLines=1;
            lblTitle.text=title;
            lblTitle.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_BIG_FONT_SIZE-2];
            lblTitle.textColor=[UIColor whiteColor];
            [imvAlertView addSubview:lblTitle];
            topMargin +=ZL_BIG_FONT_SIZE+6;
            viewHeight +=ZL_BIG_FONT_SIZE+6;
        }
       
        
        lblMessage=[[UILabel alloc] initWithFrame:CGRectMake(5, topMargin, viewWidth-10, 80)];
        lblMessage.backgroundColor=[UIColor clearColor];
        lblMessage.textAlignment=NSTextAlignmentCenter;
        lblMessage.numberOfLines=0;
        lblMessage.text=message;
        lblMessage.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_MIDDLE_FONT_SIZE-2];
        lblMessage.textColor=[UIColor whiteColor];
        [imvAlertView addSubview:lblMessage];
        
       CGRect messgeRect=[lblMessage textRectForBounds:CGRectMake(0, 0, viewWidth-10, 90) limitedToNumberOfLines:5];
        lblMessage.frame=CGRectMake(5, topMargin, viewWidth-10, messgeRect.size.height);
        
        topMargin +=messgeRect.size.height+18;
        viewHeight +=messgeRect.size.height+18;
        float btnLeftMargin=10;
        BOOL  hasConfirmButton=(otherButtonTitles&&[otherButtonTitles length]);
        btnCancel=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"buttonBlue.png"] forState:UIControlStateNormal];
        btnCancel.frame=hasConfirmButton?CGRectMake(btnLeftMargin, topMargin, (viewWidth-btnLeftMargin*2-10)/2, 30):CGRectMake(btnLeftMargin, topMargin, viewWidth-btnLeftMargin*2, 30);
        [btnCancel setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [btnCancel stretchImage];
        btnCancel.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
        [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnCancel.tag=[self cancelButtonIndex];
        [imvAlertView addSubview:btnCancel];
        [btnCancel addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (hasConfirmButton) {
            btnConfirm=[HSStretchableButton buttonWithType:UIButtonTypeCustom];
            [btnConfirm setBackgroundImage:[UIImage imageNamed:@"buttonRed.png"] forState:UIControlStateNormal];
            btnConfirm.frame=CGRectMake(btnLeftMargin+10+(viewWidth-btnLeftMargin*2-10)/2, topMargin, (viewWidth-btnLeftMargin*2-10)/2, 30);
            [btnConfirm setTitle:otherButtonTitles forState:UIControlStateNormal];
            [btnConfirm stretchImage];
            btnConfirm.titleLabel.font=[UIFont fontWithName:ZL_DEFAULT_FONT_NAME size:ZL_SMALL_FONT_SIZE];
            [btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btnConfirm.tag=[self confirmButtonIndex];
            [imvAlertView addSubview:btnConfirm];
            [btnConfirm addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        imvAlertView.frame=CGRectMake(leftMargin, (screenBounds.size.height-viewHeight)/2, viewWidth, viewHeight);
    }
    return self;
}

-(void)show
{
    self.frame=[UIScreen mainScreen].bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

-(NSInteger)cancelButtonIndex
{
    return 100;
}

-(NSInteger)confirmButtonIndex
{
    return 200;
}

-(void)onTapButton:(UIButton *)sender
{
    [self.delegate alertView:self clickedButtonAtIndex:sender.tag];
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
