package com.scandit.reactnative

import android.graphics.Color
import com.facebook.react.bridge.*
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.scandit.barcodepicker.*
import com.scandit.barcodepicker.BarcodePicker
import com.scandit.barcodepicker.ocr.RecognizedText
import com.scandit.barcodepicker.ocr.TextRecognitionListener
import java.util.concurrent.CountDownLatch

class BarcodePicker : SimpleViewManager<BarcodePicker>(), OnScanListener, TextRecognitionListener {

    private var picker: BarcodePicker? = null
    private var latch: CountDownLatch = CountDownLatch(1)
    private val codesToReject = ArrayList<Int>()

    override fun getName(): String = "BarcodePicker"

    override fun getCommandsMap(): MutableMap<String, Int> {
        val map = MapBuilder.newHashMap<String, Int>()
        map.put("startScanning", COMMAND_START_SCANNING)
        map.put("stopScanning", COMMAND_STOP_SCANNING)
        map.put("resumeScanning", COMMAND_RESUME_SCANNING)
        map.put("pauseScanning", COMMAND_PAUSE_SCANNING)
        map.put("applySettings", COMMAND_APPLY_SETTINGS)
        map.put("setViewfinderDimension", COMMAND_VIEWFINDER_DIMENSION)
        map.put("setTorchEnabled", COMMAND_TORCH_ENABLED)
        map.put("setVibrateEnabled", COMMAND_VIBRATE_ENABLED)
        map.put("setBeepEnabled", COMMAND_BEEP_ENABLED)
        map.put("setTorchMarginsAndSize", COMMAND_TORCH_MARGINS_AND_SIZE)
        map.put("setCameraSwitchVisibility", COMMAND_CAMERA_SWITCH_VISIBILITY)
        map.put("setCameraSwitchMarginsAndSize", COMMAND_CAMERA_SWITCH_MARGINS_AND_SIZE)
        map.put("setViewfinderColor", COMMAND_VIEWFINDER_COLOR)
        map.put("setViewfinderDecodedColor", COMMAND_VIEWFINDER_DECODED_COLOR)
        map.put("setMatrixScanHighlightingColor", COMMAND_MATRIX_HIGHLIGHT_COLOR)
        map.put("setOverlayProperty", COMMAND_SET_OVERLAY_PROPERTY)
        map.put("setGuiStyle", COMMAND_SET_GUI_STYLE)
        map.put("setTextRecognitionSwitchVisible", COMMAND_SET_TEXT_RECOGNITION_SWITCH_ENABLED)
        map.put("finishOnScanCallback", COMMAND_FINISH_ON_SCAN_CALLBACK)
        return map
    }

    override fun receiveCommand(root: BarcodePicker?, commandId: Int, args: ReadableArray?) {
        when (commandId) {
            COMMAND_START_SCANNING -> root?.startScanning()
            COMMAND_STOP_SCANNING -> root?.stopScanning()
            COMMAND_RESUME_SCANNING -> root?.resumeScanning()
            COMMAND_PAUSE_SCANNING -> root?.pauseScanning()
            COMMAND_APPLY_SETTINGS -> setScanSettings(args)
            COMMAND_VIEWFINDER_DIMENSION -> setViewfinderDimension(args)
            COMMAND_TORCH_ENABLED -> setTorchEnabled(args)
            COMMAND_VIBRATE_ENABLED -> setVibrateEnabled(args)
            COMMAND_BEEP_ENABLED -> setBeepEnabled(args)
            COMMAND_TORCH_MARGINS_AND_SIZE -> setTorchMarginsSize(args)
            COMMAND_CAMERA_SWITCH_VISIBILITY -> setCameraSwitchVisibility(args)
            COMMAND_CAMERA_SWITCH_MARGINS_AND_SIZE -> setCameraSwitchMarginsSize(args)
            COMMAND_VIEWFINDER_COLOR -> setViewfinderColor(args)
            COMMAND_VIEWFINDER_DECODED_COLOR -> setViewfinderDecodedColor(args)
            COMMAND_MATRIX_HIGHLIGHT_COLOR -> setMatrixScanHighlightingColor(args)
            COMMAND_SET_OVERLAY_PROPERTY -> setOverlayProperty(args)
            COMMAND_SET_GUI_STYLE -> setGuiStyle(args)
            COMMAND_SET_TEXT_RECOGNITION_SWITCH_ENABLED -> setTextRecognitionSwitchVisible(args)
            COMMAND_FINISH_ON_SCAN_CALLBACK -> finishOnScanCallback(args)
        }
    }

