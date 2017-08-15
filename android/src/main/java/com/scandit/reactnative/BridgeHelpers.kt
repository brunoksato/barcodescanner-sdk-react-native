package com.scandit.reactnative

import com.facebook.react.bridge.*
import com.scandit.barcodepicker.ScanSession
import com.scandit.barcodepicker.ScanSettings
import com.scandit.recognition.Barcode
import com.scandit.recognition.Quadrilateral
import org.json.JSONArray
import org.json.JSONObject

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

fun ReadableArray.toJson(): JSONArray {
    val jsonArray = JSONArray()

    for (i in 0 until this.size()) {

        when (this.getType(i)) {
            ReadableType.Null -> jsonArray.put(JSONObject.NULL)
            ReadableType.Boolean -> jsonArray.put(this.getBoolean(i))
            ReadableType.Number -> jsonArray.put(this.getDouble(i))
            ReadableType.String -> jsonArray.put(this.getString(i))
            ReadableType.Map -> jsonArray.put(this.getMap(i).toJson())
            ReadableType.Array -> jsonArray.put(this.getArray(i).toJson())
            else -> {}
        }
    }

    return jsonArray
}

fun ReadableMap.toJson(): JSONObject {
    val jsonObject = JSONObject()
    val iterator = this.keySetIterator()

    while (iterator.hasNextKey()) {
        val key = iterator.nextKey()

        when (this.getType(key)) {
            ReadableType.Null -> jsonObject.put(key, JSONObject.NULL)
            ReadableType.Boolean -> jsonObject.put(key, this.getBoolean(key))
            ReadableType.Number -> jsonObject.put(key, this.getDouble(key))
            ReadableType.String -> jsonObject.put(key, this.getString(key))
            ReadableType.Map -> jsonObject.put(key, this.getMap(key).toJson())
            ReadableType.Array -> jsonObject.put(key, this.getArray(key).toJson())
            else -> {}
        }
    }

    return jsonObject
}

fun settingsFromMap(map: ReadableMap): ScanSettings = ScanSettings.createWithJson(map.toJson())
