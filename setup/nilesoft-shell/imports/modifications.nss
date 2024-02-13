// static items
import 'cleanup.nss'

modify(type='recyclebin' where=window.is_desktop and this.id==id.empty_recycle_bin pos=1 sep)
modify(type='back' find=['shortcut', '/new'] vis=vis.remove)
modify(find='unpin' pos=pos.bottom menu="Pin//Unpin")
modify(find='pin' pos=pos.top menu="Pin//Unpin")
modify(where=this.id==id.copy_as_path menu='file manage')
modify(type='dir.back|drive.back' where=this.id==id.customize_this_folder pos=1 sep='top' menu='file manage')
modify(where=this.name=="open in terminal" || this.name=="open linux shell here" || this.id==id.open_powershell_window_here
	pos=pos.bottom menu='Terminal')
modify(find='open with visual studio' pos=1 menu='develop/editors')
//Move and organize
//modify(mode=mode.multiple find='scan with' menu=title.more_options)
modify(mode=mode.multiple
	where=this.id(id.send_to,id.share,id.create_shortcut,id.set_as_desktop_background,id.rotate_left,
					id.rotate_right, id.map_network_drive,id.disconnect_network_drive,id.format, id.eject,
					id.give_access_to,id.include_in_library,id.print)
	pos=1 menu=title.more_options)
