objfunc_00_sonic:
   res    1, (iy+iy_08_lvflag03-IYBASE)  ; 01:48C8 - FD CB 08 8E
   bit    7, (ix+24)                   ; 01:48CC - DD CB 18 7E
   call   nz, @fn_set_was_on_ground_bit  ; 01:48D0 - C4 88 4E
   set    7, (iy+iy_07_lvflag02-IYBASE)  ; 01:48D3 - FD CB 07 FE
   bit    0, (iy+iy_05_lvflag00-IYBASE)  ; 01:48D7 - FD CB 05 46
   jp     nz, @sonic_is_dying          ; 01:48DB - C2 3C 54
   ld     a, (sonic_brake_sound_cooldown_timer_ix_22)  ; 01:48DE - 3A 12 D4
   and    a                            ; 01:48E1 - A7
   call   nz, @fn_handle_brake_sound_cooldown_timer  ; 01:48E2 - C4 F0 4F
   res    5, (ix+24)                   ; 01:48E5 - DD CB 18 AE
   bit    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:48E9 - FD CB 06 76
   call   nz, @fn_handle_damage_stun_and_input_suppression  ; 01:48ED - C4 0A 51
   ld     a, (g_directional_input_suppression_timer)  ; 01:48F0 - 3A 8C D2
   and    a                            ; 01:48F3 - A7
   call   nz, @fn_enforce_directional_input_suppression  ; 01:48F4 - C4 8F 56
   bit    0, (iy+iy_07_lvflag02-IYBASE)  ; 01:48F7 - FD CB 07 46
   call   nz, @fn_forbid_rolling_in_special_stage  ; 01:48FB - C4 00 51
   bit    0, (iy+iy_08_lvflag03-IYBASE)  ; 01:48FE - FD CB 08 46
   call   nz, @fn_handle_invincibility  ; 01:4902 - C4 F5 4F
   bit    4, (ix+24)                   ; 01:4905 - DD CB 18 66
   call   nz, @fn_handle_air_timer_and_drowning  ; 01:4909 - C4 09 50
   ld     a, (g_chaos_emerald_music_countdown_timer)  ; 01:490C - 3A 8B D2
   and    a                            ; 01:490F - A7
   call   nz, @fn_handle_chaos_emerald_music_countdown_timer  ; 01:4910 - C4 85 52
   ld     a, (g_teleport_start_countdown_timer)  ; 01:4913 - 3A 8A D2
   and    a                            ; 01:4916 - A7
   jp     nz, @handle_teleport_start   ; 01:4917 - C2 17 51
   bit    6, (iy+iy_08_lvflag03-IYBASE)  ; 01:491A - FD CB 08 76
   jp     nz, @handle_ending_animation_teleport_in  ; 01:491E - C2 93 51
   bit    7, (iy+iy_08_lvflag03-IYBASE)  ; 01:4921 - FD CB 08 7E
   call   nz, @fn_handle_good_ending_sequence  ; 01:4925 - C4 9C 52
   bit    4, (ix+24)                   ; 01:4928 - DD CB 18 66
   jp     z, @not_underwater_physics   ; 01:492C - CA 4F 49
   ld     hl, objfunc_00_sonic@sonic_physics_underwater  ; 01:492F - 21 DD 4D
   ld     de, tmp_00                   ; 01:4932 - 11 0E D2
   ld     bc, $0009                    ; 01:4935 - 01 09 00
   ldir                                ; 01:4938 - ED B0
   ld     hl, $0100                    ; 01:493A - 21 00 01
   ld     (g_sonic_x_speed_cap_subpx), hl  ; 01:493D - 22 40 D2
   ld     hl, $FD80                    ; 01:4940 - 21 80 FD
   ld     (g_sonic_y_jump_velocity), hl  ; 01:4943 - 22 42 D2
   ld     hl, $0010                    ; 01:4946 - 21 10 00
   ld     (g_sonic_y_gravity_acceleration), hl  ; 01:4949 - 22 44 D2
   jp     @physics_selected            ; 01:494C - C3 D9 49

@not_underwater_physics:
   ld     a, (ix+21)                   ; 01:494F - DD 7E 15
   and    a                            ; 01:4952 - A7
   jr     nz, @is_speed_shoes_physics  ; 01:4953 - 20 58
   bit    0, (iy+iy_07_lvflag02-IYBASE)  ; 01:4955 - FD CB 07 46
   jr     nz, @is_special_stage_air_physics  ; 01:4959 - 20 26

@is_normal_physics:
   ld     hl, objfunc_00_sonic@sonic_physics_main  ; 01:495B - 21 CB 4D
   ld     de, tmp_00                   ; 01:495E - 11 0E D2
   ld     bc, $0009                    ; 01:4961 - 01 09 00
   ldir                                ; 01:4964 - ED B0
   ld     hl, $0300                    ; 01:4966 - 21 00 03
   ld     (g_sonic_x_speed_cap_subpx), hl  ; 01:4969 - 22 40 D2
   ld     hl, $FC80                    ; 01:496C - 21 80 FC
   ld     (g_sonic_y_jump_velocity), hl  ; 01:496F - 22 42 D2
   ld     hl, $0038                    ; 01:4972 - 21 38 00
   ld     (g_sonic_y_gravity_acceleration), hl  ; 01:4975 - 22 44 D2
   ld     hl, (snd_music_saved_tick_tempo)  ; 01:4978 - 2A 0C DC
   ld     (snd_music_tick_tempo), hl   ; 01:497B - 22 0A DC
   jp     @physics_selected            ; 01:497E - C3 D9 49

@is_special_stage_air_physics:
   bit    7, (ix+24)                   ; 01:4981 - DD CB 18 7E
   jr     nz, @is_normal_physics       ; 01:4985 - 20 D4
   ld     hl, objfunc_00_sonic@sonic_physics_special_stage_airborne  ; 01:4987 - 21 D4 4D
   ld     de, tmp_00                   ; 01:498A - 11 0E D2
   ld     bc, $0009                    ; 01:498D - 01 09 00
   ldir                                ; 01:4990 - ED B0
   ld     hl, $0C00                    ; 01:4992 - 21 00 0C
   ld     (g_sonic_x_speed_cap_subpx), hl  ; 01:4995 - 22 40 D2
   ld     hl, $FC80                    ; 01:4998 - 21 80 FC
   ld     (g_sonic_y_jump_velocity), hl  ; 01:499B - 22 42 D2
   ld     hl, $0038                    ; 01:499E - 21 38 00
   ld     (g_sonic_y_gravity_acceleration), hl  ; 01:49A1 - 22 44 D2
   ld     hl, (snd_music_saved_tick_tempo)  ; 01:49A4 - 2A 0C DC
   ld     (snd_music_tick_tempo), hl   ; 01:49A7 - 22 0A DC
   jp     @physics_selected            ; 01:49AA - C3 D9 49

@is_speed_shoes_physics:
   ld     hl, objfunc_00_sonic@sonic_physics_speed_shoes  ; 01:49AD - 21 E6 4D
   ld     de, tmp_00                   ; 01:49B0 - 11 0E D2
   ld     bc, $0009                    ; 01:49B3 - 01 09 00
   ldir                                ; 01:49B6 - ED B0
   ld     hl, $0600                    ; 01:49B8 - 21 00 06
   ld     (g_sonic_x_speed_cap_subpx), hl  ; 01:49BB - 22 40 D2
   ld     hl, $FC80                    ; 01:49BE - 21 80 FC
   ld     (g_sonic_y_jump_velocity), hl  ; 01:49C1 - 22 42 D2
   ld     hl, $0038                    ; 01:49C4 - 21 38 00
   ld     (g_sonic_y_gravity_acceleration), hl  ; 01:49C7 - 22 44 D2
   ld     hl, (snd_music_saved_tick_tempo)  ; 01:49CA - 2A 0C DC
   inc    hl                           ; 01:49CD - 23
   ld     (snd_music_tick_tempo), hl   ; 01:49CE - 22 0A DC
   ld     a, (g_global_tick_counter)   ; 01:49D1 - 3A 23 D2
   and    $03                          ; 01:49D4 - E6 03
   call   z, @fn_handle_speed_shoes_timer  ; 01:49D6 - CC EC 4F

@physics_selected:
   bit    1, (iy+g_inputs_player_1-IYBASE)  ; 01:49D9 - FD CB 03 4E
   call   z, @fn_try_to_roll           ; 01:49DD - CC C1 50
   bit    1, (iy+g_inputs_player_1-IYBASE)  ; 01:49E0 - FD CB 03 4E
   call   nz, @fn_clear_extra_rolling_flag_SEMIVESTIGIAL  ; 01:49E4 - C4 E3 50
   ld     bc, $000C                    ; 01:49EF - 01 0C 00
   ld     de, $0010                    ; 01:49F2 - 11 10 00
   call   get_obj_level_tile_ptr_in_ram  ; 01:49F5 - CD F9 36
   ld     e, (hl)                      ; 01:49F8 - 5E
   ld a, (g_tile_flags_index)
   ld d, a
   add a, a
   add a, d
   ld d, $00
   ld     l, a                         ; 01:49FF - 6F
   ld     h, d                         ; 01:4A00 - 62
   ld a, :level_specials
   call set_rompage_2
   ld     bc, level_specials           ; 01:4A01 - 01 ED B9
   add    hl, bc                       ; 01:4A04 - 09
   push de
   ld e, (hl)
   inc hl
   ld d, (hl)
   inc hl
   ld a, (hl)
   call set_rompage_2
   ex de, hl
   pop de
   add    hl, de                       ; 01:4A09 - 19
   ld     a, (hl)                      ; 01:4A0B - 7E
   cp     $1C                          ; 01:4A0C - FE 1C
   jr     nc, objfunc_00_sonic@return_from_tile_special  ; 01:4A0E - 30 18
   add    a, a                         ; 01:4A10 - 87
   ld     l, a                         ; 01:4A11 - 6F
   ld     h, d                         ; 01:4A12 - 62
   ld     de, CODEPTRTAB_sonic_tile_specials  ; 01:4A13 - 11 E5 58
   add    hl, de                       ; 01:4A16 - 19
   ld     a, (hl)                      ; 01:4A17 - 7E
   inc    hl                           ; 01:4A18 - 23
   ld     h, (hl)                      ; 01:4A19 - 66
   ld     l, a                         ; 01:4A1A - 6F
   ld     de, objfunc_00_sonic@return_from_tile_special  ; 01:4A1B - 11 28 4A
   ld     a, $02                       ; 01:4A1E - 3E 02
   call set_rompage_2
   push   de                           ; 01:4A26 - D5
   jp     (hl)                         ; 01:4A27 - E9

@return_from_tile_special:
   ld     hl, (sonic_y)                ; 01:4A28 - 2A 01 D4
   ld     de, $0024                    ; 01:4A2B - 11 24 00
   add    hl, de                       ; 01:4A2E - 19
   ex     de, hl                       ; 01:4A2F - EB
   ld     hl, (g_level_limit_y1)       ; 01:4A30 - 2A 79 D2
   ld     bc, $00C0                    ; 01:4A33 - 01 C0 00
   add    hl, bc                       ; 01:4A36 - 09
   xor    a                            ; 01:4A37 - AF
   sbc    hl, de                       ; 01:4A38 - ED 52
   call   c, kill_sonic                ; 01:4A3A - DC 18 36
   ld     hl, $0000                    ; 01:4A3D - 21 00 00
   ld     a, (iy+g_inputs_player_1-IYBASE)  ; 01:4A40 - FD 7E 03
   cp     $FF                          ; 01:4A43 - FE FF
   jr     nz, @sonic_not_bored         ; 01:4A45 - 20 12
   ld     de, (sonic_vel_x_sub)        ; 01:4A47 - ED 5B 03 D4
   ld     a, e                         ; 01:4A4B - 7B
   or     d                            ; 01:4A4C - B2
   jr     nz, @sonic_not_bored         ; 01:4A4D - 20 0A
   ld     a, (sonic_flags_ix_24)       ; 01:4A4F - 3A 14 D4
   rlca                                ; 01:4A52 - 07
   jr     nc, @sonic_not_bored         ; 01:4A53 - 30 04
   ld     hl, (g_sonic_bored_anim_countup_timer)  ; 01:4A55 - 2A 99 D2
   inc    hl                           ; 01:4A58 - 23

@sonic_not_bored:
   ld     (g_sonic_bored_anim_countup_timer), hl  ; 01:4A59 - 22 99 D2
   bit    7, (iy+iy_06_lvflag01-IYBASE)  ; 01:4A5C - FD CB 06 7E
   call   nz, @fn_set_underwater_state_based_on_water_level  ; 01:4A60 - C4 E8 50
   ld     (ix+20), $05                 ; 01:4A63 - DD 36 14 05
   ld     hl, (g_sonic_bored_anim_countup_timer)  ; 01:4A67 - 2A 99 D2
   ld     de, $0168                    ; 01:4A6A - 11 68 01
   and    a                            ; 01:4A6D - A7
   sbc    hl, de                       ; 01:4A6E - ED 52
   call   nc, @fn_handle_sonic_bored_anim  ; 01:4A70 - D4 05 51
   ld     a, (iy+g_inputs_player_1-IYBASE)  ; 01:4A73 - FD 7E 03
   cp     $FE                          ; 01:4A76 - FE FE
   call   z, @fn_camera_look_up        ; 01:4A78 - CC DD 4E
   bit    0, (iy+g_inputs_player_1-IYBASE)  ; 01:4A7B - FD CB 03 46
   call   nz, @fn_restore_camera_look  ; 01:4A7F - C4 D3 4F
   bit    0, (ix+24)                   ; 01:4A82 - DD CB 18 46
   jp     nz, @sonic_is_rolling        ; 01:4A86 - C2 2E 53
   ld     a, (ix+14)                   ; 01:4A89 - DD 7E 0E
   cp     $20                          ; 01:4A8C - FE 20
   jr     z, @skip_adjust_y_pos_after_roll  ; 01:4A8E - 28 0A
   ld     hl, (sonic_y)                ; 01:4A90 - 2A 01 D4
   ld     de, $FFF8                    ; 01:4A93 - 11 F8 FF
   add    hl, de                       ; 01:4A96 - 19
   ld     (sonic_y), hl                ; 01:4A97 - 22 01 D4

@skip_adjust_y_pos_after_roll:
   ld     (ix+13), $18                 ; 01:4A9A - DD 36 0D 18
   ld     (ix+14), $20                 ; 01:4A9E - DD 36 0E 20
   ld     hl, (sonic_vel_x_sub)        ; 01:4AA2 - 2A 03 D4
   ld     b, (ix+9)                    ; 01:4AA5 - DD 46 09
   ld     c, $00                       ; 01:4AA8 - 0E 00
   ld     e, c                         ; 01:4AAA - 59
   ld     d, c                         ; 01:4AAB - 51
   bit    3, (iy+g_inputs_player_1-IYBASE)  ; 01:4AAC - FD CB 03 5E
   jp     z, @handle_right_input       ; 01:4AB0 - CA 01 4F
   bit    2, (iy+g_inputs_player_1-IYBASE)  ; 01:4AB3 - FD CB 03 56
   jp     z, @handle_left_input        ; 01:4AB7 - CA 5C 4F
   ld     a, h                         ; 01:4ABA - 7C
   or     l                            ; 01:4ABB - B5
   or     b                            ; 01:4ABC - B0
   jr     z, @update_x_velocity_from_basic_movement  ; 01:4ABD - 28 5C
   ld     (ix+20), $01                 ; 01:4ABF - DD 36 14 01
   bit    7, b                         ; 01:4AC3 - CB 78
   jr     nz, @consider_coasting_x_speed_cap_moving_left  ; 01:4AC5 - 20 30
   ld     de, (tmp_04)                 ; 01:4AC7 - ED 5B 12 D2
   ld     a, e                         ; 01:4ACB - 7B
   cpl                                 ; 01:4ACC - 2F
   ld     e, a                         ; 01:4ACD - 5F
   ld     a, d                         ; 01:4ACE - 7A
   cpl                                 ; 01:4ACF - 2F
   ld     d, a                         ; 01:4AD0 - 57
   inc    de                           ; 01:4AD1 - 13
   ld     c, $FF                       ; 01:4AD2 - 0E FF
   push   hl                           ; 01:4AD4 - E5
   push   de                           ; 01:4AD5 - D5
   ld     de, (g_sonic_x_speed_cap_subpx)  ; 01:4AD6 - ED 5B 40 D2
   xor    a                            ; 01:4ADA - AF
   sbc    hl, de                       ; 01:4ADB - ED 52
   pop    de                           ; 01:4ADD - D1
   pop    hl                           ; 01:4ADE - E1
   jr     c, @update_x_velocity_from_basic_movement  ; 01:4ADF - 38 3A
   ld     de, (tmp_00)                 ; 01:4AE1 - ED 5B 0E D2
   ld     a, e                         ; 01:4AE5 - 7B
   cpl                                 ; 01:4AE6 - 2F
   ld     e, a                         ; 01:4AE7 - 5F
   ld     a, d                         ; 01:4AE8 - 7A
   cpl                                 ; 01:4AE9 - 2F
   ld     d, a                         ; 01:4AEA - 57
   inc    de                           ; 01:4AEB - 13
   ld     c, $FF                       ; 01:4AEC - 0E FF
   ld     a, (tmp_08)                  ; 01:4AEE - 3A 16 D2
   ld     (ix+20), a                   ; 01:4AF1 - DD 77 14
   jp     @update_x_velocity_from_basic_movement  ; 01:4AF4 - C3 1B 4B

