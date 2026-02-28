#!/usr/bin/env tclsh

package require Tk 8.6
tk appname "stitchview"
wm title . "stitch-view"

# I have a 4K monitor, this will be just fine.
set ::screen_lx 2560
set ::screen_ly 1920

set ::layout_boxes {
   {LVLAYOUT_GHZ1_ENDING 0x0040 0x18C0 0x0020 0x0140 -4 317}
   {LVLAYOUT_GHZ2 0x0001 0x0CA0 0x0001 0x0340 0 8}
   {LVLAYOUT_GHZ3 0x0001 0x0A00 0x00E8 0x0340 -18 0}
   {LVLAYOUT_BRI1 0x0001 0x1F00 0x0001 0x0140 -6 -8}
   {LVLAYOUT_BRI2 0x0001 0x0F00 0x0001 0x0340 -16 -18}
   {LVLAYOUT_BRI3 0x0001 0x0F00 0x0300 0x0340 0 14}
   {LVLAYOUT_JUN1 0x0001 0x1F00 0x0001 0x0120 -6 -9}
   {LVLAYOUT_JUN2_special_4_8 0x0001 0x0100 0x0001 0x1F20 -6 -243}
   {LVLAYOUT_JUN3 0x0001 0x0700 0x0001 0x0480 0 113}
   {LVLAYOUT_LAB1 0x0001 0x0700 0x0001 0x0740 0 0}
   {LVLAYOUT_LAB2 0x0001 0x0700 0x0001 0x0740 0 -2}
   {LVLAYOUT_LAB3 0x0001 0x0700 0x0001 0x0740 0 -25}
   {LVLAYOUT_SCR1 0x0001 0x1E00 0x0001 0x0120 -19 13}
   {LVLAYOUT_SCR2_main 0x0001 0x0F00 0x0001 0x0340 -13 -14}
   {LVLAYOUT_SCR2_upper 0x0001 0x0700 0x0001 0x0740 -4 -58}
   {LVLAYOUT_SCR2_lower 0x0001 0x0300 0x0001 0x0AA0 -64 82}
   {LVLAYOUT_SCR3 0x0001 0x0700 0x0220 0x0740 15 -106}
   {LVLAYOUT_SKY1 0x0001 0x0F00 0x0001 0x0340 -18 -44}
   {LVLAYOUT_SKY2 0x0001 0x0700 0x0001 0x0640 -24 -20}
   {LVLAYOUT_SKY3_endof_SKY2 0x0001 0x0700 0x0001 0x0120 0 0}
}
# {LVLAYOUT_SKY3_endof_SKY2 0x0001 0x0700 0x0001 0x0740}

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
}
# {LVLAYOUT_SPECIAL_1_2_3_5_6_7 src/data/lv_special_1_2_3_5_6_7.layout6 special}

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
   puts "widgets: [time { init_widgets }]"
   puts "tilemap images: [time { init_tilemap_images }]"
   puts "levels: [time { init_levels }]"
}

proc init_widgets {} {
   # Build the omegacanvas
   set ::scroll_px 0
   set ::scroll_py 0
   canvas .canvas -width $::screen_lx -height $::screen_ly
   grid .canvas -sticky nswe
   grid rowconfigure . 0 -weight 1
   grid columnconfigure . 0 -weight 1

   set ::drag_pos {}
   set ::drag_tag {}
   set ::drag_accum_dx 16
   set ::drag_accum_dy 16
   bind .canvas <ButtonPress-1> { on_drag_start %x %y }
   bind .canvas <ButtonRelease-1> { on_drag_stop %x %y }
   bind .canvas <Motion> { on_drag_step %x %y }
}

proc on_drag_start {x y} {
   set ::drag_pos [list $x $y]
   set pick_item [.canvas find overlapping $x $y $x $y]
   set ::drag_tag {}
   set ::drag_accum_dx 16
   set ::drag_accum_dy 16
   set ::drag_dx_count 0
   set ::drag_dy_count 0
   if {$pick_item ne {}} {
      set pick_item [lindex $pick_item 0]
      set ::drag_tag [lindex [.canvas itemcget $pick_item -tags] 0]
      #puts "tag <$::drag_tag>"
   }
   #puts "pick <$pick_item>"
}

proc on_drag_stop {x y} {
   if {$::drag_tag ne {}} {
      puts "drag counts $::drag_dx_count $::drag_dy_count"
   }
   set ::drag_pos {}
}

proc on_drag_step {x y} {
   if {$::drag_pos ne {}} {
      lassign $::drag_pos old_x old_y
      set dx [expr {$x-$old_x}]
      set dy [expr {$y-$old_y}]
      set ::drag_pos [list $x $y]
      if {$::drag_tag ne {}} {
         incr ::drag_accum_x $dx
         incr ::drag_accum_y $dy
         set dx 0
         set dy 0
         while {$::drag_accum_x < 0} {
            incr dx -32
            incr ::drag_dx_count -1
            incr ::drag_accum_x 32
         }
         while {$::drag_accum_y < 0} {
            incr dy -32
            incr ::drag_dy_count -1
            incr ::drag_accum_y 32
         }
         while {$::drag_accum_x >= 32} {
            incr dx 32
            incr ::drag_dx_count 1
            incr ::drag_accum_x -32
         }
         while {$::drag_accum_y >= 32} {
            incr dy 32
            incr ::drag_dy_count 1
            incr ::drag_accum_y -32
         }
         .canvas move $::drag_tag $dx $dy
      } else {
         .canvas move all $dx $dy
      }
   }
}

