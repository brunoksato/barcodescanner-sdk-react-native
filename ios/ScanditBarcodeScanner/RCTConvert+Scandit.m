//
//  RCTConvert+Scandit.m
//  RCTScanditBarcodeScanner
//
//  Created by Luca Torella on 17.08.17.
//  Copyright © 2017 Scandit. All rights reserved.
//

#import "RCTConvert+Scandit.h"

@import ScanditBarcodeScanner;

@implementation RCTConvert (Scandit)

RCT_ENUM_CONVERTER(SBSCameraSwitchVisibility,
                   (@{
                      @"CAMERA_SWITCH_NEVER": @(SBSCameraSwitchVisibilityNever),
                      @"CAMERA_SWITCH_ALWAYS": @(SBSCameraSwitchVisibilityAlways),
                      @"CAMERA_SWITCH_ON_TABLET": @(SBSCameraSwitchVisibilityOnTablet),
                      }),
                   SBSCameraSwitchVisibilityNever,
                   integerValue)

RCT_ENUM_CONVERTER(SBSMatrixScanHighlightingState,
                   (@{
                      @"MATRIX_SCAN_STATE_LOCALIZED": @(SBSMatrixScanHighlightingStateLocalized),
                      @"MATRIX_SCAN_STATE_RECOGNIZED": @(SBSMatrixScanHighlightingStateRecognized),
                      @"MATRIX_SCAN_STATE_REJECTED": @(SBSMatrixScanHighlightingStateRejected),
                      }),
                   SBSMatrixScanHighlightingStateLocalized,
                   integerValue)

RCT_ENUM_CONVERTER(SBSGuiStyle,
                   (@{
                      @"GUI_STYLE_DEFAULT": @(SBSGuiStyleDefault),
                      @"GUI_STYLE_LASER": @(SBSGuiStyleLaser),
                      @"GUI_STYLE_NONE": @(SBSGuiStyleNone),
                      @"GUI_STYLE_MATRIX_SCAN": @(SBSGuiStyleMatrixScan),
                      @"GUI_STYLE_LOCATIONS_ONLY": @(SBSGuiStyleLocationsOnly),
                      }),
                   SBSMatrixScanHighlightingStateLocalized,
                   integerValue)

@end
