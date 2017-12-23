//
//  LMTextHTMLParser.h
//  SimpleWord
//
//  Created by Chenly on 16/6/27.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMTextHTMLParser : NSObject

// 改变attachment.userInfo
+ (NSAttributedString *)attStringFromAttributedString:(NSAttributedString *)attributedString textView:(UITextView *)textView htmlString:(NSString *)htmlString;

+ (NSString *)HTMLFromAttributedString:(NSAttributedString *)attributedString;

@end
