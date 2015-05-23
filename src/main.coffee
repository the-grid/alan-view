'use strict'

sizeByMax = require './sizeByMax'

TAU = 2 * Math.PI

class AlanView
  constructor: (props) ->
    @props = props

  draw: (block) ->
    {saliency, colors, faces, src, width, height, scene} = block.cover
    {width, height, scale} = @getSizeAndScale width, height
    {lines} = block

    canvas = @props.canvas
    context = canvas.getContext('2d')

    context.clearRect 0, 0, width, height

    if saliency?
      unless @props.noSaliency?
        @drawSaliency context, saliency, width, height, scale
    if faces?
      @drawFaces context, faces, scale
    if scene?
      @drawScene context, scene, width, height, scale
    if lines?
      @drawLines context, lines, scale
    if colors?
      @drawColors context, colors

  drawLines: (context, lines, scale) ->
    if lines.direction is 'vertical'
      pieces = lines.columns
    else
      pieces = lines.rows
    for piece in pieces
      if piece[0] is 'space'
        bbox = piece[1]
        x = bbox.x * scale
        y = bbox.y * scale
        w = bbox.width * scale
        h = bbox.height * scale
        context.beginPath()
        context.rect x, y, w, h
        context.strokeStyle = 'rgba(255, 0, 0, 0.5)'
        context.stroke()
        context.fillStyle = 'rgba(255, 0, 0, 0.2)'
        context.fill()

  drawScene: (context, scene, width, height, scale) ->
    unless @props.noScene?
      {bbox} = scene
      x = bbox.x * scale
      y = bbox.y * scale
      w = bbox.width * scale
      h = bbox.height * scale
      context.beginPath()
      context.rect x, y, w, h
      context.strokeStyle = 'rgba(0, 255, 0, 0.5)'
      context.stroke()

      # Fade outside salient bounding box
      context.beginPath()
      context.rect 0, 0, width, height
      context.rect x-50, y-50, w+100, h+100
      context.fillStyle = 'rgba(255, 255, 255, 0.5)'
      context.fill('evenodd')

  drawSaliency: (context, saliency, width, height, scale) ->
    {center, polygon, bounding_rect, radius} = saliency

    if polygon?
      unless @props.noPolygon?
        # Draw points of polygon
        for point in polygon
          context.beginPath()
          context.arc(point[0]*scale, point[1]*scale, 1, 0, TAU, false)
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
        firstPoint = polygon[0]
        context.moveTo(firstPoint[0]*scale, firstPoint[1]*scale)
        for point in polygon
          context.lineTo(point[0]*scale, point[1]*scale)
        context.closePath()

        context.fillStyle = 'rgba(255, 255, 255, 0.25)'
        context.fill('evenodd')

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

  drawFaces: (context, faces, scale) ->
    for face in faces
      {x, y, width, height} = face
      x *= scale
      y *= scale
      width *= scale
      height *= scale
      context.fillStyle = 'rgba(0, 0, 155, 0.5)'
      context.fillRect(x, y, width, height)
      context.strokeStyle = 'rgba(0, 0, 155, 0.9)'
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
