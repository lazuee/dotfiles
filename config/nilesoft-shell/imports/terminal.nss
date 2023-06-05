menu(type='*' where=(sel.count or wnd.is_taskbar or wnd.is_edit) title=title.terminal sep='top' image=icon.run_with_powershell)
{
	$tip_run_admin=["\xE1A7 Press SHIFT key to run " + this.title + " as administrator", tip.warning, 1.0]
	
	item(title=title.command_prompt tip=tip_run_admin admin=key.shift() or key.rbutton() image cmd='cmd.exe' args='/K TITLE Command Prompt &ver& PUSHD "@sel.dir"')
	item(title=title.windows_powershell tip=tip_run_admin admin=key.shift() or key.rbutton() image cmd='@user.dir\scoop\apps\pwsh-beta\current\pwsh.exe' args='-noexit -command Set-Location -Path "@sel.dir\."')
	item(where=sys.ver.major >= 10 title=title.Windows_Terminal tip=tip_run_admin admin=key.shift() or key.rbutton() image cmd='@user.dir\scoop\apps\windows-terminal-preview\current\wt.exe' arg='-d "@sel.path\."')
}