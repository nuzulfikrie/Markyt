/*Este javascript se usa para mostrar las graficas y el dialog de carga de 
 los submits
 */
var pathImages = null;
var exportMenu={};
        
$(document).ready(function() {
    pathImages = $('#chartImages').attr('href');
    exportMenu={
        menuTop: "40px",
        menuRight: "80px",
        paddingTop: '6px',
        paddingRight: '6px',
        paddingBottom: '6px',
        paddingLeft: '6px',
        menuItems: [{
                textAlign: 'center',
                onclick: function() {
                },
                icon: pathImages + 'export.png',
                iconTitle: 'Save chart as an image',
                items: [{
                        title: 'JPG',
                        format: 'jpg'
                    }, {
                        title: 'PNG',
                        format: 'png'
                    }, {
                        title: 'SVG',
                        format: 'svg'
                    }]
            }],
        menuItemStyle: {
            width: '40px',
            paddingTop: '6px',
            paddingRight: '6px',
            paddingBottom: '6px',
            paddingLeft: '6px',
            backgroundColor: 'EFEFEF',
            rollOverBackgroundColor: '#DDDDDD'
        }};
    $('#downloadButton').click(function()
    {
        window.location.href = $('#downloadLink').attr('href');
    });
    var fullScreen = false;
    $('#fullScreenButton').click(function() {
        if (!fullScreen) {
            $("#tableResults").addClass('fullscreen');
            $('#header').addClass('hidden');
            $('#footer').addClass('hidden');
            $('.forHidden').addClass('hidden');
            window.scrollTo(0, 0);
            fullScreen = true;

        }
        else {
            $("#tableResults").removeClass('fullscreen');
            $('#header').removeClass('hidden');
            $('#footer').removeClass('hidden');
            $('.forHidden').removeClass('hidden');
            fullScreen = false;
        }
    });


    $(document).keyup(function(e) {

        if (e.keyCode === 27 && fullScreen) {
            $("#tableResults").removeClass('fullscreen');
            $('#header').removeClass('hidden');
            $('#footer').removeClass('hidden');
            $('.forHidden').removeClass('hidden');
            fullScreen = false;
        }   // esc
    });


    if ($('#graficArrayNames').length === 1) {
        var names = $('#graficArrayNames').attr('value');
        names = JSON.parse(names);
        var values = $('#graficArray').attr('value');
        values = JSON.parse(values);
        var axisName = $('#graficArrayNames').attr('name');
        charts(values, axisName, "Hits", "chartdiv");
    }

    if ($('#NFnames').length === 1) {
        var hasData=false;
        names = $('#NFnames').attr('value');
        names = JSON.parse(names);
        values = $('#noneArrayFiles').attr('value');
        values = JSON.parse(values);
        title = $('#NFnames').attr('name');
        hasData=pie3D(values, title, "noneHits", "chartdiv2");
        

        names = $('#NCnames').attr('value');
        names = JSON.parse(names);
        values = $('#noneArrayCols').attr('value');
        values = JSON.parse(values);
        title = $('#NCnames').attr('name');
        hasData= hasData === pie3D(values, title, "noneHits", "chartdiv3");
        
        if(!hasData)
        {
            $('.noneHits').hide();
        }
    }

    if ($('#statisticsData').length === 1) {

        values = $('#statisticsData').attr('value');
        values = JSON.parse(values);
        title = '% of annotations by type';
        pie3D(values, title, "value", "chartdiv");

    }

    if ($('#graficArrayFscore').length === 1) {

        values = $('#graficArrayFscore').attr('value');
        values = JSON.parse(values);
        names = $('#graficArrayFscoreNames').attr('value');
        names = JSON.parse(names);

        aux = Array();
        for (var key in values) {
            values[key]['Type'] = key;
            aux.push(values[key]);
        }
        column3D(aux, names);

    }
    
    
    $('.statisticsUser').each(function (){
        var values=$(this).find('.userData').val();
        var id=$(this).find('.chart').attr('id');
        values = JSON.parse(values);
        var title = '';
        pie3D(values, title, "value", id);  

    });
});





function zoomChart() {
    // different zoom methods can be used - zoomToIndexes, zoomToDates, zoomToCategoryValues
    chart.zoomToIndexes(10, 20);
}



function charts(values, axisName, strValueField, chartId)
{
    var chart;
    var chartData = [];
    var tam = values.length;
    if (tam > 0) {
        for (i = 0; i < tam; i++) {
            chartData.push(values[i]);
        }

        // SERIAL CHART    
        chart = new AmCharts.AmSerialChart();
        chart.pathToImages = pathImages;
        chart.dataProvider = chartData;
        chart.categoryField = "GraficColumns";
        // this single line makes the chart a bar chart, 
        // try to set it to false - your bars will turn to columns                
        chart.rotate = true;
        chart.exportConfig = exportMenu;

        // the following two lines makes chart 3D
        //chart.depth3D = 20;
        //chart.angle = 30;


        chart.zoomOutButton = {
            backgroundColor: '#000000',
            backgroundAlpha: 0.15
        };
        // CURSOR
        var chartCursor = new AmCharts.ChartCursor();
        chartCursor.cursorPosition = "mouse";
        chart.addChartCursor(chartCursor);

        // SCROLLBAR
        var chartScrollbar = new AmCharts.ChartScrollbar();
        chart.addChartScrollbar(chartScrollbar);


        var categoryAxis = chart.categoryAxis;
        categoryAxis.labelRotation = 90;
        categoryAxis.dashLength = 5;
        categoryAxis.gridPosition = "start";
        categoryAxis.axisColor = "#DADADA";
        categoryAxis.title = axisName + 's';


        // value
        var valueAxis = new AmCharts.ValueAxis();
        valueAxis.title = strValueField;
        valueAxis.dashLength = 5;
        chart.addValueAxis(valueAxis);



        // GRAPHS
        var graph1 = new AmCharts.AmGraph();
        graph1.valueField = strValueField;
        graph1.type = "column";
        graph1.colorField = "Colour";
        graph1.lineAlpha = 0;
        graph1.fillAlphas = 1;
        chart.addGraph(graph1);


        // WRITE
        chart.write(chartId);
    }
    else
    {
        $('#' + chartId).hide();
    }


}



