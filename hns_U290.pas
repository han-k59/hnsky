unit hns_U290;
{HNSKY reads star databases type .dat and .290}
{$mode delphi}

interface

uses
  Classes, SysUtils
  {$IFDEF unix}
  {$ELSE}
  ,windows {for getinputstate}
  {$ENDIF}
  ;

//var counts:integer;  {temporary}

var
  database2         : array[0..(11*10)] of ansichar;{info star database, length 110 char equals 10x11 bytes}


  // searchmode [S,T] specify S = screen update within FOV or T for full (designation text) database access.
  // telescope_ra, telescope_dec [radians], contains to center position of the field of interest
  // field_diameter [radians], FOV diameter of field of interest. This is ignored in searchmode=T}
  // ra, dec [radians],   reported star position
  // mag2 [magnitude*10]  reported star magnitude
  // result [true/false]  if reported true then more stars are available. If false no more stars available.
  // extra outputs:
  //          naam2,  string containing the star Tycho/UCAC4 designation for record size above 7
  //          database2  : array[0..(11*10)] of ansichar;{text info star database used}
  // preconditions:
  //   procedure reset290index should be called before any read.
  //   cos_telescope_dec, double variable should contains the cos(telescope_dec) to detect if star read is within the FOV diameter}
  //   maxmag [magnitude*10], double variable which specifies the maximum magnitude to be read. This is typical used in HNSKY if a star designation needs to be reported after a mouse click on it

procedure reset290index;{call this procedure before start reading from the 290 files}
function readdatabase290(searchmode:char): boolean;{star 290 file database search}
procedure opendatabase2(naam_star:string);{open star database type .dat}
procedure closedatabase;
procedure read_star(searchmode:char);{star database search}

// The format of the 290 star databases is described in the HNSKY help file
//
// The sky is divided in 290 areas of equal surface except for the poles which are half of that size.
// The stars are stored in these 290 separate files and sorted from bright to faint. Each file starts with a header of 110 bytes of which the first part contains
// a textual description and the last byte contains the record size 5, 6, 7, 10 or 11 bytes.  The source of the utility program to make star databases is provided.
//
// The 290 area's:
// The areas are based on an mathematical method described in a paper of the PHILLIPS LABORATORY called "THE DIVISION OF A CIRCLE OR SPHERICAL SURFACE INTO EQUAL-AREA CELLS OR PIXELS"
// by Irving I. Gringorten Penelope J. Yepez on 30 June 1992
// First circles of constant declination are assumed. The first sphere segment defined by circle with number 1 has a height h1 from the pole and a surface of pi*sqr(h1).
// If the second circle of constant declination has a sphere segment with a height of 3*h1 then the surface area of the second sphere segment is nine times higher equal pi*sqr(3*h1).
// If the area between circle 1 en 2 is divided in 8 segments then these eight have the same area as the area of the first segment.
// The same is possible for the third circle by diving it in 16 segments, then in 24, 32, 40, 48, 56, 64 segments.
// The area of the third segment is pi*sqr(5*h1) so 25 times larger, where 25 equals 1+8+16. So the sphere segments have a height of h1, 3*h1, 5*h1, 7*h1.
// The height of h1=1-sin(declination). All areas are equal area but rectangle.
// In HNSKY all area's are a combination of two except for the polar areas to have a more square shape especially around the equator.
// The south pole is stored in file 0101.290 Area A2 and A3 are stored in file 02_01.290, area A4 and A5 are stored in file 0202.290.
// The distances between the circles is pretty constant and around 10 to 12 degrees. The distance between the area centres is around 15 degrees maximum.
// The declinations are calculated by arcsin (1-1/289), arcsin(1-(1+8)/289), arcsin (1-(1+8+16)/289), arcsin(1-(1+8+16+24)/289)...
//
//     	Ring 	declination 	declination     Areas 	HNSKY
//              minimum         maximum         equal   area's
//                                              size
//   	0-1 	-90 	        -85.23224404 	1 	1          {arcsin(1-1/289)}
//     	1-2 	-85.23224404 	-75.66348756 	8 	4          {arcsin(1-(1+8)/289)}
//	2-3 	-75.66348756 	-65.99286637 	16 	8          {arcsin (1-(1+8+16)/289)}
//	4-5 	-65.99286637 	-56.14497387 	24 	12
//	6-7 	-56.14497387 	-46.03163067 	32 	16
//	7-8 	-46.03163067 	-35.54307745 	40 	20
//	8-9 	-35.54307745 	-24.53348115 	48 	24
//	7-8 	-24.53348115 	-12.79440589 	56 	28
//	8-9 	-12.79440589 	0 	        64 	32
//	9-10 	0 	        12.79440589 	64 	32
//	10-11 	12.79440589 	24.53348115 	56 	28
//	11-12 	24.53348115 	35.54307745 	48 	24
//	12-13 	35.54307745 	46.03163067 	40 	20
//	13-14 	46.03163067 	56.14497387 	32 	16
//	14-15 	56.14497387 	65.99286637 	24 	12
//	15-16 	65.99286637 	75.66348756 	16 	8
//	16-17 	75.66348756 	85.23224404 	8 	4
//	17-18 	85.23224404 	90 	        1 	1
//    ----------------------------------------------------
//                              Total   	578 	290


//Decoding example for two stars from the HNSKY and ASTAP star database type290-5
//G17, Gaia Dr2
//File:g17_1801.290
//
//first record (header record)
//ra7=255
//ra8=255
//ra9=255
//dec7=254
//dec8=38
//
//calculations
//ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
//           if (ra_raw=$FFFFFF) then  {special magnitude record is found}
//mag2:=dec8-16  {new magn shifted 16 to make sirius and other positive}
//mag2:=22
//dec9_storage:=dec7-128  {recover dec9 shortint and put it in storage}
//dec9_storage:=126

//Second record (first star Polaris):
//ra7=248
//ra8=251
//ra9=26
//dec7=19
//dec8=244
//
// ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16)  = 1768440 ;{always required, fasted method}
// ra2:= ra_raw*(pi*2  /((256*256*256)-1));
// ra2: =0.66229324858915306 {radians}
// dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));
// dec2:=1.5579529812355912
//
//Third record (header record)
//ra7=255
//ra8=255
//ra9=255
//dec7=251
//dec8=60
//
//ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
//           if (ra_raw=$FFFFFF) then  {special magnitude record is found}
//
// mag2:=dec8-16;{new magn shifted 16 to make sirius and other positive. Magnitude is stored in mag2 till new magnitude record is found}
// mag2=44
// dec9_storage:=dec7-128;{recover dec9 shortint and put it in storage}
// dec9_storage:=123
//
//Fourth record (second star):
//ra7=188
//ra8=15
//ra9=187
//dec7=74
//dec8=37
//
// ra2:= ra_raw*(pi*2  /((256*256*256)-1));
// ra2:=4.5911793053194119 {radians}
//
// dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));
// dec2:=1.5579529812355912 {radians}


