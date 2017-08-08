export class ScanSession {

	constructor(scanData) {
		this.scanData = scanData;
		this.shouldPause = false;
		this.shouldStop = false;
	}

	pauseScan() {
		this.shouldPause = true;
	}

	stopScan() {
		this.shouldStop = true;
	}

}
