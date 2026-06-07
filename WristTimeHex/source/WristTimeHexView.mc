import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Attention;
using Toybox.Time;
using Toybox.Time.Gregorian;

class WristTimeHexView extends WatchUi.View {
    private var mTaskNameText;
    private var mTimerText;
    private var mStatusText;
    private var mCurrentTimeText;
    private var mModel;
    private var mUpdateTimer;
    private var mCurrentTime;
    private var mLastUpdatedText;

    private var mCurrentDayOfWeekText;
    private var mCurrentDateText;
    private var mCurrentPercentageText;

    private var mFirstPercentageText;
    private var mFirstPercentageDateText;

    private var mSecondPercentageText;
    private var mSecondPercentageDateText;

    private var mThirdPercentageText;
    private var mThirdPercentageDateText;

    private var mFourthPercentageText;
    private var mFourthPercentageDateText;

    private var mFifthPercentageText;
    private var mFifthPercentageDateText;

    private var mSixthPercentageText;
    private var mSixthPercentageDateText;


    private var mBatteryPercentageText;
    
    function initialize() {
        View.initialize();
        mUpdateTimer = new Timer.Timer();
    }
    
    // Load resources and set up the view
    function onLayout(dc) {
        // Load layout resources
        setLayout(Rez.Layouts.MainLayout(dc));
        
        // Get references to text fields
        mTaskNameText = View.findDrawableById("TaskName") as WatchUi.Text;
        mTimerText = View.findDrawableById("TimerValue") as WatchUi.Text;
        mStatusText = View.findDrawableById("StatusText") as WatchUi.Text;
        mCurrentTimeText = View.findDrawableById("CurrentTime") as WatchUi.Text;

        mCurrentDayOfWeekText = View.findDrawableById("CurrentDayOfWeek") as WatchUi.Text;
        mCurrentDateText = View.findDrawableById("CurrentDate") as WatchUi.Text;
        mCurrentPercentageText = View.findDrawableById("CurrentPercentage") as WatchUi.Text;


        mFirstPercentageText = View.findDrawableById("FirstPercentage") as WatchUi.Text;
        mFirstPercentageDateText = View.findDrawableById("FirstPercentageDate") as WatchUi.Text;

        mSecondPercentageText = View.findDrawableById("SecondPercentage") as WatchUi.Text;
        mSecondPercentageDateText = View.findDrawableById("SecondPercentageDate") as WatchUi.Text;

        mThirdPercentageText = View.findDrawableById("ThirdPercentage") as WatchUi.Text;
        mThirdPercentageDateText = View.findDrawableById("ThirdPercentageDate") as WatchUi.Text;

        mFourthPercentageText = View.findDrawableById("FourthPercentage") as WatchUi.Text;
        mFourthPercentageDateText = View.findDrawableById("FourthPercentageDate") as WatchUi.Text;

        mFifthPercentageText = View.findDrawableById("FifthPercentage") as WatchUi.Text;
        mFifthPercentageDateText = View.findDrawableById("FifthPercentageDate") as WatchUi.Text;

        mSixthPercentageText = View.findDrawableById("SixthPercentage") as WatchUi.Text;
        mSixthPercentageDateText = View.findDrawableById("SixthPercentageDate") as WatchUi.Text;


        mBatteryPercentageText = View.findDrawableById("BatteryPercentage") as WatchUi.Text;
        
        // Initialize with default values
        mTaskNameText.setText("No Task");
        mTimerText.setText("00:00:00");
        mStatusText.setText("Updated: Just now");
        mCurrentTimeText.setText("00:00:00");

        mCurrentDayOfWeekText.setText("-");
        mCurrentDateText.setText("-");
        mCurrentPercentageText.setText("0%");

        mFirstPercentageText.setText("-");
        mFirstPercentageDateText.setText("-");

        mSecondPercentageText.setText("-");
        mSecondPercentageDateText.setText("-");

        mThirdPercentageText.setText("-");
        mThirdPercentageDateText.setText("-");

        mFourthPercentageText.setText("-");
        mFourthPercentageDateText.setText("-");

        mFifthPercentageText.setText("-");
        mFifthPercentageDateText.setText("-");

        mSixthPercentageText.setText("-");
        mSixthPercentageDateText.setText("-");

        mBatteryPercentageText.setText("-");

        System.println(Rez.Styles.device_info.screenWidth);
    }
    
