#!/usr/bin/perl
# JPlot : Perl/JavaScript programm to plot WIEN2K's Density of States and Bandstructure.
#
# Revision: 1.0
# Author: A. SAYEDE (adlane.sayede@univ-artois.fr)

require "../../../libs/w2web.pl";
require "../../../libs/struct.pl";
&GetInput;
&GetSession;
$error = 0;
print "Content-type: text/html\n\n";
print <<EOF;
<html><head>
<link rel="stylesheet" href="/exec/JPlot/bootstrap.min.css">
<link rel="stylesheet" href="/exec/JPlot/font-awesome.min.css">
<link rel="stylesheet" href="/exec/JPlot/bootstrap-colorpicker.min.css">
<script type='text/javascript' src='/exec/JPlot/jquery.min.js'></script>
<script src="/exec/JPlot/bootstrap.min.js"></script>
<script src="/exec/JPlot/bootbox.min.js"></script>
<script src="/exec/JPlot/highcharts.js"></script>
<script src="/exec/JPlot/exporting.js"></script>
<script src="/exec/JPlot/broken-axis.js"></script>
<script src="/exec/JPlot/StackBlur.js" type="text/javascript"></script>
<script src="/exec/JPlot/rgbcolor.js" type="text/javascript"></script>
<script src="/exec/JPlot/canvg.js" type="text/javascript"></script>
<script src="/exec/JPlot/Blob.js" type="text/javascript"></script>
<script src="/exec/JPlot/Saver.js" type="text/javascript"></script>
<script src="/exec/JPlot/bootstrap-colorpicker.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="/exec/JPlot/jquery-ui.css">
<script src="/exec/JPlot/jquery-ui.js"></script>
  <style>


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

.fountainG{
    position:absolute;
    top:0;
    background-color:rgb(239,232,131);
    width:28px;
    height:28px;
    animation-name:bounce_fountainG;
	-o-animation-name:bounce_fountainG;
	-ms-animation-name:bounce_fountainG;
	-webkit-animation-name:bounce_fountainG;
	-moz-animation-name:bounce_fountainG;
    animation-duration:1.5s;
	-o-animation-duration:1.5s;
	-ms-animation-duration:1.5s;
	-webkit-animation-duration:1.5s;
	-moz-animation-duration:1.5s;
    animation-iteration-count:infinite;
	-o-animation-iteration-count:infinite;
	-ms-animation-iteration-count:infinite;
	-webkit-animation-iteration-count:infinite;
	-moz-animation-iteration-count:infinite;
    animation-direction:normal;
	-o-animation-direction:normal;
	-ms-animation-direction:normal;
	-webkit-animation-direction:normal;
	-moz-animation-direction:normal;
    transform:scale(.3);
	-o-transform:scale(.3);
	-ms-transform:scale(.3);
	-webkit-transform:scale(.3);
	-moz-transform:scale(.3);
    border-radius:36px;
	-o-border-radius:19px;
	-ms-border-radius:19px;
	-webkit-border-radius:19px;
	-moz-border-radius:19px;
}

#fountainG_1{
    left:0;
    animation-delay:0.6s;
	-o-animation-delay:0.6s;
	-ms-animation-delay:0.6s;
	-webkit-animation-delay:0.6s;
	-moz-animation-delay:0.6s;
}

#fountainG_2{
    left:56px;
    animation-delay:0.75s;
	-o-animation-delay:0.75s;
	-ms-animation-delay:0.75s;
	-webkit-animation-delay:0.75s;
	-moz-animation-delay:0.75s;
}

#fountainG_3{
    left:113px;
    animation-delay:0.9s;
	-o-animation-delay:0.9s;
	-ms-animation-delay:0.9s;
	-webkit-animation-delay:0.9s;
	-moz-animation-delay:0.9s;
}

#fountainG_4{
    left:169px;
    animation-delay:1.05s;
	-o-animation-delay:1.05s;
	-ms-animation-delay:1.05s;
	-webkit-animation-delay:1.05s;
	-moz-animation-delay:1.05s;
}

#fountainG_5{
    left:225px;
    animation-delay:1.2s;
	-o-animation-delay:1.2s;
	-ms-animation-delay:1.2s;
	-webkit-animation-delay:1.2s;
	-moz-animation-delay:1.2s;
}

#fountainG_6{
    left:281px;
    animation-delay:1.35s;
	-o-animation-delay:1.35s;
	-ms-animation-delay:1.35s;
	-webkit-animation-delay:1.35s;
	-moz-animation-delay:1.35s;
}

#fountainG_7{
    left:338px;
    animation-delay:1.5s;
	-o-animation-delay:1.5s;
	-ms-animation-delay:1.5s;
	-webkit-animation-delay:1.5s;
	-moz-animation-delay:1.5s;
}

