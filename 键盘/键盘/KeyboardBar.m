//
//  KeyboardBar.m
//  键盘
//
//  Created by YT_lwf on 2018/3/23.
//  Copyright © 2018年 YT_lwf. All rights reserved.
//

#import "KeyboardBar.h"

#define UICOLOR_HEX_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]

static CGFloat const defaultBarHeight = 49;
static CGFloat const defaultInputHeight = 35;
static CGFloat const leftPadding = 10;

@interface KeyboardBar()<UITextViewDelegate>

@property(nonatomic, assign) CGFloat kWidth;
@property(nonatomic, assign) CGFloat kHeight;
@property(nonatomic, assign) CGFloat keyboardHeight;

@property(nonatomic, strong) UIView *messageBar;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *audioButton;
@property(nonatomic, strong) UIButton *audioLpButton;
@property(nonatomic, strong) UIButton *swtFaceButton;
@property(nonatomic, strong) UIButton *swtHandleButton;

@end

@implementation KeyboardBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.kWidth = [UIScreen mainScreen].bounds.size.width;
        self.kHeight =  [UIScreen mainScreen].bounds.size.height;
        [self addSubview:self.messageBar];
        [self initLayout];
        [self registNotification];
    }
    return self;
}

#pragma mark --- Layout

- (void)initLayout {
    self.messageBar.frame = CGRectMake(0, 0, self.kWidth, defaultBarHeight);
    
    self.audioButton.frame = CGRectMake(leftPadding, (CGRectGetHeight(self.messageBar.frame) - 30)*0.5, 30, 30);
    self.audioLpButton.frame = CGRectMake(CGRectGetMaxX(self.audioButton.frame)+15,(CGRectGetHeight(self.messageBar.frame)-defaultInputHeight)*0.5, self.kWidth - 155, defaultInputHeight);
    self.textView.frame = self.audioLpButton.frame;
    self.swtFaceButton.frame  = CGRectMake(CGRectGetMaxX(self.textView.frame)+15, (CGRectGetHeight(self.messageBar.frame)-30)*0.5,30, 30);
    self.swtHandleButton.frame = CGRectMake(CGRectGetMaxX(self.swtFaceButton.frame)+15, (CGRectGetHeight(self.messageBar.frame)-30)*0.5, 30, 30);
}

#pragma mark --- InitData
- (void)registNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark --- Public

#pragma mark --- Event

- (void)audioButtonClick:(UIButton *)btn {
    
}

- (void)switchFaceKeyboard:(UIButton *)swtFaceButton{
    
}

- (void)switchHandleKeyboard:(UIButton *)swtHandleButton{
   
}

- (void)audioLpButtonTouchDown:(UIButton *)audioLpButton{

}

- (void)audioLpButtonMoveOut:(UIButton *)audioLpButton{

}

- (void)audioLpButtonMoveOutTouchUp:(UIButton *)audioLpButton{

}

- (void)audioLpButtonMoveInside:(UIButton *)audioLpButton{
    
}

- (void)audioLpButtonTouchUpInside:(UIButton *)audioLpButton{
   
}

#pragma mark --- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    CGFloat oldHeight  = [change[@"old"] CGSizeValue].height;
    CGFloat newHeight = [change[@"new"] CGSizeValue].height;
    if (oldHeight <=0 || newHeight <=0) return;
    if (newHeight != oldHeight) {
        CGFloat inputHeight = newHeight > defaultInputHeight ? newHeight : defaultInputHeight;
        [self msgTextViewHeightFit:inputHeight];
    }
}

- (void)systemKeyboardWillShow:(NSNotification *)note{
    CGFloat systemKbHeight  = [note.userInfo[@"UIKeyboardBoundsUserInfoKey"]CGRectValue].size.height;
    self.keyboardHeight = systemKbHeight;
    [self customKeyboardMove:self.kHeight - systemKbHeight - CGRectGetHeight(self.messageBar.frame)];
}

- (void)systemKeyboardWillHide:(NSNotification *)note{
    CGFloat systemKbHeight  = [note.userInfo[@"UIKeyboardBoundsUserInfoKey"]CGRectValue].size.height;
    self.keyboardHeight = systemKbHeight;
    [self customKeyboardMove:self.kHeight - defaultBarHeight];
}

#pragma mark --- Private

