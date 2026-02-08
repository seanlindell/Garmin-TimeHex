import Toybox.Lang;
import Toybox.WatchUi;

class WristTimeHexDelegate extends WatchUi.BehaviorDelegate {
    private var mRefreshCallback;
    
    function initialize(refreshCallback) {
        BehaviorDelegate.initialize();
        mRefreshCallback = refreshCallback;
    }
    
    // Handle physical button or touch events
    function onSelect() {
        // Call refresh when select button is pressed
        mRefreshCallback.invoke();
        return true;
    }
    
    // Menu button handler
    function onMenu() {
        // Show options menu
        WatchUi.pushView(new Rez.Menus.MainMenu(), new WristTimeHexMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}