#fountainG_8{
    left:394px;
    animation-delay:1.64s;
	-o-animation-delay:1.64s;
	-ms-animation-delay:1.64s;
	-webkit-animation-delay:1.64s;
	-moz-animation-delay:1.64s;
}



\@keyframes bounce_fountainG{
    0%{
    transform:scale(1);
	background-color:rgb(68,157,68);
    }

    100%{
    transform:scale(.3);
	background-color:rgb(239,232,131);
    }
}

\@-o-keyframes bounce_fountainG{
    0%{
    -o-transform:scale(1);
	background-color:rgb(68,157,68);
    }

    100%{
    -o-transform:scale(.3);
	background-color:rgb(239,232,131);
    }
}

\@-ms-keyframes bounce_fountainG{
    0%{
    -ms-transform:scale(1);
	background-color:rgb(68,157,68);
    }

    100%{
    -ms-transform:scale(.3);
	background-color:rgb(239,232,131);
    }
}

\@-webkit-keyframes bounce_fountainG{
    0%{
    -webkit-transform:scale(1);
	background-color:rgb(68,157,68);
    }

    100%{
    -webkit-transform:scale(.3);
	background-color:rgb(239,232,131);
    }
}

\@-moz-keyframes bounce_fountainG{
    0%{
    -moz-transform:scale(1);
	background-color:rgb(68,157,68);
    }

    100%{
    -moz-transform:scale(.3);
	background-color:rgb(239,232,131);
    }
}
  </style>
</head><body bgcolor="#F0F0F0">
EOF

if ( $spinpol =~ /CHECKED/ ) {

    use CGI;
    $obj  = new CGI;
    $spin = $obj->param('spin');
    if ( !$spin ) {
        print <<EOF;
<script>
                                 bootbox.dialog({
                                     title: 'Plot type',
				     size: 'small',
                                     message: '<div class="row"> ' +
    '<div class="col-md-7">'+
        '<div class="input-group mycolor colorpicker-element">'+
            '<span class="input-group-addon">Spin</span>'+
            '<select class="form-control" id="spintype" name="spintype">'+
                '<option selected="" value="up">Up</option>'+
                '<option value="dn">Dn</option>'+
                                '<option value="updn">Up+Dn</option>'+
    '</select>'+
        '</div>'+
    '</div>'+
    '<div class="col-md-5">'+
    '</div>'+
'</div>',
                                     buttons: {
                                         success: {
                                             label: "Next",
                                             className: "btn-success",
					      callback: function () {
							spin=\$('#spintype').val();
							window.location.href = '/exec/JPlot/plotband.pl?SID=$SID&spin='+spin+'';
							}	
                                              }
                                         }

                                 })

</script>
</body></html>
EOF
        exit;
    }
    if ( $spin eq "updn" ) {
        &spinupdn;
    }
    else {
        &spin("$spin");
    }
}
else {
    $spin = "";
    &spin("$spin");
}
&spijplot($spin);
&rest;

sub spin {
    $spin = shift;
    print "<script> \n";
    unless ( open( FILE, "$DIR/$CASE.bands$spin.agr" ) ) {
        $error = 1;
    }
    @lines = <FILE>;
    close(FILE);
    chomp(@lines);
    print <<EOF;
function dodata_$spin() { 
lntpp="solid";
lw = parseFloat(document.getElementById("lw").value);
lclr= document.getElementById("lclr").value;
efc= document.getElementById("efcc").value;
EOF
    $i = 0;
    for $line (@lines) {
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );
        if (    @lin[0] eq "@"
            and @lin[1] eq "xaxis"
            and @lin[2] eq "ticklabel"
            and @lin[3] ne "char" )
        {
            @lin[4] =~ s/^.{1,2}//s;
            if ( @lin[4] eq "G" or @lin[4] eq "\\xG\"" ) {
                push( @label, "\\u0393" );
            }
            else {
                push( @label, @lin[4] );
            }
        }

        if (    @lin[0] eq "@"
            and @lin[1] eq "xaxis"
            and @lin[2] eq "tick"
            and @lin[3] eq "major"
            and @lin[4] ne "grid" )
        {
            push( @posi, @lin[5] );
        }

        if ( @lin[0] eq "@" and @lin[1] eq "world" ) {
            chop( @lin[4] );
            $longeur = @lin[4];
        }

        if ( @lin[1] eq "bandindex:" and @lin[2] eq "1" ) {
            $index1 = $i;
        }

        if ( @lin[1] eq "bandindex:" and @lin[2] eq "2" ) {
            $index2 = $i;
        }

        $i++;
    }
    $index = $index2 - $index1 - 5;

    print "tkP=[";
    foreach (@posi) {
        print " $_,";
    }
    print "]\n";

    print "KL=[";
    foreach (@label) {
        print " \"$_\",";
    }
    print "]\n";

    $ii = 0;
    $t  = 0;
    for $line (@lines) {
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );

        if ( @lin[1] eq "bandindex:" ) {
            if ( @lin[2] eq "1" ) {
                @emin = split( /\s+/, @lines[ 1 + $ii ] );
                $Emin = @emin[1];
            }
            print "$spin\_data_bd_$t=[";
            for ( $j = 1 ; $j < $index ; $j++ ) {
                @li = split( /\s+/, @lines[ $j + $ii ] );
                printf "[%.5f,  ", ( @li[0] ) . "  ";
                printf "%.5f],  ", ( @li[1] ) . "  ";
            }
            print "];\n";
            $t++;
        }

        $ii++;
    }
    $Emax = @li[1];
    print "data1=[";
    for ( $k = 0 ; $k < $t ; $k++ ) {
        print
"{data : $spin\_data_bd_$k, id : 'Band_$spin $k', name : 'Band_$spin $k',showInLegend: false, linkedTo: '$spin', color: ''+lclr+'', dashStyle: '+lntpp+', lineWidth: ''+lw+''},";
    }
    print "];}\n";
    print "</script> \n";
}

