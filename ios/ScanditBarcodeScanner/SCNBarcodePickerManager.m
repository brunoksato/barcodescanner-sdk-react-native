//
//  SCNBarcodePickerManager.m
//  ScanditBarcodeScanner
//
//  Created by Luca Torella on 08.08.17.
//  Copyright © 2017 Scandit. All rights reserved.
//

#import "SCNBarcodePickerManager.h"

@import ScanditBarcodeScanner;

@implementation SCNBarcodePickerManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    SBSBarcodePicker *barcodePicker = [[SBSBarcodePicker alloc] init];
    return barcodePicker.view;
}

@end
