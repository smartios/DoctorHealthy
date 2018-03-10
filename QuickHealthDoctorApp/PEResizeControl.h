

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PEResizeControlViewDelegate;

@interface PEResizeControl : UIView

@property (nonatomic, weak) id<PEResizeControlViewDelegate> delegate;
@property (nonatomic, readonly) CGPoint translation;

@end

@protocol PEResizeControlViewDelegate <NSObject>

- (void)resizeControlViewDidBeginResizing:(PEResizeControl *)resizeControlView;
- (void)resizeControlViewDidResize:(PEResizeControl *)resizeControlView;
- (void)resizeControlViewDidEndResizing:(PEResizeControl *)resizeControlView;

@end
