﻿goto,jumpoverclickstuff

clickOnPicture: ;react on clicks of the user

thread, Priority, -50

MouseGetPos,mx,my ;Get the mouse position



if (A_GuiEvent="DoubleClick") ;If user double clicked
{
	
	if (theOnlyOneMarkedElement)
		ui_settingsOfElement(theOnlyOneMarkedElement) ;open settings of the marked element
	return
}

GetKeyState,ControlKeyState,control,p ;If control is pressed

elementWithHighestPriority=
if ((0 < mx) and (0 < my) and ((NewElementIconWidth*1.2*zoomFactor)  > mx) and ((NewElementIconHeight*1.2*zoomFactor) > my))
	elementWithHighestPriority=MenuCreateNewAction
if (((NewElementIconWidth*1.2*zoomFactor) < mx) and (0 < my) and ((NewElementIconWidth*1.2 * 2*zoomFactor)  > mx) and ((NewElementIconHeight*1.2*zoomFactor) > my))
	elementWithHighestPriority=MenuCreateNewCondition



	;ToolTip( "gsdd" Sqrt((middlePointOfPlusButtonX*zoomFactor - mx)*(middlePointOfPlusButtonX*zoomFactor - mx) + (middlePointOfPlusButtonY*zoomFactor - my)*(middlePointOfPlusButtonY*zoomFactor - my)) "`n middlePointOfPlusButtonX " middlePointOfPlusButtonX "`n middlePointOfPlusButtonY " middlePointOfPlusButtonY)
	
	if (PlusButtonExist=true and Sqrt((middlePointOfPlusButtonX*zoomFactor - mx)*(middlePointOfPlusButtonX*zoomFactor - mx) + (middlePointOfPlusButtonY*zoomFactor - my)*(middlePointOfPlusButtonY*zoomFactor - my)) < SizeOfButtons/2*zoomFactor)
		elementWithHighestPriority=PlusButton
	else if (EditButtonExist=true and Sqrt((middlePointOfEditButtonX*zoomFactor - mx)*(middlePointOfEditButtonX*zoomFactor - mx) + (middlePointOfEditButtonY*zoomFactor - my)*(middlePointOfEditButtonY*zoomFactor - my)) < SizeOfButtons/2 *zoomFactor)
		elementWithHighestPriority=EditButton
	else if (TrashButtonExist=true and Sqrt((middlePointOfTrashButtonX*zoomFactor - mx)*(middlePointOfTrashButtonX*zoomFactor - mx) + (middlePointOfTrashButtonY*zoomFactor - my)*(middlePointOfTrashButtonY*zoomFactor - my)) < SizeOfButtons/2*zoomFactor)
		elementWithHighestPriority=TrashButton
	else if (MoveButton2Exist=true and Sqrt((middlePointOfMoveButton2X*zoomFactor - mx)*(middlePointOfMoveButton2X*zoomFactor - mx) + (middlePointOfMoveButton2Y*zoomFactor - my)*(middlePointOfMoveButton2Y*zoomFactor - my)) < SizeOfButtons/2*zoomFactor)
		elementWithHighestPriority=MoveButton2
	else if (MoveButton1Exist=true and Sqrt((middlePointOfMoveButton1X*zoomFactor - mx)*(middlePointOfMoveButton1X*zoomFactor - mx) + (middlePointOfMoveButton1Y*zoomFactor - my)*(middlePointOfMoveButton1Y*zoomFactor - my)) < SizeOfButtons/2*zoomFactor)
		elementWithHighestPriority=MoveButton1
	


if elementWithHighestPriority=
{
	clickHighestPriority=0 ;The highest priority decides whitch element will be selected. The priority reduces a little bit when the element was selected, and increases every time the user clicks on it but something else is selected. This way it is possible to click through the elements whith are beneath each other.
	for index, element in allElements
	{
		
		Loop % %element%CountOfParts ;Connections consist of multiple parts
		{
			;msgbox,% element "`n" %element%part%a_index%x1 "  " %element%part%a_index%y1 "`n"  %element%part%a_index%x2 "  "  %element%part%a_index%y2 "`n" mx "  " my
			if (%element%part%a_index%x1 < mx and %element%part%a_index%y1 < my and %element%part%a_index%x2 > mx and %element%part%a_index%y2 > my)
			{
				
				if (clickHighestPriority < %element%ClickPriority) ;Select the element with highest priority
				{
					clickHighestPriority:=%element%ClickPriority
					
					elementWithHighestPriority:=element
				}
				
				if (%element%ClickPriority<500 and %element%ClickPriority >=490) ;Increase priority if element has low priority. Elements have higher priority...
					%element%ClickPriority++
				if (%element%ClickPriority<200 and %element%ClickPriority >=190) ;... than Connections
					%element%ClickPriority++
				
				
				;msgbox,%element%
				
			}
			
			
		}
		
		
		
	}
	if (%elementWithHighestPriority%ClickPriority<=500 and %elementWithHighestPriority%ClickPriority >=490) ;reduce the priority of selected element
		%elementWithHighestPriority%ClickPriority:=490
	if (%elementWithHighestPriority%ClickPriority<=200 and %elementWithHighestPriority%ClickPriority >=190)
		%elementWithHighestPriority%ClickPriority:=190
	;msgbox,%elementWithHighestPriority% : clickHighestPriority
}


