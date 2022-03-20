/* Based on https://xyne.archlinux.ca/scripts/system/xrandroutputchangewait.c */

#include <stdio.h>
#include <stdlib.h>
#include <X11/Xlib.h>
#include <X11/extensions/Xrandr.h>

int main (int argc, char **argv)
{
	(void)argc; (void)argv;

	int screen = 0;
	int rr_event_base = 0;
	int rr_error_base = 0;
	int rr_mask = RROutputChangeNotifyMask;

	Display* display;
	Window rootwindow;
	XEvent event;

	display = XOpenDisplay(getenv("DISPLAY"));
	if (!display) return EXIT_FAILURE;

	screen = DefaultScreen(display);

	rootwindow = RootWindow(display, screen);
	if (!rootwindow) return EXIT_FAILURE;

	XSelectInput(display, rootwindow, StructureNotifyMask);
	XRRSelectInput(display, rootwindow, rr_mask);
	XRRQueryExtension (display, &rr_event_base, &rr_error_base);

	XNextEvent(display, &event);
	return EXIT_SUCCESS;
}
