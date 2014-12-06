#SingleInstance,Force
new dir({win:1,w:200,h:200,start:"c:\windows\addins"})
Gui,Show
return
GuiEscape:
ExitApp
return
class dir{
	static con:=[]
	__New(info){
		static
		win:=info.win?info.win:1,start:=info.start,pos:=""
		for a,b in ["x","y","w","h"]
			if info[b]
				pos.=b info[b] " "
		Gui,%win%:Add,TreeView,%pos% gtree AltSubmit hwndhwnd
		GuiControl,%win%:+v%hwnd%,%hwnd%
		Gui,%win%:Default
		this.win:=info.win?info.win:1,this.queued:=[],this.dirs:=[],dir.con[hwnd]:=this,this.hwnd:=hwnd
		DriveGet,List,List
		for _,a in StrSplit(list)
			root:=TV_Add(a ":"),this.dirs[":" root]:=a,this.populate(a ":",root)
		this.start(start)
	}
	populate(a,root){
		GuiControl,-Redraw,% this.hwnd
		Loop,%a%\*.*,2
		{
			this.dirs[":" tv:=TV_Add(A_LoopFileName,root)]:=A_LoopFileFullPath
			Loop,%A_LoopFileFullPath%\*.*,2
			{
				this.queued[":" TV_Add("",tv)]:=1
				break
			}
		}
		this.queued.Remove(":" root)
		GuiControl,+Redraw,% this.hwnd
	}
	start(start){
		ss:=0
		sstart:
		for a,b in StrSplit(start,"\"){
			build.=b "\"
			if !FileExist(build)
				break
			while,ss:=TV_GetNext(ss,"F"){
				dd:=this.dirs[":" ss]
				if (SubStr(build,1,StrLen(dd))=dd&&dd)
					lf:={dir:dd,tv:ss}
			}
			this.populate(lf.dir,lf.tv)
		}
		TV_Modify(lf.tv,"Select Expand VisFirst")
	}
	notice(){
		tree:
		this:=dir.con[A_GuiControl]
		if (this.queued[":" tv:=TV_GetChild(A_EventInfo)]&&A_GuiEvent="+")
			TV_Delete(tv),this.populate(this.dirs[":" A_EventInfo],A_EventInfo)
		else if(A_GuiEvent="s"){
			t(this.dirs[":"A_EventInfo])
		}
		return
	}
}
m(x*){
	for a,b in x
		list.=b "`n"
	msgbox %list%
}
t(x*){
	for a,b in x
		list.=b "`n"
	ToolTip,%list%
}