;msgbox,% %elementWithHighestPriority%y
clickMoved:=false ;Whether user moved an element
nothingChanged=false ;Whether user changed something
howMuchMoved=0 ;Helpful to detect whether user wanted to move or whether he accidently moved a bit with the mouse


if elementWithHighestPriority= ;If nothing was selected (click on nowhere). -> Scroll
{
	

	firstposx:=offsetx ;Store the first offset position
	firstposy:=offsety
	Loop ;scroll with mouse
	{
		
		GetKeyState,LbuttonKeyState,lbutton,p
		if (LbuttonKeyState!="d")
		{
			ui_UpdateStatusbartext("pos")
			ui_draw()
			break
		}
		
		MouseGetPos,newmx1,newmy1 ;Get mouse position and calculate
		newmx:=newmx1
		newmy:=newmy1
		newposx:=(firstposx-(newmx-mx)/zoomFactor)
		newposy:=(firstposy-(newmy-my)/zoomFactor)
		if (newposx!=oldposx OR newposy!=oldposy) ;If mouse is moving currently
		{
			
			oldposx:=newposx
			oldposy:=newposy
			Offsetx:=newposx
			Offsety:=newposy
			howMuchMoved++
			if howMuchMoved>2
				clickMoved:=true
			ui_UpdateStatusbartext("pos")
			ui_draw()
			
		}
		else
			sleep,10 ;Save processor work
		
	}
	if (clickMoved=false) ;If the background wasn't moved, unmark elements
	{
		if (countMarkedElements) ;if at least one element is marked
		{
			
			if (ControlKeyState!="d")
			{
				markElement("")
				ui_draw()
			}
			
			
		}
		
		
	}
}
else if (elementWithHighestPriority="MenuCreateNewAction" or elementWithHighestPriority="MenuCreateNewCondition") ;User click either on "Create new action" or ".. condtion" in the drawn menu
{
	if (elementWithHighestPriority="MenuCreateNewAction")
		tempNewID:=e_NewAction()
	else
		tempNewID:=e_NewCondition()
	
	markElement(tempNewID)
	elementWithHighestPriority:=tempNewID
	%tempNewID%x:=(mx)/zoomfactor+offsetx - ElementWidth/2
	%tempNewID%y:=(my)/zoomfactor+offsety  - ElementHeight/2
		
	if (detectMovement()) ;If user moves the mouse
	{
		
		moveSelectedElements()
		
	}
	else
	{
		moveSelectedElements("InvertLbutton")
		
	}
	if (MovementAborted)
	{
		e_removeElement(tempNewID)
		ui_draw()
	}
	else
	{
		saved=no
		ui_draw()
		ui_settingsOfElement(elementWithHighestPriority) ;open settings of element
	}
	
	
	return
}
else if (elementWithHighestPriority="PlusButton") ;user click on plus button
{
	abortAddingElement:=false
	
	
	if (%TheOnlyOneMarkedElement%type="Connection") ;The selected element is connection
	{
		tempElement1:=%TheOnlyOneMarkedElement%from
		tempElement3:=%TheOnlyOneMarkedElement%to
		tempConnection1:=TheOnlyOneMarkedElement
		tempConnection2:=e_NewConnection("MOUSE" , %TheOnlyOneMarkedElement%to) ;Create new connection
		
		%tempConnection1%to:="MOUSE"
		
		
		
		if (detectMovement()) ;If user moves the mouse
		{
			;Wait until user releases the mouse and add an element there
			;The connections follow the mouse
			Loop
			{
				if (detectMovementWithoutBlocking())
					ui_draw()
				if (!getkeystate("lbutton","P") )
				{
					
					break
				}
				if ( getkeystate("rbutton","P") or getkeystate("esc","P"))
				{
					abortAddingElement:=true
					break
				}
				sleep 1
			}
		}
		else ;User has not moved the mouse after clicking
		{
			;Wait until the user clicks on a place to add the element
			Loop
			{
				if (detectMovementWithoutBlocking())
					ui_draw()
				if (GetKeyState("lbutton","P"))
					break
				if (GetKeyState("rbutton","P") or GetKeyState("esc","P"))
				{
					abortAddingElement:=true
					break
				}

				sleep 1

			}
			
		}
		if (!abortAddingElement) 
		{
			MouseGetPos,mx2,my2 ;Get the mouse position
			mx3:=mx2 ;calculate the mouse position relative to the picture
			my3:=my2
			
			;Search an element beneath the mouse.
			clickHighestPriority=0 ;The highest priority decides whitch element will be selected.
			for index, element in allElements
			{
				if (%element%type="action" or %element%type = "condition" or %element%type = "trigger")
				{
					Loop % %element%CountOfParts ;Connections consist of multiple parts
					{
						
						;msgbox,% element "`n" %element%part%a_index%x1 "  " %element%part%a_index%y1 "`n"  %element%part%a_index%x2 "  "  %element%part%a_index%y2 "`n" mx "  " my
						if (%element%part%a_index%x1 < mx3 and %element%part%a_index%y1 < my3 and %element%part%a_index%x2 > mx3 and %element%part%a_index%y2 > my3)
						{
							
							if (clickHighestPriority < %element%ClickPriority) ;Select the element with highest priority
							{
								clickHighestPriority:=%element%ClickPriority
								
								elementWithHighestPriority:=element
							}
							
							;msgbox,%element%
						}
					}
				}
			}
			if (clickHighestPriority=0) ;If user pulled the end of the connection to empty space. Create new element
			{
				returnedElementType:=ui_selectContainerType()
				if (returnedElementType="aborted") ;If user did not select the container type
				{
					
					%tempConnection1%to:=tempElement3
					e_removeElement(tempConnection2)
					
					ui_draw()
					return
				}
				
				tempElement2:=e_New%returnedElementType%()
				%tempElement2%x:=(mx3)/zoomfactor+offsetx - ElementWidth/2
				%tempElement2%y:=(my3)/zoomfactor+offsety  - ElementHeight/2
				%tempElement2%x:=ui_FitGridX(%tempElement2%x)
				%tempElement2%y:=ui_FitGridY(%tempElement2%y)
				
				
				%tempConnection1%to:=tempElement2
				%tempConnection2%from:=tempElement2
				if (%tempElement2%Type="Condition")
				{
					tempReturn:=ui_settingsOfElement(tempConnection2)
				}
				
				
				
				if tempReturn=aborted ;If User did not select the connection type
				{
					
					
					%tempConnection1%to:=%tempConnection2%to
					e_removeElement(tempConnection2)
					e_removeElement(tempElement2)
					
					ui_draw()
				}
				else
				{
					saved=no
					markElement(tempElement2)
					elementWithHighestPriority:=tempElement2
					ui_settingsOfElement(TheOnlyOneMarkedElement) ;open settings of element
				}
			}
			else ;If user pulled the end of the connection to an existing element
			{
				tempElement2:=elementWithHighestPriority
				
				%tempConnection2%from:=tempElement2
				%tempConnection1%to:=tempElement2
				
				thisConnectionPossible:=true ;Check whether Connection is possible
				
				
				if %tempElement2%Type=Trigger
				{
					Msgbox,% lang("You_cannot_connect_to_trigger!")
					thisConnectionPossible:=false
				}
				if (tempElement2=tempElement1 OR tempElement2=tempElement3)
				{
					Msgbox,% lang("The_Connection_cannot_start_and_end_on_the_same_element!")
					thisConnectionPossible:=false
				}
				if (thisConnectionPossible=true)
				{
					
					if (%tempElement2%Type="Condition")
					{
						
						tempReturn:=ui_settingsOfElement(tempConnection2)
						if tempReturn=aborted
							thisConnectionPossible:=false
					}
					
					/* Not necessary
					if (thisConnectionPossible=true)
					{
						for index, element in allElements
						{
							if (element=tempConnection1 or element=tempConnection2)
								continue
							if (%element%Type="Connection")
							{
								if (%element%from=tempElement1 and %element%to=tempElement2 )
								{
									if (%element%ConnectionType=%tempConnection1%ConnectionType)
									{
										
										msgbox,% lang("This_Connection_Already_Exists!")
										thisConnectionPossible:=false
										break
									}
									
								}
								if (%element%from=tempElement2 and %element%to=tempElement3 )
								{
									if (%element%ConnectionType=%tempConnection2%ConnectionType)
									{
										
										msgbox,% lang("This_Connection_Already_Exists!")
										thisConnectionPossible:=false
										break
									}
									
								}
							}
							
						}
					}
					*/
					
				}
				if (thisConnectionPossible=true)
				{
					
					markElement(tempConnection2)
					saved=no
					
				}
				else
				{
					
					%tempConnection1%to:=tempElement3
					e_removeElement(tempConnection2)
					
				}
				
				
				
			}
			
			
			
		}
		else ;User aborted adding a new element
		{
			
			%tempConnection1%to:=tempElement3
			
			e_removeElement(tempConnection2)
			
		}
		
		
		
		

	}
	else ;The selected element is either action, condition or trigger
	{
		tempConnection1:=e_NewConnection(TheOnlyOneMarkedElement,"MOUSE")
		tempElement1:=TheOnlyOneMarkedElement
		
		if (detectMovement()) ;If user moves the mouse
		{
			;Wait until user releases the mouse and add an element there
			Loop
			{
				if (detectMovementWithoutBlocking())
					ui_draw()
				if (!getkeystate("lbutton","P") )
				{
					
					break
				}
				if ( getkeystate("rbutton","P") or getkeystate("esc","P"))
				{
					abortAddingElement:=true
					break
				}
				sleep 1
			}
		}
		else ;User has not moved the mouse after clicking
		{
			;Wait until the user clicks on a place to add the element
			Loop
			{
				if (detectMovementWithoutBlocking())
					ui_draw()
				if (GetKeyState("lbutton","P"))
					break
				if (GetKeyState("rbutton","P") or GetKeyState("esc","P"))
				{
					abortAddingElement:=true
					break
				}

				sleep 1

			}
			
		}
		if (!abortAddingElement) 
		{
			MouseGetPos,mx2,my2 ;Get the mouse position
			mx3:=mx2 ;calculate the mouse position relative to the picture
			my3:=my2
			
			;Search an element beneath the mouse.
			clickHighestPriority=0 ;The highest priority decides whitch element will be selected.
			for index, element in allElements
			{
				if (%element%type="action" or %element%type = "condition" or %element%type = "trigger")
				{
					Loop % %element%CountOfParts ;Connections consist of multiple parts
					{
						
						;msgbox,% element "`n" %element%part%a_index%x1 "  " %element%part%a_index%y1 "`n"  %element%part%a_index%x2 "  "  %element%part%a_index%y2 "`n" mx "  " my
						if (%element%part%a_index%x1 < mx3 and %element%part%a_index%y1 < my3 and %element%part%a_index%x2 > mx3 and %element%part%a_index%y2 > my3)
						{
							
							if (clickHighestPriority < %element%ClickPriority) ;Select the element with highest priority
							{
								clickHighestPriority:=%element%ClickPriority
								
								elementWithHighestPriority:=element
							}
							
							;msgbox,%element%
						}
					}
				}
			}
			if (clickHighestPriority=0) ;If user pulled the end of the connection to empty space. Create new element
			{
				returnedElementType:=ui_selectContainerType()
				if (returnedElementType="aborted") ;If user did not select the container type
				{
					
					e_removeElement(tempConnection1)
					
					ui_draw()
					return
				}
				
				tempElement2:=e_New%returnedElementType%()
				%tempElement2%x:=(mx3)/zoomfactor+offsetx - ElementWidth/2
				%tempElement2%y:=(my3)/zoomfactor+offsety  - ElementHeight/2
				%tempElement2%x:=ui_FitGridX(%tempElement2%x)
				%tempElement2%y:=ui_FitGridY(%tempElement2%y)
				
				
				
				
				%tempConnection1%to:=tempElement2
				if (%tempElement1%Type="Condition")
				{
					tempReturn:=ui_settingsOfElement(tempConnection1)
				}
				
				
				
				if tempReturn=aborted ;If User did not select the connection type
				{
					
					e_removeElement(tempConnection1)
					e_removeElement(tempElement2)
					
					ui_draw()
				}
				else
				{
					saved=no
					markElement(tempElement2)
					elementWithHighestPriority:=tempElement2
					ui_settingsOfElement(TheOnlyOneMarkedElement) ;open settings of element
				}
			}
			else ;If user pulled the end of the connection to an existing element
			{
				tempElement2:=elementWithHighestPriority
				
				thisConnectionPossible:=true ;Check whether Connection is possible
				
				
				
				if %tempElement2%Type=Trigger
				{
					Msgbox,% lang("You_cannot_connect_to_trigger!")
					thisConnectionPossible:=false
				}
				if (tempElement2=tempElement1)
				{
					Msgbox,% lang("The_Connection_cannot_start_and_end_on_the_same_element!")
					thisConnectionPossible:=false
				}
				if (thisConnectionPossible=true)
				{
					
					if (%tempElement1%Type="Condition")
					{
						
						tempReturn:=ui_settingsOfElement(tempConnection1)
						if tempReturn=aborted
							thisConnectionPossible:=false
					}
					
					if (thisConnectionPossible=true)
					{
						for index, element in allElements
						{
							
							if (%element%Type="Connection")
							{
								if (%element%from=tempElement1 and %element%to=tempElement2 )
								{
									if (%element%ConnectionType=%tempConnection1%ConnectionType)
									{
										
										msgbox,% lang("This_Connection_Already_Exists!")
										thisConnectionPossible:=false
										break
									}
									
								}
							}
						}
					}
					
				}
				if (thisConnectionPossible=true)
				{
					markElement(tempConnection1)
					%tempConnection1%to:=elementWithHighestPriority
					saved=no
				}
				else
				{
					e_removeElement(tempConnection1)
					
				}
					
					
			}
			
		}
		else ;User aborted adding a new element
		{
			
			e_removeElement(tempConnection1)
			
		}
		
		
		
		
		
	}
	
	
	
	
	
	ui_draw()
	;ui_settingsOfElement(elementWithHighestPriority) ;open settings of element
	return
}
else if (elementWithHighestPriority="MoveButton1")
{
	abortAddingElement:=false
	
	tempConnection1:=TheOnlyOneMarkedElement
	tempElement2:=%TheOnlyOneMarkedElement%to
	
	tempOldConnection1from:=%tempConnection1%from
	%tempConnection1%from:="MOUSE"
	
	
	if (detectMovement()) ;If user moves the mouse
	{
		;Wait until user releases the mouse and add an element there
		Loop
		{
			if (detectMovementWithoutBlocking())
				ui_draw()
			if (!getkeystate("lbutton","P") )
			{
				
				break
			}
			if ( getkeystate("rbutton","P") or getkeystate("esc","P"))
			{
				abortAddingElement:=true
				break
			}
			sleep 1
		}
	}
	else ;User has not moved the mouse after clicking
	{
		;Wait until the user clicks on a place to add the element
		Loop
		{
			if (detectMovementWithoutBlocking())
				ui_draw()
			if (GetKeyState("lbutton","P"))
				break
			if (GetKeyState("rbutton","P") or GetKeyState("esc","P"))
			{
				abortAddingElement:=true
				break
			}

			sleep 1

		}
		
	}
	if (!abortAddingElement) 
	{
		MouseGetPos,mx2,my2 ;Get the mouse position
		mx3:=mx2 ;calculate the mouse position relative to the picture
		my3:=my2
		
		;Search an element beneath the mouse.
		clickHighestPriority=0 ;The highest priority decides whitch element will be selected.
		for index, element in allElements
		{
			if (%element%type="action" or %element%type = "condition" or %element%type = "trigger")
			{
				Loop % %element%CountOfParts ;Connections consist of multiple parts
				{
					
					;msgbox,% element "`n" %element%part%a_index%x1 "  " %element%part%a_index%y1 "`n"  %element%part%a_index%x2 "  "  %element%part%a_index%y2 "`n" mx "  " my
					if (%element%part%a_index%x1 < mx3 and %element%part%a_index%y1 < my3 and %element%part%a_index%x2 > mx3 and %element%part%a_index%y2 > my3)
					{
						
						if (clickHighestPriority < %element%ClickPriority) ;Select the element with highest priority
						{
							clickHighestPriority:=%element%ClickPriority
							
							elementWithHighestPriority:=element
						}
						
						;msgbox,%element%
					}
				}
			}
		}
		if (clickHighestPriority=0) ;If user pulled the end of the connection to empty space. Create new element
		{
			returnedElementType:=ui_selectContainerType()
			if (returnedElementType="aborted") ;If user did not select the container type
			{
				
				%tempConnection1%from:=tempOldConnection1from
				
				ui_draw()
				return
			}
			
			tempElement1:=e_New%returnedElementType%()
			%tempElement1%x:=(mx3)/zoomfactor+offsetx - ElementWidth/2
			%tempElement1%y:=(my3)/zoomfactor+offsety  - ElementHeight/2
			%tempElement1%x:=ui_FitGridX(%tempElement1%x)
			%tempElement1%y:=ui_FitGridY(%tempElement1%y)
			
			
			%tempConnection1%from:=tempElement1
			
			
			if tempReturn=aborted ;If User did not select the connection type
			{
				
				%tempConnection1%from:=tempOldConnection1from
				e_removeElement(tempElement1)
				
				ui_draw()
			}
			else
			{
				saved=no
				markElement(tempElement1)
				elementWithHighestPriority:=tempElement1
				ui_settingsOfElement(TheOnlyOneMarkedElement) ;open settings of element
			}
		}
		else ;If user pulled the end of the connection to an existing element
		{
			tempElement1:=elementWithHighestPriority
			
			thisConnectionPossible:=true ;Check whether Connection is possible
			
			%tempConnection1%from:=tempElement1
			
			if (tempElement2=tempElement1)
			{
				Msgbox,% lang("The_Connection_cannot_start_and_end_on_the_same_element!")
				thisConnectionPossible:=false
			}
			if (thisConnectionPossible=true)
			{
				;If the old element has not the same type as the new element, the connection type must be changed
				if (%tempElement1%Type!=%tempOldConnection1from%type)
				{
					if (%tempElement1%Type="Condition")
					{
						
						tempReturn:=ui_settingsOfElement(tempConnection1)
						if tempReturn=aborted
							thisConnectionPossible:=false
					}
					else
					{
						
						tempReturn:=ui_settingsOfElement(tempConnection1)
						if tempReturn=aborted
							thisConnectionPossible:=false
					}
				}
				
				
				for index, element in allElements
				{
					
					if (element!=tempConnection1 and %element%Type="Connection")
					{
						if (%element%from=tempElement1 and %element%to=tempElement2 )
						{
							if (%element%ConnectionType=%tempConnection1%ConnectionType)
							{
								
								msgbox,% lang("This_Connection_Already_Exists!")
								thisConnectionPossible:=false
								break
							}
							
						}
					}
				}
				
				
			}
			if (thisConnectionPossible=true)
			{
				markElement(tempConnection1)
				%tempConnection1%from:=elementWithHighestPriority
				saved=no
			}
			else
			{
				%tempConnection1%from:=tempOldConnection1from
				
			}
				
				
		}
		
	}
	else ;User aborted adding a new element
	{
		
		%tempConnection1%from:=tempOldConnection1from
	}
	
	
	
	ui_draw()

}
else if (elementWithHighestPriority="MoveButton2")
{
	abortAddingElement:=false
	
	tempConnection1:=TheOnlyOneMarkedElement
	tempElement1:=%TheOnlyOneMarkedElement%from
	
	tempOldConnection1to:=%tempConnection1%to
	%tempConnection1%to:="MOUSE"
	
	
	if (detectMovement()) ;If user moves the mouse
	{
		;Wait until user releases the mouse and add an element there
		Loop
		{
			if (detectMovementWithoutBlocking())
				ui_draw()
			if (!getkeystate("lbutton","P") )
			{
				
				break
			}
			if ( getkeystate("rbutton","P") or getkeystate("esc","P"))
			{
				abortAddingElement:=true
				break
			}
			sleep 1
		}
	}
	else ;User has not moved the mouse after clicking
	{
		;Wait until the user clicks on a place to add the element
		Loop
		{
			if (detectMovementWithoutBlocking())
				ui_draw()
			if (GetKeyState("lbutton","P"))
				break
			if (GetKeyState("rbutton","P") or GetKeyState("esc","P"))
			{
				abortAddingElement:=true
				break
			}

			sleep 1

		}
		
	}
	if (!abortAddingElement) 
	{
		MouseGetPos,mx2,my2 ;Get the mouse position
		mx3:=mx2 ;calculate the mouse position relative to the picture
		my3:=my2
		
		;Search an element beneath the mouse.
		clickHighestPriority=0 ;The highest priority decides whitch element will be selected.
		for index, element in allElements
		{
			if (%element%type="action" or %element%type = "condition" or %element%type = "trigger")
			{
				Loop % %element%CountOfParts ;Connections consist of multiple parts
				{
					
					;msgbox,% element "`n" %element%part%a_index%x1 "  " %element%part%a_index%y1 "`n"  %element%part%a_index%x2 "  "  %element%part%a_index%y2 "`n" mx "  " my
					if (%element%part%a_index%x1 < mx3 and %element%part%a_index%y1 < my3 and %element%part%a_index%x2 > mx3 and %element%part%a_index%y2 > my3)
					{
						
						if (clickHighestPriority < %element%ClickPriority) ;Select the element with highest priority
						{
							clickHighestPriority:=%element%ClickPriority
							
							elementWithHighestPriority:=element
						}
						
						;msgbox,%element%
					}
				}
			}
		}
		if (clickHighestPriority=0) ;If user pulled the end of the connection to empty space. Create new element
		{
			returnedElementType:=ui_selectContainerType()
			if (returnedElementType="aborted") ;If user did not select the container type
			{
				
				%tempConnection1%to:=tempOldConnection1to
				
				ui_draw()
				return
			}
			
			tempElement2:=e_New%returnedElementType%()
			%tempElement2%x:=(mx3)/zoomfactor+offsetx - ElementWidth/2
			%tempElement2%y:=(my3)/zoomfactor+offsety  - ElementHeight/2
			%tempElement2%x:=ui_FitGridX(%tempElement2%x)
			%tempElement2%y:=ui_FitGridY(%tempElement2%y)
			
			
			%tempConnection1%to:=tempElement2
			
			
			if tempReturn=aborted ;If User did not select the connection type
			{
				
				%tempConnection1%to:=tempOldConnection1to
				e_removeElement(tempElement2)
				
				ui_draw()
			}
			else
			{
				saved=no
				markElement(tempElement2)
				elementWithHighestPriority:=tempElement2
				ui_settingsOfElement(TheOnlyOneMarkedElement) ;open settings of element
			}
		}
		else ;If user pulled the end of the connection to an existing element
		{
			tempElement2:=elementWithHighestPriority
			
			thisConnectionPossible:=true ;Check whether Connection is possible
			
			
			
			if %tempElement2%Type=Trigger
			{
				Msgbox,% lang("You_cannot_connect_to_trigger!")
				thisConnectionPossible:=false
			}
			if (tempElement2=tempElement1)
			{
				Msgbox,% lang("The_Connection_cannot_start_and_end_on_the_same_element!")
				thisConnectionPossible:=false
			}
			if (thisConnectionPossible=true)
			{
				
				
				for index, element in allElements
				{
					
					if (%element%Type="Connection")
					{
						if (%element%from=tempElement1 and %element%to=tempElement2 )
						{
							if (%element%ConnectionType=%tempConnection1%ConnectionType)
							{
								
								msgbox,% lang("This_Connection_Already_Exists!")
								thisConnectionPossible:=false
								break
							}
							
						}
					}
				}
				
				
			}
			if (thisConnectionPossible=true)
			{
				markElement(tempConnection1)
				%tempConnection1%to:=elementWithHighestPriority
				saved=no
			}
			else
			{
				%tempConnection1%to:=tempOldConnection1to
				
			}
				
				
		}
		
	}
	else ;User aborted adding a new element
	{
		
		%tempConnection1%to:=tempOldConnection1to
	}
	
	
	
	
	

	
	
	ui_draw()
	
	

}
else if (elementWithHighestPriority="TrashButton")
{
	MsgBox, 4, % lang("Delete Object") , % lang("Do you really want to delete the %1% %2%?",lang (%TheOnlyOneMarkedElement%type), %TheOnlyOneMarkedElement%name)
	IfMsgBox yes
		e_removeElement(TheOnlyOneMarkedElement)
	ui_draw()
	saved=no
}
else if (elementWithHighestPriority="EditButton")
{
	elementWithHighestPriority:=TheOnlyOneMarkedElement
	ui_settingsOfElement(elementWithHighestPriority)

}
else if (elementWithHighestPriority) ;if user clicked on an element
{
	
	
	if (clickModus="Normal") ;Normal modus: mark elements 
	{
		
		
		
		if (!detectMovement()) ;If user did not move the mouse
		{	
			
			if (ControlKeyState="d")
			{
				markElement(elementWithHighestPriority,"true") ;mark multiple elements
				
			}
			else
				markElement(elementWithHighestPriority) ;mark one element and unmark others
			ui_draw() 
		}
		else ;If user moves the mouse
		{
			if (%elementWithHighestPriority%marked="true")
				moveSelectedElements()
			else if ((ControlKeyState!="d")) ;if no elements are marked, select an move it
			{
				markElement(elementWithHighestPriority) 
				moveSelectedElements()
			}
			saved=no
		}
		
		
	}
	
	
	
	if (clickMoved=false) ;if nothing was moved
	{
		
		if clickModus=connect1 ;If user is about to select where a new Connection should start
		{
			toConnectFrom:=elementWithHighestPriority
			markElement(elementWithHighestPriority)
			clickModus=connect2
			OnTopLabel:=lang("Creating_Connection") "...`n" lang("Select_second_element")
		}
		else if clickModus=connect2 ;If user is about to select where a new Connection should end
		{
			OnTopLabel=
			toConnectTo:=elementWithHighestPriority
			
			
			thisConnectionPossible=true ;Check whether Connection is possible
			
			if %toConnectTo%Type=Trigger
			{
				Msgbox,% lang("You_cannot_connect_to_trigger!")
				thisConnectionPossible=false
			}
			if (toConnectTo=toConnectFrom)
			{
				Msgbox,% lang("The_Connection_cannot_start_and_end_on_the_same_element!")
				thisConnectionPossible=false
			}
			if thisConnectionPossible=true
			{
				ConnectionType=Normal
				if (%toConnectFrom%Type="Condition")
				{
					
					ConnectionType:=ui_selectConnectionType("")
				}
				
				
				for index, element in allElements
				{
					
					if (%element%Type="Connection")
					{
						if (%element%from=toConnectFrom and %element%to=toConnectTo )
						{
							if (%element%ConnectionType=ConnectionType)
							{
								
								msgbox,% lang("This_Connection_Already_Exists!")
								thisConnectionPossible=false
							}
							
						}
					}
				}
				
				
			}
			if thisConnectionPossible=true ;if possible create new Connection
			{
				
				e_newConnection(toConnectFrom,toConnectTo,ConnectionType)
				
			}
			clickModus=normal
			
			ui_draw()
			
			
		}
		
		
	}



}






