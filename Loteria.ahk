#NoEnv
#MaxThreads 99000000
#MaxThreadsPerHotkey 255
#KeyHistory 0
#Persistent
#SingleInstance, Force
ListLines, Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetTitleMatchMode 2
DetectHiddenWindows, On
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SetWorkingDir %A_ScriptDir%


URL := "http://loterias.caixa.gov.br/wps/portal/loterias/landing/lotofacil/!ut/p/a1/04_Sj9CPykssy0xPLMnMz0vMAfGjzOLNDH0MPAzcDbz8vTxNDRy9_Y2NQ13CDA0sTIEKIoEKnN0dPUzMfQwMDEwsjAw8XZw8XMwtfQ0MPM2I02-AAzgaENIfrh-FqsQ9wBmoxN_FydLAGAgNTKEK8DkRrACPGwpyQyMMMj0VAcySpRM!/dl5/d5/L2dBISEvZ0FBIS9nQSEh/pw/Z7_61L0H0G0J0VSC0AC4GLFAD2003/res/id=buscaResultado/c=cacheLevelPage/=/?timestampAjax="
Cursor := "https://github.com/gvieiraaa/Loto/blob/master/Yellow.cur?raw=true"
Results := {}
Tickets := {}

if !InStr(FileExist(A_ScriptDir "\resultados"), "D")
	FileCreateDir % A_ScriptDir "\resultados"
if !InStr(FileExist(A_ScriptDir "\Yellow.cur"), "A")
	UrlDownloadToFile, % Cursor, % "Yellow.cur"

CursorPath := A_ScriptDir "\Yellow.cur"
CUstomCursor := DllCall("LoadImageW", "Uint", 0, "Ptr", &CursorPath, "Uint", 0x2, "int", 0, "int", 0, "Uint", 0x10)

max := 0
Loop, Files, % A_ScriptDir "\resultados\*.json"
{
	n := StrReplace(A_LoopFileName,".json")
	Results[n] := new Result(n,true)
	if (n > max)
		max := n
}

Loop, 9 {
	IniRead, JogoIni, Jogo.ini, Jogos, % "Jogo" A_Index 
	if (JogoIni != "false" AND JogoIni != "ERROR") {
		Tickets[A_Index] := new Ticket(JogoIni)
		LastTicket := A_Index
		LastTicketNumbers := Tickets[A_Index].GetNumbers
	}
}

Gui, 1:New, +Resize -MaximizeBox +MinSize1000x600 +MaxSize1920x1080 +HwndMyGui
Gui, 1:Font, cWhite
Gui, 1:Color, 0x090909
Gui, 1:Add, GroupBox, x0 y0 w600 h250  +HwndCursorFix
Gui, 1:Add, GroupBox, x600 y0 w1320 h250  +HwndCursorFix
Gui, 1:Add, GroupBox, x0 y250 w600 h830  +HwndCursorFix
Gui, 1:Add, GroupBox, x600 y250 w1320 h950  +HwndCursorFix
Gui, 1:Font, s80
Gui, 1:Add, Text, center x1 y54 w270 h190 , Jogo
Gui, 1:Font, s50
Gui, 1:Add, Button, x312 y9 w50 h230 gJogoMenos , <
Gui, 1:Add, Button, x512 y9 w50 h230 gJogoMais , >
Gui, 1:Font, s110
Gui, 1:Add, Edit, cBlack center x362 y59 w150 h180 vJogo gJogo +HwndCursorFix, % (LastTicket) ? LastTicket : 1
Gui, 1:Font, s30
Gui, 1:Add, Button, x361 y9 w152 h50 gEditar, Editar
Gui, 1:Font, s10
;final grupo 1

