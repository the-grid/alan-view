'use strict'

sizeByMax = require './sizeByMax'

TAU = 2 * Math.PI

drawTarget = (context, x, y, radius, style) ->
  context.beginPath()
  context.arc(x, y, radius, 0, TAU, false)
  context.strokeStyle = style
  context.stroke()
  context.beginPath()
  context.moveTo(x - 15, y)
  context.lineTo(x + 15, y)
  context.stroke()
  context.beginPath()
  context.moveTo(x, y - 15)
  context.lineTo(x, y + 15)
  context.stroke()

drawPolygon = (context, polygon, scale, width, height) ->
  # Draw points of polygon
  for point in polygon
    if point.length?
      x = point[0]*scale
      y = point[1]*scale
    else
      {x, y} = point
      x *= scale
      y *= scale
    context.beginPath()
    context.arc(x, y, 1, 0, TAU, false)
    context.fillStyle = 'rgba(255, 255, 255, 0.75)'
    context.fill()

  # Fade outside of polygon
  context.beginPath()
  # Outline border (CW)
  context.moveTo 0, 0
  context.lineTo width, 0
  context.lineTo width, height
  context.lineTo 0, height
  # Polygon hole (CCW (always?))
  for point,i in polygon
    if point.length?
      x = point[0] * scale
      y = point[1] * scale
    else
      {x, y} = point
      x *= scale
      y *= scale
    if i == 0
      context.moveTo x, y
    context.lineTo x, y
  context.closePath()

  context.fillStyle = 'rgba(255, 255, 255, 0.25)'
  context.fill('evenodd')

class AlanView
  constructor: (props) ->
    @props = props

  draw: (block) ->
    return unless block.cover?
    # Get mandatory measurements
    {src, width, height, colors} = block.cover
    # Get extra measurements
    {saliency, faces, textregions, histogram} = block.cover
    # Get helper measurements
    {scene, lines} = block.cover
    {width, height, scale} = @getSizeAndScale width, height

    canvas = @props.canvas
    context = canvas.getContext('2d')

    unless @props.noBackground?
      context.clearRect 0, 0, width, height

    if saliency?
      unless @props.noSaliency?
        @drawSaliency context, saliency, width, height, scale
    if faces?
      unless @props.noFaces?
        @drawFaces context, faces, scale
    if textregions?
      unless @props.noTextregions?
        @drawTextregions context, textregions, scale
    if scene?
      unless @props.noScene?
        @drawScene context, scene, width, height, scale
    if lines?
      unless @props.noLines?
        @drawLines context, lines, scale
    if colors?
      unless @props.noColors?
        @drawColors context, colors
    if histogram?
      unless @props.noHistogram?
        @drawHistogram context, histogram, width, height

  drawHistogram: (context, histogram, width, height) ->
    histWidth = 200
    histHeight = 100
    histX = 10
    histY = height - 10
    for type of histogram
      context.beginPath()
      context.rect histX, histY, histWidth, histHeight
      context.strokeStyle = 'rgba(255, 255, 255, 0.9)'
      context.stroke()
      histY -= histHeight + 10

  drawLines: (context, lines, scale) ->
    {stripes} = lines
    for stripe in stripes
      {type, bbox} = stripe
      if type is 'space'
        x = bbox.x * scale
        y = bbox.y * scale
        w = bbox.width * scale
        h = bbox.height * scale
        context.beginPath()
        context.rect x, y, w, h
        context.strokeStyle = 'rgba(255, 0, 0, 0.5)'
        context.stroke()
        context.fillStyle = 'rgba(255, 0, 0, 0.3)'
        context.fill()

  drawScene: (context, scene, width, height, scale) ->
    {bbox, center} = scene
    x = bbox.x * scale
    y = bbox.y * scale
    w = bbox.width * scale
    h = bbox.height * scale
    context.beginPath()
    context.rect x, y, w, h
    context.strokeStyle = 'rgba(0, 255, 0, 0.7)'
    context.stroke()

    if center?
      drawTarget context, center.x*scale, center.y*scale, 3, 'rgba(0, 255, 0, 0.7)'

    unless @props.noSceneFading?
      # Fade outside salient bounding box
      context.beginPath()
      context.rect 0, 0, width, height
      context.rect x-50, y-50, w+100, h+100
      context.fillStyle = 'rgba(255, 255, 255, 0.5)'
      context.fill('evenodd')

  drawSaliency: (context, saliency, width, height, scale) ->
    {regions, center, polygon, bounding_rect, radius} = saliency

    if polygon?
      unless @props.noPolygon?
        drawPolygon context, polygon, scale, width, height

    if bounding_rect?
      unless @props.noSaliency?
        l = bounding_rect[0][0]*scale
        t = bounding_rect[0][1]*scale
        r = bounding_rect[1][0]*scale
        b = bounding_rect[1][1]*scale
        w = r-l
        h = b-t

        # Draw salient bounding box
        context.beginPath()
        context.rect l, t, w, h
        context.strokeStyle = 'rgba(255, 255, 255, 0.5)'
        context.stroke()

    if center?
      unless @props.noCircle?
        # Draw salient circle
        context.beginPath()
        context.arc(center[0]*scale, center[1]*scale, radius*scale, 0, TAU, false)
        context.strokeStyle = 'rgba(255, 255, 255, 0.7)'
        context.stroke()

    if regions?
      for region in regions
        {bbox, polygon} = region
        {x, y, width, height} = bbox
        x *= scale
        y *= scale
        width *= scale
        height *= scale
        context.strokeStyle = 'rgba(255, 255, 255, 0.5)'
        context.strokeRect(x, y, width, height)
        if polygon?
          unless @props.noPolygon?
            drawPolygon context, polygon, scale, width, height



  drawFaces: (context, faces, scale) ->
    for face in faces
      {x, y, width, height, confidence} = face
      x *= scale
      y *= scale
      width *= scale
      height *= scale
      context.fillStyle = 'rgba(0, 0, 155, 0.5)'
      context.fillRect(x, y, width, height)
      context.strokeStyle = 'rgba(0, 0, 155, 0.9)'
      context.strokeRect(x, y, width, height)
      unless @props.noFaceConfidence?
        context.fillStyle = 'rgba(255, 255, 255, 1.0)'
        context.fillText confidence.toFixed(2), x, y + height + 10
      area = width * height
      context.fillText "#{width}x#{height}", x + width / 3, y + height / 2
      context.fillText area.toFixed(0), x + width / 3, y + height / 2 + 10

  drawTextregions: (context, regions, scale) ->
    for region in regions
      {x, y, width, height} = region
      x *= scale
      y *= scale
      width *= scale
      height *= scale
      context.fillStyle = 'rgba(155, 0, 0, 0.5)'
      context.fillRect(x, y, width, height)
      context.strokeStyle = 'rgba(155, 0, 0, 0.9)'
      context.strokeRect(x, y, width, height)

  drawColors: (context, colors) ->
    for c, i in colors
      context.beginPath()
      context.arc(20 + i*40, 20, 15, 0, TAU, false)
      context.fillStyle = "rgb(#{c[0]}, #{c[1]}, #{c[2]})"
      context.fill()
      context.strokeStyle = 'rgba(255, 255, 255, 0.9)'
      context.stroke()

  getSizeAndScale: (width, height) ->
    {maxWidth, maxHeight} = @props
    return sizeByMax width, height, maxWidth, maxHeight
  
module.exports = AlanView
