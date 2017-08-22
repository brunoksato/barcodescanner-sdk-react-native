//
//  SCNBarcodePickerManager.m
//  ScanditBarcodeScanner
//
//  Created by Luca Torella on 08.08.17.
//  Copyright © 2017 Scandit. All rights reserved.
//

#import "SCNBarcodePickerManager.h"
#import "SCNBarcodePicker.h"
#import <React/RCTUIManager.h>

@import ScanditBarcodeScanner;

@interface SCNBarcodePickerManager ()

@end

@implementation SCNBarcodePickerManager

RCT_EXPORT_MODULE(ReactBarcodePicker)

-(dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (UIView *)view {
    return [[SCNBarcodePicker alloc] init];
}

RCT_EXPORT_VIEW_PROPERTY(scanSettings, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onScan, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onTextRecognized, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSettingsApplied, RCTBubblingEventBlock)

RCT_EXPORT_METHOD(startScan:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker startScanning];
         }
     }];
}

RCT_EXPORT_METHOD(stopScan:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker stopScanning];
         }
     }];
}

RCT_EXPORT_METHOD(pauseScan:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker pauseScanning];
         }
     }];
}

RCT_EXPORT_METHOD(resumeScan:(nonnull NSNumber *)reactTag) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker resumeScanning];
         }
     }];
}

RCT_EXPORT_METHOD(applySettings:(nonnull NSNumber *)reactTag
                  settings:(NSDictionary *)settings) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             NSError *error = nil;
             SBSScanSettings *scanSettings = [SBSScanSettings settingsWithDictionary:settings
                                                                               error:&error];
             if (error != nil) {
                 RCTLogError(@"Invalid scan settings: %@", error.localizedDescription);
             } else {
                 SCNBarcodePicker *pickerView = (SCNBarcodePicker *)view;
                 [pickerView.picker applyScanSettings:scanSettings
                                    completionHandler:
                  ^{
                      if (pickerView.onSettingsApplied != nil) {
                          pickerView.onSettingsApplied(@{});
                      }
                  }];
             }
         }
     }];
}

RCT_EXPORT_METHOD(setViewfinderDimension:(nonnull NSNumber *)reactTag
                  width:(float)width
                  height:(float)height
                  landscapeWidth:(float)landscapeWidth
                  landscapeHeight:(float)landscapeHeight) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setViewfinderWidth:width
                                            height:height
                                    landscapeWidth:landscapeWidth
                                   landscapeHeight:landscapeHeight];
         }
     }];
}

RCT_EXPORT_METHOD(setTorchEnabled:(nonnull NSNumber *)reactTag
                  enabled:(BOOL)enabled) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker.overlayController setTorchEnabled:enabled];
         }
     }];
}

RCT_EXPORT_METHOD(setVibrateEnabled:(nonnull NSNumber *)reactTag
                  enabled:(BOOL)enabled) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker.overlayController setVibrateEnabled:enabled];
         }
     }];
}

RCT_EXPORT_METHOD(setBeepEnabled:(nonnull NSNumber *)reactTag
                  enabled:(BOOL)enabled) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker.overlayController setBeepEnabled:enabled];
         }
     }];
}

RCT_EXPORT_METHOD(setTorchMarginsAndSize:(nonnull NSNumber *)reactTag
                  leftMargin:(float)leftMargin
                  topMargin:(float)topMargin
                  width:(float)width
                  height:(float)height) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setTorchButtonLeftMargin:leftMargin
                                               topMargin:topMargin
                                                   width:width
                                                  height:height];
         }
     }];
}

RCT_EXPORT_METHOD(setCameraSwitchVisibility:(nonnull NSNumber *)reactTag
                  visibility:(SBSCameraSwitchVisibility)visibility) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setCameraSwitchVisibility:visibility];
         }
     }];
}

RCT_EXPORT_METHOD(setCameraSwitchMarginsAndSize:(nonnull NSNumber *)reactTag
                  rightMargin:(float)rightMargin
                  topMargin:(float)topMargin
                  width:(float)width
                  height:(float)height) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setCameraSwitchButtonRightMargin:rightMargin
                                                       topMargin:topMargin
                                                           width:width
                                                          height:height];
         }
     }];
}

RCT_EXPORT_METHOD(setViewfinderColor:(nonnull NSNumber *)reactTag
                  color:(UIColor *)color) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             CGFloat red = 0, green = 0, blue = 0, alpha = 0;
             [color getRed:&red green:&green blue:&blue alpha:&alpha];
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setViewfinderColor:red green:green blue:blue];
         }
     }];
}

RCT_EXPORT_METHOD(setViewfinderDecodedColor:(nonnull NSNumber *)reactTag
                  color:(UIColor *)color) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             CGFloat red = 0, green = 0, blue = 0, alpha = 0;
             [color getRed:&red green:&green blue:&blue alpha:&alpha];
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setViewfinderDecodedColor:red green:green blue:blue];
         }
     }];
}

RCT_EXPORT_METHOD(setMatrixScanColor:(nonnull NSNumber *)reactTag
                  color:(UIColor *)color
                  state:(SBSMatrixScanHighlightingState)state) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setMatrixScanHighlightingColor:color forState:state];
         }
     }];
}

RCT_EXPORT_METHOD(setGuiStyle:(nonnull NSNumber *)reactTag
                  guiStyle:(SBSGuiStyle)guiStyle) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             SBSOverlayController *overlayController = ((SCNBarcodePicker *)view).picker.overlayController;
             [overlayController setGuiStyle:guiStyle];
         }
     }];
}

RCT_EXPORT_METHOD(setTextRecognitionSwitchVisible:(nonnull NSNumber *)reactTag
                  visible:(BOOL)visible) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             [((SCNBarcodePicker *)view).picker.overlayController setTextRecognitionSwitchVisible:visible];
         }
     }];
}

RCT_EXPORT_METHOD(setOverlayProperty:(nonnull NSNumber *)reactTag
                  key:(NSString *)key
                  value:(id)value) {
    [self.bridge.uiManager addUIBlock:
     ^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
         id view = viewRegistry[reactTag];
         if (![view isKindOfClass:[SCNBarcodePicker class]]) {
             RCTLogError(@"Invalid view returned from registry, expecting SCNBarcodePicker, got: %@", view);
         } else {
             // TODO: NOT IMPLEMENTED YET
         }
     }];
}

@end
