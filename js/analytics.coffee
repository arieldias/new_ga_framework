class window.MWAnalytics
  constructor: (accounts) ->
    @accounts = accounts
    # so we need to do a few things here
    # 1) Ensure that all necessary objects are created. 
    
    for account in @accounts
      trackerName = account.config.name
      __mwgaTracker 'create', account.account, 
        name: trackerName
      __mwgaTracker "#{trackerName}.require", 'linker'
      __mwgaTracker "#{trackerName}.require", 'linkid', 'linkid.js'
      if document.head.getAttribute("data-mw-ga-ecomm") != null
        __mwgaTracker "#{trackerName}.require", 'ecommerce.js'
      # console.log account
  track: (tEvent, e) -> 
    hit = tEvent.getHit()
    console.log(hit)

    cmd = tEvent.type

    for account in @accounts
      trackerName = account.config.name
      if trackerName == prefixes.rollup
        __mwgaTracker("#{trackerName}.#{cmd}", hit) if hit.hitType != 'event'
      else 
        __mwgaTracker("#{trackerName}.#{cmd}", hit)


`
  if (typeof window.__mwgaTracker === 'undefined') {
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','__mwgaTracker');
  }`

# window.addEventListener("load", ->
#   # track pageview!
#   window.analytics.track(new window.TrackablePageview)
# )

# console.log analytics.accounts