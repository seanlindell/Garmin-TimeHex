import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class WristTimeHexMenuDelegate extends WatchUi.MenuInputDelegate {
    function initialize() {
        MenuInputDelegate.initialize();
    }
    
    function onMenuItem(item) {
        if (item == :refresh) {
            // Handle refresh menu item
            Application.getApp().onRefreshRequested();
        }
    }
}