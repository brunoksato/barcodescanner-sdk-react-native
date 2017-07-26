package com.scandit.reactnative

import android.view.View
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.JavaScriptModule
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import java.util.*
import kotlin.collections.ArrayList

class ScanditPackage : ReactPackage {

    override fun createJSModules(): MutableList<Class<out JavaScriptModule>> {
        return Collections.emptyList()
    }

    override fun createNativeModules(reactContext: ReactApplicationContext?): MutableList<NativeModule> {
        val modules = ArrayList<NativeModule>()
        modules.add(ScanditModule(reactContext))
        return modules
    }

    override fun createViewManagers(reactContext: ReactApplicationContext?): MutableList<SimpleViewManager<View>> {
        val managers = ArrayList<SimpleViewManager<View>>()
        managers.add(ReactBarcodePicker() as SimpleViewManager<View>)
        return managers
    }
}