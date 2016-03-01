//
//  ReadFooterView.m
//  EndlessReading
//
//  Created by Xiaodiao.Deng on 16/1/6.
//  Copyright © 2016年 Satinno. All rights reserved.
//

#import "ReadFooterView.h"

@implementation ReadFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setDownloadLabelText:(NSString*)download{
    _downloadLabel.text = download;
}

- (IBAction)sliderValueChanged:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [_delegate sliderValueChanged:((UISlider*)sender).value];
    }
}

- (IBAction)whiteButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(whiteButtonClicked)]) {
        [_delegate whiteButtonClicked];
    }
}

- (IBAction)blueButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(blueButtonClicked)]) {
        [_delegate blueButtonClicked];
    }
}

- (IBAction)yellowButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(yellowButtonClicked)]) {
        [_delegate yellowButtonClicked];
    }
}

- (IBAction)zoomOutFontButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(zoomOutFontButtonClicked)]) {
        [_delegate zoomOutFontButtonClicked];
    }
}

- (IBAction)zoomInFontButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(zoomInFontButtonClicked)]) {
        [_delegate zoomInFontButtonClicked];
    }
}

- (IBAction)nightButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(nightButtonClicked)]) {
        [_delegate nightButtonClicked];
    }
}

- (IBAction)horizontalButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(horizontalButtonClicked)]) {
        [_delegate horizontalButtonClicked];
    }
}

- (IBAction)downloadButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(downloadButtonClicked)]) {
        [_delegate downloadButtonClicked];
    }
}

- (IBAction)catalogButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(catalogButtonClicked)]) {
        [_delegate catalogButtonClicked];
    }
}
@end