###
sub spinupdn {
    $spin = "updn";
    print "<script> \n";
    unless ( open( FILEUP, "$DIR/$CASE.bandsup.agr" ) ) {
        $error = 1;
    }

    unless ( open( FILEDN, "$DIR/$CASE.bandsdn.agr" ) ) {
        $error = 1;
    }

    @linesup = <FILEUP>;
    close(FILEUP);
    chomp(@linesup);

    @linesdn = <FILEDN>;
    close(FILEDN);
    chomp(@linesdn);

    print <<EOF;
function dodata_updn() { 
lntpp="solid";
lwup = parseFloat(document.getElementById("lwup").value);
lclrup= document.getElementById("lclrup").value;
lwdn = parseFloat(document.getElementById("lwdn").value);
lclrdn = document.getElementById("lclrdn").value;
efc= document.getElementById("efcc").value;
EOF
    $i = 0;
    for $line (@linesup) {
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );
        if (    @lin[0] eq "@"
            and @lin[1] eq "xaxis"
            and @lin[2] eq "ticklabel"
            and @lin[3] ne "char" )
        {
            @lin[4] =~ s/^.{1,2}//s;
            if ( @lin[4] eq "G" ) {
                push( @label, "\\u0393" );
            }
            else {
                push( @label, @lin[4] );
            }
        }

        if (    @lin[0] eq "@"
            and @lin[1] eq "xaxis"
            and @lin[2] eq "tick"
            and @lin[3] eq "major"
            and @lin[4] ne "grid" )
        {
            push( @posi, @lin[5] );
        }

        if ( @lin[0] eq "@" and @lin[1] eq "world" ) {
            chop( @lin[4] );
            $longeur = @lin[4];
        }

        if ( @lin[1] eq "bandindex:" and @lin[2] eq "1" ) {
            $index1 = $i;
        }

        if ( @lin[1] eq "bandindex:" and @lin[2] eq "2" ) {
            $index2 = $i;
        }

        $i++;
    }
    $index = $index2 - $index1 - 5;

    print "tkP=[";
    foreach (@posi) {
        print " $_,";
    }
    print "]\n";

    print "KL=[";
    foreach (@label) {
        print " \"$_\",";
    }
    print "]\n";

    $ii = 0;
    $t  = 0;
    for $line (@linesup) {
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );

        if ( @lin[1] eq "bandindex:" ) {
            if ( @lin[2] eq "1" ) {
                @emin = split( /\s+/, @linesup[ 1 + $ii ] );
                $Emin = @emin[1];
            }
            print "up\_data_bd_$t=[";
            for ( $j = 1 ; $j < $index ; $j++ ) {
                @li = split( /\s+/, @linesup[ $j + $ii ] );
                printf "[%.5f,  ", ( @li[0] ) . "  ";
                printf "%.5f],  ", ( @li[1] ) . "  ";
            }
            print "];\n";
            $t++;
        }
        $ii++;
    }
    $Emax = @li[1];

    $i = 0;
    for $line (@linesdn) {
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );
        if (    @lin[0] eq "@"
            and @lin[1] eq "xaxis"
            and @lin[2] eq "ticklabel"
            and @lin[3] ne "char" )
        {
            @lin[4] =~ s/^.{1,2}//s;
            if ( @lin[4] eq "G" ) {
                push( @label, "\\u0393" );
            }
            else {
                push( @label, @lin[4] );
            }
        }

        if (    @lin[0] eq "@"
            and @lin[1] eq "xaxis"
            and @lin[2] eq "tick"
            and @lin[3] eq "major"
            and @lin[4] ne "grid" )
        {
            push( @posi, @lin[5] );
        }

        if ( @lin[0] eq "@" and @lin[1] eq "world" ) {
            chop( @lin[4] );
            $longeur = @lin[4];
        }

        if ( @lin[1] eq "bandindex:" and @lin[2] eq "1" ) {
            $index1 = $i;
        }

        if ( @lin[1] eq "bandindex:" and @lin[2] eq "2" ) {
            $index2 = $i;
        }

        $i++;
    }
    $index = $index2 - $index1 - 5;

    $ii = 0;
    $t  = 0;
    for $line (@linesdn) {
        $line =~ s/^\s+//;
        @lin = split( /\s+/, $line );

        if ( @lin[1] eq "bandindex:" ) {
            print "dn\_data_bd_$t=[";
            for ( $j = 1 ; $j < $index ; $j++ ) {
                @li = split( /\s+/, @linesdn[ $j + $ii ] );
                printf "[%.5f,  ", ( @li[0] ) . "  ";
                printf "%.5f],  ", ( @li[1] ) . "  ";
            }
            print "];\n";
            $t++;
        }
        $ii++;
    }

    print "data1=[";
    for ( $k = 0 ; $k < $t ; $k++ ) {
        print
"{data : up\_data_bd_$k, id : 'Band_up $k', name : 'Band_up $k',showInLegend: false, linkedTo: 'up', color: ''+lclrup+'', dashStyle: '+lntpp+', lineWidth: ''+lwup+''},";
        print
"{data : dn\_data_bd_$k, id : 'Band_dn $k', name : 'Band_dn $k',showInLegend: false, linkedTo: 'dn', color: ''+lclrdn+'', dashStyle: '+lntpp+', lineWidth: ''+lwdn+''},";
    }
    print "];\n";
    print "}\n";
    print "</script> \n";
}