- (void)msgTextViewHeightFit:(CGFloat)msgViewHeight{
    self.messageBar.frame = CGRectMake(0, 0, self.kWidth, msgViewHeight +CGRectGetMinY(self.textView.frame)*2);
    self.textView.frame = CGRectMake(CGRectGetMinX(self.textView.frame),(CGRectGetHeight(self.messageBar.frame)-msgViewHeight)*0.5, CGRectGetWidth(self.textView.frame), msgViewHeight);
    self.frame = CGRectMake(0,self.kHeight - self.keyboardHeight - CGRectGetHeight(self.messageBar.frame), self.kWidth,CGRectGetHeight(self.messageBar.frame));
}

- (void)customKeyboardMove:(CGFloat)customKbY{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0,customKbY, self.kWidth, CGRectGetHeight(self.frame));
    }];
}

#pragma mark --- UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(didChangeMessage:)]) {
        [self.delegate didChangeMessage:textView.text];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.delegate respondsToSelector:@selector(didBeginEditing:)]) {
        [self.delegate didBeginEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if ([self.delegate respondsToSelector:@selector(didSendMessage:)]) {
            [self.delegate didSendMessage:textView];
        }
        if ([self.delegate respondsToSelector:@selector(didChangeMessage:)]) {
            [self.delegate didChangeMessage:@""];
            [self msgTextViewHeightFit:defaultInputHeight];
        }
        return NO;
    }
    if ([text isEqualToString:@""""]) {//删除
         return NO;
    }
    return YES;
}


#pragma mark --- Get

- (UIView *)messageBar
{
    if (!_messageBar) {
        _messageBar = [[UIView alloc]init];
        _messageBar.backgroundColor = UICOLOR_HEX_Alpha(0xe6e6e6, 1);
        [_messageBar addSubview:self.audioButton];
        [_messageBar addSubview:self.textView];
        [_messageBar addSubview:self.audioLpButton];
        [_messageBar addSubview:self.swtFaceButton];
        [_messageBar addSubview:self.swtHandleButton];
    }
    return _messageBar;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = 1.0;
        [_textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return _textView;
}

- (UIButton *)audioButton{
    if (!_audioButton) {
        _audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioButton setImage:[UIImage imageNamed:@"chat_audio"] forState:UIControlStateNormal];
        [_audioButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioButton;
}

- (UIButton *)swtFaceButton{
    if (!_swtFaceButton) {
        _swtFaceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_swtFaceButton setImage:[UIImage imageNamed:@"chat_enjoy"] forState:UIControlStateNormal];
        [_swtFaceButton addTarget:self action:@selector(switchFaceKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swtFaceButton;
}

- (UIButton *)swtHandleButton{
    if (!_swtHandleButton) {
        _swtHandleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_swtHandleButton setImage:[UIImage imageNamed:@"chat_more"] forState:UIControlStateNormal];
        [_swtHandleButton addTarget:self action:@selector(switchHandleKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swtHandleButton;
}

- (UIButton *)audioLpButton{
    if (!_audioLpButton) {
        _audioLpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_audioLpButton setTitle:@"按住说话" forState:UIControlStateNormal];
        [_audioLpButton setTitle:@"松开发送" forState:UIControlStateHighlighted];
        [_audioLpButton setTitleColor:UICOLOR_HEX_Alpha(0x333333, 1) forState:UIControlStateNormal];
        _audioLpButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _audioLpButton.hidden = YES;
        _audioLpButton.layer.borderColor = UICOLOR_HEX_Alpha(0x999999, 1).CGColor;
        _audioLpButton.layer.borderWidth = 1.0f;
        _audioLpButton.layer.cornerRadius = 5;
        _audioLpButton.layer.masksToBounds = YES;
        //按下录音按钮
        [_audioLpButton addTarget:self action:@selector(audioLpButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        //手指离开录音按钮 , 但不松开
        [_audioLpButton addTarget:self action:@selector(audioLpButtonMoveOut:) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchDragOutside];
        //手指离开录音按钮 , 松开
        [_audioLpButton addTarget:self action:@selector(audioLpButtonMoveOutTouchUp:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        //手指回到录音按钮,但不松开
        [_audioLpButton addTarget:self action:@selector(audioLpButtonMoveInside:) forControlEvents:UIControlEventTouchDragInside|UIControlEventTouchDragEnter];
        //手指回到录音按钮 , 松开
        [_audioLpButton addTarget:self action:@selector(audioLpButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _audioLpButton;
}


#pragma mark --- Set


@end
