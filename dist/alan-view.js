(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.alanView = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
var AlanView, TAU, drawPolygon, drawTarget, sizeByMax;

sizeByMax = require('./sizeByMax');

TAU = 2 * Math.PI;

drawTarget = function(context, x, y, radius, style) {
  context.beginPath();
  context.arc(x, y, radius, 0, TAU, false);
  context.strokeStyle = style;
  context.stroke();
  context.beginPath();
  context.moveTo(x - 15, y);
  context.lineTo(x + 15, y);
  context.stroke();
  context.beginPath();
  context.moveTo(x, y - 15);
  context.lineTo(x, y + 15);
  return context.stroke();
};

drawPolygon = function(context, polygon, scale, width, height) {
  var i, j, k, len, len1, point, x, y;
  for (j = 0, len = polygon.length; j < len; j++) {
    point = polygon[j];
    if (point.length != null) {
      x = point[0] * scale;
      y = point[1] * scale;
    } else {
      x = point.x, y = point.y;
      x *= scale;
      y *= scale;
    }
    context.beginPath();
    context.arc(x, y, 1, 0, TAU, false);
    context.fillStyle = 'rgba(255, 255, 255, 0.75)';
    context.fill();
  }
  context.beginPath();
  context.moveTo(0, 0);
  context.lineTo(width, 0);
  context.lineTo(width, height);
  context.lineTo(0, height);
  for (i = k = 0, len1 = polygon.length; k < len1; i = ++k) {
    point = polygon[i];
    if (point.length != null) {
      x = point[0] * scale;
      y = point[1] * scale;
    } else {
      x = point.x, y = point.y;
      x *= scale;
      y *= scale;
    }
    if (i === 0) {
      context.moveTo(x, y);
    }
    context.lineTo(x, y);
  }
  context.closePath();
  context.fillStyle = 'rgba(255, 255, 255, 0.25)';
  return context.fill('evenodd');
};

AlanView = (function() {
  function AlanView(props) {
    this.props = props;
  }

  AlanView.prototype.draw = function(block) {
    var canvas, colors, context, faces, height, lines, ref, ref1, saliency, scale, scene, src, textregions, width;
    ref = block.cover, saliency = ref.saliency, colors = ref.colors, faces = ref.faces, textregions = ref.textregions, src = ref.src, width = ref.width, height = ref.height, scene = ref.scene, lines = ref.lines;
    ref1 = this.getSizeAndScale(width, height), width = ref1.width, height = ref1.height, scale = ref1.scale;
    canvas = this.props.canvas;
    context = canvas.getContext('2d');
    if (this.props.noBackground == null) {
      context.clearRect(0, 0, width, height);
    }
    if (saliency != null) {
      if (this.props.noSaliency == null) {
        this.drawSaliency(context, saliency, width, height, scale);
      }
    }
    if (faces != null) {
      if (this.props.noFaces == null) {
        this.drawFaces(context, faces, scale);
      }
    }
    if (textregions != null) {
      if (this.props.noTextregions == null) {
        this.drawTextregions(context, textregions, scale);
      }
    }
    if (scene != null) {
      if (this.props.noScene == null) {
        this.drawScene(context, scene, width, height, scale);
      }
    }
    if (lines != null) {
      if (this.props.noLines == null) {
        this.drawLines(context, lines, scale);
      }
    }
    if (colors != null) {
      if (this.props.noColors == null) {
        return this.drawColors(context, colors);
      }
    }
  };

  AlanView.prototype.drawLines = function(context, lines, scale) {
    var bbox, h, j, len, results, stripe, stripes, type, w, x, y;
    stripes = lines.stripes;
    results = [];
    for (j = 0, len = stripes.length; j < len; j++) {
      stripe = stripes[j];
      type = stripe.type, bbox = stripe.bbox;
      if (type === 'space') {
        x = bbox.x * scale;
        y = bbox.y * scale;
        w = bbox.width * scale;
        h = bbox.height * scale;
        context.beginPath();
        context.rect(x, y, w, h);
        context.strokeStyle = 'rgba(255, 0, 0, 0.5)';
        context.stroke();
        context.fillStyle = 'rgba(255, 0, 0, 0.3)';
        results.push(context.fill());
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  AlanView.prototype.drawScene = function(context, scene, width, height, scale) {
    var bbox, center, h, w, x, y;
    bbox = scene.bbox, center = scene.center;
    x = bbox.x * scale;
    y = bbox.y * scale;
    w = bbox.width * scale;
    h = bbox.height * scale;
    context.beginPath();
    context.rect(x, y, w, h);
    context.strokeStyle = 'rgba(0, 255, 0, 0.7)';
    context.stroke();
    if (center != null) {
      drawTarget(context, center.x * scale, center.y * scale, 3, 'rgba(0, 255, 0, 0.7)');
    }
    if (this.props.noSceneFading == null) {
      context.beginPath();
      context.rect(0, 0, width, height);
      context.rect(x - 50, y - 50, w + 100, h + 100);
      context.fillStyle = 'rgba(255, 255, 255, 0.5)';
      return context.fill('evenodd');
    }
  };

  AlanView.prototype.drawSaliency = function(context, saliency, width, height, scale) {
    var b, bbox, bounding_rect, center, h, j, l, len, polygon, r, radius, region, regions, results, t, w, x, y;
    regions = saliency.regions, center = saliency.center, polygon = saliency.polygon, bounding_rect = saliency.bounding_rect, radius = saliency.radius;
    if (polygon != null) {
      if (this.props.noPolygon == null) {
        drawPolygon(context, polygon, scale, width, height);
      }
    }
    if (bounding_rect != null) {
      if (this.props.noSaliency == null) {
        l = bounding_rect[0][0] * scale;
        t = bounding_rect[0][1] * scale;
        r = bounding_rect[1][0] * scale;
        b = bounding_rect[1][1] * scale;
        w = r - l;
        h = b - t;
        context.beginPath();
        context.rect(l, t, w, h);
        context.strokeStyle = 'rgba(255, 255, 255, 0.5)';
        context.stroke();
      }
    }
    if (center != null) {
      if (this.props.noCircle == null) {
        context.beginPath();
        context.arc(center[0] * scale, center[1] * scale, radius * scale, 0, TAU, false);
        context.strokeStyle = 'rgba(255, 255, 255, 0.7)';
        context.stroke();
      }
    }
    if (regions != null) {
      results = [];
      for (j = 0, len = regions.length; j < len; j++) {
        region = regions[j];
        bbox = region.bbox, polygon = region.polygon;
        x = bbox.x, y = bbox.y, width = bbox.width, height = bbox.height;
        x *= scale;
        y *= scale;
        width *= scale;
        height *= scale;
        context.strokeStyle = 'rgba(255, 255, 255, 0.5)';
        context.strokeRect(x, y, width, height);
        if (polygon != null) {
          if (this.props.noPolygon == null) {
            results.push(drawPolygon(context, polygon, scale, width, height));
          } else {
            results.push(void 0);
          }
        } else {
          results.push(void 0);
        }
      }
      return results;
    }
  };

  AlanView.prototype.drawFaces = function(context, faces, scale) {
    var area, confidence, face, height, j, len, results, width, x, y;
    results = [];
    for (j = 0, len = faces.length; j < len; j++) {
      face = faces[j];
      x = face.x, y = face.y, width = face.width, height = face.height, confidence = face.confidence;
      x *= scale;
      y *= scale;
      width *= scale;
      height *= scale;
      context.fillStyle = 'rgba(0, 0, 155, 0.5)';
      context.fillRect(x, y, width, height);
      context.strokeStyle = 'rgba(0, 0, 155, 0.9)';
      context.strokeRect(x, y, width, height);
      if (this.props.noFaceConfidence == null) {
        context.fillStyle = 'rgba(255, 255, 255, 1.0)';
        context.fillText(confidence.toFixed(2), x, y + height + 10);
      }
      area = width * height;
      context.fillText(width + "x" + height, x + width / 3, y + height / 2);
      results.push(context.fillText(area.toFixed(0), x + width / 3, y + height / 2 + 10));
    }
    return results;
  };

  AlanView.prototype.drawTextregions = function(context, regions, scale) {
    var height, j, len, region, results, width, x, y;
    results = [];
    for (j = 0, len = regions.length; j < len; j++) {
      region = regions[j];
      x = region.x, y = region.y, width = region.width, height = region.height;
      x *= scale;
      y *= scale;
      width *= scale;
      height *= scale;
      context.fillStyle = 'rgba(155, 0, 0, 0.5)';
      context.fillRect(x, y, width, height);
      context.strokeStyle = 'rgba(155, 0, 0, 0.9)';
      results.push(context.strokeRect(x, y, width, height));
    }
    return results;
  };

  AlanView.prototype.drawColors = function(context, colors) {
    var c, i, j, len, results;
    results = [];
    for (i = j = 0, len = colors.length; j < len; i = ++j) {
      c = colors[i];
      context.beginPath();
      context.arc(20 + i * 40, 20, 15, 0, TAU, false);
      context.fillStyle = "rgb(" + c[0] + ", " + c[1] + ", " + c[2] + ")";
      context.fill();
      context.strokeStyle = 'rgba(255, 255, 255, 0.9)';
      results.push(context.stroke());
    }
    return results;
  };

  AlanView.prototype.getSizeAndScale = function(width, height) {
    var maxHeight, maxWidth, ref;
    ref = this.props, maxWidth = ref.maxWidth, maxHeight = ref.maxHeight;
    return sizeByMax(width, height, maxWidth, maxHeight);
  };

  return AlanView;

})();

module.exports = AlanView;


},{"./sizeByMax":2}],2:[function(require,module,exports){
'use strict';
var sizeByMax;

sizeByMax = function(width, height, maxWidth, maxHeight) {
  var maxRatio, ratio, scale;
  if (width <= maxWidth && height <= maxHeight) {
    return {
      width: width,
      height: height,
      scale: 1.0
    };
  }
  ratio = width / height;
  maxRatio = maxWidth / maxHeight;
  if (ratio >= maxRatio) {
    scale = maxWidth / width;
    width = Math.round(width * scale);
    height = Math.round(height * scale);
    return {
      width: width,
      height: height,
      scale: scale
    };
  } else {
    scale = maxHeight / height;
    width = Math.round(width * scale);
    height = Math.round(height * scale);
    return {
      width: width,
      height: height,
      scale: scale
    };
  }
};

module.exports = sizeByMax;

},{}]},{},[1])(1)
});