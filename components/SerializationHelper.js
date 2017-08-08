import { ScanSession } from './ScanSession';

export class SerializationHelper {

  static serializeScanSession(scanSession) {
    return [scanSession.shouldStop, scanSession.shouldPause, scanSession.scanData];
  }

  static deserializeScanSession(array) {
    var session = new ScanSession(array[2]);
    session.shouldStop = array[0];
    session.shouldPause = array[1];
    return session;
  }

}
