//
//  ReadFooterView.h
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/6.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadFooterViewDelegate <NSObject>

- (void)sliderValueChanged:(CGFloat)brightness;
- (void)whiteButtonClicked;
- (void)blueButtonClicked;
- (void)yellowButtonClicked;
- (void)zoomOutFontButtonClicked;
- (void)zoomInFontButtonClicked;
- (void)nightButtonClicked;
- (void)horizontalButtonClicked;
- (void)downloadButtonClicked;
- (void)catalogButtonClicked;

@end

@interface ReadFooterView : UIView
{
    __weak IBOutlet UILabel *_downloadLabel;
    
}
@property (nonatomic, weak)id<ReadFooterViewDelegate> delegate;

- (void)setDownloadLabelText:(NSString*)download;

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)whiteButtonClicked:(id)sender;
- (IBAction)blueButtonClicked:(id)sender;
- (IBAction)yellowButtonClicked:(id)sender;
- (IBAction)zoomOutFontButtonClicked:(id)sender;
- (IBAction)zoomInFontButtonClicked:(id)sender;
- (IBAction)nightButtonClicked:(id)sender;
- (IBAction)horizontalButtonClicked:(id)sender;
- (IBAction)downloadButtonClicked:(id)sender;
- (IBAction)catalogButtonClicked:(id)sender;

@end
