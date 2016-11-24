#!/usr/bin/perl
# JPlot : Perl/JavaScript programm to plot WIEN2K's Density of States and Bandstructure.
#
# Revision: 1.0
# Author: A. SAYEDE (adlane.sayede@univ-artois.fr)

require "../../../libs/w2web.pl";
require "../../../libs/struct.pl";
&GetInput;
&GetSession;
print "Content-type: text/html\n\n";

$numdos=0;
open(FILE, "$DIR/$CASE.int") or die "Can't open `$CASE.int': $!";
while (my $ligne = <FILE>) {
$numdos ++;
}
$numdos=$numdos-3;
close(FILE);

open(FILE, "$DIR/$CASE.struct") or die "Can't open `$CASE.struct': $!";
@line = <FILE>;
foreach $line (@line){ 
	if ($line =~ /Z:/){
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );
	push (@col3, "$lin[0]");
	}
}
close(FILE);

$nat=@col3;

opendir( $dir, $DIR) || die "can't opendir $DIR: $!";
foreach ( grep { !/^\.\.?$/ } (sort readdir $dir) )  {
    if ($_ =~ /dos/ and $_ =~ /ev/ and $_ =~ /up/){
    push (@fileup, "$_");
    }elsif ($_ =~ /dos/ and $_ =~ /ev/ and $_ =~ /dn/){
    push (@filedn, "$_");
    } elsif($_ =~ /dos/ and $_ =~ /ev/ and ($_ !=~ /dn/ or $_ !=~ /up/)) {
    push (@file, "$_");
    }
}

@ENE=();
@head=();

if($spinpol=~ /CHECKED/){

%dataup = ();
%datadn = ();

$selspin='<select style="width:auto" class="form-control" id="selspin"><option active="" value="Up">Up</option><option active="" value="Dn">Dn</option><option active="" value="UpDn">Up+Dn</option></select>';
$filene="$DIR/@fileup[0]";

foreach (@fileup){
open(FILE, "$DIR/$_") or die "Can't open `$_': $!";
@line = <FILE>;
shift @line; shift @line;
@line[0] =~ s/^\s+//;
@lin = split( /\s+/, @line[0]);
shift @lin; shift @lin; 

    foreach (@lin){
	if ($_ eq "total-DOS"){
	push(@head, "Total_DOS");
	}else{
	@li = split( /:/, $_);
	push(@head, @col3[@li[0]-1]."_".@li[1]);
	}
    }
close(FILE);
}

$k=0;
foreach (@fileup){
open(FILE, "$DIR/$_") or die "Can't open `$_': $!";
@line = <FILE>;
shift @line; shift @line; shift @line;

    foreach (@line){
        $_ =~ s/^\s+//;
	@lin = split( /\s+/, $_);
	$s=@lin;
	    for ($y=1; $y<$s; $y++){
		 push @{$dataup{$head[$y-1+$k]}}, @lin[$y];

	    }
	}

	$k=$k+7;
}

$k=0;
foreach (@filedn){
open(FILE, "$DIR/$_") or die "Can't open `$_': $!";
@line = <FILE>;
shift @line; shift @line; shift @line;

    foreach (@line){
        $_ =~ s/^\s+//;
	@lin = split( /\s+/, $_);
	$s=@lin;
	    for ($y=1; $y<$s; $y++){
#		 push @{$datadn{$head[$y-1+$k]}}, @lin[$y]*-1;
                push @{$datadn{$head[$y-1+$k]}}, @lin[$y];	    }
	}

	$k=$k+7;
}

}else{

%data = ();
$filene="$DIR/@file[0]"; 

foreach (@file){
open(FILE, "$DIR/$_") or die "Can't open `$_': $!";
@line = <FILE>;
shift @line; shift @line;
@line[0] =~ s/^\s+//;
@lin = split( /\s+/, @line[0]);
shift @lin; shift @lin; 

    foreach (@lin){
	if ($_ eq "total-DOS"){
	push(@head, "Total_DOS");
	}else{
	@li = split( /:/, $_);
	push(@head, @col3[@li[0]-1]."_".@li[1]);
	}
    }
close(FILE);
}

$k=0;
foreach (@file){
open(FILE, "$DIR/$_") or die "Can't open `$_': $!";
@line = <FILE>;
shift @line; shift @line; shift @line;

    foreach (@line){
        $_ =~ s/^\s+//;
	@lin = split( /\s+/, $_);
	$s=@lin;
	    for ($y=1; $y<$s; $y++){
		 push @{$data{$head[$y-1+$k]}}, @lin[$y];

	    }
	}

	$k=$k+7;
}

}

open(FILE, $filene) or die "Can't open `$_': $!";
@line = <FILE>;
shift @line;shift @line;shift @line;
    foreach (@line){
        $_ =~ s/^\s+//;
	@lin = split( /\s+/, $_);
	$s=@lin;
	    push(@ENE,@lin[0]);	
	$k++;
	}






