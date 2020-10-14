<cfscript>
	_secret_phrase = 'd90a9sd9dad0as99w3e0934499ccx9v9909dfsd0';
	
	function getURLPrefix() {
		return ListDeleteAt(CGI.SCRIPT_NAME, ListLen(CGI.SCRIPT_NAME,'/'), '/');
	}
	
	function getPathPrefix() {
		return ListDeleteAt(CGI.PATH_TRANSLATED, ListLen(CGI.PATH_TRANSLATED,'\\'), '\\');;
	}

	function isRunningLocal() {
		return FindNoCase('localhost',CGI.SERVER_NAME) gt 0;
	}
</cfscript>