return

moveSelectedElements(option="")
{
	global
	MovementAborted:=false
	oldposx:=%elementWithHighestPriority%x ;Store the olt position of the element
	firstposx:=%elementWithHighestPriority%x
	oldposy:=%elementWithHighestPriority%y
	firstposy:=%elementWithHighestPriority%y
	
	
	clickMoved:=false
	for index, markedElement in markedElements  ;Preparing to move
	{
		%markedElement%oldx:=%markedElement%x
		%markedElement%oldy:=%markedElement%y
		
	}
	Loop ;Move element(s)
	{
		
		GetKeyState,k,lbutton,p ;When mouse releases, the element(s) will be fittet to the Grid
		if (option!= "InvertLbutton" and k!="d" or option= "InvertLbutton" and k="d")
		{
			if howMuchMoved>0
			{
				;Fit to grid
				for index, element in markedElements
				{
					
					%element%x:=ui_FitGridX(%element%x)
					%element%y:=ui_FitGridY(%element%y)
					
				}
				
				ui_draw()
			}
			
			
			break
			
		}
		if (getkeystate("rbutton","P") or getkeystate("esc","P"))
		{
			%element%x:=firstposx
			%element%y:=firstposy
			MovementAborted:=true
			ui_draw()
			break
		}
		
		MouseGetPos,newmx1,newmy1 ;get mouse position and calculate the new position of the element
		newmx:=newmx1
		newmy:=newmy1
		newposx:=(firstposx+(newmx-mx)/zoomFactor)
		newposy:=(firstposy+(newmy-my)/zoomFactor)
		if (newposx!=oldposx OR newposy!=oldposy) ;If mouse is currently moving
		{
			oldposx:=newposx
			oldposy:=newposy
			for index, element in markedElements
			{
				%element%x:=(%element%oldx+(newmx-mx)/zoomFactor)
				%element%y:=(%element%oldy+(newmy-my)/zoomFactor)
				
			}
			
			howMuchMoved++
			if howMuchMoved>2
				clickMoved:=true
			ui_draw()
		}
		else ;If mouse is not currently moving
		{
			nothingChanged=true
			sleep,10 ;Save processor load
		}
		
		
		
	}
	return clickMoved
}

