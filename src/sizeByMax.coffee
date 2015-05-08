'use strict'

sizeByMax = (width, height, maxWidth, maxHeight) ->
  if width <= maxWidth and height <= maxHeight
    # Don't scale
    return {width, height, scale: 1.0}

  ratio = width/height
  maxRatio = maxWidth/maxHeight
  if ratio >= maxRatio
    # Size by maxWidth
    scale = maxWidth/width
    width = Math.round width*scale
    height = Math.round height*scale
    return {width, height, scale}
  else
    # Size by maxHeight
    scale = maxHeight/height
    width = Math.round width*scale
    height = Math.round height*scale
    return {width, height, scale}

module.exports = sizeByMax