    // Update the display with the current model data
    function updateDisplay(model) {
        mModel = model;
        
        // Update the UI elements
        mTaskNameText.setText(model.taskName.length() < 12 ? model.taskName : model.taskCode);
        mTimerText.setText(model.getFormattedTime());
        mTaskNameText.setColor(hexToColor(model.taskColor));
        mTimerText.setColor(hexToColor(model.taskColor));
        
        // Show status
        if (model.isRunning) {
            // Start timer update for running timers (update every second)
            mUpdateTimer.start(method(:onSecondTick), 1000, true);
        } else {
            mUpdateTimer.stop();
            mStatusText.setText("No active timer");
        }
        // Request update
        WatchUi.requestUpdate();
    }

    function updatePercentagesDisplay(model) {
        mModel = model;

        mCurrentDayOfWeekText.setText(model.currentDayOfWeek);
        mCurrentDateText.setText(model.currentDate);
        mCurrentPercentageText.setText(model.currentPercentage.toString() + "%");
        mCurrentPercentageText.setColor(getColorFromValue(model.currentPercentage));

        mFirstPercentageText.setText(model.firstPercentage.toString() + "%");
        mFirstPercentageDateText.setText(model.firstPercentageDate + ": ");
        mFirstPercentageText.setColor(getColorFromValue(model.firstPercentage));

        mSecondPercentageText.setText(model.secondPercentage.toString() + "%");
        mSecondPercentageDateText.setText(model.secondPercentageDate + ": ");
        mSecondPercentageText.setColor(getColorFromValue(model.secondPercentage));

        mThirdPercentageText.setText(model.thirdPercentage.toString() + "%");
        mThirdPercentageDateText.setText(model.thirdPercentageDate + ": ");
        mThirdPercentageText.setColor(getColorFromValue(model.thirdPercentage));

        mFourthPercentageText.setText(model.fourthPercentage.toString() + "%");
        mFourthPercentageDateText.setText(model.fourthPercentageDate + ": ");
        mFourthPercentageText.setColor(getColorFromValue(model.fourthPercentage));

        mFifthPercentageText.setText(model.fifthPercentage.toString() + "%");
        mFifthPercentageDateText.setText(model.fifthPercentageDate + ": ");
        mFifthPercentageText.setColor(getColorFromValue(model.fifthPercentage));

        mSixthPercentageText.setText(model.sixthPercentage.toString() + "%");
        mSixthPercentageDateText.setText(model.sixthPercentageDate + ": ");
        mSixthPercentageText.setColor(getColorFromValue(model.sixthPercentage));

        mBatteryPercentageText.setText(getBatteryLevel().toNumber().toString() + "%");
        mBatteryPercentageText.setColor(getColorFromValue(getBatteryLevel().toNumber()));

        WatchUi.requestUpdate();
    }
    
    // Update timer display every second
    function onSecondTick() {
        if (mModel != null && mModel.isRunning) {
            mModel.elapsedSeconds += 1;

            if (mModel.elapsedSeconds % 900 == 0 && mModel.taskCode.equals("INB")) {
                // System.println("Buzz 1");

                Attention.vibrate([new Attention.VibeProfile(100, 500)]);
            }

            mTimerText.setText(mModel.getFormattedTime());

            var now = Time.now();
            var info = Gregorian.info(now, Time.FORMAT_SHORT);
            
            // Convert to 12-hour format
            var hour12 = info.hour;
            var ampm = "AM";
            
            if (hour12 >= 12) {
                ampm = "PM";
                if (hour12 > 12) {
                    hour12 = hour12 - 12;
                }
            }
            
            if (hour12 == 0) {
                hour12 = 12;
            }
            
            // Format time as hh:mm:ss AM/PM
            mCurrentTime = Lang.format("$1$:$2$:$3$ $4$", [
                hour12.format("%d"),  // No leading zero for hour in 12-hour format
                info.min.format("%02d"),
                info.sec.format("%02d"),
                ampm
            ]);

            mLastUpdatedText = Lang.format("$1$:$2$ $3$", [
                hour12.format("%d"),  // No leading zero for hour in 12-hour format
                info.min.format("%02d"),
                ampm
            ]);

            mCurrentTimeText.setText(mCurrentTime);
            // mCurrentTimeText.setColor(getColorFromValue(mModel.elapsedSeconds));

            WatchUi.requestUpdate();
        }
    }
    
