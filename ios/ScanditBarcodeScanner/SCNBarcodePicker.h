//
//  SCNBarcodePicker.h
//  SCNScanditBarcodeScanner
//
//  Created by Luca Torella on 13.08.17.
//  Copyright © 2017 Scandit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>

@class SBSBarcodePicker;

@interface SCNBarcodePicker : UIView

@property (nonatomic, strong, nonnull) SBSBarcodePicker *picker;

@property (nonatomic, strong, nullable) NSDictionary *scanSettings;
@property (nonatomic, copy, nullable) RCTBubblingEventBlock onScan;
@property (nonatomic, copy, nullable) RCTBubblingEventBlock onTextRecognized;
@property (nonatomic, copy, nullable) RCTBubblingEventBlock onSettingsApplied;

@end
