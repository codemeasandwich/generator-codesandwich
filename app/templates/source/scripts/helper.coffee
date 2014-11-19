###
MBP - Mobile boilerplate helper functions
###
((document) ->
  
  ###
  Fix for iPhone viewport scale bug
  http://www.blog.highub.com/mobile-2/a-fix-for-iphone-viewport-scale-bug/
  ###
  
  ###
  Normalized hide address bar for iOS & Android
  (c) Scott Jehl, scottjehl.com
  MIT License
  ###
  
  # If we split this up into two functions we can reuse
  # this function if we aren't doing full page reloads.
  
  # If we cache this we don't need to re-calibrate everytime we call
  # the hide url bar
  
  # So we don't redefine this function everytime we
  # we call hideUrlBar
  
  # It should be up to the mobile
  
  # if there is a hash, or MBP.BODY_SCROLL_TOP hasn't been set yet, wait till that happens
  
  # If there's a hash, or addEventListener is undefined, stop here
  
  # scroll to 1
  
  # reset to 0 on bodyready, if needed
  
  # at load, if user hasn't scrolled more than 20 or so...
  
  # reset to hide addr bar at onload
  
  ###
  Fast Buttons - read wiki below before using
  https://github.com/h5bp/mobile-boilerplate/wiki/JavaScript-Helper
  ###
  
  # styling of .pressed is defined in the project's CSS files
  
  # This is a bit of fun for Android 2.3...
  # If you change window.location via fastButton, a click event will fire
  # on the new page, as if the events are continuing from the previous page.
  # We pick that event up here, but MBP.coords is empty, because it's a new page,
  # so we don't prevent it. Here's we're assuming that click events on touch devices
  # that occur without a preceding touchStart are to be ignored.
  
  # This bug only affects touch Android 2.3 devices, but a simple ontouchstart test creates a false positive on
  # some Blackberry devices. https://github.com/Modernizr/Modernizr/issues/372
  # The browser sniffing is to avoid the Blackberry case. Bah
  
  # fn arg can be an object or a function, thanks to handleEvent
  # read more about the explanation at: http://www.thecssninja.com/javascript/handleevent
  addEvt = (el, evt, fn, bubble) ->
    if "addEventListener" of el
      
      # BBOS6 doesn't support handleEvent, catch and polyfill
      try
        el.addEventListener evt, fn, bubble
      catch e
        if typeof fn is "object" and fn.handleEvent
          el.addEventListener evt, ((e) ->
            
            # Bind fn as this and set first arg as event object
            fn.handleEvent.call fn, e
            return
          ), bubble
        else
          throw e
    else if "attachEvent" of el
      
      # check if the callback is an object and contains handleEvent
      if typeof fn is "object" and fn.handleEvent
        el.attachEvent "on" + evt, ->
          
          # Bind fn as this
          fn.handleEvent.call fn
          return

      else
        el.attachEvent "on" + evt, fn
    return
  rmEvt = (el, evt, fn, bubble) ->
    if "removeEventListener" of el
      
      # BBOS6 doesn't support handleEvent, catch and polyfill
      try
        el.removeEventListener evt, fn, bubble
      catch e
        if typeof fn is "object" and fn.handleEvent
          el.removeEventListener evt, ((e) ->
            
            # Bind fn as this and set first arg as event object
            fn.handleEvent.call fn, e
            return
          ), bubble
        else
          throw e
    else if "detachEvent" of el
      
      # check if the callback is an object and contains handleEvent
      if typeof fn is "object" and fn.handleEvent
        el.detachEvent "on" + evt, ->
          
          # Bind fn as this
          fn.handleEvent.call fn
          return

      else
        el.detachEvent "on" + evt, fn
    return
  window.MBP = window.MBP or {}
  MBP.viewportmeta = document.querySelector and document.querySelector("meta[name=\"viewport\"]")
  MBP.ua = navigator.userAgent
  MBP.scaleFix = ->
    if MBP.viewportmeta and /iPhone|iPad|iPod/.test(MBP.ua) and not /Opera Mini/.test(MBP.ua)
      MBP.viewportmeta.content = "width=device-width, minimum-scale=1.0, maximum-scale=1.0"
      document.addEventListener "gesturestart", MBP.gestureStart, false
    return

  MBP.gestureStart = ->
    MBP.viewportmeta.content = "width=device-width, minimum-scale=0.25, maximum-scale=1.6"
    return

  MBP.BODY_SCROLL_TOP = false
  MBP.getScrollTop = ->
    win = window
    doc = document
    win.pageYOffset or doc.compatMode is "CSS1Compat" and doc.documentElement.scrollTop or doc.body.scrollTop or 0

  MBP.hideUrlBar = ->
    win = window
    win.scrollTo 0, (if MBP.BODY_SCROLL_TOP is 1 then 0 else 1)  if not location.hash and MBP.BODY_SCROLL_TOP isnt false
    return

  MBP.hideUrlBarOnLoad = ->
    win = window
    doc = win.document
    bodycheck = undefined
    if not win.navigator.standalone and not location.hash and win.addEventListener
      window.scrollTo 0, 1
      MBP.BODY_SCROLL_TOP = 1
      bodycheck = setInterval(->
        if doc.body
          clearInterval bodycheck
          MBP.BODY_SCROLL_TOP = MBP.getScrollTop()
          MBP.hideUrlBar()
        return
      , 15)
      win.addEventListener "load", (->
        setTimeout (->
          MBP.hideUrlBar()  if MBP.getScrollTop() < 20
          return
        ), 0
        return
      ), false
    return

  MBP.fastButton = (element, handler, pressedClass) ->
    @handler = handler
    @pressedClass = (if typeof pressedClass is "undefined" then "pressed" else pressedClass)
    MBP.listenForGhostClicks()
    if element.length and element.length > 1
      for singleElIdx of element
        @addClickEvent element[singleElIdx]
    else
      @addClickEvent element
    return

  MBP.fastButton::handleEvent = (event) ->
    event = event or window.event
    switch event.type
      when "touchstart"
        @onTouchStart event
      when "touchmove"
        @onTouchMove event
      when "touchend"
        @onClick event
      when "click"
        @onClick event

  MBP.fastButton::onTouchStart = (event) ->
    element = event.target or event.srcElement
    event.stopPropagation()
    element.addEventListener "touchend", this, false
    document.body.addEventListener "touchmove", this, false
    @startX = event.touches[0].clientX
    @startY = event.touches[0].clientY
    element.className += " " + @pressedClass
    return

  MBP.fastButton::onTouchMove = (event) ->
    @reset event  if Math.abs(event.touches[0].clientX - @startX) > 10 or Math.abs(event.touches[0].clientY - @startY) > 10
    return

  MBP.fastButton::onClick = (event) ->
    event = event or window.event
    element = event.target or event.srcElement
    event.stopPropagation()  if event.stopPropagation
    @reset event
    @handler.apply event.currentTarget, [event]
    MBP.preventGhostClick @startX, @startY  if event.type is "touchend"
    pattern = new RegExp(" ?" + @pressedClass, "gi")
    element.className = element.className.replace(pattern, "")
    return

  MBP.fastButton::reset = (event) ->
    element = event.target or event.srcElement
    rmEvt element, "touchend", this, false
    rmEvt document.body, "touchmove", this, false
    pattern = new RegExp(" ?" + @pressedClass, "gi")
    element.className = element.className.replace(pattern, "")
    return

  MBP.fastButton::addClickEvent = (element) ->
    addEvt element, "touchstart", this, false
    addEvt element, "click", this, false
    return

  MBP.preventGhostClick = (x, y) ->
    MBP.coords.push x, y
    window.setTimeout (->
      MBP.coords.splice 0, 2
      return
    ), 2500
    return

  MBP.ghostClickHandler = (event) ->
    if not MBP.hadTouchEvent and MBP.dodgyAndroid
      event.stopPropagation()
      event.preventDefault()
      return
    i = 0
    len = MBP.coords.length

    while i < len
      x = MBP.coords[i]
      y = MBP.coords[i + 1]
      if Math.abs(event.clientX - x) < 25 and Math.abs(event.clientY - y) < 25
        event.stopPropagation()
        event.preventDefault()
      i += 2
    return

  MBP.dodgyAndroid = ("ontouchstart" of window) and (navigator.userAgent.indexOf("Android 2.3") isnt -1)
  MBP.listenForGhostClicks = (->
    alreadyRan = false
    ->
      return  if alreadyRan
      document.addEventListener "click", MBP.ghostClickHandler, true  if document.addEventListener
      addEvt document.documentElement, "touchstart", (->
        MBP.hadTouchEvent = true
        return
      ), false
      alreadyRan = true
      return
  )()
  MBP.coords = []
  
  ###
  Autogrow
  http://googlecode.blogspot.com/2009/07/gmail-for-mobile-html5-series.html
  ###
  MBP.autogrow = (element, lh) ->
    handler = (e) ->
      newHeight = @scrollHeight
      currentHeight = @clientHeight
      @style.height = newHeight + 3 * textLineHeight + "px"  if newHeight > currentHeight
      return
    setLineHeight = (if (lh) then lh else 12)
    textLineHeight = (if element.currentStyle then element.currentStyle.lineHeight else getComputedStyle(element, null).lineHeight)
    textLineHeight = (if (textLineHeight.indexOf("px") is -1) then setLineHeight else parseInt(textLineHeight, 10))
    element.style.overflow = "hidden"
    (if element.addEventListener then element.addEventListener("input", handler, false) else element.attachEvent("onpropertychange", handler))
    return

  
  ###
  Enable CSS active pseudo styles in Mobile Safari
  http://alxgbsn.co.uk/2011/10/17/enable-css-active-pseudo-styles-in-mobile-safari/
  ###
  MBP.enableActive = ->
    document.addEventListener "touchstart", (->
    ), false
    return

  
  ###
  Prevent default scrolling on document window
  ###
  MBP.preventScrolling = ->
    document.addEventListener "touchmove", ((e) ->
      return  if e.target.type is "range"
      e.preventDefault()
      return
    ), false
    return

  
  ###
  Prevent iOS from zooming onfocus
  https://github.com/h5bp/mobile-boilerplate/pull/108
  Adapted from original jQuery code here: http://nerd.vasilis.nl/prevent-ios-from-zooming-onfocus/
  ###
  MBP.preventZoom = ->
    if MBP.viewportmeta and navigator.platform.match(/iPad|iPhone|iPod/i)
      formFields = document.querySelectorAll("input, select, textarea")
      contentString = "width=device-width,initial-scale=1,maximum-scale="
      i = 0
      fieldLength = formFields.length
      setViewportOnFocus = ->
        MBP.viewportmeta.content = contentString + "1"
        return

      setViewportOnBlur = ->
        MBP.viewportmeta.content = contentString + "10"
        return

      while i < fieldLength
        formFields[i].onfocus = setViewportOnFocus
        formFields[i].onblur = setViewportOnBlur
        i++
    return

  
  ###
  iOS Startup Image helper
  ###
  MBP.startupImage = ->
    portrait = undefined
    landscape = undefined
    pixelRatio = undefined
    head = undefined
    link1 = undefined
    link2 = undefined
    pixelRatio = window.devicePixelRatio
    head = document.getElementsByTagName("head")[0]
    if navigator.platform is "iPad"
      portrait = (if pixelRatio is 2 then "img/startup/startup-tablet-portrait-retina.png" else "img/startup/startup-tablet-portrait.png")
      landscape = (if pixelRatio is 2 then "img/startup/startup-tablet-landscape-retina.png" else "img/startup/startup-tablet-landscape.png")
      link1 = document.createElement("link")
      link1.setAttribute "rel", "apple-touch-startup-image"
      link1.setAttribute "media", "screen and (orientation: portrait)"
      link1.setAttribute "href", portrait
      head.appendChild link1
      link2 = document.createElement("link")
      link2.setAttribute "rel", "apple-touch-startup-image"
      link2.setAttribute "media", "screen and (orientation: landscape)"
      link2.setAttribute "href", landscape
      head.appendChild link2
    else
      portrait = (if pixelRatio is 2 then "img/startup/startup-retina.png" else "img/startup/startup.png")
      portrait = (if screen.height is 568 then "img/startup/startup-retina-4in.png" else portrait)
      link1 = document.createElement("link")
      link1.setAttribute "rel", "apple-touch-startup-image"
      link1.setAttribute "href", portrait
      head.appendChild link1
    
    #hack to fix letterboxed full screen web apps on 4" iPhone / iPod with iOS 6
    MBP.viewportmeta.content = MBP.viewportmeta.content.replace(/\bwidth\s*=\s*320\b/, "width=320.1").replace(/\bwidth\s*=\s*device-width\b/, "")  if MBP.viewportmeta  if navigator.platform.match(/iPhone|iPod/i) and (screen.height is 568) and navigator.userAgent.match(/\bOS 6_/)
    return

  return
) document