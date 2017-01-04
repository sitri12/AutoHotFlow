﻿AllBuiltInVars:="A_Space A_Tab A_YYYY A_Year A_MM A_Mon A_DD A_MDay A_MMMM A_MMM A_DDDD A_DDD A_WDay A_YDay A_Hour A_Min A_Sec A_MSec A_TickCount A_TimeIdle A_TimeIdlePhysical A_Temp A_OSVersion A_Is64bitOS A_PtrSize A_Language A_ComputerName A_UserName A_ScriptDir A_WinDir A_ProgramFiles A_AppData A_AppDataCommon A_Desktop A_DesktopCommon A_StartMenu A_StartMenuCommon A_Programs A_ProgramsCommon A_Startup A_StartupCommon A_MyDocuments A_IsAdmin A_ScreenWidth A_ScreenHeight A_ScreenDPI A_IPAddress1 A_IPAddress2 A_IPAddress3 A_IPAddress4 A_Cursor A_CaretX A_CaretY a_now A_NowUTC a_linefeed"
AllCustomBuiltInVars:="a_lf a_workingdir A_LanguageName"

if not fileexist(my_workingdir "\Variables")
	FileCreateDir, % my_workingdir "\Variables"

LoopVariable_Set(Environment,p_Name,p_Value, p_hidden=False)
{
	if (p_hidden)
		Environment.loopvarsHidden[p_Name]:=p_Value
	else
		Environment.loopvars[p_Name]:=p_Value
}
ThreadVariable_Set(Environment,p_Name,p_Value,p_hidden=False)
{
	if (p_hidden)
		Environment.threadvarsHidden[p_Name]:=p_Value
	else
		Environment.threadvars[p_Name]:=p_Value
}
InstanceVariable_Set(Environment,p_Name,p_Value,p_hidden=False)
{
	global _execution
	if (p_hidden)
		_execution.instances[Environment.InstanceID].InstanceVarsHidden[p_Name]:=p_Value
	else
		_execution.instances[Environment.InstanceID].InstanceVars[p_Name]:=p_Value
	
}

StaticVariable_Set(Environment,p_Name,p_Value, p_hidden=False)
{
	global my_workingdir
	
	if (p_hidden)
		MsgBox unexpected error! It is not possible to set a hidden static variable!
	
	path:=my_workingdir "\Variables\" Environment.flowID
	FileCreateDir,%path%
	FileDelete,% path "\" p_Name ".ahfvd"
	FileDelete,% path "\" p_Name ".ahfvar"
	content:=""
	content.="[variable]`n"
	content.="name=" p_Name "`n"
	if isobject(p_value)
		content.="type=object`n"
	else
		content.="type=normal`n"
	FileAppend,%content%,% path "\" p_Name ".ahfvd", utf-16
	
	if isobject(p_value)
	{
		FileAppend,% strobj(p_Value),% path "\" p_Name ".ahfvar"
	}
	else
	{
		FileAppend,% p_Value,% path "\" p_Name ".ahfvar"
	}
	
}

GlobalVariable_Set(Environment,p_Name,p_Value, p_hidden=False)
{
	global my_workingdir
	if (p_hidden)
		MsgBox unexpected error! It is not possible to set a hidden global variable!
	
	path:=my_workingdir "\Variables"
	FileDelete,% path "\" p_Name ".ahfvd"
	FileDelete,% path "\" p_Name ".ahfvar"
	content:=""
	content.="[variable]`n"
	content.="name=" p_Name "`n"
	if isobject(p_value)
		content.="type=object`n"
	else
		content.="type=normal`n"
	FileAppend,%content%,% path "\" p_Name ".ahfvd", utf-16
	
	if isobject(p_value)
	{
		FileAppend,% strobj(p_Value),% path "\" p_Name ".ahfvar"
	}
	else
	{
		FileAppend,% p_Value,% path "\" p_Name ".ahfvar"
	}
	
}


LoopVariable_Get(Environment,p_Name, p_hidden=False)
{
	if (p_hidden)
		return Environment.loopvarsHidden[p_Name]
	else
		return Environment.loopvars[p_Name]
}
ThreadVariable_Get(Environment,p_Name, p_hidden=False)
{
	if (p_hidden)
		return Environment.threadvarsHidden[p_Name]
	else
		return Environment.threadvars[p_Name]
	
}
InstanceVariable_Get(Environment,p_Name, p_hidden=False)
{
	global _execution
	if (p_hidden)
		return _execution.instances[Environment.InstanceID].InstanceVarsHidden[p_Name]
	else
		return _execution.instances[Environment.InstanceID].InstanceVars[p_Name]
	
}