function pie3D(values, title, strValueField, chartId) {
    var chart;
    var chartData = [];
    var tam = values.length;    
    if (tam > 0) {
        for (i = 0; i < tam; i++) {
            chartData.push(values[i]);
        }

        // SERIAL CHART    
        chart = new AmCharts.AmPieChart();
        chart.pathToImages = pathImages;
        chart.dataProvider = chartData;
        // this single line makes the chart a bar chart, 
        // try to set it to false - your bars will turn to columns                
        chart.rotate = true;
        chart.addTitle(title, 16);
        chart.dataProvider = chartData;
        chart.titleField = "GraficColumns";
        chart.valueField = strValueField;
        chart.colorField = "Colour";
        chart.outlineAlpha = 0.8;
        chart.outlineThickness = 2;
        chart.radius = 80;
        chart.labelText = "[[percents]]%";
        chart.exportConfig = exportMenu;
        // LEGEND
        legend = new AmCharts.AmLegend();
        legend.align = "center";
        legend.markerType = "circle";
        chart.addLegend(legend);



        // this makes the chart 3D
        //chart.depth3D = 15;
        //chart.angle = 30;
        chart.write(chartId);
        return true;
    }
    else
    {   
        $('#' + chartId).hide();
        return false;
    }
}


function column3D(chartData, names) {
    chart = new AmCharts.AmSerialChart();
    chart.pathToImages = pathImages;
    chart.dataProvider = chartData;
    chart.categoryField = "Type";
    chart.color = "#000000";
    chart.fontSize = 14;
    chart.startDuration = 1;
    chart.clustered = true;
    chart.columnSpacing = 8;
    chart.plotAreaFillAlphas = 0.2;
    exportMenu.menuRight= "40px",
    chart.exportConfig = exportMenu;



    // the following two lines makes chart 3D
//    chart.angle = 30;
//    chart.depth3D = 60;

    // LEGEND
    legend = new AmCharts.AmLegend();
    legend.align = "center";
    legend.markerType = "circle";
    chart.addLegend(legend);

    // category
    var categoryAxis = chart.categoryAxis;
    categoryAxis.gridAlpha = 0.2;
    categoryAxis.gridPosition = "start";
    categoryAxis.gridColor = "#000000";
    categoryAxis.axisColor = "#000000";
    categoryAxis.axisAlpha = 0.5;
    categoryAxis.dashLength = 5;

    // value
    var valueAxis = new AmCharts.ValueAxis();
    valueAxis.stackType = "3d"; // This line makes chart 3D stacked (columns are placed one behind another)
    valueAxis.gridAlpha = 0.2;
    valueAxis.gridColor = "#000000";
    valueAxis.axisColor = "#000000";
    valueAxis.axisAlpha = 0.5;
    valueAxis.dashLength = 5;
    valueAxis.title = "F-Score";
    valueAxis.titleColor = "#000000";
    valueAxis.unit = "%";
    chart.addValueAxis(valueAxis);

    // GRAPHS         
    // first graph

    for (var key in names) {
        var graph1 = new AmCharts.AmGraph();
        graph1.title = names[key].toUpperCase();
        graph1.valueField = key;
        graph1.type = "column";
        graph1.lineAlpha = 0;
        graph1.lineColor = ramdomHexColor();
        graph1.fillAlphas = 0.5;
        graph1.balloonText = "F-Score in [[category]] (" + names[key].toUpperCase() + ") [[value]]";

        chart.addGraph(graph1);
    }
    chart.zoomOutButton = {
        backgroundColor: '#000000',
        backgroundAlpha: 0.15
    };

    // CURSOR
    var chartCursor = new AmCharts.ChartCursor();
    chartCursor.cursorPosition = "mouse";
    chart.addChartCursor(chartCursor);

    // SCROLLBAR
    var chartScrollbar = new AmCharts.ChartScrollbar();
    chart.addChartScrollbar(chartScrollbar);

    chart.write("chartdiv");

}

function ramdomHexColor()
{
    var cont = 0;
    var color = "#000000";
    while (color === '#000000')
    {
        cont++;
        color = '#' + Math.floor(Math.random() * 16777215).toString(16);
        if (cont === 5 || color.length !== 7)
        {
            color = "#006DAA";
        }
    }
    return color;

}