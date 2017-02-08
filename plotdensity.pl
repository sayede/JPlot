#!/usr/bin/perl
# JPlot : Perl/JavaScript programm to plot WIEN2K's Density of States and Bandstructure.
#
# Revision: 1.0
# Author: A. SAYEDE (adlane.sayede@univ-artois.fr)

$error = 0;
$CASE="TiC";
require "../../../libs/w2web.pl";
require "../../../libs/struct.pl";
&GetInput;
&GetSession;
$error = 0;

#`../../../../reformat <$DIR/$CASE.rho> $DIR/.tmp.rho3D`;

print "Content-type: text/html\n\n";
print <<EOF;
<html><head>
<meta charset="utf-8"/>
<link rel="stylesheet" href="/exec/JPlot/bootstrap.min.css">
<link rel="stylesheet" href="/exec/JPlot/font-awesome.min.css">
<link rel="stylesheet" href="/exec/JPlot/bootstrap-colorpicker.min.css">
<link rel="stylesheet" href="/exec/JPlot/bootstrap-toggle.min.css">
<script type='text/javascript' src='/exec/JPlot/jquery.min.js'></script>
<script src="/exec/JPlot/bootstrap-toggle.min.js"></script>
<script src="/exec/JPlot/bootstrap.min.js"></script>
<script src="/exec/JPlot/bootbox.min.js"></script>
<script src="/exec/JPlot/plotly-latest.min.js"></script>
<script src="/exec/JPlot/StackBlur.js" type="text/javascript"></script>
<script src="/exec/JPlot/rgbcolor.js" type="text/javascript"></script>
<script src="/exec/JPlot/canvg.js" type="text/javascript"></script>
<script src="/exec/JPlot/Blob.js" type="text/javascript"></script>
<script src="/exec/JPlot/Saver.js" type="text/javascript"></script>
<script src="/exec/JPlot/bootstrap-colorpicker.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="/exec/JPlot/jquery-ui.css">
<script src="/exec/JPlot/jquery-ui.js"></script>
  <style>
  .toggle.android { border-radius: 0px;}
  .toggle.android .toggle-handle { border-radius: 0px; }
 .bootbox-alert div div div button.btn-primary{
    color: #fff;
    background-color: #d9534f;
    border-color: #d9534f;     
    }
.ui-resizable-helper { border: 2px dotted #4cae4c; }
#fountainG{
    position:relative;
    width:234px;
    height:28px;
    margin:auto;
}
.borderless tbody tr td, .borderless tbody tr th, .borderless thead tr th {
border: none;
}
  </style>
</head><body bgcolor="#F0F0F0">
<body bgcolor="#F0F0F0">
   <div class="row" style="padding:10px;height:90%; width:99%">
      <div class="col-lg-9" style="height:100%">
         <div class="panel panel-default" style="border-color: #E0E0E0; color: #000; box-shadow: 5px 5px 3px #888888">
            <div class="panel-heading" style="border-color: #E0E0E0; color: #000; background-color: #EFE883">
               <div class="row">
                  <div class="col-lg-4">
                     <table>
                        <tbody>
                           <tr>
<td>
	    <a href="#" data-toggle="tooltip" title="About JPlot">
        <img style="opacity: 1;" src="images/JPlot.png" class="sba img-responsive" alt="Cinque Terre" width="50"></a>
