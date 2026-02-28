#!/usr/bin/env tclsh

package require Tk 8.6
tk appname "stitchview"
wm title . "stitch-view"

# I have a 4K monitor, this will be just fine.
set ::screen_lx 2560
set ::screen_ly 1920

set ::layout_specs {
  {LVLAYOUT_GHZ1_ENDING src/data/lv_ghz_1_ending.layout8 GHZ}
  {LVLAYOUT_GHZ2 src/data/lv_ghz_2.layout7 GHZ}
  {LVLAYOUT_GHZ3 src/data/lv_ghz_3.layout7 GHZ}
  {LVLAYOUT_BRI1 src/data/lv_bri_1.layout8 BRI}
  {LVLAYOUT_BRI2 src/data/lv_bri_2.layout7 BRI}
  {LVLAYOUT_BRI3 src/data/lv_bri_3.layout7 BRI}
  {LVLAYOUT_JUN1 src/data/lv_jun_1.layout8 JUN}
  {LVLAYOUT_JUN2_special_4_8 src/data/lv_jun_2_special_4_8.layout4 JUN}
  {LVLAYOUT_JUN3 src/data/lv_jun_3.layout6 JUN}
  {LVLAYOUT_LAB1 src/data/lv_lab_1.layout6 LAB}
  {LVLAYOUT_LAB2 src/data/lv_lab_2.layout6 LAB}
  {LVLAYOUT_LAB3 src/data/lv_lab_3.layout6 LAB}
  {LVLAYOUT_SCR1 src/data/lv_scr_1.layout8 SCR}
  {LVLAYOUT_SCR2_main src/data/lv_scr_2_main.layout7 SCR}
  {LVLAYOUT_SCR2_upper src/data/lv_scr_2_upper.layout6 SCR}
  {LVLAYOUT_SCR2_lower src/data/lv_scr_2_lower.layout5 SCR}
  {LVLAYOUT_SCR3 src/data/lv_scr_3.layout6 SCR}
  {LVLAYOUT_SKY1 src/data/lv_sky_1.layout7 SKY}
  {LVLAYOUT_SKY2 src/data/lv_sky_2.layout6 SKY}
  {LVLAYOUT_SKY3_endof_SKY2 src/data/lv_sky_3_end_sky_2.layout6 SKY_3}
  {LVLAYOUT_SPECIAL_1_2_3_5_6_7 src/data/lv_special_1_2_3_5_6_7.layout6 special}
}

set ::tilemap_specs {
   {GHZ LVTILEMAP_GHZ src/data/lv_ghz.tilemap}
   {BRI LVTILEMAP_BRI src/data/lv_bri.tilemap}
   {JUN LVTILEMAP_JUN src/data/lv_jun.tilemap}
   {LAB LVTILEMAP_LAB src/data/lv_lab.tilemap}
   {SCR LVTILEMAP_SCR src/data/lv_scr.tilemap}
   {SKY LVTILEMAP_SKY src/data/lv_sky.tilemap}
   {SKY_3 LVTILEMAP_SKY_3 src/data/lv_sky_3.tilemap}
   {special LVTILEMAP_special src/data/lv_special.tilemap}
}

set ::lvart0_specs {
   {GHZ ART_GHZ_0000 src/data/lv_ghz.art0000}
   {BRI ART_BRI_0000 src/data/lv_bri.art0000}
   {JUN ART_JUN_0000 src/data/lv_jun.art0000}
   {LAB ART_LAB_0000 src/data/lv_lab.art0000}
   {SCR ART_SCR_0000 src/data/lv_scr.art0000}
   {SKY ART_SKY_0000 src/data/lv_sky.art0000}
   {SKY_3 ART_SKY3_0000 src/data/lv_sky_3.art0000}
   {special ART_special_0000 src/data/lv_special.art0000}
}

set ::pal3_specs {
   {GHZ LVPAL3_GHZ src/data/lv_ghz.pal3}
   {BRI LVPAL3_BRI src/data/lv_bri.pal3}
   {JUN LVPAL3_JUN src/data/lv_jun.pal3}
   {LAB LVPAL3_LAB src/data/lv_lab_combined_above_water.pal3}
   {SCR LVPAL3_SCR src/data/lv_scr.pal3}
   {SKY LVPAL3_SKY src/data/lv_sky.pal3}
   {SKY_3 LVPAL3_SKY_3 src/data/lv_sky_3.pal3}
   {special LVPAL3_special src/data/lv_special.pal3}
}

proc main {} {
   init_widgets
   init_tilemap_images
}

proc init_widgets {} {
   # Build the omegacanvas
   set ::scroll_px 0
   set ::scroll_py 0
   canvas .canvas -width $::screen_lx -height $::screen_ly
   grid .canvas -sticky nswe
   grid rowconfigure . 0 -weight 1
   grid columnconfigure . 0 -weight 1
}