@consider_coasting_x_speed_cap_moving_left:
   ld     de, (tmp_04)                 ; 01:4AF7 - ED 5B 12 D2
   ld     c, $00                       ; 01:4AFB - 0E 00
   push   hl                           ; 01:4AFD - E5
   push   de                           ; 01:4AFE - D5
   ld     a, l                         ; 01:4AFF - 7D
   cpl                                 ; 01:4B00 - 2F
   ld     l, a                         ; 01:4B01 - 6F
   ld     a, h                         ; 01:4B02 - 7C
   cpl                                 ; 01:4B03 - 2F
   ld     h, a                         ; 01:4B04 - 67
   inc    hl                           ; 01:4B05 - 23
   ld     de, (g_sonic_x_speed_cap_subpx)  ; 01:4B06 - ED 5B 40 D2
   xor    a                            ; 01:4B0A - AF
   sbc    hl, de                       ; 01:4B0B - ED 52
   pop    de                           ; 01:4B0D - D1
   pop    hl                           ; 01:4B0E - E1
   jr     c, @update_x_velocity_from_basic_movement  ; 01:4B0F - 38 0A
   ld     de, (tmp_00)                 ; 01:4B11 - ED 5B 0E D2
   ld     a, (tmp_08)                  ; 01:4B15 - 3A 16 D2
   ld     (ix+20), a                   ; 01:4B18 - DD 77 14

@update_x_velocity_from_basic_movement:
   ld     a, b                         ; 01:4B1B - 78
   and    a                            ; 01:4B1C - A7
   jp     m, @update_x_velocity_moving_left  ; 01:4B1D - FA 38 4B
   add    hl, de                       ; 01:4B20 - 19
   adc    a, c                         ; 01:4B21 - 89
   ld     c, a                         ; 01:4B22 - 4F
   jp     p, @store_updated_x_velocity  ; 01:4B23 - F2 42 4B
   ld     a, (sonic_vel_x_sub)         ; 01:4B26 - 3A 03 D4
   or     (ix+8)                       ; 01:4B29 - DD B6 08
   or     (ix+9)                       ; 01:4B2C - DD B6 09
   jr     z, @store_updated_x_velocity  ; 01:4B2F - 28 11
   ld     c, $00                       ; 01:4B31 - 0E 00
   ld     l, c                         ; 01:4B33 - 69
   ld     h, c                         ; 01:4B34 - 61
   jp     @store_updated_x_velocity    ; 01:4B35 - C3 42 4B

@update_x_velocity_moving_left:
   add    hl, de                       ; 01:4B38 - 19
   adc    a, c                         ; 01:4B39 - 89
   ld     c, a                         ; 01:4B3A - 4F
   jp     m, @store_updated_x_velocity  ; 01:4B3B - FA 42 4B
   ld     c, $00                       ; 01:4B3E - 0E 00
   ld     l, c                         ; 01:4B40 - 69
   ld     h, c                         ; 01:4B41 - 61

@store_updated_x_velocity:
   ld     a, c                         ; 01:4B42 - 79
   ld     (sonic_vel_x_sub), hl        ; 01:4B43 - 22 03 D4
   ld     (sonic_vel_x_hi), a          ; 01:4B46 - 32 05 D4

@update_y_velocity_from_basic_movement:
   ld     hl, (sonic_vel_y_sub)        ; 01:4B49 - 2A 06 D4
   ld     b, (ix+12)                   ; 01:4B4C - DD 46 0C
   ld     c, $00                       ; 01:4B4F - 0E 00
   ld     e, c                         ; 01:4B51 - 59
   ld     d, c                         ; 01:4B52 - 51
   bit    7, (ix+24)                   ; 01:4B53 - DD CB 18 7E
   call   nz, @fn_handle_sonic_landing_SEMIVESTIGIAL  ; 01:4B57 - C4 AF 50
   bit    0, (ix+24)                   ; 01:4B5A - DD CB 18 46
   jp     nz, @update_y_velocity_for_rolling  ; 01:4B5E - C2 07 54
   ld     a, (g_sonic_jump_countdown_timer)  ; 01:4B61 - 3A 8E D2
   and    a                            ; 01:4B64 - A7
   jr     nz, @jump_continue_or_await_release  ; 01:4B65 - 20 12
   bit    7, (ix+24)                   ; 01:4B67 - DD CB 18 7E
   jr     z, @suppress_jump_button     ; 01:4B6B - 28 30
   bit    3, (ix+24)                   ; 01:4B6D - DD CB 18 5E
   jr     nz, @jump_continue_or_await_release  ; 01:4B71 - 20 06
   bit    5, (iy+g_inputs_player_1-IYBASE)  ; 01:4B73 - FD CB 03 6E
   jr     z, @suppress_jump_button     ; 01:4B77 - 28 24

@jump_continue_or_await_release:
   bit    5, (iy+g_inputs_player_1-IYBASE)  ; 01:4B79 - FD CB 03 6E
   jr     nz, @unsuppress_jump_button  ; 01:4B7D - 20 25

@continue_jump_processing_from_rolling:
   ld     a, (g_sonic_jump_countdown_timer)  ; 01:4B7F - 3A 8E D2
   and    a                            ; 01:4B82 - A7
   call   z, @fn_start_jump_timer      ; 01:4B83 - CC 9D 50
   ld     hl, (g_sonic_y_jump_velocity)  ; 01:4B86 - 2A 42 D2
   ld     b, $FF                       ; 01:4B89 - 06 FF
   ld     c, $00                       ; 01:4B8B - 0E 00
   ld     e, c                         ; 01:4B8D - 59
   ld     d, c                         ; 01:4B8E - 51
   ld     a, (g_sonic_jump_countdown_timer)  ; 01:4B8F - 3A 8E D2
   dec    a                            ; 01:4B92 - 3D
   ld     (g_sonic_jump_countdown_timer), a  ; 01:4B93 - 32 8E D2
   set    2, (ix+24)                   ; 01:4B96 - DD CB 18 D6
   jp     @continue_without_applying_gravity  ; 01:4B9A - C3 BE 4B

@suppress_jump_button:
   res    3, (ix+24)                   ; 01:4B9D - DD CB 18 9E
   jp     @stop_jump_timer             ; 01:4BA1 - C3 A8 4B

@unsuppress_jump_button:
   set    3, (ix+24)                   ; 01:4BA4 - DD CB 18 DE

@stop_jump_timer:
   xor    a                            ; 01:4BA8 - AF
   ld     (g_sonic_jump_countdown_timer), a  ; 01:4BA9 - 32 8E D2

@continue_without_jumping_from_rolling:
   bit    7, h                         ; 01:4BAC - CB 7C
   jr     nz, @apply_gravity           ; 01:4BAE - 20 08
   ld     a, (tmp_07)                  ; 01:4BB0 - 3A 15 D2
   cp     h                            ; 01:4BB3 - BC
   jr     z, @continue_without_applying_gravity  ; 01:4BB4 - 28 08
   jr     c, @continue_without_applying_gravity  ; 01:4BB6 - 38 06

@apply_gravity:
   ld     de, (g_sonic_y_gravity_acceleration)  ; 01:4BB8 - ED 5B 44 D2
   ld     c, $00                       ; 01:4BBC - 0E 00

@continue_without_applying_gravity:
   add    hl, de                       ; 01:4BD6 - 19
   ld     a, b                         ; 01:4BD7 - 78
   adc    a, c                         ; 01:4BD8 - 89
   ld     (sonic_vel_y_sub), hl        ; 01:4BD9 - 22 06 D4
   ld     (sonic_vel_y_hi), a          ; 01:4BDC - 32 08 D4
   push   hl                           ; 01:4BDF - E5
   ld     a, e                         ; 01:4BE0 - 7B
   cpl                                 ; 01:4BE1 - 2F
   ld     l, a                         ; 01:4BE2 - 6F
   ld     a, d                         ; 01:4BE3 - 7A
   cpl                                 ; 01:4BE4 - 2F
   ld     h, a                         ; 01:4BE5 - 67
   ld     a, c                         ; 01:4BE6 - 79
   cpl                                 ; 01:4BE7 - 2F
   ld     de, $0001                    ; 01:4BE8 - 11 01 00
   add    hl, de                       ; 01:4BEB - 19
   adc    a, $00                       ; 01:4BEC - CE 00
   ld     (g_sonic_bounce_vel_y_sub), hl  ; 01:4BEE - 22 E6 D2
   ld     (g_sonic_bounce_vel_y_pix_hi), a  ; 01:4BF1 - 32 E8 D2
   pop    hl                           ; 01:4BF4 - E1
   bit    2, (ix+24)                   ; 01:4BF5 - DD CB 18 56
   call   nz, @fn_set_roll_animation_for_airborne  ; 01:4BF9 - C4 80 52
   ld     a, h                         ; 01:4BFC - 7C
   and    a                            ; 01:4BFD - A7
   jp     p, @skip_negating_y_vel_for_absolute_value  ; 01:4BFE - F2 08 4C
   ld     a, h                         ; 01:4C01 - 7C
   cpl                                 ; 01:4C02 - 2F
   ld     h, a                         ; 01:4C03 - 67
   ld     a, l                         ; 01:4C04 - 7D
   cpl                                 ; 01:4C05 - 2F
   ld     l, a                         ; 01:4C06 - 6F
   inc    hl                           ; 01:4C07 - 23

@skip_negating_y_vel_for_absolute_value:
   ld     de, $0100                    ; 01:4C08 - 11 00 01
   ex     de, hl                       ; 01:4C0B - EB
   and    a                            ; 01:4C0C - A7
   sbc    hl, de                       ; 01:4C0D - ED 52
   jr     nc, @continue_maybe_without_setting_animation  ; 01:4C0F - 30 17
   ld     a, (sonic_flags_ix_24)       ; 01:4C11 - 3A 14 D4
   and    $85                          ; 01:4C14 - E6 85
   jr     nz, @continue_maybe_without_setting_animation  ; 01:4C16 - 20 10
   bit    7, (ix+12)                   ; 01:4C18 - DD CB 0C 7E
   jr     z, @select_walking_animation  ; 01:4C1C - 28 06
   ld     (ix+20), $13                 ; 01:4C1E - DD 36 14 13
   jr     @continue_maybe_without_setting_animation  ; 01:4C22 - 18 04

@select_walking_animation:
   ld     (ix+20), $01                 ; 01:4C24 - DD 36 14 01

@continue_maybe_without_setting_animation:
   ld     bc, $000C                    ; 01:4C28 - 01 0C 00
   ld     de, $0008                    ; 01:4C2B - 11 08 00
   call   get_obj_level_tile_ptr_in_ram  ; 01:4C2E - CD F9 36
   ld     a, (hl)                      ; 01:4C31 - 7E
   and    $7F                          ; 01:4C32 - E6 7F
   cp     $79                          ; 01:4C34 - FE 79
   call   nc, @fn_try_collect_ring_in_ring_tile  ; 01:4C36 - D4 EF 4D

@continue_past_basic_movement_physics:
   ld     a, (g_directional_input_suppression_timer)  ; 01:4C39 - 3A 8C D2
   and    a                            ; 01:4C3C - A7
   call   nz, @fn_decrement_directional_input_suppression_timer  ; 01:4C3D - C4 B3 51
   bit    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:4C40 - FD CB 06 76
   call   nz, @fn_handle_damage_stun_animation_and_deactivation  ; 01:4C44 - C4 BC 51
   bit    2, (iy+iy_08_lvflag03-IYBASE)  ; 01:4C47 - FD CB 08 56
   call   nz, @fn_handle_consuming_an_air_bubble  ; 01:4C4B - C4 DD 51
   ld     a, (sonic_anim_index_ix_20)  ; 01:4C4E - 3A 10 D4
   cp     $0A                          ; 01:4C51 - FE 0A
   call   z, @fn_throttled_play_brake_sound_effect  ; 01:4C53 - CC F3 51
   ld     l, (ix+20)                   ; 01:4C56 - DD 6E 14
   ld     c, l                         ; 01:4C59 - 4D
   ld     h, $00                       ; 01:4C5A - 26 00
   add    hl, hl                       ; 01:4C5C - 29
   ld     de, LUT_sonic_anim_ptrs      ; 01:4C5D - 11 65 59
   add    hl, de                       ; 01:4C60 - 19
   ld     e, (hl)                      ; 01:4C61 - 5E
   inc    hl                           ; 01:4C62 - 23
   ld     d, (hl)                      ; 01:4C63 - 56
   ld     (sonic_anim_ptr_ix_17), de   ; 01:4C64 - ED 53 0D D4
   ld     a, (g_sonic_prev_anim_idx)   ; 01:4C68 - 3A DF D2
   sub    c                            ; 01:4C6B - 91
   call   nz, @fn_reset_anim_frame_idx_on_anim_change  ; 01:4C6C - C4 1F 52
   ld     a, (sonic_anim_sprite_subindex_ix_19)  ; 01:4C6F - 3A 0F D4

@find_next_anim_frame:
   ld     h, $00                       ; 01:4C72 - 26 00
   ld     l, a                         ; 01:4C74 - 6F
   add    hl, de                       ; 01:4C75 - 19
   ld     a, (hl)                      ; 01:4C76 - 7E
   and    a                            ; 01:4C77 - A7
   jp     p, @found_anim_frame         ; 01:4C78 - F2 83 4C
   inc    hl                           ; 01:4C7B - 23
   ld     a, (hl)                      ; 01:4C7C - 7E
   ld     (sonic_anim_sprite_subindex_ix_19), a  ; 01:4C7D - 32 0F D4
   jp     @find_next_anim_frame        ; 01:4C80 - C3 72 4C

@found_anim_frame:
   ld     d, a                         ; 01:4C83 - 57
   ld     bc, $4000                    ; 01:4C84 - 01 00 40
   bit    1, (ix+24)                   ; 01:4C87 - DD CB 18 4E
   jr     z, @sprite_setting_was_facing_left  ; 01:4C8B - 28 03
   ld     bc, $7000                    ; 01:4C8D - 01 00 70

@sprite_setting_was_facing_left:
   bit    5, (iy+iy_06_lvflag01-IYBASE)  ; 01:4C90 - FD CB 06 6E
   call   nz, @fn_handle_shield_animation  ; 01:4C94 - C4 06 52
   ld     a, (g_sonic_sprite_index_override)  ; 01:4C97 - 3A 02 D3
   and    a                            ; 01:4C9A - A7
   call   nz, @fn_use_left_facing_sonic_sprites  ; 01:4C9B - C4 48 4E
   ld     a, d                         ; 01:4C9E - 7A
   rrca                                ; 01:4C9F - 0F
   rrca                                ; 01:4CA0 - 0F
   rrca                                ; 01:4CA1 - 0F
   ld     e, a                         ; 01:4CA2 - 5F
   and    $E0                          ; 01:4CA3 - E6 E0
   ld     l, a                         ; 01:4CA5 - 6F
   ld     a, e                         ; 01:4CA6 - 7B
   and    $1F                          ; 01:4CA7 - E6 1F
   add    a, d                         ; 01:4CA9 - 82
   ld     h, a                         ; 01:4CAA - 67
   add    hl, bc                       ; 01:4CAB - 09
   ld     (g_new_sonic_sprite_ptr), hl  ; 01:4CAC - 22 8F D2
   ld     hl, SPRITEMAP_sonic_normal   ; 01:4CAF - 21 1D 59
   ld     a, (sonic_anim_index_ix_20)  ; 01:4CB9 - 3A 10 D4
   cp     $13                          ; 01:4CBC - FE 13
   call   z, @fn_use_upspring_sprites  ; 01:4CBE - CC 13 52
   ld     a, (g_sonic_sprite_index_override)  ; 01:4CC1 - 3A 02 D3
   and    a                            ; 01:4CC4 - A7
   call   nz, @fn_suppress_sprite_rendering  ; 01:4CC5 - C4 4D 4E
   ld     (sonic_spritemap_ix_15), hl  ; 01:4CC8 - 22 0B D4
   ld     c, $10                       ; 01:4CCB - 0E 10
   ld     a, (sonic_vel_x)             ; 01:4CCD - 3A 04 D4
   and    a                            ; 01:4CD0 - A7
   jp     p, @hard_cap_x_vel_was_positive  ; 01:4CD1 - F2 D8 4C
   neg                                 ; 01:4CD4 - ED 44
   ld     c, $F0                       ; 01:4CD6 - 0E F0

@hard_cap_x_vel_was_positive:
   cp     $10                          ; 01:4CD8 - FE 10
   jr     c, @skip_hard_cap_x_vel      ; 01:4CDA - 38 04
   ld     a, c                         ; 01:4CDC - 79
   ld     (sonic_vel_x), a             ; 01:4CDD - 32 04 D4

@skip_hard_cap_x_vel:
   ld     c, $10                       ; 01:4CE0 - 0E 10
   ld     a, (sonic_vel_y)             ; 01:4CE2 - 3A 07 D4
   and    a                            ; 01:4CE5 - A7
   jp     p, @hard_cap_y_vel_was_positive  ; 01:4CE6 - F2 ED 4C
   neg                                 ; 01:4CE9 - ED 44
   ld     c, $F0                       ; 01:4CEB - 0E F0

@hard_cap_y_vel_was_positive:
   cp     $10                          ; 01:4CED - FE 10
   jr     c, @skip_hard_cap_y_vel      ; 01:4CEF - 38 04
   ld     a, c                         ; 01:4CF1 - 79
   ld     (sonic_vel_y), a             ; 01:4CF2 - 32 07 D4

@skip_hard_cap_y_vel:
   ld     de, (sonic_y)                ; 01:4CF5 - ED 5B 01 D4
   ld     hl, $0010                    ; 01:4CF9 - 21 10 00
   and    a                            ; 01:4CFC - A7
   sbc    hl, de                       ; 01:4CFD - ED 52
   jr     c, @skip_clamp_sonic_y_pos_top  ; 01:4CFF - 38 04
   add    hl, de                       ; 01:4D01 - 19
   ld     (sonic_y), hl                ; 01:4D02 - 22 01 D4

