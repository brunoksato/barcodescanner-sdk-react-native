import {
	NativeModules
} from 'react-native';
export { ScanSession } from './components/ScanSession';
export { ScanditPicker } from './components/ScanditPicker';
export { Barcode } from './components/Barcode';
export { ScanSettings } from './components/ScanSettings';
export { SymbologySettings } from './components/SymbologySettings';

export const ScanditModule = NativeModules.ScanditModule;