Gui, 1:Font, s80
Gui, 1:Add, Text, x622 y54 w490 h190 , Concurso
Gui, 1:Add, Button, x1122 y9 w80 h230 gConcursoMenos +HwndCursorFix, <
Gui, 1:Add, Button, x1572 y9 w80 h230 gConcursoMais +HwndCursorFix , >
Gui, 1:Font, s30
Gui, 1:Add, Text, center x1202 y9 w370 h190, Número
Gui, 1:Font, s110
Gui, 1:Add, Edit, Number cBlack center x1202 y59 w370 h180  +HwndCursorFix +hwndHandle vConcurso gConcurso, % max
Gui, 1:Font, s40
Gui, 1:Add, Button, x1672 y9 w240 h230 gBaixar vBaixar, Baixar
;final grupo 2
Gui, 1:Font, s55

GuiCounter := 0
Loop, 3 {
	GuiRow := A_Index
	Loop, 5 {
		GuiCounter++
		Gui, 1:Add, Text, % "x" -108 + 120*A_Index " y" 170 + 90 * GuiRow " vJ" . GuiCounter " w90 h80", % LastTicketNumbers[GuiCounter]
	}
}

Gui, 1:Add, Button, x12 y522 w575 h140 gConferir, Conferir
Gui, 1:Font, s22 cFCE9E9
Gui, 1:Add, Text, center x12 y679 w560 h190 , Premiação
Gui, 1:Font, s45 cYellow
Gui, 1:Add, Text, center x12 y730 w560 h600 vEditAcertos , % ""
Gui, 1:Font, s50 c6F63FE
Gui, 1:Add, Text, center x12 y830 w560 h600 vEditPremio , % ""
;final grupo 3
Gui, 1:Font, s70
Gui, 1:Add, Text, center x622 y260 w580 h130 vResultTxt , % ""
Gui, 1:Font, s70 cYellow
Gui, 1:Add, Text, x612 y420 w650 h310 vContestResults , % ""
Gui, 1:Font, s19 cWhite
Gui, 1:Add, Text, x1322 y260 w530 h650 vEvenMoreInfo, % ""
Gui, 1:Font, s20
Gui, 1:Add, Text, x612 y750 w580 h280 vMoreInfo, % ""
Gui, 1:Show, x0 y0 h1080 w1920 Maximize, LOTERIA FEDERAL - Lotofácil
Results[max].Show()


DllCall("SetClassLongPtrW", "Uint", CursorFix, "int", -12, "Ptr", CUstomCursor)
DllCall("SetClassLongPtrW", "Uint", MyGui, "int", -12, "Ptr", CUstomCursor)
DllCall("SetClassLongPtrW", "Uint", Handle, "int", -12, "Ptr", CUstomCursor)
Return

1:GuiClose:
ExitApp

ConcursoMenos:
ClearColors()
GuiControlGet, ContestSub,, Concurso
GuiControl,1:, Concurso, % ContestSub - 1
If IsObject(Results[ContestSub - 1]) {
	GuiControl, Disable, Baixar
	Results[ContestSub - 1].Show()
}
Else {
	GuiControl, Enable, Baixar
	Clear()
}
return

ConcursoMais:
ClearColors()
GuiControlGet, ContestAdd,, Concurso
GuiControl,, Concurso, % ContestAdd + 1
If IsObject(Results[ContestAdd + 1]) {
	GuiControl, Disable, Baixar
	Results[ContestAdd + 1].Show()
}
Else {
	GuiControl, Enable, Baixar
	Clear()
}
return

Concurso:
ClearColors()
GuiControlGet, ContestEdit,, Concurso
GuiControl,, Concurso, % ContestEdit
If IsObject(Results[ContestEdit]) {
	GuiControl, Disable, Baixar
	Results[ContestEdit].Show()
}
Else {
	GuiControl, Enable, Baixar
	Clear()
}
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
return

Baixar:
GuiControlGet, ContestGet,, Concurso
If !IsObject(Results[ContestGet])
	Results[ContestGet] := new Result(ContestGet,false,URL)
if !(Results[ContestGet].OK)
	Results.delete(ContestGet)