@skip_clamp_sonic_y_pos_top:
   bit    7, (iy+iy_06_lvflag01-IYBASE)  ; 01:4D05 - FD CB 06 7E
   call   nz, @fn_blow_a_bubble_periodically  ; 01:4D09 - C4 24 52
   bit    0, (iy+iy_08_lvflag03-IYBASE)  ; 01:4D0C - FD CB 08 46
   call   nz, @fn_handle_invincibility_sparkle_sprite  ; 01:4D10 - C4 8D 4E
   ld     a, (g_special_stage_round_bumper_cooldown_timer)  ; 01:4D13 - 3A E1 D2
   and    a                            ; 01:4D16 - A7
   call   nz, @fn_handle_round_bumper_throbbing_effect  ; 01:4D17 - C4 31 52
   ld     a, (g_ring_sparkle_sprite_countdown_timer)  ; 01:4D1A - 3A 21 D3
   and    a                            ; 01:4D1D - A7
   call   nz, @fn_handle_ring_sparkle_sprites  ; 01:4D1E - C4 51 4E
   bit    1, (iy+iy_06_lvflag01-IYBASE)  ; 01:4D21 - FD CB 06 4E
   jr     nz, @continue_past_clamp_sonic_x_pos_right  ; 01:4D25 - 20 5A
   ld     hl, (g_level_limit_x0)       ; 01:4D27 - 2A 73 D2
   ld     bc, $0008                    ; 01:4D2A - 01 08 00
   add    hl, bc                       ; 01:4D2D - 09
   ex     de, hl                       ; 01:4D2E - EB
   ld     hl, (sonic_x)                ; 01:4D2F - 2A FE D3
   and    a                            ; 01:4D32 - A7
   sbc    hl, de                       ; 01:4D33 - ED 52
   jr     nc, @skip_clamp_sonic_x_pos_left  ; 01:4D35 - 30 18
   ld     (sonic_x), de                ; 01:4D37 - ED 53 FE D3
   ld     a, (sonic_vel_x_hi)          ; 01:4D3B - 3A 05 D4
   and    a                            ; 01:4D3E - A7
   jp     p, @continue_past_clamp_sonic_x_pos_right  ; 01:4D3F - F2 81 4D
   xor    a                            ; 01:4D42 - AF
   ld     (sonic_vel_x_sub), a         ; 01:4D43 - 32 03 D4
   ld     (sonic_vel_x), a             ; 01:4D46 - 32 04 D4
   ld     (sonic_vel_x_hi), a          ; 01:4D49 - 32 05 D4
   jp     @continue_past_clamp_sonic_x_pos_right  ; 01:4D4C - C3 81 4D

@skip_clamp_sonic_x_pos_left:
   ld     hl, (g_level_limit_x1)       ; 01:4D4F - 2A 75 D2
   ld     de, $00F8                    ; 01:4D52 - 11 F8 00
   add    hl, de                       ; 01:4D55 - 19
   ex     de, hl                       ; 01:4D56 - EB
   ld     hl, (sonic_x)                ; 01:4D57 - 2A FE D3
   ld     c, $18                       ; 01:4D5A - 0E 18
   add    hl, bc                       ; 01:4D5C - 09
   and    a                            ; 01:4D5D - A7
   sbc    hl, de                       ; 01:4D5E - ED 52
   jr     c, @continue_past_clamp_sonic_x_pos_right  ; 01:4D60 - 38 1F
   ex     de, hl                       ; 01:4D62 - EB
   scf                                 ; 01:4D63 - 37
   sbc    hl, bc                       ; 01:4D64 - ED 42
   ld     (sonic_x), hl                ; 01:4D66 - 22 FE D3
   ld     a, (sonic_vel_x_hi)          ; 01:4D69 - 3A 05 D4
   and    a                            ; 01:4D6C - A7
   jp     m, @continue_past_clamp_sonic_x_pos_right  ; 01:4D6D - FA 81 4D
   ld     hl, (sonic_vel_x)            ; 01:4D70 - 2A 04 D4
   or     h                            ; 01:4D73 - B4
   or     l                            ; 01:4D74 - B5
   jr     z, @continue_past_clamp_sonic_x_pos_right  ; 01:4D75 - 28 0A
   xor    a                            ; 01:4D77 - AF
   ld     (sonic_vel_x_sub), a         ; 01:4D78 - 32 03 D4
   ld     (sonic_vel_x), a             ; 01:4D7B - 32 04 D4
   ld     (sonic_vel_x_hi), a          ; 01:4D7E - 32 05 D4

@continue_past_clamp_sonic_x_pos_right:
   ld     a, (sonic_flags_ix_24)       ; 01:4D81 - 3A 14 D4
   ld     (g_sonic_flags_copy), a      ; 01:4D84 - 32 B9 D2
   ld     a, (sonic_anim_index_ix_20)  ; 01:4D87 - 3A 10 D4
   ld     (g_sonic_prev_anim_idx), a   ; 01:4D8A - 32 DF D2
   ld     d, $01                       ; 01:4D8D - 16 01
   ld     c, $30                       ; 01:4D8F - 0E 30
   cp     $01                          ; 01:4D91 - FE 01
   jr     z, @handle_x_speed_dependent_anim  ; 01:4D93 - 28 0C
   ld     d, $06                       ; 01:4D95 - 16 06
   ld     c, $50                       ; 01:4D97 - 0E 50
   cp     $09                          ; 01:4D99 - FE 09
   jr     z, @handle_x_speed_dependent_anim  ; 01:4D9B - 28 04
   inc    (ix+19)                      ; 01:4D9D - DD 34 13
   ret                                 ; 01:4DA0 - C9

@handle_x_speed_dependent_anim:
   ld     a, (g_sonic_x_speed_dependent_anim_subframe)  ; 01:4DA1 - 3A E0 D2
   ld     b, a                         ; 01:4DA4 - 47
   ld     hl, (sonic_vel_x_sub)        ; 01:4DA5 - 2A 03 D4
   bit    7, h                         ; 01:4DA8 - CB 7C
   jr     z, @x_speed_anim_speed_was_not_negative  ; 01:4DAA - 28 07
   ld     a, l                         ; 01:4DAC - 7D
   cpl                                 ; 01:4DAD - 2F
   ld     l, a                         ; 01:4DAE - 6F
   ld     a, h                         ; 01:4DAF - 7C
   cpl                                 ; 01:4DB0 - 2F
   ld     h, a                         ; 01:4DB1 - 67
   inc    hl                           ; 01:4DB2 - 23

@x_speed_anim_speed_was_not_negative:
   srl    h                            ; 01:4DB3 - CB 3C
   rr     l                            ; 01:4DB5 - CB 1D
   ld     a, l                         ; 01:4DB7 - 7D
   add    a, b                         ; 01:4DB8 - 80
   ld     (g_sonic_x_speed_dependent_anim_subframe), a  ; 01:4DB9 - 32 E0 D2
   ld     a, h                         ; 01:4DBC - 7C
   adc    a, d                         ; 01:4DBD - 8A
   adc    a, (ix+19)                   ; 01:4DBE - DD 8E 13
   ld     (sonic_anim_sprite_subindex_ix_19), a  ; 01:4DC1 - 32 0F D4
   cp     c                            ; 01:4DC4 - B9
   ret    c                            ; 01:4DC5 - D8
   sub    c                            ; 01:4DC6 - 91
   ld     (sonic_anim_sprite_subindex_ix_19), a  ; 01:4DC7 - 32 0F D4
   ret                                 ; 01:4DCA - C9

@sonic_physics_main:
.dw $0010, $0030, $0008, $0800                                                      ; 01:4DCB
.db $02                                                                             ; 01:4DD3

@sonic_physics_special_stage_airborne:
.dw $0010, $0030, $0002, $0800                                                      ; 01:4DD4
.db $02                                                                             ; 01:4DDC

@sonic_physics_underwater:
.dw $0004, $000C, $0002, $0200                                                      ; 01:4DDD
.db $01                                                                             ; 01:4DE5

@sonic_physics_speed_shoes:
.dw $0010, $0030, $0008, $0800                                                      ; 01:4DE6
.db $02                                                                             ; 01:4DEE

@fn_try_collect_ring_in_ring_tile:
   ex     de, hl                       ; 01:4DEF - EB
   ld     hl, (sonic_y)                ; 01:4DF0 - 2A 01 D4
   ld     bc, (g_level_scroll_y_pix_lo)  ; 01:4DF3 - ED 4B 5D D2
   and    a                            ; 01:4DF7 - A7
   sbc    hl, bc                       ; 01:4DF8 - ED 42
   ret    c                            ; 01:4DFA - D8
   ld     bc, $0010                    ; 01:4DFB - 01 10 00
   and    a                            ; 01:4DFE - A7
   sbc    hl, bc                       ; 01:4DFF - ED 42
   ret    c                            ; 01:4E01 - D8
   ld     hl, (sonic_x)                ; 01:4E02 - 2A FE D3
   ld     bc, $000C                    ; 01:4E05 - 01 0C 00
   add    hl, bc                       ; 01:4E08 - 09
   ld     a, (de)                      ; 01:4E09 - 1A
   ld     c, a                         ; 01:4E0A - 4F
   ld     a, l                         ; 01:4E0B - 7D
   rrca                                ; 01:4E0C - 0F
   rrca                                ; 01:4E0D - 0F
   rrca                                ; 01:4E0E - 0F
   rrca                                ; 01:4E0F - 0F
   and    $01                          ; 01:4E10 - E6 01
   inc    a                            ; 01:4E12 - 3C
   ld     b, a                         ; 01:4E13 - 47
   ld     a, c                         ; 01:4E14 - 79
   and    b                            ; 01:4E15 - A0
   ret    z                            ; 01:4E16 - C8
   ld     a, l                         ; 01:4E17 - 7D
   and    $F0                          ; 01:4E18 - E6 F0
   ld     l, a                         ; 01:4E1A - 6F
   ld     (g_screen_tile_replace_x), hl  ; 01:4E1B - 22 AB D2
   ld     (g_ring_sparkle_sprite_x), hl  ; 01:4E1E - 22 1D D3
   ld     a, c                         ; 01:4E21 - 79
   xor    b                            ; 01:4E22 - A8
   ld     (de), a                      ; 01:4E23 - 12
   ld     hl, (sonic_y)                ; 01:4E24 - 2A 01 D4
   ld     bc, $0008                    ; 01:4E27 - 01 08 00
   add    hl, bc                       ; 01:4E2A - 09
   ld     a, l                         ; 01:4E2B - 7D
   and    $E0                          ; 01:4E2C - E6 E0
   add    a, $08                       ; 01:4E2E - C6 08
   ld     l, a                         ; 01:4E30 - 6F
   ld     (g_screen_tile_replace_y), hl  ; 01:4E31 - 22 AD D2
   ld     (g_ring_sparkle_sprite_y), hl  ; 01:4E34 - 22 1F D3
   ld     a, $06                       ; 01:4E37 - 3E 06
   ld     (g_ring_sparkle_sprite_countdown_timer), a  ; 01:4E39 - 32 21 D3
   ld     hl, TILEREPLACE_ring_blanking  ; 01:4E3C - 21 5D 59
   ld     (g_screen_tile_replace_data_ptr), hl  ; 01:4E3F - 22 AF D2
   ld     a, $01                       ; 01:4E42 - 3E 01
   call   add_A_rings                  ; 01:4E44 - CD AC 39
   ret                                 ; 01:4E47 - C9

@fn_use_left_facing_sonic_sprites:
   ld     d, a                         ; 01:4E48 - 57
   ld     bc, $7000                    ; 01:4E49 - 01 00 70
   ret                                 ; 01:4E4C - C9

@fn_suppress_sprite_rendering:
   ld     hl, $0000                    ; 01:4E4D - 21 00 00
   ret                                 ; 01:4E50 - C9

@fn_handle_ring_sparkle_sprites:
   dec    a                            ; 01:4E51 - 3D
   ld     (g_ring_sparkle_sprite_countdown_timer), a  ; 01:4E52 - 32 21 D3
   ld     hl, (g_ring_sparkle_sprite_x)  ; 01:4E55 - 2A 1D D3
   ld     (tmp_00), hl                 ; 01:4E58 - 22 0E D2
   ld     hl, (g_ring_sparkle_sprite_y)  ; 01:4E5B - 2A 1F D3
   ld     (tmp_02), hl                 ; 01:4E5E - 22 10 D2
   ld     hl, $0000                    ; 01:4E61 - 21 00 00
   ld     (tmp_04), hl                 ; 01:4E64 - 22 12 D2
   ld     hl, $FFFE                    ; 01:4E67 - 21 FE FF
   ld     (tmp_06), hl                 ; 01:4E6A - 22 14 D2
   cp     $03                          ; 01:4E6D - FE 03
   jr     c, @skip_ring_sparkle_second_sprite  ; 01:4E6F - 38 11
   ld     a, $B2                       ; 01:4E71 - 3E B2
   call   draw_sprite                  ; 01:4E73 - CD 81 35
   ld     hl, $0008                    ; 01:4E76 - 21 08 00
   ld     (tmp_04), hl                 ; 01:4E79 - 22 12 D2
   ld     hl, $0002                    ; 01:4E7C - 21 02 00
   ld     (tmp_06), hl                 ; 01:4E7F - 22 14 D2

@skip_ring_sparkle_second_sprite:
   ld     a, $5A                       ; 01:4E82 - 3E 5A
   call   draw_sprite                  ; 01:4E84 - CD 81 35
   ret                                 ; 01:4E87 - C9

@fn_set_was_on_ground_bit:
   set    1, (iy+iy_08_lvflag03-IYBASE)  ; 01:4E88 - FD CB 08 CE
   ret                                 ; 01:4E8C - C9

@fn_handle_invincibility_sparkle_sprite:
   ld     hl, (sonic_x)                ; 01:4E8D - 2A FE D3
   ld     (tmp_00), hl                 ; 01:4E90 - 22 0E D2
   ld     hl, (sonic_y)                ; 01:4E93 - 2A 01 D4
   ld     (tmp_02), hl                 ; 01:4E96 - 22 10 D2
   ld     hl, g_invincibility_sparkle_position_buffer_0  ; 01:4E99 - 21 F3 D2
   ld     a, (g_global_tick_counter)   ; 01:4E9C - 3A 23 D2
   rrca                                ; 01:4E9F - 0F
   rrca                                ; 01:4EA0 - 0F
   jr     nc, @update_first_invisibility_sparkle_pos  ; 01:4EA1 - 30 03
   ld     hl, g_invincibility_sparkle_position_buffer_1  ; 01:4EA3 - 21 F7 D2

@update_first_invisibility_sparkle_pos:
   ld     de, tmp_04                   ; 01:4EA6 - 11 12 D2
   ldi                                 ; 01:4EA9 - ED A0
   ldi                                 ; 01:4EAB - ED A0
   ldi                                 ; 01:4EAD - ED A0
   ldi                                 ; 01:4EAF - ED A0
   rrca                                ; 01:4EB1 - 0F
   ld     a, $94                       ; 01:4EB2 - 3E 94
   jr     nc, @use_first_invisibility_sparkle_sprite_graphic  ; 01:4EB4 - 30 02
   ld     a, $96                       ; 01:4EB6 - 3E 96

@use_first_invisibility_sparkle_sprite_graphic:
   call   draw_sprite                  ; 01:4EB8 - CD 81 35
   ld     a, (g_global_tick_counter)   ; 01:4EBB - 3A 23 D2
   ld     c, a                         ; 01:4EBE - 4F
   and    $07                          ; 01:4EBF - E6 07
   ret    nz                           ; 01:4EC1 - C0
   ld     b, $02                       ; 01:4EC2 - 06 02
   ld     hl, g_invincibility_sparkle_position_buffer_0  ; 01:4EC4 - 21 F3 D2
   bit    3, c                         ; 01:4EC7 - CB 59
   jr     z, @each_invincibility_sparkle_coordinate  ; 01:4EC9 - 28 03
   ld     hl, g_invincibility_sparkle_position_buffer_1  ; 01:4ECB - 21 F7 D2

@each_invincibility_sparkle_coordinate:
   push   hl                           ; 01:4ECE - E5
   call   random_A                     ; 01:4ECF - CD 25 06
   pop    hl                           ; 01:4ED2 - E1
   and    $0F                          ; 01:4ED3 - E6 0F
   ld     (hl), a                      ; 01:4ED5 - 77
   inc    hl                           ; 01:4ED6 - 23
   ld     (hl), $00                    ; 01:4ED7 - 36 00
   inc    hl                           ; 01:4ED9 - 23
   djnz   @each_invincibility_sparkle_coordinate  ; 01:4EDA - 10 F2
   ret                                 ; 01:4EDC - C9

@fn_camera_look_up:
   ld     hl, (sonic_vel_x_sub)        ; 01:4EDD - 2A 03 D4
   ld     a, h                         ; 01:4EE0 - 7C
   or     l                            ; 01:4EE1 - B5
   ret    nz                           ; 01:4EE2 - C0
   ld     a, (sonic_flags_ix_24)       ; 01:4EE3 - 3A 14 D4
   rlca                                ; 01:4EE6 - 07
   ret    nc                           ; 01:4EE7 - D0
   ld     (ix+20), $0C                 ; 01:4EE8 - DD 36 14 0C
   ld     de, (g_camera_y_look_up_offset_px)  ; 01:4EEC - ED 5B B7 D2
   bit    7, d                         ; 01:4EF0 - CB 7A
   jr     nz, @looking_down_immediate_look_up  ; 01:4EF2 - 20 07
   ld     hl, $002C                    ; 01:4EF4 - 21 2C 00
   and    a                            ; 01:4EF7 - A7
   sbc    hl, de                       ; 01:4EF8 - ED 52
   ret    c                            ; 01:4EFA - D8

@looking_down_immediate_look_up:
   inc    de                           ; 01:4EFB - 13
   ld     (g_camera_y_look_up_offset_px), de  ; 01:4EFC - ED 53 B7 D2
   ret                                 ; 01:4F00 - C9

