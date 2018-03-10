//
//  PlaceholderTextView.h
//  PhannMusic
//
//  Created by SS-047 on 28/04/17.
//  Copyright © 2017 Rahul Verma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic, retain) UILabel *placeHolderLabel;

-(void)textChanged:(NSNotification*)notification;

@end