    override fun createViewInstance(reactContext: ThemedReactContext?): BarcodePicker {
        picker = BarcodePicker(reactContext, ScanSettings.create())
        picker?.setOnScanListener(this)
        picker?.setTextRecognitionListener(this)
        return picker as BarcodePicker
    }

    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> {
        return MapBuilder.of(
                "onScan", MapBuilder.of("registrationName", "onScan"),
                "onSettingsApplied", MapBuilder.of("registrationName", "onSettingsApplied"),
                "onTextRecognized", MapBuilder.of("registrationName", "onTextRecognized")
        )
    }

    override fun getExportedViewConstants(): MutableMap<String, Int> {
        val map = MapBuilder.newHashMap<String, Int>()
        map.put(KEY_CAMERA_SWITCH_ALWAYS, ScanOverlay.CAMERA_SWITCH_ALWAYS)
        map.put(KEY_CAMERA_SWITCH_NEVER, ScanOverlay.CAMERA_SWITCH_NEVER)
        map.put(KEY_CAMERA_SWITCH_ON_TABLET, ScanOverlay.CAMERA_SWITCH_ON_TABLET)
        map.put(KEY_MATRIX_SCAN_STATE_LOCALIZED, ScanOverlay.MATRIX_SCAN_HIGHLIGHTING_STATE_LOCALIZED)
        map.put(KEY_MATRIX_SCAN_STATE_RECOGNIZED, ScanOverlay.MATRIX_SCAN_HIGHLIGHTING_STATE_RECOGNIZED)
        map.put(KEY_MATRIX_SCAN_STATE_REJECTED, ScanOverlay.MATRIX_SCAN_HIGHLIGHTING_STATE_REJECTED)
        map.put(KEY_GUI_STYLE_DEFAULT, ScanOverlay.GUI_STYLE_DEFAULT)
        map.put(KEY_GUI_STYLE_LASER, ScanOverlay.GUI_STYLE_LASER)
        map.put(KEY_GUI_STYLE_NONE, ScanOverlay.GUI_STYLE_NONE)
        map.put(KEY_GUI_STYLE_MATRIX_SCAN, ScanOverlay.GUI_STYLE_MATRIX_SCAN)
        map.put(KEY_GUI_STYLE_LOCATIONS_ONLY, ScanOverlay.GUI_STYLE_LOCATIONS_ONLY)
        return map
    }

    override fun didScan(scanSession: ScanSession?) {
        val context = picker?.context as ReactContext?
        context?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(picker?.id ?: 0,
                "onScan", sessionToMap(scanSession))
        latch.await()
        for (index in codesToReject) {
            scanSession?.rejectCode(scanSession.newlyRecognizedCodes[index])
        }
        codesToReject.clear()
    }

    override fun didRecognizeText(text: RecognizedText?): Int {
        val event = Arguments.createMap()
        val context = picker?.context as ReactContext?
        event.putString("text", text?.text)
        context?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(picker?.id ?: 0, "onTextRecognized", event)
        return TextRecognitionListener.PICKER_STATE_ACTIVE
    }

    @ReactProp(name = "scanSettings")
    fun setPropScanSettings(view: BarcodePicker, settingsJson: ReadableMap) {
        view.applyScanSettings(settingsFromMap(settingsJson))
    }