@handle_right_input:
   res    1, (ix+24)                   ; 01:4F01 - DD CB 18 8E
   bit    7, b                         ; 01:4F05 - CB 78
   jr     nz, @left_brake_to_right     ; 01:4F07 - 20 28
   ld     de, (tmp_00)                 ; 01:4F09 - ED 5B 0E D2
   ld     c, $00                       ; 01:4F0D - 0E 00
   ld     (ix+20), $01                 ; 01:4F0F - DD 36 14 01
   push   hl                           ; 01:4F13 - E5
   exx                                 ; 01:4F14 - D9
   pop    hl                           ; 01:4F15 - E1
   ld     de, (g_sonic_x_speed_cap_subpx)  ; 01:4F16 - ED 5B 40 D2
   xor    a                            ; 01:4F1A - AF
   sbc    hl, de                       ; 01:4F1B - ED 52
   exx                                 ; 01:4F1D - D9
   jp     c, @update_x_velocity_from_basic_movement  ; 01:4F1E - DA 1B 4B
   ld     b, a                         ; 01:4F21 - 47
   ld     e, a                         ; 01:4F22 - 5F
   ld     d, a                         ; 01:4F23 - 57
   ld     c, a                         ; 01:4F24 - 4F
   ld     hl, (g_sonic_x_speed_cap_subpx)  ; 01:4F25 - 2A 40 D2
   ld     a, (tmp_08)                  ; 01:4F28 - 3A 16 D2
   ld     (ix+20), a                   ; 01:4F2B - DD 77 14
   jp     @update_x_velocity_from_basic_movement  ; 01:4F2E - C3 1B 4B

@left_brake_to_right:
   set    1, (ix+24)                   ; 01:4F31 - DD CB 18 CE
   ld     (ix+20), $0A                 ; 01:4F35 - DD 36 14 0A
   push   hl                           ; 01:4F39 - E5
   ld     a, l                         ; 01:4F3A - 7D
   cpl                                 ; 01:4F3B - 2F
   ld     l, a                         ; 01:4F3C - 6F
   ld     a, h                         ; 01:4F3D - 7C
   cpl                                 ; 01:4F3E - 2F
   ld     h, a                         ; 01:4F3F - 67
   inc    hl                           ; 01:4F40 - 23
   ld     de, $0100                    ; 01:4F41 - 11 00 01
   and    a                            ; 01:4F44 - A7
   sbc    hl, de                       ; 01:4F45 - ED 52
   pop    hl                           ; 01:4F47 - E1
   ld     de, (tmp_02)                 ; 01:4F48 - ED 5B 10 D2
   ld     c, $00                       ; 01:4F4C - 0E 00
   jp     nc, @update_x_velocity_from_basic_movement  ; 01:4F4E - D2 1B 4B
   res    1, (ix+24)                   ; 01:4F51 - DD CB 18 8E
   ld     (ix+20), $01                 ; 01:4F55 - DD 36 14 01
   jp     @update_x_velocity_from_basic_movement  ; 01:4F59 - C3 1B 4B

@handle_left_input:
   set    1, (ix+24)                   ; 01:4F5C - DD CB 18 CE
   ld     a, l                         ; 01:4F60 - 7D
   or     h                            ; 01:4F61 - B4
   jr     z, @skip_right_brake_to_left_check  ; 01:4F62 - 28 04
   bit    7, b                         ; 01:4F64 - CB 78
   jr     z, @right_brake_to_left      ; 01:4F66 - 28 3E

@skip_right_brake_to_left_check:
   ld     de, (tmp_00)                 ; 01:4F68 - ED 5B 0E D2
   ld     a, e                         ; 01:4F6C - 7B
   cpl                                 ; 01:4F6D - 2F
   ld     e, a                         ; 01:4F6E - 5F
   ld     a, d                         ; 01:4F6F - 7A
   cpl                                 ; 01:4F70 - 2F
   ld     d, a                         ; 01:4F71 - 57
   inc    de                           ; 01:4F72 - 13
   ld     c, $FF                       ; 01:4F73 - 0E FF
   ld     (ix+20), $01                 ; 01:4F75 - DD 36 14 01
   push   hl                           ; 01:4F79 - E5
   exx                                 ; 01:4F7A - D9
   pop    hl                           ; 01:4F7B - E1
   ld     a, l                         ; 01:4F7C - 7D
   cpl                                 ; 01:4F7D - 2F
   ld     l, a                         ; 01:4F7E - 6F
   ld     a, h                         ; 01:4F7F - 7C
   cpl                                 ; 01:4F80 - 2F
   ld     h, a                         ; 01:4F81 - 67
   inc    hl                           ; 01:4F82 - 23
   ld     de, (g_sonic_x_speed_cap_subpx)  ; 01:4F83 - ED 5B 40 D2
   xor    a                            ; 01:4F87 - AF
   sbc    hl, de                       ; 01:4F88 - ED 52
   exx                                 ; 01:4F8A - D9
   jp     c, @update_x_velocity_from_basic_movement  ; 01:4F8B - DA 1B 4B
   ld     e, a                         ; 01:4F8E - 5F
   ld     d, a                         ; 01:4F8F - 57
   ld     c, a                         ; 01:4F90 - 4F
   ld     hl, (g_sonic_x_speed_cap_subpx)  ; 01:4F91 - 2A 40 D2
   ld     a, l                         ; 01:4F94 - 7D
   cpl                                 ; 01:4F95 - 2F
   ld     l, a                         ; 01:4F96 - 6F
   ld     a, h                         ; 01:4F97 - 7C
   cpl                                 ; 01:4F98 - 2F
   ld     h, a                         ; 01:4F99 - 67
   inc    hl                           ; 01:4F9A - 23
   ld     b, $FF                       ; 01:4F9B - 06 FF
   ld     a, (tmp_08)                  ; 01:4F9D - 3A 16 D2
   ld     (ix+20), a                   ; 01:4FA0 - DD 77 14
   jp     @update_x_velocity_from_basic_movement  ; 01:4FA3 - C3 1B 4B

@right_brake_to_left:
   res    1, (ix+24)                   ; 01:4FA6 - DD CB 18 8E
   ld     (ix+20), $0A                 ; 01:4FAA - DD 36 14 0A
   ld     de, (tmp_02)                 ; 01:4FAE - ED 5B 10 D2
   ld     a, e                         ; 01:4FB2 - 7B
   cpl                                 ; 01:4FB3 - 2F
   ld     e, a                         ; 01:4FB4 - 5F
   ld     a, d                         ; 01:4FB5 - 7A
   cpl                                 ; 01:4FB6 - 2F
   ld     d, a                         ; 01:4FB7 - 57
   inc    de                           ; 01:4FB8 - 13
   ld     c, $FF                       ; 01:4FB9 - 0E FF
   push   hl                           ; 01:4FBB - E5
   exx                                 ; 01:4FBC - D9
   pop    hl                           ; 01:4FBD - E1
   ld     bc, $0100                    ; 01:4FBE - 01 00 01
   and    a                            ; 01:4FC1 - A7
   sbc    hl, bc                       ; 01:4FC2 - ED 42
   exx                                 ; 01:4FC4 - D9
   jp     nc, @update_x_velocity_from_basic_movement  ; 01:4FC5 - D2 1B 4B
   set    1, (ix+24)                   ; 01:4FC8 - DD CB 18 CE
   ld     (ix+20), $01                 ; 01:4FCC - DD 36 14 01
   jp     @update_x_velocity_from_basic_movement  ; 01:4FD0 - C3 1B 4B

@fn_restore_camera_look:
   bit    0, (ix+24)                   ; 01:4FD3 - DD CB 18 46
   ret    nz                           ; 01:4FD7 - C0
   ld     hl, (g_camera_y_look_up_offset_px)  ; 01:4FD8 - 2A B7 D2
   ld     a, h                         ; 01:4FDB - 7C
   or     l                            ; 01:4FDC - B5
   ret    z                            ; 01:4FDD - C8
   bit    7, h                         ; 01:4FDE - CB 7C
   jr     z, @restore_from_look_up     ; 01:4FE0 - 28 05
   inc    hl                           ; 01:4FE2 - 23
   ld     (g_camera_y_look_up_offset_px), hl  ; 01:4FE3 - 22 B7 D2
   ret                                 ; 01:4FE6 - C9

@restore_from_look_up:
   dec    hl                           ; 01:4FE7 - 2B
   ld     (g_camera_y_look_up_offset_px), hl  ; 01:4FE8 - 22 B7 D2
   ret                                 ; 01:4FEB - C9

@fn_handle_speed_shoes_timer:
   dec    (ix+21)                      ; 01:4FEC - DD 35 15
   ret                                 ; 01:4FEF - C9

@fn_handle_brake_sound_cooldown_timer:
   dec    a                            ; 01:4FF0 - 3D
   ld     (sonic_brake_sound_cooldown_timer_ix_22), a  ; 01:4FF1 - 32 12 D4
   ret                                 ; 01:4FF4 - C9

@fn_handle_invincibility:
   ld     a, (g_global_tick_counter)   ; 01:4FF5 - 3A 23 D2
   and    $03                          ; 01:4FF8 - E6 03
   ret    nz                           ; 01:4FFA - C0
   ld     hl, g_invincibility_countdown_timer  ; 01:4FFB - 21 8D D2
   dec    (hl)                         ; 01:4FFE - 35
   ret    nz                           ; 01:4FFF - C0
   res    0, (iy+iy_08_lvflag03-IYBASE)  ; 01:5000 - FD CB 08 86
   ld     a, (g_level_music)           ; 01:5004 - 3A FC D2
   rst    $18                          ; 01:5007 - DF
   ret                                 ; 01:5008 - C9

@fn_handle_air_timer_and_drowning:
   ld     a, (g_tile_flags_index)      ; 01:5009 - 3A D4 D2
   cp     $03                          ; 01:500C - FE 03
   ret    nz                           ; 01:500E - C0
   ld     a, (g_level)                 ; 01:500F - 3A 3E D2
   cp     $0B                          ; 01:5012 - FE 0B
   ret    z                            ; 01:5014 - C8
   ld     hl, (g_sonic_underwater_countup_timer)  ; 01:5015 - 2A 9B D2
   inc    hl                           ; 01:5018 - 23
   ld     (g_sonic_underwater_countup_timer), hl  ; 01:5019 - 22 9B D2
   ld     de, $0300                    ; 01:501C - 11 00 03
   and    a                            ; 01:501F - A7
   sbc    hl, de                       ; 01:5020 - ED 52
   ret    c                            ; 01:5022 - D8
   ld     a, $05                       ; 01:5023 - 3E 05
   sub    h                            ; 01:5025 - 94
   jr     nc, @dont_drown_yet          ; 01:5026 - 30 29
   res    5, (iy+iy_06_lvflag01-IYBASE)  ; 01:5028 - FD CB 06 AE
   res    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:502C - FD CB 06 B6
   res    0, (iy+iy_08_lvflag03-IYBASE)  ; 01:5030 - FD CB 08 86
   set    3, (iy+iy_08_lvflag03-IYBASE)  ; 01:5034 - FD CB 08 DE
   set    0, (iy+iy_05_lvflag00-IYBASE)  ; 01:5038 - FD CB 05 C6
   ld     a, $C0                       ; 01:503C - 3E C0
   ld     (g_level_restart_countdown_timer), a  ; 01:503E - 32 87 D2
   ld     a, $0A                       ; 01:5041 - 3E 0A
   rst    $18                          ; 01:5043 - DF
   call   spawn_bubble                 ; 01:5044 - CD EB 91
   call   spawn_bubble                 ; 01:5047 - CD EB 91
   call   spawn_bubble                 ; 01:504A - CD EB 91
   call   spawn_bubble                 ; 01:504D - CD EB 91
   xor    a                            ; 01:5050 - AF

@dont_drown_yet:
   ld     e, a                         ; 01:5051 - 5F
   add    a, a                         ; 01:5052 - 87
   add    a, $80                       ; 01:5053 - C6 80
   ld     (g_HUD_FFstr_buf), a         ; 01:5055 - 32 BE D2
   ld     a, $FF                       ; 01:5058 - 3E FF
   ld     (g_HUD_FFstr_buf_1), a       ; 01:505A - 32 BF D2
   ld     d, $00                       ; 01:505D - 16 00
   ld     hl, objfunc_00_sonic@beep_period_masks_per_air_countdown  ; 01:505F - 21 97 50
   add    hl, de                       ; 01:5062 - 19
   ld     a, (g_global_tick_counter)   ; 01:5063 - 3A 23 D2
   and    (hl)                         ; 01:5066 - A6
   jr     nz, @skip_beep_sound         ; 01:5067 - 20 03
   ld     a, $1A                       ; 01:5069 - 3E 1A
   rst    $28                          ; 01:506B - EF

@skip_beep_sound:
   ld     a, (g_global_tick_counter)   ; 01:506C - 3A 23 D2
   rrca                                ; 01:506F - 0F
   ret    nc                           ; 01:5070 - D0
   ld     hl, (sonic_x)                ; 01:5071 - 2A FE D3
   ld     de, (g_level_scroll_x_pix_lo)  ; 01:5074 - ED 5B 5A D2
   and    a                            ; 01:5078 - A7
   sbc    hl, de                       ; 01:5079 - ED 52
   ld     a, l                         ; 01:507B - 7D
   add    a, $08                       ; 01:507C - C6 08
   ld     c, a                         ; 01:507E - 4F
   ld     hl, (sonic_y)                ; 01:507F - 2A 01 D4
   ld     de, (g_level_scroll_y_pix_lo)  ; 01:5082 - ED 5B 5D D2
   and    a                            ; 01:5086 - A7
   sbc    hl, de                       ; 01:5087 - ED 52
   ld     a, l                         ; 01:5089 - 7D
   add    a, $EC                       ; 01:508A - C6 EC
   ld     b, a                         ; 01:508C - 47
   ld     hl, g_sprite_table_20        ; 01:508D - 21 3C D0
   ld     de, g_HUD_FFstr_buf          ; 01:5090 - 11 BE D2
   call   draw_sprite_text             ; 01:5093 - CD CC 35
   ret                                 ; 01:5096 - C9

@beep_period_masks_per_air_countdown:
.db $01, $07, $0F, $1F, $3F, $7F                                                    ; 01:5097

@fn_start_jump_timer:
   ld     a, $10                       ; 01:509D - 3E 10
   ld     (g_sonic_jump_countdown_timer), a  ; 01:509F - 32 8E D2
   ld     a, $00                       ; 01:50A2 - 3E 00
   rst    $28                          ; 01:50A4 - EF
   ret                                 ; 01:50A5 - C9

@fn_handle_sonic_landing_SEMIVESTIGIAL:
   exx                                 ; 01:50AF - D9
   ld     hl, (sonic_y)                ; 01:50B0 - 2A 01 D4
   ld     (g_UNUSED_last_sonic_ground_y), hl  ; 01:50B3 - 22 D9 D2
   exx                                 ; 01:50B6 - D9
   bit    2, (ix+24)                   ; 01:50B7 - DD CB 18 56
   ret    z                            ; 01:50BB - C8
   res    2, (ix+24)                   ; 01:50BC - DD CB 18 96
   ret                                 ; 01:50C0 - C9

@fn_try_to_roll:
   bit    2, (ix+24)                   ; 01:50C1 - DD CB 18 56
   ret    nz                           ; 01:50C5 - C0
   bit    0, (ix+24)                   ; 01:50C6 - DD CB 18 46
   ret    nz                           ; 01:50CA - C0
   bit    7, (ix+24)                   ; 01:50CB - DD CB 18 7E
   ret    z                            ; 01:50CF - C8
   set    0, (ix+24)                   ; 01:50D0 - DD CB 18 C6
   ld     hl, (sonic_vel_x_sub)        ; 01:50D4 - 2A 03 D4
   ld     a, l                         ; 01:50D7 - 7D
   or     h                            ; 01:50D8 - B4
   jr     z, @skip_rolling_sound_effect  ; 01:50D9 - 28 03
   ld     a, $06                       ; 01:50DB - 3E 06
   rst    $28                          ; 01:50DD - EF

@skip_rolling_sound_effect:
   set    2, (iy+iy_07_lvflag02-IYBASE)  ; 01:50DE - FD CB 07 D6
   ret                                 ; 01:50E2 - C9

@fn_clear_extra_rolling_flag_SEMIVESTIGIAL:
   res    2, (iy+iy_07_lvflag02-IYBASE)  ; 01:50E3 - FD CB 07 96
   ret                                 ; 01:50E7 - C9

@fn_set_underwater_state_based_on_water_level:
   ld     hl, (g_water_level_y)        ; 01:50E8 - 2A DC D2
   ld     de, (sonic_y)                ; 01:50EB - ED 5B 01 D4
   and    a                            ; 01:50EF - A7
   sbc    hl, de                       ; 01:50F0 - ED 52
   jp     c, objfunc_00_sonic@special_08_underwater  ; 01:50F2 - DA A8 55
   ld     hl, $0000                    ; 01:50F5 - 21 00 00
   ld     (g_sonic_underwater_countup_timer), hl  ; 01:50F8 - 22 9B D2
   res    4, (ix+24)                   ; 01:50FB - DD CB 18 A6
   ret                                 ; 01:50FF - C9

@fn_forbid_rolling_in_special_stage:
   set    2, (ix+24)                   ; 01:5100 - DD CB 18 D6
   ret                                 ; 01:5104 - C9

@fn_handle_sonic_bored_anim:
   ld     (ix+20), $0D                 ; 01:5105 - DD 36 14 0D
   ret                                 ; 01:5109 - C9

@fn_handle_damage_stun_and_input_suppression:
   ld     (iy+g_inputs_player_1-IYBASE), $FF  ; 01:510A - FD 36 03 FF
   ld     a, (sonic_flags_ix_24)       ; 01:510E - 3A 14 D4
   and    $FA                          ; 01:5111 - E6 FA
   ld     (sonic_flags_ix_24), a       ; 01:5113 - 32 14 D4
   ret                                 ; 01:5116 - C9

@handle_teleport_start:
   dec    a                            ; 01:5117 - 3D
   ld     (g_teleport_start_countdown_timer), a  ; 01:5118 - 32 8A D2
   jr     z, @do_teleport              ; 01:511B - 28 25
   cp     $14                          ; 01:511D - FE 14
   jr     c, @do_teleport_spin_effect  ; 01:511F - 38 16
   xor    a                            ; 01:5121 - AF
   ld     l, a                         ; 01:5122 - 6F
   ld     h, a                         ; 01:5123 - 67
   ld     (sonic_vel_x_sub), a         ; 01:5124 - 32 03 D4
   ld     (sonic_vel_x), hl            ; 01:5127 - 22 04 D4
   ld     (sonic_vel_y_sub), a         ; 01:512A - 32 06 D4
   ld     (sonic_vel_y), hl            ; 01:512D - 22 07 D4
   ld     (ix+20), $0F                 ; 01:5130 - DD 36 14 0F
   jp     @continue_past_basic_movement_physics  ; 01:5134 - C3 39 4C

