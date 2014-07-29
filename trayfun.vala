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

using Posix;
using AppIndicator;

public class TrayFun {
	public static Indicator indicator = null;
	
	public static void reco(string time) {
		TrayFun.indicator.set_status(IndicatorStatus.ATTENTION);
		string ex = "~/ffmpeg-2.2.4/ffmpeg -f x11grab -s 1920x1080 -r 10 -t " + time + " -i :0.0 -c:v libvpx -b:v 1M -y ~/Desktop/mydesktop.webm";
		Posix.stdout.printf ("Exec:: %s\n", ex);
		try{
			Posix.system(ex);
		}catch(Error e){
			Posix.stdout.printf ("Err:: Could not execute command.\n");
		}
		TrayFun.indicator.set_status(IndicatorStatus.ACTIVE);
	}

	public static int main(string[] args) {
		Gtk.init(ref args);

		var win = new Gtk.Window();
		win.title = "Indicator Test";
		win.resize(200, 200);
		win.destroy.connect(Gtk.main_quit);

		var label = new Gtk.Label("Hello, world!");
		win.add(label);

		TrayFun.indicator = new Indicator(win.title, "face-glasses",
									  IndicatorCategory.APPLICATION_STATUS);

		TrayFun.indicator.set_status(IndicatorStatus.ACTIVE);
		TrayFun.indicator.set_attention_icon("face-laugh");

		var menu = new Gtk.Menu();

		var item = new Gtk.MenuItem.with_label("5 Seconds");
		item.activate.connect(() => {
				TrayFun.reco("5");
		});
		//item.activate.connect(this.reco(5));
		item.show();
		menu.append(item);

		item = new Gtk.MenuItem.with_label("10 Seconds");
		item.show();
		item.activate.connect(() => {
				TrayFun.reco("10");
		});
		//item.activate.connect(TrayFun.reco(10));
		menu.append(item);
		
		item = new Gtk.MenuItem.with_label("Exit");
		item.show();
		item.activate.connect(() => {
				win.destroy();
		});
		//item.activate.connect(TrayFun.reco(10));
		menu.append(item);

		indicator.set_menu(menu);

		//win.show_all();
		win.hide();

		Gtk.main();
		return 0;
	}
}
