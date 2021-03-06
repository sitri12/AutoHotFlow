﻿iniAllActions.="Minimize_all_windows|" ;Add this action to list of all actions on initialisation

runActionMinimize_all_windows(InstanceID,ThreadID,ElementID,ElementIDInInstance)
{
	global

	
	if %ElementID%WinMinimizeAllEvent=1
		WinMinimizeAll
	else
		WinMinimizeAllUndo

	MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"normal")
	return
}
getNameActionMinimize_all_windows()
{
	return lang("Minimize_all_windows")
}
getCategoryActionMinimize_all_windows()
{
	return lang("Window")
}

getParametersActionMinimize_all_windows()
{
	global
	
		parametersToEdit:=Object()
	parametersToEdit.push({type: "Label", label: lang("Event")})
	parametersToEdit.push({type: "Radio", id: "WinMinimizeAllEvent", default: 1, choices: [lang("Minimize all windows"), lang("Undo")]})
return parametersToEdit
}

GenerateNameActionMinimize_all_windows(ID)
{
	global
	;MsgBox % %ID%text_to_show
	
	return lang("Minimize_all_windows") ": " GUISettingsOfElement%id%frequency " " lang("Hz") " " GUISettingsOfElement%id%duration " " lang("ms")
	
}