</td>
                              <td>
                                 <h4>Electron density plots </h4>
                              </td>
                              <td>&nbsp;</td>
                              <td>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
                  <div class="col-lg-2">
                  </div>
                  <div class="col-lg-3">
                  </div>
                  <div class="col-lg-3">
                     <div class="pull-right">
                        Save as : 
                        <span id="png"></span> 
                        <span id="svg"></span>
                     </div>
                  </div>
               </div>
            </div>
            <div class="panel-body" style="height:100%">
               <div id="resz" style="border: 1px solid rgb(92, 184, 92); width: 100%; height: 100%; position: relative;">
                  <div id="container" class="tab-pane fade active in" style="display:;" data-highcharts-chart="0"></div>
               </div>
	    </div>
	</div>
      </div>
      <div id="plotctrl" class="col-lg-3" style="display:; ">
         <div class="panel panel-default" style="border-color: #E0E0E0; box-shadow: 5px 5px 3px #888888">
            <div class="panel-heading" style="border-color: #E0E0E0; color: #000; background-color: #EFE883">Plot control</div>
            <div class="panel-body">
               <div class="tab-content">
                  <div class="tab-pane fade active in" id="energie">
			
		    <div class="input-group colorpicker-element">
		        <span class="input-group-addon">Plot type</span>
			<input  id="pltype" checked data-toggle="toggle" data-on="3D" data-off="2D" data-onstyle="success" data-style="android" data-offstyle="warning"  type="checkbox">
		    </div>                     

			<br>

		<div class="input-group colorpicker-element">
	        <span class="input-group-addon">&#961;<sub>min</sub></span>
		<input  id="zmin" class="form-control" type="number" step="0.01">
	        </div>
			<br>

		<div class="input-group colorpicker-element">
	        <span class="input-group-addon">&#961;<sub>max</sub></span>
		<input  id="zmax" class="form-control" type="number" step="0.01">
	        </div>

			<br>

		<div class="input-group colorpicker-element">
	        <span class="input-group-addon">&Delta;&#961</span>
		<input  id="cdelta" class="form-control" type="number" value=""  step="1">
	        </div>

<script>
 \$(function() {

    var typingTimer;                
    var doneTypingInterval = 10000;

/*
    \$('#zmin').keyup(function(){
	clearTimeout(typingTimer);
	    if (\$('#zmin').val()) {
    		typingTimer = setTimeout(doneTyping (), doneTypingInterval);
		}
    }); 
    \$('#zmax').keyup(function(){
	clearTimeout(typingTimer);
	    if (\$('#zmax').val()) {
    		typingTimer = setTimeout(doneTyping (), doneTypingInterval);
		}
    }); 

    function doneTyping () {
    \$('#cdelta').val('')
    doplot()
    }
*/

    \$('#pltype').change(function() {
	if(\$(this).prop('checked')==false){
	\$('#surfdiv').hide()
	\$('#cont').show()
	}else{
	\$('#surfdiv').show()
	\$('#cont').hide()
	}
    doplot();	
    })
  })
</script>

<br>

<table><tr>
<td>
  <div class="dropdown" style="border-top-right-radius:0; border-bottom-right-radius:0">
    <button class="btn btn-default dropdown-toggle" type="button" id="menu1" data-toggle="dropdown"  style="border-top-right-radius:0; border-bottom-right-radius:0">Colorscale<span class="caret"></span></button>
    <ul class="dropdown-menu" role="menu" aria-labelledby="menuclr" id="menuclr">	
    </ul>
  </div>