StaticVariable_Get(Environment,p_Name, p_hidden=False)
{
	global my_workingdir
	
	if (p_hidden)
		MsgBox unexpected error! There are no hidden static variables!
	
	path:=my_workingdir "\Variables\" Environment.flowID
	IniRead,vartype, % path "\" p_Name ".ahfvd", variable, type,%A_Space%
	if (vartype = "")
	{
		return 
	}
	else 
	{
		FileRead,varcontent, % path "\" p_Name ".ahfvar"
		if (vartype = "object")
		{
			return strobj(varcontent)
		}
		else
		{
			return varcontent
		}
	}
}

GlobalVariable_Get(Environment,p_Name, p_hidden=False)
{
	global my_workingdir
	
	if (p_hidden)
		MsgBox unexpected error! There are no hidden global variables!
	
	path:=my_workingdir "\Variables"
	IniRead,vartype, % path "\" p_Name ".ahfvd", variable, type,%A_Space%
	if (vartype = "")
	{
		return 
	}
	else 
	{
		FileRead,varcontent, % path "\" p_Name ".ahfvar"
		if (vartype = "object")
		{
			return strobj(varcontent)
		}
		else
		{
			return varcontent
		}
	}
}

BuiltInVariable_Get(Environment,p_Name, p_hidden=False)
{
	if (p_hidden)
		MsgBox unexpected error! There are no hidden built-in variables!
	
	;If no thread and loop variable found, try to find a built in variable if (p_Name="A_YWeek") ;Separate the week.
	if (p_Name="A_YWeek") 
	{
		StringRight,tempvalue,A_YWeek,2
		return tempvalue
	}
	else if (p_Name="A_LanguageName") 
	{
		tempvalue:= ;GetLanguageNameFromCode(A_Language) ;;TODO: Uncomment
		
		return tempvalue
	}
	else if (p_Name="a_workingdir")
	{
		;~ tempvalue:=flowSettings.WorkingDir
		return tempvalue
	}
	;~ else if (name="a_triggertime")
	;~ {
		;~ tempvalue:=Instance_%InstanceID%_Thread_%ThreadID%_Variables[name] 
		;~ if p_Type=Normal
			;~ return this.convertVariable(tempvalue,"date","`n") 
		;~ else
		;~ {
			;~ return tempvalue
		;~ }
	;~ }
	else if (p_Name="a_lf")
	{
		return  "`n"
	}
	;~ else if (p_Name="a_CPULoad")
	;~ {
		;~ return CPULoad()
	;~ }
	;~ else if (p_Name="a_MemoryUsage")
	;~ {
		;~ return MemoryLoad()
	;~ }
	;~ else if (p_Name="a_OSInstallDate")
	;~ {
		;~ if p_Type=Normal
			;~ return convertVariable(OSInstallDate(),"date","`n") 
		;~ else
		;~ {
			;~ return OSInstallDate()
		;~ }
	;~ }
	else If InStr(this.AllBuiltInVars,"-" p_Name "-")
	{
		tempvar:=%p_Name%
		return tempvar
	}
	;todo
}

LoopVariable_Delete(Environment,p_Name, p_hidden=False)
{
	if (p_hidden)
		Environment.loopvarsHidden.delete(p_Name)
	else
		Environment.loopvars.delete(p_Name)
}
ThreadVariable_Delete(Environment,p_Name, p_hidden=False)
{
	if (p_hidden)
		Environment.threadvarsHidden.delete(p_Name)
	else
		Environment.threadvars.delete(p_Name)
	
}
InstanceVariable_Delete(Environment,p_Name, p_hidden=False)
{
	global _execution
	
	if (p_hidden)
		_execution.instances[Environment.InstanceID].InstanceVarsHidden.delete(p_Name)
	else
		_execution.instances[Environment.InstanceID].InstanceVars.delete(p_Name)
	
}

StaticVariable_Delete(Environment,p_Name)
{
	global my_workingdir
	path:=my_workingdir "\Variables\" Environment.flowID
	FileDelete,% path "\" p_Name ".ahfvd"
	FileDelete,% path "\" p_Name ".ahfvar"
}
GlobalVariable_Delete(Environment,p_Name)
{
	global my_workingdir
	path:=my_workingdir "\Variables"
	FileDelete,% path "\" p_Name ".ahfvd"
	FileDelete,% path "\" p_Name ".ahfvar"
}


