# code for dataset shim:
`if(!Function.prototype.bind){Function.prototype.bind=function(e){"use strict";if(typeof this!=="function"){throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable")}var t=Array.prototype.slice.call(arguments,1),n=this,r=function(){},i=function(){return n.apply(this instanceof r&&e?this:e,t.concat(Array.prototype.slice.call(arguments)))};r.prototype=this.prototype;i.prototype=new r;return i}}(function(){"use strict";var e=Object.prototype,t=e.__defineGetter__,n=e.__defineSetter__,r=e.__lookupGetter__,i=e.__lookupSetter__,s=e.hasOwnProperty;if(t&&n&&r&&i){if(!Object.defineProperty){Object.defineProperty=function(e,o,u){if(arguments.length<3){throw new TypeError("Arguments not optional")}o+="";if(s.call(u,"value")){if(!r.call(e,o)&&!i.call(e,o)){e[o]=u.value}if(s.call(u,"get")||s.call(u,"set")){throw new TypeError("Cannot specify an accessor and a value")}}if(!(u.writable&&u.enumerable&&u.configurable)){throw new TypeError("This implementation of Object.defineProperty does not support"+" false for configurable, enumerable, or writable.")}if(u.get){t.call(e,o,u.get)}if(u.set){n.call(e,o,u.set)}return e}}if(!Object.getOwnPropertyDescriptor){Object.getOwnPropertyDescriptor=function(e,t){if(arguments.length<2){throw new TypeError("Arguments not optional.")}t+="";var n={configurable:true,enumerable:true,writable:true},o=r.call(e,t),u=i.call(e,t);if(!s.call(e,t)){return n}if(!o&&!u){n.value=e[t];return n}delete n.writable;n.get=n.set=undefined;if(o){n.get=o}if(u){n.set=u}return n}}if(!Object.defineProperties){Object.defineProperties=function(e,t){var n;for(n in t){if(s.call(t,n)){Object.defineProperty(e,n,t[n])}}}}}})();if(!document.documentElement.dataset&&(!Object.getOwnPropertyDescriptor(Element.prototype,"dataset")||!Object.getOwnPropertyDescriptor(Element.prototype,"dataset").get)){var propDescriptor={enumerable:true,get:function(){"use strict";var e,t=this,n,r,i,s,o,u=this.attributes,a=u.length,f=function(e){return e.charAt(1).toUpperCase()},l=function(){return this},c=function(e,t){return typeof t!=="undefined"?this.setAttribute(e,t):this.removeAttribute(e)};try{(({})).__defineGetter__("test",function(){});n={}}catch(h){n=document.createElement("div")}for(e=0;e<a;e++){o=u[e];if(o&&o.name&&/^data-\w[\w\-]*$/.test(o.name)){r=o.value;i=o.name;s=i.substr(5).replace(/-./g,f);try{Object.defineProperty(n,s,{enumerable:this.enumerable,get:l.bind(r||""),set:c.bind(t,i)})}catch(p){n[s]=r}}}return n}};try{Object.defineProperty(Element.prototype,"dataset",propDescriptor)}catch(e){propDescriptor.enumerable=false;Object.defineProperty(Element.prototype,"dataset",propDescriptor)}}`