###

sub spijplot {
    print "<script> \n";
    print <<EOF;
function doplot(spin,inset){
W = \$('#resz').width();
H = \$('#resz').height();
Emin=parseFloat(document.getElementById('Emin').value) ;
Emax=parseFloat(document.getElementById('Emax').value) ;
fsize = parseInt(document.getElementById('fsize').value);
tsize = parseInt(document.getElementById('tsize').value);
if (inset=="no"){
container = "container";
NRJ="Energy(eV)"
}else if (inset=="yes") {
NRJ=""
chart=\$('#container').highcharts()
chart.setSize((W*2/3)-20, null)
Emin=parseFloat(document.getElementById('in_Emin').value) ;
Emax=parseFloat(document.getElementById('in_Emax').value) ;
fsize = parseInt(document.getElementById('in_fsize').value);
tsize = parseInt(document.getElementById('in_tsize').value);
container = "in_container";
W=W*1/3;
H=H*2/3;
} 

maxb = parseFloat(document.getElementById('maxb').value);
minb = parseFloat(document.getElementById('minb').value);
brks = parseFloat(document.getElementById('brks').value);
fsize = parseInt(document.getElementById('fsize').value);
tsize = parseInt(document.getElementById('tsize').value);
lntp = document.getElementById('lntp').value;

  var plotln = [];
  for (y=0; y<tkP.length; y++){
   plotln[y]={'color': 'black',
             'value':tkP[y],
             'width': 1 ,
             "id": 'pltl'+y,
             'label': {'text': KL[y],
                        'rotation': 0,
                        "textAlign": 'center',
                        'verticalAlign': 'bottom',
                        'x': -2, 'y': +25,
                        'style': {'color': 'black',
                                  'fontSize': fsize+'px',
                                  'fontFamily': 'Helvetica, Verdana, sans-serif'
                                  }
                        }
             }

  }

    Highcharts.wrap(Highcharts.Axis.prototype, 'getLinePath', function (proceed, lineWidth) {
        var axis = this,
            path = proceed.call(this, lineWidth),
            x = path[1];

        Highcharts.each(this.breakArray || [], function (brk) {
            var from;
            if (!axis.horiz) {
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

var chart =  \$('#'+container+'').highcharts({
         chart: {
            width: W,
            height: H-2,
            zoomType: 'xy',
            panning: true,
            panKey: 'shift',
            marginRight: 25,
            marginBottom: 25,
            plotBorderColor: 'black',
            plotBorderWidth: 1,
            backgroundColor: null
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
            pointFormat: 'E={point.y} eV'
            },
    xAxis: {
    plotLines: plotln,
    //tickPositions: tkP,
    gridLineWidth: '0',
    gridLineColor: '#000000',
    lineWidth: 1,
    minPadding: 0,
    maxPadding: 0,
    startOnTick: false,
    endOnTick: false,
    lineColor: '#000',
    tickWidth: 0,
    tickColor: '#000000',
    labels: {
	     style: {
                    color: '#fff',
                    fontSize: '0px',
                    font: 'Helvetica, Verdana, sans-serif'
                     }
            },
   },
    yAxis: {
    max:Emax,
    min:Emin,
    plotLines: [{
                value: 0.02,
                color: ''+efc+'',
                dashStyle: lntp,
                width: 2,
                label: {
                    style: {
                    fontSize: '14px',
                    font: 'Helvetica, Verdana, sans-serif',
		    color: ''+efc+'',
                    },
		    useHTML: true,
                    align: 'right',
                    y: 0,
                    x: 20,
		    text: 'E<sub>F</sub>'
                }
                }
		],
    //breaks: brk[0],
      breaks: [{
                    from: minb,
                    to:	maxb,
		    breakSize: brks,
		}],
    minorGridLineWidth: 0,
    minorgridLineDashStyle: 'longdash',
    gridLineWidth: 0,
    lineColor: '#000000',
    lineWidth: 1,
    tickWidth: 1,
    tickColor: '#000000',
    labels: {
         style: {
            color: '#000000',
            fontSize:fsize+'px',
            font: 'Helvetica, Verdana, sans-serif'
         }
      },
    title: {
        enabled: true,
        text: NRJ,
         style: {
            color: '#000000',
            fontWeight: 'bold',
            fontSize: tsize+'px',
            fontFamily: 'Helvetica, Verdana, sans-serif'
         }
      },
   minorTickColor: '#000000',
   minorTickLength: 5,
   minorTickInterval: 'auto',
   minorTickWidth: 1,
   },
    plotOptions: {
    line: {

           marker: {
                    enabled: false
                   }
           }
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
            symbolWidth: 60,
            //shadow: true,
            draggable: true,
            zIndex: 20,          
            useHTML:true            
        },
    series : data1,
   navigation: {
                buttonOptions: {
                                enabled: false
                                }
               },
   })


if (inset=="yes") {
bandshow=\$('#showband').val()
	    var chart0 =  \$('#container').highcharts()
	    var chart1 =  \$('#in_container').highcharts()
	    emin=chart1.yAxis[0].min
	    emax=chart1.yAxis[0].max

	    if (bandshow==1) {
	    var chart0 =  \$('#container').highcharts()
	    chart0.yAxis[0].addPlotBand({
                from: emin,
                to: emax,
                color: 'rgba(243,233,169,0.52)',
            })
	    var chart1 =  \$('#in_container').highcharts()
	    chart1.yAxis[0].addPlotBand({
                from: emin,
                to: emax,
                color: 'rgba(243,233,169,0.52)',
            })
	    };
}

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
chart = \$('#container').highcharts(),
qual=parseFloat(\$( "#quality" ).val())
height = chart.chartHeight * qual;
width = chart.chartWidth * qual;
canvas = document.createElement("canvas");
canvas.width = width; canvas.height = height;
var svg = chart.getSVG({
        exporting: {
            sourceHeight: chart.chartHeight,
            sourceWidth: chart.chartWidth,
        }
    });
canvg(canvas, svg, {ignoreDimensions: true, scaleWidth: canvas.width, scaleHeight: canvas.height});
var isChrome = window.chrome;
if(isChrome) {
bandpng = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
saveAs(bandpng, "band.png");
}else{
canvas.toBlob(function(blob) {
saveAs(blob, "band.png", 'image/png');
});
}
}
}
}	
})

})

