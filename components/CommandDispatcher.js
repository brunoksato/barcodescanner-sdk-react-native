import {
  UIManager
} from 'react-native';

export class CommandDispatcher {

  constructor(viewHandle) {
    this.pickerViewHandle = viewHandle;
  }

  startScan() {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle, UIManager.ReactBarcodePicker.Commands.startScan, null);
  }

  stopScan() {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle, UIManager.ReactBarcodePicker.Commands.stopScan, null);
  }

  resumeScan() {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle, UIManager.ReactBarcodePicker.Commands.resumeScan, null);
  }

  pauseScan() {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle, UIManager.ReactBarcodePicker.Commands.pauseScan, null);
  }

  applySettings(scanSettings) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.applySettings, [scanSettings]);
  }

  finishOnScanCallback(session) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.finishOnScanCallback,
      session);
  }

  setBeepEnabled(isEnabled) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setBeepEnabled, [isEnabled]);
  }

  setVibrateEnabled(isEnabled) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setVibrateEnabled, [isEnabled]);
  }

  setTorchEnabled(isEnabled) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setTorchEnabled, [isEnabled]);
  }

  setCameraSwitchVisibility(visibility) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setCameraSwitchVisibility, [visibility]);
  }

  setTextRecognitionSwitchVisible(isVisible) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setTextRecognitionSwitchVisible, [isVisible]);
  }

  setViewfinderDimension(x, y, width, height) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setViewfinderDimension, [x, y, width, height]);
  }

  setTorchMarginsAndSize(leftMargin, topMargin, width, height) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setTorchMarginsAndSize, [leftMargin, topMargin, width, height]);
  }

  setCameraSwitchMarginsAndSize(leftMargin, topMargin, width, height) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setCameraSwitchMarginsAndSize, [leftMargin, topMargin, width, height]);
  }

  setViewfinderColor(color) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setViewfinderColor, [color]);
  }

  setViewfinderDecodedColor(color) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setViewfinderDecodedColor, [color]);
  }

  setMatrixScanHighlightingColor(state, color) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setMatrixScanHighlightingColor, [state, color]);
  }

  setOverlayProperty(propName, propValue) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setOverlayProperty, [propName, propValue]);
  }

  setGuiStyle(style) {
    UIManager.dispatchViewManagerCommand(
      this.pickerViewHandle,
      UIManager.ReactBarcodePicker.Commands.setGuiStyle, [style]);
  }

}
