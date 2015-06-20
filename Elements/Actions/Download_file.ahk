﻿iniAllActions.="Download_file|" ;Add this action to list of all actions on initialisation

runActionDownload_file(InstanceID,ThreadID,ElementID,ElementIDInInstance)
{
	global
	
	
	local tempPath:=% v_replaceVariables(InstanceID,ThreadID,%ElementID%file)
	if tempPath=
	{
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception")
		return
	}
	if  DllCall("Shlwapi.dll\PathIsRelative","Str",tempPath)
		tempPath:=SettingWorkingDir "\" tempPath
	
	

	local tempURL
	
	

	if %ElementID%IsExpression=1
		tempURL:=%ElementID%URL
	else if %ElementID%IsExpression=2
		tempURL:=v_replaceVariables(InstanceID,ThreadID,%ElementID%URL)
	else if %ElementID%IsExpression=3
		tempURL:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%URL)
	
	URLDownloadToFile,%tempURL%,%tempPath%
	if ErrorLevel
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception")
	else
	{
		v_SetVariable(InstanceID,ThreadID,tempVarName,temp)
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"normal")
	}
	return
}
getNameActionDownload_file()
{
	return lang("Download_file")
}
getCategoryActionDownload_file()
{
	return lang("Files") "|" lang("Internet")
}

getParametersActionDownload_file()
{
	global
	
	parametersToEdit:=["Label|" lang("URL"),"Radio|1|IsExpression|" lang("This is a Link. It does not contain variables") ";" lang("This is a Link. It contains variables enclosed in percentage signs") ";" lang("This is a variable name or expression"),"Text|http://www.example.com|URL","Label|" lang("File path"),"File||file|" lang("Select file") "|" ]
	return parametersToEdit
}

GenerateNameActionDownload_file(ID)
{
	global
	;MsgBox % %ID%text_to_show
	
	
	return lang("Download_file") " " GUISettingsOfElement%ID%file ": " GUISettingsOfElement%ID%URL 
	
}

CheckSettingsActionDownload_file(ID)
{
	
	
}
