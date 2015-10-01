<?php
echo $this->Html->script('./amcharts/amcharts.js', array('block' => 'scriptInView'));
echo $this->Html->script('./amcharts/serial.js', array('block' => 'scriptInView'));
echo $this->Html->script('./amcharts/pie.js', array('block' => 'scriptInView'));
echo $this->Html->script('./amcharts/exporting/filesaver.js', array('block' => 'scriptInView'));
echo $this->Html->script('./amcharts/exporting/amexport.js', array('block' => 'scriptInView'));
echo $this->Html->script('./amcharts/exporting/canvg.js', array('block' => 'scriptInView'));
echo $this->Html->script('./amcharts/exporting/rgbcolor.js', array('block' => 'scriptInView'));
echo $this->Html->script('markyChart.js', array('block' => 'scriptInView'));
echo $this->Html->link(__('Return'), $redirect, array('id' => 'comeBack'));
?>
<div class="statistics view">
    <h2>There are the statistics  of annotation for <?php echo h($userName) ?> in project: <?php echo h($projectName) ?></h2>
    <input type="hidden" value='<?php echo json_encode($totalTypeData) ?>' id="statisticsData">
    <div id="chartdiv" class="chart"></div>

    <p class="bold">
        Total number of annotations: <?php echo $totalAnnotations ?>
    </p>

</div>
<a href="<?php echo $this->webroot . 'js/amcharts/images/' ?>" class="hidden" id="chartImages">chartImages</a>
