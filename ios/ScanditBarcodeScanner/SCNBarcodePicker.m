//
//  SCNBarcodePicker.m
//  SCNScanditBarcodeScanner
//
//  Created by Luca Torella on 13.08.17.
//  Copyright © 2017 Scandit. All rights reserved.
//

#import "SCNBarcodePicker.h"

@import ScanditBarcodeScanner;

@interface SCNBarcodePicker () <SBSScanDelegate>

@end

@implementation SCNBarcodePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _picker = [[SBSBarcodePicker alloc] initWithSettings:[SBSScanSettings defaultSettings]];
        _picker.scanDelegate = self;
        [self addSubview:_picker.view];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.picker.view.frame = self.bounds;
}

- (void)setScanSettings:(NSDictionary *)dictionary {
    _scanSettings = dictionary;
    SBSScanSettings *scanSettings = [SBSScanSettings settingsWithDictionary:dictionary error:nil];
    [self.picker applyScanSettings:scanSettings completionHandler:nil];
}

#pragma mark - SBSScanDelegate

static inline NSDictionary<NSString *, id> *dictionaryFromScanSession(SBSScanSession *session) {
    NSMutableArray *allRecognizedCodes = [NSMutableArray arrayWithCapacity:session.allRecognizedCodes.count];
    for (SBSCode *code in session.allRecognizedCodes) {
        [allRecognizedCodes addObject:dictionaryFromCode(code)];
    }
    NSMutableArray *newlyLocalizedCodes = [NSMutableArray arrayWithCapacity:session.newlyLocalizedCodes.count];
    for (SBSCode *code in session.newlyLocalizedCodes) {
        [newlyLocalizedCodes addObject:dictionaryFromCode(code)];
    }
    NSMutableArray *newlyRecognizedCodes = [NSMutableArray arrayWithCapacity:session.newlyRecognizedCodes.count];
    for (SBSCode *code in session.newlyRecognizedCodes) {
        [newlyRecognizedCodes addObject:dictionaryFromCode(code)];
    }
    return @{
             @"allRecognizedCodes": allRecognizedCodes,
             @"newlyLocalizedCodes": newlyLocalizedCodes,
             @"newlyRecognizedCodes": newlyRecognizedCodes,
             };
}

static NSDictionary<NSString *, id> *dictionaryFromCode(SBSCode *code) {
    NSMutableArray<NSNumber *> *bytesArray = [NSMutableArray arrayWithCapacity:code.rawData.length];
    if (code.rawData != nil) {
        unsigned char *bytes = (unsigned char *)[code.rawData bytes];
        for (int i = 0; i < code.rawData.length; i++) {
            [bytesArray addObject:@(bytes[i])];
        }
    }

    return @{
             @"rawData": bytesArray,
             @"data": code.data ?: @"",
             @"symbology": code.symbologyName,
             @"compositeFlag": @(code.compositeFlag),
             @"isGs1DataCarrier": [NSNumber numberWithBool:code.isGs1DataCarrier],
             @"isRecognized": [NSNumber numberWithBool:code.isRecognized],
             @"location": dictionaryFromQuadrilateral(code.location),
             };
}

static inline NSDictionary<NSString *, id> *dictionaryFromQuadrilateral(SBSQuadrilateral quadrilateral) {
    return @{
             @"topLeft": @[@(quadrilateral.topLeft.x), @(quadrilateral.topLeft.y)],
             @"topRight": @[@(quadrilateral.topRight.x), @(quadrilateral.topRight.y)],
             @"bottomLeft": @[@(quadrilateral.bottomLeft.x), @(quadrilateral.bottomLeft.y)],
             @"bottomRight": @[@(quadrilateral.bottomRight.x), @(quadrilateral.bottomRight.y)],
             };
}

- (void)barcodePicker:(SBSBarcodePicker *)picker didScan:(SBSScanSession *)session {
    if (self.onScan) {
        self.onScan(dictionaryFromScanSession(session));
    }
}

@end
