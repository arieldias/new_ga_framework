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