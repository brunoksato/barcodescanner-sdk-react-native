package com.scandit.reactnative

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.scandit.barcodepicker.BarcodePicker
import com.scandit.barcodepicker.OnScanListener
import com.scandit.barcodepicker.ScanSession
import com.scandit.barcodepicker.ScanSettings
import org.json.JSONObject
import java.nio.charset.Charset

class ReactBarcodePicker: SimpleViewManager<BarcodePicker>(), OnScanListener {

    var picker: BarcodePicker? = null

    override fun getName(): String {
        return "ReactBarcodePicker"
    }

    override fun getCommandsMap(): MutableMap<String, Int> {
        return MapBuilder.of(
                "startScanning", COMMAND_START_SCANNING,
                "stopScanning", COMMAND_STOP_SCANNING,
                "resumeScanning", COMMAND_RESUME_SCANNING,
                "pauseScanning", COMMAND_PAUSE_SCANNING)
    }

    override fun receiveCommand(root: BarcodePicker?, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            0 -> root?.startScanning()
            1 -> root?.stopScanning()
            2 -> root?.resumeScanning()
            3 -> root?.pauseScanning()
        }
    }

    override fun createViewInstance(reactContext: ThemedReactContext?): BarcodePicker {
        picker = BarcodePicker(reactContext, ScanSettings.create())
        picker?.setOnScanListener(this)
        return picker as BarcodePicker
    }

    override fun didScan(scanSession: ScanSession?) {
        val event = Arguments.createMap()
        val codes = Arguments.createArray()
        val context = picker?.context as ReactContext?
        scanSession?.newlyRecognizedCodes?.forEach { barcode ->
            codes.pushString(barcode.rawData.toString(Charset.forName("UTF-8")))
        }
        event.putArray("codes", codes)
        context?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(picker?.id ?: 0, "topChange", event)
    }

    @ReactProp(name = "scanSettings")
    fun setScanSettings(view: BarcodePicker, settingsJson: String ) {
        view.applyScanSettings(ScanSettings.createWithJson(JSONObject(settingsJson)))
    }
}