proc init_tilemap_images {} {
   array set ::tilemap {}
   set dumpx 0
   set dumpy 0
   foreach tms $::tilemap_specs {
      # Retrieve all info we need at the moment
      lassign $tms tm_key tm_label tm_fname
      lassign [lsearch -inline -exact -index 0 $::lvart0_specs $tm_key] _ art0_label art0_fname
      lassign [lsearch -inline -exact -index 0 $::pal3_specs $tm_key] _ pal3_label pal3_fname
      lassign [lsearch -inline -exact -index 0 $::tilemap_specs $tm_key] _ tilemap_label tilemap_fname

      # Load the palette
      set fp [open $pal3_fname rb]
      try {
         binary scan [read $fp 32] cu* pal
      } finally {
         close $fp
      }
      # Convert palette
      # And yes, I know it's faster to do a PPM image and load it raw, but I *am* running this on a supercomputer.
      for {set i 0} {$i < 32} {incr i} {
         set v [lindex $pal $i]
         set cr [expr {(($v>>0)&0x3)*0x5}]
         set cg [expr {(($v>>2)&0x3)*0x5}]
         set cb [expr {(($v>>4)&0x3)*0x5}]
         lset pal $i [format "#%01x%01x%01x" $cr $cg $cb]
      }

      # Load the tilemap
      set fp [open $tilemap_fname rb]
      try {
         binary scan [read $fp] cu* tilemap
      } finally {
         close $fp
      }

      # Load the tileset
      # We don't care about transparency here, I don't need correct rendering of tiles in front of objects.
      set fp [open $art0_fname rb]
      try {
         binary scan [read $fp 8] a2sususu a_magic a_ptr_offsets a_ptr_literals a_rowcount
         if {$a_magic ne "HY"} { error "invalid magic" }
         binary scan [read $fp [expr {$a_ptr_offsets-0x0008}]] cu* masksels
         binary scan [read $fp [expr {$a_ptr_literals-$a_ptr_offsets}]] cu* offsets
         binary scan [read $fp] iu* literals
      } finally {
         close $fp
      }

      # Convert literals
      for {set li 0} {$li < [llength $literals]} {incr li} {
         set v [lindex $literals $li]
         set pixels [list]
         for {set x 0} {$x < 8} {incr x} {
            set p [expr {
               (($v>>7) & 0x01)
               | (($v>>14) & 0x02)
               | (($v>>21) & 0x04)
               | (($v>>28) & 0x08)
            }]
            set p [lindex $pal $p]
            lappend pixels $p
            set v [expr {($v&0x7F7F7F7F)<<1}]
         }
         lset literals $li $pixels
      }

      # Decompress!
      set mask 1
      set mi 0
      # LSbit first, 0=literal 1=offset
      # Offsets 0xF0 up are in the form Fx yy for $xyy and offsets are absolute
      set li 0
      set oi 0
      set tiledata [list]
      for {set ri 0} {$ri < $a_rowcount} {incr ri} {
         if {$mask <= 1} {
            if {$mask < 1} { error "BUG - mask broke" }
            set mask [expr {0x100+[lindex $masksels $mi]}]
            incr mi
         }
         if {($mask & 1) == 0} {
            # Literal
            lappend tiledata [lindex $literals $li]
            incr li
         } else {
            # Copy
            set v [lindex $offsets $oi]
            incr oi
            if {$v >= 0xF0} {
               set v [expr {(($v&0xF)<<8) + [lindex $offsets $oi]}]
               incr oi
            }
            if {$v >= $li} { error "unexpected late offset" }
            lappend tiledata [lindex $literals $v]
         }
         set mask [expr {$mask>>1}]
      }

      # Load the tilemap
      set tmap {}
      for {set toffs 0} {$toffs < [llength $tilemap]} {incr toffs 16} {
         set mt [lrange $tilemap $toffs [expr {$toffs+16-1}]]
         set img [image create photo -width 32 -height 32]
         set mtsubi 0
         for {set y 0} {$y < 32} {incr y 8} {
            for {set x 0} {$x < 32} {incr x 8} {
               set ti [expr {8*[lindex $mt $mtsubi]}]
               incr mtsubi
               set d [lrange $tiledata $ti [expr {$ti+8-1}]]
               $img put $d -to $x $y
            }
         }
         lappend tmap $img
      }

      # TEST: Dump tile data into the canvas
      foreach img $tmap {
         .canvas create image $dumpx $dumpy -image $img -anchor nw
         incr dumpy 32
         if {$dumpy > $::screen_ly-32} {
            set dumpy 0
            incr dumpx 32
         }
      }
   }
}

main {*}$argv