</div>
</td><td>
<script>			
colorarray= {
    Greys: [
        [0, "rgb(0,0,0)"],
        [.125, "rgb(30,30,30)"],
        [.25, "rgb(67,67,67)"],
        [.375, "rgb(114,114,114)"],
        [.5, "rgb(178,178,178)"],
        [.625, "rgb(214,214,214)"],
        [.75, "rgb(240,240,240)"],
        [.875, "rgb(250,250,250)"],
        [1, "rgb(255,255,255)"]
    ],
    YlGnBu: [
        [0, "rgb(8,29,88)"],
        [.125, "rgb(37,52,148)"],
        [.25, "rgb(34,94,168)"],
        [.375, "rgb(29,145,192)"],
        [.5, "rgb(65,182,196)"],
        [.625, "rgb(127,205,187)"],
        [.75, "rgb(199,233,180)"],
        [.875, "rgb(237,248,217)"],
        [1, "rgb(255,255,217)"]
    ],
    Greens: [
        [0, "rgb(0,68,27)"],
        [.125, "rgb(0,109,44)"],
        [.25, "rgb(35,139,69)"],
        [.375, "rgb(65,171,93)"],
        [.5, "rgb(116,196,118)"],
        [.625, "rgb(161,217,155)"],
        [.75, "rgb(199,233,192)"],
        [.875, "rgb(229,245,224)"],
        [1, "rgb(247,252,245)"]
    ],
    YlOrRd: [
        [0, "rgb(128,0,38)"],
        [.125, "rgb(189,0,38)"],
        [.25, "rgb(227,26,28)"],
        [.375, "rgb(252,78,42)"],
        [.5, "rgb(253,141,60)"],
        [.625, "rgb(254,178,76)"],
        [.75, "rgb(254,217,118)"],
        [.875, "rgb(255,237,160)"],
        [1, "rgb(255,255,204)"]
    ],
    Bluered: [
        [0, "rgb(0,0,255)"],
        [1, "rgb(255,0,0)"]
    ],
    RdBu: [
        [0, "rgb(5,10,172)"],
        [.35, "rgb(106,137,247)"],
        [.5, "rgb(190,190,190)"],
        [.6, "rgb(220,170,132)"],
        [.7, "rgb(230,145,90)"],
        [1, "rgb(178,10,28)"]
    ],
    Reds: [
        [0, "rgb(220,220,220)"],
        [.2, "rgb(245,195,157)"],
        [.4, "rgb(245,160,105)"],
        [1, "rgb(178,10,28)"]
    ],
    Blues: [
        [0, "rgb(5,10,172)"],
        [.35, "rgb(40,60,190)"],
        [.5, "rgb(70,100,245)"],
        [.6, "rgb(90,120,245)"],
        [.7, "rgb(106,137,247)"],
        [1, "rgb(220,220,220)"]
    ],
    Picnic: [
        [0, "rgb(0,0,255)"],
        [.1, "rgb(51,153,255)"],
        [.2, "rgb(102,204,255)"],
        [.3, "rgb(153,204,255)"],
        [.4, "rgb(204,204,255)"],
        [.5, "rgb(255,255,255)"],
        [.6, "rgb(255,204,255)"],
        [.7, "rgb(255,153,255)"],
        [.8, "rgb(255,102,204)"],
        [.9, "rgb(255,102,102)"],
        [1, "rgb(255,0,0)"]
    ],
    Rainbow: [
        [0, "rgb(150,0,90)"],
        [.125, "rgb(0,0,200)"],
        [.25, "rgb(0,25,255)"],
        [.375, "rgb(0,152,255)"],
        [.5, "rgb(44,255,150)"],
        [.625, "rgb(151,255,0)"],
        [.75, "rgb(255,234,0)"],
        [.875, "rgb(255,111,0)"],
        [1, "rgb(255,0,0)"]
    ],
    Portland: [
        [0, "rgb(12,51,131)"],
        [.25, "rgb(10,136,186)"],
        [.5, "rgb(242,211,56)"],
        [.75, "rgb(242,143,56)"],
        [1, "rgb(217,30,30)"]
    ],
    Jet: [
        [0, "rgb(0,0,131)"],
        [.125, "rgb(0,60,170)"],
        [.375, "rgb(5,255,255)"],
        [.625, "rgb(255,255,0)"],
        [.875, "rgb(250,0,0)"],
        [1, "rgb(128,0,0)"]
    ],
    Hot: [
        [0, "rgb(0,0,0)"],
        [.3, "rgb(230,0,0)"],
        [.6, "rgb(255,210,0)"],
        [1, "rgb(255,255,255)"]
    ],
    Blackbody: [
        [0, "rgb(0,0,0)"],
        [.2, "rgb(230,0,0)"],
        [.4, "rgb(230,210,0)"],
        [.7, "rgb(255,255,255)"],
        [1, "rgb(160,200,255)"]
    ],
    Earth: [
        [0, "rgb(0,0,130)"],
        [.1, "rgb(0,180,180)"],
        [.2, "rgb(40,210,40)"],
        [.4, "rgb(230,230,50)"],
        [.6, "rgb(120,70,20)"],
        [1, "rgb(255,255,255)"]
    ],
    Electric: [
        [0, "rgb(0,0,0)"],
        [.15, "rgb(30,0,100)"],
        [.4, "rgb(120,0,100)"],
        [.6, "rgb(160,90,0)"],
        [.8, "rgb(230,200,0)"],
        [1, "rgb(255,250,220)"]
    ],
    Viridis: [
        [0, "#440154"],
        [.06274509803921569, "#48186a"],
        [.12549019607843137, "#472d7b"],
        [.18823529411764706, "#424086"],
        [.25098039215686274, "#3b528b"],
        [.3137254901960784, "#33638d"],
        [.3764705882352941, "#2c728e"],
        [.4392156862745098, "#26828e"],
        [.5019607843137255, "#21918c"],
        [.5647058823529412, "#1fa088"],
        [.6274509803921569, "#28ae80"],
        [.6901960784313725, "#3fbc73"],
        [.7529411764705882, "#5ec962"],
        [.8156862745098039, "#84d44b"],
        [.8784313725490196, "#addc30"],
        [.9411764705882353, "#d8e219"],
        [1, "#fde725"]
    ]
}

