using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;
using Toybox.Communications;
using Toybox.Attention;


class WristTimeHex extends Application.AppBase {
    // App-level variables
    private var mView;
    private var mModel;
    private var mPollingTimer;
    
    // API configuration
    private var mApiUrl = "https://timehex.net/api/flow/current";
    private var mApiPercentagesUrl = "https://timehex.net/api/watch/percentages";
    private var mApiKey = "fill_api_key_here";  // Store securely, consider using app settings

    function initialize() {
        AppBase.initialize();
        mModel = new TimerModel();
        mPollingTimer = new Timer.Timer();
    }

    // onStart() is called when your app is starting
    function onStart(state) {
        // Start polling the API every 120 seconds
        mPollingTimer.start(method(:fetchTimerData), 120000, true);
        
        // Initial data fetch
        fetchTimerData();
    }

    // onStop() is called when your app is exiting
    function onStop(state) {
        mPollingTimer.stop();
    }

    // Return the initial view
    function getInitialView() {
        mView = new WristTimeHexView();
        return [mView, new WristTimeHexDelegate(method(:onRefreshRequested))];
    }
    
    // Manual refresh handler - called when user presses refresh button
    function onRefreshRequested() {
        mView.showLoading(true);
        Attention.vibrate([new Attention.VibeProfile(100, 500)]);
        fetchTimerData();
        fetchPercentageData();
    }
    
        // Fetch timer data from your Nuxt API
        // Fetch timer data from your Nuxt API
    function fetchTimerData() {
        // Prepare the API request
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => mApiKey,
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        
        // Make the API request with callback object
        var callback = new Lang.Method(self, :onTimerDataReceived);
        Communications.makeWebRequest(mApiUrl, null, options, callback);
    }

    function fetchPercentageData() {
        // Prepare the API request
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => mApiKey,
            },
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };
        
        // Make the API request with callback object
        var callback = new Lang.Method(self, :onPercentageDataReceived);
        Communications.makeWebRequest(mApiPercentagesUrl, null, options, callback);
    }

    // Process API response - keep this as a separate method
    function onTimerDataReceived(responseCode, data) {
        
        if (responseCode == 200) {
            // Successful response
            if (data != null) {
                // Update the model with received data
                mModel.updateFromApiResponse(data);
                
                // Update the view
                mView.updateDisplay(mModel);
            } else {
                mView.showError("Empty response");
            }
        } else {
            // Handle error
            mView.showError("Error: " + responseCode);
        }
    }

    function onPercentageDataReceived(responseCode, data) {
        mView.showLoading(false);

        if (responseCode == 200) {
            // Successful response
            if (data != null) {
                // Update the model with received data
                mModel.updatePercentagesFromApiResponse(data);
                
                // Update the view
                mView.updatePercentagesDisplay(mModel);
            } else {
                mView.showError("Empty response");
            }
        } else {
            // Handle error
            mView.showError("Error: " + responseCode);
        }
    }
}


function getApp() as WristTimeHex {
    return Application.getApp() as WristTimeHex;
}

class TimerModel {
    public var isRunning;
    public var taskName;
    public var taskCode;
    public var taskColor;
    public var startTimeStamp;
    public var elapsedSeconds;
    public var lastUpdated;

    public var currentDayOfWeek;
    public var currentDate;
    public var currentPercentage;

    public var firstPercentage;
    public var firstPercentageDate;

    public var secondPercentage;
    public var secondPercentageDate;

    public var thirdPercentage;
    public var thirdPercentageDate;

    public var fourthPercentage;
    public var fourthPercentageDate;

    public var fifthPercentage;
    public var fifthPercentageDate;

    public var sixthPercentage;
    public var sixthPercentageDate;
    
    function initialize() {
        isRunning = false;
        taskName = "--";
        taskCode = "--";
        taskColor = "0xAA7942";
        startTimeStamp = 0;
        elapsedSeconds = 0;
        lastUpdated = System.getTimer();
    }
    
    // Update model from API response
    function updateFromApiResponse(data) {
        isRunning = data.get("is_running");
        taskName = data.get("time_bucket_name");
        taskCode = data.get("code");
        taskColor = data.get("time_bucket_color");
        
        if (isRunning) {
            if (data.hasKey("start_time")) {
                startTimeStamp = data.get("start_time");
            }
            
            if (data.hasKey("duration")) {
                elapsedSeconds = data.get("duration").toNumber();
            }
        } else {
            elapsedSeconds = 0;
        }
        
        lastUpdated = System.getTimer();
    }

    function updatePercentagesFromApiResponse(data) {
        currentDayOfWeek = data[6].get("day");
        currentDate = data[6].get("date");
        currentPercentage = percentageStringToInt(data[6].get("percentage"));

        firstPercentage = percentageStringToInt(data[5].get("percentage"));
        firstPercentageDate = data[5].get("day");

        secondPercentage = percentageStringToInt(data[4].get("percentage"));
        secondPercentageDate = data[4].get("day");

        thirdPercentage = percentageStringToInt(data[3].get("percentage"));
        thirdPercentageDate = data[3].get("day");

        fourthPercentage = percentageStringToInt(data[2].get("percentage"));
        fourthPercentageDate = data[2].get("day");

        fifthPercentage = percentageStringToInt(data[1].get("percentage"));
        fifthPercentageDate = data[1].get("day");

        sixthPercentage = percentageStringToInt(data[0].get("percentage"));
        sixthPercentageDate = data[0].get("day");
    }
    
    // Calculate current elapsed time
    function getCurrentElapsedTime() {
        if (!isRunning) {
            return 0;
        }
        
        // If using server time, return the stored elapsed value
        // You could adjust this based on local time difference since last update
        return elapsedSeconds;
    }
    
    // Format time as HH:MM:SS
    function getFormattedTime() {
        var seconds = getCurrentElapsedTime();
        var hours = (seconds / 3600).toNumber();
        var minutes = ((seconds % 3600) / 60).toNumber();
        var secs = (seconds % 60).toNumber();
        
        return Lang.format("$1$:$2$:$3$", [
            hours.format("%02d"),
            minutes.format("%02d"),
            secs.format("%02d")
        ]);
    }

    function percentageStringToInt(percentStr) {
        // Check if the string is not empty
        if (percentStr.length() > 0) {
            // Get the substring excluding the last character
            var numStr = percentStr.substring(0, percentStr.length() - 1);
            // Convert to integer
            return numStr.toNumber();
        }
        return 0; // Return 0 or some default value for empty strings
    }
}