\$("#svg").empty()
\$('<button type="button" class="btn btn-success">SVG</button>').appendTo(svg).click(function (e) {
var chart=\$('#container').highcharts()
var svg = chart.getSVG({
        exporting: {
            sourceHeight: chart.chartHeight,
            sourceWidth: chart.chartWidth,
        }
    });
saveAs(new Blob([svg], {type:"application/svg+xml"}), "band.svg")
})

}


\$(document).ready(function () {
EOF
    if ( $error == 1 ) {
        print <<EOF;

    bootbox.alert({
        message: "Can't read file $CASE.bands(up/dn).agr, please check your calculations !",
        size: 'small',
		});
EOF
    }
    print <<EOF;
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



\$('#inset').val("no")
dodata_$spin();
doplot("$spin", "no");
\$('#addinset').click(function (e) {
bootbox.hideAll()
                                     bootbox.dialog({
                                     title: '',
                                     message:'<table><tr><td>This can take  a few seconds !</td></tr><tr><td><div id="fountainG">'+
    '<div id="fountainG_1" class="fountainG"></div>'+
    '<div id="fountainG_2" class="fountainG"></div>'+
    '<div id="fountainG_3" class="fountainG"></div>'+
    '<div id="fountainG_4" class="fountainG"></div>'+
    '<div id="fountainG_5" class="fountainG"></div>'+
    '<div id="fountainG_6" class="fountainG"></div>'+
    '<div id="fountainG_7" class="fountainG"></div>'+
    '<div id="fountainG_8" class="fountainG"></div>'+
'</div></td></tr></table>'
				     })
\$("#inset").val("yes")
\$("#in_container").remove
left = (\$('#resz').width()*2/3)-20;
topp = \$('#resz').height(); topp=topp-topp*1/6;

\$("#container").append('<div id="in_container" style="position:relative;left:'+left+';top:-'+topp+'"></div></b>');
myEvent = function(){
dodata_$spin();doplot('$spin', 'yes');
\$('#myModal').modal('toggle');

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
chart=\$('#container').highcharts()
in_chart = \$('#in_container').highcharts(),

W1=chart.chartWidth
H1=chart.chartHeight
W2=in_chart.chartWidth
H2=in_chart.chartHeight

svgArr = [];

svg = chart.getSVG({
        exporting: {
            sourceHeight: H1,
            sourceWidth: W1,
        }
    });
svg = svg.replace('<svg', '<g transform="translate(0,0)"');
svg = svg.replace('</svg>', '</g>');
svgArr.push(svg);    

in_svg = in_chart.getSVG({
        exporting: {
            sourceHeight: H2,
            sourceWidth: W2,
        }
    });
    
left = W1+20;
topp = H1*1/6;
    
in_svg = in_svg.replace('<svg', '<g transform="translate(' + left + ',' + topp + ')"');
in_svg = in_svg.replace('</svg>', '</g>');
svgArr.push(in_svg);         
tW=W1+W2+20;
svg= '<svg height="'+ H1 +'" width="' + tW + '" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>';
height = H1 * qual;
width = tW * qual;
canvas = document.createElement("canvas");
canvas.width = width; canvas.height = height;
canvg(canvas, svg, {ignoreDimensions: true, scaleWidth: canvas.width, scaleHeight: canvas.height});
var isChrome = window.chrome;
if(isChrome) {
bandpng = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream");
saveAs(bandpng, "band.png");
}else{
canvas.toBlob(function(blob) {
saveAs(blob, "band.png", 'image/png');
});
}
}
}
}	
})
})