for (var key in colorarray) {
\$('#menuclr').append('<li role=\"presentation\"><a role=\"menuitem\" tabindex=\"-1\" href=\"#\" onclick=\"colorsca(\$(this).text())\">'+key+'</a><table><tr id=\"clr'+key+'\" ></tr></table></li>')	
    for (var key2 in colorarray[key]) {
    \$('#clr'+key+'').append('<td> <div style="width: 18px; height: 18px; background-color: '+colorarray[key][key2][1]+';"></div></td>')
    }
}
</script>
<input style="width:100%"  id="reversed" checked data-toggle="toggle" data-on="Normal" data-off="Reversed" data-onstyle="success" data-style="android" data-offstyle="warning"  type="checkbox">
</td>
</tr></table>
<br>


<div id="surfdiv">

<div class="row " id="surfdiv">
 <div class="col-md-5">
		    <div class="input-group colorpicker-element" style="display:">
		        <span class="input-group-addon">Surface</span>
			<input  id="surface" checked data-toggle="toggle" data-on="Displayed" data-off="Hided" data-onstyle="success" data-style="android" data-offstyle="warning"  type="checkbox">
		    </div>                     
 </div>
 <div class="col-md-4">
      <div class="input-group colorpicker-element">
        <span class="input-group-addon">Opacity</span>
	<input  id="opace" name="opace" checked data-toggle="toggle" data-on="No" data-off="Yes" data-onstyle="success" data-style="android" data-offstyle="warning"  type="checkbox">
	<input  id="opac" name="opac" type="hidden" value="1">

      </div>
 </div>     

</div>
<br>

<div class="row ">

 <div class="col-md-7">
	          <div class="input-group colorpicker-element" style="display:">
		        <span class="input-group-addon">XY Background</span>
			<input  id="xyb" checked data-toggle="toggle" data-on="Displayed" data-off="Hided" data-onstyle="success" data-style="android" data-offstyle="warning"  type="checkbox">
		    </div>   
 </div>
 <div class="col-md-2">
 
		<div class="input-group efc" id="efc" style="height:34px border-left:1px">
		<span class="input-group-addon">Color</span>
		<input id="efcc" type="hidden" value="#d4d4c3" class="form-control" />
		<span class="input-group-addon" style="background-color:rgb(238, 238, 238)" ><i></i></span>
                </div>

 </div>
</div>

</div>

<script>
function colorsca(clrsca){
		\$('#reversed').bootstrapToggle('on')
		var update = { colorscale:clrsca}
		Plotly.restyle('container', update);
		\$('#clrval').val(clrsca)
}


 \$(function() {
    \$('#reversed').change(function() {
	if(\$(this).prop('checked')==false){
	var update = { reversescale : true,}
	}else{
	var update = { reversescale : false,}
	}
	Plotly.restyle('container', update);
    })
  })

    \$(function(){
        \$('.efc').colorpicker();
    });

 \$(function() {

    \$('#surface').change(function() {
	if(\$(this).prop('checked')==false){
	var update = { hidesurface : true,}
	}else{
	var update = { hidesurface : false,}
	}
	Plotly.restyle('container', update, [0]);
    })



    \$('#opace').change(function() {
	if(\$(this).prop('checked')==false){
	\$('#opac').val(0.95);
	var update = { opacity: \$('#opac').val()}
	}else{
	\$('#opac').val(1);
	var update = { opacity: \$('#opac').val()}
	}
	Plotly.restyle('container', update, [0]);
    })



    \$('#xyb').change(function() {
	if(\$(this).prop('checked')==false){
		\$(efc).hide()
		var update = {
	        xaxis: {showbackground: false},
		yaxis: {showbackground: false},
		};
	}else{
		\$(efc).show()
		var update = {
		xaxis: {showbackground: true},
		yaxis: {showbackground: true},
		};
	}
	Plotly.relayout('container', update);
    })



  })
