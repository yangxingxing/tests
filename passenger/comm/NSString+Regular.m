//
//  NSString+Regular.m
//  114SD
//
//  Created by 杨星星 on 2017/3/25.
//  Copyright © 2017年 杨星星. All rights reserved.
//

#import "NSString+Regular.h"
#import "wConsts.h"
#import "SBJsonParser.h"
#import "SBJsonWriter.h"

@implementation NSString (Regular)

//过滤空字符串(和其他特殊字符串)
+(NSString*)filterEmptyString:(NSString*)str{
    NSString*nStr=[[str description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString*eStr=[nStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    return eStr;
}


- (BOOL)isValidWithRegex:(NSString *) regex {
    BOOL result = NO;
    
    if (regex != nil && self && self.length > 0) {
        NSError *error = nil;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:0 error:&error];
        NSRange range = [regularExpression rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
        if (range.location != NSNotFound) {
            result = YES;
        }
    }
    
    return result;
}
- (BOOL)isChinese{
    BOOL flag=YES;
    for (int i=0;i<self.length;i++){
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[self substringWithRange:range];
        const char *cString=[subString UTF8String];
        if (!cString||strlen(cString)!=3)
            flag=NO;
        else
            return YES;
    }
    return flag;
}

- (BOOL)isChineseName {
    static NSString *chineseNameRegex = @"^[\\u4e00-\\u9fa5]{2,20}$";
    return [self isValidWithRegex:chineseNameRegex];
}

-(BOOL)isNum{
    static NSString*numRegex=@"[0-9]";
    return [self isValidWithRegex:numRegex];
}

-(BOOL)isQQNum{
    static NSString*qqNumRegex=@"[0-9]{5,11}";
    return [self isValidWithRegex:qqNumRegex];
}
//固定电话
-(BOOL)isTelePhone{
    
    static NSString *phoneNumberRegex = @"0\\d{2,3}-\\d{5,9}|0\\d{2,3}-\\d{5,9}";
    return [self isValidWithRegex:phoneNumberRegex];
}

- (BOOL)isPhoneNumber {
    
    static NSString *phoneNumberRegex = @"^1(3[0-9]|4[0-9]|7[0-9]|5[0-9]|8[0-9])\\d{8}$";
    
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0235-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789])\\d{7}$";
    NSString * PHSS = @"^0(\\d{3})\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestphss = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHSS];
    
    return [regextestmobile evaluateWithObject:self]
    || [regextestcm evaluateWithObject:self]
    || [regextestct evaluateWithObject:self]
    || [regextestcu evaluateWithObject:self]
    || [regextestphs evaluateWithObject:self]
    || [regextestphss evaluateWithObject:self]
    || [self isValidWithRegex:phoneNumberRegex];
}

-(BOOL)isEmail{
    static NSString*emailRegex=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    BOOL isemail =[self isValidWithRegex:emailRegex];
    return isemail;
    
}
-(BOOL)isAccount{
    
    static NSString * emailRegex = @"^[a-zA-Z][a-zA-Z0-9]{5,19}";
    if ([self isValidWithRegex:emailRegex]) {
        if (self.length == 6) {
            return YES;
        }else{
            static NSString * r = @"[a-zA-Z0-9]";
            int len = 6;
            for (int i = len; i < self.length; i++) {
                NSRange range = NSMakeRange(len, 1);
                NSString *substr = [self substringWithRange:range];
                if ([substr isValidWithRegex:r]) {
                    len++;
                }
            }
            return (len == self.length);
        }
        
    }else{
        return NO;
    }
    
    //    static NSString*emailRegex=@"^[a-zA-Z][a-zA-Z0-9]{5,19}";
    //    return [self isValidWithRegex:emailRegex];
    
}
-(BOOL)isSHIYIWEI{
    static NSString*emailRegex=@"[0-9]{7,11}";
    
    return [self isValidWithRegex:emailRegex];
}
//邮编
- (BOOL)isZipCode {
    static NSString *chineseNameRegex = @"[1-9]\\d{5}(?!\\d)";
    return [self isValidWithRegex:chineseNameRegex];
}

- (BOOL)isURL
{
    //安卓那边拷过来的，比较全
    NSString *GOOD_IRI_CHAR = @"a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF";
    NSString *IRI = [NSString stringWithFormat:@"[%@]([%@\\-]{0,61}[%@]){0,1}",GOOD_IRI_CHAR,GOOD_IRI_CHAR,GOOD_IRI_CHAR];
    NSString *GOOD_GTLD_CHAR =@"a-zA-Z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF";
    NSString *GTLD = [NSString stringWithFormat:@"[%@]{2,63}",GOOD_GTLD_CHAR];
    NSString *HOST_NAME = [NSString stringWithFormat:@"(%@\\.)%@",IRI,GTLD];
    NSString *IP_ADDRESS = @"((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9]))";
    NSString *DOMAIN_NAME = [NSString stringWithFormat:@"(%@|%@)",HOST_NAME,IP_ADDRESS];
    NSString *regex = [NSString stringWithFormat:@"((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%%[a-fA-F0-9]{2})){1,25})?\\@)?)?(?:%@)(?:\\:\\d{1,5})?)(\\/(?:(?:[%@\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%%[a-fA-F0-9]{2}))*)?(?:\\b|$)",DOMAIN_NAME,GOOD_IRI_CHAR];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

-(NSString*)trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString*)quotedStr
{
    NSString *s = self;
    if (![NSString vaildateStr: s])
        s = SStringEmpty;
    
    static NSString * const singQuert = @"'";
    
    NSMutableString *result = [NSMutableString stringWithString:s];
    [result replaceOccurrencesOfString:singQuert withString:@"''"
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, result.length)];
    [result insertString:singQuert atIndex:0];
    [result appendString:singQuert];
    
    return result;
    
}

