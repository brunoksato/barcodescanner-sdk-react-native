import PropTypes from 'prop-types';
import React from 'react';
import {
	requireNativeComponent,
	findNodeHandle,
	View,
	UIManager,
	processColor
} from 'react-native';
import { CommandDispatcher } from './CommandDispatcher';
import { ScanSession } from './ScanSession';
import { SerializationHelper } from './SerializationHelper';
import { Barcode } from './Barcode';

var iface = {
  name: 'BarcodePicker',
  propTypes: {
	  scanSettings: PropTypes.object,
	  onScan: PropTypes.func,
	  onSettingsApplied: PropTypes.func,
	  onTextRecognized: PropTypes.func,
	  ...View.propTypes
  }
};

var ReactBarcodePicker = requireNativeComponent('BarcodePicker', iface);

export class BarcodePicker extends React.Component {

	constructor(props) {
		super(props);
		this.onScan = this.onScan.bind(this);
		this.onSettingsApplied = this.onSettingsApplied.bind(this);
		this.onTextRecognized = this.onTextRecognized.bind(this);
	}

	componentDidMount() {
    this.dispatcher = new CommandDispatcher(findNodeHandle(this.reference));
  }

	onScan(event: Event) {
		if (!this.props.onScan) {
			return;
		}
		var session = SerializationHelper.deserializeScanSession(event.nativeEvent);
		this.props.onScan(session);
		this.dispatcher.finishOnScanCallback(SerializationHelper.serializeScanSession(session));
	}

	onSettingsApplied(event: Event) {
		if (!this.props.onSettingsApplied) {
			return;
		}
		this.props.onSettingsApplied(event.nativeEvent);
	}

	onTextRecognized(event: Event) {
		if (!this.props.onTextRecognized) {
			return;
		}
		this.props.onTextRecognized(event.nativeEvent.text);
	}

	render() {
		return <ReactBarcodePicker
		    {...this.props}
				onScan = {this.onScan}
		    onSettingsApplied = {this.onSettingsApplied}
		    onTextRecognized = {this.onTextRecognized}
				ref = {(scan) => {this.reference = scan}} />;
	}

	startScanning() {
		this.dispatcher.startScanning();
	}

	stopScanning() {
		this.dispatcher.stopScanning();
	}

	resumeScanning() {
		this.dispatcher.resumeScanning();
	}

	pauseScanning() {
		this.dispatcher.pauseScanning();
	}

	setBeepEnabled(isEnabled) {
		this.dispatcher.setBeepEnabled(isEnabled);
	}

	applySettings(settingsJSON) {
		this.dispatcher.applySettings(settingsJSON);
	}

	setVibrateEnabled(isEnabled) {
		this.dispatcher.setVibrateEnabled(isEnabled);
	}

	setTorchEnabled(isEnabled) {
		this.dispatcher.setTorchEnabled(isEnabled);
	}

	setCameraSwitchVisibility(visibility) {
		this.dispatcher.setCameraSwitchVisibility(visibility);
	}

	setTextRecognitionSwitchVisible(isVisible) {
		this.dispatcher.setTextRecognitionSwitchVisible(isVisible);
	}

	setViewfinderDimension(x, y, width, height) {
		this.dispatcher.setViewfinderDimension(x, y, width, height);
	}

	setTorchMarginsAndSize(leftMargin, topMargin, width, height) {
		this.dispatcher.setTorchMarginsAndSize(leftMargin, topMargin, width, height);
	}

	setCameraSwitchMarginsAndSize(leftMargin, topMargin, width, height) {
		this.dispatcher.setCameraSwitchMarginsAndSize(leftMargin, topMargin, width, height);
	}

	setViewfinderColor(color) {
		this.dispatcher.setViewfinderColor(processColor(color));
	}

	setViewfinderDecodedColor(color) {
		this.dispatcher.setViewfinderDecodedColor(processColor(color));
	}

	setMatrixScanHighlightingColor(state, color) {
		this.dispatcher.setMatrixScanHighlightingColor(state, processColor(color));
	}

	setOverlayProperty(propName, propValue) {
		this.dispatcher.setOverlayProperty(propName, propValue);
	}

	setGuiStyle(style) {
		this.dispatcher.setGuiStyle(style);
	}

}
