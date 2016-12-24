﻿
init_GlobalVars()
{
	global
	/* Content of _flows
	_flows is an associative array of objects. Each object contains some informations:
		.id 			Flow ID (which is also the key)
		.name 			Flow name
		.allElements	Associative array of Objects. Each object contains following values:
			.ID				ID of the element. (Which is also the key)
			.name			Element name
			.type			Element type name
			.subtype		Element subtype name
			.class			Element class name. Equals to %type%_%subtype%
			.pars			Associative Array with the parameters of the element
			.triggers		If element contains triggers, this will be an array of trigger IDs
			.fromConnections	A list of connection IDs which start from the element
			.toConnections	A list of connection IDs which end on the element
			
			.x	.y			Position
			.heightOfVerticalBar	If element is a loop
			.StandardName	Setting whether the name should be generated (True) or manually set by user (False)
			.marked			True if element is marked
			.ClickPriority	If multiple elements hover each other, this value makes it possible to click through the elements 
			
			.state			Execution state of the element
			.countRuns		Count of Threads which are currently running this element
			.lastrun		Timestamp of last execution (a_tickcount)
			
		.allConnections	Associative array of Objects. Each object contains following values:
			.ID				ID of the connections. (Which is also the key)
			.type			Contains string "Connection"
			.ConnectionType	Connection type
			.from			Element ID where the connection starts
			.to				Element ID where the connection ends
			
			.marked			True if connection is marked
			.ClickPriority	If multiple elements hover each other, this value makes it possible to click through the elements
			
			.state			Execution state of the element
			.lastrun		Timestamp of last execution (a_tickcount)
		
		.allTriggers	Associative array of Objects. Each object contains following values:
			.ID				ID of the trigger. (Which is also the key)
			.ContainerID	Element ID containing the trigger
			.class			Trigger class name. Equals to %type%_%subtype%
			.type			Contains string "Trigger"
			.par			Associative Array with the parameters of the trigger
			
			.state			Execution state of the element
			.enabled		True if trigger is enabled
		
		.markedElements	Contains an array of all element and connection IDs which are marked
		
		.FlowSettings		Contains all flow specific settings
			.ExecutionPolicy	Defines what happens if a flow is triggered but already executing. Contains "wait", "skip", "stop" or "parallel"
			.FolderOfStaticVariables	;TODO
			.LogToFile		Defines whether the logging of this flow should be written to file
			.OffsetX		Current offset
			.OffsetY		Current offset
			.zoomFactor		Current zoom factor
			.WorkingDir		Working dir of the flow
		
		;Internal values
		.category 		Flow category ID (Internal ID, which is not the name)
		.categoryName 	Flow category name
		.tv 			Flow tree view ID
		
		.enabled 		True if flow is enabled
		.executing 		True if flow is running
		.countOfExecutions	
		.countOfWaitingExecutions
		
		.Folder			Folder path of the flow
		.FileName		File name of the flow
		
		.draw			Object containing some informations for the draw thread:
			.mustDraw		True if something has changed and the flow must be redrawn
		.Type			Flow type (currently containing "Flow")
		
		.states			Object containing up to 100 previous states of the flow (which allows undo and redo). Each object contains following values:
			.id				ID of the state. (Which is also the key)
			.allElements
			.allConnections
			.allTriggers
		.currentState	ID of current state
	*/
	_flows := CriticalObject()
	
	/* Content of _settings
	
	
	*/
	
	_settings := CriticalObject()
	
	/* Content of _execution
	_execution is an associative array of values:
		.Instances		Associative array of objects. Each object contains following values:
			.ID				Instance ID (Which is also the key)
			.FlowID			Flow ID
			.Threads		Associative array of objects. Each object contains following values:
				.ID				Thread ID (Which is also the key)
				.ThreadID		Same as .ID
				.State			Defines the current state of the execution.
					-starting 		The element execution is ready to be started
					-running		The element execution is currently running
					-finished		The element execution has finished
				.flowID			Flow ID
				.ElementID		Currently executed element
				.InstanceID		Instance ID
				.ElementPars 	Parameters of the element
				.Result			Contains the execution result if execution of current element has finished
				.Message		Result message. Especially if error.
				.threadVars 	thread variables in current execution
				.loopVars		thread loop variables in current execution
			.InstanceVars	Local variables in current instance
			
		.triggers		Associative array of objects. Each object contains following values:
			.ID				Enabled trigger ID (Which is also the key)
			.FlowID			Flow ID
			.ElementID		ID of trigger
			.ElementClass	Element class of trigger
			.enabled		Whether the element was successfully enabled
			.result			Result of element enabling
			.Message		Message of element enabling
		
		
		
	*/
	_execution := CriticalObject()
	_execution.Instances := CriticalObject()
	_execution.triggers := CriticalObject()
	
	/* Content of _GlobalVars
	
	
	*/
	_GlobalVars := CriticalObject()	
	
	
	/* Content of _share
	_share contains some values:
		.allCategories	Internal array which contains all categories: Each entry contains following:
			.id				Internal Category ID. (Which is also the key)
			.Name			Category name.
			.Type			Category Type. (Containing the string "Category")
			.TV				Tree view ID. 
		.log			Log content
	*/
	_share := CriticalObject()

	_language := CriticalObject()
	
	_share.hwnds := Object()
	_share.log := ""
	_share.logcount := 0
	_share.logcountAfterTidy := 0
	_share.drawActive := 0 	;True if the draw thread is currently active
	_share.temp := criticalObject() 	;For temporary content
	
	CriticalSection_Flows := CriticalSection()
}