//判断字符串 不为null
+(BOOL)vaildateStr:(NSString*)str
{
    BOOL result = YES;
    if (!str || ![str isKindOfClass:[NSString class]] ||
        [str isEqualToString:@"<null>"] ||
        [str isEqualToString:@"(null)"])
        result = NO;
    return result;
}

//            如果中间插入的话，会把最后面的内容切掉
//            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:_maxLen];
//            //删除多出来的部份
//            NSRange delRange = NSMakeRange(rangeIndex.location, toBeString.length - rangeIndex.location);
//            self.selectedRange = delRange;
//            [self replaceRange:self.selectedTextRange withText:@""];
//            delRange.length = 0;
//            [self scrollRangeToVisible: delRange];

//如果字符串 为 null, 则返回空字符 @""
+(NSString*)nullOfEmptyStr:(NSString*)str
{
    NSString *result = str;
    if (![self vaildateStr:str])
        result = SStringEmpty;
    return result;
}

//JOSN 转 NSDictionary
-(NSDictionary*)JSONToDictionary
{
    NSData *data = [self dataUsingEncoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableLeaves
                                                           error:&error];
    if (!dict && error)
    {
        SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
        dict = [jsonParser objectWithString:self];
#if ! __has_feature(objc_arc)
        [jsonParser release];
#endif
    }
    return dict;
}

+(NSString *)stringFromJSONDictionary:(NSDictionary*)JSONData
{
    NSError *error;
    NSData *dJson = [NSJSONSerialization dataWithJSONObject:JSONData
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:&error];
    if (dJson)
    {
        NSString *str = [[NSString alloc] initWithData: dJson encoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
        [str autorelease];
#endif
        return str;
    }
    else
    {
        SBJsonWriter * jsonWriter = [[SBJsonWriter alloc] init];
        NSString *s = [jsonWriter stringWithObject:JSONData];
        
#if ! __has_feature(objc_arc)
        [jsonWriter release];
#endif
        
        return s;
    }
    return nil;
}

- (CGSize)calcSizeWithFont:(UIFont *)font
{
    return [self calcSizeWithFont:font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode: NSLineBreakByWordWrapping];
}

- (CGSize)calcSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size // Uses NSLineBreakByWordWrapping
{
    return [self calcSizeWithFont:font constrainedToSize:size lineBreakMode: NSLineBreakByWordWrapping];
}

- (CGSize)calcSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        paragraphStyle.alignment     = NSTextAlignmentLeft;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        
        result = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes context:nil].size;
