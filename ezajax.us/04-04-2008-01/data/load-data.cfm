<cfsetting requesttimeout="3600" showdebugoutput="yes">
<cfinclude template="../cfincludes/onRequest.cfm">
<cfinclude template="../cfincludes/functions.cfm">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Load Data</title>
</head>
<body>
	<cfscript>
		Request.myDSN = 'mssqlcf_raychorn';
		Request.ezAJAX_DSN = Request.myDSN;
		
		function retrieveRecord(aStruct) {
			_sql_statement = "SELECT UserNames.username, ServerNames.serverName, RuntimeLicenses.RuntimeLicenseData FROM EZAJAX.UserNames INNER JOIN EZAJAX.ServerNames ON UserNames.id = ServerNames.uid INNER JOIN EZAJAX.RuntimeLicenses ON ServerNames.id = RuntimeLicenses.sid WHERE (UserNames.username = '#aStruct.userName#') AND (ServerNames.serverName = '#aStruct.serverName#')";
			safely_execSQL('Request.qGetRecord', Request.ezAJAX_DSN, _sql_statement);
			writeOutput('Request.dbError=[#Request.dbError#]<br/>');
			writeOutput(cfdump(Request.qGetRecord,'Request.qGetRecord [#_sql_statement#]',false));
		}

		function insertRecord(aStruct) {
			_sql_statement = "SELECT id, username FROM EZAJAX.UserNames WHERE (username = '#aStruct.userName#')";
			safely_execSQL('Request.qGetUserID', Request.ezAJAX_DSN, _sql_statement);
			if (0) {
				writeOutput('Request.dbError=[#Request.dbError#]<br/>');
				writeOutput(cfdump(Request,'Request',true));
				writeOutput(cfdump(Request.qGetUserID,'Request.qGetUserID [#_sql_statement#]',false));
			}
			if (NOT Request.dbError) {
				uid = -1;
				if (Request.qGetUserID.recordCount gt 0) {
					uid = Request.qGetUserID.id;
				}
				if (uid eq -1) {
					_sql_statement = "INSERT INTO EZAJAX.UserNames (username) VALUES ('#aStruct.userName#'); SELECT @@IDENTITY as 'id';";
					safely_execSQL('Request.qAddUserName', Request.ezAJAX_DSN, _sql_statement);
					if (NOT Request.dbError) {
						if (Request.qAddUserName.recordCount gt 0) {
							uid = Request.qAddUserName.id;
						}
					}
				}
	
				if (NOT Request.dbError) {
					sid = -1;
					if ( (Len(aStruct.serverName) gt 0) AND (ezIsValidServerName(aStruct.serverName)) ) { // this allows any server name one might imagine using even IP addresses...
						_sql_statement = "SELECT id, uid, serverName FROM EZAJAX.ServerNames WHERE (serverName = '#aStruct.serverName#')";
						safely_execSQL('Request.qCheckServerName', Request.ezAJAX_DSN, _sql_statement);
						if (NOT Request.dbError) {
							bool_isServerNameTaken = false;
							if (Request.qCheckServerName.recordCount eq 0) {
								_sql_statement = "INSERT INTO EZAJAX.ServerNames (uid, serverName) VALUES (#uid#, '#aStruct.serverName#'); SELECT @@IDENTITY as 'id';";
								safely_execSQL('Request.qAddServerName', Request.ezAJAX_DSN, _sql_statement);
	
								if (NOT Request.dbError) {
									sid = Request.qAddServerName.id;

									bool_isCommunityEdition = 0;
									if (aStruct.isCommunityEdition) {
										bool_isCommunityEdition = 1;
									}
									_sql_statement = "INSERT INTO EZAJAX.RuntimeLicenses (sid, expirationDate, computerID, ProductName, productVersion, ServerName, ColdfusionID, osID, isCommunityEdition, copyrightNotice, RuntimeLicenseData) VALUES (#sid#,#CreateODBCDateTime(aStruct.expirationDate)#,'#filterQuotesForSQL(aStruct.computerID)#','#filterQuotesForSQL(aStruct.ProductName)#','#filterQuotesForSQL(aStruct.productVersion)#', '#filterQuotesForSQL(aStruct.ServerName)#','#filterQuotesForSQL(aStruct.ColdfusionID)#', '#filterQuotesForSQL(aStruct.osid)#',#bool_isCommunityEdition#,'#filterQuotesForSQL(aStruct.copyrightNotice)#','#filterQuotesForSQL(aStruct.RuntimeLicenseData)#'); SELECT @@IDENTITY as 'id';";
									safely_execSQL('Request.qAddLicenseToDb', Request.ezAJAX_DSN, _sql_statement);
									if (1) {
										writeOutput('Request.dbError=[#Request.dbError#]<br/>');
										writeOutput(cfdump(Request,'Request [#_sql_statement#]]',false));
									}
									if (NOT Request.dbError) {
									} else {
										writeOutput(Request.errorMsg & '<br/>');
									}
								}
							} else {
								writeOutput(Request.errorMsg & '<br/>');
							}
						} else {
							writeOutput(Request.errorMsg & '<br/>');
						}
					} else {
						writeOutput(Request.errorMsg & '<br/>');
					}
				} else {
					writeOutput(Request.errorMsg & '<br/>');
				}
			} else {
				writeOutput(Request.errorMsg & '<br/>');
			}
		}
		
		_names = 'username,serverName,expirationDate,computerID,ProductName,productVersion,_ServerName,ColdfusionID,osID,isCommunityEdition,copyrightNotice,RuntimeLicenseData';
		
		_data = '';
		writeOutput('CGI.PATH_TRANSLATED=[#getPathPrefix()#]<br/>');
		ezCfFileRead('#getPathPrefix()#\\raw-data.csv','_data');
		if (NOT Request.fileError) {
			for (i = 1; i lt ListLen(_data,chr(13)); i = i + 1) {
				glob = ListGetAt(_data,i,chr(13));
				_record = StructNew();
				for (j = 1; j lte ListLen(glob,','); j = j + 1) {
					token = Trim(Replace(ListGetAt(glob,j,','),'"','','all'));
					aName = ListGetAt(_names,j,',');
				//	writeOutput(aName & '=' & token & '<br/>');
					StructInsert(_record, aName, token);		
				}
				writeOutput(cfdump(_record,'Record #i#',false));
				insertRecord(_record);
				retrieveRecord(_record);
				writeOutput('==============================================================================<br/>');
			}
		} else {
			writeOutput('ERROR in reading the file due to [#Request.errorMsg#]');
		}
    </cfscript>
</body>
</html>
