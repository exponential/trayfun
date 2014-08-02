/*
 * Original source code can be found here:
 * 	https://wiki.ubuntu.com/DesktopExperienceTeam/ApplicationIndicators#Vala_Example
 * 
 * Purpose:
 * 	Record my desktop, less the audio, in 3 clicks or less.
 * 
 * On Ubuntu 14.04 this compiled with:
 * 	valac --pkg appindicator-0.1 --pkg gtk+-3.0 --pkg posix trayfun.vala
 * 
 */

using GLib;
using Posix;
using AppIndicator;

public class TrayFun {
	public static Indicator indicator = null;
	public static int s_width = 9001;
	public static int s_height = 9001;
	
	public static void reco(string time) {
		int y = 1999;
		int M = 07;
		int d = 14;
		int h = 11;
		int m = 59;
		int s = 59;
		
		var n = new DateTime.now_local();
		
		n.get_ymd(out y,out M,out d);
		h = n.get_hour();
		m = n.get_minute();
		s = n.get_second();
		
		TrayFun.indicator.set_status(IndicatorStatus.ATTENTION);
		string ex = "~/ffmpeg-2.2.4/ffmpeg -f x11grab -s " + TrayFun.s_width.to_string() + "x" + TrayFun.s_height.to_string() + " -r 10 -t " + time + " -i :0.0 -c:v libvpx -r 24 -qscale 0 -b:v 1M -y ~/Desktop/" + y.to_string() + "-" + M.to_string() + "-" + d.to_string() + "." + h.to_string() + ":" + m.to_string() + ":" + s.to_string() + ".webm";
		Posix.stdout.printf ("Exec:: %s\n", ex);
		Posix.system(ex);
		TrayFun.indicator.set_status(IndicatorStatus.ACTIVE);
	}

	public static int main(string[] args) {
		Gtk.init(ref args);
		
		TrayFun.s_width = Gdk.Screen.width();
		TrayFun.s_height = Gdk.Screen.height();

		var win = new Gtk.Window();
		win.title = "Indicator Test";
		win.resize(200, 200);
		win.destroy.connect(Gtk.main_quit);

		var label = new Gtk.Label("Hello, world!");
		win.add(label);

		TrayFun.indicator = new Indicator(win.title, "face-glasses", IndicatorCategory.APPLICATION_STATUS);

		TrayFun.indicator.set_status(IndicatorStatus.ACTIVE);
		TrayFun.indicator.set_attention_icon("face-laugh");

		var menu = new Gtk.Menu();

		var item = new Gtk.MenuItem.with_label("5 Seconds");
		item.activate.connect(() => { TrayFun.reco("5"); });
		item.show();
		menu.append(item);

		item = new Gtk.MenuItem.with_label("10 Seconds");
		item.show();
		item.activate.connect(() => { TrayFun.reco("10"); });
		menu.append(item);
		
		item = new Gtk.MenuItem.with_label("Exit");
		item.show();
		item.activate.connect(() => { win.destroy(); });
		menu.append(item);

		indicator.set_menu(menu);

		win.hide();

		Gtk.main();
		return 0;
	}
}