detectMovement(threshold=2)
{
	
	MouseGetPos,xold,yold ;get mouse position and calculate the new position of the element
	Loop ;Wait until it moves or the mouse button is released
	{
		
		GetKeyState,k,lbutton,p ;When mouse releases, return false
		if (k!="d")
		{
			return false
			
		}
		MouseGetPos,xnew,ynew ;get mouse position and calculate the new position of the element
		
		if (xnew!=xold OR yold!=ynew) ;If mouse is currently moving
		{
			yold:=ynew
			xold:=xnew
			
			howMuchMoved++
			if (howMuchMoved>threshold)
			{
				
				return true
			}
		}
		
		
		sleep,10 ;Save processor load
	}
	return clickMoved
	
}

detectMovementWithoutBlocking(threshold=0)
{
	static yold =0
	static xold =0


	
	
	MouseGetPos,xnew,ynew ;get mouse position and calculate the new position of the element
	
	if (xnew!=xold OR yold!=ynew) ;If mouse is currently moving
	{
		yold:=ynew
		xold:=xnew
		
		howMuchMoved++
		if (howMuchMoved>threshold)
		{
			
			return true
		}
	}
	
	
	sleep,10 ;Save processor load

	return false ;When it did't nome return noMov
	
}

markElement(toMark="",additional="false")
{
	global
	
	if additional=false
	{
		for index, element in markedElements
		{
			%element%marked=false
			
			
		}
		markedElements.remove(markedElements.MinIndex(),markedElements.MaxIndex())
		
		if toMark<>
		{
			%toMark%marked=true
			
		}
		else
		{
			OrderNormalize() 
		}
		
		
	}
	else
	{
		;msgbox,% toMark "`n" %toMark%marked
		markedElements.remove(markedElements.MinIndex(),markedElements.MaxIndex())  ;remove all marked elements
		if toMark<>
		{
			if (%toMark%marked="true")
				%toMark%marked=false
			else
				%toMark%marked=true
			
		}
		
		
	}
	
	countMarkedElements=0
	TheOnlyOneMarkedElement=
	for index, element in allElements ;Add mall marked elements into array
	{
		
		if (%element%marked="true")
		{
			
			markedElements.insert(element)
			
			
			countMarkedElements++
			TheOnlyOneMarkedElement:=element
		}
		;MsgBox,% element "   " %element%marked
		
	}
	if (countMarkedElements!=1)
		TheOnlyOneMarkedElement=
	
	;ToolTip("-" element "-" %element%marked "-" TheOnlyOneMarkedElement "-" countMarkedElements "-")
	
	SortMarkedInForeground()
}