\$("#svg").empty()
\$('<button type="button" class="btn btn-success">SVG</button>').appendTo(svg).click(function (e) {

chart=\$('#container').highcharts()
in_chart = \$('#in_container').highcharts(),

W1=chart.chartWidth
H1=chart.chartHeight
W2=in_chart.chartWidth
H2=in_chart.chartHeight

svgArr = [];

svg = chart.getSVG({
        exporting: {
            sourceHeight: H1,
            sourceWidth: W1,
        }
    });
svg = svg.replace('<svg', '<g transform="translate(0,0)"');
svg = svg.replace('</svg>', '</g>');
svgArr.push(svg);    

in_svg = in_chart.getSVG({
        exporting: {
            sourceHeight: H2,
            sourceWidth: W2,
        }
    });
    
left = W1+20;
topp = H1*1/6;
    
in_svg = in_svg.replace('<svg', '<g transform="translate(' + left + ',' + topp + ')"');
in_svg = in_svg.replace('</svg>', '</g>');
svgArr.push(in_svg);         
tW=W1+W2+20;
svg= '<svg height="'+ H1 +'" width="' + tW + '" version="1.1" xmlns="http://www.w3.org/2000/svg">' + svgArr.join('') + '</svg>';
saveAs(new Blob([svg], {type:"application/svg+xml"}), "band.svg")
})
}

\$.when( myEvent() ).done( function() {bootbox.hideAll()})

})



})
</script>
EOF
}