class window.TrackableEvent
  ## `date +%Y-%m-%d` 
  # A Hit has 4 properties:
  # category: required
  # action: required
  # label: optional
  # value: optional
  # label and value can by dynamic
  ####################
  
    
  constructor: (analytics, category, options) ->
    @type     = options.type     || "send"
    @action   = options.action   || "click"
    @hitType  = options.hitType  || "event"
    @label    = options.label
    @value    = options.value
    @category = category 
    @tracker  = analytics

    if options.el?
      @el = options.el
      @el.addEventListener(@action, this.eventFired)

  eventFired: (e) =>
    @tracker.track(this, e)

  getLabel: (e) ->
    el = e.currentTarget
    if !@label 
      el = e.currentTarget
      @label = el.dataset.trackLabel 

    if @label.substr(0,3) == "js:"
      target = el
      # "js:jQuery(target).val()"
      # "potato"
      eval(@label.substr(3))
    else
      @label

  getValue: (e) ->
    if !@value 
      el = e.currentTarget
      @label = el.dataset.trackValue

    if @value? && @value.substr(0,3) == "js:"
      target = e.currentTarget
      eval(@value.substr(3))
    else
      @value
  getHit: => 
    hit = 
      hitType:       @hitType
      eventCategory: @category
      eventAction:   @action
      eventLabel:    this.getLabel(e)
      eventValue:    this.getValue(e)

    `for (var i in hit) {
      if (hit[i] === null || hit[i] === undefined) {
        delete hit[i];
      }
    }` 
    return hit   


  @fetchFromSelector: (selector, analytics) ->
    elements = document.querySelectorAll(selector)

    # supported attributes:
    # data-track
    # data-track-action
    # data-track-label
    # data-track-value
    # data-track-category

    for el in elements
      options = 
        label: el.dataset.trackLabel
        value: el.dataset.trackValue
        "el":  el

      new TrackableEvent(analytics, el.dataset.trackCategory, options)

class window.TrackablePageview
  constructor: (analytics, page) ->
    @type    = "send"
    @hitType = "pageview"
    @page    = page
    @tracker = analytics

  getHit: ->
    hit = 
      page: @page
      hitType: @hitType
    `for (var i in hit) {
      if (hit[i] === null || hit[i] === undefined) {
        delete hit[i];
      }
    }` 
    return hit   

class window.TrackableCustomPage
  constructor: (options) ->
    @index    = options.index
    @name     = options.name  || "page_type"
    @value    = options.value
    @optScope = options.optScope
    @type     = "set"
    
  getHit: () ->
    hit = {}
    hit["dimension#{@index}"] = @value 
      
    `for (var i in hit) {
      if (hit[i] === null || hit[i] === undefined) {
        delete hit[i];
      }
    }` 
    return hit   
  @getFromBody: (analytics) ->
    new TrackableCustomPage(document.body.dataset)

class window.TrackableTransaction
  constructor: (id, storeName, total, shipping, salesTax) ->
    @id        = id
    @storeName = storeName
    @total     = total
    @shipping  = shipping
    @salesTax  = salesTax
    @type      = "ecommerce:addTransaction"

  hit: =>
    hit = 
      id:          @id
      affiliation: @storeName
      revenue:     @total
      shipping:    @shipping
      tax:         @salesTax
    `for (var i in hit) {
      if (hit[i] === null || hit[i] === undefined) {
        delete hit[i];
      }
    }` 
    return hit  
  @createTransaction: () ->
    bodyData    = document.body.dataset
    transaction = new window.TrackableTransaction bodyData.trackId, bodyData.trackStoreName, bodyData.trackTotal, bodyData.trackShipping, bodyData.trackSalesTax
    return transaction

class window.TrackableItem
  constructor: (id, name, options) ->
    @id       = id
    @name     = name
    @sku      = options.sku
    @category = options.category
    @price    = options.price
    @quantity = options.quantity
    @type     = "ecommerce:addItem"
  getHit: () =>
    hit = 
      id:       @id
      name:     @name
      sku:      @sku
      category: @category
      price:    @price
      quantity: @quantity
    `for (var i in hit) {
      if (hit[i] === null || hit[i] === undefined) {
        delete hit[i];
      } else {
        hit[i].toString();
      }
    }` 
    return hit  
  @fetchFromSelector: (selector, analytics) ->
    items = document.querySelectorAll(selector)
    for item in items
      id           = item.querySelector("[data-track-id]").dataset.trackId
      name         = item.querySelector("[data-track-name]").dataset.trackName
      sku          = item.querySelector("[data-track-sku]").dataset.trackSku
      category     = item.querySelector("[data-track-category]").dataset.trackCategory
      price        = item.querySelector("[data-track-price]").dataset.trackPrice
      quantity     = item.querySelector("[data-track-quantity]").dataset.trackQuantity
      options = 
        sku:      sku
        category: category
        price:    price
        quantity: quantity

      analytics.track(new window.TrackableItem(id, name, options))

class window.SendEcommerce 
  constructor: () ->
    @type = "ecommerce:send"
  getHit: () ->
    return {}