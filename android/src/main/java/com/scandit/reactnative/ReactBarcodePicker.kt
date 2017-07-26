package com.scandit.reactnative

import com.facebook.react.bridge.ReadableArray
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.scandit.barcodepicker.BarcodePicker
import com.scandit.barcodepicker.OnScanListener
import com.scandit.barcodepicker.ScanSession
import com.scandit.barcodepicker.ScanSettings

class ReactBarcodePicker: SimpleViewManager<BarcodePicker>(), OnScanListener {

    companion object {
        const val COMMAND_START_SCANNING = 0
    }

    override fun getName(): String {
        return "ReactBarcodePicker"
    }

    override fun getCommandsMap(): MutableMap<String, Int> {
        return MapBuilder.of("startScanning", COMMAND_START_SCANNING)
    }

    override fun receiveCommand(root: BarcodePicker?, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            0 -> root?.startScanning()
        }
    }

    override fun createViewInstance(reactContext: ThemedReactContext?): BarcodePicker {
        val picker = BarcodePicker(reactContext, ScanSettings.create())
        picker.setOnScanListener(this)
        return picker
    }

    override fun didScan(scanSession: ScanSession?) {

    }
}