print <<EOF;
<html><head>
<style type="text/css" media="all">

.bloc { display:inline-block; vertical-align:top; overflow:hidden; border:solid #4cae4c 2px; }
.bloc select { padding:10px; margin:-5px -20px -5px -5px; }
.layers button.XLS {    display: none;}
.layers:hover button.XLS {    display: block;}
table.fix-head>tbody, table {
        display:block;

}

table.fix-head>tbody {
  overflow-y: scroll;
  height: 65%;
}
#pp th{

padding-right:28px;
}
#myTable{
  width:100%;
}
  #resizable { width: 150px; height: 150px; padding: 0.5em; }
  #resizable h3 { text-align: center; margin: 0; }
  .ui-resizable-helper { border: 2px dotted #4cae4c; }
  </style>
<link rel="stylesheet" href="/exec/JPlot/bootstrap.min.css">
<link rel="stylesheet" href="/exec/JPlot/bootstrap-colorpicker.min.css">
<script type='text/javascript' src='/exec/JPlot/jquery.min.js'></script>
<link rel="stylesheet" href="/exec/JPlot/jquery-ui.css">
<script src="/exec/JPlot/jquery-ui.js"></script>
<script src="/exec/JPlot/bootstrap.min.js"></script>
<script src="/exec/JPlot/bootbox.min.js"></script>
<script src="/exec/JPlot/bootstrap-colorpicker.js"></script>
<script src="/exec/JPlot/highcharts.js"></script>
<script src="/exec/JPlot/exporting.js"></script>
<script src="/exec/JPlot/export-csv.js"></script>
<script src="/exec/JPlot/draggable-legend.js"></script>
<script src="/exec/JPlot/broken-axis.js"></script>
<script src="/exec/JPlot/StackBlur.js" type="text/javascript"></script>
<script src="/exec/JPlot/rgbcolor.js" type="text/javascript"></script>
<script src="/exec/JPlot/canvg.js" type="text/javascript"></script>
<script src="/exec/JPlot/Blob.js" type="text/javascript"></script>
<script src="/exec/JPlot/Saver.js" type="text/javascript"></script>
<link rel="stylesheet" href="/exec/JPlot/jquery-ui.css">
<script src="/exec/JPlot/jquery-ui.js"></script>
</head><body bgcolor="#F0F0F0">
 <input id="nlayer" value="" type="hidden">
 <input id="imax" value="" type="hidden">

<div class="col-lg-12" style="padding:10px; width:99%; height:99%">
<div class="row" style="padding:10px; ">
    <div class="panel panel-default" style="border-color: #E0E0E0; color: #337AB7;box-shadow: 5px 5px 3px #888888">
        <div class="panel-heading" style="border-color: #E0E0E0; color: #000; background-color: #EFE883">
	    <div class="row" >
		 <div class="col-lg-3">
		 <table ><tr >
		 <td ><h4>Density of states</h4></td><td>&nbsp</td>
		 <td >
		    <a href="#" data-toggle="tooltip" title="About JPlot">
                            <img src="images/about.png" class="sba img-responsive" alt="Cinque Terre" width="20" height="20"></a>
		</td>
		 </tr></table>
		 </div>
		 <div class="col-lg-2"></div>
<div class="col-lg-7"><div class="pull-right"> 
<table class="table" style="border:0px; margin-bottom: 0;"><tr style="border:0px">
<td style="border:0px; display:none" id="plotype">
Plot type:
<div class="btn-group">
<button id="line" class="btn btn-success">Line</button>
<button id="spline" class="btn btn-success">Spline</button>
<button id="area" class="btn btn-success">Area</button>
<button id="areaspline" class="btn btn-success">Areaspline</button>
<button id="scatter" class="btn btn-success">Scatter</button>
</div>
</td>
<td  style="border:0px;">
<div class="btn-group" id="figr"></div>
</td>
<td style="border:0px">
		    <table><tr><td style="color: #000" id="pltctrl1">Select the number of layers &nbsp </td>
		    <td id="pltctrl2"><select style="width:auto" class="form-control" id="lay">
		    <OPTION active VALUE="a">1</OPTION>
		    <OPTION VALUE="b">1X2</OPTION>
		    <OPTION VALUE="c">1X3</OPTION>
		    <OPTION VALUE="d">2X1</OPTION>
		    <OPTION VALUE="e">2X2</OPTION>
		    <OPTION VALUE="f">2X3</OPTION>
		    <OPTION VALUE="g">3X2</OPTION>
		    </select></td></tr></table>
</td><td style="border:0px"><button  id="next" type="button" class="btn btn-success">Next</button></td><td id="pltctrl3" style="border:0px;"></td></tr></table>
</div></div>
	    </div>
	</div>
	<div class="panel-body" id="mybody"  style=" height:85%;">
	    <div id="slay" style="padding: 10px; border: solid 1px #fff; height:100%; ">
	    </div>
	</div>

    </div>
</div>
</div>

<div style="display: none;" class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
	<div class="modal-content">

	    <div id ="mheader" class="modal-header" style="border-color: #E0E0E0; color: #FFF; background-color: #EFE883">		
	    </div>

	    <div class="modal-body row">
		<table class="table borderless" style="border:0px; margin-bottom: 0;"><tr>
		    <td style="border:0px"><table>	<tr><td id="td1" class="bloc"><select class="input-sm dosval" multiple style="height: 320px;" id="dosori">
EOF
foreach (@head){
print "<OPTION VALUE=\"$_\"><small>$_</small></OPTION>";
}

print <<EOF;
		    </select></td><td id="mlayer"></td></tr></table></td>
		    <td style="border:0px">

<div class="panel-body">
<!-- Nav tabs -->
<ul class="nav nav-pills">
    <li class="active"><a aria-expanded="true" href="#energie" data-toggle="tab">Energies</a>
    </li>
    <li><a aria-expanded="true" href="#dos" data-toggle="tab">DOS</a>
    </li>
    <li class=""><a aria-expanded="false" href="#font" data-toggle="tab">Font</a>
    </li>
</ul>
<!-- Tab panes -->
<div class="tab-content ">
    <div class="tab-pane fade active in" id="energie">
	<br>
	<div class="form-group input-group">
	    <span class="input-group-addon">Emin(eV)</span>
	    <input class="form-control" type="text"  id="Emin"   value="$ENE[0]">
	</div>
	<div class="form-group input-group">
	    <span class="input-group-addon">Emax(eV)</span>
	    <input class="form-control" type="text" id="Emax"   value="$ENE[-1]">
	</div>
        <div class="form-group input-group">
            <span class="input-group-addon">Break min(eV)</span>
            <input class="form-control" type="text"  id="EBmin"   value="">
        </div>
        <div class="form-group input-group">
            <span class="input-group-addon">Break max(eV)</span>
            <input class="form-control" type="text" id="EBmax"   value="">
        </div>

       <div class="form-group input-group">
            <span class="input-group-addon">Break value(eV)</span>
            <input class="form-control" type="text" id="EBval"   value="">
        </div>
    </div>
    <br>
    <div class="tab-pane fade" id="dos">
    </div>
    <div class="tab-pane fade" id="font">
	<div class="form-group input-group">
	    <span class="input-group-addon">Label Font Size</span>
	    <input class="form-control" type="text" id="fsize"  value="12">
	</div>
	<div class="form-group input-group">
	    <span class="input-group-addon">Title Font Size</span>
	    <input class="form-control" type="text" id="tsize"  value="14">
	</div>
    </div>
</div>


		    </td></tr>
		    </table>
		    <input size="2" maxlength="2" id="bgc" name="bgc" value="ffffff" type="hidden">
	    </div>
 
	    <div class="modal-footer">
		<div class="row">
		    <div class="col-lg-4">
			$selspin
		    </div>
		<div class="col-lg-4">
		</div>
    		<div class="col-lg-4">
		    <button class="btn  btn-success"  data-toggle="modal" id="plot" onclick="plot();\$('#myModal').modal('toggle')">Plot</button>
    		    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		</div>
	    </div>

	</div>
    </div>
</div>




<script>

function updateColor(series){
    if(series == undefined) return;
    var color = series.color == '#ffffff' ? '#851E20' : '#ffffff';
    var sibling = \$('#container_1').highcharts().series[series.index];
    series.update({color:color});
    sibling.update({color:color});
}

function plot(){

\$('#resz').css('border', 'solid 1px #5CB85C'); 
lntpp="solid";
lw=0.5;
Emin=parseFloat(document.getElementById('Emin').value) ;
Emax=parseFloat(document.getElementById('Emax').value) ;
if (!isNumeric(Emin)){Emin=null}
if (!isNumeric(Emax)){Emax=null}
EBmin=parseFloat(document.getElementById('EBmin').value) ;
EBmax=parseFloat(document.getElementById('EBmax').value) ;
EBval=parseFloat(document.getElementById('EBval').value) ;
/*if (isNumeric(EBmin) & isNumeric(EBmax) & isNumeric(EBval)){
brk='[{from: '+EBmin+',to: '+EBmax+',breakSize: '+EBval+',}]'
}else{brk=""}*/
fsize = parseInt(document.getElementById('fsize').value);
tsize = parseInt(document.getElementById('tsize').value);
W = \$("#layer1").width();
H = \$("#layer1").height();

imax = \$('#imax').val();
for(o=1; o <= imax; o++){

minb=parseFloat(document.getElementById('minb'+o+'').value) ;
maxb=parseFloat(document.getElementById('maxb'+o+'').value) ;
bval=parseFloat(document.getElementById('bval'+o+'').value) ;

Highcharts.wrap(Highcharts.Axis.prototype, 'getLinePath', function (proceed, lineWidth) {
        var axis = this,
            path = proceed.call(this, lineWidth),
            x = path[1],
            y = path[2];

        Highcharts.each(this.breakArray || [], function (brk) {
            if (axis.horiz) {
                x = axis.toPixels(brk.from);
                path.splice(3, 0,
                    'L', x - 4, y, // stop
                    'M', x - 9, y + 5, 'L', x + 1, y - 5, // left slanted line
                    'M', x - 1, y + 5, 'L', x + 9, y - 5, // higher slanted line
                    'M', x + 4, y
                );
            } else {
                y = axis.toPixels(brk.from);
                path.splice(3, 0,
                    'L', x, y - 4, // stop
                    'M', x + 5, y - 9, 'L', x - 5, y + 1, // lower slanted line
                    'M', x + 5, y - 1, 'L', x - 5, y + 9, // higher slanted line
                    'M', x, y + 4
                );
            }
        });
        return path;
    });

 Highcharts.setOptions({
        chart: {    
	    type: "line",
	    width: W,
	    height: H,
            zoomType: 'xy',
            panning: true,
            panKey: 'shift',
            marginRight: 10,
            marginBottom: 50,
            plotBorderColor: 'black',
            plotBorderWidth: 1,
            backgroundColor: null,
	    events: {
                    click: function(){
                    //updateColor(this);
                    },
	    }
            },
      plotOptions: {
            series: {
                marker: {
                    enabled: false
                },
                states: {
                    hover: {
                        enabled: true,
                        lineWidth: 3

                    }
                },
                    events: {
                        click: function(event) {
                                myserie=this
                                if(myserie.name.includes("Tot")){
                                Name=myserie.name.replace(/ /g,"_")
                                }else{
                                Name=myserie.name.replace(/ /g,"__")
                                }
			        eval('lw=\$("#lw'+Name+'").text()')
    				eval('style=\$("#style'+Name+'").text()')

                                 bootbox.dialog({
                                     title: ''+myserie.name+'',
                                     message: '<div class="row"> ' +
    '<div class="col-md-8">'+
        '<div class="input-group mycolor colorpicker-element">'+
            '<span class="input-group-addon">Color</span>'+
            '<input id="mycolor" name="mycolor" value="'+myserie.color+'" class="form-control" type="hidden">'+
            '<span class="input-group-addon"><i style="background-color: '+myserie.color+'"></i></span>'+
            '<span class="input-group-addon">Line type</span>'+
            '<select class="form-control" id="myln" name="myln">'+
                '<option selected="">'+style+'</option>'+
                '<option>Solid</option>'+
                                '<option>ShortDash</option>'+
                                '<option>ShortDot</option>'+
                                '<option>ShortDashDot</option>'+
                                '<option>ShortDashDotDot</option>'+
                '<option>Dot</option>'+
                '<option>Dash</option>'+
                '<option>LongDash</option>'+
                '<option>DashDot</option>'+
                '<option>LongDashDot</option>'+
                '<option>LongDashDotDot</option>'+
    '</select>'+
        '</div>'+
    '</div>'+
    '<div class="col-md-4">'+
        '<div class="input-group colorpicker-element">'+
        '<span class="input-group-addon">Line width</span>'+
        '<input id="mylw" name="mylw" value="'+lw+'" min="0" max="2" class="form-control" step="0.1" type="number">'+
        '</div>'+
    '</div>'+
'</div>',
                                     buttons: {
                                         success: {
                                             label: "Change",
                                             className: "btn-success",
                                             callback: function () {
                                              myserie.update({color: \$('#mycolor').val(),lineWidth:\$('#mylw').val(),dashStyle:\$('#myln').val()});
                                                \$('#lw'+Name+'').val(\$('#mylw').val())
                                                \$('#style'+Name+'').val(\$('#myln').val())
                                                \$('#color'+Name+'').val(\$('#mycolor').val())

                                             }
                                         }
                                     }

                                 })
\$(function() {
    \$('.mycolor').colorpicker();
    \$('.colorpicker').css('z-index', 9999999999);
});
                               }
                              },
            }
        },
        xAxis: {
	    max:Emax,
	    min:Emin,
	    plotLines: [{
		dashStyle: 'dash',
                color: '#FF0000',
                width: 1,
                value: 0,
	        label: {
		    verticalAlign: 'top',
                    textAlign: 'center',
		    y : 10,
		    x : 10,	
		    rotation: 0,
                    style: {
                    fontSize: '14px',
                    font: 'Helvetica, Verdana, sans-serif',
                    color: '#FF0000',
                    },
                    useHTML: true,
                    text: 'E<sub>F</sub>'
                }
            }],
	    title: {
		margin: 0,
                enabled: true,
                text: 'Energy (eV)',
                style: {
                    fontSize: tsize,
                    font: 'Helvetica, Verdana, sans-serif',
                    color: '#000',
                },
            },
            gridLineWidth: 0,
            lineColor: '#000',
            tickColor: '#000',
	    tickLength: 10,
	    tickWidth: 1,
            minorGridLineWidth: 0,
            minorTickInterval: 'auto',
            minorTickLength: 5,
            minorTickWidth: 1,
            minorTickColor : '#000',
            labels: {
                style: {
                    fontSize: fsize,
                    font: 'Helvetica, Verdana, sans-serif',
                    color: '#000',
                },
            },
	    breaks:[{
        	    from: EBmin,
        	    to: EBmax,
        	    breakSize: EBval 
    		  }],
        },
        yAxis: {
            breaks:[{
                    from: minb,
                    to:   maxb,
                    breakSize: bval
                  }],
	    plotLines: [{
                color: '#000',
                width: 1,
                value: 0
            }],
	    title: {
                enabled: true,
                text: 'DOS (States/eV)',
                style: {
                    fontSize: tsize,
                    font: 'Helvetica, Verdana, sans-serif',
                    color: '#000',
                },
            },
            gridLineWidth: 0,
            lineColor: '#000',
            tickColor: '#000',
	    tickLength: 10,
	    tickWidth: 1,
	    minorGridLineWidth: 0,
            minorTickInterval: 'auto',
            minorTickLength: 5,
            minorTickWidth: 1,
            minorTickColor : '#000',			
            labels: {
                style: {
                    fontSize: fsize,
                    font: 'Helvetica, Verdana, sans-serif',
                    color: '#000',
                },
            },
        },
        title: {
            text: '',
            floating: true,
                align: 'center',
                    x: 0,
    	    verticalAlign: 'top',
                    y: 20,
            style: {
                     color: '#ffffff',
                    font: '16px Helvetica, Verdana, sans-serif',
                    fontWeight: 'bold'
                    }
        },
    tooltip:{
           headerFormat: '<b>{series.name}</b><br/>',
            pointFormat: '{point.y}'
            },
      credits: {
                enabled: false,
                text: '',
                href: ''
		},
       legend: {
            enabled: true,
            backgroundColor: 'white',
	    itemHoverStyle: {
            color: '#DADADA'
            },
            align: 'right',
            verticalAlign: 'top',
            layout: 'vertical',
            x :-80,
            y :20,
            floating : true,
            borderColor: '#000000',
            borderWidth: 1,
            borderRadius: 5,
            symbolWidth: 30,
	    //shadow: true,
            draggable: true,
            zIndex: 20,
            useHTML:true
        },   
navigation: {
                buttonOptions: {
                                enabled: false
                                }
               },
})

;

dodata(o)

\$('#container_'+o+'').highcharts({series: data,})
var chart=\$('#container_'+o+'').highcharts()

nlayer = \$('#nlayer').val()
if (nlayer=="b" && o==2) {chart.yAxis[0].setTitle({text:''});}
if (nlayer=="c" && o==2) {chart.yAxis[0].setTitle({text:''});}
if (nlayer=="c" && o==3) {chart.yAxis[0].setTitle({text:''});}
if (nlayer=="d" && o==1) {chart.xAxis[0].setTitle({text:''})}
if (nlayer=="d" && o==2) {chart.xAxis[0].setTitle({text:'Energy (eV)'})}
if (nlayer=="e" && o==1) {chart.xAxis[0].setTitle({text:''})}
if (nlayer=="e" && o==2) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="e" && o==3) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:'DOS'})}
if (nlayer=="e" && o==4) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="f" && o==1) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:'DOS'})}
if (nlayer=="f" && o==2) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="f" && o==3) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="f" && o==4) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:'DOS'})}
if (nlayer=="f" && o==5) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="f" && o==6) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="g" && o==1) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:'DOS'})}
if (nlayer=="g" && o==2) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="g" && o==3) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:'DOS'})}
if (nlayer=="g" && o==4) {chart.xAxis[0].setTitle({text:''}); chart.yAxis[0].setTitle({text:''})}
if (nlayer=="g" && o==5) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:'DOS'})}
if (nlayer=="g" && o==6) {chart.xAxis[0].setTitle({text:'Energy (eV)'}); chart.yAxis[0].setTitle({text:''})}


