package com.scandit.reactnative

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.scandit.barcodepicker.ScanSession
import com.scandit.recognition.Barcode
import com.scandit.recognition.Quadrilateral

fun sessionToMap(scanSession: ScanSession?): WritableMap  {
    val event = Arguments.createMap()

    val allRecognizedCodes = Arguments.createArray()
    scanSession?.allRecognizedCodes?.forEach { barcode ->
        allRecognizedCodes.pushMap(barcodeToMap(barcode))
    }
    event.putArray("allRecognizedCodes", allRecognizedCodes)

    val newlyLocalizedCodes = Arguments.createArray()
    scanSession?.newlyLocalizedCodes?.forEach { barcode ->
        newlyLocalizedCodes.pushMap(barcodeToMap(barcode))
    }
    event.putArray("newlyLocalizedCodes", newlyLocalizedCodes)

    val newlyRecognizedCodes = Arguments.createArray()
    if (scanSession?.newlyRecognizedCodes != null) {
        for (i in scanSession.newlyRecognizedCodes.indices) {
            newlyRecognizedCodes.pushMap(barcodeToMap(scanSession.newlyRecognizedCodes[i], i))
        }
    }
    event.putArray("newlyRecognizedCodes", newlyRecognizedCodes)

    return event
}

fun barcodeToMap(barcode: Barcode?, index: Int = -1): WritableMap {
    val map = Arguments.createMap()
    val rawData = Arguments.createArray()

    if (index != -1) {
        map.putInt("id", index)
    }
    barcode?.rawData?.forEach { byte ->
        rawData.pushInt(byte.toInt())
    }
    map.putArray("rawData", rawData)
    map.putString("data", barcode?.data)
    map.putString("symbology", Barcode.symbologyToString(barcode?.symbology ?: Barcode.SYMBOLOGY_UNKNOWN))
    map.putInt("compositeFlag", barcode?.compositeFlag ?: Barcode.SC_COMPOSITE_FLAG_UNKNOWN)
    map.putBoolean("isGs1DataCarrier", barcode?.isGs1DataCarrier ?: false)
    map.putBoolean("isRecognized", barcode?.isRecognized ?: false)
    map.putMap("location", quadrilateralToMap(barcode?.location))

    return map
}

fun quadrilateralToMap(quadrilateral: Quadrilateral?): WritableMap {
    val map = Arguments.createMap()

    var array = Arguments.createArray()
    array.pushInt(quadrilateral?.top_left?.x ?: 0)
    array.pushInt(quadrilateral?.top_left?.y ?: 0)
    map.putArray("topLeft", array)

    array = Arguments.createArray()
    array.pushInt(quadrilateral?.top_right?.x ?: 0)
    array.pushInt(quadrilateral?.top_right?.y ?: 0)
    map.putArray("topRight", array)

    array = Arguments.createArray()
    array.pushInt(quadrilateral?.bottom_left?.x ?: 0)
    array.pushInt(quadrilateral?.bottom_left?.y ?: 0)
    map.putArray("bottomLeft", array)

    array = Arguments.createArray()
    array.pushInt(quadrilateral?.bottom_right?.x ?: 0)
    array.pushInt(quadrilateral?.bottom_right?.y ?: 0)
    map.putArray("bottomRight", array)

    return map
}
