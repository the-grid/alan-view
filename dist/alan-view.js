(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.alanView = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';
var AlanView, TAU, sizeByMax;

sizeByMax = require('./sizeByMax');

TAU = 2 * Math.PI;

AlanView = (function() {
  function AlanView(props) {
    this.props = props;
  }

  AlanView.prototype.draw = function(block) {
    var canvas, colors, context, faces, height, lines, ref, ref1, saliency, scale, scene, src, width;
    ref = block.cover, saliency = ref.saliency, colors = ref.colors, faces = ref.faces, src = ref.src, width = ref.width, height = ref.height, scene = ref.scene;
    ref1 = this.getSizeAndScale(width, height), width = ref1.width, height = ref1.height, scale = ref1.scale;
    lines = block.lines;
    canvas = this.props.canvas;
    context = canvas.getContext('2d');
    context.clearRect(0, 0, width, height);
    if (saliency != null) {
      if (this.props.noSaliency == null) {
        this.drawSaliency(context, saliency, width, height, scale);
      }
    }
    if (faces != null) {
      this.drawFaces(context, faces, scale);
    }
    if (scene != null) {
      this.drawScene(context, scene, width, height, scale);
    }
    if (lines != null) {
      this.drawLines(context, lines, scale);
    }
    if (colors != null) {
      return this.drawColors(context, colors);
    }
  };

  AlanView.prototype.drawLines = function(context, lines, scale) {
    var bbox, h, j, len, piece, pieces, results, w, x, y;
    if (lines.direction === 'vertical') {
      pieces = lines.columns;
    } else {
      pieces = lines.rows;
    }
    results = [];
    for (j = 0, len = pieces.length; j < len; j++) {
      piece = pieces[j];
      if (piece[0] === 'space') {
        bbox = piece[1];
        x = bbox.x * scale;
        y = bbox.y * scale;
        w = bbox.width * scale;
        h = bbox.height * scale;
        context.beginPath();
        context.rect(x, y, w, h);
        context.strokeStyle = 'rgba(255, 0, 0, 0.5)';
        context.stroke();
        context.fillStyle = 'rgba(255, 0, 0, 0.2)';
        results.push(context.fill());
      } else {
        results.push(void 0);
      }
    }
    return results;
  };

  AlanView.prototype.drawScene = function(context, scene, width, height, scale) {
    var bbox, h, w, x, y;
    if (this.props.noScene == null) {
      bbox = scene.bbox;
      x = bbox.x * scale;
      y = bbox.y * scale;
      w = bbox.width * scale;
      h = bbox.height * scale;
      context.beginPath();
      context.rect(x, y, w, h);
      context.strokeStyle = 'rgba(0, 255, 0, 0.5)';
      context.stroke();
      context.beginPath();
      context.rect(0, 0, width, height);
      context.rect(x - 50, y - 50, w + 100, h + 100);
      context.fillStyle = 'rgba(255, 255, 255, 0.5)';
      return context.fill('evenodd');
    }
  };

  AlanView.prototype.drawSaliency = function(context, saliency, width, height, scale) {
    var b, bounding_rect, center, firstPoint, h, j, k, l, len, len1, point, polygon, r, radius, t, w;
    center = saliency.center, polygon = saliency.polygon, bounding_rect = saliency.bounding_rect, radius = saliency.radius;
    if (polygon != null) {
      if (this.props.noPolygon == null) {
        for (j = 0, len = polygon.length; j < len; j++) {
          point = polygon[j];
          context.beginPath();
          context.arc(point[0] * scale, point[1] * scale, 1, 0, TAU, false);
          context.fillStyle = 'rgba(255, 255, 255, 0.75)';
          context.fill();
        }
        context.beginPath();
        context.moveTo(0, 0);
        context.lineTo(width, 0);
        context.lineTo(width, height);
        context.lineTo(0, height);
        firstPoint = polygon[0];
        context.moveTo(firstPoint[0] * scale, firstPoint[1] * scale);
        for (k = 0, len1 = polygon.length; k < len1; k++) {
          point = polygon[k];
          context.lineTo(point[0] * scale, point[1] * scale);
        }
        context.closePath();
        context.fillStyle = 'rgba(255, 255, 255, 0.25)';
        context.fill('evenodd');
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
        return context.stroke();
      }
    }
  };

  AlanView.prototype.drawFaces = function(context, faces, scale) {
    var face, height, j, len, results, width, x, y;
    results = [];
    for (j = 0, len = faces.length; j < len; j++) {
      face = faces[j];
      x = face.x, y = face.y, width = face.width, height = face.height;
      x *= scale;
      y *= scale;
      width *= scale;
      height *= scale;
      context.fillStyle = 'rgba(0, 0, 155, 0.5)';
      context.fillRect(x, y, width, height);
      context.strokeStyle = 'rgba(0, 0, 155, 0.9)';
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