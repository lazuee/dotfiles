menu(mode="multiple" title='&Develop' sep=sep.bottom image=\uE26E)
{
	menu(mode="single" title='Editors' image=\uE17A)
	{
		item(title='VSCodium' image cmd='@user.dir\scoop\apps\vscodium\current\VSCodium.exe' args='"@sel.path"')
		separator
		item(type='file' mode="single" title='Notepad++' image cmd='@user.dir\scoop\apps\notepadplusplus\current\notepad++.exe' args='"@sel.path"')
		item(type='file' mode="single" title='Notepad' image cmd='@sys.bin\notepad.exe' args='"@sel.path"')
	}
}