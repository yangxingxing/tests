//
//  LMTextHTMLParser.m
//  SimpleWord
//
//  Created by Chenly on 16/6/27.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import "LMTextHTMLParser.h"
#import "LMParagraphConfig.h"
#import "UIFont+LMText.h"
#import "NSTextAttachment+LMText.h"
#import "TFHpple.h"

@implementation LMTextHTMLParser

// 改变attachment.userInfo
+ (NSAttributedString *)attStringFromAttributedString:(NSAttributedString *)attributedString textView:(UITextView *)textView htmlString:(NSString *)htmlString {
    NSMutableAttributedString *copyAttr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    NSRange effectiveRange = NSMakeRange(0, 0);
    int section = 0;
    NSArray *secArr = [self getSrcArrWithHtmlString:htmlString];
    while (effectiveRange.location + effectiveRange.length < attributedString.length) {
        
        NSDictionary *attributes = [attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        NSTextAttachment *attachment = attributes[@"NSAttachment"];
        
        if (attachment) {
            attachment.attachmentType = LMTextAttachmentTypeImage;
            attachment.userInfo = secArr[section]; // 获取网络图片路径
            section++;
            //
            NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:@"\n"];
            [attributedStr insertAttributedString:attachmentString atIndex:0];
            
            [attributedStr addAttributes:textView.typingAttributes range:NSMakeRange(0, attributedStr.length)];
            // 添加样式
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
            paragraphStyle.paragraphSpacingBefore = 8.f;
            paragraphStyle.paragraphSpacing = 8.f;
            [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
            
            [copyAttr replaceCharactersInRange:effectiveRange withAttributedString:attributedStr];
        }
        effectiveRange = NSMakeRange(effectiveRange.location + effectiveRange.length, 0);
    }
    return copyAttr;
}

+ (NSArray *)getSrcArrWithHtmlString:(NSString *)htmlString {
    NSData *data =[htmlString dataUsingEncoding:NSUnicodeStringEncoding];
    NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];   //data转字符串 为了打印不是乱码
    SLog(@"------%@",result);
    
    TFHpple *Hpple = [[TFHpple alloc]initWithHTMLData:data];
    
    NSArray *array =[Hpple searchWithXPathQuery:@"//img"]; //获取到为img标签数组
    NSMutableArray *secArr = [NSMutableArray array];
    for (TFHppleElement *HppleElement in array) {
        NSDictionary *node = HppleElement.attributes;
        [secArr addObject:node[@"src"]];
    }
    return secArr;
}

/**
 *  将原生的 AttributedString 导出成 HTML，用于 Web 端显示，可以根据自己需求修改导出的 HTML 内容，比如添加 class 或是 id 等。
 *
 *  @param attributedString 需要被导出的富文本
 *
 *  @return 导出的 HTML
 */
+ (NSString *)HTMLFromAttributedString:(NSAttributedString *)attributedString {
    
    BOOL isNewParagraph = YES;
    NSMutableString *htmlContent = [NSMutableString string];
    NSRange effectiveRange = NSMakeRange(0, 0);
    while (effectiveRange.location + effectiveRange.length < attributedString.length) {
        
        NSDictionary *attributes = [attributedString attributesAtIndex:effectiveRange.location effectiveRange:&effectiveRange];
        NSTextAttachment *attachment = attributes[@"NSAttachment"];
        NSParagraphStyle *paragraph = attributes[@"NSParagraphStyle"];
        LMParagraphConfig *paragraphConfig = [[LMParagraphConfig alloc] initWithParagraphStyle:paragraph type:LMParagraphTypeNone];
        if (attachment) {
            switch (attachment.attachmentType) {
                case LMTextAttachmentTypeImage: // attachment.fileWrapper.preferredFilename
                [htmlContent appendString:[NSString stringWithFormat:@"<img src=\"%@\" width=\"100%%\"/>", attachment.userInfo]];
                break;
                default:
                break;
            }
        }
        else {
            NSString *text = [[attributedString string] substringWithRange:effectiveRange];
            UIFont *font = attributes[NSFontAttributeName];
            UIColor *fontColor = attributes[@"NSColor"];
            NSString *color = [self hexStringWithColor:fontColor];
            BOOL underline = [attributes[NSUnderlineStyleAttributeName] boolValue];
            
            BOOL isFirst = YES;
            
            NSArray *components = [text componentsSeparatedByString:@"\n"];
            for (NSInteger i = 0; i < components.count; i ++) {
                
                NSString *content = components[i];
                
                if (!isFirst && !isNewParagraph) {
                    [htmlContent appendString:@"</p>"];
                    isNewParagraph = YES;
                }
                if (isNewParagraph && (content.length > 0 || i < components.count - 1)) {
                    [htmlContent appendString:[NSString stringWithFormat:@"<p style=\"text-indent:%@em;margin:4px auto 0px auto;\">", @(2 * paragraphConfig.indentLevel).stringValue]];
                    isNewParagraph = NO;
                }
                [htmlContent appendString:[self HTMLWithContent:content font:font underline:underline color:color]];
                isFirst = NO;
            }
            if (effectiveRange.location + effectiveRange.length >= attributedString.length && ![htmlContent hasSuffix:@"</p>"]) {
                // 补上</p>
                [htmlContent appendString:@"</p>"];
            }
        }
        effectiveRange = NSMakeRange(effectiveRange.location + effectiveRange.length, 0);
    }
    return [htmlContent copy];
}

+ (NSString *)HTMLWithContent:(NSString *)content font:(UIFont *)font underline:(BOOL)underline color:(NSString *)color {
    
    if (content.length == 0) {
        return @"";
    }
    
    if (font.bold) {
        content = [NSString stringWithFormat:@"<b>%@</b>", content];
    }
    if (font.italic) {
        content = [NSString stringWithFormat:@"<i>%@</i>", content];
    }
    if (underline) {
        content = [NSString stringWithFormat:@"<u>%@</u>", content];
    }
    return [NSString stringWithFormat:@"<font style=\"font-size:%f;color:%@\">%@</font>", font.fontSize, color, content];
}

+ (NSString *)hexStringWithColor:(UIColor *)color {
    
    NSString *colorString = [[CIColor colorWithCGColor:color.CGColor] stringRepresentation];
    NSArray *parts = [colorString componentsSeparatedByString:@" "];
    
    NSMutableString *hexString = [NSMutableString stringWithString:@"#"];
    for (int i = 0; i < 3; i ++) {
        [hexString appendString:[NSString stringWithFormat:@"%02X", (int)([parts[i] floatValue] * 255)]];
    }
    return [hexString copy];
}

@end