@do_teleport_spin_effect:
   res    1, (ix+24)                   ; 01:5137 - DD CB 18 8E
   ld     (ix+20), $0E                 ; 01:513B - DD 36 14 0E
   jp     @continue_past_basic_movement_physics  ; 01:513F - C3 39 4C

@do_teleport:
   ld     hl, (g_teleport_spec_dest_ptr)  ; 01:5142 - 2A D5 D2
   ld     b, (hl)                      ; 01:5145 - 46
   inc    hl                           ; 01:5146 - 23
   ld     c, (hl)                      ; 01:5147 - 4E
   inc    hl                           ; 01:5148 - 23
   ld     a, (hl)                      ; 01:5149 - 7E
   and    a                            ; 01:514A - A7
   jr     z, @teleport_is_in_same_level  ; 01:514B - 28 16
   jp     m, @teleport_advance_to_next_level  ; 01:514D - FA 59 51
   ld     (g_next_level_override_target), a  ; 01:5150 - 32 D3 D2
   set    4, (iy+iy_06_lvflag01-IYBASE)  ; 01:5153 - FD CB 06 E6
   jr     @teleport_did_want_specific_level  ; 01:5157 - 18 04

@teleport_advance_to_next_level:
   set    2, (iy+iy_0D-IYBASE)         ; 01:5159 - FD CB 0D D6

@teleport_did_want_specific_level:
   ld     a, $01                       ; 01:515D - 3E 01
   ld     (g_signpost_tickdown_counter), a  ; 01:515F - 32 89 D2
   ret                                 ; 01:5162 - C9

@teleport_is_in_same_level:
   ld     a, b                         ; 01:5163 - 78
   ld     h, $00                       ; 01:5164 - 26 00
   ld     b, $05                       ; 01:5166 - 06 05

@teleport_x_pos_shift_left_by_5_loop:
   add    a, a                         ; 01:5168 - 87
   rl     h                            ; 01:5169 - CB 14
   djnz   @teleport_x_pos_shift_left_by_5_loop  ; 01:516B - 10 FB
   ld     l, a                         ; 01:516D - 6F
   ld     de, $0008                    ; 01:516E - 11 08 00
   add    hl, de                       ; 01:5171 - 19
   ld     (sonic_x), hl                ; 01:5172 - 22 FE D3
   ld     a, c                         ; 01:5175 - 79
   ld     h, $00                       ; 01:5176 - 26 00
   add    a, a                         ; 01:5178 - 87
   rl     h                            ; 01:5179 - CB 14
   add    a, a                         ; 01:517B - 87
   rl     h                            ; 01:517C - CB 14
   add    a, a                         ; 01:517E - 87
   rl     h                            ; 01:517F - CB 14
   add    a, a                         ; 01:5181 - 87
   rl     h                            ; 01:5182 - CB 14
   add    a, a                         ; 01:5184 - 87
   rl     h                            ; 01:5185 - CB 14
   ld     l, a                         ; 01:5187 - 6F
   ld     (sonic_y), hl                ; 01:5188 - 22 01 D4
   xor    a                            ; 01:518B - AF
   ld     (sonic_x_sub), a             ; 01:518C - 32 FD D3
   ld     (sonic_y_sub), a             ; 01:518F - 32 00 D4
   ret                                 ; 01:5192 - C9

@handle_ending_animation_teleport_in:
   xor    a                            ; 01:5193 - AF
   ld     l, a                         ; 01:5194 - 6F
   ld     h, a                         ; 01:5195 - 67
   ld     (sonic_vel_y_sub), hl        ; 01:5196 - 22 06 D4
   ld     (sonic_vel_y_hi), a          ; 01:5199 - 32 08 D4
   ld     (ix+20), $16                 ; 01:519C - DD 36 14 16
   ld     a, (sonic_anim_sprite_subindex_ix_19)  ; 01:51A0 - 3A 0F D4
   cp     $12                          ; 01:51A3 - FE 12
   jp     c, @continue_past_basic_movement_physics  ; 01:51A5 - DA 39 4C
   res    6, (iy+iy_08_lvflag03-IYBASE)  ; 01:51A8 - FD CB 08 B6
   set    2, (ix+24)                   ; 01:51AC - DD CB 18 D6
   jp     @continue_past_basic_movement_physics  ; 01:51B0 - C3 39 4C

@fn_decrement_directional_input_suppression_timer:
   dec    a                            ; 01:51B3 - 3D
   ld     (g_directional_input_suppression_timer), a  ; 01:51B4 - 32 8C D2
   ld     (ix+20), $11                 ; 01:51B7 - DD 36 14 11
   ret                                 ; 01:51BB - C9

@fn_handle_damage_stun_animation_and_deactivation:
   ld     (ix+13), $1C                 ; 01:51BC - DD 36 0D 1C
   ld     (ix+20), $10                 ; 01:51C0 - DD 36 14 10
   bit    7, (ix+12)                   ; 01:51C4 - DD CB 0C 7E
   ret    nz                           ; 01:51C8 - C0
   bit    7, (ix+24)                   ; 01:51C9 - DD CB 18 7E
   ret    z                            ; 01:51CD - C8
   res    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:51CE - FD CB 06 B6
   xor    a                            ; 01:51D2 - AF
   ld     (sonic_vel_x_sub), a         ; 01:51D3 - 32 03 D4
   ld     (sonic_vel_x), a             ; 01:51D6 - 32 04 D4
   ld     (sonic_vel_x_hi), a          ; 01:51D9 - 32 05 D4
   ret                                 ; 01:51DC - C9

@fn_handle_consuming_an_air_bubble:
   ld     a, (sonic_flags_ix_24)       ; 01:51DD - 3A 14 D4
   and    $FA                          ; 01:51E0 - E6 FA
   ld     (sonic_flags_ix_24), a       ; 01:51E2 - 32 14 D4
   ld     (ix+20), $14                 ; 01:51E5 - DD 36 14 14
   ld     hl, g_sonic_consume_air_bubble_countdown_timer  ; 01:51E9 - 21 FB D2
   dec    (hl)                         ; 01:51EC - 35
   ret    nz                           ; 01:51ED - C0
   res    2, (iy+iy_08_lvflag03-IYBASE)  ; 01:51EE - FD CB 08 96
   ret                                 ; 01:51F2 - C9

@fn_throttled_play_brake_sound_effect:
   ld     a, (sonic_brake_sound_cooldown_timer_ix_22)  ; 01:51F3 - 3A 12 D4
   and    a                            ; 01:51F6 - A7
   ret    nz                           ; 01:51F7 - C0
   bit    7, (ix+24)                   ; 01:51F8 - DD CB 18 7E
   ret    z                            ; 01:51FC - C8
   ld     a, $03                       ; 01:51FD - 3E 03
   rst    $28                          ; 01:51FF - EF
   ld     a, $3C                       ; 01:5200 - 3E 3C
   ld     (sonic_brake_sound_cooldown_timer_ix_22), a  ; 01:5202 - 32 12 D4
   ret                                 ; 01:5205 - C9

@fn_handle_shield_animation:
   ld     a, (g_global_tick_counter)   ; 01:5206 - 3A 23 D2
   and    $01                          ; 01:5209 - E6 01
   ret    nz                           ; 01:520B - C0
   ld     d, $18                       ; 01:520C - 16 18
   ret                                 ; 01:520E - C9

@fn_use_upspring_sprites:
   ld     hl, SPRITEMAP_sonic_upspring_right  ; 01:5213 - 21 39 59
   bit    1, (ix+24)                   ; 01:5216 - DD CB 18 4E
   ret    z                            ; 01:521A - C8
   ld     hl, SPRITEMAP_sonic_upspring_left  ; 01:521B - 21 4B 59
   ret                                 ; 01:521E - C9

@fn_reset_anim_frame_idx_on_anim_change:
   ld     (ix+19), $00                 ; 01:521F - DD 36 13 00
   ret                                 ; 01:5223 - C9

@fn_blow_a_bubble_periodically:
   bit    4, (ix+24)                   ; 01:5224 - DD CB 18 66
   ret    z                            ; 01:5228 - C8
   ld     a, (g_global_tick_counter)   ; 01:5229 - 3A 23 D2
   and    a                            ; 01:522C - A7
   call   z, spawn_bubble              ; 01:522D - CC EB 91
   ret                                 ; 01:5230 - C9

@fn_handle_round_bumper_throbbing_effect:
   dec    a                            ; 01:5231 - 3D
   ld     (g_special_stage_round_bumper_cooldown_timer), a  ; 01:5232 - 32 E1 D2
   cp     $06                          ; 01:5235 - FE 06
   jr     c, @show_round_bumper_throbbing_sprite  ; 01:5237 - 38 03
   cp     $0A                          ; 01:5239 - FE 0A
   ret    c                            ; 01:523B - D8

@show_round_bumper_throbbing_sprite:
   ld     a, (iy+g_sprite_count-IYBASE)  ; 01:523C - FD 7E 0A
   ld     hl, (g_next_avail_vdp_sprite_ptr)  ; 01:523F - 2A 3C D2
   push   af                           ; 01:5242 - F5
   push   hl                           ; 01:5243 - E5
   ld     hl, g_sprite_table           ; 01:5244 - 21 00 D0
   ld     (g_next_avail_vdp_sprite_ptr), hl  ; 01:5247 - 22 3C D2
   ld     de, (g_level_scroll_y_pix_lo)  ; 01:524A - ED 5B 5D D2
   ld     hl, (g_special_stage_round_bumper_anim_sprite_y)  ; 01:524E - 2A E4 D2
   and    a                            ; 01:5251 - A7
   sbc    hl, de                       ; 01:5252 - ED 52
   ex     de, hl                       ; 01:5254 - EB
   ld     bc, (g_level_scroll_x_pix_lo)  ; 01:5255 - ED 4B 5A D2
   ld     hl, (g_special_stage_round_bumper_anim_sprite_x)  ; 01:5259 - 2A E2 D2
   and    a                            ; 01:525C - A7
   sbc    hl, bc                       ; 01:525D - ED 42
   ld     bc, objfunc_00_sonic@SPRTAB_round_bumper_throbbing  ; 01:525F - 01 6E 52
   call   draw_sprite_string           ; 01:5262 - CD 0F 35
   pop    hl                           ; 01:5265 - E1
   pop    af                           ; 01:5266 - F1
   ld     (g_next_avail_vdp_sprite_ptr), hl  ; 01:5267 - 22 3C D2
   ld     (iy+g_sprite_count-IYBASE), a  ; 01:526A - FD 77 0A
   ret                                 ; 01:526D - C9

@SPRTAB_round_bumper_throbbing:
.db $00, $02, $04, $06, $FF, $FF, $20, $22, $24, $26, $FF, $FF, $FF, $FF, $FF, $FF  ; 01:526E
.db $FF, $FF                                                                        ; 01:527E

@fn_set_roll_animation_for_airborne:
   ld     (ix+20), $09                 ; 01:5280 - DD 36 14 09
   ret                                 ; 01:5284 - C9

@fn_handle_chaos_emerald_music_countdown_timer:
   dec    a                            ; 01:5285 - 3D
   ld     (g_chaos_emerald_music_countdown_timer), a  ; 01:5286 - 32 8B D2
   ret    nz                           ; 01:5289 - C0
   ld     a, (g_level_music)           ; 01:528A - 3A FC D2
   rst    $18                          ; 01:528D - DF
   ld     c, (iy+g_sprite_count-IYBASE)  ; 01:528E - FD 4E 0A
   res    0, (iy+iy_00-IYBASE)         ; 01:5291 - FD CB 00 86
   call   wait_until_irq_ticked        ; 01:5295 - CD 1C 03
   ld     (iy+g_sprite_count-IYBASE), c  ; 01:5298 - FD 71 0A
   ret                                 ; 01:529B - C9

@fn_handle_good_ending_sequence:
   ld     (iy+g_inputs_player_1-IYBASE), $FB  ; 01:529C - FD 36 03 FB
   ld     hl, (sonic_x)                ; 01:52A0 - 2A FE D3
   ld     de, $1B60                    ; 01:52A3 - 11 60 1B
   and    a                            ; 01:52A6 - A7
   sbc    hl, de                       ; 01:52A7 - ED 52
   ret    nc                           ; 01:52A9 - D0
   ld     (iy+g_inputs_player_1-IYBASE), $FF  ; 01:52AA - FD 36 03 FF
   ld     hl, (sonic_vel_x_sub)        ; 01:52AE - 2A 03 D4
   ld     a, l                         ; 01:52B1 - 7D
   or     h                            ; 01:52B2 - B4
   ret    nz                           ; 01:52B3 - C0
   res    1, (ix+24)                   ; 01:52B4 - DD CB 18 8E
   pop    hl                           ; 01:52B8 - E1
   set    1, (ix+24)                   ; 01:52B9 - DD CB 18 CE
   ld     (ix+20), $18                 ; 01:52BD - DD 36 14 18
   ld     hl, g_good_ending_emerald_anim_countdown_timer  ; 01:52C1 - 21 FE D2
   bit    0, (iy+iy_0D-IYBASE)         ; 01:52C4 - FD CB 0D 46
   jr     nz, @good_ending_emeralds_already_spawned  ; 01:52C8 - 20 41
   ld     (hl), $50                    ; 01:52CA - 36 50
   call   spawn_object                 ; 01:52CC - CD 7B 7C
   jp     c, @continue_past_basic_movement_physics  ; 01:52CF - DA 39 4C
   push   ix                           ; 01:52D2 - DD E5
   push   hl                           ; 01:52D4 - E5
   pop    ix                           ; 01:52D5 - DD E1
   xor    a                            ; 01:52D7 - AF
   ld     (ix+0), $54                  ; 01:52D8 - DD 36 00 54
   ld     (ix+17), a                   ; 01:52DC - DD 77 11
   ld     (ix+24), a                   ; 01:52DF - DD 77 18
   ld     (ix+1), a                    ; 01:52E2 - DD 77 01
   ld     hl, (sonic_x)                ; 01:52E5 - 2A FE D3
   ld     de, $0002                    ; 01:52E8 - 11 02 00
   add    hl, de                       ; 01:52EB - 19
   ld     (ix+2), l                    ; 01:52EC - DD 75 02
   ld     (ix+3), h                    ; 01:52EF - DD 74 03
   ld     (ix+4), a                    ; 01:52F2 - DD 77 04
   ld     hl, (sonic_y)                ; 01:52F5 - 2A 01 D4
   ld     de, $000E                    ; 01:52F8 - 11 0E 00
   add    hl, de                       ; 01:52FB - 19
   ld     (ix+5), l                    ; 01:52FC - DD 75 05
   ld     (ix+6), h                    ; 01:52FF - DD 74 06
   pop    ix                           ; 01:5302 - DD E1
   set    0, (iy+iy_0D-IYBASE)         ; 01:5304 - FD CB 0D C6
   jp     @continue_past_basic_movement_physics  ; 01:5308 - C3 39 4C

@good_ending_emeralds_already_spawned:
   bit    1, (iy+iy_0D-IYBASE)         ; 01:530B - FD CB 0D 4E
   jr     nz, @good_ending_emerald_anim_0_already_done  ; 01:530F - 20 0A
   dec    (hl)                         ; 01:5311 - 35
   jp     nz, @continue_past_basic_movement_physics  ; 01:5312 - C2 39 4C
   set    1, (iy+iy_0D-IYBASE)         ; 01:5315 - FD CB 0D CE
   ld     (hl), $8C                    ; 01:5319 - 36 8C

@good_ending_emerald_anim_0_already_done:
   ld     (ix+20), $17                 ; 01:531B - DD 36 14 17
   ld     a, (hl)                      ; 01:531F - 7E
   and    a                            ; 01:5320 - A7
   jr     z, @good_ending_emerald_anim_1_already_done  ; 01:5321 - 28 04
   dec    (hl)                         ; 01:5323 - 35
   jp     @continue_past_basic_movement_physics  ; 01:5324 - C3 39 4C

@good_ending_emerald_anim_1_already_done:
   ld     (ix+20), $19                 ; 01:5327 - DD 36 14 19
   jp     @continue_past_basic_movement_physics  ; 01:532B - C3 39 4C

@sonic_is_rolling:
   ld     a, (ix+14)                   ; 01:532E - DD 7E 0E
   cp     $18                          ; 01:5331 - FE 18
   jr     z, @skip_adjust_y_pos_before_roll  ; 01:5333 - 28 0A
   ld     hl, (sonic_y)                ; 01:5335 - 2A 01 D4
   ld     de, $0008                    ; 01:5338 - 11 08 00
   add    hl, de                       ; 01:533B - 19
   ld     (sonic_y), hl                ; 01:533C - 22 01 D4

@skip_adjust_y_pos_before_roll:
   ld     (ix+13), $18                 ; 01:533F - DD 36 0D 18
   ld     (ix+14), $18                 ; 01:5343 - DD 36 0E 18
   ld     hl, (sonic_vel_x_sub)        ; 01:5347 - 2A 03 D4
   ld     b, (ix+9)                    ; 01:534A - DD 46 09
   ld     c, $00                       ; 01:534D - 0E 00
   ld     e, c                         ; 01:534F - 59
   ld     d, c                         ; 01:5350 - 51
   ld     a, h                         ; 01:5351 - 7C
   or     l                            ; 01:5352 - B5
   or     b                            ; 01:5353 - B0
   jp     z, @consider_camera_look_down  ; 01:5354 - CA B9 53
   ld     (ix+20), $09                 ; 01:5357 - DD 36 14 09
   bit    2, (iy+g_inputs_player_1-IYBASE)  ; 01:535B - FD CB 03 56
   jr     nz, @dont_go_left_in_roll    ; 01:535F - 20 20
   bit    1, (iy+g_inputs_player_1-IYBASE)  ; 01:5361 - FD CB 03 4E
   jr     z, @dont_go_left_in_roll     ; 01:5365 - 28 1A
   bit    7, (ix+24)                   ; 01:5367 - DD CB 18 7E
   jp     z, @go_left_in_roll          ; 01:536B - CA 79 53
   bit    7, b                         ; 01:536E - CB 78
   jr     nz, @dont_go_right_in_roll   ; 01:5370 - 20 35
   res    0, (ix+24)                   ; 01:5372 - DD CB 18 86
   jp     @right_brake_to_left         ; 01:5376 - C3 A6 4F