DOSmin=parseFloat(document.getElementById('dosmin'+o+'').value) ;
DOSmax=parseFloat(document.getElementById('dosmax'+o+'').value) ;

if (isNaN(DOSmin) & isNaN(DOSmax)){
        if(\$('#selspin').val()=="UpDn"){chart.yAxis[0].setExtremes(null,null);}else{chart.yAxis[0].setExtremes(0,null)}
}

if (isNaN(DOSmin) & isNumeric(DOSmax)){
        if(\$('#selspin').val()=="UpDn"){chart.yAxis[0].setExtremes(null,DOSmax);}else{chart.yAxis[0].setExtremes(0,DOSmax)}
}

if (isNumeric(DOSmin) & isNaN(DOSmax)){
        if(\$('#selspin').val()=="UpDn"){chart.yAxis[0].setExtremes(DOSmin,null)}else{chart.yAxis[0].setExtremes(DOSmin,null)}
}

if (isNumeric(DOSmin) & isNumeric(DOSmax)){
        chart.yAxis[0].setExtremes(DOSmin, DOSmax);
}


}

fig()

}

function fig(){
lay = \$('#lay').val();
if (lay=="a"){x=1; y=1}
if (lay=="b"){x=1; y=2}
if (lay=="c"){x=1; y=3}
if (lay=="d"){x=2; y=1}
if (lay=="e"){x=2; y=2}
if (lay=="f"){x=2; y=3}
if (lay=="g"){x=3; y=2}

\$("#figr").empty()
\$('<dif id="figrr">Save as: </div>').appendTo(figr)
\$('<button class="btn btn-success">SVG</button>').appendTo(figrr).click(function (e) {
var ii=1;  t = 0;
var svgArr = [];
for(r = 0; r < x; r++){
    l=0;
    for (c = 0; c < y; c++){
       var chart=\$('#container_'+ii+'').highcharts()
        var svg = chart.getSVG({chart:{width:chart.chartWidth, height:chart.chartHeight}});
        svg = svg.replace('<svg', '<g transform="translate(' + l + ',' + t + ')"');
        svg = svg.replace('</svg>', '</g>');
        l += chart.chartWidth;
        h = chart.chartHeight; //Math.max(height, chart.chartHeight);
        svgArr.push(svg);
        ii++;
    }
    t += h;
}
svg= '<svg height="'+ t +'" width="' + l + '" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>';
saveAs(new Blob([svg], {type:"application/svg+xml"}), "dos.svg")
})

\$('<button class="btn btn-success">PNG</button>').appendTo(figrr).click(function (e) {
var ii=1;  t = 0;
var svgArr = [];
for(r = 0; r < x; r++){
    l=0;
    for (c = 0; c < y; c++){
       var chart=\$('#container_'+ii+'').highcharts()
        var svg = chart.getSVG({chart:{width:chart.chartWidth, height:chart.chartHeight}});
        svg = svg.replace('<svg', '<g transform="translate(' + l + ',' + t + ')"');
        svg = svg.replace('</svg>', '</g>');
        l += chart.chartWidth;
        h = chart.chartHeight; //Math.max(height, chart.chartHeight);
        svgArr.push(svg);
        ii++;
    }
    t += h;
}
svg= '<svg height="'+ t +'" width="' + l + '" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>';
//qual=parseFloat($( "#quality" ).val())
qual=2;
width = l*qual
height = t*qual
canvas = document.createElement("canvas");
canvas.width=width;
canvas.height= height;
canvg(canvas, svg, {ignoreDimensions: true, scaleWidth: canvas.width, scaleHeight: canvas.height});
var isChrome = window.chrome;
if(isChrome) {
dospng = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
saveAs(dospng, "dos.png");
}else{
canvas.toBlob(function(blob) {
saveAs(blob, "dos.png", 'image/png');
});
}
})

var ii=1;  t = 0;
for(r = 0; r < x; r++){
    for (c = 0; c < y; c++){
        var chart=\$('#container_'+ii+'').highcharts()
        xls = chart.getTable(true)
        xls = xls.replace('Category', 'Energy');
        xls = xls.replace('<table>', '<table class="table fix-head  table-striped">');
	\$('<button id=\"XLS'+ii+'\" type="button" class="btn btn-xs btn-success XLS" style="position:absolute;top:2;left:2">DATA</button>').appendTo('#layer'+ii+'').click(function (e) {
	\$('#modal_'+this.id+'').modal('toggle'); 	
	})
        \$('<div style="display: none;" class="modal fade" id=\"modal_XLS'+ii+'\" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">'+
  '<div class="modal-dialog">'+
		'<div class="modal-content">'+
			'<div id="mheader" class="modal-header" style="border-color: #4cae4c; color: #FFF; background-color: #5cb85c">Plot '+ii+' <button type="button" class="close" data-dismiss="modal">&times;</button></div>'+
			'<div class="modal-body">'+xls+'</div>'+
   '</div>'+
  '</div>'+
'</div>').appendTo(document.body)
	ii++;
    }
}



}

