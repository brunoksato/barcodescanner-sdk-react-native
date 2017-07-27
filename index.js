import PropTypes from 'prop-types';
import React from 'react';
import { NativeModules, requireNativeComponent, View } from 'react-native';

var iface = {
  name: 'ReactBarcodePicker',
  propTypes: {
	  scanSettings: PropTypes.string,
	  onScan: PropTypes.func,
	  ...View.propTypes
  }
};

var ReactBarcodePicker = requireNativeComponent('ReactBarcodePicker', iface);

export class ScanditPicker extends React.Component {
	
	constructor(props) {
		super(props);
		this._onChange = this._onChange.bind(this);
	}
  
	_onChange(event: Event) {
		if (!this.props.onScan) {
			return;
		}
		this.props.onScan(event.nativeEvent.codes);
	}
	
	render() {
		return <ReactBarcodePicker {...this.props} onChange={this._onChange} />;
	}
}

export let ScanditModule = NativeModules.ScanditModule