@go_left_in_roll:
   ld     de, $FFF0                    ; 01:5379 - 11 F0 FF
   ld     c, $FF                       ; 01:537C - 0E FF
   jp     @update_x_velocity_from_basic_movement  ; 01:537E - C3 1B 4B

@dont_go_left_in_roll:
   bit    3, (iy+g_inputs_player_1-IYBASE)  ; 01:5381 - FD CB 03 5E
   jr     nz, @dont_go_right_in_roll   ; 01:5385 - 20 20
   bit    1, (iy+g_inputs_player_1-IYBASE)  ; 01:5387 - FD CB 03 4E
   jr     z, @dont_go_right_in_roll    ; 01:538B - 28 1A
   bit    7, (ix+24)                   ; 01:538D - DD CB 18 7E
   jp     z, @go_right_in_roll         ; 01:5391 - CA 9F 53
   bit    7, b                         ; 01:5394 - CB 78
   jr     z, @dont_go_right_in_roll    ; 01:5396 - 28 0F
   res    0, (ix+24)                   ; 01:5398 - DD CB 18 86
   jp     @right_brake_to_left         ; 01:539C - C3 A6 4F

@go_right_in_roll:
   ld     de, $0010                    ; 01:539F - 11 10 00
   ld     c, $00                       ; 01:53A2 - 0E 00
   jp     @update_x_velocity_from_basic_movement  ; 01:53A4 - C3 1B 4B

@dont_go_right_in_roll:
   ld     de, $0004                    ; 01:53A7 - 11 04 00
   ld     c, $00                       ; 01:53AA - 0E 00
   ld     a, b                         ; 01:53AC - 78
   and    a                            ; 01:53AD - A7
   jp     m, @update_x_velocity_from_basic_movement  ; 01:53AE - FA 1B 4B
   ld     de, $FFFC                    ; 01:53B1 - 11 FC FF
   ld     c, $FF                       ; 01:53B4 - 0E FF
   jp     @update_x_velocity_from_basic_movement  ; 01:53B6 - C3 1B 4B

@consider_camera_look_down:
   bit    7, (ix+24)                   ; 01:53B9 - DD CB 18 7E
   jr     z, @skip_camera_look_down    ; 01:53BD - 28 21
   ld     (ix+20), $07                 ; 01:53BF - DD 36 14 07
   res    0, (ix+24)                   ; 01:53C3 - DD CB 18 86
   ld     de, (g_camera_y_look_up_offset_px)  ; 01:53C7 - ED 5B B7 D2
   bit    7, d                         ; 01:53CB - CB 7A
   jr     z, @looking_up_immediate_look_down  ; 01:53CD - 28 09
   ld     hl, $FFB0                    ; 01:53CF - 21 B0 FF
   and    a                            ; 01:53D2 - A7
   sbc    hl, de                       ; 01:53D3 - ED 52
   jp     nc, @update_y_velocity_from_basic_movement  ; 01:53D5 - D2 49 4B

@looking_up_immediate_look_down:
   dec    de                           ; 01:53D8 - 1B
   ld     (g_camera_y_look_up_offset_px), de  ; 01:53D9 - ED 53 B7 D2
   jp     @update_y_velocity_from_basic_movement  ; 01:53DD - C3 49 4B

@skip_camera_look_down:
   ld     (ix+20), $09                 ; 01:53E0 - DD 36 14 09
   push   de                           ; 01:53E4 - D5
   push   hl                           ; 01:53E5 - E5
   bit    7, b                         ; 01:53E6 - CB 78
   jr     z, @skip_negating_x_vel_for_absolute_value_for_speed_cap  ; 01:53E8 - 28 07
   ld     a, l                         ; 01:53EA - 7D
   cpl                                 ; 01:53EB - 2F
   ld     l, a                         ; 01:53EC - 6F
   ld     a, h                         ; 01:53ED - 7C
   cpl                                 ; 01:53EE - 2F
   ld     h, a                         ; 01:53EF - 67
   inc    hl                           ; 01:53F0 - 23

@skip_negating_x_vel_for_absolute_value_for_speed_cap:
   ld     de, (g_sonic_x_speed_cap_subpx)  ; 01:53F1 - ED 5B 40 D2
   xor    a                            ; 01:53F5 - AF
   sbc    hl, de                       ; 01:53F6 - ED 52
   pop    hl                           ; 01:53F8 - E1
   pop    de                           ; 01:53F9 - D1
   jp     c, @update_x_velocity_from_basic_movement  ; 01:53FA - DA 1B 4B
   ld     c, a                         ; 01:53FD - 4F
   ld     e, c                         ; 01:53FE - 59
   ld     d, c                         ; 01:53FF - 51
   ld     (ix+20), $09                 ; 01:5400 - DD 36 14 09
   jp     @update_x_velocity_from_basic_movement  ; 01:5404 - C3 1B 4B

@update_y_velocity_for_rolling:
   bit    7, (ix+24)                   ; 01:5407 - DD CB 18 7E
   jr     z, @suppress_jump_button_loc2  ; 01:540B - 28 21
   bit    3, (ix+24)                   ; 01:540D - DD CB 18 5E
   jr     nz, @jump_continue_or_await_release_loc2  ; 01:5411 - 20 06
   bit    5, (iy+g_inputs_player_1-IYBASE)  ; 01:5413 - FD CB 03 6E
   jr     z, @suppress_jump_button_loc2  ; 01:5417 - 28 15

@jump_continue_or_await_release_loc2:
   bit    5, (iy+g_inputs_player_1-IYBASE)  ; 01:5419 - FD CB 03 6E
   jr     nz, @unsuppress_jump_button_loc2  ; 01:541D - 20 16
   res    0, (ix+24)                   ; 01:541F - DD CB 18 86
   ld     a, (sonic_vel_x_sub)         ; 01:5423 - 3A 03 D4
   and    $F8                          ; 01:5426 - E6 F8
   ld     (sonic_vel_x_sub), a         ; 01:5428 - 32 03 D4
   jp     @continue_jump_processing_from_rolling  ; 01:542B - C3 7F 4B

@suppress_jump_button_loc2:
   res    3, (ix+24)                   ; 01:542E - DD CB 18 9E
   jp     @continue_without_jumping_from_rolling  ; 01:5432 - C3 AC 4B

@unsuppress_jump_button_loc2:
   set    3, (ix+24)                   ; 01:5435 - DD CB 18 DE
   jp     @continue_without_jumping_from_rolling  ; 01:5439 - C3 AC 4B

@sonic_is_dying:
   set    5, (ix+24)                   ; 01:543C - DD CB 18 EE
   ld     a, (g_level_restart_countdown_timer)  ; 01:5440 - 3A 87 D2
   cp     $60                          ; 01:5443 - FE 60
   jr     z, @skip_sonic_vel_change_on_death  ; 01:5445 - 28 63
   ld     hl, (g_level_scroll_y_pix_lo)  ; 01:5447 - 2A 5D D2
   ld     de, $00C0                    ; 01:544A - 11 C0 00
   add    hl, de                       ; 01:544D - 19
   ld     de, (sonic_y)                ; 01:544E - ED 5B 01 D4
   sbc    hl, de                       ; 01:5452 - ED 52
   jr     nc, @dont_deduct_lives       ; 01:5454 - 30 16
   bit    2, (iy+iy_06_lvflag01-IYBASE)  ; 01:5456 - FD CB 06 56
   jr     nz, @dont_deduct_lives       ; 01:545A - 20 10
   ld     a, $01                       ; 01:545C - 3E 01
   ld     (g_sonic_died_at_least_once), a  ; 01:545E - 32 83 D2
   ld     hl, g_lives                  ; 01:5461 - 21 46 D2
   dec    (hl)                         ; 01:5464 - 35
   set    2, (iy+iy_06_lvflag01-IYBASE)  ; 01:5465 - FD CB 06 D6
   jp     @skip_sonic_vel_change_on_death  ; 01:5469 - C3 AA 54

@dont_deduct_lives:
   xor    a                            ; 01:546C - AF
   ld     hl, $0080                    ; 01:546D - 21 80 00
   bit    3, (iy+iy_08_lvflag03-IYBASE)  ; 01:5470 - FD CB 08 5E
   jr     nz, @select_sonic_drowning_y_vel_cap  ; 01:5474 - 20 25
   ld     de, (sonic_vel_y_sub)        ; 01:5476 - ED 5B 06 D4
   bit    7, d                         ; 01:547A - CB 7A
   jr     nz, @skip_y_vel_cap_when_going_up_on_death  ; 01:547C - 20 08
   ld     hl, $0600                    ; 01:547E - 21 00 06
   and    a                            ; 01:5481 - A7
   sbc    hl, de                       ; 01:5482 - ED 52
   jr     c, @apply_sonic_y_vel_cap_on_death  ; 01:5484 - 38 1B

@skip_y_vel_cap_when_going_up_on_death:
   ex     de, hl                       ; 01:5486 - EB
   ld     b, (ix+12)                   ; 01:5487 - DD 46 0C
   ld     a, h                         ; 01:548A - 7C
   cp     $80                          ; 01:548B - FE 80
   jr     nc, @dont_cap_sonic_y_vel_on_death  ; 01:548D - 30 04
   cp     $08                          ; 01:548F - FE 08
   jr     nc, @continue_from_capped_sonic_y_vel_on_death  ; 01:5491 - 30 05

@dont_cap_sonic_y_vel_on_death:
   ld     de, $0030                    ; 01:5493 - 11 30 00
   ld     c, $00                       ; 01:5496 - 0E 00

@continue_from_capped_sonic_y_vel_on_death:
   add    hl, de                       ; 01:5498 - 19
   ld     a, b                         ; 01:5499 - 78
   adc    a, c                         ; 01:549A - 89

@select_sonic_drowning_y_vel_cap:
   ld     (sonic_vel_y_sub), hl        ; 01:549B - 22 06 D4
   ld     (sonic_vel_y_hi), a          ; 01:549E - 32 08 D4

@apply_sonic_y_vel_cap_on_death:
   xor    a                            ; 01:54A1 - AF
   ld     l, a                         ; 01:54A2 - 6F
   ld     h, a                         ; 01:54A3 - 67
   ld     (sonic_vel_x_sub), hl        ; 01:54A4 - 22 03 D4
   ld     (sonic_vel_x_hi), a          ; 01:54A7 - 32 05 D4

@skip_sonic_vel_change_on_death:
   ld     (ix+20), $0B                 ; 01:54AA - DD 36 14 0B
   bit    3, (iy+iy_08_lvflag03-IYBASE)  ; 01:54AE - FD CB 08 5E
   jp     z, @continue_past_basic_movement_physics  ; 01:54B2 - CA 39 4C
   ld     (ix+20), $15                 ; 01:54B5 - DD 36 14 15
   jp     @continue_past_basic_movement_physics  ; 01:54B9 - C3 39 4C

@special_00_nothing:
   bit    7, (iy+iy_06_lvflag01-IYBASE)  ; 01:54BC - FD CB 06 7E
   ret    nz                           ; 01:54C0 - C0
   res    4, (ix+24)                   ; 01:54C1 - DD CB 18 A6
   ret                                 ; 01:54C5 - C9

@special_01_spikes:
   bit    0, (iy+iy_05_lvflag00-IYBASE)  ; 01:54C6 - FD CB 05 46
   jp     z, damage_sonic              ; 01:54CA - CA FD 35
   ret                                 ; 01:54CD - C9

@special_02_end_of_ramp_jump:
   ld     a, (ix+2)                    ; 01:54CE - DD 7E 02
   add    a, $0C                       ; 01:54D1 - C6 0C
   and    $1F                          ; 01:54D3 - E6 1F
   cp     $1A                          ; 01:54D5 - FE 1A
   ret    c                            ; 01:54D7 - D8
   ld     a, (sonic_flags_ix_24)       ; 01:54D8 - 3A 14 D4
   rrca                                ; 01:54DB - 0F
   jr     c, @continue_end_of_ramp_jump  ; 01:54DC - 38 03
   and    $02                          ; 01:54DE - E6 02
   ret    z                            ; 01:54E0 - C8

@continue_end_of_ramp_jump:
   ld     l, (ix+7)                    ; 01:54E1 - DD 6E 07
   ld     h, (ix+8)                    ; 01:54E4 - DD 66 08
   bit    7, (ix+9)                    ; 01:54E7 - DD CB 09 7E
   ret    nz                           ; 01:54EB - C0
   ld     de, $0301                    ; 01:54EC - 11 01 03
   and    a                            ; 01:54EF - A7
   sbc    hl, de                       ; 01:54F0 - ED 52
   ret    c                            ; 01:54F2 - D8
   ld     l, (ix+8)                    ; 01:54F3 - DD 6E 08
   ld     h, (ix+9)                    ; 01:54F6 - DD 66 09
   add    hl, hl                       ; 01:54F9 - 29
   ld     a, l                         ; 01:54FA - 7D
   cpl                                 ; 01:54FB - 2F
   ld     l, a                         ; 01:54FC - 6F
   ld     a, h                         ; 01:54FD - 7C
   cpl                                 ; 01:54FE - 2F
   ld     h, a                         ; 01:54FF - 67
   inc    hl                           ; 01:5500 - 23
   ld     (ix+10), $00                 ; 01:5501 - DD 36 0A 00
   ld     (ix+11), l                   ; 01:5505 - DD 75 0B
   ld     (ix+12), h                   ; 01:5508 - DD 74 0C
   ld     a, $05                       ; 01:550B - 3E 05
   rst    $28                          ; 01:550D - EF
   ret                                 ; 01:550E - C9

@special_03_spring_left_8_px_t:
   ld     a, (ix+2)                    ; 01:550F - DD 7E 02
   add    a, $0C                       ; 01:5512 - C6 0C
   and    $1F                          ; 01:5514 - E6 1F
   cp     $10                          ; 01:5516 - FE 10
   ret    c                            ; 01:5518 - D8
   ld     (ix+7), $00                  ; 01:5519 - DD 36 07 00
   ld     (ix+8), $F8                  ; 01:551D - DD 36 08 F8
   ld     (ix+9), $FF                  ; 01:5521 - DD 36 09 FF
   set    1, (ix+24)                   ; 01:5525 - DD CB 18 CE
   ld     a, $04                       ; 01:5529 - 3E 04
   rst    $28                          ; 01:552B - EF
   ret                                 ; 01:552C - C9

@special_04_spring_up_12_px_t:
   ld     a, (ix+2)                    ; 01:552D - DD 7E 02
   add    a, $0C                       ; 01:5530 - C6 0C
   and    $1F                          ; 01:5532 - E6 1F
   cp     $10                          ; 01:5534 - FE 10
   ret    c                            ; 01:5536 - D8
   bit    7, (ix+24)                   ; 01:5537 - DD CB 18 7E
   ret    z                            ; 01:553B - C8
   ld     a, (g_sonic_flags_copy)      ; 01:553C - 3A B9 D2
   and    $80                          ; 01:553F - E6 80
   ret    nz                           ; 01:5541 - C0
   res    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:5542 - FD CB 06 B6
   ld     (ix+10), $00                 ; 01:5546 - DD 36 0A 00
   ld     (ix+11), $F4                 ; 01:554A - DD 36 0B F4
   ld     (ix+12), $FF                 ; 01:554E - DD 36 0C FF
   ld     a, $04                       ; 01:5552 - 3E 04
   rst    $28                          ; 01:5554 - EF
   ret                                 ; 01:5555 - C9

@special_05_spring_right_8_px_t:
   ld     a, (ix+2)                    ; 01:5556 - DD 7E 02
   add    a, $0C                       ; 01:5559 - C6 0C
   and    $1F                          ; 01:555B - E6 1F
   cp     $10                          ; 01:555D - FE 10
   ret    nc                           ; 01:555F - D0
   res    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:5560 - FD CB 06 B6
   ld     (ix+7), $00                  ; 01:5564 - DD 36 07 00
   ld     (ix+8), $08                  ; 01:5568 - DD 36 08 08
   ld     (ix+9), $00                  ; 01:556C - DD 36 09 00
   res    1, (ix+24)                   ; 01:5570 - DD CB 18 8E
   ld     a, $04                       ; 01:5574 - 3E 04
   rst    $28                          ; 01:5576 - EF
   ret                                 ; 01:5577 - C9

@special_06_conveyor_left:
   bit    7, (ix+24)                   ; 01:5578 - DD CB 18 7E
   ret    z                            ; 01:557C - C8
   ld     hl, (sonic_x_sub)            ; 01:557D - 2A FD D3
   ld     a, (sonic_x_hi)              ; 01:5580 - 3A FF D3
   ld     de, $FE80                    ; 01:5583 - 11 80 FE
   add    hl, de                       ; 01:5586 - 19
   adc    a, $FF                       ; 01:5587 - CE FF
   ld     (sonic_x_sub), hl            ; 01:5589 - 22 FD D3
   ld     (sonic_x_hi), a              ; 01:558C - 32 FF D3
   ret                                 ; 01:558F - C9