</script>
</div>

<div id="cont" style="display:none">
     <div class="input-group colorpicker-element">
        <span class="input-group-addon">Line width</span>
	<input  id="lnw" class="form-control" step="0.1" type="number" value="1" min="0" max="3" >
    </div>
<br>
<div class="input-group colorpicker-element">
        <span class="input-group-addon">Coloring</span>
        <select  class="form-control" id="coloring">
        	<OPTION active VALUE="fill">fill</OPTION>
        	<OPTION VALUE="heatmap">heatmap</OPTION>
                <OPTION VALUE="lines">lines</OPTION>
        </select>
        </div>

<script>
 \$(function() {
    \$('#coloring').change(function() {
        if(\$('#coloring').val()=="fill" || \$('#coloring').val()=="heatmap"){
	\$('#linec').show()
	}else{
	\$('#linec').hide()	
	}
	doplot()
    })

    \$('#lnw').change(function() {
	doplot()
    })


  })
</script>
<br>

		<div class="input-group efc" id="linec" style="height:34px">
		    <span class="input-group-addon">Line Color</span>
		<input id="linecc" type="hidden" value="#000" class="form-control" />
		<span class="input-group-addon" style="background-color:#fff" ><i></i></span>
<script>
    \$(function(){
        \$('.efc').colorpicker();
    });
</script>
</div>


                  </div>
               </div><br>
               <button type="button" class="btn btn-success" onclick="doplot()">Plot</button>
               <br><br>
            </div>
         </div>
      </div>
   </div>
