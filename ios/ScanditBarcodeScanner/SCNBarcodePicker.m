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

@property (nonatomic) BOOL shouldStop;
@property (nonatomic) BOOL shouldPause;
@property (nonatomic, nullable) NSArray<NSNumber *> *codesToReject;
@property (nonatomic) dispatch_semaphore_t didScanSemaphore;

@end

@implementation SCNBarcodePicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        _picker = [[SBSBarcodePicker alloc] initWithSettings:[SBSScanSettings defaultSettings]];
        _picker.scanDelegate = self;
        _didScanSemaphore = dispatch_semaphore_create(0);
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
        [allRecognizedCodes addObject:dictionaryFromCode(code, nil)];
    }
    NSMutableArray *newlyLocalizedCodes = [NSMutableArray arrayWithCapacity:session.newlyLocalizedCodes.count];
    for (SBSCode *code in session.newlyLocalizedCodes) {
        [newlyLocalizedCodes addObject:dictionaryFromCode(code, nil)];
    }
    NSMutableArray *newlyRecognizedCodes = [NSMutableArray arrayWithCapacity:session.newlyRecognizedCodes.count];
    int i = 0;
    for (SBSCode *code in session.newlyRecognizedCodes) {
        [newlyRecognizedCodes addObject:dictionaryFromCode(code, @(i))];
        i++;
    }
    return @{
             @"allRecognizedCodes": allRecognizedCodes,
             @"newlyLocalizedCodes": newlyLocalizedCodes,
             @"newlyRecognizedCodes": newlyRecognizedCodes,
             };
}

static NSDictionary<NSString *, id> *dictionaryFromCode(SBSCode *code, NSNumber *identifier) {
    NSMutableArray<NSNumber *> *bytesArray = [NSMutableArray arrayWithCapacity:code.rawData.length];
    if (code.rawData != nil) {
        unsigned char *bytes = (unsigned char *)[code.rawData bytes];
        for (int i = 0; i < code.rawData.length; i++) {
            [bytesArray addObject:@(bytes[i])];
        }
    }

    return @{
             @"id": identifier ?: @(-1),
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
    dispatch_semaphore_wait(self.didScanSemaphore, DISPATCH_TIME_FOREVER);
    if (self.shouldStop) {
        [session stopScanning];
    } else if (self.shouldPause) {
        [session pauseScanning];
    } else {
        for (NSNumber *index in self.codesToReject) {
            if (index.integerValue == -1) {
                continue;
            }
            SBSCode *code = session.newlyRecognizedCodes[index.integerValue];
            [session rejectCode:code];
        }
    }
}

- (void)finishOnScanCallbackShouldStop:(BOOL)shouldStop
                           shouldPause:(BOOL)shouldPause
                         codesToReject:(NSArray<NSNumber *> *)codesToReject {
    self.shouldStop = shouldStop;
    self.shouldPause = shouldPause;
    self.codesToReject = codesToReject;
    dispatch_semaphore_signal(self.didScanSemaphore);
}

@end
