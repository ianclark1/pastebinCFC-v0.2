/*
	Name: pastebinCFC
	Author: Andy Matthews
	Website: http://www.andyMatthews.net || http://returnPacket.riaforge.org
	Created: 1/29/2011
	Last Updated: 1/29/2011
	History:
			1/29/2011		Initial creation
	Purpose: Wrapper for the pasteBin API
	Version: Listed in contructor
	A ColdFusion wrapper for the PasteBin code snippet storage API
*/
 /**
 * @accessors true
 */
component {

	property string currentVersion;
	property string appName;
	property date lastUpdated;
    property string apiRoot;

	public pastebinCFC function init() {
		VARIABLES.currentVersion = '0.1';
		VARIABLES.appName = 'pastebinCFC';
		VARIABLES.lastUpdated = DateFormat(CreateDate(2011,01,29),'mm/dd/yyyy');
        VARIABLES.apiRoot = 'http://pastebin.com/api_public.php';
		return THIS;
	}

	public struct function introspect() {
		return getMetaData(THIS);
	}

	public any function paste(required string paste_code, struct options, string format = 'cfm') {
		var returnPacket = { success=0, message='', data='' };
		var remoteCall = new http(method='POST', url=getApiRoot());
		remoteCall.addParam(type='formfield', name='paste_code', value=ARGUMENTS.paste_code);
		for (o in ARGUMENTS.options) {
			if (ARGUMENTS.options[o] != '') remoteCall.addParam(type='formfield', name=o, value=ARGUMENTS.options[o]);
		}
		result = remoteCall.send().getPrefix();
		// make sure the request was successful, and there's no errors
		if ( Find('ERROR', result.FileContent) ) {
			returnPacket.message = result.FileContent;
		} else {
			returnPacket.message = 'Success';
			returnPacket.success = 1;
			returnPacket.data = result.FileContent;
		};
		if (ARGUMENTS.format == 'cfm') {
			return returnPacket;
		} else {
			return serializeJSON(returnPacket);
		}
	}

}