proc init_tilemap_images {} {
   array set ::tilemaps {}

   # Load ring art
   set fp [open src/data/ringart_00.ringart rb]
   try {
      binary scan [read $fp 128] iu* ringdata
   } finally {
      close $fp
   }

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

      # Insert ring data
      for {set i 0} {$i < 32} {incr i} {
         lset tiledata [expr {(0xFC*8)+$i}] [lindex $ringdata $i]
      }

      # Convert data
      for {set i 0} {$i < [llength $tiledata]} {incr i} {
         set v [lindex $tiledata $i]
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
         lset tiledata $i $pixels
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

      # Save this tilemap for use
      set ::tilemaps($tm_key) $tmap
   }
}

proc init_levels {} {
   set ::min_layout_x [expr {0x20000}]
   set ::max_layout_x [expr {-0x10000}]
   set ::min_layout_y [expr {0x20000}]
   set ::max_layout_y [expr {-0x10000}]
   set ::next_layout_row_y 0
   set ::next_layout_x 0
   set ::next_layout_y 0
   foreach lbs $::layout_boxes { load_level_layout $lbs }
   #load_level_layout [lindex $::layout_specs 0]
   puts [format "end X: %04X (%5d)" $::next_layout_x $::next_layout_x]
   puts [format "end Y: %04X (%5d) mt=%3d" $::next_layout_y $::next_layout_y [expr {$::next_layout_y>>5}]]
   puts [format "min X: %04X (%5d)" $::min_layout_x $::min_layout_x]
   puts [format "max X: %04X (%5d)" $::max_layout_x $::max_layout_x]
   puts [format "min Y: %04X (%5d)" $::min_layout_y $::min_layout_y]
   puts [format "max Y: %04X (%5d)" $::max_layout_y $::max_layout_y]

   # Move the view down to suit the first level
   .canvas move all 0 [expr {-32*[lindex $::layout_boxes 0 6]}]
}

proc load_level_layout {lbs} {
   lassign $lbs ls_key x0 x1 y0 y1 delta_mt_x delta_mt_y
   lassign [lsearch -inline -exact -index 0 $::layout_specs $ls_key] _ ls_fname tm_key
   set tilemap $::tilemaps($tm_key)
   set width_shift [string index $ls_fname end]
   set width_mt [expr {1<<$width_shift}]
   set height_mt [expr {4096>>$width_shift}]
   set width_px [expr {$width_mt*32}]
   set height_px [expr {$height_mt*32}]

   # Apply offset
   incr ::next_layout_x [expr {$delta_mt_x*32}]
   incr ::next_layout_y [expr {$delta_mt_y*32}]
   #incr ::next_layout_row_y [expr {$delta_mt_y*32}]

   # Adjust virtual width + height
   set x0_mt [expr {$x0>>5}]
   set y0_mt [expr {$y0>>5}]
   set x1_mt [expr {(($x1+256-1)>>5)+1}]
   set y1_mt [expr {(($y1+192-1)>>5)+1}]
   set x0_px [expr {$x0_mt<<5}]
   set y0_px [expr {$y0_mt<<5}]
   set x1_px [expr {$x1_mt<<5}]
   set y1_px [expr {$y1_mt<<5}]
   set vwidth_mt [expr {$x1_mt-$x0_mt}]
   set vheight_mt [expr {$y1_mt-$y0_mt}]
   set vwidth_px [expr {$vwidth_mt*32}]
   set vheight_px [expr {$vheight_mt*32}]

   if {$::next_layout_x+$vwidth_px > 0x10000} {
      set ::next_layout_x 0
      set ::next_layout_y $::next_layout_row_y
   }
   set base_x $::next_layout_x
   set base_y $::next_layout_y
   set ::next_layout_row_y [expr {max($::next_layout_row_y, $base_y+$vheight_px)}]
   puts "$ls_key $tm_key $width_mt $height_mt $vwidth_mt $vheight_mt $base_x $base_y"

   # Load the data
   set fp [open $ls_fname rb]
   try {
      binary scan [read $fp] cu* cmpdata
   } finally {
      close $fp
   }

   # Decompress the data
   set uncdata [list]
   set rle_prev -1
   set rle_pending 0
   foreach b $cmpdata {
      if {$rle_pending} {
         # Handle the special case
         if {$b == 0} { incr b 256 }
         lappend uncdata {*}[lrepeat $b $rle_prev]
         set rle_pending 0
         set rle_prev -1
      } elseif {$b != $rle_prev} {
         lappend uncdata $b
         set rle_prev $b
      } else {
         set rle_pending 1
      }
   }

   #puts [llength $uncdata]
   # Pad that one 2 KB level (SCR2 lower) to 4 KB
   while {[llength $uncdata] < 4096} {
      lappend uncdata 0
   }

   # Put it on the canvas!
   set ti 0
   set eff_width_px 0
   for {set py 0} {$py < $height_px} {incr py 32} {
      for {set px 0} {$px < $width_px} {incr px 32} {
         set v [lindex $uncdata $ti]
         incr ti
         if {$py >= $y0_px && $py < $y1_px} {
            if {$px >= $x0_px && $px < $x1_px} {
               if {$v != 0} {
                  set eff_width_px [expr {max($eff_width_px, $px-$x0_px+32)}]
                  set ::min_layout_x [expr {min($::min_layout_x, $base_x+$px+$x0_px)}]
                  set ::max_layout_x [expr {max($::max_layout_x, $base_x+$px+$x0_px+32)}]
                  set ::min_layout_y [expr {min($::min_layout_y, $base_y+$py+$y0_px)}]
                  set ::max_layout_y [expr {max($::max_layout_y, $base_y+$py+$y0_px+32)}]
                  .canvas create image [expr {$base_x+$px-$x0_px}] [expr {$base_y+$py-$y0_px}] -image [lindex $tilemap $v] -tags [list $ls_key]
               }
            }
         }
      }
   }
   incr ::next_layout_x $eff_width_px
}

main {*}$argv