    // Show loading indicator
    function showLoading(isLoading) {
        if (isLoading) {
            mStatusText.setText("Updating...");
        } else {
            if (mLastUpdatedText == null) {
                mStatusText.setText("Updated: Just Now"); 
            }
            else {
                mStatusText.setText("Updated: " + mLastUpdatedText); 
            }
        }
        WatchUi.requestUpdate();
    }
    
    // Show error message
    function showError(message) {
        mStatusText.setText(message);
        WatchUi.requestUpdate();
    }
    
    // Called when this View is brought to the foreground
    function onShow() {
        // Refresh data when view becomes visible
    }
    
    // Called when this View is removed from the screen
    function onHide() {
        mUpdateTimer.stop();
    }

    function hexToColor(hexString) {
        // Remove the # if present

        if (hexString == null) {
            return Graphics.COLOR_WHITE;
        }

        // Parse the hex values for red, green, and blue
        var red = hexString.substring(1, 3).toNumberWithBase(16);
        var green = hexString.substring(3, 5).toNumberWithBase(16);
        var blue = hexString.substring(5, 7).toNumberWithBase(16);
        


        // Combine into a 24-bit color value (0xRRGGBB)
        var color = (red << 16) | (green << 8) | blue;

        return color;
    }

    function getBatteryLevel() {
        var stats = System.getSystemStats();
        return stats.battery;  // Returns a percentage value (0-100)
    }

    function getBatteryIconId(batteryLevel) {
        if (batteryLevel > 80) {
            return Rez.Drawables.BatteryFull;
        } else if (batteryLevel > 60) {
            return Rez.Drawables.BatteryHigh;
        } else if (batteryLevel > 40) {
            return Rez.Drawables.BatteryMedium;
        } else if (batteryLevel > 20) {
            return Rez.Drawables.BatteryLow;
        } else {
            return Rez.Drawables.BatteryCritical;
        }
    }

    function getColorFromValue(value) {
        // Clamp the input value to the range 0-100
        var normalizedValue = value;
        if (normalizedValue < 0) {
            normalizedValue = 0; // Clamp to minimum
        } else if (normalizedValue > 100) {
            normalizedValue = 100; // Clamp to maximum
        }
        
        // Define gradient stops (position from 0-100, and corresponding RGB values)
        var stops = [
            { "pos" => 0, "color" => [255, 0, 0] },
            { "pos" => 50, "color" => [255, 127, 0] },
            { "pos" => 70, "color" => [255, 255, 0] },
            { "pos" => 90, "color" => [0, 255, 0] },
            { "pos" => 100, "color" => [0, 255, 255] }
        ];
        
        // Find the two stops we're between
        var lowerStop = stops[0];
        var upperStop = stops[stops.size() - 1];
        
        for (var i = 0; i < stops.size() - 1; i++) {
            if (normalizedValue >= stops[i].get("pos") && normalizedValue <= stops[i+1].get("pos")) {
                lowerStop = stops[i];
                upperStop = stops[i+1];
                break;
            }
        }
        
        // Calculate interpolation factor between the two stops
        var range = upperStop.get("pos") - lowerStop.get("pos");
        var factor = (range > 0) ? (normalizedValue - lowerStop.get("pos")).toFloat() / range.toFloat() : 0;
        
        // Interpolate RGB values
        var r = (upperStop.get("color")[0] - lowerStop.get("color")[0]) * factor + lowerStop.get("color")[0];
        var g = (upperStop.get("color")[1] - lowerStop.get("color")[1]) * factor + lowerStop.get("color")[1];
        var b = (upperStop.get("color")[2] - lowerStop.get("color")[2]) * factor + lowerStop.get("color")[2];
        
        // System.println(r.toNumber() + " " + g.toNumber() + " " + b.toNumber() + "; " + factor + " - " + range + " - " + normalizedValue + " lower: " + lowerStop.get("pos") + " upper: " + upperStop.get("pos"));
        // System.println(normalizedValue - lowerStop.get("pos"));

        // Convert to Garmin color format (0xRRGGBB)
        return Graphics.createColor(255, r.toNumber(), g.toNumber(), b.toNumber());
    }
}
