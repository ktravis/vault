package vault.ugl;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import vault.EMath;

// use '@0xRRGGBB' to set a text coloring mid-string,
// and '@' to return to the default color.
class ComplexText extends Text {

  override function redraw()
  {
    sprite.graphics.clear();
    if (_text.length == 0) return;

    _redraw = false;
    var bmpd = ComplexText.drawText(_text, _color, _size);
    sprite.graphics.beginBitmapFill(bmpd, null, false, false);
    sprite.graphics.drawRect(0, 0, bmpd.width, bmpd.height);
  }
  static override public function drawText(text: String, color: Int, size: Int): BitmapData
    {
    color |= 0xFF000000;
    var cols:Array<Int> = [];
    var segs:Array<String> = [];
    for (s in text.split("@"))
      if (s.length > 2)
      {
        if (s.substr(0,2) == '0x')
        {
            segs.push(s.substr(8));
            cols.push(color | Std.parseInt(s.substr(0,8)));
        }
        else 
        {
            segs.push(s);
            cols.push(color);
        }
      }
    var lines = 1;
    var longest_line = 0;
    var line_start = 0;
    for (i in 0...text.length)
      if (text.charAt(i) == '\n')
      {
        lines++;
        longest_line = EMath.max(i - line_start, longest_line);
        line_start = i;
      }
    longest_line = EMath.max(text.length - line_start, longest_line);
    var bmpd = new BitmapData(size*longest_line*Text.FONTWIDTH, size*Text.FONTHEIGHT*lines, true, 0);

    var curx = 0;
    var maxx = 0;
    var yoff = 0;
    for (j in 0...segs.length)
    {
      for (i in 0...segs[j].length)
      {
        if (segs[j].charAt(i) == '\n') 
        {
          yoff += Text.FONTHEIGHT;
          maxx = curx = 0;
          continue;
        }
        var c = segs[j].charCodeAt(i);
        if (c <= 32 || c > 126) { c = 32; maxx += Text.FONTWIDTH*size; }
        for (p in 0...Text.FONTWIDTH*Text.FONTHEIGHT) {
          var v:UInt = Text.FONTDATA[(c-32)*2 + Std.int(p/32)] & 1 << (31-(p%32));
          if (v != 0) {
            var px = curx + (p%Text.FONTWIDTH) * size;
            maxx = EMath.max(maxx, px);
            var py = Std.int(p/Text.FONTWIDTH) * size;
            bmpd.fillRect(new Rectangle(px, py+yoff, size, size), cols[j]);
          }
        }
        curx = maxx + 2*size;
      } 
    }

    var out = new BitmapData(bmpd.width, bmpd.height, true, 0);
    out.copyPixels(bmpd, out.rect, new flash.geom.Point(0, 0));
    return out;
  }
}
