﻿iniAllActions.="Set_Monitor_Settings|" ;Add this action to list of all actions on initialisation
ActionsWithMonitorDisplay := New Monitor()
ActionsWithMonitorNumberOfMonitors := DllCall("user32.dll\GetSystemMetrics", "Int", 80)                  ; Get the number of display monitors on a desktop.

RunActionSet_Monitor_Settings(InstanceID,ThreadID,ElementID,ElementIDInInstance)
{
	global
	local tempnumber
	local result
	
	if not %ElementID%AllMonitors
	{
		local MonitorNumber:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%MonitorNumber) 
		if MonitorNumber is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Monitor number " MonitorNumber " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Monitor number"),%ElementID%MonitorNumber) )
			return
		}
	}
	
	if %ElementID%WhetherChangeBrightness
	{
		local brightness:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%brightness) 
		if brightness is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Brightness " brightness " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Brightness"),%ElementID%brightness) )
			return
		}
	}
	if %ElementID%WhetherChangecontrast
	{
		local contrast:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%contrast) 
		if contrast is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Contrast " contrast " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Contrast"),%ElementID%contrast) )
			return
		}
	}
	;~ if %ElementID%WhetherChangegamma
	;~ {
		;~ local gamma:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%gamma) 
		;~ if gamma is not number
		;~ {
			;~ logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Gamma " gamma " is not a number")
			;~ MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Gamma"),%ElementID%gamma) )
			;~ return
		;~ }
	;~ }
	if %ElementID%WhetherSetRedGain
	{
		local RedGain:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%RedGain) 
		if RedGain is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Red gain " RedGain " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Red gain"),%ElementID%RedGain) )
			return
		}
	}
	if %ElementID%WhetherSetGreenGain
	{
		local GreenGain:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%GreenGain) 
		if GreenGain is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Green gain " GreenGain " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Green gain"),%ElementID%GreenGain) )
			return
		}
	}
	if %ElementID%WhetherSetBlueGain
	{
		local BlueGain:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%BlueGain) 
		if BlueGain is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Blue gain " BlueGain " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Blue gain"),%ElementID%BlueGain) )
			return
		}
	}
	if %ElementID%WhetherSetRedDrive
	{
		local RedDrive:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%RedDrive) 
		if RedDrive is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Red drive " RedDrive " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Red drive"),%ElementID%RedDrive) )
			return
		}
	}
	if %ElementID%WhetherSetGreenDrive
	{
		local GreenDrive:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%GreenDrive) 
		if GreenDrive is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Green drive " GreenDrive " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Green drive"),%ElementID%GreenDrive) )
			return
		}
	}
	if %ElementID%WhetherSetBlueDrive
	{
		local BlueDrive:=v_EvaluateExpression(InstanceID,ThreadID,%ElementID%BlueDrive) 
		if BlueDrive is not number
		{
			logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! Blue drive " BlueDrive " is not a number")
			MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("%1% '%2%' is not a number.",lang("Blue drive"),%ElementID%BlueDrive) )
			return
		}
	}
	
	loop %ActionsWithMonitorNumberOfMonitors%
	{
		if not %ElementID%AllMonitors
			tempnumber:=MonitorNumber
		else
			tempnumber:=A_Index
		
		;~ MsgBox %MonitorNumber% - %brightness%
		if %ElementID%WhetherChangeBrightness
		{
			result:=ActionsWithMonitorDisplay.SetMonitorBrightness(tempnumber,brightness)
		}
		if %ElementID%WhetherChangecontrast
		{
			result:=ActionsWithMonitorDisplay.SetMonitorContrast(tempnumber,contrast)
		}
		
		if %ElementID%WhetherSetRedGain
		{
			result:=ActionsWithMonitorDisplay.SetMonitorRedGreenOrBlueGain(tempnumber,0,RedGain)
		}
		if %ElementID%WhetherSetGreenGain
		{
			result:=ActionsWithMonitorDisplay.SetMonitorRedGreenOrBlueGain(tempnumber,1,GreenGain)
		}
		if %ElementID%WhetherSetBlueGain
		{
			result:=ActionsWithMonitorDisplay.SetMonitorRedGreenOrBlueGain(tempnumber,2,BlueGain)
		}
		if %ElementID%WhetherSetRedDrive
		{
			result:=ActionsWithMonitorDisplay.SetMonitorRedGreenOrBlueDrive(tempnumber,0,RedDrive)
		}
		if %ElementID%WhetherSetGreenDrive
		{
			result:=ActionsWithMonitorDisplay.SetMonitorRedGreenOrBlueDrive(tempnumber,1,GreenDrive)
		}
		if %ElementID%WhetherSetBlueDrive
		{
			result:=ActionsWithMonitorDisplay.SetMonitorRedGreenOrBlueDrive(tempnumber,2,BlueDrive)
		}
		if %ElementID%WhetherChangeColorTemperature
		{
			result:=ActionsWithMonitorDisplay.SetMonitorColorTemperature(tempnumber,%ElementID%ColorTemperature)
		}
		if not %ElementID%AllMonitors
			break
	}
	
	;~ if %ElementID%WhetherChangeGamma
	;~ {
		;~ ActionSet_Monitor_SettingsDisplay.SetDeviceGammaRamp(gamma)
	;~ }
	
	if (substr(result,1,1)="*")
	{
		logger("f0","Instance " InstanceID " - " %ElementID%type " '" %ElementID%name "': Error! An error occured. Error code: " result)
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"exception",lang("An error occured") ". " lang("Error code: %1%",result))
		return
	}
	else
	{
		MarkThatElementHasFinishedRunning(InstanceID,ThreadID,ElementID,ElementIDInInstance,"normal")
	}
	return
}
getNameActionSet_Monitor_Settings()
{
	return lang("Set_Monitor_Settings")
}
getCategoryActionSet_Monitor_Settings()
{
	return lang("Image")
}