LoopVariable_AddToStack(Environment)
{
	;~ d({loopvars:Environment.loopvars, loopvarsstack:Environment.loopvarsStack},"preadd")
	;Write current loopvars to stack
	Environment.loopvarsStack.push(objFullyClone(Environment.loopvars))
	Environment.loopvarsStackHidden.push(objFullyClone(Environment.loopvarsHidden))
	
	;~ d({loopvars:Environment.loopvars, loopvarsstack:Environment.loopvarsStack},"add")
}
LoopVariable_RestoreFromStack(Environment)
{
	;~ d({loopvars:Environment.loopvars, loopvarsstack:Environment.loopvarsStack},"prerestore")
	;Restore loopvars from stack
	Environment.loopvars:=objFullyClone(Environment.loopvarsStack.pop())
	Environment.loopvarsHidden:=objFullyClone(Environment.loopvarsStackHidden.pop())
	
	;~ d({loopvars:Environment.loopvars, loopvarsstack:Environment.loopvarsStack},"restore")
}


Var_RetrieveDestination(p_Name,p_Location,p_log=true)
{
	if (substr(p_Name,1,2)="A_") ;If variable name begins with A_
	{
		if (p_Location!="Thread" and p_Location!="loop")
		{
			if (p_log=true or p_log="LOG")
				logger("f0","Setting built in variable '" p_Name "' failed. No permission given.")
			return ;No result
		}
		else ;The variable is either a thread variable or a loop variable
			return p_Location
	}
	else if (p_Location="Thread" or p_Location="loop")
	{
		if (p_log=true or p_log="LOG")
			logger("f0","Setting built in variable '" p_Name "' failed. It does not start with 'A_'.")
		return ;No result
		
	}
	else if (substr(p_Name,1,7)="global_")  ;If variable is global
	{
		return "global"
	}
	else if (substr(p_Name,1,7)="static_") ;If variable is static
	{
		return "static"
	}
	else
	{
		return "instance"
	}
	
	
}