function dodata(nlay) {

spin = \$('#selspin').val(); 
if (spin=="Up"){inv=1}
if (spin=="Dn"){inv=1}
if (spin=="UpDn"){inv=-1}

var h = new Object()
EOF
$s=@head;
$ss=@ENE;

if($spinpol=~ /CHECKED/){

for ($m=0; $m<$s; $m++){
    $k=0;
    print "h['@head[$m]_up']=[";
    foreach(@ENE){
    print "[@ENE[$k],@{$dataup{@head[$m]}}[$k]],";
    $k++;
    }
    print "]\n";
print <<EOF;
EOF
}

for ($m=0; $m<$s; $m++){
    $k=0;
    print "h['@head[$m]_dn']=[";
    foreach(@ENE){
    print "[@ENE[$k],@{$datadn{@head[$m]}}[$k]*inv],";
    $k++;
    }
    print "]\n";
print <<EOF;
EOF
}

}else{

for ($m=0; $m<$s; $m++){
    $k=0;
    print "h['@head[$m]']=[";
    foreach(@ENE){
    print "[@ENE[$k],@{$data{@head[$m]}}[$k]],";
    $k++;
    }
    print "]\n";
print <<EOF;
EOF
}

}


print <<EOF;

x=document.getElementById('dos2'+nlay+'');
data = new Array()
for(i=0; i < x.options.length; i++){
      doslabel = x.options[i].value;
      if (doslabel.substring(0, 4) == 'Plot') continue;
      if (doslabel.length == 0) continue;

      eval('color=\$("#clr'+doslabel+'").text()')
      eval('style=\$("#style'+doslabel+'").text()')

      if (\$('#selspin').length) {	
        
	spin = \$('#selspin').val(); 
	    if (spin=="Up"){
            eval('data.push({name: "'+doslabel+'", data: h[doslabel+"_up"],color:"'+color+'",dashStyle:"'+style+'"})');
	    }
	    if (spin=="Dn"){
	    eval('data.push({name: "'+doslabel+'", data: h[doslabel+"_dn"],color:"'+color+'",dashStyle:"'+style+'"})');
	    }
	    if (spin=="UpDn"){
            eval('data.push({name: "'+doslabel+'", data: h[doslabel+"_up"],color:"'+color+'",dashStyle:"'+style+'"})');
            eval('data.push({data: h[doslabel+"_dn"],color:"'+color+'",dashStyle:"'+style+'",  showInLegend: false, linkedTo: ":previous"})');
	    }
      }else{
    	    eval('data.push({name: "'+doslabel+'", data: h[doslabel],color:"'+color+'",dashStyle:"'+style+'"})');

      }
}
}