#if ! __has_feature(objc_arc)
        [paragraphStyle release];
#endif
    }
    else
    {
        result = [self calcSizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
    
    /*
     This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.
     */
    result.height = ceil(result.height);
    result.width  = ceil(result.width);
    return result;
}

//字符版本串转，数字 1.0.1 转为 1.01
-(CGFloat)stringToFloatVer
{
    NSRange range = [self rangeOfString:@"." options:NSBackwardsSearch];
    NSRange first = [self rangeOfString:@"."];
    NSString *ver = self;
    if (range.length > 0 && first.location != range.location) //只处理两个点时如1.0.1
        ver = [ver stringByReplacingCharactersInRange:range withString:SStringEmpty];
    return [ver doubleValue];
}

//返回今年的第几天
- (NSInteger)daysInTistYearWithDate:(NSString *)dateString{
    int i=0;
    NSArray*dates=[dateString componentsSeparatedByString:@"-"];
    int year=[dates[0] intValue];
    int mothe=[dates[1] intValue];
    int day=[dates[2] intValue];
    if (year%400==0||(year%100!=0&&year%4==0)) {
        i+=1;
    }
    switch (mothe) {
        case 12:
            i+=30;
        case 11:
            i+=30;
        case 10:
            i+=31;
        case 9:
            i+=30;
        case 8:
            i+=31;
        case 7:
            i+=30;
        case 6:
            i+=31;
        case 5:
            i+=30;
        case 4:
            i+=31;
        case 3:
            i+=28;
        case 2:
            i+=31;
        case 1:
            i+=day;
            break;
        default:
            break;
    }
    return i;
}

//手机号码中间4位用*代替
-(NSString *)handlePhoneSecrect{
    if (self.length >= 11) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(4, self.length - 8) withString:@"****"];
        
        //        NSString *behindFour = [self substringFromIndex:self.length-4];//后4位
        //        NSString *front = [self substringToIndex:self.length-4-4];
        //        NSString *phoneHandled = [NSString stringWithFormat:@"%@****%@",front,behindFour];
        //
        //        return phoneHandled;
    }else
        return self;
}

//券号按位隔开
- (NSString *)ticketNumberSeparate:(int)digits {
    return [self ticketSeparate:digits];
}

//券号四位隔开
- (NSString *)ticketNumberSeparate {
    return [self ticketSeparate:5];
}

- (NSString *)ticketSeparate:(int)digits {
    NSString *reString = [[NSString alloc]init];
    NSString *tempString = nil;
    if (self.length>digits) {
        int count = self.length%digits == 0?self.length/digits:self.length/digits+1;
        for (int i = 0; i<count; i++) {
            if (self.length - i*digits <digits) {
                tempString = [self substringWithRange:NSMakeRange(i*digits, self.length- i*digits)];
            }
            else
            {
                tempString = [self substringWithRange:NSMakeRange(i*digits,digits)];
            }
            if (i == 0) {
                reString = [NSString stringWithFormat:@"%@",tempString];
            }else{
                reString = [NSString stringWithFormat:@"%@ %@",reString,tempString];
            }
        }
    }
    else
    {
        reString = self;
    }
    return reString;
}


//商城钱保留小数点两位
-(NSString *)removeZeroAtTheBackOfTheDecimalPoint
{
    return [self numDecimalAndRemoveLastZeroWithMaxDecimal:2];
}

