<cfscript>
	_s = '';
	if (CGI.SERVER_PORT eq 443) {
		_s = 's';
	}
	_action = 'http#_s#://' & CGI.SERVER_NAME;
	if (CGI.SERVER_PORT neq 80) {
		_action = "#_action#:#CGI.SERVER_PORT#";
	}
	_action = "#_action##CGI.SCRIPT_NAME#";
</cfscript>
<cfoutput>
    <cfform name="form1" format="flash" width="600" height="150" wmode="transparent" onload="_root.Email_Address.setFocus();" method="post" action="#_action#">
        <cfformgroup type="vertical">
            <cfformitem type="html">
                Enter the Email Address and Server Name you used when you Registered your Ez-AJAX License<br>(click the entry field before you begin typing)
            </cfformitem>
        </cfformgroup>
        <cfformgroup type="horizontal">
            <cfinput type="text" name="Email_Address" size="35" label="Email Address:" value="" validate="email" required="yes">
        </cfformgroup>
        <cfformgroup type="horizontal">
            <cfinput type="text" name="Server_Name" size="30" label="Server Name:" value="" validate="noblanks" required="yes">
            <cfinput type="submit" name="btn_submit" value="GO" tooltip="Click this button to retrieve your License File.">
        </cfformgroup>
        <cfformgroup type="vertical">
        	<cfinput type="hidden" name="secret" value="#_secret_phrase#">
        </cfformgroup>
    </cfform>
</cfoutput>
