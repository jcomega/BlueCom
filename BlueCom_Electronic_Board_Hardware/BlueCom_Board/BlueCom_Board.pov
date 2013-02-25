//Fichier POVRay crée par 3d41.ulp v20110101
//D:/Electronique travail/BlueCom/Electronique_Board_RevA/BlueCom_Board/BlueCom_Board.brd
//07/08/2012 22:17:38

#version 3.5;

//Set to on if the file should be used as .inc
#local use_file_as_inc = off;
#if(use_file_as_inc=off)


//changes the apperance of resistors (1 Blob / 0 real)
#declare global_res_shape = 1;
//randomize color of resistors 1=random 0=same color
#declare global_res_colselect = 0;
//Number of the color for the resistors
//0=Green, 1="normal color" 2=Blue 3=Brown
#declare global_res_col = 1;
//Set to on if you want to render the PCB upside-down
#declare pcb_upsidedown = off;
//Set to x or z to rotate around the corresponding axis (referring to pcb_upsidedown)
#declare pcb_rotdir = x;
//Set the length off short pins over the PCB
#declare pin_length = 2.5;
#declare global_diode_bend_radius = 1;
#declare global_res_bend_radius = 1;
#declare global_solder = on;

#declare global_show_screws = on;
#declare global_show_washers = on;
#declare global_show_nuts = on;

#declare global_use_radiosity = on;

#declare global_ambient_mul = 1;
#declare global_ambient_mul_emit = 0;

//Animation
#declare global_anim = off;
#local global_anim_showcampath = no;

#declare global_fast_mode = off;

#declare col_preset = 2;
#declare pin_short = on;

#declare e3d_environment = off;

#local cam_x = 0;
#local cam_y = 512;
#local cam_z = -229;
#local cam_a = 20;
#local cam_look_x = 0;
#local cam_look_y = -10;
#local cam_look_z = 0;

#local pcb_rotate_x = 0;
#local pcb_rotate_y = 0;
#local pcb_rotate_z = 0;

#local pcb_board = on;
#local pcb_parts = on;
#local pcb_wire_bridges = off;
#if(global_fast_mode=off)
	#local pcb_polygons = on;
	#local pcb_silkscreen = on;
	#local pcb_wires = on;
	#local pcb_pads_smds = on;
#else
	#local pcb_polygons = off;
	#local pcb_silkscreen = off;
	#local pcb_wires = off;
	#local pcb_pads_smds = off;
#end

#local lgt1_pos_x = 60;
#local lgt1_pos_y = 91;
#local lgt1_pos_z = 53;
#local lgt1_intense = 0.928571;
#local lgt2_pos_x = -60;
#local lgt2_pos_y = 91;
#local lgt2_pos_z = 53;
#local lgt2_intense = 0.928571;
#local lgt3_pos_x = 60;
#local lgt3_pos_y = 91;
#local lgt3_pos_z = -36;
#local lgt3_intense = 0.928571;
#local lgt4_pos_x = -60;
#local lgt4_pos_y = 91;
#local lgt4_pos_z = -36;
#local lgt4_intense = 0.928571;

//Do not change these values
#declare pcb_height = 1.500000;
#declare pcb_cuheight = 0.035000;
#declare pcb_x_size = 160.000000;
#declare pcb_y_size = 100.000000;
#declare pcb_layer1_used = 1;
#declare pcb_layer16_used = 0;
#declare inc_testmode = off;
#declare global_seed=seed(1022);
#declare global_pcb_layer_dis = array[16]
{
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	0.000000,
	1.535000,
}
#declare global_pcb_real_hole = 2.000000;

#include "e3d_tools.inc"
#include "e3d_user.inc"

global_settings{charset utf8}

#if(e3d_environment=on)
sky_sphere {pigment {Navy}
pigment {bozo turbulence 0.65 octaves 7 omega 0.7 lambda 2
color_map {
[0.0 0.1 color rgb <0.85, 0.85, 0.85> color rgb <0.75, 0.75, 0.75>]
[0.1 0.5 color rgb <0.75, 0.75, 0.75> color rgbt <1, 1, 1, 1>]
[0.5 1.0 color rgbt <1, 1, 1, 1> color rgbt <1, 1, 1, 1>]}
scale <0.1, 0.5, 0.1>} rotate -90*x}
plane{y, -10.0-max(pcb_x_size,pcb_y_size)*abs(max(sin((pcb_rotate_x/180)*pi),sin((pcb_rotate_z/180)*pi)))
texture{T_Chrome_2D
normal{waves 0.1 frequency 3000.0 scale 3000.0}} translate<0,0,0>}
#end

//Ressources pour créer une animation
#if(global_anim=on)
#declare global_anim_showcampath = no;
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#declare global_anim_npoints_cam_flight=0;
#warning "Absence ou erreur dans les données spécifiés pour l'animation (3 points minimum) (Flight path)"
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#declare global_anim_npoints_cam_view=0;
#warning "Absence ou erreur dans les données spécifiés pour l'animation (3 points minimum) (Montrer l'arborescence)"
#end

#if((global_anim=on)|(global_anim_showcampath=yes))
#end

#if((global_anim_showcampath=yes)&(global_anim=off))
#end
#if(global_anim=on)
camera
{
	location global_anim_spline_cam_flight(clock)
	#if(global_anim_npoints_cam_view>2)
		look_at global_anim_spline_cam_view(clock)
	#else
		look_at global_anim_spline_cam_flight(clock+0.01)-<0,-0.01,0>
	#end
	angle 45
}
light_source
{
	global_anim_spline_cam_flight(clock)
	color rgb <1,1,1>
	spotlight point_at 
	#if(global_anim_npoints_cam_view>2)
		global_anim_spline_cam_view(clock)
	#else
		global_anim_spline_cam_flight(clock+0.01)-<0,-0.01,0>
	#end
	radius 35 falloff  40
}
#else
camera
{
	location <cam_x,cam_y,cam_z>
	look_at <cam_look_x,cam_look_y,cam_look_z>
	angle cam_a
	//translates the camera that <0,0,0> is over the Eagle <0,0>
	//translate<-80.000000,0,-50.000000>
}
#end