<script>
function doplot(){
var myPlot = document.getElementById('container'),
clrscale=\$('#clrval').val()
W=\$('#resz').width() 
H=\$('#resz').height()
EOF
open( FILE, "$DIR/$CASE.rho") or $error = 1;
$i=0;$j=1;
print "var rho_z = [\n";
while ($line = <FILE>) {
    if ($i==0){
	$line =~ s/^\s+//;
        @head= split( /\s+/, $line);
	$k=($head[0]/5); 		
	}else{
	$line =~ s/^\s+//;
        @line= split( /\s+/, $line);		
        if ($j==1){print "[";}
	foreach (@line){ printf("\"%.6f\",", $_)}; 
	#print "<br>";
        if ($j==$k){
		print "],\n";
		$j=1;
	    }else{
		$j++;
	    }
	}
$i++
}
print "]\n";
close(FILE);

open( FILE, "$DIR/$CASE.rho") or $error = 1;
$i=0;$j=1;
print "var textz = [\n";
while ($line = <FILE>) {
    if ($i==0){
	}else{
	$line =~ s/^\s+//;
        @line= split( /\s+/, $line);		
        if ($j==1){print "[";}
	foreach (@line){ 
			printf("\"rho: %.6f\",", $_);
			$min = $_ if !$min || $_ < $min;
			$max = $_ if !$max || $_ > $max    
			}; 
	#print "<br>";
        if ($j==$k){
		print "],\n";
		$j=1;
	    }else{
		$j++;
	    }
	}
$i++
}
print "]\n";
close(FILE);


$zmin=($min-($max/3))*4;
print "var z_offset = [";
foreach ($j=0;$j<$head[1];$j++){
print "[";
    foreach ($i=0;$i<$head[0];$i++){
    print "\"$zmin\",";
    }
print "],\n";
}
print "]\n";


print "var rho_y = [";
foreach ($i=0;$i<$head[1];$i++){
print "\"$i\",";
}
print "]\n";

print "var rho_x = [";
foreach ($i=0;$i<$head[0];$i++){
print "\"$i\",";
}
print "]\n";

$ratio=$head[0]/$head[1];

print <<EOF;
var cmin= parseFloat(\$('#zmin').val())
var cmax= parseFloat(\$('#zmax').val())

if(\$('#cdelta').val().length==0 || \$('#cdelta').val()==0){
var cdelta= (cmax-cmin)/10
\$('#cdelta').val(cdelta)
}else{
var cdelta = parseFloat(\$('#cdelta').val())
}

if(\$('#cdelta').val() > \$('#zmax').val()){
bootbox.alert("&Delta;&#961 should be lesser than &#961;<sub>max</sub>")
reterun;
}

if(\$('#cdelta').val() < 0){
bootbox.alert("&Delta;&#961 should be greater than 0")
reterun;
}



var lnw= \$('#lnw').val()
var opac=  \$('#opac').val();
ccloring = \$('#coloring').val()
xyb = \$('#xyb').prop('checked')
efcc = \$('#efcc').val()
linecc = \$('#linecc').val()

var data1 = { 
"surfacecolor": rho_z,
"z":rho_z,
"y":rho_y,
"x":rho_x,
"type": "surface",
"colorscale" : clrscale,
"text":textz,
"hoverinfo":'text',
"cmin": cmin,
"cmax": cmax,
"zmin": cmin,
"zmax": cmax,
"contours": {
        "x": {
          "show": false
        },
        "y": {
          "show": false
        },
        "z": {
          "show": false
        },
},
"opacity":opac,
}

var data2 = { 
"surfacecolor": rho_z,
"z":z_offset,
"y":rho_y,
"x":rho_x,
"type": 'surface',
"colorscale" : clrscale,
"text":textz,
"hoverinfo":'text',
"cmin": cmin,
"cmax": cmax,
}



var data3 = { 
"surfacecolor": rho_z,
"z":rho_z,
"y":rho_y,
"x":rho_x,
"type": "contour",
"autocontour": false,
"contours": {
    "start": cmin,
    "end": cmax,
    "size": cdelta,
    "coloring": ccloring,
},
"line": {
        "dash": "solid",
        "color": linecc,
        "shape": "linear",
        "width": lnw,
        smoothing: 0.85,
      },
"colorscale" : clrscale,
"text":textz,"hoverinfo":'text',
"opacity":opac,
}


if(\$('#pltype').prop('checked')==false){
data =  [data3]
var layout = {
  title: '$CASE',
  autosize: false,
   xaxis: {
    autorange: true,
    showgrid: false,
    zeroline: false,
    showline: false,
    autotick: true,
    ticks: '',
    showticklabels: false
  },
  yaxis: {
    autorange: true,
    showgrid: false,
    zeroline: false,
    showline: false,
    autotick: true,
    ticks: '',
    showticklabels: false
  },
  width: W,
  height: H,
  margin: {
    l: 65,
    r: 50,
    b: 65,
    t: 90,
  }

	}
}else{
data =  [data1,data2]
var layout = {
  title: '$CASE',
  autosize: false,
  scene: {
    xaxis: {
    title: '',
    showbackground: xyb,
    backgroundcolor: efcc,
    autorange: true,
    showgrid: false,
    zeroline: false,
    showline: false,
    autotick: true,
    ticks: '',
    showticklabels: false
  },
  yaxis: {
   title: '',
   showbackground: xyb,
   backgroundcolor: efcc,
    autorange: true,
    showgrid: false,
    zeroline: false,
    showline: false,
    autotick: true,
    ticks: '',
    showticklabels: false
  },
    zaxis: {
      title: '&rho;',
      showticklabels : true,
    }
  }, 
  width: W,
  height: H,
  margin: {
    l: 65,
    r: 50,
    b: 65,
    t: 90,
  }
};
}


Plotly.newPlot('container', data, layout, {displaylogo: false, modeBarButtonsToRemove: ['sendDataToCloud','hoverCompareCartesian','hoverClosestCartesian','hoverClosest3d','toImage']});

if(\$('#surface').prop('checked')==false){
var update = { hidesurface : true,}
Plotly.restyle('container', update, [0]);
}

if(\$('#reversed').prop('checked')==false){
var update = { reversescale : true,}
Plotly.restyle('container', update);
}


var d3 = Plotly.d3;
\$("#svg").empty()
\$('<button type="button" class="btn btn-success">SVG</button>').appendTo(svg).click(function (e) {

Plotly.plot('container', data, layout, {displaylogo: false, modeBarButtonsToRemove: ['sendDataToCloud','hoverCompareCartesian','hoverClosestCartesian','hoverClosest3d']}).then(function(gd) {
      Plotly.downloadImage(gd, {
        format: 'svg',
        filename: '$CASE_density'
      })
});
})


\$("#png").empty()
\$('<button type="button" class="btn btn-success">PNG</button>').appendTo(png).click(function (e) {

bootbox.dialog({
title: 'PNG',
size: 'small',
message: '<div class="row"> ' +
'<div class="col-md-2"></div>'+
'<div class="col-md-10">'+
'<div class="form-group input-group">'+
'<span class="input-group-addon">Image quality</span>'+
'<select id="quality" class="form-control">'+
'<option value="1" selected="">Small</option>'+
'<option value="2">Normal</option>'+
'<option value="4">Hight</option>'+
'<option value="6">Ultra</option>'+
'</select>'+

'</div></div>'+
'</div>',
buttons: {
success: {
label: "Ok",
className: "btn-success",
callback: function () {
qual=parseFloat(\$( "#quality" ).val())
h = H * qual;
w = W * qual;
Plotly.plot('container', data, layout, {displaylogo: false, modeBarButtonsToRemove: ['sendDataToCloud','hoverCompareCartesian','hoverClosestCartesian','hoverClosest3d']}).then(function(gd) {
      Plotly.downloadImage(gd, {
        format: 'png',
        height: h,
        width: w,
        filename: '$CASE_density'
      })
});


}
}
}	
})

})



}


