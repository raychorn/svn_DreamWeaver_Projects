<cfscript>
	_schema = 'dbo';
	if (NOT isRunningLocal()) {
		_schema = 'EZAJAX';
	}
</cfscript>
<cftry>
	<cfif isRunningLocal() AND 1>
        <cfdump var="#FORM#" label="FORM">
    </cfif>
	<cfif isDefined("FORM.Email_Address") AND (Len(FORM.Email_Address) gt 0) AND isDefined("FORM.Server_Name") AND (Len(FORM.Server_Name) gt 0) AND isDefined("FORM.secret") AND (Len(FORM.secret) gt 0) AND (FORM.secret eq _secret_phrase)>
        <cfscript>
			_username = Trim(FORM.Email_Address);
			_servername = Trim(FORM.Server_Name);
			_sql_statement = "SELECT UserNames.username, ServerNames.serverName, RuntimeLicenses.RuntimeLicenseData FROM #_schema#.UserNames INNER JOIN #_schema#.ServerNames ON UserNames.id = ServerNames.uid INNER JOIN #_schema#.RuntimeLicenses ON ServerNames.id = RuntimeLicenses.sid WHERE (UserNames.username = '#_username#') AND (ServerNames.serverName = '#_servername#')";
			safely_execSQL('Request.getLicense', 'mssqlcf_raychorn', _sql_statement);
		</cfscript>
		<cfif Request.getLicense.recordCount gt 0>
			<cfif isRunningLocal() AND 1>
				<cfdump var="#Request.getLicense#" label="Request.getLicense [#_sql_statement#]">
			</cfif>
			<cfoutput>
				<table width="500">
					<tr bgcolor="##CCCCCC">
						<td align="center">
							<b>EMail Address</b>
						</td>
						<td align="center">
							<b>Server</b>
						</td>
						<td align="center">
							<b>License</b>
						</td>
					</tr>
					<cfloop query="Request.getLicense">
						<tr>
							<td align="center">
								#username#
							</td>
							<td align="center">
								#serverName#
							</td>
							<td align="center">
<textarea cols="80" rows="2" readonly="readonly" wrap="virtual">#RuntimeLicenseData#</textarea>
							</td>
						</tr>
					</cfloop>
                    <tr>
                    	<td colspan="3">
                        	<b>Directions:</b> Click on the text area immediately below the License column header and type Ctrl-a to highlight your Runtime-License then type Ctrl-c to copy to your clipboard then paste to the appropriate file and install to make your installation of Ez-AJAX usable.<br/><br/>
                            Follow the instructions found with the Installation Program when installing your Runtime-License.<br/><br/>
                            Future versions of Ez-AJAX will be self-registering and there will be no need to install a Runtime-License on your local web server.<br/><br/>
                            Future versions of Ez-AJAX will be more of a Web 2.0 Appliance that will be installed by placing a SWF on your web page. The SWF will contain all the AJAX code. The SWF will be self-registering and will not require a Runtime-License.  You will issue commands to the Ez-AJAX System through a JavaScript Gateway and Ez-AJAX will handle the interactions with your server.
                        </td>
                    </tr>
				</table>
			</cfoutput>
		</cfif>
	</cfif>

	<cfcatch type="any">
		<cfif isRunningLocal() AND 1>
			<cfscript>
				if (isDefined("_sql_statement")) {
					writeOutput('_sql_statement=[#_sql_statement#]<br/>');
				}
				if (isDefined("cfcatch.Type")) {
					writeOutput('cfcatch.Type=[#cfcatch.Type#]<br/>');
				}
				if (isDefined("cfcatch.ErrNumber")) {
					writeOutput('cfcatch.ErrNumber=[#cfcatch.ErrNumber#]<br/>');
				}
				if (isDefined("cfcatch.Detail")) {
					writeOutput('cfcatch.Detail=[#cfcatch.Detail#]<br/>');
				}
				if (isDefined("cfcatch.Message")) {
					writeOutput('cfcatch.Message=[#cfcatch.Message#]<br/>');
				}
				if (isDefined("cfcatch.SQLState")) {
					writeOutput('cfcatch.SQLState=[#cfcatch.SQLState#]<br/>');
				}
			</cfscript>
		</cfif>
	</cfcatch>
</cftry>

<cfif 0>
	<cfoutput>
		<cfdump var="#FORM#" label="FORM">
	</cfoutput>
</cfif>