Var_GetLocation(Environment, p_Name, p_hidden=False)
{
	global _execution, my_workingdir
	if (p_hidden = false)
	{
		if (Environment.loopvars.haskey(p_Name))
		{
			return "Loop"
		}
		else if (Environment.threadvars.haskey(p_Name))
		{
			return "Thread"
		}
		else if (_execution.instances[Environment.InstanceID].InstanceVars.haskey(p_Name))
		{
			return "instance"
		}
		else ifinstring,AllBuiltInVars, %p_Name%
		{
			return "BuiltIn"
		}
		else ifinstring,AllCustomBuiltInVars, %p_Name%
		{
			return "BuiltIn"
		}
		else if fileexist(my_workingdir "\Variables\" p_Name ".ahfvd")
		{		
			return "global"
		}
		else if fileexist(my_workingdir "\Variables\"  Environment.flowID "\" p_Name ".ahfvd")
		{		
			return "static"
		}
	}
	else
	{
		if (p_hidden != true and p_hidden != "hidden")
		{
			MsgBox unexpected error while retrieving variable location of %p_Name%: The parameter p_hidden has unsupported value: %p_hiden%
		}
		if (Environment.loopvarsHidden.haskey(p_Name))
		{
			return "Loop"
		}
		else if (Environment.threadvarsHidden.haskey(p_Name))
		{
			return "Thread"
		}
		else if (_execution.instances[Environment.InstanceID].InstanceVarsHidden.haskey(p_Name))
		{
			return "instance"
		}
	}
	;~ d(Environment, "error-  " p_name)
	;Todo: static and global variables
}

Var_Set(Environment, p_Name, p_Value, p_Destination="", p_hidden=False)
{
	global _execution
	res:=Var_CheckName(p_Name,true)
	if (res="empty")
	{
		if (p_log=true or p_log="LOG")
			logger("f0","Setting a variable failed. Its name is empty.")
		return ;No result
	}
	else if (res="ForbiddenCharacter")
	{
		if (p_log=true or p_log="LOG")
			logger("f0","Setting variable '" p_Name "' failed. It contains forbidden characters.")
		return ;No result
	}
	
	if (p_Destination="")
		destination:=Var_RetrieveDestination(p_Name,p_Destination,"LOG")
	else
		destination:=p_Destination
	if (destination!="")
	{
		%destination%Variable_Set(environment,p_Name,p_Value,p_hidden)
	}
	else
	{
		logger("f0","Setting variable '" p_Name "' failed. Cannot retrieve destination.")
	}
	;~ d(_execution.instances[Environment.InstanceID].InstanceVars,"instance vars set " p_Name)
}

Var_Get(environment, p_Name, p_hidden = False)
{
	global _execution
	tempvalue=
	if (p_Name="")
	{
		logger("f0","Retrieving variable failed. The name is empty")
	}
	
	tempLocation := Var_GetLocation(Environment, p_Name, p_hidden)
	
	if (tempLocation)
	{
		logger("f3","Retrieving " tempLocation " variable '" p_Name "'")
		tempVar := %tempLocation%Variable_Get(environment, p_Name, p_hidden)
		return tempVar
	}
	else
	{
		logger("f0","Retrieving variable '" p_Name "' failed. It does not exist")
	}
}

Var_GetType(Environment, p_Name, p_hidden = False)
{
	tempLocation := Var_GetLocation(Environment, p_Name, p_hidden)
	;~ d(tempLocation)
	if (tempLocation)
	{
		variable:=%tempLocation%Variable_Get(Environment, p_Name, p_hidden)
		;~ d(variable)
		if IsObject(variable)
		{
			return "object"
		}
		else
		{
			return "normal"
		}
	}
	
}
Var_Delete(Environment, p_Name, p_hidden=False)
{
	tempLocation := Var_GetLocation(Environment, p_Name, p_hidden)
	if (tempLocation)
		%tempLocation%Variable_Delete(Environment, p_Name, p_hidden)
}

Var_CheckName(p_Name, tellWhy=false) ;Return 1 if valid. 0 if not
{
	;Check whether the variable name is not empty
	if p_Name=
	{
		;~ logger("f0","Setting a variable failed. Its name is empty.")
		if tellWhy
			return "Empty"
		else
			return 0
	}
	;Check whether the variable name is valid and has no prohibited characters
	try
		asdf%p_Name%:=1 
	catch
	{
		;~ logger("f0","Setting variable '" p_Name "' failed. Name is invalid.")
		if tellWhy
			return "ForbiddenCharacter"
		else
			return 0
	}
	if tellWhy
		return "OK"
	else
		return 1
}



Var_replaceVariables(environment, p_String, pars = "")
{
	tempstring:=p_String
	;~ d(environment, "replace variables: " p_String )
	Loop
	{
		tempFoundPos:=RegExMatch(tempstring, "SU).*%(.+)%.*", tempFoundVarName)
		if tempFoundPos=0
			break
		tempVarValue:=Var_Get(environment,tempFoundVarName1)
		if isobject(tempVarValue)
		{
			IfInString, pars, ConvertObjectToString
				tempVarValue := strobj(tempVarValue)
		}
		
		StringReplace,tempstring,tempstring,`%%tempFoundVarName1%`%,% tempVarValue
		;~ MsgBox % "reerhes#-" tempstring "-#-" tempFoundVarName1 "-#-" Variable_Get(p_thread,tempFoundVarName1,p_ContentType)
		;~ MsgBox %tempVariablesToReplace1%
	}
	;~ d(environment, "replace variables result: " tempstring )
	return tempstring 
	
}

Var_GetListOfLoopVars(environment)
{
	retobject:=Object()
	for varname, varcontent in Environment.loopvars
	{
		retobject.push(varname)
	}
	return retobject
}
Var_GetListOfThreadVars(environment)
{
	retobject:=Object()
	for varname, varcontent in Environment.threadvars
	{
		retobject.push(varname)
	}
	return retobject
}
Var_GetListOfInstanceVars(environment)
{
	global _execution
	retobject:=Object()
	for varname, varcontent in _execution.instances[Environment.InstanceID].InstanceVars
	{
		retobject.push(varname)
	}
	return retobject
}
Var_GetListOfStaticVars(environment)
{

}
Var_GetListOfGlobalVars(environment)
{
	
}
Var_GetListOfAllVars(environment)
{
	retobject:=Object()
	for index, varname in Var_GetListOfLoopVars(environment)
	{
		retobject.push(varname)
	}
	for index, varname in Var_GetListOfThreadVars(environment)
	{
		retobject.push(varname)
	}
	for index, varname in Var_GetListOfInstanceVars(environment)
	{
		retobject.push(varname)
	}
	for index, varname in Var_GetListOfStaticVars(environment)
	{
		retobject.push(varname)
	}
	for index, varname in Var_GetListOfGlobalVars(environment)
	{
		retobject.push(varname)
	}
	return retobject
}