\$(document).ready(function () {

var ratio=$ratio;
\$('#resz').width(\$('#resz').height()*ratio) 

\$(function() {
    \$( "#resz" ).resizable({ 
    containment: ".panel-body",
       handles: "s, e, se",
       stop: function( event, ui ) {
    		doplot()
               },
      });
});

\$(".sba").hover(
function() {
\$(this).fadeTo("fast",0.6);
});
\$(".sba").mouseout(
function() {
\$(this).fadeTo("fast",1.0);
});
\$(".sba").click(
function() {
bootbox.dialog({
title: 'About JPlot',
size: 'medium',
message: '<div class="row"> ' +
'<div class="col-md-12">'+
'<p>For more informations visit JPlot <a target="_blank" href="https://sayede.github.io/JPlot/">Webpage</a>.</p>'+
'<p>Bug reports and fixes, suggestions, and so on should be submitted via GitHub as <a target="_blank" href="https://github.com/sayede/JPlot/issues" aria-hidden="true">Issues</a> or <a target="_blank" href="https://github.com/sayede/JPlot/pulls" aria-hidden="true">Pull Requests</a>.</p>'+
'<p>A set of example can be found in the JPlot <a target="_blank" href="https://github.com/sayede/JPlot/wiki" aria-hidden="true">wiki</a>.</p>'+
'</div></div>'+
'</div>',
buttons: {
success: {
label: "Ok",
className: "btn-success",
}
}	
})
});


\$('#cdelta').val('')
\$('#zmin').val($min)
\$('#zmax').val($max)

doplot()

\$('#opac').change(function() {
var update = { opacity: \$('#opac').val()}
Plotly.restyle('container', update, [0]);
});

if(\$('#pltype').prop('checked')==false){
\$('#surfdiv').hide()
\$('#cont').show()
}else{
\$('#surfdiv').show()
\$('#cont').hide()

}


if(\$('#coloring').val()=="fill" || \$('#coloring').val()=="heatmap"){
\$('#linec').show()
}else{
\$('#linec').hide()	
}


if(\$('#xyb').prop('checked')==false){
    \$(efc).hide()
}else{
    \$(efc).show()
}

})



</script>

<input id="clrval" type="hidden" value="RdBu">

</body>
</html>
EOF

