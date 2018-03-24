//
//  KeyboardBar.h
//  键盘
//
//  Created by YT_lwf on 2018/3/23.
//  Copyright © 2018年 YT_lwf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IMInputDelegate<NSObject>

- (void)didBeginEditing:(UITextView *)textView;
- (void)didSendMessage:(UITextView *)textView;
- (void)didChangeHeight:(CGFloat)height;
- (void)didChangeMessage:(NSString *)content;

@end

@interface KeyboardBar : UIView

@property(nonatomic, weak) id<IMInputDelegate> delegate;

- (void)reloadTextViewContentString:(NSString *)content;

@end