@special_07_conveyor_right:
   bit    7, (ix+24)                   ; 01:5590 - DD CB 18 7E
   ret    z                            ; 01:5594 - C8
   ld     hl, (sonic_x_sub)            ; 01:5595 - 2A FD D3
   ld     a, (sonic_x_hi)              ; 01:5598 - 3A FF D3
   ld     de, $0200                    ; 01:559B - 11 00 02
   add    hl, de                       ; 01:559E - 19
   adc    a, $00                       ; 01:559F - CE 00
   ld     (sonic_x_sub), hl            ; 01:55A1 - 22 FD D3
   ld     (sonic_x_hi), a              ; 01:55A4 - 32 FF D3
   ret                                 ; 01:55A7 - C9

@special_08_underwater:
   bit    4, (ix+24)                   ; 01:55A8 - DD CB 18 66
   jr     nz, @splash_sound_on_underwater_08_entry  ; 01:55AC - 20 03
   ld     a, $12                       ; 01:55AE - 3E 12
   rst    $28                          ; 01:55B0 - EF

@splash_sound_on_underwater_08_entry:
   set    4, (ix+24)                   ; 01:55B1 - DD CB 18 E6
   ret                                 ; 01:55B5 - C9

@special_09_spring_up_12_px_t:
   ld     a, (ix+2)                    ; 01:55B6 - DD 7E 02
   add    a, $0C                       ; 01:55B9 - C6 0C
   and    $1F                          ; 01:55BB - E6 1F
   cp     $08                          ; 01:55BD - FE 08
   ret    c                            ; 01:55BF - D8
   cp     $18                          ; 01:55C0 - FE 18
   ret    nc                           ; 01:55C2 - D0
   bit    7, (ix+24)                   ; 01:55C3 - DD CB 18 7E
   ret    z                            ; 01:55C7 - C8
   ld     a, (g_sonic_flags_copy)      ; 01:55C8 - 3A B9 D2
   and    $80                          ; 01:55CB - E6 80
   ret    nz                           ; 01:55CD - C0
   res    6, (iy+iy_06_lvflag01-IYBASE)  ; 01:55CE - FD CB 06 B6
   ld     (ix+10), $00                 ; 01:55D2 - DD 36 0A 00
   ld     (ix+11), $F4                 ; 01:55D6 - DD 36 0B F4
   ld     (ix+12), $FF                 ; 01:55DA - DD 36 0C FF
   ld     a, $04                       ; 01:55DE - 3E 04
   rst    $28                          ; 01:55E0 - EF
   ret                                 ; 01:55E1 - C9

@special_0A_GHZ2_falling_sfx:
   bit    7, (ix+12)                   ; 01:55E2 - DD CB 0C 7E
   ret    nz                           ; 01:55E6 - C0
   ld     a, $05                       ; 01:55E7 - 3E 05
   rst    $28                          ; 01:55E9 - EF
   ret                                 ; 01:55EA - C9

@special_0B_teleport:
   bit    4, (iy+iy_06_lvflag01-IYBASE)  ; 01:55EB - FD CB 06 66
   ret    nz                           ; 01:55EF - C0
   ld     a, (sonic_x)                 ; 01:55F0 - 3A FE D3
   add    a, $0C                       ; 01:55F3 - C6 0C
   and    $1F                          ; 01:55F5 - E6 1F
   cp     $08                          ; 01:55F7 - FE 08
   ret    c                            ; 01:55F9 - D8
   cp     $18                          ; 01:55FA - FE 18
   ret    nc                           ; 01:55FC - D0
   ld     hl, (sonic_x)                ; 01:55FD - 2A FE D3
   ld     bc, $000C                    ; 01:5600 - 01 0C 00
   add    hl, bc                       ; 01:5603 - 09
   ld     a, l                         ; 01:5604 - 7D
   add    a, a                         ; 01:5605 - 87
   rl     h                            ; 01:5606 - CB 14
   add    a, a                         ; 01:5608 - 87
   rl     h                            ; 01:5609 - CB 14
   add    a, a                         ; 01:560B - 87
   rl     h                            ; 01:560C - CB 14
   ld     e, h                         ; 01:560E - 5C
   ld     hl, (sonic_y)                ; 01:560F - 2A 01 D4
   ld     bc, $0010                    ; 01:5612 - 01 10 00
   add    hl, bc                       ; 01:5615 - 09
   ld     a, l                         ; 01:5616 - 7D
   add    a, a                         ; 01:5617 - 87
   rl     h                            ; 01:5618 - CB 14
   add    a, a                         ; 01:561A - 87
   rl     h                            ; 01:561B - CB 14
   add    a, a                         ; 01:561D - 87
   rl     h                            ; 01:561E - CB 14
   ld     d, h                         ; 01:5620 - 54
   ld     hl, objfunc_00_sonic@special_0B_teleport_specs  ; 01:5621 - 21 43 56
   ld     b, $05                       ; 01:5624 - 06 05

@find_teleport_region:
   ld     a, (hl)                      ; 01:5626 - 7E
   inc    hl                           ; 01:5627 - 23
   cp     e                            ; 01:5628 - BB
   jr     nz, @not_this_teleport_region  ; 01:5629 - 20 11
   ld     a, (hl)                      ; 01:562B - 7E
   cp     d                            ; 01:562C - BA
   jr     nz, @not_this_teleport_region  ; 01:562D - 20 0D
   inc    hl                           ; 01:562F - 23
   ld     (g_teleport_spec_dest_ptr), hl  ; 01:5630 - 22 D5 D2
   ld     a, $50                       ; 01:5633 - 3E 50
   ld     (g_teleport_start_countdown_timer), a  ; 01:5635 - 32 8A D2
   ld     a, $06                       ; 01:5638 - 3E 06
   rst    $28                          ; 01:563A - EF
   ret                                 ; 01:563B - C9

@not_this_teleport_region:
   inc    hl                           ; 01:563C - 23
   inc    hl                           ; 01:563D - 23
   inc    hl                           ; 01:563E - 23
   inc    hl                           ; 01:563F - 23
   djnz   @find_teleport_region        ; 01:5640 - 10 E4
   ret                                 ; 01:5642 - C9

@special_0B_teleport_specs:
.db $34, $3C, $34, $2F, $00, $19, $3A, $19, $04, $00, $0E, $3A, $00, $00, $16, $1B  ; 01:5643
.db $32, $00, $00, $17, $2F, $0C, $00, $00, $FF                                     ; 01:5653

@special_0C_underwater_accel_left_8_subpx_t2:
   ld     hl, (sonic_vel_x_sub)        ; 01:565C - 2A 03 D4
   ld     a, (sonic_vel_x_hi)          ; 01:565F - 3A 05 D4
   ld     de, $FFF8                    ; 01:5662 - 11 F8 FF
   add    hl, de                       ; 01:5665 - 19
   adc    a, $FF                       ; 01:5666 - CE FF
   ld     (sonic_vel_x_sub), hl        ; 01:5668 - 22 03 D4
   ld     (sonic_vel_x_hi), a          ; 01:566B - 32 05 D4
   bit    4, (ix+24)                   ; 01:566E - DD CB 18 66
   jr     nz, @splash_sound_on_underwater_0C_entry  ; 01:5672 - 20 03
   ld     a, $12                       ; 01:5674 - 3E 12
   rst    $28                          ; 01:5676 - EF

@splash_sound_on_underwater_0C_entry:
   set    4, (ix+24)                   ; 01:5677 - DD CB 18 E6
   ret                                 ; 01:567B - C9

@special_0D_slide_right_5_px_t:
   xor    a                            ; 01:567C - AF
   ld     hl, $0005                    ; 01:567D - 21 05 00
   ld     (sonic_vel_x_sub), a         ; 01:5680 - 32 03 D4
   ld     (sonic_vel_x), hl            ; 01:5683 - 22 04 D4
   res    1, (ix+24)                   ; 01:5686 - DD CB 18 8E

@set_directional_input_suppression:
   ld     a, $06                       ; 01:568A - 3E 06
   ld     (g_directional_input_suppression_timer), a  ; 01:568C - 32 8C D2

@fn_enforce_directional_input_suppression:
   ld     a, (iy+g_inputs_player_1-IYBASE)  ; 01:568F - FD 7E 03
   or     $0F                          ; 01:5692 - F6 0F
   ld     (iy+g_inputs_player_1-IYBASE), a  ; 01:5694 - FD 77 03
   ld     hl, $0004                    ; 01:5697 - 21 04 00
   ld     (sonic_vel_y), hl            ; 01:569A - 22 07 D4
   res    0, (ix+24)                   ; 01:569D - DD CB 18 86
   res    2, (ix+24)                   ; 01:56A1 - DD CB 18 96
   ret                                 ; 01:56A5 - C9

@special_0E_slide_right_6_px_t:
   xor    a                            ; 01:56A6 - AF
   ld     hl, $0006                    ; 01:56A7 - 21 06 00
   ld     (sonic_vel_x_sub), a         ; 01:56AA - 32 03 D4
   ld     (sonic_vel_x), hl            ; 01:56AD - 22 04 D4
   res    1, (ix+24)                   ; 01:56B0 - DD CB 18 8E
   jr     @set_directional_input_suppression  ; 01:56B4 - 18 D4

@special_0F_slide_left_5_px_t:
   xor    a                            ; 01:56B6 - AF
   ld     hl, $FFFB                    ; 01:56B7 - 21 FB FF
   ld     (sonic_vel_x_sub), a         ; 01:56BA - 32 03 D4
   ld     (sonic_vel_x), hl            ; 01:56BD - 22 04 D4
   set    1, (ix+24)                   ; 01:56C0 - DD CB 18 CE
   jr     @set_directional_input_suppression  ; 01:56C4 - 18 C4

@special_10_slide_left_6_px_t:
   xor    a                            ; 01:56C6 - AF
   ld     hl, $FFFA                    ; 01:56C7 - 21 FA FF
   ld     (sonic_vel_x_sub), a         ; 01:56CA - 32 03 D4
   ld     (sonic_vel_x), hl            ; 01:56CD - 22 04 D4
   set    1, (ix+24)                   ; 01:56D0 - DD CB 18 CE
   jr     @set_directional_input_suppression  ; 01:56D4 - 18 B4

@special_11_bumper_special_stage:
   ld     a, (g_special_stage_round_bumper_cooldown_timer)  ; 01:56D6 - 3A E1 D2
   cp     $08                          ; 01:56D9 - FE 08
   ret    nc                           ; 01:56DB - D0
   call   @fn_apply_special_stage_bouncies_x_vel  ; 01:56DC - CD 27 57
   ld     de, $0001                    ; 01:56DF - 11 01 00
   ld     hl, (sonic_vel_y_sub)        ; 01:56E2 - 2A 06 D4
   ld     a, l                         ; 01:56E5 - 7D
   cpl                                 ; 01:56E6 - 2F
   ld     l, a                         ; 01:56E7 - 6F
   ld     a, h                         ; 01:56E8 - 7C
   cpl                                 ; 01:56E9 - 2F
   ld     h, a                         ; 01:56EA - 67
   ld     a, (sonic_vel_y_hi)          ; 01:56EB - 3A 08 D4
   cpl                                 ; 01:56EE - 2F
   add    hl, de                       ; 01:56EF - 19
   adc    a, $00                       ; 01:56F0 - CE 00
   and    a                            ; 01:56F2 - A7
   jp     p, @round_bumper_select_upwards_y_vel  ; 01:56F3 - F2 FC 56
   ld     de, $FFC8                    ; 01:56F6 - 11 C8 FF
   add    hl, de                       ; 01:56F9 - 19
   adc    a, $FF                       ; 01:56FA - CE FF

@round_bumper_select_upwards_y_vel:
   ld     (sonic_vel_y_sub), hl        ; 01:56FC - 22 06 D4
   ld     (sonic_vel_y_hi), a          ; 01:56FF - 32 08 D4
   ld     bc, $000C                    ; 01:5702 - 01 0C 00
   ld     hl, (sonic_x)                ; 01:5705 - 2A FE D3
   add    hl, bc                       ; 01:5708 - 09
   ld     a, l                         ; 01:5709 - 7D
   and    $E0                          ; 01:570A - E6 E0
   ld     l, a                         ; 01:570C - 6F
   ld     (g_special_stage_round_bumper_anim_sprite_x), hl  ; 01:570D - 22 E2 D2
   ld     bc, $0010                    ; 01:5710 - 01 10 00
   ld     hl, (sonic_y)                ; 01:5713 - 2A 01 D4
   add    hl, bc                       ; 01:5716 - 09
   ld     a, l                         ; 01:5717 - 7D
   and    $E0                          ; 01:5718 - E6 E0
   ld     l, a                         ; 01:571A - 6F
   ld     (g_special_stage_round_bumper_anim_sprite_y), hl  ; 01:571B - 22 E4 D2
   ld     a, $10                       ; 01:571E - 3E 10
   ld     (g_special_stage_round_bumper_cooldown_timer), a  ; 01:5720 - 32 E1 D2
   ld     a, $07                       ; 01:5723 - 3E 07
   rst    $28                          ; 01:5725 - EF
   ret                                 ; 01:5726 - C9

@fn_apply_special_stage_bouncies_x_vel:
   ld     hl, (sonic_vel_x_sub)        ; 01:5727 - 2A 03 D4
   ld     a, (sonic_vel_x_hi)          ; 01:572A - 3A 05 D4
   ld     c, a                         ; 01:572D - 4F
   and    $80                          ; 01:572E - E6 80
   ld     b, a                         ; 01:5730 - 47
   ld     a, (sonic_x)                 ; 01:5731 - 3A FE D3
   add    a, $0C                       ; 01:5734 - C6 0C
   and    $1F                          ; 01:5736 - E6 1F
   sub    $10                          ; 01:5738 - D6 10
   and    $80                          ; 01:573A - E6 80
   cp     b                            ; 01:573C - B8
   jr     z, @skip_invert_x_vel_on_bouncy  ; 01:573D - 28 09
   ld     a, l                         ; 01:573F - 7D
   cpl                                 ; 01:5740 - 2F
   ld     l, a                         ; 01:5741 - 6F
   ld     a, h                         ; 01:5742 - 7C
   cpl                                 ; 01:5743 - 2F
   ld     h, a                         ; 01:5744 - 67
   ld     a, c                         ; 01:5745 - 79
   cpl                                 ; 01:5746 - 2F
   ld     c, a                         ; 01:5747 - 4F

@skip_invert_x_vel_on_bouncy:
   ld     de, $0001                    ; 01:5748 - 11 01 00
   ld     a, c                         ; 01:574B - 79
   add    hl, de                       ; 01:574C - 19
   adc    a, $00                       ; 01:574D - CE 00
   ld     e, l                         ; 01:574F - 5D
   ld     d, h                         ; 01:5750 - 54
   ld     c, a                         ; 01:5751 - 4F
   sra    c                            ; 01:5752 - CB 29
   rr     d                            ; 01:5754 - CB 1A
   rr     e                            ; 01:5756 - CB 1B
   add    hl, de                       ; 01:5758 - 19
   adc    a, c                         ; 01:5759 - 89
   ld     (sonic_vel_x_sub), hl        ; 01:575A - 22 03 D4
   ld     (sonic_vel_x_hi), a          ; 01:575D - 32 05 D4
   ret                                 ; 01:5760 - C9

@special_12_spring_up_10_px_t_special_stage:
   ld     (ix+10), $00                 ; 01:5761 - DD 36 0A 00
   ld     (ix+11), $F6                 ; 01:5765 - DD 36 0B F6
   ld     (ix+12), $FF                 ; 01:5769 - DD 36 0C FF
   ld     a, $04                       ; 01:576D - 3E 04
   rst    $28                          ; 01:576F - EF
   ret                                 ; 01:5770 - C9

@special_13_spring_up_12_px_t_special_stage:
   ld     (ix+10), $00                 ; 01:5771 - DD 36 0A 00
   ld     (ix+11), $F4                 ; 01:5775 - DD 36 0B F4
   ld     (ix+12), $FF                 ; 01:5779 - DD 36 0C FF
   ld     a, $04                       ; 01:577D - 3E 04
   rst    $28                          ; 01:577F - EF
   ret                                 ; 01:5780 - C9

@special_14_spring_up_14_px_t_special_stage:
   ld     (ix+10), $00                 ; 01:5781 - DD 36 0A 00
   ld     (ix+11), $F2                 ; 01:5785 - DD 36 0B F2
   ld     (ix+12), $FF                 ; 01:5789 - DD 36 0C FF
   ld     a, $04                       ; 01:578D - 3E 04
   rst    $28                          ; 01:578F - EF
   ret                                 ; 01:5790 - C9

@special_15_bouncebar_middle_special_stage:
   ld     a, (g_pal_flash_countdown_timer)  ; 01:5791 - 3A B1 D2
   and    a                            ; 01:5794 - A7
   ret    nz                           ; 01:5795 - C0
   ld     de, $0001                    ; 01:5796 - 11 01 00
   ld     hl, (sonic_vel_x_sub)        ; 01:5799 - 2A 03 D4
   ld     a, l                         ; 01:579C - 7D
   cpl                                 ; 01:579D - 2F
   ld     l, a                         ; 01:579E - 6F
   ld     a, h                         ; 01:579F - 7C
   cpl                                 ; 01:57A0 - 2F
   ld     h, a                         ; 01:57A1 - 67
   ld     a, (sonic_vel_x_hi)          ; 01:57A2 - 3A 05 D4
   cpl                                 ; 01:57A5 - 2F
   add    hl, de                       ; 01:57A6 - 19
   adc    a, $00                       ; 01:57A7 - CE 00
   ld     de, $FF00                    ; 01:57A9 - 11 00 FF
   ld     c, $FF                       ; 01:57AC - 0E FF
   jp     m, @bouncebar_middle_x_vel_is_negative  ; 01:57AE - FA B6 57
   ld     de, $0100                    ; 01:57B1 - 11 00 01
   ld     c, $00                       ; 01:57B4 - 0E 00

@bouncebar_middle_x_vel_is_negative:
   add    hl, de                       ; 01:57B6 - 19
   adc    a, c                         ; 01:57B7 - 89
   ld     (sonic_vel_x_sub), hl        ; 01:57B8 - 22 03 D4
   ld     (sonic_vel_x_hi), a          ; 01:57BB - 32 05 D4

