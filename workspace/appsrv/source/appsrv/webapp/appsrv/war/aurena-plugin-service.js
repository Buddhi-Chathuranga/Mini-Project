"use strict";

class IfsMessage {
    constructor(action, data) {
        this.action = action;
        this.data = data;
        //this.target = pluginGUID;
    }
}

IfsMessage.prototype.getMessage = function() {
    var msgObj = {
        "action": this.action,
        "data": this.data,
        "target": this.target
        }
    return JSON.stringify(msgObj);
}

/**
  Create a reference to IfsPluginStub class in onload and access the public api functions as desired.

  ex: (using jquery)

    var pluginStub = null; //in global scope

    $(window).on("load", function() {
        pluginStub = IfsPluginStub;
        pluginStub.onRecordChange = onIfsRecordChanged;
    });

  It is advisable to call setViewPortHeight with an appropriate height to avoid seeing scrollbars in IFS Web client

**/
var IfsPluginStub = (function () {

    var pluginGUID;
    //--------- communication event constants --------------------
    var RECORD_CHANGED_EVENT = "recordChangedEvent",
        VIEWPORT_HEIGHT_EVENT = "viewportHeightEvent",
        MESSAGE_EVENT = "messageEvent",
        PAGE_INFO_EVENT = "pageInfoEvent",
        NAVIGATE_EVENT = "navigateEvent";

    //---------- message event type constants --------------------
    var ERROR_MESSAGE_TYPE = "error",
        WARNING_MESSAGE_TYPE = "warning",
        INFO_MESSAGE_TYPE = "info",
        SUCCESS_MESSAGE_TYPE = "success";

    //---------- navigate event type constants --------------------
    var PAGE_NAVIGATE_TYPE = "page",
        LOBBY_NAVIGATE_TYPE = "lobby";

    // A cross-browser event handler function:
    function addEvent(target, type, callback) {
        if (target == null || typeof (target) == 'undefined') {
            return;
        }
        else if (target.addEventListener) {
            target.addEventListener(type, callback, false);
        }
        else if (target.attachEvent) {
            target.attachEvent("on" + type, callback);
        }
        else {
            target["on" + type] = callback;
        }
    }

    function getQueryStringParams(){
        var params = {};
        if (location.search) {
            var queryString = location.search.substring(1).split("&").forEach(function(item) {
                var kv = item.split("=");
                if (kv.length > 1) {
                    params[kv[0]] = decodeURIComponent(kv[1]);
                }
            });
        }
        return params;
    }

    function initialize() {
        var params = getQueryStringParams();
        pluginGUID = params["id"];

        registerMessageHandler();
    }

    function registerMessageHandler() {
        addEvent(window, "message", messageHandler);
    }

    /**
     * message handler that handles predefine message events sent from IFS Web framework
     */
    function messageHandler(e) {
        var message;
        var action;

        if (typeof event.data === "string") {
            message = JSON.parse(event.data);
            action = message.action;
        }

        switch(action) {
            case RECORD_CHANGED_EVENT:
                api.onRecordChange(message.data);
                break;
            case PAGE_INFO_EVENT:
                api.onPageInfoReceived(message.data);
                break;
            default:
                console.debug("unsupported action: " + action);
        }
    }

    /**
     * Communicate with IFS Web framework using HTML postMessaging service
     */
    function sendMessage(message) {
        parent.postMessage(message, "/");
    }

    /**
     * height - number type
     */
    function updateViewPortHeight(height) {
        var msg = new IfsMessage(VIEWPORT_HEIGHT_EVENT, {"height": height});
        sendMessage(msg.getMessage());
    }

    /**
     * messageType - a predefine message event type
     * message - message shown inside message box
     * title - title shown on message box
     */
    function sendMessageEvent(messageType, message, title) {
        var msg = new IfsMessage(MESSAGE_EVENT, {"messageType": messageType, "message": message, "title": title});
        sendMessage(msg.getMessage());
    }

    function getPageInfo() {
        var msg = new IfsMessage(PAGE_INFO_EVENT, {});
        sendMessage(msg.getMessage());
    }

    function navigateTo(navigationObject) {
        var msg = new IfsMessage(NAVIGATE_EVENT, navigationObject);
        sendMessage(msg.getMessage());
    }

    initialize();
    //--------------------- public API methods ------------------------
    var api = {
        setViewPortHeight: updateViewPortHeight,
        successMessage: function(message, title) {
            sendMessageEvent(SUCCESS_MESSAGE_TYPE, message, title);
        },
        warningMessage: function(message, title) {
            sendMessageEvent(WARNING_MESSAGE_TYPE, message, title);
        },
        infoMessage: function(message, title) {
            sendMessageEvent(INFO_MESSAGE_TYPE, message, title);
        },
        errorMessage: function(message, title) {
            sendMessageEvent(ERROR_MESSAGE_TYPE, message, title);
        },
        onRecordChange: function(rec) {
            /**The plugin stub should declare a function and assign it this property if the current record needs to be used by the plugin
               ex: pluginStub.onRecordChange = onIfsRecordChanged;

               structure of the record object is as returned by odata service
             **/

        },
        getPageInfo: getPageInfo,
        onPageInfoReceived: function(meta) {
            /** The plugin stub should declare a function and assign it this property if the page metadata needs to be used by the plugin
                ex: pluginStub.onPageInfoReceived = onIfsPageInfoReceived;

                structure of the metadate object is
                {
                    client: .client file name
                    page: current page name
                    category: projection category
                    metadata: metadata generated by developer studio
                }
             **/
        },
        navigateToPage: function(projection, page, filter) {
            navigateTo({"navigateType": PAGE_NAVIGATE_TYPE, "projection": projection, "page": page, "filter": filter});
        },
        navigateToLobby: function(lobbyId) {
            navigateTo({"navigateType": LOBBY_NAVIGATE_TYPE, "id": lobbyId});
        }
    };

    return api;
})();
