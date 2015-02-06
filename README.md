# Welcome To The New Analytics Framework.

## What is Nobelium?
Nobelium is the old Analytics framework rethought. Nobelium is an *Object Oriented* Javascript Framework for creating different types of **trackers** which correspond to different Google Analytics events. What if we leveredged our already existing tritium and javascript to do our tracking? What if we could track using the DOM? 

## Why would you do this?
Currently implementing analytics can take up to 5 days including ecommerce tracking, and no one has any idea what it's doing or how. I wanted to alleviate the stress, mystery and time. We no longer have a giant JSON object to track elements (although you can use that if you want). Instead what we have is a semantic Javascript solution that can use the DOM to track.

## What does a tracker look like?
A Tracker must have 2 things:
  1. A type property so that I can call trackable.type
  2. A getHit function which returns the Google Analytics tracking options object.  

Therefore a simple Trackable Object Looks like this: 
```coffeescript
class TrackableObject 
  constructor: () ->
    @type = "send"
  getHit: () ->
    return {}
```

Because a tracker is just a simple javascript class (seen above in Coffeescript) you can also give it other methods you might like. Such as a "fetchFromSelector()" function. You create it however you want and use it however *you* want as long as you have that base object. In fact, you can create that base object and just extend it however you want!  

Pretty cool right? 

## So I have to write a bunch of Javascript to use this?!!?
##### Of course not!
You just can now! If Alan wants a new type of Google Analtyics tracking tag, you can now support that! The goal is to put as little burden on the developer as possible. I've already created all the basics from Events, PageViews, AjaxPageViews and eCommerce. But this is a completely extensible javascript object. 

## What about leveraging our existing code?!
That's simple: I have some tritium helpers and soon to have some jQuery ones to help with nasty javascript problems. 

## Alright, alright, you sold me, how do I use this? 
Since these objects are completely extensible, I created what I think is the ideal way to implement this. But basically an event driven DOM element looks like this: 

```
insert("button", "Hey Click Me To Check Analytics Stuff!",
  data-track:          "event",
  data-track-action:   "click",
  data-track-category: "Categories Accordion L1 - Body",
  data-track-label:    "js:jQuery(target).text()"
);
```

##### Setting up with Tritium helpers:

```
$(".//button[@class='checkout']") {
  track("Cart Page - Checkout Start", "click", "Checkout Button", "js:$(target).val();")
}
```

##### or more cleanly
```
track$(".//button[@class='checkout']", "Cart Page - Checkout Start", "click", "Checkout Button", "js:$(target).val();")
```

That's literally all you have to do! This means that say in your tritium you have:

```
$(".//special_element") {
  ... important tritium here ... 
}
```

You can instantly start tracking this by changing $ -> track$: 
```
track$(".//special_element", "Special Category", "click")
```

*No more searching through your gigantic JSON file for a specific place to change your code!*  
*No more converting tritium to CSS selectors!*

## The Anaytics Object
After initializing it (`var analytics = new MWAnalytics()`) with all your analytics data:

```
  prefixes = {
    client: "mvc",
    rollup: "mvr"
  };

  accounts = [
    {
      account: "UA-49268500-8",
      config: {
        name: prefixes.client
      }
    }, {
      account: "UA-41624135-11",
      config: {
        name: prefixes.rollup
      }
    }
  ];
```

It only has *one* method you want to worry about: analytics.track. If you need to track an element manually, in javascript, you call it like this:
```
analytics.track(new TrackableData());
```

I have a few helpers for this, such as:
```
TrackableEvent.fetchFromSelector(selector);
```

Would start the event listeners for any thing that matches the selector. 

### What does that really mean? 
A trackable element ajaxes in: You can write *regular* javascript to ensure that ALL trackable elements are being tracked and never have to worry about it. Here is an example w/o jQuery:

```coffeescript
prefixes = 
  client: "mvc"
  rollup: "mvr"
accounts = [
  {
    account: "UA-49268500-8"
    config: 
      name: prefixes.client
  },
  {
    account: "UA-41624135-11"
    config:
      name: prefixes.rollup
  }
]

analytics = new MWAnalytics accounts

window.addEventListener "load", ->
  analytics.track window.TrackableCustomPage.getFromBody()
  analytics.track new window.TrackablePageview 
  window.TrackableEvent.fetchFromSelector '[data-track="event"]', analytics
  document.body.addEventListener "DOMNodeInserted", (e) ->
    if e.target.nodeName != "#text"
      el = e.target 
      if el.dataset.trackAjaxPageview?
        analytics.track new TrackablePageview(analytics, el.dataset.trackAjaxPageview)
      else if el.dataset.track?
        options = {
          action: el.dataset.trackAction,
          label:  el.dataset.trackLabel,
          value:  el.dataset.trackValue,
          "el":   el
        }
        `for (var i in options) {
          if (options[i] === null || options[i] === undefined) {
            delete options[i];
          }
        }`
        new window.TrackableEvent analytics, el.dataset.trackCategory, options
```

### What does that code do? 

  1. It defines the accounts this analytics branch is tracking.  
  2. Then when the document loads we fire off a pageview.  
  3. Then we start tracking all DOM elements which are being event tracked
  4. If any element is being added to the DOM and it is NOT a text element we:
    1. Track an AjaxPageView if necessary
    2. If it is a trackable element, we start to track it. 
  5. BAM Tracking works EVEN FOR AJAX without you needing to write any code at all! 