@continue_from_other_bouncies:
   ld     hl, g_pal_flash_countdown_timer  ; 01:57BE - 21 B1 D2
   ld     (hl), $04                    ; 01:57C1 - 36 04
   inc    hl                           ; 01:57C3 - 23
   ld     (hl), $0E                    ; 01:57C4 - 36 0E
   inc    hl                           ; 01:57C6 - 23
   ld     (hl), $3F                    ; 01:57C7 - 36 3F
   ld     a, $07                       ; 01:57C9 - 3E 07
   rst    $28                          ; 01:57CB - EF
   ret                                 ; 01:57CC - C9

@special_16_bouncebar_end_special_stage:
   call   @fn_apply_special_stage_bouncies_x_vel  ; 01:57CD - CD 27 57
   ld     de, $0001                    ; 01:57D0 - 11 01 00
   ld     hl, (sonic_vel_y_sub)        ; 01:57D3 - 2A 06 D4
   ld     a, l                         ; 01:57D6 - 7D
   cpl                                 ; 01:57D7 - 2F
   ld     l, a                         ; 01:57D8 - 6F
   ld     a, h                         ; 01:57D9 - 7C
   cpl                                 ; 01:57DA - 2F
   ld     h, a                         ; 01:57DB - 67
   ld     a, (sonic_vel_y_hi)          ; 01:57DC - 3A 08 D4
   cpl                                 ; 01:57DF - 2F
   add    hl, de                       ; 01:57E0 - 19
   adc    a, $00                       ; 01:57E1 - CE 00
   and    a                            ; 01:57E3 - A7
   jp     p, @bouncebar_end_select_upwards_y_vel  ; 01:57E4 - F2 ED 57
   ld     de, $FFC8                    ; 01:57E7 - 11 C8 FF
   add    hl, de                       ; 01:57EA - 19
   adc    a, $FF                       ; 01:57EB - CE FF

@bouncebar_end_select_upwards_y_vel:
   ld     (sonic_vel_y_sub), hl        ; 01:57ED - 22 06 D4
   ld     (sonic_vel_y_hi), a          ; 01:57F0 - 32 08 D4
   jp     @continue_from_other_bouncies  ; 01:57F3 - C3 BE 57

@special_17_SKY1_lightning:
   ld     hl, (g_lightning_timer)      ; 01:57F6 - 2A E9 D2
   ld     de, $0082                    ; 01:57F9 - 11 82 00
   and    a                            ; 01:57FC - A7
   sbc    hl, de                       ; 01:57FD - ED 52
   ret    c                            ; 01:57FF - D8
   bit    0, (iy+iy_05_lvflag00-IYBASE)  ; 01:5800 - FD CB 05 46
   jp     z, damage_sonic              ; 01:5804 - CA FD 35
   ret                                 ; 01:5807 - C9

@special_18_collapsing_bridge_both_sides:
   ld     a, (sonic_flags_ix_24)       ; 01:5808 - 3A 14 D4
   rlca                                ; 01:580B - 07
   ret    nc                           ; 01:580C - D0
   ld     hl, (sonic_x)                ; 01:580D - 2A FE D3
   ld     bc, $000C                    ; 01:5810 - 01 0C 00
   add    hl, bc                       ; 01:5813 - 09
   ld     a, l                         ; 01:5814 - 7D
   and    $1F                          ; 01:5815 - E6 1F
   cp     $10                          ; 01:5817 - FE 10
   jr     nc, @collapsing_bridge_continue_right_side  ; 01:5819 - 30 3D

@collapsing_bridge_continue_left_side:
   ld     hl, (sonic_x)                ; 01:581B - 2A FE D3
   ld     bc, $000C                    ; 01:581E - 01 0C 00
   add    hl, bc                       ; 01:5821 - 09
   ld     a, l                         ; 01:5822 - 7D
   and    $E0                          ; 01:5823 - E6 E0
   ld     c, a                         ; 01:5825 - 4F
   ld     b, h                         ; 01:5826 - 44
   ld     hl, (sonic_y)                ; 01:5827 - 2A 01 D4
   ld     de, $0010                    ; 01:582A - 11 10 00
   add    hl, de                       ; 01:582D - 19
   ld     a, l                         ; 01:582E - 7D
   and    $E0                          ; 01:582F - E6 E0
   ld     e, a                         ; 01:5831 - 5F
   ld     d, h                         ; 01:5832 - 54
   call   @spawn_falling_bridge_piece  ; 01:5833 - CD 93 58
   ret    c                            ; 01:5836 - D8
   ld     bc, $000C                    ; 01:5837 - 01 0C 00
   ld     de, $0010                    ; 01:583A - 11 10 00
   call   get_obj_level_tile_ptr_in_ram  ; 01:583D - CD F9 36
   ld     c, $00                       ; 01:5840 - 0E 00
   ld     a, (hl)                      ; 01:5842 - 7E
   cp     $8A                          ; 01:5843 - FE 8A
   jr     z, @collapsing_bridge_write_tile_back_now  ; 01:5845 - 28 02
   ld     c, $89                       ; 01:5847 - 0E 89

@collapsing_bridge_write_tile_back_now:
   ld     (hl), c                      ; 01:5849 - 71
   ret                                 ; 01:584A - C9

@special_19_collapsing_bridge_right_only:
   ld     hl, (sonic_x)                ; 01:584B - 2A FE D3
   ld     bc, $000C                    ; 01:584E - 01 0C 00
   add    hl, bc                       ; 01:5851 - 09
   ld     a, l                         ; 01:5852 - 7D
   and    $1F                          ; 01:5853 - E6 1F
   cp     $10                          ; 01:5855 - FE 10
   ret    c                            ; 01:5857 - D8

@collapsing_bridge_continue_right_side:
   ld     a, l                         ; 01:5858 - 7D
   and    $E0                          ; 01:5859 - E6 E0
   add    a, $10                       ; 01:585B - C6 10
   ld     c, a                         ; 01:585D - 4F
   ld     b, h                         ; 01:585E - 44
   ld     hl, (sonic_y)                ; 01:585F - 2A 01 D4
   ld     de, $0010                    ; 01:5862 - 11 10 00
   add    hl, de                       ; 01:5865 - 19
   ld     a, l                         ; 01:5866 - 7D
   and    $E0                          ; 01:5867 - E6 E0
   ld     e, a                         ; 01:5869 - 5F
   ld     d, h                         ; 01:586A - 54
   call   @spawn_falling_bridge_piece  ; 01:586B - CD 93 58
   ret    c                            ; 01:586E - D8
   ld     bc, $000C                    ; 01:586F - 01 0C 00
   ld     de, $0010                    ; 01:5872 - 11 10 00
   call   get_obj_level_tile_ptr_in_ram  ; 01:5875 - CD F9 36
   ld     c, $00                       ; 01:5878 - 0E 00
   ld     a, (hl)                      ; 01:587A - 7E
   cp     $89                          ; 01:587B - FE 89
   jr     z, @collapsing_bridge_write_tile_back_now  ; 01:587D - 28 CA
   ld     c, $8A                       ; 01:587F - 0E 8A
   ld     (hl), c                      ; 01:5881 - 71
   ret                                 ; 01:5882 - C9

@special_1A_collapsing_bridge_left_only:
   ld     hl, (sonic_x)                ; 01:5883 - 2A FE D3
   ld     bc, $000C                    ; 01:5886 - 01 0C 00
   add    hl, bc                       ; 01:5889 - 09
   ld     a, l                         ; 01:588A - 7D
   and    $1F                          ; 01:588B - E6 1F
   cp     $10                          ; 01:588D - FE 10
   ret    nc                           ; 01:588F - D0
   jp     @collapsing_bridge_continue_left_side  ; 01:5890 - C3 1B 58

@spawn_falling_bridge_piece:
   push   bc                           ; 01:5893 - C5
   push   de                           ; 01:5894 - D5
   call   spawn_object                 ; 01:5895 - CD 7B 7C
   pop    de                           ; 01:5898 - D1
   pop    bc                           ; 01:5899 - C1
   ret    c                            ; 01:589A - D8
   push   ix                           ; 01:589B - DD E5
   push   hl                           ; 01:589D - E5
   pop    ix                           ; 01:589E - DD E1
   xor    a                            ; 01:58A0 - AF
   ld     (ix+0), $2E                  ; 01:58A1 - DD 36 00 2E
   ld     (ix+1), a                    ; 01:58A5 - DD 77 01
   ld     (ix+2), c                    ; 01:58A8 - DD 71 02
   ld     (ix+3), b                    ; 01:58AB - DD 70 03
   ld     (ix+4), a                    ; 01:58AE - DD 77 04
   ld     (ix+5), e                    ; 01:58B1 - DD 73 05
   ld     (ix+6), d                    ; 01:58B4 - DD 72 06
   ld     (ix+7), a                    ; 01:58B7 - DD 77 07
   ld     (ix+8), a                    ; 01:58BA - DD 77 08
   ld     (ix+9), a                    ; 01:58BD - DD 77 09
   ld     (ix+10), a                   ; 01:58C0 - DD 77 0A
   ld     (ix+11), a                   ; 01:58C3 - DD 77 0B
   ld     (ix+12), a                   ; 01:58C6 - DD 77 0C
   ld     (ix+24), a                   ; 01:58C9 - DD 77 18
   pop    ix                           ; 01:58CC - DD E1
   and    a                            ; 01:58CE - A7
   ret                                 ; 01:58CF - C9

@special_1B_upwards_offscreen_input_suppressor:
   bit    7, (ix+24)                   ; 01:58D0 - DD CB 18 7E
   ret    z                            ; 01:58D4 - C8
   ld     hl, (sonic_y)                ; 01:58D5 - 2A 01 D4
   ld     de, (g_level_scroll_y_pix_lo)  ; 01:58D8 - ED 5B 5D D2
   and    a                            ; 01:58DC - A7
   sbc    hl, de                       ; 01:58DD - ED 52
   ret    nc                           ; 01:58DF - D0
   ld     (iy+g_inputs_player_1-IYBASE), $FF  ; 01:58E0 - FD 36 03 FF
   ret                                 ; 01:58E4 - C9

CODEPTRTAB_sonic_tile_specials:
.dw objfunc_00_sonic@special_00_nothing, objfunc_00_sonic@special_01_spikes, objfunc_00_sonic@special_02_end_of_ramp_jump, objfunc_00_sonic@special_03_spring_left_8_px_t, objfunc_00_sonic@special_04_spring_up_12_px_t, objfunc_00_sonic@special_05_spring_right_8_px_t, objfunc_00_sonic@special_06_conveyor_left, objfunc_00_sonic@special_07_conveyor_right  ; 01:58E5
.dw objfunc_00_sonic@special_08_underwater, objfunc_00_sonic@special_09_spring_up_12_px_t, objfunc_00_sonic@special_0A_GHZ2_falling_sfx, objfunc_00_sonic@special_0B_teleport, objfunc_00_sonic@special_0C_underwater_accel_left_8_subpx_t2, objfunc_00_sonic@special_0D_slide_right_5_px_t, objfunc_00_sonic@special_0E_slide_right_6_px_t, objfunc_00_sonic@special_0F_slide_left_5_px_t  ; 01:58F5
.dw objfunc_00_sonic@special_10_slide_left_6_px_t, objfunc_00_sonic@special_11_bumper_special_stage, objfunc_00_sonic@special_12_spring_up_10_px_t_special_stage, objfunc_00_sonic@special_13_spring_up_12_px_t_special_stage, objfunc_00_sonic@special_14_spring_up_14_px_t_special_stage, objfunc_00_sonic@special_15_bouncebar_middle_special_stage, objfunc_00_sonic@special_16_bouncebar_end_special_stage, objfunc_00_sonic@special_17_SKY1_lightning  ; 01:5905
.dw objfunc_00_sonic@special_18_collapsing_bridge_both_sides, objfunc_00_sonic@special_19_collapsing_bridge_right_only, objfunc_00_sonic@special_1A_collapsing_bridge_left_only, objfunc_00_sonic@special_1B_upwards_offscreen_input_suppressor  ; 01:5915

SPRITEMAP_sonic_normal:
.db $B4, $B6, $B8, $FF, $FF, $FF, $BA, $BC, $BE, $FF, $FF, $FF, $FF, $FF            ; 01:591D

;; v TODO: This is vestigial for upside-down mode, but could be useful later? --GM
SPRITEMAP_sonic_hflip:
.db $B8, $B6, $B4, $FF, $FF, $FF, $BE, $BC, $BA, $FF, $FF, $FF, $FF, $FF            ; 01:592B

SPRITEMAP_sonic_upspring_right:
.db $B4, $B6, $B8, $FF, $FF, $FF, $BA, $BC, $BE, $FF, $FF, $FF, $98, $9A, $FF, $FF  ; 01:5939
.db $FF, $FF                                                                        ; 01:5949

SPRITEMAP_sonic_upspring_left:
.db $B4, $B6, $B8, $FF, $FF, $FF, $BA, $BC, $BE, $FF, $FF, $FF, $FE, $9C, $9E, $FF  ; 01:594B
.db $FF, $FF                                                                        ; 01:595B

TILEREPLACE_ring_blanking:
.db $00, $00, $00, $00, $00, $00, $00, $00                                          ; 01:595D

LUT_sonic_anim_ptrs:
.dw sonic_anim_00_01_walking, sonic_anim_00_01_walking, sonic_anim_02, sonic_anim_03_EMPTY_ANIM_HANGS_GAME, sonic_anim_04, sonic_anim_05, sonic_anim_06, sonic_anim_07_look_down  ; 01:5965
.dw sonic_anim_08, sonic_anim_09_rolling, sonic_anim_0A_braking, sonic_anim_0B_death, sonic_anim_0C_look_up, sonic_anim_0D_bored, sonic_anim_0E_teleport_disappear, sonic_anim_0F_teleport_spin  ; 01:5975
.dw sonic_anim_10, sonic_anim_11, sonic_anim_12, sonic_anim_13_upspring, sonic_anim_14, sonic_anim_15_death_by_drowning, sonic_anim_16, sonic_anim_17_dropped_rings_00_03  ; 01:5985
.dw sonic_anim_18_dropped_rings_01_04, sonic_anim_19_dropped_rings_02_05            ; 01:5995

sonic_anim_00_01_walking:
.db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01  ; 01:5999
.db $02, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03  ; 01:59A9
.db $04, $04, $04, $04, $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05  ; 01:59B9
.db $FF, $00                                                                        ; 01:59C9

sonic_anim_02:
.db $0D, $0D, $0D, $0D, $0E, $0E, $0E, $0E, $0F, $0F, $0F, $0F, $10, $10, $10, $10  ; 01:59CB
.db $FF, $00                                                                        ; 01:59DB

sonic_anim_03_EMPTY_ANIM_HANGS_GAME:
.db $FF, $00                                                                        ; 01:59DD

sonic_anim_04:
.db $13, $FF, $00                                                                   ; 01:59DF

sonic_anim_05:
.db $06, $FF, $00                                                                   ; 01:59E2

sonic_anim_06:
.db $08, $08, $08, $08, $09, $09, $09, $09, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0B  ; 01:59E5
.db $0C, $0C, $0C, $0C, $FF, $00                                                    ; 01:59F5

sonic_anim_07_look_down:
.db $07, $FF, $00                                                                   ; 01:59FB

sonic_anim_08:
.db $00, $FF, $00                                                                   ; 01:59FE

sonic_anim_09_rolling:
.db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C  ; 01:5A01
.db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08  ; 01:5A11
.db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09  ; 01:5A21
.db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A  ; 01:5A31
.db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B  ; 01:5A41
.db $FF, $00                                                                        ; 01:5A51

sonic_anim_0A_braking:
.db $13, $13, $13, $13, $13, $13, $13, $13, $25, $25, $25, $25, $25, $25, $25, $25  ; 01:5A53
.db $FF, $00                                                                        ; 01:5A63

sonic_anim_0B_death:
.db $11, $FF, $00                                                                   ; 01:5A65

sonic_anim_0C_look_up:
.db $14, $FF, $00                                                                   ; 01:5A68

sonic_anim_0D_bored:
.db $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16  ; 01:5A6B
.db $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15, $15  ; 01:5A7B
.db $15, $15, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $16  ; 01:5A8B
.db $16, $16, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17, $17  ; 01:5A9B
.db $17, $17, $FF, $22                                                              ; 01:5AAB

sonic_anim_0E_teleport_disappear:
.db $19, $19, $19, $19, $1A, $1A, $1B, $1B, $1C, $1C, $1D, $1D, $1E, $1E, $1F, $1F  ; 01:5AAF
.db $20, $20, $21, $21, $FF, $12                                                    ; 01:5ABF

sonic_anim_0F_teleport_spin:
.db $0C, $08, $09, $0A, $0B, $FF, $00                                               ; 01:5AC5

sonic_anim_10:
.db $12, $12, $FF, $00                                                              ; 01:5ACC

sonic_anim_11:
.db $12, $12, $12, $12, $12, $12, $24, $24, $24, $24, $24, $24, $FF, $00            ; 01:5AD0

sonic_anim_12:
.db $00, $FF, $00                                                                   ; 01:5ADE

sonic_anim_13_upspring:
.db $26, $FF, $00                                                                   ; 01:5AE1

sonic_anim_14:
.db $22, $FF, $00                                                                   ; 01:5AE4

sonic_anim_15_death_by_drowning:
.db $23, $FF, $00                                                                   ; 01:5AE7

sonic_anim_16:
.db $21, $21, $20, $20, $1F, $1F, $1E, $1E, $1D, $1D, $1C, $1C, $1B, $1B, $1A, $1A  ; 01:5AEA
.db $19, $19, $19, $19, $FF, $12                                                    ; 01:5AFA

sonic_anim_17_dropped_rings_00_03:
.db $19, $FF, $00                                                                   ; 01:5B00

sonic_anim_18_dropped_rings_01_04:
.db $1A, $FF, $00                                                                   ; 01:5B03

sonic_anim_19_dropped_rings_02_05:
.db $1B, $FF, $00                                                                   ; 01:5B06