return

JogoMenos:
ClearColors()
GuiControlGet, JogoSub,, Jogo
GuiControl,, Jogo, % (JogoSub = 1) ? 1 : JogoSub - 1
GuiControlGet, JogoValor,, Jogo
If (Tickets[JogoValor].valid) {
	Tickets[JogoValor].Show()
}
Else
	ClearTicket()
return

JogoMais:
ClearColors()
GuiControlGet, JogoAdd,, Jogo
GuiControl,, Jogo, % (JogoAdd = 9) ? 9 : JogoAdd + 1
GuiControlGet, JogoValor,, Jogo
If (Tickets[JogoValor].valid) {
	Tickets[JogoValor].Show()
}
Else
	ClearTicket()
return

Jogo:
ClearColors()
GuiControlGet, JogoValor,, Jogo
GuiControl,, Jogo, % (JogoValor > 9) ? 9 : (JogoValor < 1) ? 1 : JogoValor
GuiControlGet, JogoValor,, Jogo
If (Tickets[JogoValor].valid) {
	Tickets[JogoValor].Show()
}
Else 
	ClearTicket()
return

Editar:
TotalSelected := 0
Selection := ""
GuiControlGet, JogoValor,, Jogo
LastEdit := JogoValor
IniWrite, % "false", Jogo.ini, Jogos, Jogo%LastEdit%
Tickets[LastEdit] := ""
GuiControlGet, JogoValor,, Jogo
ClearTicket()
Gui, 2:New, +Resize -MaximizeBox +MinSize1000x600 +MaxSize1920x1080
Gui, 2:Font, cWhite
Gui, 2:Color, 0x090909
Gui, 2:Font, s80
Gui, 2:Add, Text, center x100 y10 h200 w1720 vTitleEditTicket, % "Jogo numero " LastEdit
CountClicked := 0
loop 5 {
	row := A_Index
	loop 5 {
		CountClicked := (CountClicked++ < 9) ? ("0" CountClicked++) : CountClicked++
		Gui, 2:Add, Button, % "x" -50 + (A_index * 260) " y" 50 + (row * 120) " w250 h110 gTicketNumber", % CountClicked
	}
}
Gui, 2:Show, x100 y50 h880 w1720, Meus Tickets
return

TicketNumber:
TotalSelected++
GuiControl, 2:Disable, % A_GuiControl
Selection .= (TotalSelected = 15) ? A_GuiControl : (A_GuiControl "-")
if (TotalSelected = 15) {
	Gui, 2:Destroy
	Sleep 100
	Tickets[LastEdit] := new Ticket(Selection)
	Sort, Selection, D-
	IniWrite, % Selection, Jogo.ini, Jogos, Jogo%LastEdit%
	ClearColors()
}
return

Conferir:
GuiControlGet, JogoValor,, Jogo
GuiControlGet, ConcursoValor,, Concurso
If IsObject(Results[ConcursoValor])
	Tickets[JogoValor].check(Results[ConcursoValor],Results)
return

