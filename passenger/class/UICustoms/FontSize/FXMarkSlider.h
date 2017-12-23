

#import <UIKit/UIKit.h>
@class FXMarkSlider;

@protocol FXMarkSliderDelegate <NSObject>

//单击手势选择值
- (void)FXSliderTapGestureValue:(CGFloat)selectValue;
@end

@interface FXMarkSlider : UISlider

@property (nonatomic, strong) NSArray *markPositions;
@property (nonatomic, assign) CGFloat currentValue;
@property (nonatomic, assign) id <FXMarkSliderDelegate> delegate;
@end