//去掉小数点后面最后一位的0,小数保留两位数,第三位四舍五入   Decimal为要保留的最长位数(fengshen)
-(NSString *)numDecimalAndRemoveLastZeroWithMaxDecimal:(int)Decimal
{
    NSRange range = [self rangeOfString:@"."];
    if (range.location == NSNotFound)
    {
        return self;
    }
    /*
     else
     {
     NSString * z = [self substringToIndex:range.location];
     NSString * x = [self substringFromIndex:range.location+1];
     int dec = x.length > Decimal ? Decimal : x.length;
     
     NSMutableString *sFormate = [NSMutableString string];
     for (int  i = 0; i < z.length; i++) {
     [sFormate appendString:@"0"];
     }
     [sFormate appendString:@"."];
     for (int  i = 0; i < dec; i++) {
     [sFormate appendString:@"0"];
     }
     NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
     [numberFormatter setPositiveFormat:sFormate];
     NSString *s = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:self.doubleValue]];
     for (int i = s.length; i > z.length; i--) {
     NSRange lastRang = NSMakeRange(i - 1, 1);
     NSString *lastStr = [s substringWithRange:lastRang];
     if (![lastStr isEqualToString:@"0"]) {
     if ([lastStr isEqualToString:@"."]) {
     return [s substringWithRange:NSMakeRange(0, i - 1)];
     }
     return [s substringWithRange:NSMakeRange(0, i)];
     }
     }
     return s;
     }
     
     */
    static dispatch_once_t once;
    static NSNumberFormatter *numberFormatter;
    dispatch_once(&once, ^{numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.decimalSeparator      = @".";
        numberFormatter.minimumFractionDigits = 0;
        numberFormatter.usesGroupingSeparator = NO;
        numberFormatter.roundingMode          = kCFNumberFormatterRoundHalfEven;
        
    });
    numberFormatter.maximumFractionDigits = Decimal;
    return [numberFormatter stringFromNumber:@(self.doubleValue)];
}

- (NSString *)removeAddressBookCopySpecilCharacters {
    NSString *fliter = self;
    // 考虑到通讯录直接copy过来的号码
    if([fliter rangeOfString:@"+86"].location != NSNotFound || [fliter rangeOfString:@"-"].location != NSNotFound || [fliter rangeOfString:@" "].location != NSNotFound) {
        // copy本机号码前后有特殊字符
        if ((int)[fliter characterAtIndex:0] == 8237) {
            int front;
            for (front = 0; front < fliter.length; front++) {
                if ((int)[fliter characterAtIndex:front] != 8237) {
                    break;
                }
            }
            NSMutableArray *behindArray = [NSMutableArray array];
            int behind;
            for (behind = fliter.length - 1; behind >= 0; behind--) {
                if ((int)[fliter characterAtIndex:behind] == 8236) {
                    [behindArray addObject:@(behind)];  // 粘贴出来的号码后面可手动加入数字
                }
            }
            for (NSNumber *location in behindArray) {
                fliter = [fliter stringByReplacingCharactersInRange:NSMakeRange([location integerValue],1) withString:@""];
            }
            // 循环便利前后的转义符位置，提取出数字
            //            if (front < fliter.length && behind >= 0) {
            fliter = [fliter substringFromIndex:front];
            //            }
            
            //            (lldb) p (int)[fliter characterAtIndex:0]
            //            (int) $4 = 8237
            //            (lldb) p (int)[fliter characterAtIndex:1]
            //            (int) $5 = 8237
            //            (lldb) p (int)[fliter characterAtIndex:19]
            //            (int) $6 = 8236
            //            (lldb) p (int)[fliter characterAtIndex:20]
            //            (int) $7 = 8236
        }
        
        fliter = [fliter stringByReplacingOccurrencesOfString:@"-" withString:@""];
        fliter = [fliter stringByReplacingOccurrencesOfString:@"+86" withString:@""];
        fliter = [fliter stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return fliter;
}

//13位时间戳+4位随机
+ (NSString *)topicClientId{
    NSTimeInterval timeSecond = [[NSDate date] timeIntervalSince1970];
    int num = arc4random()%10000;
    NSString *numStr = [NSString stringWithFormat:@"%.4d",num];
    return [NSString stringWithFormat:@"%.0f%@",timeSecond*1000,numStr];
}

// 处理输入框钱
- (NSString *)dealWithMoneyTextField {
    NSString *textStr = self;
    long long money = 0;
    NSRange range = [textStr rangeOfString:@"."];
    if (range.location == NSNotFound) { // 整数
        money = textStr.longLongValue * 100;
    } else {
        textStr = [textStr stringByReplacingOccurrencesOfString:@"." withString:SStringEmpty];
        if ((textStr.length - range.location) > 1) { // 两位小数点
            money = textStr.longLongValue;
        } else { // 一位
            money = textStr.longLongValue * 10;
        }
    }
    return [NSString stringWithFormat:@"%lld",money];
}

@end
