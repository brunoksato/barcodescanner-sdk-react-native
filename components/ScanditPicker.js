import PropTypes from 'prop-types';
import React from 'react';
import {
	requireNativeComponent,
	findNodeHandle,
	View,
	UIManager
} from 'react-native';
import { CommandDispatcher } from './CommandDispatcher';
import { ScanSession } from './ScanSession';
import { SerializationHelper } from './SerializationHelper';

var iface = {
  name: 'ReactBarcodePicker',
  propTypes: {
	  scanSettings: PropTypes.string,
	  onScan: PropTypes.func,
	  onSettingsApplied: PropTypes.func,
	  onTextRecognized: PropTypes.func,
	  ...View.propTypes
  }
};

var ReactBarcodePicker = requireNativeComponent('ReactBarcodePicker', iface);

export class ScanditPicker extends React.Component {

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
		var session = new ScanSession(event.nativeEvent.codes);
		this.props.onScan(session);
		this.dispatcher.finishOnScanCallback(SerializationHelper.serializeScanSession(session));
	}

	onSettingsApplied(event: Event) {
		if (!this.props.onSettingsApplied) {
			return;
		}
		this.props.onSettingsApplied(event.nativeEvent.settings);
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

	startScan() {
		this.dispatcher.startScan();
	}

	stopScan() {
		this.dispatcher.stopScan();
	}

	resumeScan() {
		this.dispatcher.resumeScan();
	}

	pauseScan() {
		this.dispatcher.pauseScan();
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

	setViewfinderColor(red, green, blue) {
		this.dispatcher.setViewfinderColor(red, green, blue);
	}

	setViewfinderDecodedColor(red, green, blue) {
		this.dispatcher.setViewfinderDecodedColor(red, green, blue);
	}

}