SortMarkedInForeground()
{
	global
	
	tempObject:=Object()
	for index, element in allElements
	{
		if ((%element%Type="Condition" or %element%Type="Action" or %element%Type="Trigger") and %element%marked="false")
			tempObject.insert(element)
		
		
	}
	for index, element in allElements
	{
		if (%element%Type="Connection" and %element%marked="false" )
			tempObject.insert(element)
		
		
	}
	for index, element in markedElements
	{
		tempObject.insert(element)
		
		
	}
	
	
	allElements:=tempObject.clone()
}

OrderNormalize() ;Normale Elemente in den Hintergrund, Connectionslinien in den Vordergrund
{
	tempObject:=Object()
	for index, element in allElements
	{
		if ((%element%Type="Condition" or %element%Type="Action" or %element%Type="Trigger"))
			tempObject.insert(element)
		
		
	}
	for index, element in allElements
	{
		if (%element%Type="Connection")
			tempObject.insert(element)
		
		
	}
	allElements:=tempObject.clone()
}


#IfWinActive ·AutoHotFlow· Editor ;Hotkeys

esc:
return

del: ;delete marked element


for markindex, markelement in markedElements
{
	if markelement=trigger
	{
		MsgBox,% lang("Trigger_cannot be removed!")
		return
	}
	else ;remove all marked elements
	{
		for index, element in allElements
		{
			if (element=markelement)
			{
				;MsgBox,%element%
				
				
				e_removeElement(element)
				saved:="no"
				break
				
			}
		}
	}
	

}