type
  hnskyhdr290_11 = packed record {This format is normally not used}
             nr32: integer; {Star number containing the Tycho/GSC or UCAC4 designation}
             ra7 : byte;    {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;    {note with word and smallint, delphi makes longer records !!!}
             dec9: shortint;
             mag0: shortint;

   end;

{Magnitude: The stars are sorted with an accuracy of 0.1 magnitude. Prior to each group a special record is written where RA is $FFFFFF and DEC contains the magnitude}
type
  hnskyhdr290_10 = packed record {This format is used for the Tycho2++ database up to magnitude 12.5}
             nr32: integer; {Star number containing the Tycho/GSC or UCAC4 designation}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
             dec9: shortint;
   end;
  hnskyhdr290_9 = packed record  {Used TUC, for Tycho & UCAC4 database up to magnitude 15}
             nr32: integer; {Star number containing the Tycho/GSC or UCAC4 designation}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
   end;

  hnskyhdr290_7 = packed record  {This format is normally not used}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
             dec9: shortint;
             mag0: shortint;
  end;
 hnskyhdr290_A7 = packed record  {Interim like hnskyhdr290_A6 but Gaia Bp_Rp added. Used to create 290-6 later}
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;
             dec9: shortint;
             B_R: shortint;{Gaia Bp_Rp}
  end;


 hnskyhdr290_6 = packed record  {G16 for storing Rp-Bp}
            ra7 : byte; {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
            ra8 : byte;
            ra9 : byte;
            dec7: byte;
            dec8: byte;
            B_R: shortint;{Gaia Bp-Rp}
  end;

 hnskyhdr290_A6 = packed record  {Interim format normally not used. Used to create 290-5 later}
            ra7 : byte; {The RA is stored as a 3 bytes word. The DEC position is stored as a two's complement (=standard), three bytes integer. The resolution of this three byte storage will be for RA: 360*60*60/((256*256*256)-1) = 0.077 arc seconds. For the DEC value it will be: 90*60*60/((128*256*256)-1) = 0.039 arc seconds.}
            ra8 : byte;
            ra9 : byte;
            dec7: byte;
            dec8: byte;
            dec9: shortint;
  end;

  hnskyhdr290_5 = packed record  {Most compact format, used for Gaia}
              ra7 : byte;
              ra8 : byte;
              ra9 : byte;
              dec7: byte;
              dec8: byte;
    end;

type
  hnskyhdr = packed record
             nr1 : byte;
             nr2 : byte;
             nr3 : byte;
             ra7 : byte;
             ra8 : byte;
             ra9 : byte;
             dec7: byte;
             dec8: byte;    {note with word and smallint, delphi makes longer records !!!}
             dec9: shortint;
             mag0: shortint;
             spec0:  byte;
   end;




implementation

uses hns_main, hns_Uast, hns_Ucon;



//Const

//AA= -90.0 * pi/180;
//BB=-(85.23224404+75.66348756)/2 * pi/180;
//CC=-(75.66348756+65.99286637)/2 * pi/180;
//DD=-(65.99286637+56.14497387)/2 * pi/180;
//EE=-(56.14497387+46.03163067)/2 * pi/180;
//FF=-(46.03163067+35.54307745)/2 * pi/180;
//GG=-(35.54307745+24.53348115)/2 * pi/180;
//HH=-(24.53348115+12.79440589)/2 * pi/180;
//II=-(12.79440589+0          )/2 * pi/180;


Const
AA=-90.0 * pi/180;
BB=-85.23224404 * pi/180;
CC=-75.66348756 * pi/180;
DD=-65.99286637 * pi/180;
EE=-56.14497387 * pi/180;
FF=-46.03163067 * pi/180;
GG=-35.54307745 * pi/180;
HH=-24.53348115 * pi/180;
II=-12.79440589 * pi/180;
JJ=  0;
KK=+12.79440589 * pi/180;
LL=+24.53348115 * pi/180;
MM=+35.54307745 * pi/180;
NN=+46.03163067 * pi/180;
OO=+56.14497387 * pi/180;
PP=+65.99286637 * pi/180;
QQ=+75.66348756 * pi/180;
RR=+85.23224404 * pi/180;
SS=+90.0 * pi/180;


centers290 : array[1..290,1..6] of real= {divide sky in 290 area's in bands of constant DEC}

 {ra_center, dec_center, ra_min    ,ra_max, dec_max, dec_min}

 (( 0       , +AA       ,  0        ,pi         ,AA,BB ),  {1  south pole }

 (0.5/4*2*pi, (BB+CC)/2, 0.0/4*2*pi, 1.0/4*2*pi,BB,CC),  {4 circle segments}
 (1.5/4*2*pi, (BB+CC)/2, 1.0/4*2*pi, 2.0/4*2*pi,BB,CC),
 (2.5/4*2*pi, (BB+CC)/2, 2.0/4*2*pi, 3.0/4*2*pi,BB,CC),
 (3.5/4*2*pi, (BB+CC)/2, 3.0/4*2*pi, 4.0/4*2*pi,BB,CC),

 (0.5/8*2*pi, (CC+DD)/2, 0.0/8*2*pi, 1.0/8*2*pi,CC,DD),  {8 circel segments}
 (1.5/8*2*pi, (CC+DD)/2, 1.0/8*2*pi, 2.0/8*2*pi,CC,DD),
 (2.5/8*2*pi, (CC+DD)/2, 2.0/8*2*pi, 3.0/8*2*pi,CC,DD),
 (3.5/8*2*pi, (CC+DD)/2, 3.0/8*2*pi, 4.0/8*2*pi,CC,DD),
 (4.5/8*2*pi, (CC+DD)/2, 4.0/8*2*pi, 5.0/8*2*pi,CC,DD),
 (5.5/8*2*pi, (CC+DD)/2, 5.0/8*2*pi, 6.0/8*2*pi,CC,DD),
 (6.5/8*2*pi, (CC+DD)/2, 6.0/8*2*pi, 7.0/8*2*pi,CC,DD),
 (7.5/8*2*pi, (CC+DD)/2, 7.0/8*2*pi, 8.0/8*2*pi,CC,DD),

 (0.5/12*2*pi, (DD+EE)/2, 0.0/12*2*pi, 1.0/12*2*pi,DD,EE),  {12 circle segments}
 (1.5/12*2*pi, (DD+EE)/2, 1.0/12*2*pi, 2.0/12*2*pi,DD,EE),
 (2.5/12*2*pi, (DD+EE)/2, 2.0/12*2*pi, 3.0/12*2*pi,DD,EE),
 (3.5/12*2*pi, (DD+EE)/2, 3.0/12*2*pi, 4.0/12*2*pi,DD,EE),
 (4.5/12*2*pi, (DD+EE)/2, 4.0/12*2*pi, 5.0/12*2*pi,DD,EE),
 (5.5/12*2*pi, (DD+EE)/2, 5.0/12*2*pi, 6.0/12*2*pi,DD,EE),
 (6.5/12*2*pi, (DD+EE)/2, 6.0/12*2*pi, 7.0/12*2*pi,DD,EE),
 (7.5/12*2*pi, (DD+EE)/2, 7.0/12*2*pi, 8.0/12*2*pi,DD,EE),
 (8.5/12*2*pi, (DD+EE)/2, 8.0/12*2*pi, 9.0/12*2*pi,DD,EE),
 (9.5/12*2*pi, (DD+EE)/2, 9.0/12*2*pi, 10.0/12*2*pi,DD,EE),
 (10.5/12*2*pi, (DD+EE)/2, 10.0/12*2*pi, 11.0/12*2*pi,DD,EE),
 (11.5/12*2*pi, (DD+EE)/2, 11.0/12*2*pi, 12.0/12*2*pi,DD,EE),

 (0.5/16*2*pi, (EE+FF)/2, 0.0/16*2*pi, 1.0/16*2*pi,EE,FF),  {16 circel segments}
 (1.5/16*2*pi, (EE+FF)/2, 1.0/16*2*pi, 2.0/16*2*pi,EE,FF),
 (2.5/16*2*pi, (EE+FF)/2, 2.0/16*2*pi, 3.0/16*2*pi,EE,FF),
 (3.5/16*2*pi, (EE+FF)/2, 3.0/16*2*pi, 4.0/16*2*pi,EE,FF),
 (4.5/16*2*pi, (EE+FF)/2, 4.0/16*2*pi, 5.0/16*2*pi,EE,FF),
 (5.5/16*2*pi, (EE+FF)/2, 5.0/16*2*pi, 6.0/16*2*pi,EE,FF),
 (6.5/16*2*pi, (EE+FF)/2, 6.0/16*2*pi, 7.0/16*2*pi,EE,FF),
 (7.5/16*2*pi, (EE+FF)/2, 7.0/16*2*pi, 8.0/16*2*pi,EE,FF),
 (8.5/16*2*pi, (EE+FF)/2, 8.0/16*2*pi, 9.0/16*2*pi,EE,FF),
 (9.5/16*2*pi, (EE+FF)/2, 9.0/16*2*pi, 10.0/16*2*pi,EE,FF),
 (10.5/16*2*pi, (EE+FF)/2, 10.0/16*2*pi, 11.0/16*2*pi,EE,FF),
 (11.5/16*2*pi, (EE+FF)/2, 11.0/16*2*pi, 12.0/16*2*pi,EE,FF),
 (12.5/16*2*pi, (EE+FF)/2, 12.0/16*2*pi, 13.0/16*2*pi,EE,FF),
 (13.5/16*2*pi, (EE+FF)/2, 13.0/16*2*pi, 14.0/16*2*pi,EE,FF),
 (14.5/16*2*pi, (EE+FF)/2, 14.0/16*2*pi, 15.0/16*2*pi,EE,FF),
 (15.5/16*2*pi, (EE+FF)/2, 15.0/16*2*pi, 16.0/16*2*pi,EE,FF),

 (0.5/20*2*pi, (FF+GG)/2, 0.0/20*2*pi, 1.0/20*2*pi,FF,GG),  {20 circle segments}
 (1.5/20*2*pi, (FF+GG)/2, 1.0/20*2*pi, 2.0/20*2*pi,FF,GG),
 (2.5/20*2*pi, (FF+GG)/2, 2.0/20*2*pi, 3.0/20*2*pi,FF,GG),
 (3.5/20*2*pi, (FF+GG)/2, 3.0/20*2*pi, 4.0/20*2*pi,FF,GG),
 (4.5/20*2*pi, (FF+GG)/2, 4.0/20*2*pi, 5.0/20*2*pi,FF,GG),
 (5.5/20*2*pi, (FF+GG)/2, 5.0/20*2*pi, 6.0/20*2*pi,FF,GG),
 (6.5/20*2*pi, (FF+GG)/2, 6.0/20*2*pi, 7.0/20*2*pi,FF,GG),
 (7.5/20*2*pi, (FF+GG)/2, 7.0/20*2*pi, 8.0/20*2*pi,FF,GG),
 (8.5/20*2*pi, (FF+GG)/2, 8.0/20*2*pi, 9.0/20*2*pi,FF,GG),
 (9.5/20*2*pi, (FF+GG)/2, 9.0/20*2*pi, 10.0/20*2*pi,FF,GG),
 (10.5/20*2*pi, (FF+GG)/2, 10.0/20*2*pi, 11.0/20*2*pi,FF,GG),
 (11.5/20*2*pi, (FF+GG)/2, 11.0/20*2*pi, 12.0/20*2*pi,FF,GG),
 (12.5/20*2*pi, (FF+GG)/2, 12.0/20*2*pi, 13.0/20*2*pi,FF,GG),
 (13.5/20*2*pi, (FF+GG)/2, 13.0/20*2*pi, 14.0/20*2*pi,FF,GG),
 (14.5/20*2*pi, (FF+GG)/2, 14.0/20*2*pi, 15.0/20*2*pi,FF,GG),
 (15.5/20*2*pi, (FF+GG)/2, 15.0/20*2*pi, 16.0/20*2*pi,FF,GG),
 (16.5/20*2*pi, (FF+GG)/2, 16.0/20*2*pi, 17.0/20*2*pi,FF,GG),
 (17.5/20*2*pi, (FF+GG)/2, 17.0/20*2*pi, 18.0/20*2*pi,FF,GG),
 (18.5/20*2*pi, (FF+GG)/2, 18.0/20*2*pi, 19.0/20*2*pi,FF,GG),
 (19.5/20*2*pi, (FF+GG)/2, 19.0/20*2*pi, 20.0/20*2*pi,FF,GG),

 (0.5/24*2*pi, (GG+HH)/2, 0.0/24*2*pi, 1.0/24*2*pi,GG,HH),  {24circle segments}
 (1.5/24*2*pi, (GG+HH)/2, 1.0/24*2*pi, 2.0/24*2*pi,GG,HH),
 (2.5/24*2*pi, (GG+HH)/2, 2.0/24*2*pi, 3.0/24*2*pi,GG,HH),
 (3.5/24*2*pi, (GG+HH)/2, 3.0/24*2*pi, 4.0/24*2*pi,GG,HH),
 (4.5/24*2*pi, (GG+HH)/2, 4.0/24*2*pi, 5.0/24*2*pi,GG,HH),
 (5.5/24*2*pi, (GG+HH)/2, 5.0/24*2*pi, 6.0/24*2*pi,GG,HH),
 (6.5/24*2*pi, (GG+HH)/2, 6.0/24*2*pi, 7.0/24*2*pi,GG,HH),
 (7.5/24*2*pi, (GG+HH)/2, 7.0/24*2*pi, 8.0/24*2*pi,GG,HH),
 (8.5/24*2*pi, (GG+HH)/2, 8.0/24*2*pi, 9.0/24*2*pi,GG,HH),
 (9.5/24*2*pi, (GG+HH)/2, 9.0/24*2*pi, 10.0/24*2*pi,GG,HH),
 (10.5/24*2*pi, (GG+HH)/2, 10.0/24*2*pi, 11.0/24*2*pi,GG,HH),
 (11.5/24*2*pi, (GG+HH)/2, 11.0/24*2*pi, 12.0/24*2*pi,GG,HH),
 (12.5/24*2*pi, (GG+HH)/2, 12.0/24*2*pi, 13.0/24*2*pi,GG,HH),
 (13.5/24*2*pi, (GG+HH)/2, 13.0/24*2*pi, 14.0/24*2*pi,GG,HH),
 (14.5/24*2*pi, (GG+HH)/2, 14.0/24*2*pi, 15.0/24*2*pi,GG,HH),
 (15.5/24*2*pi, (GG+HH)/2, 15.0/24*2*pi, 16.0/24*2*pi,GG,HH),
 (16.5/24*2*pi, (GG+HH)/2, 16.0/24*2*pi, 17.0/24*2*pi,GG,HH),
 (17.5/24*2*pi, (GG+HH)/2, 17.0/24*2*pi, 18.0/24*2*pi,GG,HH),
 (18.5/24*2*pi, (GG+HH)/2, 18.0/24*2*pi, 19.0/24*2*pi,GG,HH),
 (19.5/24*2*pi, (GG+HH)/2, 19.0/24*2*pi, 20.0/24*2*pi,GG,HH),
 (20.5/24*2*pi, (GG+HH)/2, 20.0/24*2*pi, 21.0/24*2*pi,GG,HH),
 (21.5/24*2*pi, (GG+HH)/2, 21.0/24*2*pi, 22.0/24*2*pi,GG,HH),
 (22.5/24*2*pi, (GG+HH)/2, 22.0/24*2*pi, 23.0/24*2*pi,GG,HH),
 (23.5/24*2*pi, (GG+HH)/2, 23.0/24*2*pi, 24.0/24*2*pi,GG,HH),


 (0.5/28*2*pi, (HH+II)/2, 0.0/28*2*pi, 1.0/28*2*pi,HH,II),  {28 circle segments}
 (1.5/28*2*pi, (HH+II)/2, 1.0/28*2*pi, 2.0/28*2*pi,HH,II),
 (2.5/28*2*pi, (HH+II)/2, 2.0/28*2*pi, 3.0/28*2*pi,HH,II),
 (3.5/28*2*pi, (HH+II)/2, 3.0/28*2*pi, 4.0/28*2*pi,HH,II),
 (4.5/28*2*pi, (HH+II)/2, 4.0/28*2*pi, 5.0/28*2*pi,HH,II),
 (5.5/28*2*pi, (HH+II)/2, 5.0/28*2*pi, 6.0/28*2*pi,HH,II),
 (6.5/28*2*pi, (HH+II)/2, 6.0/28*2*pi, 7.0/28*2*pi,HH,II),
 (7.5/28*2*pi, (HH+II)/2, 7.0/28*2*pi, 8.0/28*2*pi,HH,II),
 (8.5/28*2*pi, (HH+II)/2, 8.0/28*2*pi, 9.0/28*2*pi,HH,II),
 (9.5/28*2*pi, (HH+II)/2, 9.0/28*2*pi, 10.0/28*2*pi,HH,II),
 (10.5/28*2*pi, (HH+II)/2, 10.0/28*2*pi, 11.0/28*2*pi,HH,II),
 (11.5/28*2*pi, (HH+II)/2, 11.0/28*2*pi, 12.0/28*2*pi,HH,II),
 (12.5/28*2*pi, (HH+II)/2, 12.0/28*2*pi, 13.0/28*2*pi,HH,II),
 (13.5/28*2*pi, (HH+II)/2, 13.0/28*2*pi, 14.0/28*2*pi,HH,II),
 (14.5/28*2*pi, (HH+II)/2, 14.0/28*2*pi, 15.0/28*2*pi,HH,II),
 (15.5/28*2*pi, (HH+II)/2, 15.0/28*2*pi, 16.0/28*2*pi,HH,II),
 (16.5/28*2*pi, (HH+II)/2, 16.0/28*2*pi, 17.0/28*2*pi,HH,II),
 (17.5/28*2*pi, (HH+II)/2, 17.0/28*2*pi, 18.0/28*2*pi,HH,II),
 (18.5/28*2*pi, (HH+II)/2, 18.0/28*2*pi, 19.0/28*2*pi,HH,II),
 (19.5/28*2*pi, (HH+II)/2, 19.0/28*2*pi, 20.0/28*2*pi,HH,II),
 (20.5/28*2*pi, (HH+II)/2, 20.0/28*2*pi, 21.0/28*2*pi,HH,II),
 (21.5/28*2*pi, (HH+II)/2, 21.0/28*2*pi, 22.0/28*2*pi,HH,II),
 (22.5/28*2*pi, (HH+II)/2, 22.0/28*2*pi, 23.0/28*2*pi,HH,II),
 (23.5/28*2*pi, (HH+II)/2, 23.0/28*2*pi, 24.0/28*2*pi,HH,II),
 (24.5/28*2*pi, (HH+II)/2, 24.0/28*2*pi, 25.0/28*2*pi,HH,II),
 (25.5/28*2*pi, (HH+II)/2, 25.0/28*2*pi, 26.0/28*2*pi,HH,II),
 (26.5/28*2*pi, (HH+II)/2, 26.0/28*2*pi, 27.0/28*2*pi,HH,II),
 (27.5/28*2*pi, (HH+II)/2, 27.0/28*2*pi, 28.0/28*2*pi,HH,II),

 (0.5/32*2*pi, (II+JJ)/2, 0.0/32*2*pi, 1.0/32*2*pi,II,JJ),  {32 circle segments}
 (1.5/32*2*pi, (II+JJ)/2, 1.0/32*2*pi, 2.0/32*2*pi,II,JJ),
 (2.5/32*2*pi, (II+JJ)/2, 2.0/32*2*pi, 3.0/32*2*pi,II,JJ),
 (3.5/32*2*pi, (II+JJ)/2, 3.0/32*2*pi, 4.0/32*2*pi,II,JJ),
 (4.5/32*2*pi, (II+JJ)/2, 4.0/32*2*pi, 5.0/32*2*pi,II,JJ),
 (5.5/32*2*pi, (II+JJ)/2, 5.0/32*2*pi, 6.0/32*2*pi,II,JJ),
 (6.5/32*2*pi, (II+JJ)/2, 6.0/32*2*pi, 7.0/32*2*pi,II,JJ),
 (7.5/32*2*pi, (II+JJ)/2, 7.0/32*2*pi, 8.0/32*2*pi,II,JJ),
 (8.5/32*2*pi, (II+JJ)/2, 8.0/32*2*pi, 9.0/32*2*pi,II,JJ),
 (9.5/32*2*pi, (II+JJ)/2, 9.0/32*2*pi, 10.0/32*2*pi,II,JJ),
 (10.5/32*2*pi, (II+JJ)/2, 10.0/32*2*pi, 11.0/32*2*pi,II,JJ),
 (11.5/32*2*pi, (II+JJ)/2, 11.0/32*2*pi, 12.0/32*2*pi,II,JJ),
 (12.5/32*2*pi, (II+JJ)/2, 12.0/32*2*pi, 13.0/32*2*pi,II,JJ),
 (13.5/32*2*pi, (II+JJ)/2, 13.0/32*2*pi, 14.0/32*2*pi,II,JJ),
 (14.5/32*2*pi, (II+JJ)/2, 14.0/32*2*pi, 15.0/32*2*pi,II,JJ),
 (15.5/32*2*pi, (II+JJ)/2, 15.0/32*2*pi, 16.0/32*2*pi,II,JJ),
 (16.5/32*2*pi, (II+JJ)/2, 16.0/32*2*pi, 17.0/32*2*pi,II,JJ),
 (17.5/32*2*pi, (II+JJ)/2, 17.0/32*2*pi, 18.0/32*2*pi,II,JJ),
 (18.5/32*2*pi, (II+JJ)/2, 18.0/32*2*pi, 19.0/32*2*pi,II,JJ),
 (19.5/32*2*pi, (II+JJ)/2, 19.0/32*2*pi, 20.0/32*2*pi,II,JJ),
 (20.5/32*2*pi, (II+JJ)/2, 20.0/32*2*pi, 21.0/32*2*pi,II,JJ),
 (21.5/32*2*pi, (II+JJ)/2, 21.0/32*2*pi, 22.0/32*2*pi,II,JJ),
 (22.5/32*2*pi, (II+JJ)/2, 22.0/32*2*pi, 23.0/32*2*pi,II,JJ),
 (23.5/32*2*pi, (II+JJ)/2, 23.0/32*2*pi, 24.0/32*2*pi,II,JJ),
 (24.5/32*2*pi, (II+JJ)/2, 24.0/32*2*pi, 25.0/32*2*pi,II,JJ),
 (25.5/32*2*pi, (II+JJ)/2, 25.0/32*2*pi, 26.0/32*2*pi,II,JJ),
 (26.5/32*2*pi, (II+JJ)/2, 26.0/32*2*pi, 27.0/32*2*pi,II,JJ),
 (27.5/32*2*pi, (II+JJ)/2, 27.0/32*2*pi, 28.0/32*2*pi,II,JJ),
 (28.5/32*2*pi, (II+JJ)/2, 28.0/32*2*pi, 29.0/32*2*pi,II,JJ),
 (29.5/32*2*pi, (II+JJ)/2, 29.0/32*2*pi, 30.0/32*2*pi,II,JJ),
 (30.5/32*2*pi, (II+JJ)/2, 30.0/32*2*pi, 31.0/32*2*pi,II,JJ),
 (31.5/32*2*pi, (II+JJ)/2, 31.0/32*2*pi, 32.0/32*2*pi,II,JJ),

 (0.5/32*2*pi, -(II+JJ)/2, 0.0/32*2*pi, 1.0/32*2*pi,-II,JJ),  {32 circle segments}
 (1.5/32*2*pi, -(II+JJ)/2, 1.0/32*2*pi, 2.0/32*2*pi,-II,JJ),
 (2.5/32*2*pi, -(II+JJ)/2, 2.0/32*2*pi, 3.0/32*2*pi,-II,JJ),
 (3.5/32*2*pi, -(II+JJ)/2, 3.0/32*2*pi, 4.0/32*2*pi,-II,JJ),
 (4.5/32*2*pi, -(II+JJ)/2, 4.0/32*2*pi, 5.0/32*2*pi,-II,JJ),
 (5.5/32*2*pi, -(II+JJ)/2, 5.0/32*2*pi, 6.0/32*2*pi,-II,JJ),
 (6.5/32*2*pi, -(II+JJ)/2, 6.0/32*2*pi, 7.0/32*2*pi,-II,JJ),
 (7.5/32*2*pi, -(II+JJ)/2, 7.0/32*2*pi, 8.0/32*2*pi,-II,JJ),
 (8.5/32*2*pi, -(II+JJ)/2, 8.0/32*2*pi, 9.0/32*2*pi,-II,JJ),
 (9.5/32*2*pi, -(II+JJ)/2, 9.0/32*2*pi, 10.0/32*2*pi,-II,JJ),
 (10.5/32*2*pi, -(II+JJ)/2, 10.0/32*2*pi, 11.0/32*2*pi,-II,JJ),
 (11.5/32*2*pi, -(II+JJ)/2, 11.0/32*2*pi, 12.0/32*2*pi,-II,JJ),
 (12.5/32*2*pi, -(II+JJ)/2, 12.0/32*2*pi, 13.0/32*2*pi,-II,JJ),
 (13.5/32*2*pi, -(II+JJ)/2, 13.0/32*2*pi, 14.0/32*2*pi,-II,JJ),
 (14.5/32*2*pi, -(II+JJ)/2, 14.0/32*2*pi, 15.0/32*2*pi,-II,JJ),
 (15.5/32*2*pi, -(II+JJ)/2, 15.0/32*2*pi, 16.0/32*2*pi,-II,JJ),
 (16.5/32*2*pi, -(II+JJ)/2, 16.0/32*2*pi, 17.0/32*2*pi,-II,JJ),
 (17.5/32*2*pi, -(II+JJ)/2, 17.0/32*2*pi, 18.0/32*2*pi,-II,JJ),
 (18.5/32*2*pi, -(II+JJ)/2, 18.0/32*2*pi, 19.0/32*2*pi,-II,JJ),
 (19.5/32*2*pi, -(II+JJ)/2, 19.0/32*2*pi, 20.0/32*2*pi,-II,JJ),
 (20.5/32*2*pi, -(II+JJ)/2, 20.0/32*2*pi, 21.0/32*2*pi,-II,JJ),
 (21.5/32*2*pi, -(II+JJ)/2, 21.0/32*2*pi, 22.0/32*2*pi,-II,JJ),
 (22.5/32*2*pi, -(II+JJ)/2, 22.0/32*2*pi, 23.0/32*2*pi,-II,JJ),
 (23.5/32*2*pi, -(II+JJ)/2, 23.0/32*2*pi, 24.0/32*2*pi,-II,JJ),
 (24.5/32*2*pi, -(II+JJ)/2, 24.0/32*2*pi, 25.0/32*2*pi,-II,JJ),
 (25.5/32*2*pi, -(II+JJ)/2, 25.0/32*2*pi, 26.0/32*2*pi,-II,JJ),
 (26.5/32*2*pi, -(II+JJ)/2, 26.0/32*2*pi, 27.0/32*2*pi,-II,JJ),
 (27.5/32*2*pi, -(II+JJ)/2, 27.0/32*2*pi, 28.0/32*2*pi,-II,JJ),
 (28.5/32*2*pi, -(II+JJ)/2, 28.0/32*2*pi, 29.0/32*2*pi,-II,JJ),
 (29.5/32*2*pi, -(II+JJ)/2, 29.0/32*2*pi, 30.0/32*2*pi,-II,JJ),
 (30.5/32*2*pi, -(II+JJ)/2, 30.0/32*2*pi, 31.0/32*2*pi,-II,JJ),
 (31.5/32*2*pi, -(II+JJ)/2, 31.0/32*2*pi, 32.0/32*2*pi,-II,JJ),

 (0.5/28*2*pi, -(HH+II)/2, 0.0/28*2*pi, 1.0/28*2*pi,-HH,-II),  {28 circle segments}
 (1.5/28*2*pi, -(HH+II)/2, 1.0/28*2*pi, 2.0/28*2*pi,-HH,-II),
 (2.5/28*2*pi, -(HH+II)/2, 2.0/28*2*pi, 3.0/28*2*pi,-HH,-II),
 (3.5/28*2*pi, -(HH+II)/2, 3.0/28*2*pi, 4.0/28*2*pi,-HH,-II),
 (4.5/28*2*pi, -(HH+II)/2, 4.0/28*2*pi, 5.0/28*2*pi,-HH,-II),
 (5.5/28*2*pi, -(HH+II)/2, 5.0/28*2*pi, 6.0/28*2*pi,-HH,-II),
 (6.5/28*2*pi, -(HH+II)/2, 6.0/28*2*pi, 7.0/28*2*pi,-HH,-II),
 (7.5/28*2*pi, -(HH+II)/2, 7.0/28*2*pi, 8.0/28*2*pi,-HH,-II),
 (8.5/28*2*pi, -(HH+II)/2, 8.0/28*2*pi, 9.0/28*2*pi,-HH,-II),
 (9.5/28*2*pi, -(HH+II)/2, 9.0/28*2*pi, 10.0/28*2*pi,-HH,-II),
 (10.5/28*2*pi, -(HH+II)/2, 10.0/28*2*pi, 11.0/28*2*pi,-HH,-II),
 (11.5/28*2*pi, -(HH+II)/2, 11.0/28*2*pi, 12.0/28*2*pi,-HH,-II),
 (12.5/28*2*pi, -(HH+II)/2, 12.0/28*2*pi, 13.0/28*2*pi,-HH,-II),
 (13.5/28*2*pi, -(HH+II)/2, 13.0/28*2*pi, 14.0/28*2*pi,-HH,-II),
 (14.5/28*2*pi, -(HH+II)/2, 14.0/28*2*pi, 15.0/28*2*pi,-HH,-II),
 (15.5/28*2*pi, -(HH+II)/2, 15.0/28*2*pi, 16.0/28*2*pi,-HH,-II),
 (16.5/28*2*pi, -(HH+II)/2, 16.0/28*2*pi, 17.0/28*2*pi,-HH,-II),
 (17.5/28*2*pi, -(HH+II)/2, 17.0/28*2*pi, 18.0/28*2*pi,-HH,-II),
 (18.5/28*2*pi, -(HH+II)/2, 18.0/28*2*pi, 19.0/28*2*pi,-HH,-II),
 (19.5/28*2*pi, -(HH+II)/2, 19.0/28*2*pi, 20.0/28*2*pi,-HH,-II),
 (20.5/28*2*pi, -(HH+II)/2, 20.0/28*2*pi, 21.0/28*2*pi,-HH,-II),
 (21.5/28*2*pi, -(HH+II)/2, 21.0/28*2*pi, 22.0/28*2*pi,-HH,-II),
 (22.5/28*2*pi, -(HH+II)/2, 22.0/28*2*pi, 23.0/28*2*pi,-HH,-II),
 (23.5/28*2*pi, -(HH+II)/2, 23.0/28*2*pi, 24.0/28*2*pi,-HH,-II),
 (24.5/28*2*pi, -(HH+II)/2, 24.0/28*2*pi, 25.0/28*2*pi,-HH,-II),
 (25.5/28*2*pi, -(HH+II)/2, 25.0/28*2*pi, 26.0/28*2*pi,-HH,-II),
 (26.5/28*2*pi, -(HH+II)/2, 26.0/28*2*pi, 27.0/28*2*pi,-HH,-II),
 (27.5/28*2*pi, -(HH+II)/2, 27.0/28*2*pi, 28.0/28*2*pi,-HH,-II),

 (0.5/24*2*pi, -(GG+HH)/2, 0.0/24*2*pi, 1.0/24*2*pi,-GG,-HH),  {24 circle segments}
 (1.5/24*2*pi, -(GG+HH)/2, 1.0/24*2*pi, 2.0/24*2*pi,-GG,-HH),
 (2.5/24*2*pi, -(GG+HH)/2, 2.0/24*2*pi, 3.0/24*2*pi,-GG,-HH),
 (3.5/24*2*pi, -(GG+HH)/2, 3.0/24*2*pi, 4.0/24*2*pi,-GG,-HH),
 (4.5/24*2*pi, -(GG+HH)/2, 4.0/24*2*pi, 5.0/24*2*pi,-GG,-HH),
 (5.5/24*2*pi, -(GG+HH)/2, 5.0/24*2*pi, 6.0/24*2*pi,-GG,-HH),
 (6.5/24*2*pi, -(GG+HH)/2, 6.0/24*2*pi, 7.0/24*2*pi,-GG,-HH),
 (7.5/24*2*pi, -(GG+HH)/2, 7.0/24*2*pi, 8.0/24*2*pi,-GG,-HH),
 (8.5/24*2*pi, -(GG+HH)/2, 8.0/24*2*pi, 9.0/24*2*pi,-GG,-HH),
 (9.5/24*2*pi, -(GG+HH)/2, 9.0/24*2*pi, 10.0/24*2*pi,-GG,-HH),
 (10.5/24*2*pi, -(GG+HH)/2, 10.0/24*2*pi, 11.0/24*2*pi,-GG,-HH),
 (11.5/24*2*pi, -(GG+HH)/2, 11.0/24*2*pi, 12.0/24*2*pi,-GG,-HH),
 (12.5/24*2*pi, -(GG+HH)/2, 12.0/24*2*pi, 13.0/24*2*pi,-GG,-HH),
 (13.5/24*2*pi, -(GG+HH)/2, 13.0/24*2*pi, 14.0/24*2*pi,-GG,-HH),
 (14.5/24*2*pi, -(GG+HH)/2, 14.0/24*2*pi, 15.0/24*2*pi,-GG,-HH),
 (15.5/24*2*pi, -(GG+HH)/2, 15.0/24*2*pi, 16.0/24*2*pi,-GG,-HH),
 (16.5/24*2*pi, -(GG+HH)/2, 16.0/24*2*pi, 17.0/24*2*pi,-GG,-HH),
 (17.5/24*2*pi, -(GG+HH)/2, 17.0/24*2*pi, 18.0/24*2*pi,-GG,-HH),
 (18.5/24*2*pi, -(GG+HH)/2, 18.0/24*2*pi, 19.0/24*2*pi,-GG,-HH),
 (19.5/24*2*pi, -(GG+HH)/2, 19.0/24*2*pi, 20.0/24*2*pi,-GG,-HH),
 (20.5/24*2*pi, -(GG+HH)/2, 20.0/24*2*pi, 21.0/24*2*pi,-GG,-HH),
 (21.5/24*2*pi, -(GG+HH)/2, 21.0/24*2*pi, 22.0/24*2*pi,-GG,-HH),
 (22.5/24*2*pi, -(GG+HH)/2, 22.0/24*2*pi, 23.0/24*2*pi,-GG,-HH),
 (23.5/24*2*pi, -(GG+HH)/2, 23.0/24*2*pi, 24.0/24*2*pi,-GG,-HH),

 (0.5/20*2*pi, -(FF+GG)/2, 0.0/20*2*pi, 1.0/20*2*pi,-FF,-GG),  {20 circle segments}
 (1.5/20*2*pi, -(FF+GG)/2, 1.0/20*2*pi, 2.0/20*2*pi,-FF,-GG),
 (2.5/20*2*pi, -(FF+GG)/2, 2.0/20*2*pi, 3.0/20*2*pi,-FF,-GG),
 (3.5/20*2*pi, -(FF+GG)/2, 3.0/20*2*pi, 4.0/20*2*pi,-FF,-GG),
 (4.5/20*2*pi, -(FF+GG)/2, 4.0/20*2*pi, 5.0/20*2*pi,-FF,-GG),
 (5.5/20*2*pi, -(FF+GG)/2, 5.0/20*2*pi, 6.0/20*2*pi,-FF,-GG),
 (6.5/20*2*pi, -(FF+GG)/2, 6.0/20*2*pi, 7.0/20*2*pi,-FF,-GG),
 (7.5/20*2*pi, -(FF+GG)/2, 7.0/20*2*pi, 8.0/20*2*pi,-FF,-GG),
 (8.5/20*2*pi, -(FF+GG)/2, 8.0/20*2*pi, 9.0/20*2*pi,-FF,-GG),
 (9.5/20*2*pi, -(FF+GG)/2, 9.0/20*2*pi, 10.0/20*2*pi,-FF,-GG),
 (10.5/20*2*pi, -(FF+GG)/2, 10.0/20*2*pi, 11.0/20*2*pi,-FF,-GG),
 (11.5/20*2*pi, -(FF+GG)/2, 11.0/20*2*pi, 12.0/20*2*pi,-FF,-GG),
 (12.5/20*2*pi, -(FF+GG)/2, 12.0/20*2*pi, 13.0/20*2*pi,-FF,-GG),
 (13.5/20*2*pi, -(FF+GG)/2, 13.0/20*2*pi, 14.0/20*2*pi,-FF,-GG),
 (14.5/20*2*pi, -(FF+GG)/2, 14.0/20*2*pi, 15.0/20*2*pi,-FF,-GG),
 (15.5/20*2*pi, -(FF+GG)/2, 15.0/20*2*pi, 16.0/20*2*pi,-FF,-GG),
 (16.5/20*2*pi, -(FF+GG)/2, 16.0/20*2*pi, 17.0/20*2*pi,-FF,-GG),
 (17.5/20*2*pi, -(FF+GG)/2, 17.0/20*2*pi, 18.0/20*2*pi,-FF,-GG),
 (18.5/20*2*pi, -(FF+GG)/2, 18.0/20*2*pi, 19.0/20*2*pi,-FF,-GG),
 (19.5/20*2*pi, -(FF+GG)/2, 19.0/20*2*pi, 20.0/20*2*pi,-FF,-GG),

 (0.5/16*2*pi, -(EE+FF)/2, 0.0/16*2*pi, 1.0/16*2*pi,-EE,-FF),  {16 circle segments}
 (1.5/16*2*pi, -(EE+FF)/2, 1.0/16*2*pi, 2.0/16*2*pi,-EE,-FF),
 (2.5/16*2*pi, -(EE+FF)/2, 2.0/16*2*pi, 3.0/16*2*pi,-EE,-FF),
 (3.5/16*2*pi, -(EE+FF)/2, 3.0/16*2*pi, 4.0/16*2*pi,-EE,-FF),
 (4.5/16*2*pi, -(EE+FF)/2, 4.0/16*2*pi, 5.0/16*2*pi,-EE,-FF),
 (5.5/16*2*pi, -(EE+FF)/2, 5.0/16*2*pi, 6.0/16*2*pi,-EE,-FF),
 (6.5/16*2*pi, -(EE+FF)/2, 6.0/16*2*pi, 7.0/16*2*pi,-EE,-FF),
 (7.5/16*2*pi, -(EE+FF)/2, 7.0/16*2*pi, 8.0/16*2*pi,-EE,-FF),
 (8.5/16*2*pi, -(EE+FF)/2, 8.0/16*2*pi, 9.0/16*2*pi,-EE,-FF),
 (9.5/16*2*pi, -(EE+FF)/2, 9.0/16*2*pi, 10.0/16*2*pi,-EE,-FF),
 (10.5/16*2*pi, -(EE+FF)/2, 10.0/16*2*pi, 11.0/16*2*pi,-EE,-FF),
 (11.5/16*2*pi, -(EE+FF)/2, 11.0/16*2*pi, 12.0/16*2*pi,-EE,-FF),
 (12.5/16*2*pi, -(EE+FF)/2, 12.0/16*2*pi, 13.0/16*2*pi,-EE,-FF),
 (13.5/16*2*pi, -(EE+FF)/2, 13.0/16*2*pi, 14.0/16*2*pi,-EE,-FF),
 (14.5/16*2*pi, -(EE+FF)/2, 14.0/16*2*pi, 15.0/16*2*pi,-EE,-FF),
 (15.5/16*2*pi, -(EE+FF)/2, 15.0/16*2*pi, 16.0/16*2*pi,-EE,-FF),

 (0.5/12*2*pi, -(DD+EE)/2, 0.0/12*2*pi, 1.0/12*2*pi,-DD,-EE),  {12 circle segments}
 (1.5/12*2*pi, -(DD+EE)/2, 1.0/12*2*pi, 2.0/12*2*pi,-DD,-EE),
 (2.5/12*2*pi, -(DD+EE)/2, 2.0/12*2*pi, 3.0/12*2*pi,-DD,-EE),
 (3.5/12*2*pi, -(DD+EE)/2, 3.0/12*2*pi, 4.0/12*2*pi,-DD,-EE),
 (4.5/12*2*pi, -(DD+EE)/2, 4.0/12*2*pi, 5.0/12*2*pi,-DD,-EE),
 (5.5/12*2*pi, -(DD+EE)/2, 5.0/12*2*pi, 6.0/12*2*pi,-DD,-EE),
 (6.5/12*2*pi, -(DD+EE)/2, 6.0/12*2*pi, 7.0/12*2*pi,-DD,-EE),
 (7.5/12*2*pi, -(DD+EE)/2, 7.0/12*2*pi, 8.0/12*2*pi,-DD,-EE),
 (8.5/12*2*pi, -(DD+EE)/2, 8.0/12*2*pi, 9.0/12*2*pi,-DD,-EE),
 (9.5/12*2*pi, -(DD+EE)/2, 9.0/12*2*pi, 10.0/12*2*pi,-DD,-EE),
 (10.5/12*2*pi,-(DD+EE)/2, 10.0/12*2*pi, 11.0/12*2*pi,-DD,-EE),
 (11.5/12*2*pi,-(DD+EE)/2, 11.0/12*2*pi, 12.0/12*2*pi,-DD,-EE),

 (0.5/8*2*pi, -(CC+DD)/2, 0.0/8*2*pi, 1.0/8*2*pi,-CC,-DD),  {8 circle segments}
 (1.5/8*2*pi, -(CC+DD)/2, 1.0/8*2*pi, 2.0/8*2*pi,-CC,-DD),
 (2.5/8*2*pi, -(CC+DD)/2, 2.0/8*2*pi, 3.0/8*2*pi,-CC,-DD),
 (3.5/8*2*pi, -(CC+DD)/2, 3.0/8*2*pi, 4.0/8*2*pi,-CC,-DD),
 (4.5/8*2*pi, -(CC+DD)/2, 4.0/8*2*pi, 5.0/8*2*pi,-CC,-DD),
 (5.5/8*2*pi, -(CC+DD)/2, 5.0/8*2*pi, 6.0/8*2*pi,-CC,-DD),
 (6.5/8*2*pi, -(CC+DD)/2, 6.0/8*2*pi, 7.0/8*2*pi,-CC,-DD),
 (7.5/8*2*pi, -(CC+DD)/2, 7.0/8*2*pi, 8.0/8*2*pi,-CC,-DD),

 (0.5/4*2*pi, -(BB+CC)/2, 0.0/4*2*pi,  1.0/4*2*pi,-BB,-CC),  {4 circle segments}
 (1.5/4*2*pi, -(BB+CC)/2, 1.0/4*2*pi, 2.0/4*2*pi,-BB,-CC),
 (2.5/4*2*pi, -(BB+CC)/2, 2.0/4*2*pi, 3.0/4*2*pi,-BB,-CC),
 (3.5/4*2*pi, -(BB+CC)/2, 3.0/4*2*pi, 4.0/4*2*pi,-BB,-CC),

 ( 0        , -AA        ,  0        ,pi         ,-AA,-BB )); {1 segment}   {north pole }


filenames290 : array[1..290] of string= {}
(('0101.290'),

 ('0201.290'),  {combined cells from 8}
 ('0202.290'),
 ('0203.290'),
 ('0204.290'),

 ('0301.290'),
 ('0302.290'),
 ('0303.290'),
 ('0304.290'),
 ('0305.290'),
 ('0306.290'),
 ('0307.290'),
 ('0308.290'),

 ('0401.290'),
 ('0402.290'),
 ('0403.290'),
 ('0404.290'),
 ('0405.290'),
 ('0406.290'),
 ('0407.290'),
 ('0408.290'),
 ('0409.290'),
 ('0410.290'),
 ('0411.290'),
 ('0412.290'),

 ('0501.290'),
 ('0502.290'),
 ('0503.290'),
 ('0504.290'),
 ('0505.290'),
 ('0506.290'),
 ('0507.290'),
 ('0508.290'),
 ('0509.290'),
 ('0510.290'),
 ('0511.290'),
 ('0512.290'),
 ('0513.290'),
 ('0514.290'),
 ('0515.290'),
 ('0516.290'),

 ('0601.290'),
 ('0602.290'),
 ('0603.290'),
 ('0604.290'),
 ('0605.290'),
 ('0606.290'),
 ('0607.290'),
 ('0608.290'),
 ('0609.290'),
 ('0610.290'),
 ('0611.290'),
 ('0612.290'),
 ('0613.290'),
 ('0614.290'),
 ('0615.290'),
 ('0616.290'),
 ('0617.290'),
 ('0618.290'),
 ('0619.290'),
 ('0620.290'),

 ('0701.290'),
 ('0702.290'),
 ('0703.290'),
 ('0704.290'),
 ('0705.290'),
 ('0706.290'),
 ('0707.290'),
 ('0708.290'),
 ('0709.290'),
 ('0710.290'),
 ('0711.290'),
 ('0712.290'),
 ('0713.290'),
 ('0714.290'),
 ('0715.290'),
 ('0716.290'),
 ('0717.290'),
 ('0718.290'),
 ('0719.290'),
 ('0720.290'),
 ('0721.290'),
 ('0722.290'),
 ('0723.290'),
 ('0724.290'),

 ('0801.290'),
 ('0802.290'),
 ('0803.290'),
 ('0804.290'),
 ('0805.290'),
 ('0806.290'),
 ('0807.290'),
 ('0808.290'),
 ('0809.290'),
 ('0810.290'),
 ('0811.290'),
 ('0812.290'),
 ('0813.290'),
 ('0814.290'),
 ('0815.290'),
 ('0816.290'),
 ('0817.290'),
 ('0818.290'),
 ('0819.290'),
 ('0820.290'),
 ('0821.290'),
 ('0822.290'),
 ('0823.290'),
 ('0824.290'),
 ('0825.290'),
 ('0826.290'),
 ('0827.290'),
 ('0828.290'),

 ('0901.290'),
 ('0902.290'),
 ('0903.290'),
 ('0904.290'),
 ('0905.290'),
 ('0906.290'),
 ('0907.290'),
 ('0908.290'),
 ('0909.290'),
 ('0910.290'),
 ('0911.290'),
 ('0912.290'),
 ('0913.290'),
 ('0914.290'),
 ('0915.290'),
 ('0916.290'),
 ('0917.290'),
 ('0918.290'),
 ('0919.290'),
 ('0920.290'),
 ('0921.290'),
 ('0922.290'),
 ('0923.290'),
 ('0924.290'),
 ('0925.290'),
 ('0926.290'),
 ('0927.290'),
 ('0928.290'),
 ('0929.290'),
 ('0930.290'),
 ('0931.290'),
 ('0932.290'),

 ('1001.290'),
 ('1002.290'),
 ('1003.290'),
 ('1004.290'),
 ('1005.290'),
 ('1006.290'),
 ('1007.290'),
 ('1008.290'),
 ('1009.290'),
 ('1010.290'),
 ('1011.290'),
 ('1012.290'),
 ('1013.290'),
 ('1014.290'),
 ('1015.290'),
 ('1016.290'),
 ('1017.290'),
 ('1018.290'),
 ('1019.290'),
 ('1020.290'),
 ('1021.290'),
 ('1022.290'),
 ('1023.290'),
 ('1024.290'),
 ('1025.290'),
 ('1026.290'),
 ('1027.290'),
 ('1028.290'),
 ('1029.290'),
 ('1030.290'),
 ('1031.290'),
 ('1032.290'),

 ('1101.290'),
 ('1102.290'),
 ('1103.290'),
 ('1104.290'),
 ('1105.290'),
 ('1106.290'),
 ('1107.290'),
 ('1108.290'),
 ('1109.290'),
 ('1110.290'),
 ('1111.290'),
 ('1112.290'),
 ('1113.290'),
 ('1114.290'),
 ('1115.290'),
 ('1116.290'),
 ('1117.290'),
 ('1118.290'),
 ('1119.290'),
 ('1120.290'),
 ('1121.290'),
 ('1122.290'),
 ('1123.290'),
 ('1124.290'),
 ('1125.290'),
 ('1126.290'),
 ('1127.290'),
 ('1128.290'),

 ('1201.290'),
 ('1202.290'),
 ('1203.290'),
 ('1204.290'),
 ('1205.290'),
 ('1206.290'),
 ('1207.290'),
 ('1208.290'),
 ('1209.290'),
 ('1210.290'),
 ('1211.290'),
 ('1212.290'),
 ('1213.290'),
 ('1214.290'),
 ('1215.290'),
 ('1216.290'),
 ('1217.290'),
 ('1218.290'),
 ('1219.290'),
 ('1220.290'),
 ('1221.290'),
 ('1222.290'),
 ('1223.290'),
 ('1224.290'),

 ('1301.290'),
 ('1302.290'),
 ('1303.290'),
 ('1304.290'),
 ('1305.290'),
 ('1306.290'),
 ('1307.290'),
 ('1308.290'),
 ('1309.290'),
 ('1310.290'),
 ('1311.290'),
 ('1312.290'),
 ('1313.290'),
 ('1314.290'),
 ('1315.290'),
 ('1316.290'),
 ('1317.290'),
 ('1318.290'),
 ('1319.290'),
 ('1320.290'),

 ('1401.290'),
 ('1402.290'),
 ('1403.290'),
 ('1404.290'),
 ('1405.290'),
 ('1406.290'),
 ('1407.290'),
 ('1408.290'),
 ('1409.290'),
 ('1410.290'),
 ('1411.290'),
 ('1412.290'),
 ('1413.290'),
 ('1414.290'),
 ('1415.290'),
 ('1416.290'),

 ('1501.290'),
 ('1502.290'),
 ('1503.290'),
 ('1504.290'),
 ('1505.290'),
 ('1506.290'),
 ('1507.290'),
 ('1508.290'),
 ('1509.290'),
 ('1510.290'),
 ('1511.290'),
 ('1512.290'),

 ('1601.290'),
 ('1602.290'),
 ('1603.290'),
 ('1604.290'),
 ('1605.290'),
 ('1606.290'),
 ('1607.290'),
 ('1608.290'),


 ('1701.290'),
 ('1702.290'),
 ('1703.290'),
 ('1704.290'),

 ('1801.290'));


const
   record_size:integer=11;{default}
   record_type:integer=11;
var
  p11       : ^hnskyhdr290_11;	    { pointer to hnskyrecord }
  p10       : ^hnskyhdr290_10;	    { pointer to hnskyrecord }
  p9        : ^hnskyhdr290_9;	    { pointer to hnskyrecord }
  pA7       : ^hnskyhdr290_A7;	    { pointer to hnskyrecord }
  p7        : ^hnskyhdr290_7;	    { pointer to hnskyrecord }
  p6        : ^hnskyhdr290_6;       { pointer to hnskyrecord }
  pA6       : ^hnskyhdr290_A6;       { pointer to hnskyrecord }
  p5        : ^hnskyhdr290_5;       { pointer to hnskyrecord }
  dec9_storage: shortint;

  area290:integer;      {290 files, should be set at 290+1 for before any read series}
  buf2: array[1..sizeof(hnskyhdr)] of byte;  {read buffer stars}
  thefile_stars      : tfilestream;
  Reader_stars       : TReader;


procedure closedatabase;
begin
  if file_open=2 then
  begin
    Reader_stars.free;
    thefile_stars.free;
    end;
  file_open:=0;
end;

procedure opendatabase2(naam_star:string);{open star database}
begin
  {$I-}
  mag2:=0; {is compared with deep for maximum magnitude, should be set low before starting}

  if length(name_star)<=9 then exit;

  if file_open<>0 then
   closedatabase;
  try
    thefile_stars:=tfilestream.Create(application_Path+naam_star{naam5}, fmOpenRead or fmShareDenyWrite);{read but do not lock file for reading by other programs}
    nr_records:= trunc(thefile_stars.size/sizeof(hnskyhdr));
    Reader_stars := TReader.Create (thefile_stars, 1024*11);{number of hnsky records}
  except
    exit;
  end;
  {thefile_stars.size-reader.position>sizeof(hnskyhdr) could also be used but slow down a factor of 2 !!!}
  file_open:=2; {buffer size is .. x 1024}
  reader_stars.read(database2,sizeof(database2)); {read file info}
  dec(nr_records,10); {correct for above read}

end;


procedure read_star(searchmode:char);{.dat star database search}
            {searchmode=S screen update}
            {searchmode=M mouse click  search}
            {searchmode=T text search}
  var
    p2           : ^hnskyhdr;		        { pointer to hnskyrecord }
    nr           : longint;
    delta_ra,sep : double;
    i            : integer;
    in_sight     : boolean;
 label      einde;
begin
   {$I-}
   p2:= @buf2[1];	{ set pointer }
   repeat
     if  ( (file_open=0) or {(thefile_stars.status<>0) or}
          ((searchmode<>'T') and (mag2>maxmag))
          )  then    {file_open omdat anders fileroutine soms vastloopt}
einde:begin
        mode:=100;{go to next step}
        closedatabase;
        mag2:=9999;{prevent ghost images around moon if moon covers stars}
        exit;
      end;
     {thefile_stars.readbuffer(buf2,sizeof(hnskyhdr));}
     reader_stars.read(buf2,sizeof(hnskyhdr));
     with p2^ do
     begin
       ra2:= (ra7 + ra8 shl 8 +ra9 shl 16)*(pi*2  /((256*256*256)-1));
       dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, put dec7 behind}
       if mag0>-20 then mag2:=mag0 else mag2:=256+mag0;{new magn 12.8 is -12.8, 12.9 = -12.7}
     end;

     delta_ra:=abs(ra2-telescope_ra); if delta_ra>pi then delta_ra:=pi*2-delta_ra;
     if delta_ra>pi/3 then
     begin {far away in ra}
       ang_sep(telescope_ra,telescope_dec,ra2,dec2, sep );{seperation using rigorous method}
       in_sight:=sep<(1+work_width/work_height)/zoom; {star in sight?}
      end
     else
     begin {nearby in ra}
       sep:=(sqr( delta_ra*cos(dec2) ) + sqr(dec2-telescope_dec));{seperation using approximate method for shorter distances}
       in_sight:=sep<sqr((1+work_width/work_height)/zoom); {star in sight?  sqr is faster then sqrt}
     end;

     dec(nr_records); {faster then  (thefile_stars.size-thefile_stars.position<sizeof(hnskyhdr) !!!)}
     if nr_records<=0 then goto einde;{here otherwise star at 0:0}
   until ((searchmode='T') or
          {$ifdef mswindows}
          (getinputstate) or {to be fixed for Linux}
          {$ELSE} {}
          {$endif}
          (in_sight));{2020-12-30, in sight of screen}
          {searchmode=S screen update}
          {searchmode=M mouse click  search}
            {searchmode=T text search}
   type2:='';

   {name stars}
   with p2^ do
   begin
     nr:=(nr1)+(trunc(nr2) shl 8)+(trunc(nr3) shl 16);
     str(nr,naam2);
     spectr:=spectral[1,spec0 shr 4] +spectral[0,spec0 and $0F];    { spec0 shr 4}
   end;

   {namest=0 bright stars only}
   {namest=1 external stars only}
   {namest=2 all stars}
   if (mag2<=29) then
   IF (  ( (namest=0) and ((mag2<=03) or (dec2>pi*89/180)) ) {name only bright stars and polaris}
          or
         (namest=2) {all stars with names}
          or
         (searchmode<>'S') ) THEN   { mouse click search or text search}
   begin
     type2:=''; {clear always}



     for i:=0 to round(-1+sizeof(Bright_star_pos)/8) do
     begin
       if abs(ra2-Bright_star_pos[i,0])<pi*0.5/180 then
       if abs(dec2-Bright_star_pos[i,1])<pi*0.5/180 then type2:=Bright_star_name[i];
    end;
  end;  {name stars}
end;


procedure reset290index;{call this procedure before start reading from the 290 files}
begin
  area290:=290+1;
end;


// searchmode [S,T] specify S = screen update within FOV or T for full (designation text) database access.
// telescope_ra, telescope_dec [radians], contains to center position of the field of interest
// field_diameter [radians], FOV diameter of field of interest. This is ignored in searchmode=T}
// ra2, dec2 [radians],   reported star position
// mag2 [magnitude*10]  reported star magnitude
// result [true/false]  if reported true then more stars are available. If false no more stars available.
// extra outputs:
//          naam2,  string containing the star Tycho/UCAC4 designation for record size above 7
//          database2  : array[0..(11*10)] of ansichar;{text info star database used}
// preconditions:
//   procedure reset290index should be called before any read.
//   maxmag [magnitude*10], double variable which specifies the maximum magnitude to be read. This is typical used in HNSKY if a star designation needs to be reported after a mouse click on it

function readdatabase290(searchmode:char): boolean;{star 290 file database search}
            {searchmode=S screen update }
            {searchmode=M mouse click  search}
            {searchmode=T text search}
  var
    i, nr_regio, nr_star,ra_raw,nr32store : integer;
    name_regio, naamst       : string;
    delta_ra,required_range,sep      : double;
    nearbyarea,header_record,in_sight: boolean;

begin
   {$I-}

  readdatabase290:=true;
  repeat
    repeat
      if  ( (file_open=0) or  {check file_open to prevent getting file routine get stucked}
            (nr_records<=0) or {here otherwise star at 0:0}
            ((searchmode<>'T') and (mag2>maxmag))
          )  then
        begin {einde}
           if file_open<>0 then closedatabase;
           nearbyarea:=false;
           naam2:=''; {clear for 5, 6 and 7 bytes records to prevent ghost names}
           Bp_Rp:=-999;{assume no colour information is available}

           required_range:= sqrt(sqr(work_width/(work_height))+1)*1.2/zoom;
           if required_range<5.95*pi/180 then required_range:=5.95*pi/180;{Longest distance to a corner or center of a tile. Worst place is ra=0, dec 18.8 degrees}

           while ((area290>1) and (nearbyarea=false)) do
           begin
             dec(area290);
             if searchmode='T' then nearbyarea:=true
             else
             begin {check if area is visible using center position tile}
               ang_sep(telescope_ra,telescope_dec,centers290[area290,1],centers290[area290,2], sep );
               if sep<required_range then  nearbyarea:=true
               else
               if sep<required_range+15*pi/180 then {center close enough to check the corners}
               begin {check if area is visible using corner position tile}
                 ang_sep(telescope_ra,telescope_dec,centers290[area290,3],centers290[area290,5], sep );
                 if sep<required_range then  nearbyarea:=true
                 else
                 begin {check if area is visible using corner position tile}
                   ang_sep(telescope_ra,telescope_dec,centers290[area290,4],centers290[area290,5], sep );
                   if sep<required_range then  nearbyarea:=true
                   else
                   begin  {check if area is visible using corner position tile}
                     ang_sep(telescope_ra,telescope_dec,centers290[area290,3],centers290[area290,6], sep );
                     if sep<required_range then  nearbyarea:=true
                     else
                     begin  {check if area is visible using corner position tile}
                       ang_sep(telescope_ra,telescope_dec,centers290[area290,4],centers290[area290,6], sep );
                       if sep<required_range then  nearbyarea:=true
                     end;
                   end;
                 end;
               end;
             end;
           end; {while}

           if nearbyarea=false then begin mode:=100;{go to next step} readdatabase290:=false; exit; end;


           name_star:=copy(name_star,1,3)+'_'+filenames290[area290];{tyc0101.290}
           try
             thefile_stars:=tfilestream.Create(application_Path+name_star, fmOpenRead or fmShareDenyWrite);
             Reader_stars := TReader.Create (thefile_stars, 128*1024 );{Buffer helps for small fields}
             {thefile_stars.size-reader.position>sizeof(0kyhdr) could also be used but a factor two slower !!!}
           except
              exit;
           end;
           file_open:=2; {buffer size is .. x 1024}
           reader_stars.read(database2,110); {read header info, 10x11 is 110 bytes}
           if database2[109]=' ' then
           begin
            record_size:=11; {default}
            record_type:=11; {default}
           end
           else
           begin
             record_type:=ord(database2[109]);{5,6,7,9,10 or 11 bytes record}
             record_size:=record_type and $0F;
           end;

           nr_records:= trunc((thefile_stars.size-110)/(record_size));{110 header size, correct for above read}

           mag2:=0;{temporary fix 2019-8-18. Remove in 2021 after release DR3 based database files}
        end;{einde}

      reader_stars.read(buf2,record_size);
      header_record:=false;

      case record_type of
      5: begin {record size 5}
           with p5^ do
           begin
             ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
             if ((ra_raw=$FFFFFF) and {special magnitude record is found}
                 ((mag2<150) or ((dec8-16)-mag2>=0)) ) {temporary fix 2019-8-18. Remove in 2021 after release DR3 based database files. Fix for area 205 with some faint star positions wrongly with ra=2*pi=$FFFFFF rather then $000000. Around location ra=0, dec=20 degrees}
             then  {special magnitude record is found}
             begin
               mag2:=dec8-16;{new magn shifted 16 to make sirius and other positive}
               {magnitude is stored in mag2 till new magnitude record is found}
               dec9_storage:=dec7-128;{recover dec9 shortint and put it in storage}
               header_record:=true;
             end
             else
             begin {normal record without magnitude}
               ra2:= ra_raw*(pi*2  /((256*256*256)-1));
               dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             end;
           end;
         end;{record size 5}
     6: begin {record size 6}
           with p6^ do
           begin
             ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
             if ((ra_raw=$FFFFFF) and {special magnitude record is found}
                 ((mag2<150) or ((dec8-16)-mag2>=0)) ) {temporary fix 2019-8-18. Remove in 2021. Fix for area 205 with some faint star positions wrongly with ra=2*pi=$FFFFFF rather then $000000. Around location ra=0, dec=20 degrees}
             then
             begin
               mag2:=dec8-16;{new magn shifted 16 to make sirius and other positive}
               {magnitude is stored in mag2 till new magnitude record is found}
               dec9_storage:=dec7-128;{recover dec9 shortint and put it in storage}
               header_record:=true;
             end
             else
             begin {normal record without magnitude}
               ra2:= ra_raw*(pi*2  /((256*256*256)-1));
               dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
               Bp_Rp:=b_r;{gaia (Bp-Rp)*10}
             end;
           end;
         end;{record size 6}
     9: begin {record size 9}
           with p9^ do
           begin
             ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
             if ra_raw=$FFFFFF  then  {special magnitude record is found}
             begin
               mag2:=dec8-16;{new magn shifted 16 to make sirius and other positive}
               {magnitude is stored in mag2 till new magnitude record is found}
               dec9_storage:=dec7-128;{recover dec9 shortint and put it in storage}
               header_record:=true;{not a star but a header with values for magnitude and dec9 for the next record}
             end
             else
             begin {normal record without magnitude}
               nr32store:=nr32;{store for later}
               ra2:= ra_raw*(pi*2  /((256*256*256)-1));
               dec2:=((dec9_storage shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             end;{normal record without magnitude}
           end;{with P9^}
         end; {record size 9}

     10: begin {record size 10}
           with p10^ do
           begin
             ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
             if ra_raw=$FFFFFF  then  {special magnitude record is found}
             begin
               if dec9>-20 then mag2:=dec9 else  mag2:=256+dec9;{new magn 12.8 is -12.8, 12.9 = -12.7}
              {magnitude is stored in mag2 till new magnitude record is found}
              header_record:=true;
             end
             else
             begin {normal record without magnitude}
               nr32store:=nr32;{store for later}
               ra2:= ra_raw*(pi*2  /((256*256*256)-1));
               dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             end;{normal record without magnitude}
           end;{with P10^}
         end; {record size 10}

      {following records are normally not used of for interim results}
      $A6: begin {record size 6}
           with pA6^ do
           begin
             ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
             if ra_raw=$FFFFFF  then  {special magnitude record is found}
             begin
               if dec9>-20 then mag2:=dec9 else  mag2:=256+dec9;{new magn 12.8 is -12.8, 12.9 = -12.7}
              {magnitude is stored in mag2 till new magnitude record is found}
              header_record:=true;
             end
             else
             begin {normal record without magnitude}
               ra2:= ra_raw*(pi*2  /((256*256*256)-1));
               dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             end;
           end;
         end;{record size 6}
      7: begin {record size 7}
           with p7^ do
           begin
             ra2:= (ra7 + ra8 shl 8 +ra9 shl 16)*(pi*2  /((256*256*256)-1));
             dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             if mag0>-20 then mag2:=mag0 else  mag2:=256+mag0;{new magn 12.8 is -12.8, 12.9 = -12.7}
           end;
          end;{record size 7}
      $A7: begin {record size 7, like 6 but with Gaia Bp_Rp added}
            with pA7^ do
            begin
              ra_raw:=(ra7 + ra8 shl 8 +ra9 shl 16);{always required, fasted method}
              if ra_raw=$FFFFFF  then  {special magnitude record is found}
              begin
                if dec9>-20 then mag2:=dec9 else  mag2:=256+dec9;{new magn 12.8 is -12.8, 12.9 = -12.7}
                {magnitude is stored in mag2 till new magnitude record is found}
                header_record:=true;
              end
              else
              begin {normal record without magnitude}
                ra2:= ra_raw*(pi*2  /((256*256*256)-1));
                dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
                Bp_Rp:=b_r;{gaia Bp-Rp}
              end;
            end;
         end;{record size 6}

     11: begin {record size 11}
           with p11^ do
           begin
             nr32store:=nr32;{store for later}
             ra2:= (ra7 + ra8 shl 8 +ra9 shl 16)*(pi*2  /((256*256*256)-1));
             dec2:=((dec9 shl 16)+(dec8 shl 8)+dec7)*(pi*0.5/((128*256*256)-1));// dec2:=(dec7+(dec8 shl 8)+(dec9 shl 16))*(pi*0.5/((128*256*256)-1)); {FPC compiler makes mistake, but dec7 behind}
             if mag0>-20 then mag2:=mag0 else  mag2:=256+mag0;{new magn 12.8 is -12.8, 12.9 = -12.7}
           end;{with P11^}
         end; {record size 11}
      end;{case}

      dec(nr_records); {faster then  (thefile_stars.size-thefile_stars.position<sizeofhnskyhdr) !!!)}
    until header_record=false;

    delta_ra:=abs(ra2-telescope_ra); if delta_ra>pi then delta_ra:=pi*2-delta_ra;
    if delta_ra>pi/3 then
    begin {far away in ra}
      ang_sep(telescope_ra,telescope_dec,ra2,dec2, sep );{seperation using rigorous method}
      in_sight:=sep<(1+work_width/work_height)/zoom; {star in sight?}
    end
    else
    begin {nearby in ra}
      sep:=(sqr( delta_ra*cos(dec2) ) + sqr(dec2-telescope_dec));{seperation using approximate method for shorter distances}
      in_sight:=sep<sqr((1+work_width/work_height)/zoom); {star in sight?  sqr is faster then sqrt}
    end;
  until (
   {$ifdef mswindows}
   (getinputstate=true) or{to be fixed for Linux}
   {$ELSE} {}
   {$endif}
     ((searchmode='T') or  (in_sight)) ); {text search or in_sight, skip when too far from centre screen and go to next line}
     {searchmode=S screen update}
     {searchmode=M mouse click  search}
     {searchmode=T text search}


  {name stars}
  if record_size>7 then {record contains naam/designation}
  begin
    if nr32store>0 then {ucac4 .290 style}
    begin
      {Designation: The star designation is stored in 32 bit integer named NR290. If the NR290 integer is positive, it contains an UCAC4 number. For UCAC4 the star zone is added as a multiply of $100000.  This allows $800 or 2048 zones and  $100000 or 1.048.576 stars. The UCAC4 contains maximum 286.833 stars in a zone and has 900 zones.}
      nr_regio:=(nr32store and $FFF00000) shr 20;{every 00 is 8 bits, so 5 zeros is 20 bits shift}
      nr_star:= (nr32store and $000FFFFF);  {zone is multiply of $100000, maximum nr of UCAC4 stars in a zone is 286.833 This allow 1.048.576 stars in a zone and 4096 zones using a cardinal or 2024 zones  using an integer (Tycho .290 is using negative numbers)}
      {$IFDEF fpc}
      name_regio:=inttostr2(nr_regio);{fast string routine for FPC}
      naamst:=inttostr2(nr_star+1000000); {add zeros by 1000000 and later remove 1, faster then formatfloat}
      {$ELSE} {delphi}
      str(nr_regio,name_regio);
      str(nr_star+1000000:7,naamst);{add zeros by 1000000 and later remove 1, faster then formatfloat}
      {$ENDIF}
      naam2:=name_regio+'-'+naamst[1]+naamst[2]+naamst[3]+naamst[4]+naamst[5]+naamst[6];{naamst[0]contains the "1" and skip this one}
    end
    else
    begin {tycho style}
      {In case the NR290 integer is negative, the integer contains the Tycho/GSC label. After making the integer positive, the regional star number is stored in the lowest 2 bytes, the GSC/Tycho star region (1..9537) is stored in the highest 2 bytes except that if bit $40000000 is true, the Tycho specific extension is 2, else the Tycho extension is 1. The highest bit of star number at $00008000 is used for the Tycho-2 extension 3.}
      nr_regio:=((-nr32store) and $3FFF0000) shr 16;
      nr_star:=(-nr32store) and $7FFF;
     {$IFDEF fpc}
      name_regio:=inttostr2(nr_regio);{fast string routien for FPC}
      naamst:=inttostr2(nr_star);
      {$ELSE} {delphi}
      str(nr_regio,name_regio);
      str(nr_star,naamst);
      {$ENDIF}
      naam2:=name_regio+'-'+naamst;
      if (((-nr32store) and $40008000)>0) then  {tycho extensions}
      begin
        if (((-nr32store) and $40000000)>0) then
         naam2:=naam2+'-2' {tycho-2 extension}
        else
         naam2:=naam2+'-3'; {tycho-2 extension}
      end;
    end;
  end; {record_size>7}

  type2:=''; {clear always}
  {namest=0 bright stars only}
  {namest=1 external stars only}
  {namest=2 all stars}
  if (mag2<=29) then
  IF (  ( (namest=0) and ((mag2<=03) or (dec2>pi*89/180)) ) {name only bright stars and polaris}
         or
        (namest=2) {all stars with names}
         or
        (searchmode<>'S') ) THEN   { mouse click search or text search}
  begin
    type2:=''; {clear always}
   begin
     i:=0 ;
     repeat
       if abs(ra2-Bright_star_pos[i,0])<pi*0.5/180 then
       if abs(dec2-Bright_star_pos[i,1])<pi*0.5/180 then
       begin
          type2:=Bright_star_name[i];
          i:=9999;{stop}
       end;
       inc(i);
     until i>round(-1+sizeof(bright_star_pos)/8);
   end;  {name stars}

end;{read database}
end;

begin
  p11:= @buf2[1];	{ set pointer }
  p10:= @buf2[1];	{ set pointer }
  p9:= @buf2[1];	{ set pointer }
  p7:= @buf2[1];	{ set pointer }
  pA7:= @buf2[1];	{ set pointer }
  pA6:= @buf2[1];	{ set pointer }
  p6:= @buf2[1];	{ set pointer }
  p5:= @buf2[1];	{ set pointer }
end.

