//
//  UIFont+Addition.m

//

#import "UIFont+Addition.h"
@implementation UIFont (Addition)
/**  字体样式*/
+(UIFont*)myfontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    CGFloat size = fontSize;
    if (isIPhone6) {
        size = fontSize;
    }else if(isIPhone6p){
        size = fontSize + 1;
    }
    return [UIFont fontWithName:fontName size:size];
}
/**  字体大小*/
+(UIFont *)mysystemFontOfSize:(CGFloat)fontSize{
    CGFloat size = fontSize;
    if (isIPhone6) {
        size = fontSize;
    }else if(isIPhone6p){
        size = fontSize + 1;
    }
    
    return [UIFont systemFontOfSize:size];
}
/**  粗体，黑体*/
+(UIFont *)myboldSystemFontOfSize:(CGFloat)fontSize{
    CGFloat size = fontSize;
    if (isIPhone6) {
        size = fontSize;
    }else if(isIPhone6p){
        size = fontSize + 1;
    }
    return [UIFont boldSystemFontOfSize:size];
}
@end