Class Result {
	__New(ContestNumber,FromDisk := false,URL := "URL") {
		If (FromDisk) {
			this.JsonFromDisk(ContestNumber)
		}
		Else If (this.OK) {
			MsgBox % "Já existe"
		}
		Else {
			this.DownloadJson(ContestNumber, URL)
		}
	}
	JsonFromDisk(ContestNumber) {
		file := FileOpen(A_ScriptDir "\resultados\" ContestNumber ".json","r")
		this.json := file.Read()
		file.Close()
		this.OK := true
		this.Jsonify()
	}
	DownloadJson(ContestNumber, URL) {
		now := A_NowUTC
		EnvSub, now, 1970, seconds
		epoch := now * 1000
		GetResult := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		GetResult.SetTimeouts(0,3000,3000,3000)
		GetResult.Open("GET", URL . epoch . "&concurso=" . ContestNumber, true)
		GetResult.Send("")
		Try GetResult.WaitForResponse()
		Sleep 100
		Try Response := GetResult.ResponseText
		
		If (Response AND InStr(Response,"de_resultado"":null") = 0) {
			this.json := (SubStr(Response,1,1) = "{") ? Response : ("{" Response "}")
			this.Jsonify()
			if this.Validate {
				file := FileOpen(A_ScriptDir "\resultados\" ContestNumber ".json","rw")
				file.write(this.json)
				file.close()
				this.OK := true
				this.Show()
			}
		}
		Else {
			this.__Delete()
		}
	}
	Jsonify() {
		this.JsonObject := Jxon_Load(this.json)
		this.RawResult := this.JsonObject.de_resultado
	}
	Validate {
		Get {
			return !!(this.JsonObject.de_resultado)
		}
	}
	OrderedResult {
		Get {
			local temp := this.RawResult
			Sort temp, D-
			return StrReplace(temp,"-"," ")
		}
	}
	Show() {
		GuiControl,, ResultTxt, % "Resultado"
		GuiControl,, ContestResults, % this.OrderedResult
		
		EvenMoreInfo := "`r`nData do sorteio:`t" this.JsonObject.dt_apuracaoStr
		EvenMoreInfo .= (this.JsonObject.qt_ganhador_faixa1 = 1) ? "`r`n`r`nAcertaram 15:`r`n`t" dotify(this.JsonObject.qt_ganhador_faixa1,".") " Aposta. (R$ " dotify(SubStr(this.JsonObject.vr_rateio_faixa1,1,-3),".") "," SubStr(this.JsonObject.vr_rateio_faixa1,-1,2) " p/ cada)" : "`r`n`r`nAcertaram 15:`r`n`t" dotify(this.JsonObject.qt_ganhador_faixa1,".") " Apostas. (R$ " dotify(SubStr(this.JsonObject.vr_rateio_faixa1,1,-3),".") "," SubStr(this.JsonObject.vr_rateio_faixa1,-1,2) " p/ cada)"
		EvenMoreInfo .= "`r`nAcertaram 14:`r`n`t" dotify(this.JsonObject.qt_ganhador_faixa2,".") " Apostas. (R$ " dotify(SubStr(this.JsonObject.vr_rateio_faixa2,1,-3),".") "," SubStr(this.JsonObject.vr_rateio_faixa2,-1,2) " p/ cada)"
		EvenMoreInfo .= "`r`nAcertaram 13:`r`n`t" dotify(this.JsonObject.qt_ganhador_faixa3,".") " Apostas. (R$ " dotify(SubStr(this.JsonObject.vr_rateio_faixa3,1,-3),".") "," SubStr(this.JsonObject.vr_rateio_faixa3,-1,2) " p/ cada)"
		EvenMoreInfo .= "`r`nAcertaram 12:`r`n`t" dotify(this.JsonObject.qt_ganhador_faixa4,".") " Apostas. (R$ " dotify(SubStr(this.JsonObject.vr_rateio_faixa4,1,-3),".") "," SubStr(this.JsonObject.vr_rateio_faixa4,-1,2) " p/ cada)"
		EvenMoreInfo .= "`r`nAcertaram 11:`r`n`t" dotify(this.JsonObject.qt_ganhador_faixa5,".") " Apostas. (R$ " dotify(SubStr(this.JsonObject.vr_rateio_faixa5,1,-3),".") "," SubStr(this.JsonObject.vr_rateio_faixa5,-1,2) " p/ cada)" 
		
		GuiControl,, EvenMoreInfo, % EvenMoreInfo
		
		MoreInfo := "Valor Acumulado:`tR$ " this.JsonObject.vrAcumuladoFaixa1
		MoreInfo .= "`r`n`r`nEstimativa p/ próximo:`tR$ " this.JsonObject.vrEstimativa
		MoreInfo .= "`r`n`r`nValor arrecadado total:`tR$ " this.JsonObject.vrArrecadado
		MoreInfo .= "`r`n`r`nAcumulado (Especial):`tR$ " this.JsonObject.vrAcumuladoEspecial
		
		GuiControl,, MoreInfo, % MoreInfo
		GuiControl, Disable, Baixar
	}
	Prize(qtd) {
		return % (qtd=15) ? this.JsonObject.vr_rateio_faixa1 : (qtd=14) ? this.JsonObject.vr_rateio_faixa2 : (qtd=13) ? this.JsonObject.vr_rateio_faixa3 : (qtd=12) ? this.JsonObject.vr_rateio_faixa4 : this.JsonObject.vr_rateio_faixa5
	}
	__Delete() {
		this.base := ""
	}
}

Class Ticket {
	__New(nums) {
		local temp := nums
		Sort temp, D-
		this.numbers := StrSplit(temp,"-")
		this.Show()
	}
	Show() {
		for key, val in this.numbers {
			GuiControl,1:, % "J" key, % val
		}
	}
	GetNumbers {
		Get {
			return this.numbers
		}
	}
	valid {
		Get {
			return (this.numbers[1] != "false")
		}
	}
	check(ObjResult,Results) {
		found := 0
		for k, v in this.numbers {
			if InStr(ObjResult.OrderedResult,v) {
				found++
				this.ChangeColor(k,"Green")
			}
			else if (v!="false") {
				this.ChangeColor(k,"Red")
			}
		}
		this.Edit(found,Results)
	}
	ChangeColor(num,color) {
		GuiControl, % "+c" color, % "J" num
		this.Show()
	}
	Edit(found,Results) {
		GuiControlGet, JogoValor,, Jogo
		GuiControlGet, ConcursoValor,, Concurso
		GuiControl,,EditAcertos, % "Acertou " found " números."
		GuiControl,,EditPremio, % (found > 10) ? ("R$ " Results[ConcursoValor].Prize(found)) : "Sem Premiação"
	}
}

ClearColors() {
	Loop, 15 {
		GuiControl, % "+cWhite", % "J" A_Index
		GuiControlGet, CurrentNum,, % "J" A_Index
		GuiControl,, % "J" A_Index, % CurrentNum 
	}
	GuiControl,,EditAcertos, % ""
	GuiControl,,EditPremio, % ""
}

Clear() {
	GuiControl,, ResultTxt, % ""
	GuiControl,, ContestResults, % ""
	GuiControl,, MoreInfo, % ""
	GuiControl,, EvenMoreInfo, % ""
}

ClearTicket() {
	Loop, 15 {
		GuiControl,1:, % "J" A_Index, % ""
	}
}

dotify(string,separator) {
	While (pos := RegExMatch(string, "\d{4}(\s|$)"))
		string := SubStr(string, 1, pos) " " SubStr(string, pos+1)
	return StrReplace(string," ",separator)
}

Jxon_Load(ByRef src, args*)
{
	static q := Chr(34)
	
	key := "", is_key := false
	stack := [ tree := [] ]
	is_arr := { (tree): 1 }
	next := q . "{[01234567890-tfn"
	pos := 0
	while ( (ch := SubStr(src, ++pos, 1)) != "" )
	{
		if InStr(" `t`n`r", ch)
			continue
		if !InStr(next, ch, true)
		{
			ln := ObjLength(StrSplit(SubStr(src, 1, pos), "`n"))
			col := pos - InStr(src, "`n",, -(StrLen(src)-pos+1))
			
			msg := Format("{}: line {} col {} (char {})"
			,   (next == "")      ? ["Extra data", ch := SubStr(src, pos)][1]
			  : (next == "'")     ? "Unterminated string starting at"
			  : (next == "\")     ? "Invalid \escape"
			  : (next == ":")     ? "Expecting ':' delimiter"
			  : (next == q)       ? "Expecting object key enclosed in double quotes"
			  : (next == q . "}") ? "Expecting object key enclosed in double quotes or object closing '}'"
			  : (next == ",}")    ? "Expecting ',' delimiter or object closing '}'"
			  : (next == ",]")    ? "Expecting ',' delimiter or array closing ']'"
			  : [ "Expecting JSON value(string, number, [true, false, null], object or array)"
			    , ch := SubStr(src, pos, (SubStr(src, pos)~="[\]\},\s]|$")-1) ][1]
			, ln, col, pos)
			
			throw Exception(msg, -1, ch)
		}
		
		is_array := is_arr[obj := stack[1]]
		
		if i := InStr("{[", ch)
		{
			val := (proto := args[i]) ? new proto : {}
			is_array? ObjPush(obj, val) : obj[key] := val
			ObjInsertAt(stack, 1, val)
			
			is_arr[val] := !(is_key := ch == "{")
			next := q . (is_key ? "}" : "{[]0123456789-tfn")
		}
		
		else if InStr("}]", ch)
		{
			ObjRemoveAt(stack, 1)
			next := stack[1]==tree ? "" : is_arr[stack[1]] ? ",]" : ",}"
		}
		
		else if InStr(",:", ch)
		{
			is_key := (!is_array && ch == ",")
			next := is_key ? q : q . "{[0123456789-tfn"
		}
		
		else ; string | number | true | false | null
		{
			if (ch == q) ; string
			{
				i := pos
				while i := InStr(src, q,, i+1)
				{
					val := StrReplace(SubStr(src, pos+1, i-pos-1), "\\", "\u005C")
					static end := A_AhkVersion<"2" ? 0 : -1
					if (SubStr(val, end) != "\")
						break
				}
				if !i ? (pos--, next := "'") : 0
					continue
				
				pos := i ; update pos
				
				val := StrReplace(val,    "\/",  "/")
				, val := StrReplace(val, "\" . q,    q)
				, val := StrReplace(val,    "\b", "`b")
				, val := StrReplace(val,    "\f", "`f")
				, val := StrReplace(val,    "\n", "`n")
				, val := StrReplace(val,    "\r", "`r")
				, val := StrReplace(val,    "\t", "`t")
				
				i := 0
				while i := InStr(val, "\",, i+1)
				{
					if (SubStr(val, i+1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0
						continue 2
					
					; \uXXXX - JSON unicode escape sequence
					xxxx := Abs("0x" . SubStr(val, i+2, 4))
					if (A_IsUnicode || xxxx < 0x100)
						val := SubStr(val, 1, i-1) . Chr(xxxx) . SubStr(val, i+6)
				}
				
				if is_key
				{
					key := val, next := ":"
					continue
				}
			}
			
			else ; number | true | false | null
			{
				val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$",, pos)-pos)
				
				; For numerical values, numerify integers and keep floats as is.
				; I'm not yet sure if I should numerify floats in v2.0-a ...
				static number := "number", integer := "integer"
				if val is %number%
				{
					if val is %integer%
						val += 0
				}
				; in v1.1, true,false,A_PtrSize,A_IsUnicode,A_Index,A_EventInfo,
				; SOMETIMES return strings due to certain optimizations. Since it
				; is just 'SOMETIMES', numerify to be consistent w/ v2.0-a
				else if (val == "true" || val == "false")
					val := %value% + 0
				; AHK_H has built-in null, can't do 'val := %value%' where value == "null"
				; as it would raise an exception in AHK_H(overriding built-in var)
				else if (val == "null")
					val := ""
				; any other values are invalid, continue to trigger error
				else if (pos--, next := "#")
					continue
				
				pos += i-1
			}
			
			is_array? ObjPush(obj, val) : obj[key] := val
			next := obj==tree ? "" : is_array ? ",]" : ",}"
		}
	}
	
	return tree[1]
}