    private fun finishOnScanCallback(args: ReadableArray?) {
        if (args?.getBoolean(0) == true)
            picker?.stopScanning()
        if (args?.getBoolean(1) == true)
            picker?.pauseScanning()
        var index = 0
        val array = args?.getArray(2)
        while (index < array?.size() ?: 0) {
            codesToReject.add(array?.getInt(index++) ?: continue)
        }
        latch.countDown()
        latch = CountDownLatch(1)
    }

    private fun setScanSettings(args: ReadableArray?) {
        picker?.applyScanSettings(settingsFromMap(args?.getMap(0) ?: return), {
            val context = picker?.context as ReactContext?
            context?.getJSModule(RCTEventEmitter::class.java)?.receiveEvent(picker?.id ?: 0, "onSettingsApplied", Arguments.createMap())
        })
    }

    private fun setGuiStyle(args: ReadableArray?) {
        picker?.overlayView?.setGuiStyle(args?.getInt(0) ?: ScanOverlay.GUI_STYLE_DEFAULT)
    }

    private fun setViewfinderDimension(args: ReadableArray?) {
        picker?.overlayView?.setViewfinderDimension(
                args?.getDouble(0)?.toFloat() ?: 1f, args?.getDouble(1)?.toFloat() ?: 1f,
                args?.getDouble(2)?.toFloat() ?: 1f, args?.getDouble(3)?.toFloat() ?: 1f
        )
    }

    private fun setTorchEnabled(args: ReadableArray?) {
        picker?.overlayView?.setTorchEnabled(args?.getBoolean(0) ?: false)
    }

    private fun setTorchMarginsSize(args: ReadableArray?) {
        picker?.overlayView?.setTorchButtonMarginsAndSize(
                args?.getInt(0) ?: 0, args?.getInt(1) ?: 0, args?.getInt(2) ?: 0, args?.getInt(3) ?: 0
        )
    }

    private fun setVibrateEnabled(args: ReadableArray?) {
        picker?.overlayView?.setVibrateEnabled(args?.getBoolean(0) ?: false)
    }

    private fun setBeepEnabled(args: ReadableArray?) {
        picker?.overlayView?.setBeepEnabled(args?.getBoolean(0) ?: false)
    }

    private fun setCameraSwitchVisibility(args: ReadableArray?) {
        picker?.overlayView?.setCameraSwitchVisibility(args?.getInt(0) ?: ScanOverlay.CAMERA_SWITCH_NEVER)
    }

    private fun setCameraSwitchMarginsSize(args: ReadableArray?) {
        picker?.overlayView?.setCameraSwitchButtonMarginsAndSize(
                args?.getInt(0) ?: 0, args?.getInt(1) ?: 0, args?.getInt(2) ?: 0, args?.getInt(3) ?: 0
        )
    }

    private fun setViewfinderColor(args: ReadableArray?) {
        val colorInt = args?.getInt(0) ?: Color.WHITE
        picker?.overlayView?.setViewfinderColor(Color.red(colorInt) / 255f, Color.green(colorInt) / 255f, Color.blue(colorInt) / 255f)
    }

    private fun setViewfinderDecodedColor(args: ReadableArray?) {
        val colorInt = args?.getInt(0) ?: Color.GREEN
        picker?.overlayView?.setViewfinderDecodedColor(Color.red(colorInt) / 255f, Color.green(colorInt) / 255f, Color.blue(colorInt) / 255f)
    }

    private fun setMatrixScanHighlightingColor(args: ReadableArray?) {
        picker?.overlayView?.setMatrixScanHighlightingColor(
                args?.getInt(0) ?: 0, args?.getInt(1) ?: 0
        )
    }

    private fun setTextRecognitionSwitchVisible(args: ReadableArray?) {
        picker?.overlayView?.setTextRecognitionSwitchVisible(args?.getBoolean(0) ?: false)
    }

    private fun setOverlayProperty(args: ReadableArray?) {
        val propValue: Any? = when (args?.getType(1)) {
            ReadableType.Boolean -> args.getBoolean(1)
            ReadableType.String -> args.getString(1)
            ReadableType.Number -> args.getDouble(1)
            else -> null
        }
        picker?.overlayView?.setProperty(args?.getString(0), propValue)
    }
}