background{col_bgr}
light_source{<lgt1_pos_x,lgt1_pos_y,lgt1_pos_z> White*lgt1_intense}
light_source{<lgt2_pos_x,lgt2_pos_y,lgt2_pos_z> White*lgt2_intense}
light_source{<lgt3_pos_x,lgt3_pos_y,lgt3_pos_z> White*lgt3_intense}
light_source{<lgt4_pos_x,lgt4_pos_y,lgt4_pos_z> White*lgt4_intense}
#end


#macro BLUECOM_BOARD(mac_x_ver,mac_y_ver,mac_z_ver,mac_x_rot,mac_y_rot,mac_z_rot)
union{
#if(pcb_board = on)
difference{
union{
//Plaque
prism{-1.500000,0.000000,8
<0.000000,0.000000><160.000000,0.000000>
<160.000000,0.000000><160.000000,100.000000>
<160.000000,100.000000><0.000000,100.000000>
<0.000000,100.000000><0.000000,0.000000>
texture{col_brd}}
}//End union(PCB)
//Trous(réel)/Composants
//Trous(réel)/Board
//Trous(réel)/Vias
}//End difference(reale Bohrungen/Durchbrüche)
#end
#if(pcb_parts=on)//Composants
union{
#ifndef(pack_C1) #declare global_pack_C1=yes; object {CAP_SMD_CHIP_0805()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<58.420000,0.000000,64.770000>translate<0,0.035000,0> }#end		//SMD Capacitor 0805 C1 1µF 25V C0805
#ifndef(pack_C2) #declare global_pack_C2=yes; object {CAP_SMD_CHIP_0805()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<49.530000,0.000000,64.770000>translate<0,0.035000,0> }#end		//SMD Capacitor 0805 C2 1µF 25V C0805
#ifndef(pack_C3) #declare global_pack_C3=yes; object {CAP_SMD_CHIP_0805()translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<67.310000,0.000000,69.850000>translate<0,0.035000,0> }#end		//SMD Capacitor 0805 C3  C0805
#ifndef(pack_LED1) #declare global_pack_LED1=yes; object {DIODE_DIS_LED_3MM(Red,0.300000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<40.640000,0.000000,63.500000>}#end		//Diskrete 3MM LED LED1  LED3MM
#ifndef(pack_LED2) #declare global_pack_LED2=yes; object {DIODE_DIS_LED_3MM(Green,0.300000,0.000000,)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<30.480000,0.000000,63.500000>}#end		//Diskrete 3MM LED LED2  LED3MM
#ifndef(pack_R1) #declare global_pack_R1=yes; object {RES_SMD_CHIP_0805("0R0",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<62.230000,0.000000,69.850000>translate<0,0.035000,0> }#end		//SMD Resistor 0805 R1  R0805
#ifndef(pack_R2) #declare global_pack_R2=yes; object {RES_SMD_CHIP_0805("0R0",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<57.150000,0.000000,69.850000>translate<0,0.035000,0> }#end		//SMD Resistor 0805 R2  R0805
#ifndef(pack_R3) #declare global_pack_R3=yes; object {RES_SMD_CHIP_0805("0R0",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<52.070000,0.000000,69.850000>translate<0,0.035000,0> }#end		//SMD Resistor 0805 R3  R0805
#ifndef(pack_R4) #declare global_pack_R4=yes; object {RES_SMD_CHIP_0805("0R0",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<46.990000,0.000000,69.850000>translate<0,0.035000,0> }#end		//SMD Resistor 0805 R4  R0805
#ifndef(pack_R5) #declare global_pack_R5=yes; object {RES_SMD_CHIP_0805("0R0",)translate<0,0,0> rotate<0,0.000000,0>rotate<0,0.000000,0> rotate<0,0,0> translate<41.910000,0.000000,69.850000>translate<0,0.035000,0> }#end		//SMD Resistor 0805 R5  R0805
}//End union
#end
#if(pcb_pads_smds=on)
//Pattes&CMS/Composants
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<57.470000,0.000000,64.770000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<59.370000,0.000000,64.770000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<48.580000,0.000000,64.770000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<50.480000,0.000000,64.770000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<66.360000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<68.260000,0.000000,69.850000>}
#ifndef(global_pack_K1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.981200,1.320800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<49.784000,0,47.904400> texture{col_thl}}
#ifndef(global_pack_K1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.981200,1.320800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<49.784000,0,35.915600> texture{col_thl}}
#ifndef(global_pack_K1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.981200,1.320800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<61.976000,0,47.904400> texture{col_thl}}
#ifndef(global_pack_K1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(2.705100,1.803400,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<47.675800,0,41.910000> texture{col_thl}}
#ifndef(global_pack_K1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.981200,1.320800,1,16,3+global_tmp,100) rotate<0,-0.000000,0>translate<61.976000,0,35.915600> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<39.370000,0,63.500000> texture{col_thl}}
#ifndef(global_pack_LED1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<41.910000,0,63.500000> texture{col_thl}}
#ifndef(global_pack_LED2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<29.210000,0,63.500000> texture{col_thl}}
#ifndef(global_pack_LED2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,2+global_tmp,0) rotate<0,-0.000000,0>translate<31.750000,0,63.500000> texture{col_thl}}
#ifndef(global_pack_Q1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<34.290000,0,52.070000> texture{col_thl}}
#ifndef(global_pack_Q1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.320800,0.812800,1,16,1+global_tmp,0) rotate<0,-0.000000,0>translate<36.830000,0,52.070000> texture{col_thl}}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<61.380000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<63.080000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<56.300000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<58.000000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<51.220000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<52.920000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<46.140000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<47.840000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<41.060000,0.000000,69.850000>}
object{TOOLS_PCB_SMD(1.300000,1.500000,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<42.760000,0.000000,69.850000>}
#ifndef(global_pack_TP1) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.981200,1.320800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<29.210000,0,53.340000> texture{col_thl}}
#ifndef(global_pack_TP2) #local global_tmp=0; #else #local global_tmp=100; #end object{TOOLS_PCB_VIA(1.981200,1.320800,1,16,3+global_tmp,100) rotate<0,-90.000000,0>translate<66.040000,0,63.500000> texture{col_thl}}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,26.847800>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,26.060400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,25.247600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,24.460200>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,23.647400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,22.860000>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,22.072600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,21.259800>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,20.472400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,19.659600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<43.916600,0.000000,18.872200>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<45.542200,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.329600,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<47.142400,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<47.929800,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<48.742600,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<49.530000,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<50.317400,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<51.130200,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<51.917600,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<52.730400,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<53.517800,0.000000,17.246600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,18.872200>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,19.659600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,20.472400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,21.259800>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,22.072600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,22.860000>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,23.647400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,24.460200>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,25.247600>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,26.060400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-270.000000,0> texture{col_pds} translate<55.143400,0.000000,26.847800>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<53.517800,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<52.730400,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<51.917600,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<51.130200,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<50.317400,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<49.530000,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<48.742600,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<47.929800,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<47.142400,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<46.329600,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.508000,1.473200,0.037000,0) rotate<0,-180.000000,0> texture{col_pds} translate<45.542200,0.000000,28.473400>}
object{TOOLS_PCB_SMD(0.558800,1.320800,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<43.510200,0.000000,54.686200>}
object{TOOLS_PCB_SMD(0.558800,1.320800,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<45.389800,0.000000,54.686200>}
object{TOOLS_PCB_SMD(0.558800,1.320800,0.037000,0) rotate<0,-0.000000,0> texture{col_pds} translate<44.450000,0.000000,57.073800>}
//Pattes/Vias
#end
#if(pcb_wires=on)
union{
//Signaux
//Text
//Rect
union{
texture{col_pds}
}
texture{col_wrs}
}
#end
#if(pcb_polygons=on)
union{
//Polygones
texture{col_pol}
}
#end
union{
cylinder{<49.784000,0.038000,47.904400><49.784000,-1.538000,47.904400>0.660400}
cylinder{<49.784000,0.038000,35.915600><49.784000,-1.538000,35.915600>0.660400}
cylinder{<61.976000,0.038000,47.904400><61.976000,-1.538000,47.904400>0.660400}
cylinder{<47.675800,0.038000,41.910000><47.675800,-1.538000,41.910000>0.901700}
cylinder{<61.976000,0.038000,35.915600><61.976000,-1.538000,35.915600>0.660400}
cylinder{<39.370000,0.038000,63.500000><39.370000,-1.538000,63.500000>0.406400}
cylinder{<41.910000,0.038000,63.500000><41.910000,-1.538000,63.500000>0.406400}
cylinder{<29.210000,0.038000,63.500000><29.210000,-1.538000,63.500000>0.406400}
cylinder{<31.750000,0.038000,63.500000><31.750000,-1.538000,63.500000>0.406400}
cylinder{<34.290000,0.038000,52.070000><34.290000,-1.538000,52.070000>0.406400}
cylinder{<36.830000,0.038000,52.070000><36.830000,-1.538000,52.070000>0.406400}
cylinder{<29.210000,0.038000,53.340000><29.210000,-1.538000,53.340000>0.660400}
cylinder{<66.040000,0.038000,63.500000><66.040000,-1.538000,63.500000>0.660400}
//Trous(rapide)/Vias
//Trous(rapide)/Board
texture{col_hls}
}
#if(pcb_silkscreen=on)
//Sérigraphie (Silk Screen)
union{
//C1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.039000,0.000000,65.430000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.801000,0.000000,65.430000>}
box{<0,0,-0.050800><0.762000,0.036000,0.050800> rotate<0,0.000000,0> translate<58.039000,0.000000,65.430000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.064000,0.000000,64.110000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<58.801000,0.000000,64.110000>}
box{<0,0,-0.050800><0.737000,0.036000,0.050800> rotate<0,0.000000,0> translate<58.064000,0.000000,64.110000> }
box{<-0.375050,0,-0.725050><0.375050,0.036000,0.725050> rotate<0,-0.000000,0> translate<57.702850,0.000000,64.771150>}
box{<-0.375050,0,-0.725050><0.375050,0.036000,0.725050> rotate<0,-0.000000,0> translate<59.150650,0.000000,64.771150>}
//C2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<49.149000,0.000000,65.430000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<49.911000,0.000000,65.430000>}
box{<0,0,-0.050800><0.762000,0.036000,0.050800> rotate<0,0.000000,0> translate<49.149000,0.000000,65.430000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<49.174000,0.000000,64.110000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<49.911000,0.000000,64.110000>}
box{<0,0,-0.050800><0.737000,0.036000,0.050800> rotate<0,0.000000,0> translate<49.174000,0.000000,64.110000> }
box{<-0.375050,0,-0.725050><0.375050,0.036000,0.725050> rotate<0,-0.000000,0> translate<48.812850,0.000000,64.771150>}
box{<-0.375050,0,-0.725050><0.375050,0.036000,0.725050> rotate<0,-0.000000,0> translate<50.260650,0.000000,64.771150>}
//C3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.929000,0.000000,70.510000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.691000,0.000000,70.510000>}
box{<0,0,-0.050800><0.762000,0.036000,0.050800> rotate<0,0.000000,0> translate<66.929000,0.000000,70.510000> }
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<66.954000,0.000000,69.190000>}
cylinder{<0,0,0><0,0.036000,0>0.050800 translate<67.691000,0.000000,69.190000>}
box{<0,0,-0.050800><0.737000,0.036000,0.050800> rotate<0,0.000000,0> translate<66.954000,0.000000,69.190000> }
box{<-0.375050,0,-0.725050><0.375050,0.036000,0.725050> rotate<0,-0.000000,0> translate<66.592850,0.000000,69.851150>}
box{<-0.375050,0,-0.725050><0.375050,0.036000,0.725050> rotate<0,-0.000000,0> translate<68.040650,0.000000,69.851150>}
//K1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,50.165000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,50.165000>}
box{<0,0,-0.076200><20.574000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.593000,0.000000,50.165000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,33.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,50.165000>}
box{<0,0,-0.076200><16.510000,0.036000,0.076200> rotate<0,90.000000,0> translate<45.593000,0.000000,50.165000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.593000,0.000000,33.655000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,33.655000>}
box{<0,0,-0.076200><20.574000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.593000,0.000000,33.655000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,50.165000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<66.167000,0.000000,33.655000>}
box{<0,0,-0.076200><16.510000,0.036000,0.076200> rotate<0,-90.000000,0> translate<66.167000,0.000000,33.655000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,47.625000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,47.625000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.435000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,36.195000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.435000,0.000000,36.195000>}
box{<0,0,-0.076200><1.905000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.435000,0.000000,36.195000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<50.800000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<50.800000,0.000000,40.640000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,-90.000000,0> translate<50.800000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<55.880000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<55.880000,0.000000,43.180000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,90.000000,0> translate<55.880000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,36.195000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,40.640000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,90.000000,0> translate<53.340000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<53.340000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<55.880000,0.000000,40.640000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,0.000000,0> translate<53.340000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<53.340000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<50.800000,0.000000,43.180000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,0.000000,0> translate<50.800000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.340000,0.000000,47.625000>}
box{<0,0,-0.076200><4.445000,0.036000,0.076200> rotate<0,90.000000,0> translate<53.340000,0.000000,47.625000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<55.880000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<53.975000,0.000000,43.180000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<53.975000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<53.975000,0.000000,43.180000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<53.340000,0.000000,43.180000>}
box{<0,0,-0.127000><0.635000,0.036000,0.127000> rotate<0,0.000000,0> translate<53.340000,0.000000,43.180000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<50.800000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<52.705000,0.000000,40.640000>}
box{<0,0,-0.127000><1.905000,0.036000,0.127000> rotate<0,0.000000,0> translate<50.800000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<52.705000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<53.340000,0.000000,40.640000>}
box{<0,0,-0.127000><0.635000,0.036000,0.127000> rotate<0,0.000000,0> translate<52.705000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.705000,0.000000,40.640000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.975000,0.000000,43.180000>}
box{<0,0,-0.076200><2.839806,0.036000,0.076200> rotate<0,-63.430762,0> translate<52.705000,0.000000,40.640000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.785000,0.000000,41.910000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.325000,0.000000,41.910000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,0.000000,0> translate<57.785000,0.000000,41.910000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,40.005000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,37.465000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,-90.000000,0> translate<62.230000,0.000000,37.465000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,43.815000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.230000,0.000000,46.355000>}
box{<0,0,-0.076200><2.540000,0.036000,0.076200> rotate<0,90.000000,0> translate<62.230000,0.000000,46.355000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.865000,0.000000,44.450000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<60.325000,0.000000,41.910000>}
box{<0,0,-0.076200><3.592102,0.036000,0.076200> rotate<0,-44.997030,0> translate<60.325000,0.000000,41.910000> }
//LED1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.214800,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<42.214800,0.000000,64.770000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,90.000000,0> translate<42.214800,0.000000,64.770000> }
object{ARC(1.524000,0.152400,140.196236,179.999846,0.036000) translate<40.640000,0.000000,63.499997>}
object{ARC(1.524000,0.152400,179.997604,221.630812,0.036000) translate<40.640000,0.000000,63.499938>}
object{ARC(1.524000,0.152400,0.000537,40.601702,0.036000) translate<40.640000,0.000000,63.499984>}
object{ARC(1.524000,0.152400,320.196236,359.999846,0.036000) translate<40.640000,0.000000,63.500003>}
object{ARC(1.524000,0.152400,35.537354,89.998691,0.036000) translate<40.639966,0.000000,63.500000>}
object{ARC(1.524000,0.152400,90.000000,143.130102,0.036000) translate<40.640000,0.000000,63.500000>}
object{ARC(1.524000,0.152400,270.000307,322.127183,0.036000) translate<40.639991,0.000000,63.500000>}
object{ARC(1.524000,0.152400,217.872817,269.999693,0.036000) translate<40.640009,0.000000,63.500000>}
object{ARC(0.635000,0.152400,90.000000,180.000000,0.036000) translate<40.640000,0.000000,63.500000>}
object{ARC(1.016000,0.152400,90.000000,180.000000,0.036000) translate<40.640000,0.000000,63.500000>}
object{ARC(0.635000,0.152400,270.000000,360.000000,0.036000) translate<40.640000,0.000000,63.500000>}
object{ARC(1.016000,0.152400,270.000000,360.000000,0.036000) translate<40.640000,0.000000,63.500000>}
object{ARC(2.032000,0.254000,39.807234,90.000342,0.036000) translate<40.640013,0.000000,63.500000>}
object{ARC(2.032000,0.254000,90.001692,151.928641,0.036000) translate<40.640059,0.000000,63.500000>}
object{ARC(2.032000,0.254000,269.998944,319.761966,0.036000) translate<40.640038,0.000000,63.500000>}
object{ARC(2.032000,0.254000,209.746365,270.001580,0.036000) translate<40.639944,0.000000,63.500000>}
object{ARC(2.032000,0.254000,151.698217,179.999918,0.036000) translate<40.640000,0.000000,63.499997>}
object{ARC(2.032000,0.254000,179.997652,211.605872,0.036000) translate<40.640000,0.000000,63.499916>}
//LED2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<32.054800,0.000000,62.230000>}
cylinder{<0,0,0><0,0.036000,0>0.127000 translate<32.054800,0.000000,64.770000>}
box{<0,0,-0.127000><2.540000,0.036000,0.127000> rotate<0,90.000000,0> translate<32.054800,0.000000,64.770000> }
object{ARC(1.524000,0.152400,140.196236,179.999846,0.036000) translate<30.480000,0.000000,63.499997>}
object{ARC(1.524000,0.152400,179.997604,221.630812,0.036000) translate<30.480000,0.000000,63.499938>}
object{ARC(1.524000,0.152400,0.000537,40.601702,0.036000) translate<30.480000,0.000000,63.499984>}
object{ARC(1.524000,0.152400,320.196236,359.999846,0.036000) translate<30.480000,0.000000,63.500003>}
object{ARC(1.524000,0.152400,35.537354,89.998691,0.036000) translate<30.479966,0.000000,63.500000>}
object{ARC(1.524000,0.152400,90.000000,143.130102,0.036000) translate<30.480000,0.000000,63.500000>}
object{ARC(1.524000,0.152400,270.000307,322.127183,0.036000) translate<30.479991,0.000000,63.500000>}
object{ARC(1.524000,0.152400,217.872817,269.999693,0.036000) translate<30.480009,0.000000,63.500000>}
object{ARC(0.635000,0.152400,90.000000,180.000000,0.036000) translate<30.480000,0.000000,63.500000>}
object{ARC(1.016000,0.152400,90.000000,180.000000,0.036000) translate<30.480000,0.000000,63.500000>}
object{ARC(0.635000,0.152400,270.000000,360.000000,0.036000) translate<30.480000,0.000000,63.500000>}
object{ARC(1.016000,0.152400,270.000000,360.000000,0.036000) translate<30.480000,0.000000,63.500000>}
object{ARC(2.032000,0.254000,39.807234,90.000342,0.036000) translate<30.480013,0.000000,63.500000>}
object{ARC(2.032000,0.254000,90.001692,151.928641,0.036000) translate<30.480059,0.000000,63.500000>}
object{ARC(2.032000,0.254000,269.998944,319.761966,0.036000) translate<30.480038,0.000000,63.500000>}
object{ARC(2.032000,0.254000,209.746365,270.001580,0.036000) translate<30.479944,0.000000,63.500000>}
object{ARC(2.032000,0.254000,151.698217,179.999918,0.036000) translate<30.480000,0.000000,63.499997>}
object{ARC(2.032000,0.254000,179.997652,211.605872,0.036000) translate<30.480000,0.000000,63.499916>}
//Q1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,53.721000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.449000,0.000000,53.721000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,53.721000> }
object{ARC(0.254000,0.152400,0.000000,90.000000,0.036000) translate<36.322000,0.000000,59.563000>}
object{ARC(0.254000,0.152400,90.000000,180.000000,0.036000) translate<34.798000,0.000000,59.563000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.798000,0.000000,59.817000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.322000,0.000000,59.817000>}
box{<0,0,-0.076200><1.524000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.798000,0.000000,59.817000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.449000,0.000000,53.721000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.449000,0.000000,54.102000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.449000,0.000000,54.102000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,54.102000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,59.563000>}
box{<0,0,-0.076200><5.461000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.576000,0.000000,59.563000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,53.721000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,54.102000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.671000,0.000000,54.102000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.544000,0.000000,54.102000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,54.102000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.544000,0.000000,54.102000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.544000,0.000000,54.102000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.544000,0.000000,59.563000>}
box{<0,0,-0.076200><5.461000,0.036000,0.076200> rotate<0,90.000000,0> translate<34.544000,0.000000,59.563000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<36.068000,0.000000,52.832000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<36.068000,0.000000,53.213000>}
box{<0,0,-0.203200><0.381000,0.036000,0.203200> rotate<0,90.000000,0> translate<36.068000,0.000000,53.213000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<35.052000,0.000000,52.832000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<35.052000,0.000000,53.340000>}
box{<0,0,-0.203200><0.508000,0.036000,0.203200> rotate<0,90.000000,0> translate<35.052000,0.000000,53.340000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<36.195000,0.000000,52.705000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<36.830000,0.000000,52.070000>}
box{<0,0,-0.203200><0.898026,0.036000,0.203200> rotate<0,44.997030,0> translate<36.195000,0.000000,52.705000> }
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.925000,0.000000,52.705000>}
cylinder{<0,0,0><0,0.036000,0>0.203200 translate<34.290000,0.000000,52.070000>}
box{<0,0,-0.203200><0.898026,0.036000,0.203200> rotate<0,-44.997030,0> translate<34.290000,0.000000,52.070000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,57.023000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,56.642000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.052000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,56.642000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.052000,0.000000,56.642000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,56.642000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,57.023000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<36.068000,0.000000,57.023000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,57.023000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,57.023000>}
box{<0,0,-0.076200><1.016000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.052000,0.000000,57.023000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,57.404000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,57.404000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.052000,0.000000,57.404000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.052000,0.000000,56.261000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,56.261000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.052000,0.000000,56.261000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,56.261000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,55.753000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,-90.000000,0> translate<35.560000,0.000000,55.753000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,56.261000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,56.261000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.560000,0.000000,56.261000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,57.404000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,57.912000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,90.000000,0> translate<35.560000,0.000000,57.912000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<35.560000,0.000000,57.404000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.068000,0.000000,57.404000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<35.560000,0.000000,57.404000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.576000,0.000000,54.102000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.449000,0.000000,54.102000>}
box{<0,0,-0.076200><0.127000,0.036000,0.076200> rotate<0,0.000000,0> translate<36.449000,0.000000,54.102000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<36.449000,0.000000,54.102000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<34.671000,0.000000,54.102000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,0.000000,0> translate<34.671000,0.000000,54.102000> }
box{<-0.203200,0,-0.292100><0.203200,0.036000,0.292100> rotate<0,-0.000000,0> translate<36.068000,0.000000,53.378100>}
box{<-0.203200,0,-0.292100><0.203200,0.036000,0.292100> rotate<0,-0.000000,0> translate<35.052000,0.000000,53.378100>}
//R1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.820000,0.000000,70.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.640000,0.000000,70.485000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.820000,0.000000,70.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<61.820000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<62.640000,0.000000,69.215000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<61.820000,0.000000,69.215000> }
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<62.961400,0.000000,69.851500>}
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<61.488200,0.000000,69.851500>}
//R2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.740000,0.000000,70.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.560000,0.000000,70.485000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.740000,0.000000,70.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.740000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<57.560000,0.000000,69.215000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.740000,0.000000,69.215000> }
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<57.881400,0.000000,69.851500>}
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<56.408200,0.000000,69.851500>}
//R3 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.660000,0.000000,70.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.480000,0.000000,70.485000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.660000,0.000000,70.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.660000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.480000,0.000000,69.215000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.660000,0.000000,69.215000> }
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<52.801400,0.000000,69.851500>}
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<51.328200,0.000000,69.851500>}
//R4 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.580000,0.000000,70.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.400000,0.000000,70.485000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.580000,0.000000,70.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.580000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.400000,0.000000,69.215000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<46.580000,0.000000,69.215000> }
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<47.721400,0.000000,69.851500>}
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<46.248200,0.000000,69.851500>}
//R5 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.500000,0.000000,70.485000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.320000,0.000000,70.485000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.500000,0.000000,70.485000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<41.500000,0.000000,69.215000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.320000,0.000000,69.215000>}
box{<0,0,-0.076200><0.820000,0.036000,0.076200> rotate<0,0.000000,0> translate<41.500000,0.000000,69.215000> }
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<42.641400,0.000000,69.851500>}
box{<-0.325000,0,-0.700000><0.325000,0.036000,0.700000> rotate<0,-0.000000,0> translate<41.168200,0.000000,69.851500>}
//TP1 silk screen
difference{
cylinder{<29.210000,0,53.340000><29.210000,0.036000,53.340000>0.838200 translate<0,0.000000,0>}
cylinder{<29.210000,-0.1,53.340000><29.210000,0.135000,53.340000>0.685800 translate<0,0.000000,0>}}
box{<-0.330200,0,-0.330200><0.330200,0.036000,0.330200> rotate<0,-0.000000,0> translate<29.210000,0.000000,53.340000>}
//TP2 silk screen
difference{
cylinder{<66.040000,0,63.500000><66.040000,0.036000,63.500000>0.838200 translate<0,0.000000,0>}
cylinder{<66.040000,-0.1,63.500000><66.040000,0.135000,63.500000>0.685800 translate<0,0.000000,0>}}
box{<-0.330200,0,-0.330200><0.330200,0.036000,0.330200> rotate<0,-0.000000,0> translate<66.040000,0.000000,63.500000>}
//U1 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.958000,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<44.526200,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.432000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<54.533800,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.102000,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<54.102000,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.958000,0.000000,27.025600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.364400,0.000000,27.432000>}
box{<0,0,-0.076200><0.574736,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.958000,0.000000,27.025600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.958000,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<44.526200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,18.288000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<54.533800,0.000000,18.288000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.102000,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<54.102000,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.432000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.526200,0.000000,27.432000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,18.288000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.526200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.672000,0.000000,19.862800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.672000,0.000000,19.481800>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.672000,0.000000,19.481800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.672000,0.000000,19.481800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.926000,0.000000,19.481800>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<42.672000,0.000000,19.481800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.926000,0.000000,19.481800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.926000,0.000000,19.862800>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<42.926000,0.000000,19.862800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.739800,0.000000,16.256000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.739800,0.000000,16.002000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.739800,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.739800,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.120800,0.000000,16.002000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<51.739800,0.000000,16.002000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.120800,0.000000,16.002000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.120800,0.000000,16.256000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<52.120800,0.000000,16.256000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.388000,0.000000,24.638000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.388000,0.000000,24.257000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,-90.000000,0> translate<56.388000,0.000000,24.257000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.388000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.134000,0.000000,24.257000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,0.000000,0> translate<56.134000,0.000000,24.257000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.134000,0.000000,24.257000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<56.134000,0.000000,24.638000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,90.000000,0> translate<56.134000,0.000000,24.638000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,29.464000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,29.718000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,90.000000,0> translate<48.539400,0.000000,29.718000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.539400,0.000000,29.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.920400,0.000000,29.718000>}
box{<0,0,-0.076200><0.381000,0.036000,0.076200> rotate<0,0.000000,0> translate<48.539400,0.000000,29.718000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.920400,0.000000,29.718000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.920400,0.000000,29.464000>}
box{<0,0,-0.076200><0.254000,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.920400,0.000000,29.464000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<53.314600,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<53.746400,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,28.854400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<53.314600,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<53.314600,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,27.863800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<52.501800,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<52.959000,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,28.854400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<52.501800,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.501800,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<51.714400,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<52.146200,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,28.854400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<51.714400,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.714400,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,27.863800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.901600,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<51.358800,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,28.854400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.901600,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.901600,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<50.114200,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<50.546000,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,28.854400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<50.114200,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.114200,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,27.863800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<49.301400,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<49.758600,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,28.854400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<49.301400,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<49.301400,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<48.514000,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<48.945800,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,28.854400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<48.514000,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.514000,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,27.863800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<47.701200,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<48.158400,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,28.854400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<47.701200,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.701200,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<46.913800,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<47.345600,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,28.854400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<46.913800,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.913800,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,27.863800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<46.101000,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<46.558200,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,28.854400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<46.101000,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.101000,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,27.863800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<45.313600,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,28.854400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<45.745400,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,28.854400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<45.313600,0.000000,28.854400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,28.854400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,27.863800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.313600,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,26.644600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.076400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,27.076400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.076400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,27.076400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,27.076400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,27.076400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,26.644600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,26.644600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,26.644600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,26.644600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,26.644600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,25.831800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,26.289000>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,26.289000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,25.831800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,25.831800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,25.831800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,25.831800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,25.831800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,25.044400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,25.476200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,25.476200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,25.476200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,25.476200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,25.476200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,25.476200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,25.044400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,25.044400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,25.044400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,25.044400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,25.044400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,24.231600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,24.688800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,24.688800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,24.688800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,24.688800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,24.688800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,24.688800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,24.231600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,24.231600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,24.231600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,24.231600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,24.231600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,23.444200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,23.876000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,23.876000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,23.444200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,23.444200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,23.444200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,23.444200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,23.444200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,22.631400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,23.088600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,23.088600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,23.088600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,23.088600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,22.631400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,22.631400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,22.631400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,22.631400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,22.631400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,22.275800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,22.275800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,22.275800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,22.275800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,22.275800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,22.275800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,21.844000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,21.844000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,21.031200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,21.488400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,21.488400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,21.488400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,21.488400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,21.488400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,21.488400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,21.031200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,21.031200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,21.031200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,21.031200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,21.031200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,20.243800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,20.675600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,20.675600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,20.675600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,20.675600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,20.675600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,20.675600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,20.243800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,20.243800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,20.243800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,20.243800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,20.243800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,19.888200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,19.888200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,19.888200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,19.888200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,19.888200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,19.888200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,19.431000>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,19.431000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,19.431000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,19.431000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,18.643600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,19.075400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<44.526200,0.000000,19.075400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,19.075400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,19.075400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,19.075400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,19.075400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,18.643600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.535600,0.000000,18.643600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.535600,0.000000,18.643600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,18.643600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<43.535600,0.000000,18.643600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<45.313600,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.313600,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.313600,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,16.865600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<45.313600,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.745400,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<45.745400,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,17.856200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<46.101000,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.101000,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.101000,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,16.865600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<46.101000,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.558200,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<46.558200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<46.913800,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<46.913800,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<46.913800,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,16.865600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<46.913800,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.345600,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<47.345600,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,17.856200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<47.701200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<47.701200,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<47.701200,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,16.865600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<47.701200,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.158400,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<48.158400,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<48.514000,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<48.514000,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.514000,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,16.865600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<48.514000,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<48.945800,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<48.945800,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,17.856200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<49.301400,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<49.301400,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.301400,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,16.865600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<49.301400,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<49.758600,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<49.758600,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<50.114200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.114200,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.114200,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,16.865600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<50.114200,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.546000,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<50.546000,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,17.856200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.901600,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<50.901600,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<50.901600,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,16.865600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<50.901600,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.358800,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<51.358800,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<51.714400,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<51.714400,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<51.714400,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,16.865600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<51.714400,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.146200,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<52.146200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,17.856200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<52.501800,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<52.501800,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.501800,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,16.865600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,0.000000,0> translate<52.501800,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<52.959000,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<52.959000,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,17.856200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<53.314600,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,16.865600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,-90.000000,0> translate<53.314600,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.314600,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,16.865600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,0.000000,0> translate<53.314600,0.000000,16.865600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,16.865600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<53.746400,0.000000,17.856200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,90.000000,0> translate<53.746400,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,19.075400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,18.643600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,18.643600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,18.643600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,18.643600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,18.643600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,18.643600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,19.075400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,19.075400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,19.075400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,19.075400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,19.075400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,19.888200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,19.431000>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,19.431000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,19.431000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,19.431000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,19.431000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,19.888200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,19.888200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,19.888200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,19.888200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,19.888200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,20.675600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,20.243800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,20.243800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,20.243800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,20.243800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,20.243800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,20.243800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,20.675600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,20.675600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,20.675600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,20.675600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,20.675600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,21.488400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,21.031200>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,21.031200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,21.031200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,21.031200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,21.031200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,21.031200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,21.488400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,21.488400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,21.488400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,21.488400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,21.488400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,22.275800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,21.844000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,21.844000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,21.844000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,21.844000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,22.275800>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,22.275800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,22.275800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,22.275800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,22.275800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,22.631400>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,22.631400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,22.631400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,22.631400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,22.631400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,22.631400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,23.088600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,23.088600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,23.088600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,23.088600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,23.088600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,23.444200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,23.444200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,23.444200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,23.444200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,23.444200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,23.444200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,23.876000>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,23.876000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,23.876000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,23.876000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,24.688800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,24.231600>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,24.231600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,24.231600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,24.231600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,24.231600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,24.231600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,24.688800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,24.688800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,24.688800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,24.688800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,24.688800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,25.476200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,25.044400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,25.044400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,25.044400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,25.044400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,25.044400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,25.044400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,25.476200>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,25.476200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,25.476200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,25.476200>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,25.476200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,25.831800>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,25.831800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,25.831800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,25.831800>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,25.831800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,25.831800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,26.289000>}
box{<0,0,-0.076200><0.457200,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,26.289000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,26.289000>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,26.289000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.076400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,26.644600>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,-90.000000,0> translate<54.533800,0.000000,26.644600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,26.644600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,26.644600>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,26.644600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,26.644600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,27.076400>}
box{<0,0,-0.076200><0.431800,0.036000,0.076200> rotate<0,90.000000,0> translate<55.524400,0.000000,27.076400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<55.524400,0.000000,27.076400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.076400>}
box{<0,0,-0.076200><0.990600,0.036000,0.076200> rotate<0,0.000000,0> translate<54.533800,0.000000,27.076400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,26.593800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.796200,0.000000,27.863800>}
box{<0,0,-0.076200><1.796051,0.036000,0.076200> rotate<0,-44.997030,0> translate<44.526200,0.000000,26.593800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,17.856200>}
box{<0,0,-0.076200><10.007600,0.036000,0.076200> rotate<0,0.000000,0> translate<44.526200,0.000000,17.856200> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,17.856200>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.863800>}
box{<0,0,-0.076200><10.007600,0.036000,0.076200> rotate<0,90.000000,0> translate<54.533800,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<54.533800,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.863800>}
box{<0,0,-0.076200><10.007600,0.036000,0.076200> rotate<0,0.000000,0> translate<44.526200,0.000000,27.863800> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,27.863800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.526200,0.000000,17.856200>}
box{<0,0,-0.076200><10.007600,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.526200,0.000000,17.856200> }
//U2 silk screen
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.764200,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.256200,0.000000,54.991000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<43.256200,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.256200,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.256200,0.000000,54.381400>}
box{<0,0,-0.076200><0.609600,0.036000,0.076200> rotate<0,-90.000000,0> translate<43.256200,0.000000,54.381400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.256200,0.000000,54.381400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.764200,0.000000,54.381400>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<43.256200,0.000000,54.381400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.764200,0.000000,54.381400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.764200,0.000000,54.991000>}
box{<0,0,-0.076200><0.609600,0.036000,0.076200> rotate<0,90.000000,0> translate<43.764200,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.643800,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.135800,0.000000,54.991000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.135800,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.135800,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.135800,0.000000,54.381400>}
box{<0,0,-0.076200><0.609600,0.036000,0.076200> rotate<0,-90.000000,0> translate<45.135800,0.000000,54.381400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.135800,0.000000,54.381400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.643800,0.000000,54.381400>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<45.135800,0.000000,54.381400> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.643800,0.000000,54.381400>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.643800,0.000000,54.991000>}
box{<0,0,-0.076200><0.609600,0.036000,0.076200> rotate<0,90.000000,0> translate<45.643800,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.704000,0.000000,56.769000>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.196000,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.704000,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.704000,0.000000,57.378600>}
box{<0,0,-0.076200><0.609600,0.036000,0.076200> rotate<0,90.000000,0> translate<44.704000,0.000000,57.378600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.704000,0.000000,57.378600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,57.378600>}
box{<0,0,-0.076200><0.508000,0.036000,0.076200> rotate<0,0.000000,0> translate<44.196000,0.000000,57.378600> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,57.378600>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.196000,0.000000,56.769000>}
box{<0,0,-0.076200><0.609600,0.036000,0.076200> rotate<0,-90.000000,0> translate<44.196000,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,54.991000>}
box{<0,0,-0.076200><3.098800,0.036000,0.076200> rotate<0,0.000000,0> translate<42.900600,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,56.769000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,90.000000,0> translate<45.999400,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,56.769000>}
box{<0,0,-0.076200><3.098800,0.036000,0.076200> rotate<0,0.000000,0> translate<42.900600,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,54.991000>}
box{<0,0,-0.076200><1.778000,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.900600,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<43.840400,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,56.769000>}
box{<0,0,-0.076200><0.939800,0.036000,0.076200> rotate<0,0.000000,0> translate<42.900600,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.119800,0.000000,54.991000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<44.780200,0.000000,54.991000>}
box{<0,0,-0.076200><0.660400,0.036000,0.076200> rotate<0,0.000000,0> translate<44.119800,0.000000,54.991000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,55.422800>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,56.769000>}
box{<0,0,-0.076200><1.346200,0.036000,0.076200> rotate<0,90.000000,0> translate<45.999400,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.999400,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<45.059600,0.000000,56.769000>}
box{<0,0,-0.076200><0.939800,0.036000,0.076200> rotate<0,0.000000,0> translate<45.059600,0.000000,56.769000> }
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,56.769000>}
cylinder{<0,0,0><0,0.036000,0>0.076200 translate<42.900600,0.000000,55.422800>}
box{<0,0,-0.076200><1.346200,0.036000,0.076200> rotate<0,-90.000000,0> translate<42.900600,0.000000,55.422800> }
texture{col_slk}
}
#end
translate<mac_x_ver,mac_y_ver,mac_z_ver>
rotate<mac_x_rot,mac_y_rot,mac_z_rot>
}//End union
#end

#if(use_file_as_inc=off)
object{  BLUECOM_BOARD(-80.000000,0,-50.000000,pcb_rotate_x,pcb_rotate_y,pcb_rotate_z)
#if(pcb_upsidedown=on)
rotate pcb_rotdir*180
#end
}
#end


//Parts not found in 3dpack.dat or 3dusrpac.dat are:
//K1	Relay 5V	ZF112
//Q1		TC26H
//TP1	TPPAD1-13Y	P1-13Y
//TP2	TPPAD1-13Y	P1-13Y
//U1	PIC18F44J11-I/PT	QFP80P1200X1200X120-44N
//U2	MCP1702T-3302E/CB	SOT95P255X145-3N