getParametersActionSet_Monitor_Settings()
{
	global
	
	parametersToEdit:=Object()
	parametersToEdit.push({type: "Label", label: lang("Which monitor")})
	parametersToEdit.push({type: "Checkbox", id: "AllMonitors", default: 0, label: lang("All monitors")})
	parametersToEdit.push({type: "edit", id: "MonitorNumber", default: 1, content: "Expression", WarnIfEmpty: true, UseUpDown: true, range: "1-"ActionsWithMonitorNumberOfMonitors})
	
	parametersToEdit.push({type: "Label", label:  lang("Brightness")})
	parametersToEdit.push({type: "Checkbox", id: "WhetherChangeBrightness", default: 1, label: lang("Change brightness")})
	parametersToEdit.push({type: "Slider", id: "brightness", default: 100, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	
	parametersToEdit.push({type: "Label", label:  lang("Contrast")})
	parametersToEdit.push({type: "Checkbox", id: "WhetherChangeContrast", default: 0, label: lang("Change contrast")})
	parametersToEdit.push({type: "Slider", id: "contrast", default: 50, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	
	;~ parametersToEdit.push({type: "Label", label:  lang("Gamma") " (" lang("Affects all monitors") ")" })
	;~ parametersToEdit.push({type: "Checkbox", id: "WhetherChangeGamma", default: 0, label: lang("Change gamma")})
	;~ parametersToEdit.push({type: "Slider", id: "gamma", default: 128, options: "Range0-255 tooltip tickinterval128", AllowExpression: true})
	
	parametersToEdit.push({type: "Label", label:  lang("Color gain") })
	parametersToEdit.push({type: "Checkbox", id: "WhetherSetRedGain", default: 0, label: lang("Change red gain value")})
	parametersToEdit.push({type: "Slider", id: "RedGain", default: 128, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	parametersToEdit.push({type: "Checkbox", id: "WhetherSetGreenGain", default: 0, label: lang("Change green gain value")})
	parametersToEdit.push({type: "Slider", id: "GreenGain", default: 128, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	parametersToEdit.push({type: "Checkbox", id: "WhetherSetBlueGain", default: 0, label: lang("Change blue gain value")})
	parametersToEdit.push({type: "Slider", id: "BlueGain", default: 128, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	
	parametersToEdit.push({type: "Label", label:  lang("Color drive") })
	parametersToEdit.push({type: "Checkbox", id: "WhetherSetRedDrive", default: 0, label: lang("Change red drive value")})
	parametersToEdit.push({type: "Slider", id: "RedDrive", default: 128, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	parametersToEdit.push({type: "Checkbox", id: "WhetherSetGreenDrive", default: 0, label: lang("Change green drive value")})
	parametersToEdit.push({type: "Slider", id: "GreenDrive", default: 128, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	parametersToEdit.push({type: "Checkbox", id: "WhetherSetBlueDrive", default: 0, label: lang("Change blue drive value")})
	parametersToEdit.push({type: "Slider", id: "BlueDrive", default: 128, options: "Range0-100 tooltip tickinterval10", AllowExpression: true})
	
	parametersToEdit.push({type: "Label", label:  lang("Color temperature")})
	parametersToEdit.push({type: "Checkbox", id: "WhetherChangeColorTemperature", default: 0, label: lang("Change color temperature")})
	parametersToEdit.push({type: "DropDown", id: "ColorTemperature", default: 1, choices: ["4000 K.", "5000 K.", "6500 K.", "7500 K.", "8200 K.", "9300 K.", "10000 K.", "115000 K."], result: "number"})

	return parametersToEdit
}

GenerateNameActionSet_Monitor_Settings(ID)
{
	global
	local tempText
	local colortemperatures:=["4000 K.", "5000 K.", "6500 K.", "7500 K.", "8200 K.", "9300 K.", "10000 K.", "115000 K."]
	if GUISettingsOfElement%ID%WhetherChangeBrightness
		tempText.= " - " lang("Brightness") ": " GUISettingsOfElement%ID%brightness
	if GUISettingsOfElement%ID%WhetherChangeContrast
		tempText.= " - " lang("Contrast") ": " GUISettingsOfElement%ID%contrast 
	;~ if GUISettingsOfElement%ID%WhetherChangeGamma
		;~ tempText.= " - " lang("Gamma") ": " GUISettingsOfElement%ID%gamma 
	if GUISettingsOfElement%ID%WhetherSetRedGain
		tempText.= " - " lang("Red gain") ": " GUISettingsOfElement%ID%RedGain
	if GUISettingsOfElement%ID%WhetherSetGreenGain
		tempText.= " - " lang("Green gain") ": " GUISettingsOfElement%ID%GreenGain 
	if GUISettingsOfElement%ID%WhetherSetBlueGain
		tempText.= " - " lang("Blue gain") ": " GUISettingsOfElement%ID%BlueGain
	if GUISettingsOfElement%ID%WhetherSetRedDrive
		tempText.= " - " lang("Red gain") ": " GUISettingsOfElement%ID%RedDrive
	if GUISettingsOfElement%ID%WhetherSetGreenDrive
		tempText.= " - " lang("Green gain") ": " GUISettingsOfElement%ID%GreenDrive 
	if GUISettingsOfElement%ID%WhetherSetBlueDrive
		tempText.= " - " lang("Blue gain") ": " GUISettingsOfElement%ID%BlueDrive
	if GUISettingsOfElement%ID%WhetherChangeColorTemperature
		tempText.= " - " lang("Color temperature") ": " colortemperatures[GUISettingsOfElement%ID%ColorTemperature]
	
	return lang("Set_Monitor_Settings") tempText
	
}


CheckSettingsActionSet_Monitor_Settings(ID)
{
	global
	
	local shouldinitializeranges
	local temp
	static oldMonitorNumber
	static oldID
	
	if (ID!=oldID)
	{
		shouldinitializeranges:=true
		oldID:=ID
	}
	if (oldMonitorNumber!=GUISettingsOfElement%ID%MonitorNumber)
	{
		shouldinitializeranges:=true
		oldMonitorNumber:=GUISettingsOfElement%ID%MonitorNumber
	}
	if openingElementSettingsWindow
		shouldinitializeranges:=true
	
	if (GUISettingsOfElement%ID%AllMonitors = 1)
	{
		GuiControl,Disable,GUISettingsOfElement%ID%MonitorNumber
	}
	else
	{
		GuiControl,Enable,GUISettingsOfElement%ID%MonitorNumber
	}
	
	if (GUISettingsOfElement%ID%WhetherChangeBrightness = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%brightness
		GuiControl,Enable,GUISettingsOfElement%ID%brightness
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%brightness
		GuiControl,Disable,GUISettingsOfElement%ID%brightness
	}
	
	if (GUISettingsOfElement%ID%WhetherChangeContrast = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%contrast
		GuiControl,Enable,GUISettingsOfElement%ID%contrast
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%contrast
		GuiControl,Disable,GUISettingsOfElement%ID%contrast
	}
	
	;~ if (GUISettingsOfElement%ID%WhetherChangeGamma = 1)
	;~ {
		;~ GuiControl,Enable,GUISettingsOfElementSlideOf%ID%gamma
		;~ GuiControl,Enable,GUISettingsOfElement%ID%gamma
	;~ }
	;~ else
	;~ {
		;~ GuiControl,Disable,GUISettingsOfElementSlideOf%ID%gamma
		;~ GuiControl,Disable,GUISettingsOfElement%ID%gamma
	;~ }
	
	if (GUISettingsOfElement%ID%WhetherSetRedGain = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%RedGain
		GuiControl,Enable,GUISettingsOfElement%ID%RedGain
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%RedGain
		GuiControl,Disable,GUISettingsOfElement%ID%RedGain
	}
	if (GUISettingsOfElement%ID%WhetherSetGreenGain = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%GreenGain
		GuiControl,Enable,GUISettingsOfElement%ID%GreenGain
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%GreenGain
		GuiControl,Disable,GUISettingsOfElement%ID%GreenGain
	}
	if (GUISettingsOfElement%ID%WhetherSetBlueGain = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%BlueGain
		GuiControl,Enable,GUISettingsOfElement%ID%BlueGain
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%BlueGain
		GuiControl,Disable,GUISettingsOfElement%ID%BlueGain
	}
	if (GUISettingsOfElement%ID%WhetherSetRedDrive = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%RedDrive
		GuiControl,Enable,GUISettingsOfElement%ID%RedDrive
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%RedDrive
		GuiControl,Disable,GUISettingsOfElement%ID%RedDrive
	}
	if (GUISettingsOfElement%ID%WhetherSetGreenDrive = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%GreenDrive
		GuiControl,Enable,GUISettingsOfElement%ID%GreenDrive
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%GreenDrive
		GuiControl,Disable,GUISettingsOfElement%ID%GreenDrive
	}
	if (GUISettingsOfElement%ID%WhetherSetBlueDrive = 1)
	{
		GuiControl,Enable,GUISettingsOfElementSlideOf%ID%BlueDrive
		GuiControl,Enable,GUISettingsOfElement%ID%BlueDrive
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElementSlideOf%ID%BlueDrive
		GuiControl,Disable,GUISettingsOfElement%ID%BlueDrive
	}
	
	if (GUISettingsOfElement%ID%WhetherChangeColorTemperature = 1)
	{
		GuiControl,Enable,GUISettingsOfElement%ID%ColorTemperature
	}
	else
	{
		GuiControl,Disable,GUISettingsOfElement%ID%ColorTemperature
	}
	
	
	if shouldinitializeranges
	{
		
		temp:=ActionsWithMonitorDisplay.GetMonitorBrightness(oldMonitorNumber)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%brightness
		guicontrol,,GUISettingsOfElementSlideOf%ID%brightness,% GUISettingsOfElement%ID%brightness
		temp:=ActionsWithMonitorDisplay.GetMonitorContrast(oldMonitorNumber)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%contrast
		guicontrol,,GUISettingsOfElementSlideOf%ID%contrast,% GUISettingsOfElement%ID%contrast
		
		temp:=ActionsWithMonitorDisplay.GetMonitorRedGreenOrBlueGain(oldMonitorNumber,0)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%redgain
		guicontrol,,GUISettingsOfElementSlideOf%ID%redgain, % GUISettingsOfElement%ID%redgain
		temp:=ActionsWithMonitorDisplay.GetMonitorRedGreenOrBlueGain(oldMonitorNumber,1)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%greengain
		guicontrol,,GUISettingsOfElementSlideOf%ID%greengain,% GUISettingsOfElement%ID%greengain
		temp:=ActionsWithMonitorDisplay.GetMonitorRedGreenOrBlueGain(oldMonitorNumber,2)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%bluegain
		guicontrol,,GUISettingsOfElementSlideOf%ID%bluegain,% GUISettingsOfElement%ID%bluegain
		
		temp:=ActionsWithMonitorDisplay.GetMonitorRedGreenOrBlueDrive(oldMonitorNumber,0)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%redDrive
		guicontrol,,GUISettingsOfElementSlideOf%ID%redDrive, % GUISettingsOfElement%ID%redDrive
		temp:=ActionsWithMonitorDisplay.GetMonitorRedGreenOrBlueDrive(oldMonitorNumber,1)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%greenDrive
		guicontrol,,GUISettingsOfElementSlideOf%ID%greenDrive,% GUISettingsOfElement%ID%greenDrive
		temp:=ActionsWithMonitorDisplay.GetMonitorRedGreenOrBlueDrive(oldMonitorNumber,2)
		guicontrol,% "+range" temp.Minimum  "-" temp.Maximum,GUISettingsOfElementSlideOf%ID%blueDrive
		guicontrol,,GUISettingsOfElementSlideOf%ID%blueDrive,% GUISettingsOfElement%ID%blueDrive
	}
	
}