sub rest {
    print <<EOF;
<script>
    \$( function() {
        \$( "#slider-range-max" ).slider({
              range: "max",
                    min: 1,
                    max: 6,
                    value: 2,
                    slide: function( event, ui ) {
                    \$( "#amount" ).val( ui.value );
                    }
                    });
                    \$( "#amount" ).val( \$( "#slider-range-max" ).slider( "value" ) );
                    } );
</script>
<div class="row" style="padding:10px;height:90%; width:99%">
    <div class="col-lg-9" style="height:100%">
	<div class="panel panel-default" style="border-color: #E0E0E0; color: #000; box-shadow: 5px 5px 3px #888888">

         <div class="panel-heading" style="border-color: #E0E0E0; color: #000; background-color: #EFE883">
	    <div class="row">
			    <div class="col-lg-3">
			    <table><tr>
			    <td><h4>Band Structure $spin</h4></td><td>&nbsp</td>
			    <td>
			    <a href="#" data-toggle="tooltip" title="About JPlot">
			    <img src="images/about.png" class="sba img-responsive" alt="Cinque Terre" width="20" height="20"></td>
			    </a>
			    </tr></table>
			    </div>
			    <div class="col-lg-3">
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
	    <div id="resz"  style="border: 1px solid rgb(92, 184, 92); width: 100%; height: 100%; position: relative;">
		<div id="container" class="tab-pane fade active in" style="display:;"></div>
	    </div>
	</div>

<script>

function rez(){
inset=\$('#inset').val()
W = \$('#resz').width();
H = \$('#resz').height();
var chart=\$('#container').highcharts()
if (inset=="no"){
chart.setSize(W, H)
}else{
chart.setSize((W*2/3)-20,H)
chart2=\$('#in_container').highcharts()
left=W*2/3;
topp=-(H-H*1/6);
\$("#in_container").css({'top': topp ,'left': left});
chart2.setSize((W*1/3),(H*2/3))
}
}

 \$('#resz').resizable({
    containment: ".panel-body",
    stop: function (event, ui) {
                                     bootbox.dialog({
                                     title: '',
                                     message:'<table><tr><td>This can take  a few seconds !</td></tr><tr><td><div id="fountainG">'+
    '<div id="fountainG_1" class="fountainG"></div>'+
    '<div id="fountainG_2" class="fountainG"></div>'+
    '<div id="fountainG_3" class="fountainG"></div>'+
    '<div id="fountainG_4" class="fountainG"></div>'+
    '<div id="fountainG_5" class="fountainG"></div>'+
    '<div id="fountainG_6" class="fountainG"></div>'+
    '<div id="fountainG_7" class="fountainG"></div>'+
    '<div id="fountainG_8" class="fountainG"></div>'+
'</div></td></tr></table>'

				     })
myEvent = function(){rez()}
    \$.when( myEvent() ).done( function() {bootbox.hideAll()})
    }
  })
</script>
			    <div style="display: none;" class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4 class="modal-title" id="myModalLabel">Add an Inset</h4> 
                                        </div>
                                        <div class="modal-body">
		<div class="panel-body">
                            <!-- Nav tabs -->
                            <ul class="nav nav-pills">
                                <li class="active"><a aria-expanded="true" href="#in_energie" data-toggle="tab">Energies</a>
                                </li>
                                <li class=""><a aria-expanded="false" href="#in_font" data-toggle="tab">Font</a>
                                </li>
                            </ul>
                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div class="tab-pane fade active in" id="in_energie">
		    <br>
		    <div class="form-group input-group">
                                            <span class="input-group-addon">Emin(eV)</span>
		        <input class="form-control" id="in_Emin" value="$Emin" type="text">
                        	    </div>

		    <div class="form-group input-group">
                                            <span class="input-group-addon">Emax(eV)</span>
		        <input class="form-control" id="in_Emax" value="$Emax" type="text">
                        	    </div>

		    </div><br>
                                <div class="tab-pane fade" id="in_font">
		    <div class="form-group input-group">
                                            <span class="input-group-addon">Label Font Size</span>
		        <input class="form-control" id="in_fsize" value="12" type="text">
                        	    </div>
		    <div class="form-group input-group">
                                            <span class="input-group-addon">Title Font Size</span>
		        <input class="form-control" id="in_tsize" value="14" type="text">
                        	    </div>
                                </div>
                            </div>
        	</div>
    <div class="row">
        <div class="col-sm-4">Color the inset zone ?</div>
        <div class="col-sm-8">
            <div class="btn-group" data-toggle="buttons">
                <label class="btn  btn-default active" onclick="\$('#showband').val(0)">
                    <input type="radio" " /> No
                </label> 
                <label class="btn  btn-default"  onclick="\$('#showband').val(1)">
                    <input type="radio"  /> Yes
                </label>              
            </div>
        </div>
    <input id="showband" value="0" type="hidden">
    </div>
		</div>
                                        <div class="modal-footer">

This can take  a few seconds ! &nbsp
					    <button class="btn  btn-success" data-toggle="modal" id="addinset">Add</button>
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
	</div>
</div>
    <div id="plotctrl" class="col-lg-3" style="display:; ">
      <div class="panel panel-default" style="border-color: #E0E0E0; box-shadow: 5px 5px 3px #888888">
	    <div class="panel-heading" style="border-color: #E0E0E0; color: #000; background-color: #EFE883">Plot control</div>
                        <div class="panel-body">
                            <!-- Nav tabs -->
                            <ul class="nav nav-pills">
                                <li class="active"><a aria-expanded="true" href="#energie" data-toggle="tab">Energies</a>
                                </li>
                                <li class=""><a aria-expanded="false" href="#font" data-toggle="tab">Font</a>
                                </li>
                                <li class=""><a aria-expanded="false" href="#line" data-toggle="tab">Lines</a>
                                </li>
                            </ul>
                            <!-- Tab panes -->
                            <div class="tab-content">
                                <div class="tab-pane fade active in" id="energie">
				    <br>
				    <div class="form-group input-group">
                                            <span class="input-group-addon">Emin(eV)</span>
					    <input class="form-control" type="text"  id="Emin"   value="$Emin">
                            	    </div>

				    <div class="form-group input-group">
                                            <span class="input-group-addon">Emax(eV)</span>
					    <input class="form-control" type="text" id="Emax"   value="$Emax">
                            	    </div>

				    <div class="form-group input-group">
                                            <span class="input-group-addon">Break min(eV)</span>
					    <input class="form-control" type="text"  id="minb"   value="">
                            	    </div>

				    <div class="form-group input-group">
                                            <span class="input-group-addon">Break max(eV)</span>
					    <input class="form-control" type="text" id="maxb"  value="">
                            	    </div>

				    <div class="form-group input-group">
                                            <span class="input-group-addon">Break Size(eV)</span>
					    <input class="form-control" type="text" id="brks"  value="">
                            	    </div>
 				</div><br>
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
EOF

    if ( $spin eq "updn" ) {
        print <<EOF;
                                <div class="tab-pane fade" id="line">
				<div class="input-group cclrup">
			        <span class="input-group-addon">Line Color Up</span>
				<input id="lclrup" type="text" value="#000000" class="form-control" />
				<span class="input-group-addon"><i></i></span>
				</div>
<script>
    \$(function(){
        \$('.cclrup').colorpicker();
    });
</script>
			        <div  class="input-group">
			        <span class="input-group-addon">Line width Up</span>
        		        <input id="lwup" value="0.5" min="1" max="10" type="text" class="form-control">
				</div>
<br>
				<div class="input-group cclrdn">
			        <span class="input-group-addon">Line Color Dn</span>
				<input id="lclrdn" type="text" value="#16cd21" class="form-control" />
				<span class="input-group-addon"><i></i></span>
				</div>
<script>
    \$(function(){
        \$('.cclrdn').colorpicker();
    });
</script>
			        <div  class="input-group">
			        <span class="input-group-addon">Line width Dn</span>
        		        <input id="lwdn" value="0.5" min="1" max="10" type="text" class="form-control">
				</div>

EOF
    }
    else {
        print <<EOF;
                                <div class="tab-pane fade" id="line">
				<div class="input-group cclr">
			        <span class="input-group-addon">Line Color</span>
				<input id="lclr" type="text" value="#000000" class="form-control" />
				<span class="input-group-addon"><i></i></span>
				</div>
<script>
    \$(function(){
        \$('.cclr').colorpicker();
    });
</script><br>
			        <div  class="input-group">
			        <span class="input-group-addon">Line width</span>
        		        <input id="lw" value="0.5" min="1" max="10" type="text" class="form-control">
				</div>
EOF
    }

    print <<EOF;
				<hr>
				<div class="input-group efc">
			        <span class="input-group-addon">E<sub>F</sub></span>
				<input id="efcc" type="text" value="#ff000c" class="form-control" />
				<span class="input-group-addon"><i></i></span>
<script>
    \$(function(){
        \$('.efc').colorpicker();
    });
</script>
				<select class="form-control" id="lntp">
			        <option>Solid</option>
    				<option selected>ShortDash</option>
    				<option>ShortDot</option>
    				<option>ShortDashDot</option>
    				<option>ShortDashDotDot</option>
			        <option>Dot</option>
			        <option>Dash</option>
			        <option>LongDash</option>
			        <option>DashDot</option>
			        <option>LongDashDot</option>
			        <option>LongDashDotDot</option>
				</select>
                              </div><br>
				</div>
                            </div>
			    <button type="button" class="btn btn-success" onclick="dodata_$spin();doplot('$spin', 'no');if(\$('#inset').val()=='yes'){\$('#addinset').click ();\$('#myModal').modal('hide')}">Plot</button>
			    <button class="btn  btn-success" data-toggle="modal" data-target="#myModal">Add an inset </button><br><br>
            </div>
        </div> 
    </div>
</div>

<input type="hidden" id="inset" value="no"></input>
</body></html>\n
EOF
}

