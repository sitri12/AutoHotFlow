﻿iniAllActions.="Get_mouse_position|" ;Add this action to list of all actions on initialisation

runActionGet_mouse_position(InstanceID,ThreadID,ElementID,ElementIDInInstance)
{
	global
	local tempx
	local tempy
	local tempwin
	local tempcontrol
	
	local tempVarNamex:=v_replaceVariables(InstanceID,ThreadID,%ElementID%varnamex)
	
	local tempVarNamey:=v_replaceVariables(InstanceID,ThreadID,%ElementID%varnamey)
	
	if %ElementID%CoordMode=1
		CoordMode, Mouse, Screen
	else if %ElementID%CoordMode=2
		CoordMode, Mouse, Window
	else if %ElementID%CoordMode=3
		CoordMode, Mouse, Client

	MouseGetPos,tempx,tempy,tempwin,tempcontrol
	
	v_SetVariable(InstanceID,ThreadID,tempVarNamex,tempx)
	v_SetVariable(InstanceID,ThreadID,tempVarNamey,tempy)
	v_SetVariable(InstanceID,ThreadID,"a_windowid",tempwin,,true)
	v_SetVariable(InstanceID,ThreadID,"a_controlID",tempcontrol,,true)
	
	MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"normal")
	return
}
getNameActionGet_mouse_position()
{
	return lang("Get_mouse_position")
}
getCategoryActionGet_mouse_position()
{
	return lang("User_simulation")
}

getParametersActionGet_mouse_position()
{
	global
	parametersToEdit:=["Label|" lang("Output variable X position"),"VariableName|PosX|varnameX","Label|" lang("Output variable Y position"),"VariableName|PosY|varnameY","Label|" lang("Mouse position"),"Radio|1|CoordMode|" lang("Relative to screen") ";" lang("Relative to active window position") ";" lang("Relative to active window client position")]
	
	return parametersToEdit
}

GenerateNameActionGet_mouse_position(ID)
{
	global
	local tempstring
	
	
	if GUISettingsOfElement%ID%CoordMode1=1
		tempstring.=lang("Relative to screen") " "
	else if GUISettingsOfElement%ID%CoordMode2=1
		tempstring.=lang("Relative to active window position") " "
	else if GUISettingsOfElement%ID%CoordMode3=1
		tempstring.=lang("Relative to active window client position") " "
	
	
	
	return % lang("Get_mouse_position") "`n" tempstring
	
}

CheckSettingsActionGet_mouse_position(ID)
{
	
}