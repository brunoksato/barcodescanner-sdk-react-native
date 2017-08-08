import PropTypes from 'prop-types';
import React from 'react';
import { NativeModules, requireNativeComponent, View } from 'react-native';

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
  
	onScan(event: Event) {
		if (!this.props.onScan) {
			return;
		}
		this.props.onScan(event.nativeEvent.codes);
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
		    onTextRecognized = {this.onTextRecognized} />;
	}
}

export let ScanditModule = NativeModules.ScanditModule