function insertdos(n){
var ins = document.getElementById("dosori").value;
var option=document.createElement("option");
var x=document.getElementById('dos2'+n+'');
var y=document.getElementById("dosori");

option.text=ins;
try
  {
   x.add(option,x.options[null]);
   }
   catch (e)
   {
   x.add(option,null);
   }

y.remove(y.selectedIndex);
colors = ['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'];
if ((x.length-1)>7){ord=Math.round((x.length-1)/7)}else{ord=x.length-1}
eval('color=colors['+ord+']')
\$('<p id=\"clr'+ins+'\" style="display:none">'+color+'</p><p id=\"style'+ins+'\" style="display:none">solid</p><p id=\"lw'+ins+'\" style="display:none">1</p>').appendTo('#layer'+n+'')

}

function rinsertdos(n){
var ins = document.getElementById('dos2'+n+'').value;
var option=document.createElement("option");
var x=document.getElementById('dos2'+n+'');
var y=document.getElementById("dosori");
if (ins.substring(0, 4) == 'Plot'){
abort();
}


option.text=ins;
try
  {
   y.add(option,y.options[null]);
   }
   catch (e)
   {
   y.add(option,null);
   }

x.remove(x.selectedIndex);

\$('#clr'+ins+'\').remove()
\$('#style'+ins+'\').remove()
\$('#lw'+ins+'\').remove()

}



\$(document).ready(function () {

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

\$('.dosval').click(function () {
    \$(this).find('option').css('background-color', 'transparent');
    \$(this).find('option:selected').css('background-color', '#5CB85C');
}).trigger('change');


    \$.each(['line', 'column', 'spline', 'area', 'areaspline', 'scatter', 'pie'], function (i, type) {
        \$('#' + type).click(function () {
	    imax = \$('#imax').val();
	    for(o=1; o <= imax; o++){
	    var chart=\$('#container_'+o+'').highcharts()
	    for(s=0; s < chart.series.length; s++){
            chart.series[s].update({
                type: type
            })
	    }
	    };
        });
    });


nat=$nat;
label=[
EOF
foreach (@col3){
print "\'$_\',";
}
print <<EOF;
];

function dolay(){
lay = \$('#lay').val();
if (lay=="a"){x=1; y=1}
if (lay=="b"){x=1; y=2}
if (lay=="c"){x=1; y=3}
if (lay=="d"){x=2; y=1}
if (lay=="e"){x=2; y=2}
if (lay=="f"){x=2; y=3}
if (lay=="g"){x=3; y=2}
var table = \$('<div id="resz" class="row"  style=" border: 0.5px solid #5CB85C; width:100%; height:100%; position: relative; ">');
var i=1;
var yy=12/y;
var xx=100/x
for(var r = 0; r < x; r++){
    for (var c = 0; c < y; c++){
        \$('<div id= "layer'+i+'" class="layers col-lg-'+yy+'" style="position: relative; border: 0.5px solid #5CB85C; text-align: center; color: #5CB85C;  height:'+xx+'%"><h1>Plot '+i+' </h1></div>').appendTo(table) 
        i++;
 	}
}
\$('#slay').append(table);

 \$('#resz').resizable({
    containment: ".panel-body",
    stop: function () {
         imax = \$('#imax').val();
    for(o=1; o <= imax; o++){
        var chart=\$('#container_'+o+'').highcharts()
        we = \$('#layer'+o+'').width();
        he = \$('#layer'+o+'').height();
        chart.setSize(we, he)
     }
fig()   
}

   });


}
dolay();

\$("#lay").click(function(){
\$('#slay').empty()
dolay();
})


\$("#next").click(function(){
lay = \$('#lay').val();

if (lay=="a"){imax=1}
if (lay=="b"){imax=2}
if (lay=="c"){imax=3}
if (lay=="d"){imax=2}
if (lay=="e"){imax=4}
if (lay=="f"){imax=6}
if (lay=="g"){imax=6}

\$('#nlayer').val(lay)
\$('#imax').val(imax)

\$('#plotype').show()

\$('#pltctrl1').hide()
\$('#pltctrl2').hide()
\$('<button  id="ctrl" type="button" class="btn btn-success">Plot control</button>').appendTo(pltctrl3).click(function (e) {
\$('#myModal').modal('toggle');
})

\$("#next").hide()
\$('#myModal').modal('toggle');
\$('#mlayer').empty()
var layer= \$('<select style="width:auto" class="form-control" id="seltlay" onclick="setlay()">');
for(var i = 1; i <=imax ; i++){
\$('#layer'+i+'').empty();
\$('#layer'+i+'').append('<div id="container_'+i+'" class="clickme"></div>');
\$('#layer'+i+'').css('border','0px');
var add=\$('<OPTION VALUE="'+i+'">Plot '+i+'</OPTION>');
add.appendTo(layer);

\$('#container_'+i+'').bind("plotclick", function (event, pos, item) {
if (item) {
            alert(''+item.series.label+'');
        }
});


}

add=\$('</select>');
add.appendTo(layer);
layer.appendTo(mheader);

for(var i = 1; i <=imax ; i++){
\$('#mlayer').append('<div class="tlay" id="tlayer'+i+'" style="display:none; border: 0px solid #337AB7"></div>');
\$('#tlayer'+i+'').append('<table><tr><td id="td2'+i+'"></td><td id="td3'+i+'" class="bloc"></td></tr></table>');
\$('#td2'+i+'').append('<div class="btn-group" style="padding:5px;"><table><tr><td><button type="button" class="btn-xs btn-success" onclick="insertdos('+i+')"><font size="3">&#8594;</font></button></td></tr><tr><td><button type="button" class="btn-xs btn-danger" onclick="rinsertdos('+i+')"><font size="3">&#8592;</font></button></td></tr></table></div>')
\$('#td3'+i+'').append('<select  multiple class="input-sm dosval" style="height: 320px;" id="dos2'+i+'" size="10"><option style="color: #000; background-color:#EFE883 " >Plot '+i+'</option></select>')


\$('#dos').append('<div class="form-group input-group tlay" style="display:none" id="dosvarmin'+i+'"><span class="input-group-addon">Min '+i+'</span><input class="form-control" id="dosmin'+i+'" value="" type="text"></div><div class="form-group input-group tlay" style="display:none"  id="dosvarmax'+i+'"><span class="input-group-addon">Max '+i+'</span><input class="form-control" id="dosmax'+i+'" value="" type="text"></div>')

\$('#dos').append('<div id="bmin'+i+'" class="form-group input-group tlay" style="display:none"><span class="input-group-addon">Break min '+i+'</span><input class="form-control" id="minb'+i+'" value="" type="text"></div><div id="bmax'+i+'"  class="form-group input-group tlay" style="display:none"><span class="input-group-addon">Break max '+i+'</span><input class="form-control" id="maxb'+i+'" value="" type="text"></div><div id="b'+i+'"  class="form-group input-group tlay" style="display:none"><span class="input-group-addon">Break value</span><input class="form-control" id="bval'+i+'" value="" type="text"></div>')


}
\$('#tlayer1').show();
\$('#dosvarmin1').show();
\$('#dosvarmax1').show();
\$('#bmin1').show();
\$('#bmax1').show();
\$('#b1').show();
})
})
function setlay(){
seltlay = \$('#seltlay').val();
\$('.tlay').hide();
\$('#tlayer'+seltlay+'').show();
\$('#dosvarmin'+seltlay+'').show();
\$('#dosvarmax'+seltlay+'').show();
\$('#bmin'+seltlay+'').show();
\$('#bmax'+seltlay+'').show();
\$('#b'+seltlay+'').show();
}


function isNumeric(num) {
  return !isNaN(parseFloat(num)) && isFinite(num);
}

</script>
</body></html>\n
EOF




