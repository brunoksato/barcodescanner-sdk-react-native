import PropTypes from 'prop-types';
import { NativeModules, requireNativeComponent, View } from 'react-native';

var iface = {
  name: 'ReactBarcodePicker',
  propTypes: {
	  ...View.propTypes
  }
};

export let TestToastAndroid = NativeModules.TestToastAndroid
export let ScanditModule = NativeModules.ScanditModule
export let ReactBarcodePicker = requireNativeComponent('ReactBarcodePicker', iface);