markElement()

ui_draw()
return



;Zoom
ctrl_wheeldown:

MouseGetPos,mx5,my5 ;Get the mouse position

mx5old:=mx5/zoomFactor
my5old:=my5/zoomFactor



zoomFactorOld:=zoomFactor

zoomFactor:=zoomFactor/1.1
if (zoomFactor<zoomFactorMin)
{
	zoomFactor:=zoomFactorMin
}

mx5new:=(mx5 - guipicx)/zoomFactor
my5new:=(my5 - guipicy)/zoomFactor
offsetx:=  offsetx + mx5old - mx5new 
offsety:= offsety + my5old  - my5new
ui_UpdateStatusbartext("pos")
ui_draw()
return
ctrl_wheelup:

MouseGetPos,mx5,my5 ;Get the mouse position

mx5old:=mx5/zoomFactor
my5old:=my5/zoomFactor




zoomFactorOld:=zoomFactor

zoomFactor:=zoomFactor*1.1
if (zoomFactor>zoomFactorMax)
{
	zoomFactor:=zoomFactorMax
}

mx5new:=mx5/zoomFactor
my5new:=my5/zoomFactor



offsetx:=  offsetx + mx5old - mx5new 
offsety:= offsety + my5old  - my5new
ui_UpdateStatusbartext("pos")

ui_draw()
return


ctrl_x:
ToolTip("Control + X pressed")
return

ctrl_c:
ToolTip("Control + C pressed")
i_SaveToClipboard()
return

ctrl_v:
ToolTip("Control + V pressed")
i_loadFromClipboard()
return





jumpoverclickstuff:
temp=